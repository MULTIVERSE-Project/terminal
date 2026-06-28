mvp = mvp or {}
mvp.meta = mvp.meta or {}
mvp.meta.theme = mvp.meta.theme or {}

mvp.meta.theme.__proto = mvp.meta.theme

function mvp.meta.theme:New(id)
    local o = table.Copy(mvp.meta.theme.__proto)

    setmetatable(o, mvp.meta.theme)
    o.__index = self

    if (id) then
        o:SetID(id)

        return o
    end

    local cwd = debug.getinfo(2, "S").short_src
    local themeFile = string.match(cwd, "mvp/themes/([^/]+)%.lua")

    o:SetID(themeFile)

    return o
end

AccessorFunc(mvp.meta.theme, "_id", "ID", FORCE_STRING)

mvp.meta.theme.__proto._name = "Unnamed theme"
AccessorFunc(mvp.meta.theme, "_name", "Name", FORCE_STRING)

mvp.meta.theme.__proto._description = "No description"
AccessorFunc(mvp.meta.theme, "_description", "Description", FORCE_STRING)

mvp.meta.theme.__proto._author = "Unknown"
AccessorFunc(mvp.meta.theme, "_author", "Author", FORCE_STRING)

mvp.meta.theme.__proto._version = "0.0.0"
AccessorFunc(mvp.meta.theme, "_version", "Version", FORCE_STRING)

mvp.meta.theme.__proto._license = "Unknown"
AccessorFunc(mvp.meta.theme, "_license", "License", FORCE_STRING)

mvp.meta.theme.__proto._colors = {}
function mvp.meta.theme:SetColor(key, color)
    self._colors = self._colors or {}
    self._colors[key] = color
end
function mvp.meta.theme:GetColor(key)
    if (self._colors and self._colors[key]) then
        return self._colors[key]
    end

    return nil
end

function mvp.meta.theme:ModifyColor(key, hue, saturation, lightness)
    local col = self:GetColor(key)
    if (not col) then return nil end

    local h, s, l = ColorToHSL(col)

    local modifiedColor = HSLToColor(hue or h, math.Clamp(saturation or s, 0, 1), math.Clamp(lightness or l, 0, 1))
    
    return modifiedColor
end

mvp.meta.theme.__proto._fonts = {}
function mvp.meta.theme:SetDefaultFont(fontData)
    self._fonts["default"] = fontData
end
function mvp.meta.theme:SetHeaderFont(fontData)
    self._fonts["header"] = fontData
end

function mvp.meta.theme:GetFont(type)
    type = type or "default"
    return self._fonts[type]
end