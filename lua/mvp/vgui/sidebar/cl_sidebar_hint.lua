local PANEL = {}

local roundness = mvp.ui.ScaleWithFactor(16)
local spaceBetween = mvp.ui.Scale(10)

local sidebarHintFont = mvp.Font(16, 500)

AccessorFunc(PANEL, "hintFor", "HintFor")
AccessorFunc(PANEL, "text", "Text")

function PANEL:Init()
    self.text = "Sidebar"
    self.alpha = 0

    self:SetZPos(100)
end

function PANEL:Paint(w, h)
    surface.SetAlphaMultiplier(self.alpha / 255)

    draw.RoundedBox(h * .5 - 5, 0, 0, w, h, mvp.colors.Background)
    draw.SimpleText(self.text, sidebarHintFont, spaceBetween, h / 2, mvp.colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    surface.SetAlphaMultiplier(1)
    return true
end

function PANEL:PerformLayout(w, h)
    surface.SetFont(sidebarHintFont)
    
    local textWidth, textHeight = surface.GetTextSize(self.text)
    
    self:SetWide(textWidth + spaceBetween * 2)
end

function PANEL:Think()
    local x, y  = self:GetHintFor():LocalToScreen(0, 0)
    local w, h = self:GetHintFor():GetSize()
    local sW, sH = self:GetSize()
    
    self:SetPos(x - sW - 10, y + h * .5 - sH * .5)
end

vgui.Register("mvp.SidebarHint", PANEL, "EditablePanel")