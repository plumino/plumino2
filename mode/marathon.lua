return {
    name = "Marathon",
    init = function(self)
        self.level = 0

        game.speeds = {
            gravity = 1/64, -- 1/64th of a G
            das = 8,
            lockDelay = 30,
            are = 10,
            lineAre = 20
        }

        self.speedcurve = {
            1/63, 1/50, 1/39, 1/30, 1/22, 1/16, 1/12, 1/8, 1/6, 1/4, 1/3, 1/2, 1,
            465/256, 731/256, 1280/256, 1707/256, 20
        }

        self:updateGravity()

        game.movereset = true
    end,
    updateGravity = function(self)
        if self.speedcurve[self.level+1] then
            game.speeds.gravity = self.speedcurve[self.level+1]
        end
    end,
    linesCleared = function(self, lines)
        if lines > 0 then
            game.stats.score = game.stats.score + (lines * (self.level + 1))

            if game.stats.lines >= (self.level+1) * 10 then
                self.level = self.level + 1
                self:updateGravity()
            end
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