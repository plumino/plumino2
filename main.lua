PLUMINO_VERSION = {7, 1}
PLUMINO_VERSION_CODENAME = 'Light Update'

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
    "ors",
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

json = require "lib/json"
inspect = require "lib/inspect"
require "util"
require "stuff/skin"
require "game"
require "stuff/ui"
require "states/options/main"

local logistatus, logierr = pcall(function() logitech = require "lib/logitech" end) -- experimental

local libstatus, liberr = pcall(function() discord = require "lib/discordRPC" end)

if logistatus then
    logitech = require "lib/logitech"
else
    print("[WARNING!] Could not load Logitech lighting library: "..logierr)
    print("[WARNING!] This is normal if using the .love file.")
end

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

game.skins = {
    "Default"
}
game.skinIndex = 1

screen = love.graphics.newCanvas() -- testing this
screenX = 0
screenY = 0
screenCol = {1, 1, 1, 1}

controller = false
controllers = love.joystick.getJoysticks()

function doControllerCheck()
    local c, cs = false, love.joystick.getJoysticks()

    for i, pad in ipairs(cs) do
        c = true
        print(('Found a controller: %s'):format(pad:getName()))
    end
    print(('Controller status: %s'):format(tostring(c)))

    controller, controllers = c, cs
end

doControllerCheck()

love.joystickadded, love.joystickremoved = doControllerCheck, doControllerCheck

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
    "options",
    "controllerconfig"
}

gameToLogitechKeys = {
    up = "ARROW_UP",
    down = "ARROW_DOWN",
    left = "ARROW_LEFT",
    right = "ARROW_RIGHT",
    ["return"] = "ENTER"
}

local threadCode = [[
require 'love.timer'
local keys, gameToLogitechKeys = ...

for j, i in pairs(keys) do
    local key = gameToLogitechKeys[i] or i:upper()
    print(('[Thread] Setting %s to on'):format(key))
    love.thread.getChannel('lights'):push({key, 100, 100, 100})
    love.timer.sleep(0.2)
end
]]

startupLightEffectThread = love.thread.newThread(threadCode)

function killLighting()
    for _, i in pairs(logitech.keys) do
        logitech.setLightingForKey(i, 0, 0, 0)
    end
end

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

    -- SKIN SYSTEM GOES HERE

    for p, f in pairs(game.gfx) do -- handle gfx loading
        game.gfx[p] = love.graphics.newImage("assets/gfx/"..f)
    end

    local fs = love.filesystem.getDirectoryItems('assets/skins')
    for _, i in ipairs(fs) do
        print('found skin: '..i)
        if i ~= 'Default' then
            table.insert(game.skins, i)
        end
    end

    skin:load('Default')

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
        local p, r = love.filesystem.read('controller.psv')
        if p == nil then
            print('Controller input load failed. Ignoring.')
        else
            local t = json.decode(p)
            game.controllerMap = deepcopy(t)
        end
    end

    if logitech then
        logitech.init()
        love.timer.sleep(0.1) -- give it a sec to init
        print('[Logitech] Initialised successfully? '..tostring(logitech.initialised))
        startupLightEffectThread:start(game.keyMap, gameToLogitechKeys)
    end

    if runInputConfig then
        game:switchState("keyconfig", {"splash"})
    else
        game:switchState("splash")
    end
end

function love.update(dt)
    local lightMessage = love.thread.getChannel('lights'):pop()
    if lightMessage then
        logitech.setLightingForKey(unpack(lightMessage))
    end

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

    if logitech then
        print('[Logitech] Shutting down.')
        logitech.shutdown()
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

function love.gamepadpressed(p, b)
    if game.state and game.state.padDown then
        game.state:padDown(b)
    end
    game:doAltInput()
end
function love.gamepadreleased(p, b)
    if game.state and game.state.padUp then
        game.state:padUp(b)
    end
end

function love.keyreleased(k, sc)
    --game:keyUp(k, sc)
    if game.state and game.state.keyUp then
        game.state:keyUp(k, sc)
    end
end