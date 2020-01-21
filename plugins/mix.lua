return {
    name = "Stack height colouring",
    getPieceColour = function(self, x, y, d)
        return mix_v({1, 0, 0}, {0, 1, 0}, y/(game.playfieldDimensions.y+game.invisrows))
    end
}