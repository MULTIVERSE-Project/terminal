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