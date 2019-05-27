local BLANK = {0, 0, 0, 0}

rotations.FLASHLIGHT = {
    name = "Flashlight Rotation System",
    alwayswallkick = true,
    banana = 0,
    bananastate = 0
}

rotations.FLASHLIGHT.structure = {
    I = { -- *WHY* IS THE I PIECE A 5x5, TTC PLS
        {{0, 0, 0, 0},
         {1, 1, 1, 1},
         {0, 0, 0, 0},
         {0, 0, 0, 0}},
        {{0, 0, 1, 0},
         {0, 0, 1, 0},
         {0, 0, 1, 0},
         {0, 0, 1, 0}},
        {{0, 0, 0, 0},
         {0, 0, 0, 0},
         {1, 1, 1, 1},
         {0, 0, 0, 0}},
        {{0, 1, 0, 0},
         {0, 1, 0, 0},
         {0, 1, 0, 0},
         {0, 1, 0, 0}}
    },
    J = {
        {{1, 0, 0},
        {1, 1, 1},
        {0, 0, 0}},
        {{0, 1, 1},
        {0, 1, 0},
        {0, 1, 0}},
        {{0, 0, 0},
        {1, 1, 1},
        {0, 0, 1}},
        {{0, 1, 0},
        {0, 1, 0},
        {1, 1, 0}}
    },
    L = {
        {{0, 0, 1},
        {1, 1, 1},
        {0, 0, 0}},
        {{0, 1, 0},
        {0, 1, 0},
        {0, 1, 1}},
        {{0, 0, 0},
        {1, 1, 1},
        {1, 0, 0}},
        {{1, 1, 0},
        {0, 1, 0},
        {0, 1, 0}}
    },
    O = {
        {{0, 0, 0, 0},
         {0, 1, 1, 0},
         {0, 1, 1, 0},
         {0, 0, 0, 0}}
    },
    S = {
        {{0, 1, 1},
        {1, 1, 0},
        {0, 0, 0}},
        {{0, 1, 0},
        {0, 1, 1},
        {0, 0, 1}},
        {{0, 0, 0},
        {0, 1, 1},
        {1, 1, 0}},
        {{1, 0, 0},
        {1, 1, 0},
        {0, 1, 0}}
    },
    T = {
        {{0, 1, 0},
         {1, 1, 1},
         {0, 0, 0}},
        {{0, 1, 0},
         {0, 1, 1},
         {0, 1, 0}},
        {{0, 0, 0},
         {1, 1, 1},
         {0, 1, 0}},
        {{0, 1, 0},
         {1, 1, 0},
         {0, 1, 0}}
    },
    Z = {
        {{1, 1, 0},
        {0, 1, 1},
        {0, 0, 0}},
        {{0, 0, 1},
        {0, 1, 1},
        {0, 1, 0}},
        {{0, 0, 0},
        {1, 1, 0},
        {0, 1, 1}},
        {{0, 1, 0},
        {1, 1, 0},
        {1, 0, 0}}
    }
}

rotations.FLASHLIGHT.colours = {
    I = hue(180),
    J = hue(240),
    L = hue(30),
    T = hue(270),
    S = hue(120),
    Z = hue(0),
    O = hue(60)
}

local JLSZT = {
    ZO = { {0, 0},{-1, 0},{-1, 1},{0, -2},{-1, -2} },
    OZ = { {0, 0},{1, 0},{1, -1},{0, 2},{1, 2} },
    OT = { {0, 0},{1, 0},{1, -1},{0, 2},{1, 2} },
    TO = { {0, 0},{-1, 0},{-1, 1},{0, -2},{-1, -2} },
    TH = { {0, 0},{1, 0},{1, 1},{0, -2},{1, -2} },
    HT = { {0, 0},{-1, 0},{-1, -1},{0, 2},{-1, 2} },
    HZ = { {0, 0},{-1, 0},{-1, -1},{0, 2},{-1, 2} },
    ZH = { {0, 0},{1, 0},{1, 1},{0, -2},{1, -2} }
}
local I = {
    ZO = { {0, 0},{-2, 0},{1,  0},{-2, -1},{1,   2} },
    OZ = { {0, 0},{2,  0},{-1, 0},{2,   1},{-1, -2} },
    OT = { {0, 0},{-1, 0},{2, 0},{-1,  2},{2,  -1} },
    TO = { {0, 0},{1,  0},{-2, 0},{1,  -2},{-2,  1} },
    TH = { {0, 0},{2,  0},{-1, 0},{2,   1},{-1, -2} },
    HT = { {0, 0},{-2, 0},{1,  0},{-2, -1},{1,   2} },
    HZ = { {0, 0},{1,  0},{-2, 0},{1,  -2},{-2,  1} },
    ZH ={ {0, 0},{-1, 0},{2,  0},{-1,  2},{2,  -1} }
}
local O = { ZZ = {{0,0}} }

local names = { -- Lua pls
    "Z", "O", "T", "H"
}

function rotations.FLASHLIGHT:wallkick(piece, a, b)
    if a == 0 then
        a = 4
    end
    if b == 0 then
        b = 4
    end
    if a == 5 then
        a = 1
    end
    if b == 5 then
        b = 1
    end
    local ax, ay = 0
    local offset = JLSZT
    if game.piece.name == "I" then
        offset = I
    end
    local kicks = offset[names[a] .. names[b]]
    for _, kick in ipairs(kicks) do
        ax = game.piecex + kick[1]
        ay = game.piecey + (kick[2] * -1)
        if not game:isColliding(game.piece.type[b], ax, ay) then
            return false, kick[1], kick[2] * -1
        end
    end
    return true, 0, 0
end

function rotations.FLASHLIGHT:getSpawnLocation()
    return 2, game.invisrows - 2
end

local speed = 0.01

function rotations.FLASHLIGHT:update()
    if self.banana > 0 then
        self.banana = self.banana - speed
    end
end

function rotations.FLASHLIGHT:doInput()
    self.banana = self.banana + 0.10
end

function rotations.FLASHLIGHT:getPieceColour(x, y, piece)
    local heck = self.colours[piece] or {1, 1, 1, 1}
    return {heck[1], heck[2], heck[3], self.banana}
end