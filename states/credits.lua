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



[ DEFAULT SKIN/ASSETS ]
- Logo Graphic -
GlitchyPSI

- Mino Graphic -
Default: Penguin
Bricks, Retro, Flat: ry00001
Classic: Oshisaure

- Backgrounds -
Provided by 0xFC963F18DC21

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

I did not expect this game to get this far.
This started as a small passion project, then
quickly evolved into so much more.

If you're playing this game for the first time,
or returning to it after a while to see what's new,
or even going for some cool high scores,
from the bottom of my heart,

thank you for playing.



Produced by
Plumino Team
2019-2020]]

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