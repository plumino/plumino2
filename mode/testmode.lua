return {
    name = "Test Mode",
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

        self.sx, self.sy, self.sm = love.window.getPosition()
        self.stopping = false
    end,
    stop = function(self)
        self.stopping = true
        love.window.setPosition(self.sx, self.sy, self.sm)
        screenX, screenY = 0
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
        if self.stopping then return end
        local rand, rand2 = love.math.random(), love.math.random()
        local val = 200
        --local fx, fy = math.sin(love.timer.getTime())*val, math.cos(love.timer.getTime())*val
        local fx, fy = 1/math.cos(love.timer.getTime())*val, 0
        local a = {self.sx+fx, self.sy+fy}
        if a then
            love.window.setPosition(unpack(a))
        end

        screenX = -fx
        screenY = -fy

        for i=1,10,1 do
            --game.yOffset[i] = math.tan(i+love.timer.getTime()) * 30
            --game.yOffset[i] = (1/math.cos(love.timer.getTime())) * 30
            --[[game.xOffset[i] = rand*val - val/2
            game.yOffset[i] = rand2*val - val/2

            screenX = rand*val - val/2
            screenY = 0]]
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