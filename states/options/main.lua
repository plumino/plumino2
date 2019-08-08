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

        end,
        rAction = function(self)

        end,
        value = function(self) return MAX_FPS end
    },
    {
        name = "NOTE: If not set to 60 FPS, the game WILL NOT run correctly.",
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
    }
}