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

PANEL = {}

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
    if (type(icon) == "string") then
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

    if (self.icon) then
        surface.SetDrawColor(self.iconColor)
        surface.SetMaterial(self.icon)
        
        local iconSize = mvp.ui.Scale(28)

        surface.DrawTexturedRect(centerX - iconSize / 2, centerY - iconSize / 2, iconSize, iconSize)
    end

    return true
end

function PANEL:PerformLayout(w, h)
    self._w, self._h = w - spaceBetween * 3, h
end

vgui.Register("mvp.SidebarButton", PANEL, "DButton")

PANEL = {}

function PANEL:Init()
    self.backgroundColor = mvp.colors.BackgroundHover

    self.colors = {}
    self.colors.Background = mvp.colors.BackgroundHover
end

function PANEL:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, self.backgroundColor)

    return true
end

vgui.Register("mvp.SidebarSeparator", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
    self.buttons = {}

    self.close = vgui.Create("mvp.SidebarButton", self)
    self.close:Dock(BOTTOM)
    self.close:InvalidateParent(true)
    self.close:SetTall(self.close:GetWide())
    self.close:SetAnimations(false)
    self.close:SetIcon("mvp/terminal/close.png", "smooth")

    self.close:SetText("Close")

    self.close.colors.BackgroundHover = mvp.colors.Red
end

function PANEL:AddButton(text, icon, matParams, activeByDefault, onClicked)
    local button = vgui.Create("mvp.SidebarButton", self)
    button:Dock(TOP)
    button:DockMargin(0, 0, 0, 0)
    button:InvalidateParent(true)
    button:SetTall(button:GetWide() - spaceBetween * 3)
    button:SetIcon(icon, matParams)
    button:SetText(text)

    button.OnClicked = onClicked

    if (activeByDefault) then
        button:SetActive(true)

        if (onClicked) then
            onClicked()
        end
    end

    table.insert(self.buttons, button)

    return button
end

function PANEL:AddSeparator()
    local separator = vgui.Create("mvp.SidebarSeparator", self)
    separator:Dock(TOP)
    separator:DockMargin(spaceBetween, spaceBetween * .5, spaceBetween * 3 + spaceBetween, spaceBetween * .5)
    separator:InvalidateParent(true)
    separator:SetTall(2)

    return separator
end

function PANEL:OnButtonClickedInternal()
    for k, v in pairs(self.buttons) do
        v:SetActive(false)
    end
end

function PANEL:PerformLayout()
end

vgui.Register("mvp.Sidebar", PANEL, "EditablePanel")