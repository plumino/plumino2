local inspect = require "lib/inspect"

return {
    name = "Squirrels",
    init = function(self)
        self.section = 1
        self.clears = 0

        self.scoreA = 1
        self.scoreB = 0
        self.scoreC = 0
        self.grade = 0

        self.currentSectionTime = 0

        self.tasks = {}

        self.grades = {
            "J", "I", "H", "G", "F", "E", "D", "C", "B", "A",
            "alpha", "beta", "gamma", "delta", "epsilon", "zeta",
            "eta", "theta", "iota", "kappa", "lambda", "mu", "nu",
            "omicron", "pi", "rho", "sigma", "tau", "upsilon", "phi",
            "chi", "psi", "omega",
            "M1", "M2", "M3", "M4", "M5", "M6", "M7", "M8", "M9",
            "X-E", "X-D", "X-C", "X-B", "X-A", "X-M", "X-GM"
        }

        self.speedcurve = { -- Gravity, ARE, Line ARE, lock
            {1/64, 10, 20, 30},
            {1/32, 10, 20, 30},
            {1/8, 8, 18, 30},
            {1/4, 6, 16, 40},
            {1/3, 6, 16, 40},
            {1/2, 6, 16, 40},
            {1, 6, 16, 40},
            {1.5, 6, 16, 40},
            {2, 6, 16, 40},
            {20, 6, 16, 40}
        }

        game.speeds.gravity = self.speedcurve[self.section][1]
        game.speeds.are = self.speedcurve[self.section][2]
        game.speeds.lineAre = self.speedcurve[self.section][3]
        game.speeds.lockDelay = self.speedcurve[self.section][4]
        game.speeds.das = 10

        game.movereset = true

        self.pieces = {}
        for i, _ in pairs(rotations[game.rotsys].structure) do
            table.insert(self.pieces, i)
        end

        print(inspect(self.pieces))
        self:generateTasks()
    end,
    generateTask = function(self)
        local number = love.math.random(1, 4)
        local piece = self.pieces[math.random(1, #self.pieces)]
        local output = {}
        output.num = number
        if self.section >= 6 and love.math.random(1, 10) == 1 then
            output.piece = piece
        end
        return output
    end,
    generateTasks = function(self)
        for i=1,3 do
            if not self.tasks[i] then
                table.insert(self.tasks, i, self:generateTask())
            end
        end
    end,
    stringTasks = function(self)
        local e = ""
        for _, i in ipairs(self.tasks) do
            e = e .. tostring(i.num)
            if i.piece then
                e = e .. "-"..tostring(i.piece)
            end
            e = e .. "\n"
        end
        return e
    end,
    update = function(self)
        self.currentSectionTime = self.currentSectionTime + 1

        self.grade = math.floor(self.scoreA + self.scoreB + self.scoreC)
    end,
    linesCleared = function(self, lines)
        if lines > 0 then
            self.clears = self.clears + 1
            if self.clears > 14 then
                self.clears = 0
                self.section = self.section + 1
                if self.currentSectionTime < 5400 then -- 1 minute and a half
                    self.scoreB = self.scoreB + 1
                end
            end
            if self.section > #self.speedcurve then
                game.won = true
                game:killPlayer()
            else
                game.speeds.gravity = self.speedcurve[self.section][1]
                game.speeds.are = self.speedcurve[self.section][2]
                game.speeds.lineAre = self.speedcurve[self.section][3]
                game.speeds.lockDelay = self.speedcurve[self.section][4]
            end

            for i, j in ipairs(self.tasks) do
                if j.num == lines then
                    if j.piece and j.piece ~= game.piece.name then
                        self.scoreC = self.scoreC + 0.25
                    end
                    self.scoreA = self.scoreA + 0.25
                    table.remove(self.tasks, i)
                    self:generateTasks()
                    return
                end
            end
            table.remove(self.tasks, 1)
            self:generateTasks()
        end
    end,
    draw = function(self)
        ui.drawScoreText("Squirrels", 0)

        if game.gameOver then
            ui.drawScoreText("Grade", 2)
            ui.drawScoreText(self.grades[self.grade], 3)
        end

        ui.drawScoreText("Progress", 5)
        ui.drawScoreText(string.format("%d-%d", self.section, self.clears), 6)

        ui.drawScoreText("Tasks", 8)
        ui.drawScoreText(self:stringTasks(), 9)
    end,
    getPresenceText = function(self)
        return tostring(game.stats.pieceLocks) .. " blocks dropped"
    end
}