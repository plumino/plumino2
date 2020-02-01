--[[
    Bruh Blocks rotation system
    [ based off of BBlocks by Softwaves ]
    special thanks to @miskeeping for gifting the game to me.
    - implemented by ry00001 -

    this is a mistake !
]]

rotations.BRUH = {
    name = "Bruh Blocks",
    preferredRandom = "MEMORYLESS",
    credit = {
        design = "Softwaves Co. Ltd.",
        impl = "ry00001"
    }
}

rotations.BRUH.structure = {
    bblock = {
        {{1,1,0,0}, -- 0
         {1,1,0,0},
         {0,0,0,0},
         {0,0,0,0}},
        {{1,1,0,0}, -- 1
         {0,1,0,0},
         {0,1,0,0},
         {0,0,0,0}},
        {{1,1,1,0}, -- 2
         {1,0,0,0},
         {0,0,0,0},
         {0,0,0,0}},
        {{1,0,0,0}, -- 3
         {1,0,0,0},
         {1,1,0,0},
         {0,0,0,0}},
        {{0,0,1,0}, -- 4
         {1,1,1,0},
         {0,0,0,0},
         {0,0,0,0}},
        {{1,1,0,0}, -- 5
         {1,0,0,0},
         {1,0,0,0},
         {0,0,0,0}},
        {{1,0,0,0}, -- 6
         {1,1,1,0},
         {0,0,0,0},
         {0,0,0,0}},
        {{0,1,0,0}, -- 7
         {0,1,0,0},
         {1,1,0,0},
         {0,0,0,0}},
        {{1,1,1,0}, -- 8
         {0,0,1,0},
         {0,0,0,0},
         {0,0,0,0}},
        {{1,1,0,0}, -- 9
         {0,1,1,0},
         {0,0,0,0},
         {0,0,0,0}},
        {{0,1,0,0}, -- 10
         {1,1,0,0},
         {1,0,0,0},
         {0,0,0,0}},
        {{0,1,1,0}, -- 11
         {1,1,0,0},
         {0,0,0,0},
         {0,0,0,0}},
        {{1,0,0,0}, -- 12
         {1,1,0,0},
         {0,1,0,0},
         {0,0,0,0}},
        {{1,1,1,1}, -- 13
         {0,0,0,0},
         {0,0,0,0},
         {0,0,0,0}},
        {{1,0,0,0},
         {1,0,0,0},
         {1,0,0,0},
         {1,0,0,0}},
    }
}

local starts = {1, 2, 6, 10, 12, 14}

local h = {'bblock'}

rotations.BRUH.colours = {}
for _, i in ipairs(h) do
    rotations.BRUH.colours[i] = {love.math.random(0,1), love.math.random(0,1), love.math.random(0,1)}
end

function rotations.BRUH:getSpawnLocation()
    return 3, game.invisrows - 2
end

function rotations.BRUH:onNext()
    game.piece.state = starts[love.math.random(1,#starts)]
end