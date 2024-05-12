mvp = mvp or {}
mvp.ui = mvp.ui or {}

local gradientMat = Material("gui/gradient.png")
function mvp.ui.DrawRoundedGradient( roundness, x, y, w, h, startColor, endColor )
    draw.RoundedBoxEx( roundness, x, y, w - roundness - 1, h, startColor, true, false, true, false )
    draw.RoundedBoxEx( roundness, roundness + 1, y, w - roundness - 1, h, endColor, false, true, false, true )

    draw.RoundedBoxEx( roundness, x + roundness, y, w - roundness * 2, h, endColor, false, false, false, false )
    surface.SetMaterial( gradientMat )
    surface.SetDrawColor( startColor )
    surface.DrawTexturedRect( x + roundness, y, w - roundness * 2, h )
end

mvp.ui.mutedColorsCache = {}

function mvp.ui.MuteColor(col, factor)
    factor = factor or 0.8
    local colId = col.r .. col.g .. col.b .. (col.a or 255) .. factor
    if (mvp.ui.mutedColorsCache[colId]) then
        return mvp.ui.mutedColorsCache[colId]
    end
    
    local newCol = Color(col.r * factor, col.g * factor, col.b * factor, col.a)

    mvp.ui.mutedColorsCache[colId] = newCol

    return newCol
end