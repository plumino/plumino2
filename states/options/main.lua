optionFlags = {
    hd = false,
    sonicDrop = false
}

local function v(a)
    if a then return "yes" else return "no" end
end

return {
    {
        name = "Key configuration menu (press A)",
        aAction = function(self) game:switchState("keyconfig") end
    },
    {
        name = "",
        unselectable = true,
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
        name = "",
        unselectable = true
    },
    {
        name = "Credits",
        aAction = function(self)
            game:switchState("credits")
        end
    }
}