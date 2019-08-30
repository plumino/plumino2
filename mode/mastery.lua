return {
    name = "Mastery",
    init = function(self)
        self.level = 0
        self.section = 0
        self.nextsection = (self.section * 100)
        self.gm300 = false
        self.gm500 = false

        self.gravity = {
            4, 6, 8, 10, 12, 16, 32, 48, 64, 80, 96, 112, 128, 144,
            4, 32, 64, 96, 128, 160, 192, 224, 256, 512, 768, 1024,
            1280, 1024, 768, math.huge
        }
        self.gravlevels = {
            0, 30, 35, 40, 50, 60, 70, 80, 90, 100,
            120, 140, 160, 170, 200, 220, 230, 233, 236,
            239, 243, 247, 251, 300, 330, 360, 400, 420, 450, 500
        }

        self.score = 0
        self.grades = {
            400, 800, 1400, 2000, 3500, 5500, 8000, 12000, 16000, 22000, 30000, 40000, 52000, 66000, 82000, 100000, 120000
        }
        self.gradenames = {
            "8", "7", "6", "5", "4", "3", "2", "1", "S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9", "GM"
        }
        self.grade = 0

        -- game.speeds = {

        -- }
    end,

    draw = function(self)
        ui.drawScoreFont('Points', 2)
        ui.drawScoreFont(tostring(self.score), 3)
        ui.drawScoreFont('Next grade at', 4)
        local a = '??????'
        if self.grades[self.score] 
    end
}