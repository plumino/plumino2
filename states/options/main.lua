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
        name = "Sonic drop (TGM-style): {v}",
        aAction = function(self)
            optionFlags.sonicDrop = not optionFlags.sonicDrop
        end,
        value = function(self)
            return v(optionFlags.sonicDrop)
        end
    }
}