random = {}

function random:init()
    self.firstPiece = true
    self.history = {"Z", "Z", "S", "S"}
end

function random:next()
    -- TGM randomiser
    local rng = love.math.newRandomGenerator(os.time())
    local pieces = {"I", "J", "L", "S", "T", "O", "Z"}
    local roll = pieces[rng:random(1, #pieces)]
    if roll == "O" and self.firstPiece then
        return self:next()
    end
    self.firstPiece = false
    for _ = 1, 3, 1 do
        if not tablecontains(self.history, roll) then
            table.remove(self.history)
            table.insert(self.history, 1, roll)
            return roll
        else
            roll = pieces[rng:random(1, #pieces)]
        end
    end
    return roll
end