require "lib/inspect"

return {
    init = function(self)
        updatePresence {
            largeImageKey = "logo",
            state = "Options menu"
        }

        self.menuindex = 1
        self.menustate = 0 -- 0: selecting gamemode, 1: selecting rot
        self.options = (require('states/options/main'))
        self.rotations = b
        self.length = #self.options
        self.modesel = nil
    end,
    draw = function(self)
        love.graphics.setFont(game.font.med2)
        love.graphics.setColor(1, 1, 1, 1)
        local text = "Change the options"
        love.graphics.print(text, 20, 20)

        local count = 0
        local thing = self.options
        for i, j in ipairs(thing) do
            count = count + 1
            local tappend = "  "
            if count == self.menuindex then
                tappend = "> "
            end
            love.graphics.setFont(game.font.med)
            local thething = j.name
            if j.value then
                thething = string.gsub(thething, "{v}", j:value())
            end
            love.graphics.print(tappend .. thething, 25, 35 + (count*25) + (game.font.med:getHeight(tappend..j.name)))
        end
    end,
    keyDown = function(self, k, sc, ro)
        local currlen = self.length
        if game.keys.down then
            self.menuindex = self.menuindex + 1
            while self.options[self.menuindex] and self.options[self.menuindex].unselectable do
                self.menuindex = self.menuindex + 1
            end
            if self.menuindex > currlen then
                self.menuindex = 1
            end
        end
        if game.keys.up then
            self.menuindex = self.menuindex - 1
            while self.options[self.menuindex] and self.options[self.menuindex].unselectable do
                self.menuindex = self.menuindex - 1
            end
            if self.menuindex <= 0 then
                self.menuindex = currlen
            end
        end
        if game.keys.a and self.options[self.menuindex].aAction then
            self.options[self.menuindex]:aAction()
        end
        if game.keys.left and self.options[self.menuindex].lAction then
            self.options[self.menuindex]:lAction()
        end
        if game.keys.right and self.options[self.menuindex].rAction then
            self.options[self.menuindex]:rAction()
        end
        if game.keys.b then
            game:switchState("title")
        end
    end
}