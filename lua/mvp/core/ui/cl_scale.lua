mvp = mvp or {}
mvp.ui = mvp.ui or {}

mvp.ui.scalingCache = mvp.ui.scalingCache or {}
mvp.ui.scalingCacheUnrestricted = mvp.ui.scalingCacheUnrestricted or {}
mvp.ui.scalingWithFactorCache = mvp.ui.scalingWithFactorCache or {}

local scrH, max = ScrH, math.max

function mvp.ui.GetScaleFactor()
    return scrH() / 1080
end

function mvp.ui.Scale( value )
    if mvp.ui.scalingCache[ value ] then
        return mvp.ui.scalingCache[ value ]
    end

    mvp.ui.scalingCache[ value ] = max( value * ( mvp.ui.GetScaleFactor() ), 0 )
    return mvp.ui.scalingCache[ value ]
end

function mvp.ui.ScaleUnrestricted( value )
    if (mvp.ui.scalingCacheUnrestricted[ value ]) then
        return mvp.ui.scalingCacheUnrestricted[ value ]
    end

    mvp.ui.scalingCacheUnrestricted[ value ] = value * ( mvp.ui.GetScaleFactor() )

    return mvp.ui.scalingCacheUnrestricted[ value ]
end

--- Scale value, then round it to the nearest integer of factor of 2
function mvp.ui.ScaleWithFactor(value)

    if mvp.ui.scalingWithFactorCache[value] then
        return mvp.ui.scalingWithFactorCache[value]
    end

    local scaled = mvp.ui.Scale(value)
    local factor = 2 ^ math.floor(math.log(scaled) / math.log(2))

    mvp.ui.scalingWithFactorCache[value] = math.floor(scaled / factor + 0.5) * factor
    
    return mvp.ui.scalingWithFactorCache[value]
end

hook.Add("OnScreenSizeChanged", "mvp.ui.Scale", function()
    mvp.ui.scalingCache = {}
    mvp.ui.scalingWithFactorCache = {}
end)