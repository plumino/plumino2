return {
    name = "math.sin()-athon",
    init = function(self)
        self.level = 0

        game.speeds = {
            gravity = 1/64, -- 1/64th of a G
            das = 8,
            lockDelay = 30,
            are = 10,
            lineAre = 20
        }

        game.movereset = true
    end,
    linesCleared = function(self, lines)
        if lines > 0 then
            game.stats.score = game.stats.score + (lines * (self.level + 1))

            if game.stats.lines >= (self.level+1) * 10 then
                self.level = self.level + 1
            end
        end
    end,
    update = function(self)
        for i=1,10,1 do
            game.yOffset[i] = math.sin(i+love.timer.getTime()) * 30
        end
    end,
    draw = function(self)
        ui.drawScoreText("Marathon", 0)

        ui.drawScoreText("Lines", 2)
        ui.drawScoreText(tostring(game.stats.lines) .. "/" .. tostring((self.level+1) * 10), 3)

        ui.drawScoreText("Level", 5)
        ui.drawScoreText(tostring(self.level), 6)

        ui.drawScoreText("Score", 8)
        ui.drawScoreText(tostring(game.stats.score), 9)
    end,
    getPresenceText = function(self)
        return tostring(game.stats.pieceLocks) .. " blocks dropped"
    end
}