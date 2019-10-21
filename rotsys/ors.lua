local BLANK = {0, 0, 0, 0}

rotations.ORS = {
    name = "O-Piece Rotation System",
    alwayswallkick = true,
    preferredRandom = "TGM",
    credit = {
        design = "The Tetris Company Ltd.",
        impl = "ry00001"
    }
}

rotations.ORS.structure = {
    O1 = {
        {{1, 0},
         {0, 0}},
        {{0, 0},
         {0, 1}}
    },
    O2 = {
        {{1, 1},
         {1, 1}}
    },
    O3 = {
        {{1, 1, 1},
         {1, 1, 1},
         {1, 1, 1}}
    }
}

rotations.ORS.colours = {
    O2 = hue(60),
    O1 = hue(120),
    O3 = hue(240)
}

print(inspect(rotations.ORS.colours.O))

local O = { ZZ = {{0,0}} }

local names = { -- Lua pls
    "Z", "O", "T", "H"
}

function rotations.ORS:wallkick(piece, a, b)
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
    local offset = O
    local kicks = offset[names[a] .. names[b]]
    for _, kick in ipairs(kicks or {{0,0}}) do
        ax = game.piecex + kick[1]
        ay = game.piecey + (kick[2] * -1)
        if not game:isColliding(game.piece.type[b], ax, ay) then
            return false, kick[1], kick[2] * -1
        end
    end
    return true, 0, 0
end

function rotations.ORS:getSpawnLocation()
    return 3, game.invisrows
end