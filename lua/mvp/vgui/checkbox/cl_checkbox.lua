local PANEL = {}
local padding = mvp.ui.Scale(8)

AccessorFunc(PANEL, "roundness", "Roundness")

local checkIcon

function PANEL:Init()
    self.checked = false

    self:SetText("")
    self:SetRoundness(mvp.ui.ScaleWithFactor(8))

    self.colors = {}
    self.colors.Background = mvp.colors.SecondaryBackground
    self.colors.BackgroundHover = mvp.colors.BackgroundHover

    self.backgroundColor = self.colors.Background
    self.clipWidth = 0

    if (not checkIcon) then
        checkIcon = mvp.ui.images.Create("v_check", "smooth mips")
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(self.roundness, 0, 0, w, h, self.backgroundColor)

    local x, y = self:LocalToScreen(0, 0)
    render.SetScissorRect( x, y, x + self.clipWidth, y + h, true )
        draw.RoundedBox(self.roundness, 0, 0, w, h, mvp.colors.SecondaryAccent)

        checkIcon:Draw(padding, padding + 4, w - padding * 2, h - padding * 2, mvp.colors.Text)
    render.SetScissorRect( 0, 0, 0, 0, false )
end

function PANEL:OnCursorEntered()
    self:LerpColor("backgroundColor", self.colors.BackgroundHover, 0.2)
end
function PANEL:OnCursorExited()
    self:LerpColor("backgroundColor", self.colors.Background, 0.2)
end

function PANEL:SetChecked(val)
    if (tonumber(val) == 0) then
        val = 0
    end 

    val = tobool(val)

    self.checked = val

    self:OnChangedInternal(val)
end
function PANEL:GetChecked()
    return self.checked
end
function PANEL:SetValue(bool)
    self:SetChecked(bool)
end
function PANEL:GetValue()
    return self:GetChecked()
end

function PANEL:Toggle()
    self:SetChecked(not self:GetChecked())
end
function PANEL:DoClick()
    self:Toggle()
end

function PANEL:OnChangedInternal(bool)
    self:OnChanged(bool)

    self:Lerp("clipWidth", self:GetChecked() and self:GetWide() or 0, 0.2)
end
function PANEL:OnChanged(bool)
    -- override
end

vgui.Register("mvp.CheckBox", PANEL, "DButton")