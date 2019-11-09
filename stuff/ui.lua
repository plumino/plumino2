ui = {}

local minoDim = 16

local tx = (game.playfieldDimensions.x * minoDim)
local ty = (game.playfieldDimensions.y * minoDim)
local CENTER_X = (window.w-tx)/2
local CENTER_Y = (window.h-ty)/2

local RIGHT_OF_FIELD = (window.w/2)+(tx/2)+10

function ui.redefineVariables()
    CENTER_X = (window.w-tx)/2
    CENTER_Y = (window.h-ty)/2
    local a = tx
    if game.playfieldDimensions.x <= 10 then
        a = a / 2
    end

    RIGHT_OF_FIELD = (window.w/2)+(a)+10
end

function ui.drawScoreText(text, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(game.font.med)
    love.graphics.print(text, RIGHT_OF_FIELD, (CENTER_Y)+(game.font.med:getHeight(text) * y))
end