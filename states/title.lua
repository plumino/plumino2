return {
    init = function(self)
        self.w, self.h, self.m = love.window.getMode()
        self.alpha = 100
        self.speed = 2
        self.logoalpha = 0
        self.logospeed = 2

        self.messages = {
            "Go better next time.",
            "When in doubt, close the game.",
            "Matching 10 since 2019!",
            "Gluten-free.",
            "Put the block!",
            "Only contains trace amounts of bugs.",
            "May contain nuts.",
            "Can you reach the top?",
            "Ready for ARSinine moments!",
            "Not procedurally generated. Most of the time."
        }

        self.specialmessages = {
            {{18, 8}, "Happy birthday Akari!"},
            {{28, 11}, "Happy birthday Lilla!"},
            {{24, 2}, "Happy birthday Squish!"},
            {{13, 3}, "Happy birthday Amy!"},
            {{13, 4}, "Happy birthday 0xFC!"},
            {{20, 9}, "Happy birthday Fay!"},
            {{24, 12}, "Happy holidays!"},
            {{25, 12}, "Happy holidays!"},
            {{1, 1}, "Happy new year!"}
        }

        self.message = self.messages[love.math.random(1, #self.messages)]
        local date = os.date('*t')
        for i, j in ipairs(self.specialmessages) do
            if j[1][1] == date.day and j[1][2] == date.month then
                self.message = j[2]
            end
        end
    end,
    update = function(self)
        if self.alpha > 0 then
            self.alpha = self.alpha - self.speed
        end
        if self.alpha < 50 and self.logoalpha < 100 then
            self.logoalpha = self.logoalpha + self.logospeed
        end

        if game.justPressed.start then
            game:switchState("menu")
        end
        if game.justPressed.b then
            game:switchState("options")
        end
    end,
    draw = function(self)
        love.graphics.clear(0.1, 0.1, 0.1)
        love.graphics.setFont(game.font.med2)

        love.graphics.setColor(1, 1, 1, self.logoalpha/100)
        love.graphics.draw(game.gfx.logo, (self.w/2)-(game.gfx.logo:getWidth()/2), 150)

        love.graphics.setFont(game.font.med)
        love.graphics.print(self.message, (self.w/2)-(game.font.med:getWidth(self.message)/2), 300)

        love.graphics.setFont(game.font.med2)
        local t = "Press ["..game:prettyKey(game.keyMap.start).."] to begin!"
        love.graphics.print(t, (self.w/2)-(game.font.med2:getWidth(t)/2), 420)

        local c = "Press ["..game:prettyKey(game.keyMap.b).."] for the options menu."
        love.graphics.setFont(game.font.std)
        love.graphics.print(c, (window.w/2)-(game.font.std:getWidth(c)/2), 450)

        local ver = string.format("v. %s", versionString())
        love.graphics.setFont(game.font.med)
        love.graphics.print(ver, (window.w-(game.font.med:getWidth(ver)))-20, (window.h-game.font.med:getHeight(ver))-20)

        local notice = "by ry00001 2019"
        love.graphics.print(notice, 20, (window.h-game.font.med:getHeight(notice))-20)

        love.graphics.setColor(0, 0, 0, self.alpha/100)
        love.graphics.rectangle("fill", 0, 0, window.w, window.h)
    end
}