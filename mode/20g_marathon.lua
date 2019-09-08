return {
    name = "Marathon (20G)",
    init = function(self)
        self.level = 0

        game.speeds = {
            gravity = math.huge,
            das = 13,
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
    draw = function(self)
        ui.drawScoreText("Marathon (20G)", 0)

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