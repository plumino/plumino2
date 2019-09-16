PLUMINO_VERSION = {5, 0}
PLUMINO_VERSION_CODENAME = 'AV Update'

PLUMINO_DEV_BUILD = false

window = {}
window.w, window.h, window.mode = love.window.getMode()

MAX_FPS = 60
local next_time = love.timer.getTime()

modeNames = {
    "marathon",
    "20g_marathon",
    "sprint",
    "ionlysprint",
    "sinemarathon",
    "testmode",
    "squirrel"
}
-- EDIT THIS TABLE TO LOAD MORE MODES.

rotationSystems = {
    "ars",
    "srs",
    "flashlight",
    "incremental"
}
-- EDIT THIS TABLE TO LOAD ROTATION SYSTEMS.

randomisers = {
    "tgm",
    "onlyi"
}
-- EDIT THIS TABLE TO LOAD RANDOMISERS.

piece = {}

require "util"
inspect = require "lib/inspect"
require "game"
require "stuff/ui"
local json = require "lib/json"
require "states/options/main"

local libstatus, liberr = pcall(function() discord = require "lib/discordRPC" end)

if libstatus then
    discord = require "lib/discordRPC"
else
    print("[WARNING!] Could not load Discord rich presence: "..liberr)
    print("[WARNING!] This is normal if using the .love file.")
end
local presence = {}

function updatePresence(p)
    presence = p
    nextPresence = 0
end

local nextPresence = 0

game.font = {
    big = love.graphics.newFont("assets/font/standard.ttf", 36),
    std = love.graphics.newFont("assets/font/standard.ttf", 14),
    med = love.graphics.newFont("assets/font/standard.ttf", 20),
    med2 = love.graphics.newFont("assets/font/standard.ttf", 24),
    med3 = love.graphics.newFont("assets/font/standard.ttf", 26)
}

game.gfx = {
    intro = "arikek.png",
    title = "title.png",
    dev = "dev.png",
    poweredby = "poweredby.png",
    logo = "logo.png"
}

game.background = {
    "bg1.png",
    "bg2.png",
    "bg3.png",
    "bg4.png",
    "bg5.png",
    "bg6.png",
    "bg7.png",
    "bg8.png",
    "bg9.png",
    "bg10.png",
    "bg11.png",
    "bg12.png",
    "bg13.png"
}

game.bgm = {
    "bgm1.ogg"
}

game.mino = {
    "1.png",
    "2.png",
    "2_alt.png",
    "3.png",
    "agc.png",
    "flat.png",
    "flat_bright.png"
}
game.minoName = {
    "Default",
    "Bricks",
    "Bricks (alternate)",
    "Retro",
    "Classic",
    "Flat (dark)",
    "Flat (bright)"
}

modes = {}
rotations = {}
randomiser = {}

game.sfx = {
    ready = "ready.wav",
    go = "go.wav",
    credit = "credit.wav",
    lock = "lock.wav",
    gameover = "gameover.wav",
    levelup = "levelup.ogg"
}
game.clearaudio = {
    "1.wav", "2.wav", "3.wav", "4.wav"
}

screen = love.graphics.newCanvas() -- testing this
screenX = 0
screenY = 0
screenCol = {1, 1, 1, 1}

function game:switchState(name, args)
    if not game.states[name] then
        error("Could not switch to state "..name)
    end
    if game.state and game.state.stop then
        game.state:stop()
    end
    game.stateName = name
    game.state = game.states[name]
    if game.state.init then
        game.state:init(args)
    end

    -- RESET THE SCREEN VARIABLES
    screenX = 0
    screenY = 0
    screenCol = {1, 1, 1, 1}

    love.window.setTitle("Plumino²: "..name)
end

local files = {
    "game",
    "menu",
    "splash",
    "title",
    "credits",
    "keyconfig",
    "options"
}

function love.load()
    if discord then
        discord.initialize("585884186188054535", true) -- DISCORD RICH PRESENCE
    end

    for _, i in pairs(files) do -- handle state loading
        game.states[i] = require("./states/"..i)
    end

    for _, i in pairs(modeNames) do -- handle mode loading
        modes[i] = require("./mode/"..i)
    end

    for _, i in pairs(rotationSystems) do -- handle rotsys loading
        require("./rotsys/"..i)
    end

    for _, i in pairs(randomisers) do -- handle randomiser loading
        require("./randomiser/"..i)
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

    for p, f in ipairs(game.clearaudio) do -- handle sfx loading
        game.clearaudio[p] = love.audio.newSource("assets/sfx/clear/"..f, "static")
    end

    if love.filesystem and love.filesystem.getInfo then -- fix crash on some platforms
        if love.filesystem.getInfo("assets/bgm", "directory") then
            for p, f in ipairs(game.bgm) do -- handle bgm loading
                game.bgm[p] = love.audio.newSource("assets/bgm/"..f, "stream")
                game.bgm[p]:setLooping(true)
            end
        end
    end

    if love.filesystem and love.filesystem.getInfo then -- fix crash on some platforms
        if love.filesystem.getInfo("assets/gfx/mino", "directory") then
            for p, f in ipairs(game.mino) do -- handle bgm loading
                game.mino[p] = love.graphics.newImage("assets/gfx/mino/"..f)
            end
        end
    end

    local runInputConfig = false

    if love.filesystem then
        local c, e = love.filesystem.read("keys.psv")
        if c == nil then
            print('Input file load failed. Sending player to configurator.')
            runInputConfig = true
        else
            local t = json.decode(c)
            game.keyMap = deepcopy(t)
        end
    end

    if runInputConfig then
        game:switchState("keyconfig", {"splash"})
    else
        game:switchState("splash")
    end
end

function love.update(dt)
    game:updateKeys()
    game:checkJustPressed()

    game:doInput()

    if game.state and game.state.update then
        game.state:update(dt)
    end

    if discord then
        if game.mode and game.mode.getPresenceText then
            presence.largeImageText = game.mode:getPresenceText()
        end

        if nextPresence < love.timer.getTime() then
            discord.updatePresence(presence)
            nextPresence = love.timer.getTime() + 2.0
        end
        discord.runCallbacks()
    end

    next_time = next_time + 1/MAX_FPS
end

function love.quit()
    if discord then
        discord.shutdown()
    end
end

if discord then
    function discord.ready(uid, uname, discrim, avy)
        print(string.format("[Discord RPC] Ready! Logged in as %s#%s (%s).", uname, discrim, uid))
    end
end

function love.draw()
    love.graphics.setCanvas(screen)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")

    if game.state and game.state.draw then
        game.state:draw()
    end

    love.graphics.setFont(game.font.med)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(love.timer.getFPS()).."/"..MAX_FPS.." FPS", 0, 0)

    love.graphics.setCanvas()
    love.graphics.setColor(unpack(screenCol))
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(screen, screenX, screenY)

    local current_time = love.timer.getTime()
    if next_time <= current_time then
        next_time = current_time
        return
    end
    love.timer.sleep(next_time - current_time)
end

function love.keypressed(k, sc, r)
    --game:keyDown(k, sc, r)
    if game.state and game.state.keyDown then
        game.state:keyDown(k, sc, r)
    end
    game:doAltInput()
end

function love.keyreleased(k, sc)
    --game:keyUp(k, sc)
    if game.state and game.state.keyUp then
        game.state:keyUp(k, sc)
    end
end