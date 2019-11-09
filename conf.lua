function love.conf(t)
    t.window.width = 800
    t.window.height = 600
    t.window.title = "Plumino²"
    t.identity = "plumino2"

    t.window.vsync = 0 --asdjlkasjldksajkldjaslk
end

function love.errorhandler(err)
    love.graphics.reset()
    print()
    print('--- GAME CRASH ---')
    print(err)
    print()
    local oops = love.graphics.newImage("assets/gfx/oops.png")
    love.graphics.setFont(game.font.big)
    local fnt = game.font.big
    local f = love.graphics.newFont('assets/font/standard.ttf', 24)
    local f2 = love.graphics.newFont('assets/font/standard.ttf', 20)
    local std = love.graphics.newFont('assets/font/standard.ttf', 14)
    local et = "OOPS"
    local function text(et, y, font)
        if not font then font = fnt end
        love.graphics.setFont(font)
        local t = font:getWidth(et)
        love.graphics.print(et, (800/2)-(t/2), y)
    end

    local function draw()
        love.graphics.clear(0,0,0)

        love.graphics.draw(oops, 860, 600-16, 15)
        text("OOPS", 32, love.graphics.newFont("assets/font/standard.ttf", 72))
        text("the game crashed", 128, f)
        text("report this to ry00001#3487 like right now", 128+32, f)
        text("(or use https://ry00001.itch.io/plumino2)", 128+64, f2)
        text("technical info:", 128+128, f)
        text(err, 128+128+32, f2)
        text("press ENTER to quit", 600-32, f2)
        text("(oh also this has been output to the console)", 128+64+32, std)

        love.graphics.present()
    end

    return function()
        love.event.pump()
    
        for e, a, b, c in love.event.poll() do
            if e == "quit" then
                return 1
            elseif e == "keypressed" and a == "return" then
                return 1
            end
        end

        draw()
        love.timer.sleep(0.1)
    end
end