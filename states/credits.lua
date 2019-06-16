return {
    init = function(self)
        self.credits = [[[ DEVELOPMENT ]
ry00001 - Code
Oshisaure - Technical help
#spyros-dev-lag - Technical help

[ ASSETS ]
GlitchyPSI - Logo
Penguin - Mino skin
Share Tech Mono - Font

[ SPECIAL THANKS ]
Oshisaure
0xFC963F18DC21
Akari
Doremy
Everyone who has playtested
And you

Powered by Love2D
(C) ry00001, 2019]]

        self.font = game.font.med
        self.x = window.h+20
        self.speed = 1
    end,
    update = function(self)
        self.x = self.x - self.speed

        if self.x < -(self.font:getHeight(self.credits)-20) then
            game:switchState("title")
        end
    end,
    draw = function(self)
        love.graphics.setFont(self.font)
        love.graphics.print(self.credits, (window.w/2)-(self.font:getWidth(self.credits)/2), self.x)
    end
}