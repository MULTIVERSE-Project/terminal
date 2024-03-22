local PANEL = {}

local roundness = mvp.ui.ScaleWithFactor(16)

AccessorFunc(PANEL, "roundness", "Roundness")

function PANEL:Init()
    self.colors = {}
    self.colors.Background = mvp.colors.Background

    self:SetRoundness(roundness)
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
    draw.RoundedBox(self.roundness, 0, 0, w, h, self.colors.Background)
end

vgui.Register("mvp.Card", PANEL, "EditablePanel")

local PANEL = {}

local roundness = mvp.ui.ScaleWithFactor(16)
local titleFont = mvp.Font(28, 600)

function PANEL:Init()
    self.colors = {}
    self.colors.Background = mvp.ui.MuteColor(mvp.colors.SecondaryBackground)

    self.top = vgui.Create("DPanel", self)
    self.top:Dock(TOP)
    self.top:DockMargin(0, 0, 0, 0)
    self.top:SetTall(mvp.ui.Scale(60))

    self.top.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, mvp.ui.MuteColor(mvp.colors.SecondaryBackground, 1.1), true, true, false, false)
    end

    self.icon = vgui.Create("DPanel", self.top)
    self.icon:Dock(LEFT)
    self.icon:DockMargin(5, 5, 5, 5)

    self.icon.Paint = function(pnl, w, h)

        if (not self.iconData) then return end
        if (self.iconData.isGradient) then
            mvp.ui.DrawRoundedGradient( mvp.ui.ScaleWithFactor(8), 0, 0, w, h, self.iconData.bg.startCol, self.iconData.bg.endCol )
        else
            draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, self.iconData.bg)
        end
        -- mvp.ui.DrawRoundedGradient( mvp.ui.ScaleWithFactor(16), 0, 0, w, h, mvp.colors.Red, mvp.colors.Accent )

        surface.SetDrawColor(self.iconData.col)

        local iconSize = w - 18
        surface.SetMaterial(self.iconData.mat)
        surface.DrawTexturedRect(9, 9, iconSize, iconSize)

        return true
    end

    self.title = vgui.Create("DLabel", self.top)
    self.title:Dock(LEFT)
    self.title:SetTextColor(mvp.colors.Text)
    self.title:SetFont(titleFont)
    self.title:SetContentAlignment(4)
end

function PANEL:SetBackground(color)
    self.colors.Background = color
end

function PANEL:SetStyle(style)
    if (style == "primary") then
        self:SetBackground(mvp.colors.Background)
    elseif (style == "secondary") then
        self:SetBackground(ColorAlpha(mvp.colors.SecondaryBackground, 100))
    end
end

function PANEL:SetupIcon(iconMat, iconCol, bgColor)
    if (not iconMat) then return end
    iconCol = mvp.utils.IsColor(iconCol) and iconCol or mvp.colors.Text
    
    local isGradient = false 

    if (bgColor and bgColor.startCol and bgColor.endCol and mvp.utils.IsColor(bgColor.startCol) and mvp.utils.IsColor(bgColor.endCol)) then
        isGradient = true
    else
        bgColor = mvp.utils.IsColor(bgColor) and bgColor or mvp.colors.SecondaryBackground
    end

    self.iconData = {
        mat = iconMat,
        col = iconCol,
        bg = bgColor,
        isGradient = isGradient
    }
end

function PANEL:SetTitle(title)
    self.title:SetText(title)
    self.title:SizeToContents()
end

function PANEL:PerformLayout(w, h)    
    if (self.iconData) then
        self.icon:SetWide(mvp.ui.Scale(60) - 10)
    else
        self.icon:SetWide(0)
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(roundness, 0, 0, w, h, self.colors.Background)
end

vgui.Register("mvp.CardExtended", PANEL, "EditablePanel")