local PANEL = {}

local roundness = mvp.ui.ScaleWithFactor(16)
local spaceBetween = mvp.ui.Scale(10)

AccessorFunc(PANEL, "useAnimations", "Animations", FORCE_BOOL)

function PANEL:Init()
    self._x, self._y = 0, 0
    self._w, self._h = 0, 0
    self.spaceBetween = spaceBetween * .75

    self.active = false

    self:SetCursor("hand")
    self:SetAnimations(true)

    self.backgroundColor = mvp.colors.Background
    self.iconColor = Color(187, 187, 187)

    self.colors = {}
    self.colors.Background = mvp.colors.Background
    self.colors.BackgroundHover = mvp.colors.BackgroundHover
    self.colors.Accent = mvp.colors.SecondaryAccent

    self.colors.Icon = Color(187, 187, 187)
    self.colors.IconHover = Color(255, 255, 255, 255)

    self.hint = vgui.Create("mvp.SidebarHint")
    self.hint:SetHintFor(self)
    -- self.hint:SetVisible(false)
end

function PANEL:OnRemove()
    self.hint:Remove()
end

function PANEL:DoClick(...)
    self:GetParent():OnButtonClickedInternal()
    self:SetActive(true)

    if (self.OnClicked) then
        self:OnClicked(...)
    end
end

function PANEL:SetActive(bool)
    self.active = bool

    if (not self:GetAnimations()) then
        return 
    end

    if bool then
        self:Lerp("_x", spaceBetween * 3, .2)
        self:LerpColor("backgroundColor", self.colors.Accent, .2)
        self:LerpColor("iconColor", self.colors.IconHover, .2)
    else
        self:Lerp("_x", 0, .2)
        self:LerpColor("backgroundColor", self.colors.Background, .2)
        self:LerpColor("iconColor", self.colors.Icon, .2)
    end
end

function PANEL:OnCursorEntered()
    self.hint:Lerp("alpha", 255, .2)
    if self.active then return end

    if (self:GetAnimations()) then
        self:Lerp("_x", spaceBetween * 3, .2)
    end

    self:LerpColor("backgroundColor", self.colors.BackgroundHover, .2)
    self:LerpColor("iconColor", self.colors.IconHover, .2)
end

function PANEL:OnCursorExited()
    self.hint:Lerp("alpha", 0, .2)

    if self.active then return end

    if (self:GetAnimations()) then
        self:Lerp("_x", 0, .2)
    end

    self:LerpColor("backgroundColor", self.colors.Background, .2)
    self:LerpColor("iconColor", self.colors.Icon, .2)
end

function PANEL:SetIcon(icon, matParams)
    if (type(icon) ~= "IMaterial" and not icon.isImage) then
        self.icon = Material(icon, matParams)
    else
        self.icon = icon
    end
end

function PANEL:SetText(text)
    self.hint:SetText(text)
end

function PANEL:Paint(w, h)
    local centerX = self._x + self._w * .5
    local centerY = self._y + self._h * .5

    draw.RoundedBox(roundness, self._x + self.spaceBetween, self._y + self.spaceBetween, self._w - self.spaceBetween * 2, self._h - self.spaceBetween * 2, self.backgroundColor)

    local iconSize = mvp.ui.Scale(28)
    if (self.icon and self.icon.isImage) then
        self.icon:Draw(centerX - iconSize / 2, centerY - iconSize / 2, iconSize, iconSize, self.iconColor)
    elseif (self.icon) then
        surface.SetDrawColor(self.iconColor)
        surface.SetMaterial(self.icon)
        surface.DrawTexturedRect(centerX - iconSize / 2, centerY - iconSize / 2, iconSize, iconSize)
    end

    return true
end

function PANEL:PerformLayout(w, h)
    self._w, self._h = w - spaceBetween * 3, h
end

vgui.Register("mvp.SidebarButton", PANEL, "DButton")