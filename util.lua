function hue(c) -- shamelessly stolen from oshi's game (sorry if youre reading this but i cant figure out what this does lol)
	local i, f, g, h
	i, f = math.modf(c/60)
	g = 1-f
    f, g = 200*f+55, 200*g+55
    if i == 0 then h = {255, f, 55}
	elseif i == 1 then h = {g, 255, 55}
	elseif i == 2 then h = {55,	255, f}
	elseif i == 3 then h = {55,	g, 255}
	elseif i == 4 then h = {f, 55, 255}
	elseif i == 5 then h = {255, 55, g}
    else h = {255, 255, 255}
    end
    for k, l in ipairs(h) do  --  fix it for love 11 (ver plumino is built against)
        h[k] = l/255          --  just literally divide everything by 255 because screw it
    end
    return h
end

function mix(x, y, a)
    return x * (1-a) + y * a
end

function mix_v(x, y, a)
    local nt = {}
    for i, j in ipairs(x) do
        nt[i] = mix(j, y[i], a)  
    end
    return nt
end

function deepcopy(orig) -- thanks lua-users
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function tablecontains(tbl, element)
    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

function tableindex(tbl, el)
    for i, v in ipairs(tbl) do
        if v == el then
            return i
        end
    end
    return -1
end

function centerText(tx, fn)
    return (800/2)-(fn:getWidth(tx)/2)
end

function ternary(t, y, n)
    if t then return y else return n end
end

function versionString()
    local h = string.format("%d.%d%s (%s)", PLUMINO_VERSION[1], PLUMINO_VERSION[2], ternary(PLUMINO_DEV_BUILD, "-DEV", ""), PLUMINO_VERSION_CODENAME)
    return h
end