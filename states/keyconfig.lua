local inspect = require "lib/inspect"
local json = require "lib/json"

return {
    init = function(self)
        self.keys = {
            "up", "down", "left", "right", "a", "b", "c", "d", "start"
        }
        self.current = 1
        self.newMap = {}
        self.keyTimer = 0
        self.timerRunning = false

        self.firstKey = true
    end,
    draw = function(self)
        if self.keyTimer == 0 then
            local t = "Please press the key corresponding to:"
            local f = game.font.med2
            love.graphics.setFont(f)
            love.graphics.print(t, (window.w/2)-(f:getWidth(t)/2), 200)

            t = self.keys[self.current] or ""
            f = game.font.big
            love.graphics.setFont(f)
            love.graphics.print(t, (window.w/2)-(f:getWidth(t)/2), 250)
        else
            local t = "Key configuration complete!\nReturning to title..."
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
            game:switchState("title")
        end
    end,
    keyUp = function(self, k, sc)
        if self.keyTimer == 0 then
            if self.firstKey then
                self.firstKey = false
                return
            end
            self.newMap[self.keys[self.current]] = k
            self.current = self.current + 1
            if self.current > #self.keys then
                game.keyMap = deepcopy(self.newMap)
                if love.filesystem then
                    local s, m = love.filesystem.write("keys.psv", json.encode(self.newMap))
                end
                self.keyTimer = 90
                return
            end
        end
    end
}