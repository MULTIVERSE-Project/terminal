PANEL = {}

function PANEL:Init()
    self:SetTextColor(mvp.ui.config.colors.text)
    self:SetFont(mvp.ui.fonts.Get("default@18"))    
end

-- Some utility functions for labels
function PANEL:Font(...)
    self:SetFont(mvp.ui.fonts.Get(...))
end
function PANEL:Shadow(offset, color)
    offset = offset or 1
    color = color and (isnumber(color) and Color(0, 0, 0, color) or color) or Color(0, 0, 0, 150)

    self:SetExpensiveShadow(offset, color)
end

function PANEL:GetTextWidth()
    return select(1, self:GetTextSize())
end
function PANEL:GetTextHeight()
    return select(2, self:GetTextSize())
end
function PANEL:GetTextSize()
    surface.SetFont(self:GetFont())

    return surface.GetTextSize(self:GetText())
end

function PANEL:CenterText()
    self:SetContentAlignment(5)
end

mvp.ui.gui.Register("tui.Label", PANEL, "DLabel")