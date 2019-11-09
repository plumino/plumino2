skin = {
    current = "default"
}

function skin:load(name)
    print('Attempting to load skin \''..name..'\'...!')

    local mstr, serror = love.filesystem.read(('assets/skins/%s/meta.json'):format(name))
    if mstr == nil then
        error(('Skin folder with name \'%s\' is malformed! Could not open meta.json file!\nFile error: '):format(name, serror))
        return
    end
    local meta = json.decode(mstr)
    print(('Skin metadata load successful! This skin is:\n - %s, by %s'):format(meta.name, meta.author))

    self.meta = meta
    self.name = meta.name
    self.author = meta.author

    local folder = ('assets/skins/%s'):format(name)

    if meta.background then
        for p, f in ipairs(meta.background) do -- handle gfx loading
            game.background[p] = love.graphics.newImage(folder.."/bg/"..f)
        end
    end

    if meta.audio and meta.audio.sfx then
        for p, f in pairs(meta.audio.sfx) do -- handle sfx loading
            game.sfx[p] = love.audio.newSource(folder.."/sfx/"..f, "static")
        end
    end

    if meta.audio and meta.audio.clear then
        for p, f in ipairs(meta.audio.clear) do -- handle sfx loading
            game.clearaudio[p] = love.audio.newSource(folder.."/sfx/clear/"..f, "static")
        end
    end

    if love.filesystem and love.filesystem.getInfo then -- fix crash on some platforms
        if love.filesystem.getInfo(folder.."/bgm", "directory") and meta.bgm then
            for p, f in ipairs(meta.bgm) do -- handle bgm loading
                game.bgm[p] = love.audio.newSource(folder.."/bgm/"..f, "stream")
                game.bgm[p]:setLooping(true)
            end
        end
    end

    if love.filesystem.getInfo(folder.."/font.ttf", 'file') then
        game.font = {
            big = love.graphics.newFont(folder.."/font.ttf", 36),
            std = love.graphics.newFont(folder.."/font.ttf", 14),
            med = love.graphics.newFont(folder.."/font.ttf", 20),
            med2 = love.graphics.newFont(folder.."/font.ttf", 24),
            med3 = love.graphics.newFont(folder.."/font.ttf", 26)
        }
    else
        game.font = {
            big = love.graphics.newFont("assets/font/standard.ttf", 36),
            std = love.graphics.newFont("assets/font/standard.ttf", 14),
            med = love.graphics.newFont("assets/font/standard.ttf", 20),
            med2 = love.graphics.newFont("assets/font/standard.ttf", 24),
            med3 = love.graphics.newFont("assets/font/standard.ttf", 26)
        }
    end

    if love.filesystem.getInfo(folder..'/gfx/logo.png', 'file') then
        game.gfx.logo = love.graphics.newImage(folder..'/gfx/logo.png')
    else
        game.gfx.logo = love.graphics.newImage('assets/gfx/logo.png')
    end

    game.minoSkin = 1

    if meta.mino then
        for p, f in ipairs(meta.mino) do -- handle bgm loading
            game.mino[p] = love.graphics.newImage(folder.."/mino/"..f.file)
            game.minoName[p] = f.name
        end
    end
end