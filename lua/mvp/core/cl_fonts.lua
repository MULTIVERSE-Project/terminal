mvp = mvp or {}
mvp.fonts = mvp.fonts or {}

mvp.fonts.list = mvp.fonts.list or {}

function mvp.fonts.Get(size, font, weight)
    local scale = mvp.ui.Scale(size)

    return mvp.fonts.GetUnscaled(scale, font, weight)
end

function mvp.fonts.GetUnscaled(size, font, weight)
    local fontName = font .. "_" .. size .. "_" .. weight

    if mvp.fonts.list[fontName] then
        return mvp.fonts.list[fontName]
    end

    local fontData = {
        font = font,
        size = size,
        weight = weight,
        extended = true,
        -- antialias = true,
    }

    surface.CreateFont(fontName, fontData)

    mvp.fonts.list[fontName] = fontName

    return fontName    
end

local weightToName = {
    [100] = "Proxima Nova Th",
    [200] = "Proxima Nova Lt",
    [300] = "Proxima Nova Lt",
    [400] = "Proxima Nova Rg",
    [500] = "Proxima Nova Rg",
    [600] = "Proxima Nova Semibold",
    [700] = "Proxima Nova Bold",
    [800] = "Proxima Nova Extrabold",
    [900] = "Proxima Nova Bl"
}

function mvp.Font(size, weight)
    return mvp.fonts.Get(size, weightToName[weight] or "Proxima Nova Rg", weight)
end