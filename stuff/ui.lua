ui = {}

local minoDim = 16

local tx = (game.playfieldDimensions.x * minoDim)
local ty = (game.playfieldDimensions.y * minoDim)

local CENTER_X = (800-tx)/2
local CENTER_Y = (600-ty)/2

local RIGHT_OF_FIELD = (CENTER_X+(CENTER_X/2))+10

function ui.drawScoreText(text, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(game.font.med)
    love.graphics.print(text, RIGHT_OF_FIELD, (CENTER_Y)+(game.font.med:getHeight(text) * y))
end