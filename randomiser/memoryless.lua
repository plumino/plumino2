randomiser.MEMORYLESS = {}

function randomiser.MEMORYLESS:init()
    self.structure = {}
    for i, j in pairs(rotations[game.rotsys].structure) do
        table.insert(self.structure, i)
    end
end

function randomiser.MEMORYLESS:next()
    return self.structure[love.math.random(1,#self.structure)]
end