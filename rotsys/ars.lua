--[[
    JESUS CHRIST THIS TOOK A LONG TIME
    
    feel free to use this, I really don't care,
    in fact i'll be happy if i find this in another tetris game
    because it means i've saved someone from having to do this themselves

    (C) ry00001 2019
]]

-- utility stuff
local BLANK = {0, 0, 0, 0}

rotations.ARS = {
    name = "Arika Rotation System",
    preferredRandom = "TGM"
}

rotations.ARS.structure = {
    I = {
        { BLANK,
            {1, 1, 1, 1},
            BLANK,
            BLANK },
        { {0, 0, 1, 0},
            {0, 0, 1, 0},
            {0, 0, 1, 0},
            {0, 0, 1, 0} }
    },
    T = {
        {BLANK,
         {1, 1, 1, 0},
         {0, 1, 0, 0},
         BLANK},
        {{0, 1, 0, 0},
         {1, 1, 0, 0},
         {0, 1, 0, 0},
         BLANK},
        {BLANK,
         {0, 1, 0, 0},
         {1, 1, 1, 0},
         BLANK},
        {{0, 1, 0, 0},
         {0, 1, 1, 0},
         {0, 1, 0, 0},
         BLANK}
    },
    S = {
        {BLANK,
         {0, 1, 1, 0},
         {1, 1, 0, 0},
         BLANK},
        {{1, 0, 0, 0},
         {1, 1, 0, 0},
         {0, 1, 0, 0},
         BLANK}
    },
    Z = {
        {BLANK,
         {1, 1, 0, 0},
         {0, 1, 1, 0},
         BLANK},
        {{0, 0, 1, 0},
         {0, 1, 1, 0},
         {0, 1, 0, 0},
         BLANK}
    },
    J = {
        {BLANK,
         {1, 1, 1, 0},
         {0, 0, 1, 0},
         BLANK},
        {{0, 1, 0, 0},
         {0, 1, 0, 0},
         {1, 1, 0, 0},
         BLANK},
        {BLANK,
         {1, 0, 0, 0},
         {1, 1, 1, 0},
        BLANK},
        {{0, 1, 1, 0},
         {0, 1, 0, 0},
         {0, 1, 0, 0},
         BLANK}
    },
    L = {
        {BLANK,
         {1, 1, 1, 0},
         {1, 0, 0, 0},
         BLANK},
        {{1, 1, 0, 0},
         {0, 1, 0, 0},
         {0, 1, 0, 0},
         BLANK},
        {BLANK,
         {0, 0, 1, 0},
         {1, 1, 1, 0},
         BLANK},
        {{0, 1, 0, 0},
         {0, 1, 0, 0},
         {0, 1, 1, 0},
         BLANK}
    },
    O = {
        {BLANK,
         {0, 1, 1, 0},
         {0, 1, 1, 0},
         BLANK}
    }
}

rotations.ARS.colours = {
    I = hue(0),
    J = hue(240),
    L = hue(30),
    T = hue(180),
    S = hue(300),
    Z = hue(120),
    O = hue(60),
    FLAT = {1, 1, 1, 1}
}

function rotations.ARS:wallkick(piece, a, b)
    local failed = true
    local change = 0
    if game.piece.name == "I" then return true, 0, 0 end
    if not game:isColliding(rot, game.piecex+1) then -- mihara's conspiracy
        change = 1
        failed = false
    end
    if not game:isColliding(rot, game.piecex-1) then
        change = -1
        failed = false
    end
    return failed, change, 0
end

function rotations.ARS:getSpawnLocation()
    return 3, game.invisrows
end