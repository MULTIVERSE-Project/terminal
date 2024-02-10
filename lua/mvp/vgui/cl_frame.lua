local PANEL = {}

local titleFont = mvp.Font(28, 600)
local closeIcon = Material("mvp/terminal/close.png", "smooth mips")

local roundness = mvp.ui.ScaleWithFactor(16)

function PANEL:Init()
    self.top = vgui.Create("EditablePanel", self)
    self.top:Dock(TOP)

    self.top.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(roundness, 0, 0, w, h, Color(43, 43, 43), true, true, false, false)
    end

    self.title = vgui.Create("DLabel", self.top)
    self.title:Dock(LEFT)
    self.title:DockMargin(8, 0, 0, 0)
    self.title:SetFont(titleFont)
    self.title:SetTextColor(color_white)
    self.title:SetContentAlignment(4)

    self.close = vgui.Create("DButton", self)

    self.close.DoClick = function(pnl)
        self:Remove()
    end

    self.close.iconColor = Color(195, 195, 195)
    self.close.backgroundAlpha = 0
    
    self.close.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(roundness, 0, 0, w, h, Color(255, 71, 71, pnl.backgroundAlpha), false, true, false, false)

        surface.SetDrawColor(pnl.iconColor)
        surface.SetMaterial(closeIcon)
        surface.DrawTexturedRect(12, 12, w - 24, h - 24)

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

function PANEL:SetTopVisible(bool)
    self.top:SetVisible(bool)
end

function PANEL:PerformLayout(w, h)
    self.top:SetTall(mvp.ui.Scale(48))

    self.close:SetPos(w - self.top:GetTall(), 0)
    
    self.close:SetWide(self.top:GetTall())
    self.close:SetTall(self.top:GetTall())
end

function PANEL:Paint(w, h)
    draw.RoundedBox(roundness, 0, 0, w, h, Color(36, 36, 36))
end

vgui.Register("mvp.Frame", PANEL, "EditablePanel")