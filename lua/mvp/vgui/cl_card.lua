local PANEL = {}

local roundness = mvp.ui.ScaleWithFactor(16)

function PANEL:Init()
    self.colors = {}
    self.colors.Background = mvp.colors.Background
end

function PANEL:SetBackground(color)
    self.colors.Background = color
end

function PANEL:SetStyle(style)
    if (style == "primary") then
        self:SetBackground(mvp.colors.Background)
    elseif (style == "secondary") then
        self:SetBackground(mvp.colors.SecondaryBackground)
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(roundness, 0, 0, w, h, self.colors.Background)
end

vgui.Register("mvp.Card", PANEL, "EditablePanel")