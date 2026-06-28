PANEL = {}

function PANEL:Init()
    self:SetTextColor(self:C("foreground"))
    self:SetFont(self:FF("default@500", 18))
end

function PANEL:Font(...)
    self:SetFont(self:F(...))
end

function PANEL:FFont(...)
    self:SetFont(self:FF(...))
end

function PANEL:Color(key, lightMod, alpha)
    self:SetTextColor(self:C(key, lightMod, alpha))
end

function PANEL:AlignText(a)
    self:SetContentAlignment(a)
end

function PANEL:CenterText()
    self:SetContentAlignment(5)
end

function PANEL:GetContentSize()
    surface.SetFont(self:GetFont())
    
    return surface.GetTextSize(self:GetText())
end
function PANEL:GetContentWidth()
    return select(1, self:GetContentSize())
end

mvp.ui.g.Register("mvp.v2.Label", PANEL, "DLabel")

mvp.ui.g.Register("mvp.v2.Panel", {Init = function() end}, "EditablePanel") -- lmao, don't want to create another file
