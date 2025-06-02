mvp.ui = mvp.ui or {}
mvp.ui.scale = mvp.ui.scale or {}

mvp.ui.scale.cache = {
    x = {},
    y = {}
}

-- Design reference resolution
mvp.ui.scale._baseWidth = 1920
mvp.ui.scale._baseHeight = 1080

-- @notes: used for caching the calculated scale values
mvp.ui.scale._calculatedX = nil
mvp.ui.scale._calculatedY = nil

local ScrW, ScrH = ScrW, ScrH
local math_Round, math_min = math.Round, math.min

function mvp.ui.scale.GetScaleX(value)
    if mvp.ui.scale.cache.x[value] then
        return mvp.ui.scale.cache.x[value]
    end

    local scaleX = mvp.ui.scale._calculatedX
    if (not scaleX) then
        mvp.ui.scale._calculatedX = ScrW() / mvp.ui.scale._baseWidth
        scaleX = mvp.ui.scale._calculatedX
    end

    local scaledValue = math_Round(value * scaleX)
    mvp.ui.scale.cache.x[value] = scaledValue

    return scaledValue
end

function mvp.ui.scale.GetScaleY(value)
    if mvp.ui.scale.cache.y[value] then
        return mvp.ui.scale.cache.y[value]
    end

    local scaleY = mvp.ui.scale._calculatedY
    if (not scaleY) then
        mvp.ui.scale._calculatedY = ScrH() / mvp.ui.scale._baseHeight
        scaleY = mvp.ui.scale._calculatedY
    end

    local scaledValue = math_Round(value * scaleY)
    mvp.ui.scale.cache.y[value] = scaledValue

    return scaledValue
end

function mvp.ui.scale.GetScale(value)
    local scaleX = mvp.ui.scale.GetScaleX(value)
    local scaleY = mvp.ui.scale.GetScaleY(value)
    
    return math_min(scaleX, scaleY)
end

hook.Add("OnScreenSizeChanged", "mvp.ui.scale.ResetCache", function()
    mvp.ui.scale.cache = {
        x = {},
        y = {}
    }
    
    mvp.ui.scale._calculatedX = nil
    mvp.ui.scale._calculatedY = nil
end)