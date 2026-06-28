mvp = mvp or {}
mvp.theme = mvp.theme or {}

mvp.theme.list = mvp.theme.list or {}

MVP_FONT_THIN = 100
MVP_FONT_EXTRALIGHT = 200
MVP_FONT_LIGHT = 300
MVP_FONT_REGULAR = 400
MVP_FONT_MEDIUM = 500
MVP_FONT_SEMIBOLD = 600
MVP_FONT_BOLD = 700
MVP_FONT_EXTRABOLD = 800
MVP_FONT_BLACK = 900

function mvp.theme.Register(theme)
    local id = theme:GetID()

    if (mvp.theme.list[id]) then
        mvp.logger.Log(mvp.LOG.WARN, "Themes", "Theme '" .. id .. "' already registered! Overwriting...")
        mvp.logger.Log(mvp.LOG.WARN, "Themes", "This is probably a bug! Since this should not happen outside of development!")

        mvp.logger.Log(mvp.LOG.DEBUG, nil, "ID: " .. id)

        mvp.theme.list[id] = nil
    end

    mvp.theme.list[id] = theme

    mvp.logger.Log(mvp.LOG.INFO, "Themes", "Registered theme '" .. id .. "@" .. theme:GetVersion() .. "'")
    hook.Run("mvp.theme.Registered", theme)
end

function mvp.theme.GetList()
    return mvp.theme.list
end

function mvp.theme.Get(id)
    return mvp.theme.list[id]
end

function mvp.theme.GetActiveID()
    return mvp.config.Get("theme", "default")
end
function mvp.theme.GetActive()
    return mvp.theme.Get(mvp.theme.GetActiveID()) 
end

function mvp.theme.Init()
    mvp.logger.Log(mvp.LOG.INFO, "Themes", "Initializing themes...")

    mvp.loader.LoadFolder("themes")

    hook.Run("mvp.theme.Ready")

    mvp.logger.Log(mvp.LOG.INFO, "Themes", "Initialized themes!")
end

mvp.theme._colorsCache = {}
function mvp.theme.Color(key, lightMod, alpha)
    local theme = mvp.theme.GetActive()
    if (not theme) then return nil end

    local col = theme:GetColor(key)
    if (not col) then
        debug.Trace()
        -- PrintTable(key)
        print("mvp.theme.Color: Color key '" .. key .. "' not found in theme '" .. theme:GetID() .. "'")
        return color_white
    end
    local cacheKey = col.r .. "-" .. col.g .. "-" .. col.b .. "-" .. tostring(lightMod) .. "-" .. tostring(alpha)

    if (mvp.theme._colorsCache[cacheKey]) then
        return mvp.theme._colorsCache[cacheKey]
    end

    if (not col) then return nil end

    if (lightMod) then
        col = theme:ModifyColor(key, nil, nil, lightMod)
    end
    
    if (alpha) then
        col = ColorAlpha(col, alpha)
    end

    mvp.theme._colorsCache[cacheKey] = col

    return col
end
mvp.C = mvp.theme.Color -- shortcut

if (CLIENT) then -- fonts only on client
    mvp.theme._fontsCache = {}

    function mvp.theme.GetFont(size, font, weight, params)
        local scale = mvp.ui.Scale(size)

        return mvp.theme.GetFontUnscaled(scale, font, weight, params)
    end

    function mvp.theme.GetFontUnscaled(size, font, weight, params)
        size = math.floor(size)
        
        local fontName = tostring(mvp.utils.Hash(font .. "_" .. size .. "_" .. weight .. (params and table.ToString(params) or "")))
        
        if (mvp.theme._fontsCache[fontName]) then
            return mvp.theme._fontsCache[fontName]
        end

        local fontData = {
            font = font,
            size = size,
            weight = weight,
            extended = true,
        }
        if (params) then
            for k, v in pairs(params) do
                fontData[k] = v
            end
        end

        surface.CreateFont(fontName, fontData)

        mvp.theme._fontsCache[fontName] = fontName

        return fontName
    end

    function mvp.theme.GetFontSize(text, font)
        surface.SetFont(font)
        return surface.GetTextSize(text)
    end

    local textToWeight = {
        ["thin"] = MVP_FONT_THIN,
        ["extralight"] = MVP_FONT_EXTRALIGHT,
        ["light"] = MVP_FONT_LIGHT,
        ["regular"] = MVP_FONT_REGULAR,
        ["medium"] = MVP_FONT_MEDIUM,
        ["semibold"] = MVP_FONT_SEMIBOLD,
        ["bold"] = MVP_FONT_BOLD,
        ["extrabold"] = MVP_FONT_EXTRABOLD,
        ["black"] = MVP_FONT_BLACK
    }

    -- Font pattern: fontType@weight
    function mvp.theme.Font(pattern, size, unscaled, fromFigma, params)
        local theme = mvp.theme.GetActive()
        if (not theme) then return nil end

        if (fromFigma) then
            size = size + 4
        end

        pattern = string.Explode("@", pattern)
        
        local font, weight = pattern[1], tonumber(pattern[2])
        if (not weight) then
            local weightStr = string.lower(pattern[2] or "regular")
            weight = textToWeight[weightStr] or MVP_FONT_REGULAR
        end

        if (theme._fonts[font] == nil) then
            return mvp.theme[unscaled and "GetFontUnscaled" or "GetFont"](size, font, weight, params)
        end

        local fontData = theme:GetFont(font)
        local fontName = fontData.font

        if (fontData.weights and fontData.weights[weight]) then
            fontName = fontData.font .. " " .. fontData.weights[weight]
        end

        return mvp.theme[unscaled and "GetFontUnscaled" or "GetFont"](size, fontName, weight, params)
    end
    mvp.F = mvp.theme.Font -- shortcut
    mvp.FF = function(pattern, size, unscaled, params)
        return mvp.theme.Font(pattern, size, unscaled, true, params)
    end
end

mvp.theme.hooks = mvp.theme.hooks or {}
-- function to get theme colors
function mvp.theme.Hook(id, init, callAfterInit)
    if (not mvp.theme.hooks[id]) then
        mvp.theme.hooks[id] = {}
    end

    local isConfigLoaded = mvp.config.GetStored("theme")
    local f = function()
        if (init) then mvp.theme.hooks[id] = init() end

        if (callAfterInit) then
            callAfterInit(mvp.theme.hooks[id])
        end
    end

    if (isConfigLoaded) then
        f()

        hook.Add("mvp.theme.Changed", "mvp.theme.Hook." .. id, f)
        hook.Add("mvp.config.Synchronized", "mvp.theme.Hook." .. id, f)
    else
        hook.Add("mvp.config.Inited", "mvp.theme.Hook." .. id, function()
            f()

            hook.Add("mvp.theme.Changed", "mvp.theme.Hook." .. id, f())
            hook.Add("mvp.config.Synchronized", "mvp.theme.Hook." .. id, f())
        end)
    end

    return mvp.theme.hooks[id]
end