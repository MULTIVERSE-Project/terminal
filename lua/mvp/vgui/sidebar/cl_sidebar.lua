local PANEL = {}

local roundness = mvp.ui.ScaleWithFactor(16)
local spaceBetween = mvp.ui.Scale(10)

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

    self.close:SetText(mvp.q.Lang("ui.general.close"))

    self.close.colors.BackgroundHover = mvp.colors.Red
end

function PANEL:AddButton(text, icon, matParams, onClicked, activeByDefault)
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