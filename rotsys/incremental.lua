--[[
    The Incremental Rotation System
    By ry00001, 2019
    Special thanks to Oshisaure for inspiration and technical help
]]

rotations.INCREMENTAL = {
    name = "Incremental Rotation System",
    preferredRandom = "ONLYI",

    -- Incremental stuff below
    order = 5,
    pseudo = false
}

local inspect = require("lib/inspect")

rotations.INCREMENTAL.colours = {}

rotations.INCREMENTAL.structure = {
    I = {{{1}}} -- this is entirely to stop the game from crashing
}

function rotations.INCREMENTAL:getSpawnLocation()
    return 3, game.invisrows
end

function rotations.INCREMENTAL:r(a)
    local new = {}
    for y = 1, self.order, 1 do
        new[y] = {}
        for x = 1, self.order, 1 do
            new[y][x] = 0
        end
    end

    for y = 1, self.order, 1 do
        for x = 1, self.order, 1 do
            new[self.order+1-x][y] = a[y][x]
        end
    end

    return new 
end

function rotations.INCREMENTAL:getPieceStructure(_)
    local t = {}
    for y = 1, self.order, 1 do
        t[y] = {}
        for x = 1, self.order, 1 do
            t[y][x] = 0
        end
    end
    local ax, ay = math.floor(self.order/2), math.floor(self.order/2)
    local i = 0
    while true do
        local d = love.math.random(1, 4)
        if self.pseudo then
            d = love.math.random(1, 8)
        end
        if d == 1 then -- left
            ax = ax - 1
        elseif d == 2 then -- right
            ax = ax + 1
        elseif d == 3 then -- down
            ay = ay - 1
        elseif d == 4 then -- up
            ay = ay + 1
        elseif d == 5 then -- up-right
            ax, ay = ax+1, ay-1
        elseif d == 6 then -- up-left
            ax, ay = ax-1, ay-1
        elseif d == 7 then -- down-right
            ax, ay = ax+1, ay+1
        elseif d == 8 then -- down-left
            ax, ay = ax-1, ay+1
        end
        if ax < 1 then
            ax = 1
        end
        if ax > self.order then
            ax = self.order
        end
        if ay < 1 then
            ay = 1
        end
        if ay > self.order then
            ay = self.order
        end
        if t[ay][ax] == 0 then
            t[ay][ax] = 1
            i = i + 1
        end
        if i >= self.order then
            break
        end
    end
    return {t, self:r(t), self:r(self:r(t)), self:r(self:r(self:r(t)))}
end

function rotations.INCREMENTAL:getPieceColour(x, y, piece)
    return {1, 1, 1, 1}
end

function rotations.INCREMENTAL:wallkick(piece, a, b)
    local failed = true
    local changea = 0
    local achange = 0
    while true do
        changea = changea + 1
        if not game:isColliding(rot, game.piecex+changea) then -- mihara's conspiracy
            achange = changea
            failed = false
            break
        end
        if not game:isColliding(rot, game.piecex-changea) then
            achange = (changea*-1)
            failed = false
            break
        end
    end
    return failed, achange, 0
end