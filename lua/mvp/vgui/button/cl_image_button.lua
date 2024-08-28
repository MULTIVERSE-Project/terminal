local PANEL = {}

DEFINE_BASECLASS("mvp.Button")

function PANEL:Init()
    self:SetText("")

    self.image = Material("error")
    
    self.colors = self.colors or {}
    self.colors.Icon = Color(187, 187, 187)
    self.colors.IconHover = Color(255, 255, 255)

    self.iconColor = self.colors.Icon

    self.iconSize = 16
end

function PANEL:SetImage(image)
    self.image = image
end

function PANEL:SetIconSize(size)
    self.iconSize = size
end

function PANEL:Paint(w, h)
    BaseClass.Paint(self, w, h)

    surface.SetDrawColor(self.iconColor)
    surface.SetMaterial(self.image)
    
    local iconSize = self.iconSize
    local iconX = (w - iconSize) / 2
    local iconY = (h - iconSize) / 2

    surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
end

function PANEL:OnCursorEntered()
    BaseClass.OnCursorEntered(self)
    
    self:LerpColor("iconColor", self.colors.IconHover, .2)
end

function PANEL:OnCursorExited()
    BaseClass.OnCursorExited(self)
    
    self:LerpColor("iconColor", self.colors.Icon, .2)
end

function PANEL:PerformLayout(w, h)
    self.iconSize = h * .5
end

vgui.Register("mvp.ImageButton", PANEL, "mvp.Button")