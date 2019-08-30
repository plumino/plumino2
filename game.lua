game = {}
game.state = nil
game.stateName = nil
game.states = {}

game.mode = {}

function game:loadMode(name, rotation)
    if not modes[name] then
        error("Mode "..name.." does not exist! This should never ever happen!")
    end
    if not rotations[rotation] then
        error("Rotation "..rotation.." does not exist! This should never ever happen!")
    end
    self.mode = modes[name]
    self:init(rotation, {})
    self.mode:init()
end

game.playfieldDimensions = {x=10, y=20}

game.keyMap = {
    up = "up",
    down = "down",
    left = "left",
    right = "right",
    a = "a",
    b = "s",
    c = "d",
    d = "space",
    start = "return"
}

game.prettyKeys = {
    rshift = "Right SHIFT",
    lshift = "Left SHIFT",
    lctrl = "Left CONTROL",
    rctrl = "Right CONTROL",
    lgui = "Left WINDOWS",
    rgui = "Right WINDOWS"
}

game.prettyKeys["return"] = "ENTER"

function game:prettyKey(a)
    if self.prettyKeys[a] then
        return self.prettyKeys[a]
    else
        return string.upper(a)
    end
end

game.keys = {
    up = false,
    down = false,
    left = false,
    right = false,
    a = false,
    b = false,
    c = false,
    d = false,
    start = false,
    debug = false
}

game.keysInactive = deepcopy(game.keys)

game.lastKeys = deepcopy(game.keys)

game.justPressed = deepcopy(game.keys)

game.currentBackground = 1

function game:init(rotation, options)
    self.timer = 0
    self.willTrackTime = false
    self.timeStart = 0

    self.rotsys = rotation

    self.random = randomiser[self.mode.preferredRandom] or randomiser[rotations[rotation].preferredRandom] or "TGM"

    if self.random.init then
        self.random:init()
    end

    self.speeds = {
        gravity = 1/64, -- 1/64th of a G
        das = 8,
        lockDelay = 30,
        are = 10,
        lineAre = 20
    }

    self.invisible = false

    self.invisrows = options.invisrows or 4

    self.matrix = {}
    for y=1,20+self.invisrows,1 do
        self.matrix[y] = {}
        for x=1,10,1 do
            self.matrix[y][x] = false
        end
    end

    self.blankmatrix = deepcopy(self.matrix)
    self.movereset = false

    self.rendermatrix = {} -- used for rendering blocks
    for y=1,20+self.invisrows,1 do
        self.rendermatrix[y] = {}
        for x=1,10,1 do
            self.rendermatrix[y][x] = false
        end
    end

    self.xOffset = {}
    for x=1,#self.matrix[1],1 do
        self.xOffset[x] = 0
    end

    self.yOffset = {}
    for x=1,#self.matrix[1],1 do
        self.yOffset[x] = 0
    end

    self.piecex=0
    self.piecey=0

    self.won = false
    self.sections = {}

    self.piece = nil
    self.nextQueue = {}
    for i=1,6 do
        table.insert(self.nextQueue, self.random:next())
    end

    self.drawNextQueue = 3
    self.drawGhost = true

    self.lockdelay = self.speeds.lockDelay
    self.are = 0
    self.das = 0

    self.gameOver = false

    self.holdEnabled = true

    self.gravitycounter = 0
    self.isSoftDropping = false

    self.upLock = false

    self.stats = {}

    self.stats.score = 0
    self.stats.level = 0
    self.stats.targetlevel = 100
    self.stats.endlevel = options.endlevel or 999
    self.stats.lines = 0
    self.stats.pieces = 0
    self.stats.pieceLocks = 0

    self:next(true)
    self.hasRanInit = true
end

function game:update()
    if self.gameOver and self.willTrackTime then
        self.willTrackTime = false
        if self.currentbgm ~= nil then
            self.currentbgm:stop()
        end
    end

    if self.invisible and self.gameOver then
        self.invisible = false
    end

    if self.willTrackTime then
        if not self.pausetimer then
            self.timer = love.timer.getTime()
        end

        self:doARE()
        self:doRotation()
        self:doDAS()
        self:doGravity()
        self:doLockDelay()
    end

    if not self.keys.up and self.upLock then
        self.upLock = false
    end

    if rotations[self.rotsys].update then
        rotations[self.rotsys]:update()
    end

    if self.mode.update then
        self.mode:update()
    end
end

--[[ INPUT HANDLING ]]--

function game:keyDown(key, sc, rep)
    local y = nil
    for i, j in pairs(self.keyMap) do
        if key == j then
            y = i
        end
    end
    if not y then return end -- unrecognised key
    if self.keys[y] ~= nil then
        self.keys[y] = true
    end
end

function game:keyUp(key, sc)
    local y = nil
    for i, j in pairs(self.keyMap) do
        if key == j then
            y = i
        end
    end
    if not y then return end -- unrecognised key
    if self.keys[y] ~= nil then
        self.keys[y] = false
    end
end

function game:checkJustPressed()
    self.justPressed = deepcopy(self.keysInactive)
    for i, j in pairs(self.keys) do
        if self.keys[i] ~= nil then
            if self.keys[i] and not self.lastKeys[i] then
                self.justPressed[i] = true
            end
            if self.lastKeys[i] and self.keys[i] then
                self.justPressed[i] = false
            end
        end
    end
    self.lastKeys = deepcopy(self.keys)
end

--[[ GENERAL GAME STUFF ]]--

function game:buildPiece(pc)
    local t = {}
    t.active = true
    t.type = self:getPiece(pc)
    t.colour = rotations[self.rotsys].colours[pc]
    t.name = pc
    t.state = 1
    return t
end

function game:getPiece(name)
    if rotations[self.rotsys].getPieceStructure then
        return rotations[self.rotsys]:getPieceStructure(name)
    else
        return rotations[self.rotsys].structure[name]
    end
end

function game:doARE()
    if self.are > 0 then
        self.are = self.are - 1
    end
    if self.are < 1 and not self.piece.active then
        self:next()
    end
end

function game:doDAS()
    if self.keys.left then
        if self.das > 1 then
            self.das = 0
        end
        self.das = self.das - 1
    elseif self.keys.right then
        if self.das < 0 then
            self.das = 0
        end
        self.das = self.das + 1
    else
        self.das = 0
    end

    if self.are == 0 then
        if self.das < self.speeds.das * -1 then
            self:movePiece(-1, 0)
        elseif self.das > self.speeds.das then
            self:movePiece(1, 0)
        end
    end
end

function game:movePiece(x, y)
    if not self:isColliding(nil, self.piecex+x, self.piecey+y) then
        self.piecex = self.piecex + x
        self.piecey = self.piecey + y
    end
end

function game:next(dontRotate)
    if self.are > 0 then return end

    self.piece = self:buildPiece(table.remove(self.nextQueue, 1))
    table.insert(self.nextQueue, self.random:next())
    print(inspect(self.nextQueue))

    local n = self.piece.name

    self.piecex, self.piecey = rotations[self.rotsys]:getSpawnLocation()

    if not dontRotate then
        self:doRotation(self.keys.b, self.keys.a or self.keys.c, true)
    end
    self:movePiece(0, -1)

    for y = 1, #self.piece.type[self.piece.state], 1 do
        for x = 1, #self.piece.type[self.piece.state], 1 do
            if (self.matrix[self.piecey+y] or {false, false, false, false})[self.piecex+x] ~= false and self.piece.type[self.piece.state][y][x] == 1 then
                self.gameOver = true
                return
            end
        end
    end

    self.piece.active = true
    self.stats.pieces = self.stats.pieces + 1
end

function game:doRotation(b1, b2, isARE)
    if self.are > 0 and not isARE then return end
    local brot = self.piece.type[self.piece.state+1] or self.piece.type[1]
    local arot = self.piece.type[self.piece.state-1] or self.piece.type[#self.piece.type]
    local px = self.piecex
    local py = self.piecey
    local state = self.piece.state
    local hasRotated = false
    if b1 or self.justPressed.b then
        if self:isColliding(brot) or rotations[self.rotsys].alwayswallkick then
            local failed, modx, mody = rotations[self.rotsys]:wallkick(brot, self.piece.state, self.piece.state+1)
            if failed then return end
            px = px + modx
            py = py + mody
        end
        state = state + 1
        if not self.piece.type[state] then state = 1 end
        hasRotated = true
    end
    if b2 or (self.justPressed.a or self.justPressed.c) then
        if self:isColliding(arot) or rotations[self.rotsys].alwayswallkick then
            local failed, modx, mody = rotations[self.rotsys]:wallkick(arot, self.piece.state, self.piece.state-1)
            if failed then return end
            px = px + modx
            py = py + mody
        end
        state = state - 1
        if not self.piece.type[state] then state = #self.piece.type end
        hasRotated = true
    end
    self.piecex = px
    self.piecey = py
    self.piece.state = state
    if self.movereset and hasRotated then
        self.lockdelay = self.speeds.lockDelay
    end
end

function game:doInput()
    if self.willTrackTime then
        if self.keys.left and not self:isColliding(nil, self.piecex-1) then
            self.piecex = self.piecex - 1
        end
        if self.keys.down then
            self.isSoftDropping = true
        end
        if self.keys.right and not self:isColliding(nil, self.piecex+1) then
            self.piecex = self.piecex + 1
        end
        if rotations[self.rotsys].doInput then
            rotations[self.rotsys]:doInput()
        end
        if self.mode.input then
            self.mode:input()
        end
    end
end

function game:doLockDelay()
    if self.are > 0 then return end
    if (game.keys.down and optionFlags.sonicDrop) or (game.keys.up and not optionFlags.sonicDrop) then
        self.lockdelay = 0
    end
    if self:isColliding(nil, nil, self.piecey+1) then
        -- go go go the piece is on the floor
        self.lockdelay = self.lockdelay - 1
        self.gravitycounter = 0
        if self.lockdelay <= 0 then
            self.lockdelay = self.speeds.lockDelay
            local lines = self:lockPiece()
            if lines > 0 then
                self.are = game.speeds.lineAre
            else
                self.are = game.speeds.are
            end
        end
    end
end

function game:printMatrix()
    -- DEBUG DEBUG DEBUG
    local o = ""
    for y, a in ipairs(self.matrix) do
        o = o .. tostring(y) .. " "
        for x, b in ipairs(a) do
            o = o .. tostring(b) .. " "
        end
        o = o .. "\n"
    end
    print(o)
end

function game:lockPiece()
    self.gravitycounter = 0
    self.piece.active = false
    local r = self.piece.type[self.piece.state]
    for y = 1, #self.piece.type[self.piece.state], 1 do
        for x = 1, #self.piece.type[self.piece.state], 1 do
            if (self.matrix[(self.piecey+y)] or {false, false, false, false})[self.piecex+x] ~= nil and r[y][x] == 1 then
                self.matrix[(self.piecey+y)][self.piecex+x] = self.piece.name
            end
        end
    end
    local lines = self:doClearLines()
    self.stats.lines = self.stats.lines + lines
    if self.mode.linesCleared then
        self.mode:linesCleared(lines)
    end
    self.stats.pieceLocks = self.stats.pieceLocks + 1
    return lines
end

function game:doClearLines()
    local clc = 0
    for y = 1, 20+self.invisrows, 1 do
        local t = self.matrix[y]
        local cleared = true
        for x, a in ipairs(t) do
            if not a then
                cleared = false
            end
        end
        if cleared then
            clc = clc + 1
            for i, j in ipairs(t) do
                self.matrix[y][i] = false
            end
            for x = 1, 10, 1 do
                self.matrix[1][x] = false
            end
            for y2 = y, 2, -1 do
                if (y2-4 <= self.playfieldDimensions.y) then
                    self.matrix[y2] = deepcopy(self.matrix[y2-1]) or {false, false, false, false, false, false, false, false, false, false}
                end
            end
        end
    end
    return clc
end

function game:getGhostPosition()
    for i = self.piecey, #self.matrix do
        if self:isColliding(nil, nil, i+1) then
            return i
        end
    end
end

function game:doGravity()
    if self.are > 0 then return end

    local grav = self.speeds.gravity
    if self.keys.down then
        grav = 1 + self.speeds.gravity
    end
    if self.keys.up and not self.upLock then
        self.piecey = self:getGhostPosition() -- haha yes
        self.upLock = true
    end

    self.gravitycounter = self.gravitycounter + grav

    while not self:isColliding(nil, nil, self.piecey+1) and self.gravitycounter >= 1 do
        self.piecey = self.piecey + 1
        self.lockdelay = self.speeds.lockDelay -- step reset
        self.gravitycounter = self.gravitycounter - 1
    end
end

function game:isColliding(piece, px, py)
    if not piece then piece = self.piece.type[self.piece.state] end
    local ax, ay = self.piecex, self.piecey
    if px then
        ax = px
    end
    if py then
        ay = py
    end
    local res = false
    local w
    if not piece then w = 4 else w = #piece end
    for y = 0, w - 1, 1 do
        for x = 0, w - 1, 1 do
            local b = piece[y+1][x+1]
            --[[if ((y+1)+ay) < self.playfieldDimensions.y or ((y+1)+ay) > self.playfieldDimensions.y or
               ((x+1)+ax) < self.playfieldDimensions.x or ((x+1)+ax) > self.playfieldDimensions.x then
                return true
            end]]
            local t = (self.matrix[((y+1)+ay)] or {nil, nil, nil, nil})[((x+1)+ax)]
            if t == nil then
                t = true
            end
            if not not t and (b == 1) then
                res = true
            end
        end
    end
    return res
end