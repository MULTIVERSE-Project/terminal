local PANEL = {}

AccessorFunc(PANEL, "_colIdle", "ColorIdle")
AccessorFunc(PANEL, "_colHover", "ColorHover")
AccessorFunc(PANEL, "_colPressed", "ColorPressed")
AccessorFunc(PANEL, "_colGradient", "GradientColor")

AccessorFunc(PANEL, "_gradientDirection", "GradientDirection", FORCE_NUMBER)

function PANEL:Init()
    self:Feature("click")
    self:Feature("hover")

    self:AddHoverSound()

    self:SetTall(mvp.ui.scale.GetScaleY(24))
    self:CenterText()

    local _SetColorIdle = self.SetColorIdle
    self.SetColorIdle = function(pnl, color, offset)
        _SetColorIdle(pnl, color, offset)

        local _h, _s, v = ColorToHSV(color)
        if (v > .5) then
            pnl:SetTextColor(mvp.ui.config.colors.textDark)
        else
            pnl:SetTextColor(mvp.ui.config.colors.text)
        end
    end

    self:SetColorKey("backgroundColor")
    self:SetColorIdle(mvp.ui.config.colors.accent, 35)
    self:SetGradientDirection(RIGHT)

    self:Font("default@18", 600)
end

function PANEL:Paint(w, h)
    local backgroundColor = self.backgroundColor
    local outlineThickness = 1
    local outlineColor = mvp.ui.utils.EditHSVColor(backgroundColor, nil, nil, 0.33)

    if (self:GetGradientColor() and not self:GetDisabled()) then
        local gradientColor = self:GetGradientColor()
        local secondOutlineColor = mvp.ui.utils.EditHSVColor(gradientColor, nil, nil, 0.33)

        mvp.ui.utils.DrawDermaGradient(8, 0, 0, w, h, self:GetGradientDirection(), secondOutlineColor, outlineColor)
        mvp.ui.utils.DrawDermaGradient(8, outlineThickness, outlineThickness, w - outlineThickness * 2, h - outlineThickness * 2, self:GetGradientDirection(), backgroundColor, gradientColor)
    else
        draw.RoundedBox(8, 0, 0, w, h, outlineColor)
        draw.RoundedBox(8, outlineThickness, outlineThickness, w - outlineThickness * 2, h - outlineThickness * 2, backgroundColor)
    end
end

function PANEL:OnDisabled()
    local oldColorIdle, oldColorHover = self:GetColorIdle(), self:GetColorHover()

    local col = mvp.ui.config.colors.gray
    self:SetColorIdle(col, -50)
    self:SetTextColor(mvp.ui.utils.EditHSVColor(col, nil, nil, 0.60))
    
    self.oldColorIdle = oldColorIdle
    self.oldColorHover = oldColorHover
end
function PANEL:OnEnabled()
    if (self.oldColorIdle) then
        self:SetColorIdle(self.oldColorIdle)
    end
    if (self.oldColorHover) then
        self:SetColorHover(self.oldColorHover)
    end
end

mvp.ui.gui.Register("tui.Button", PANEL, "tui.Label")

PANEL = {}

function PANEL:Init()
    self:SetColorIdle(mvp.ui.config.colors.textMuted)
    self:SetColorHover(mvp.ui.config.colors.accent)

    self:SetTextColor(mvp.ui.config.colors.text)
    self:SetContentAlignment(4)

    self.iconSize = mvp.ui.scale.GetScaleY(16)
end

function PANEL:Paint(w, h)
    -- draw.RoundedBox(8, 0, 0, w, h, mvp.ui.config.colors.accent)

    draw.RoundedBox(0, w - self.iconSize, h * 0.5 - self.iconSize * 0.5, self.iconSize, self.iconSize, self.backgroundColor)
end

function PANEL:PerformLayout(w, h)
    local textW, textH = self:GetTextSize()

    if (w ~= textW + self.iconSize + mvp.ui.scale.GetScaleX(5)) then
        self:SetWide(textW + self.iconSize + mvp.ui.scale.GetScaleX(5))
    end
end

mvp.ui.gui.Register("tui.EditButton", PANEL, "tui.Button")

RunConsoleCommand("mvp_perfectparty_open_menu", "active_party")

-- mvp.ui.gui.Test("mvp.Frame", 800, 600, function(pnl, w, h)
--     pnl:MakePopup()
--     -- pnl:Focus()

--     for i = 1, 10 do
--         local btn = pnl:Add("mvp.Button")
--         btn:Dock(TOP)
--         btn:DockMargin(10, 10, 10, 0)
--         btn:SetText("Button " .. i)
--         btn:SetTall(mvp.ui.scale.GetScaleY(32))

--         if (i % 2 == 0) then
--             btn:SetDisabled(true)
--             btn:SetGradientColor(Color(255, 0, 0))
--         end
--     end
-- end)