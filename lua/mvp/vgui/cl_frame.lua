local PANEL = {}

local titleFont = mvp.Font(32, 600)
local closeIcon

local roundness = mvp.ui.ScaleWithFactor(16)

function PANEL:Init()
    self.top = vgui.Create("EditablePanel", self)
    self.top:Dock(TOP)
    self.top:DockMargin(0, 0, 0, 10)

    self.icon = vgui.Create("DPanel", self.top)
    self.icon:Dock(LEFT)
    self.icon:DockMargin(5, 5, 0, 5)

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
    self.title:DockMargin(5, 0, 0, 0)
    self.title:SetTextColor(mvp.colors.Text)
    self.title:SetFont(titleFont)
    self.title:SetContentAlignment(4)

    self.close = vgui.Create("DButton", self.top)
    self.close:Dock(RIGHT)
    self.close:DockMargin(0, 5, 5, 5)

    self.close.DoClick = function(pnl)
        self:Remove()
    end

    self.close.iconColor = Color(195, 195, 195)
    self.close.backgroundAlpha = 0

    if (not closeIcon) then
        closeIcon = mvp.ui.images.Create("v_close", "smooth mips")
    end
    
    self.close.Paint = function(pnl, w, h)
        draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.Red, pnl.backgroundAlpha), false, true, false, false)

        closeIcon:Draw(12, 12, w - 24, h - 24, pnl.iconColor)

        return true
    end

    self.close.OnCursorEntered = function(pnl)
        pnl:Lerp("backgroundAlpha", 255, 0.2)
        pnl:LerpColor("iconColor", color_white, 0.2)
    end

    self.close.OnCursorExited = function(pnl)
        pnl:Lerp("backgroundAlpha", 0, 0.2)
        pnl:LerpColor("iconColor", Color(195, 195, 195), 0.2)
    end    
end

function PANEL:SetTitle(title)
    self.title:SetText(title)
    self.title:SizeToContents()
end

function PANEL:SetupIcon(iconMat, iconCol, bgColor)
    if (not iconMat) then return end
    iconCol = mvp.utils.IsColor(iconCol) and iconCol or mvp.colors.Text
    
    local isGradient = false 

    if (bgColor and bgColor.startCol and bgColor.endCol and mvp.utils.IsColor(bgColor.startCol) and mvp.utils.IsColor(bgColor.endCol)) then
        isGradient = true
    else
        bgColor = mvp.utils.IsColor(bgColor) and bgColor or mvp.colors.BackgroundHover
    end

    self.iconData = {
        mat = iconMat,
        col = iconCol,
        bg = bgColor,
        isGradient = isGradient
    }
end

function PANEL:PerformLayout(w, h)
    self.top:SetTall(mvp.ui.Scale(64))

    self.close:SetWide(mvp.ui.Scale(64) - 10)
    
    if (self.iconData) then
        self.icon:SetWide(mvp.ui.Scale(64) - 10)
    else
        self.icon:SetWide(0)
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(roundness, 0, 0, w, h, Color(36, 36, 36))
    draw.RoundedBoxEx(mvp.ui.ScaleWithFactor(8), 0, 0, w, self.top:GetTall(), mvp.colors.SecondaryBackground, true, true, false, false)
end

vgui.Register("mvp.Frame", PANEL, "EditablePanel")