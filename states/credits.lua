return {
    init = function(self)
        self.credits = [[[ DEVELOPMENT ]
- Programmer -
ry00001

- Main Game Graphics -
ry00001

- Inspired By -
The Grand Master Series
NullpoMino
Cambridge



[ ASSETS ]
- Logo Graphic -
GlitchyPSI

- Mino Graphic -
Penguin

- Game Font -
Share Tech Mono
by Carrois Apostrophe

- Audio -
NullNoname/NullpoMino Audio Team



[ SPECIAL THANKS ]
- Technical Help and Support -
Oshisaure
0xFC963F18DC21

- Inspiration -
Arika Co. Ltd.
Elzed
NullNoname/NullpoMino Team

- Playtesting -
Oshisaure
0xFC963F18DC21
Akari
Doremy

Thank you for playing.



Powered by Love2D
(C) Plumino Team, 2019]]

        self.lines = {}
        for s in self.credits:gmatch("([^\n]*)\n?") do
            table.insert(self.lines, s)
        end

        self.font = game.font.med
        self.x = window.h+20
        self.speed = 1
    end,
    update = function(self)
        self.x = self.x - self.speed

        if self.x < -((self.font:getHeight(self.credits)*(#self.lines+3))-20) then
            game:switchState("title")
        end
    end,
    draw = function(self)
        love.graphics.setFont(self.font)
        for i, j in ipairs(self.lines) do
            love.graphics.print(j, (window.w/2)-(self.font:getWidth(j)/2), self.x+(i*self.font:getHeight(i)))
        end
    end
}