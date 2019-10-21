local inspect = require "lib/inspect"
local json = require "lib/json"

return {
    init = function(self, arg)
        self.keys = {
            "up", "down", "left", "right", "a", "b", "c", "d", "start"
        }
        self.current = 1
        self.newMap = {}
        self.keyTimer = 0
        self.timerRunning = false
        
        if arg and arg[1] then
            self.goToState = arg[1]
        end
    end,
    draw = function(self)
        if self.keyTimer == 0 then
            local t = "Please press the button corresponding to:"
            local f = game.font.med2
            love.graphics.setFont(f)
            love.graphics.print(t, (window.w/2)-(f:getWidth(t)/2), 200)

            t = self.keys[self.current] or ""
            f = game.font.big
            love.graphics.setFont(f)
            love.graphics.print(t, (window.w/2)-(f:getWidth(t)/2), 250)
        else
            local t = "Controller configuration complete!"
            local f = game.font.med2
            love.graphics.setFont(f)
            love.graphics.print(t, (window.w/2)-(f:getWidth(t)/2), 200)
        end
    end,
    update = function(self)
        if self.keyTimer > 0 then
            self.timerRunning = true
            self.keyTimer = self.keyTimer - 1
        end
        if self.keyTimer <= 0 and self.timerRunning then
            game:switchState(self.goToState or "title")
        end
    end,
    padDown = function(self, k)
        if self.keyTimer == 0 then
            self.newMap[self.keys[self.current]] = k
            self.current = self.current + 1
            if self.current > #self.keys then
                game.controllerMap = deepcopy(self.newMap)
                if love.filesystem then
                    local s, m = love.filesystem.write("controller.psv", json.encode(self.newMap))
                end
                self.keyTimer = 90
                return
            end
        end
    end
}