--[[ 
    Scale library for Terminal UI (mvp.ui)
    This library provides functions to scale UI elements based on the screen resolution.
    It caches the calculated scale values to improve performance.
]]

mvp.ui = mvp.ui or {}
mvp.ui.fonts = mvp.ui.fonts or {}

mvp.ui.fonts.list = mvp.ui.fonts.list or {}

local table_ToString = table.ToString
local table_Merge = table.Merge
local surface_CreateFont = surface.CreateFont
local string_Explode = string.Explode
local tonumber = tonumber

local config = mvp.ui.config.fonts

local function getFontName(font, weight)
    local fontConfig = config[font] or config["default"]
    local fontName = fontConfig.font .. " " .. (fontConfig.weights[weight] or fontConfig.weights[500])
    
    return fontName
end

local function createFont(font, size, params, unscaledSize)
    local fontName = font .. "_" .. size .. "_" .. (params and table_ToString(params) or "")
    local hashedFont = "mvp." .. mvp.utils.Hash(fontName)

    if (mvp.ui.fonts.list[hashedFont]) then
        return hashedFont
    end

    local fontData = {
        font = font,
        size = size,
        extended = true,

        unscaledSize = unscaledSize,
    }
    table_Merge(fontData, params or {})

    surface_CreateFont(hashedFont, fontData)
    mvp.ui.fonts.list[hashedFont] = fontData
    
    return hashedFont
end

function mvp.ui.fonts.Get(pattern, weight, params)
    weight = weight or 500
    local parts = string_Explode('@', pattern)

    local font, size = getFontName(parts[1], weight), tonumber(parts[2])
    local scaledSize = mvp.ui.scale.GetScale(size)

    return createFont(font, scaledSize, params, size)
end