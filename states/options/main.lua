optionFlags = {
    hd = false,
    sonicDrop = false
}

local function v(a)
    if a then return "yes" else return "no" end
end

return {
    {
        name = "  [Controller/keyboard options]",
        unselectable = true
    },
    {
        name = "Key configuration menu (press A)",
        aAction = function(self) game:switchState("keyconfig") end
    },
    {
        name = "Controller configuration menu",
        aAction = function(self) game:switchState("controllerconfig") end
    },
    {
        name = "",
        unselectable = true,
    },
    {
        name = "  [Video options]",
        unselectable = true,
    },
    {
        name = "HD mode: {v}",
        aAction = function(self)
            optionFlags.hd = not optionFlags.hd
            local w, h = 1280, 720
            if not optionFlags.hd then
                w, h = 800, 600
            end
            love.window.setMode(w, h, {})
            screen = love.graphics.newCanvas()
            window.w, window.h = w, h
            ui.redefineVariables()
        end,
        value = function(self) return v(optionFlags.hd) end
    },
    {
        name = "Max framerate: {v} FPS",
        lAction = function(self)
            MAX_FPS = MAX_FPS - 1
            if MAX_FPS < 10 then
                MAX_FPS = 10
            end
        end,
        rAction = function(self)
            MAX_FPS = MAX_FPS + 1
        end,
        value = function(self) return MAX_FPS end
    },
    {
        name = "NOTE: If not set to 60 FPS, the game WILL NOT run correctly.",
        unselectable = true
    },
    {
        name = "NOTE2: looking at you nora",
        unselectable = true
    },
    {
        name = "",
        unselectable = true
    },
    {
        name = "  [Game options]",
        unselectable = true,
    },
    {
        name = "Sonic drop (TGM-style): {v}",
        aAction = function(self)
            optionFlags.sonicDrop = not optionFlags.sonicDrop
        end,
        value = function(self)
            return v(optionFlags.sonicDrop)
        end
    },
    {
        name = "Block skin: {v}",
        lAction = function(self)
            game.minoSkin = game.minoSkin - 1
            if game.minoSkin < 1 then
                game.minoSkin = #game.mino
            end
        end,
        rAction = function(self)
            game.minoSkin = game.minoSkin + 1
            if game.minoSkin > #game.mino then
                game.minoSkin = 1
            end
        end,
        value = function(self)
            return game.minoName[game.minoSkin]
        end
    },
    {
        name = "Game skin: {v}",
        lAction = function(self)
            game.skinIndex = game.skinIndex - 1
            if game.skinIndex < 1 then
                game.skinIndex = #game.skins
            end
            skin:load(game.skins[game.skinIndex])
        end,
        rAction = function(self)
            game.skinIndex = game.skinIndex + 1
            if game.skinIndex > #game.skins then
                game.skinIndex = 1
            end
            skin:load(game.skins[game.skinIndex])
        end,
        value = function(self)
            return game.skins[game.skinIndex]
        end
    },
    {
        name = "",
        unselectable = true
    },
    {
        name = "  [Misc]",
        unselectable = true,
    },
    {
        name = "Credits",
        aAction = function(self)
            game:switchState("credits")
        end
    }
}