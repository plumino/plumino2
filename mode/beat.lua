return {
    name = "Beat",
    init = function(self)
        game.speeds = {
            gravity = 0,
            das = 13,
            lockDelay = 0,
            are = 0,
            lineAre = 0
        }
        self.beat = 0
        self.bpm = 120 -- change this!!
        self.len = (60/(self.bpm/2))
        self.lastbeat = 1
        game.allowHardDrop = false
        optionFlags.sonicDrop = true
        if type(game.bgm[1]) == 'string' then
            error('Mode cannot be played without music.')  
        end

        game.movereset = true
    end,
    update = function(self)
        self.beat = game.bgm[1]:tell() * self.len
        if self.beat >= self.lastbeat then
            game.piecey = game:getGhostPosition() -- haha yes
            self.lastbeat = self.lastbeat + 1
        end
    end,
    linesCleared = function(self, lines)
        if lines > 0 then
            game.stats.score = game.stats.score + math.floor(lines * self.beat)
        end
    end,
    draw = function(self)
        ui.drawScoreText("Beat", 0)

        ui.drawScoreText("Lines", 2)
        ui.drawScoreText(tostring(game.stats.lines), 3)

        ui.drawScoreText("Beat", 5)
        ui.drawScoreText(tostring(self.beat), 6)

        ui.drawScoreText("Score", 8)
        ui.drawScoreText(tostring(game.stats.score), 9)
    end,
    getPresenceText = function(self)
        return tostring(game.stats.pieceLocks) .. " blocks dropped"
    end
}