randomiser.TGM = {}

function randomiser.TGM:init()
    self.firstPiece = true
    self.history = {"Z", "Z", "S", "S"}
end

function randomiser.TGM:next()
    -- TGM randomiser
    local pieces = {"I", "J", "L", "S", "T", "O", "Z"}
    local roll = pieces[love.math.random(1, #pieces)]
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
            roll = pieces[love.math.random(1, #pieces)]
        end
    end
    return roll
end