local PANEL = {}

local Approach, abs, Clamp = math.Approach, math.abs, math.Clamp
local RealFrameTime = RealFrameTime

function PANEL:Init()
    mvp.ui.gui.Extend(self.btnGrip)

    self:SetHideButtons(true)

    self.backgroundColor = ColorAlpha(mvp.ui.config.colors.accent, 40)

    self.btnGrip.color = Color(0, 0, 0)
    self.btnGrip:Import("hover")
    self.btnGrip:SetColorKey("color")
    self.btnGrip:SetColorIdle(mvp.ui.config.colors.accent, -30)
    self.btnGrip.Paint = function(pnl, w, h)
        draw.RoundedBox(4, 0, 0, w, h, pnl.color)
    end

    self._current = 0
end

function PANEL:Think()
    local current = self._current
    local target = self.Scroll or 0

    self._current = Approach(current, target, 10 * abs(target - current) * RealFrameTime())

    if (current ~= target) then
        local parent = self:GetParent()
        local OnVScroll = parent and parent.OnVScroll

        if (OnVScroll) then
            OnVScroll(parent, self:GetOffset())
        end
    end
end

function PANEL:GetOffset()
    if (not self.Enabled) then return 0 end

    return self._current * -1
end

function PANEL:SetScroll(scrll)
    if (not self.Enabled) then self.Scroll = 0 return end

    self.Scroll = Clamp(scrll, 0, self.CanvasSize)

    self:InvalidateLayout()
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, self.backgroundColor)
end

function PANEL:OnMouseWheeled(delta)
    local hovered = vgui.GetHoveredPanel()

    if (IsValid(hovered) and hovered ~= self and hovered.OnMouseWheeled) then
        return 
    end

    self.BaseClass.OnMouseWheeled(self, delta)
end

mvp.ui.gui.Register("tui.Scroll.VBar", PANEL, "DVScrollBar")