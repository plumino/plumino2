PLUMINO_VERSION = {0, 0, 3}

modeNames = {
    "marathon",
    "sprint"
}
-- EDIT THIS TABLE TO LOAD MORE MODES.

rotationSystems = {
    "ars",
    "srs",
    "flashlight"
}

piece = {}

require "util"
require "stuff/randomiser"
inspect = require "lib/inspect"
require "game"
require "stuff/ui"

game.font = {
    big = love.graphics.newFont("assets/font/standard.ttf", 36),
    std = love.graphics.newFont("assets/font/standard.ttf", 14),
    med = love.graphics.newFont("assets/font/standard.ttf", 20),
    med2 = love.graphics.newFont("assets/font/standard.ttf", 24),
    med3 = love.graphics.newFont("assets/font/standard.ttf", 26)
}

game.gfx = {
    intro = "intro.png",
    title = "title.png",
    mino = "mino16.png"
}

game.background = {
    "bg1.png"
}

game.bgm = {
    "bgm1.ogg"
}

modes = {}
rotations = {}

game.sfx = {
    ready = "ready.wav",
    go = "go.wav",
    credit = "credit.wav"
}

function game:switchState(name, args)
    if not game.states[name] then
        error("Could not switch to state "..name)
    end
    game.stateName = name
    game.state = game.states[name]
    if game.state.init then
        game.state:init(args)
    end

    love.window.setTitle("Plumino 2: "..name)
end

local files = {
    "game",
    "menu"
}

function love.load()
    for _, i in pairs(files) do -- handle state loading
        require("./states/"..i)
    end

    for _, i in pairs(modeNames) do -- handle mode loading
        require("./mode/"..i)
    end

    for _, i in pairs(rotationSystems) do -- handle rotsys loading
        require("./rotsys/"..i)
    end

    for p, f in pairs(game.gfx) do -- handle gfx loading
        game.gfx[p] = love.graphics.newImage("assets/gfx/"..f)
    end

    for p, f in ipairs(game.background) do -- handle gfx loading
        game.background[p] = love.graphics.newImage("assets/bg/"..f)
    end

    for p, f in pairs(game.sfx) do -- handle sfx loading
        game.sfx[p] = love.audio.newSource("assets/sfx/"..f, "static")
    end

    if love.filesystem.getInfo("assets/bgm", "directory") then
        for p, f in ipairs(game.bgm) do -- handle bgm loading
            game.bgm[p] = love.audio.newSource("assets/bgm/"..f, "stream")
            game.bgm[p]:setLooping(true)
        end
    end

    game:switchState("menu")
end

function love.update(dt)
    game:checkJustPressed()

    if game.state and game.state.update then
        game.state:update(dt)
    end
end

function love.draw()
    if game.state and game.state.draw then
        game.state:draw()
    end

    love.graphics.setFont(game.font.med)
    love.graphics.print(tostring(love.timer.getFPS()).." FPS", 0, 0)
end

function love.keypressed(k, sc, r)
    game:keyDown(k, sc, r)
    if game.state and game.state.keyDown then
        game.state:keyDown(k, sc, r)
    end
    game:doInput()
end

function love.keyreleased(k, sc, r)
    game:keyUp(k, sc, r)
    if game.state and game.state.keyUp then
        game.state:keyUp(k, sc, r)
    end
end