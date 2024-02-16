local PANEL = {}

local roundness = mvp.ui.ScaleWithFactor(16)
local spaceBetween = mvp.ui.Scale(10)


function PANEL:Init()
    self.sidebar = vgui.Create("mvp.Sidebar", self)
    self.sidebar:Dock(LEFT)
    self.sidebar:SetWide(64 + spaceBetween * 3)
    self.sidebar:SetZPos(99)

    self.sidebar.close.DoClick = function()
        self:Remove()
    end

    self.content = vgui.Create("EditablePanel", self)
    self.content:Dock(FILL)
    self.content:DockMargin(-spaceBetween * 3, 0, 0, 0)
    self.content:DockPadding(spaceBetween * 3, 5, spaceBetween, 5)

    self.content.Paint = function(pnl, w, h)
        draw.RoundedBox(roundness, 0, 0, w, h, mvp.colors.Background)
    end

    self.buttons = {}
end

function PANEL:Paint(w, h)
    draw.RoundedBox(roundness, 0, 0, w, h, mvp.colors.SecondaryBackground)
end

function PANEL:GetCanvas()
    self.content:InvalidateParent(true)
    return self.content
end

function PANEL:AddButton(text, icon, activeByDefault, callback)
    local iconParams = "mips smooth"

    if (type(icon) ~= "IMaterial") then
        icon = Material(icon, iconParams)
    end

    local c = function(...)
        self:GetCanvas():Clear()

        if (callback) then
            callback(...)
        end
    end

    local but = self.sidebar:AddButton(text, icon, iconParams, activeByDefault, c)

    self.buttons[text] = but

    return but
end

function PANEL:SelectButton(text, ...)
    local but = self.buttons[text]

    if (but) then
        but:DoClick(...)
    end
end

function PANEL:AddSeparator()
    return self.sidebar:AddSeparator()
end

vgui.Register("mvp.Menu", PANEL, "EditablePanel")