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
            30, 35, 40, 50, 60, 70, 80, 90, 100,
            120, 140, 160, 170, 200, 220, 230, 233, 236,
            239, 243, 247, 251, 300, 330, 360, 400, 420, 450, 500, 10000
        }
        self.gravpointer = 1

        self.score = 0
        self.grades = {
            400, 800, 1400, 2000, 3500, 5500, 8000, 12000, 16000, 22000, 30000, 40000, 52000, 66000, 82000, 100000, 120000
        }
        self.gradenames = {
            "8", "7", "6", "5", "4", "3", "2", "1", "S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9", "GM"
        }
        self.grade = 0

        game.speeds = {
            gravity = self.gravity[self.gravpointer]/256,
            are = 30,
            das = 16,
            lockDelay = 30,
            lineAre = 46
        }
    end,
    linesCleared = function(self, lines)
        if (self.level % 100 ~= 99 and lines == 0) or (self.level % 100 == 99 and lines > 0) then
            self.level = self.level + 1
        end
    end,
    draw = function(self)
        ui.drawScoreText('Mastery', 0)

        ui.drawScoreText('Points', 2)
        ui.drawScoreText(tostring(self.score), 3)
        ui.drawScoreText('Next grade at', 4)
        local a = '??????'
        if self.grades[self.grade] then
            a = self.grades[self.grade]
        end
        ui.drawScoreText(a, 5)
        ui.drawScoreText('Points', 6)

        ui.drawScoreText('Level', 8)
        ui.drawScoreText(self.level .. '/' .. self.nextsection, 9)
    end
}