return {
    init = function(self)
        self.w, self.h, self.m = love.window.getMode()
        self.alpha = 100
        self.speed = 2
        self.logoalpha = 0
        self.logospeed = 2
    end,
    update = function(self)
        if self.alpha > 0 then
            self.alpha = self.alpha - self.speed
        end
        if self.alpha < 50 and self.logoalpha < 100 then
            self.logoalpha = self.logoalpha + self.logospeed
        end
    end,
    draw = function(self)
        love.graphics.clear(0.1, 0.1, 0.1)
        love.graphics.setFont(game.font.med2)

        love.graphics.setColor(1, 1, 1, self.logoalpha/100)
        love.graphics.draw(game.gfx.logo, (self.w/2)-(game.gfx.logo:getWidth()/2), 200)

        local t = "Press ["..game:prettyKey(game.keyMap.start).."] to begin!"
        love.graphics.print(t, (self.w/2)-(game.font.med2:getWidth(t)/2), 500)

        local c = "Press ["..game:prettyKey(game.keyMap.b).."] for the options menu."
        love.graphics.setFont(game.font.std)
        love.graphics.print(c, (window.w/2)-(game.font.std:getWidth(c)/2), 530)

        local ver = string.format("v. %s", versionString())
        love.graphics.setFont(game.font.med)
        love.graphics.print(ver, (window.w-(game.font.med:getWidth(ver)))-20, (window.h-game.font.med:getHeight(ver))-20)

        love.graphics.setColor(0, 0, 0, self.alpha/100)
        love.graphics.rectangle("fill", 0, 0, window.w, window.h)
    end,
    keyDown = function(self, k, sc, r)
        if game.keys.start then
            game:switchState("menu")
        end
        if game.keys.b then
            game:switchState("options")
        end
    end
}