require "lib/inspect"

return {
    init = function(self)
        updatePresence {
            largeImageKey = "logo",
            state = "In the menu"
        }

        self.menuindex = 1
        self.menustate = 0 -- 0: selecting gamemode, 1: selecting rot
        local a = {}
        local count1 = 0
        for i, j in pairs(modes) do
            count1 = count1 + 1
            a[count1] = i
        end
        self.modes = a
        local b = {}
        local count2 = 0
        for i, j in pairs(rotations) do
            count2 = count2 + 1
            b[count2] = i
        end
        local p = {}
        local c3 = 0
        for i, j in pairs(plugins) do
            c3 = c3 + 1
            p[c3] = i
        end
        self.rotations = b
        self.modelen = count1
        self.rotlen = count2
        self.p = p
        self.modesel = nil
        self.rotsel = nil
    end,
    draw = function(self)
        love.graphics.setFont(game.font.med2)
        love.graphics.setColor(1, 1, 1, 1)
        local text = "Select game mode"
        if self.menustate == 1 then
            text = "Select rotation system"
        end
        if self.menustate == 2 then
            text = "Select plugins"
        end
        love.graphics.print(text, 20, 20)

        local count = 0
        local thing = self.modes
        if self.menustate == 1 then
            thing = self.rotations
        end
        if self.menustate == 2 then
            thing = plugins
        end
        for i, j in pairs(thing) do
            count = count + 1
            local tappend = "  "
            if count == self.menuindex then
                tappend = "> "
            end
            love.graphics.setFont(game.font.med)
            if self.menustate == 0 then 
                love.graphics.print(tappend .. modes[j].name, 25, 35 + (count*25) + (game.font.med:getHeight(tappend..modes[j].name)))
            elseif self.menustate == 1 then
                love.graphics.print(tappend .. rotations[j].name, 25, 35 + (count*25) + (game.font.med:getHeight(tappend..rotations[j].name)))
            else
                love.graphics.print(tappend .. j.name .. ': ' .. ternary(j.enabled, 'on', 'off'), 25, 35 + (count*25) + (game.font.med:getHeight(tappend..j.name)))
            end
        end
    end,
    update = function(self)
        local currlen = self.modelen
        if self.menustate == 1 then
            currlen = self.rotlen
        end
        if self.menustate == 2 then
            currlen = #plugins
        end
        if game.justPressed.down then
            self.menuindex = self.menuindex + 1
            if self.menuindex > currlen then
                self.menuindex = 1
            end
        end
        if game.justPressed.up then
            self.menuindex = self.menuindex - 1
            if self.menuindex <= 0 then
                self.menuindex = currlen
            end
        end
        if game.justPressed.a then
            if self.menustate == 0 then
                self.modesel = self.modes[self.menuindex]
                self.menuindex = 1
                self.menustate = 1
                return
            end
            if self.menustate == 1 then
                self.rotsel = self.rotations[self.menuindex]
                self.menuindex = 1
                self.menustate = 2
                return
            end
            if self.menustate == 2 then
                plugins[self.p[self.menuindex]].enabled = not plugins[self.p[self.menuindex]].enabled
            end
        end
        if game.justPressed.start and self.menustate == 2 then
            game:switchState("game", {self.modesel, self.rotsel})
        end
        if game.justPressed.b then
            if self.menustate == 1 then
                self.menuindex = 1
                self.menustate = 0
                return
            end
            if self.menustate == 0 then
                game:switchState("title")
            end
        end
        if game.justPressed.c then
            game:switchState("options")
        end
    end
}