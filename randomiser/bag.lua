--[[
    bag nightcore randomiser for plumino^2
    by ry00001 2020
]]

randomiser.BAG = {}

function randomiser.BAG:init()
    self.structure = {}
    for i, j in pairs(rotations[game.rotsys].structure) do
        table.insert(self.structure, i)
    end
    self.bag = deepcopy(self.structure)
end

function randomiser.BAG:next()
    local piece = love.math.random(1, #self.bag)
    local pieceName = deepcopy(self.bag[piece]) -- overkill?
    table.remove(self.bag, piece)
    if #self.bag == 0 then
        print('next bag reached')
        self.bag = deepcopy(self.structure)
    end
    return pieceName
end