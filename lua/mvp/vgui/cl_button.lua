local PANEL = {}

AccessorFunc(PANEL, "roundness", "Roundness")

function PANEL:Init()
    self.colors = {}
    
    self:SetStyle("secondary")
    self:SetFont(mvp.Font(18, 600))
    self:SetTextColor(mvp.colors.Text)
    self:SetRoundness(mvp.ui.ScaleWithFactor(16))

    self.backgroundColor = self.colors.Background

    self.extRoundness = {
        true, true, true, true
    }
end

function PANEL:Think()
    self:SetCursor(self:IsEnabled() and "hand" or "no")
end

function PANEL:Paint(w, h)
    local col = self.backgroundColor
    
    if (not self:IsEnabled()) then
        col = Color(col.r * .4, col.g * .4, col.b * .4, col.a)
    end

    draw.RoundedBoxEx(self.roundness, 0, 0, w, h, col, unpack(self.extRoundness))
end

function PANEL:OnCursorEntered()
    if (not self:IsEnabled()) then
        return
    end

    self:LerpColor("backgroundColor", self.colors.BackgroundHover, .2)
end

function PANEL:OnCursorExited()
    if (not self:IsEnabled()) then
        return
    end

    self:LerpColor("backgroundColor", self.colors.Background, .2)
end

function PANEL:SetRoundedTopLeft(b)
    self.extRoundness[1] = b
end
function PANEL:SetRoundedTopRight(b)
    self.extRoundness[2] = b
end
function PANEL:SetRoundedBottomLeft(b)
    self.extRoundness[3] = b
end
function PANEL:SetRoundedBottomRight(b)
    self.extRoundness[4] = b
end

function PANEL:SetExtendedRoundness(r)
    self:SetRoundedTopLeft(r[1])
    self:SetRoundedTopRight(r[2])
    self:SetRoundedBottomLeft(r[3])
    self:SetRoundedBottomRight(r[4])
end

local stylesMap = {
    ["primary"] = {
        ColorAlpha(mvp.colors.Accent, 150),
        mvp.colors.Accent
    },
    ["secondary"] = {
        mvp.colors.SecondaryBackground,
        mvp.colors.BackgroundHover
    },
    ["success"] = {
        ColorAlpha(mvp.colors.Green, 150),
        mvp.colors.Green
    },
    ["danger"] = {
        ColorAlpha(mvp.colors.Red, 150),
        mvp.colors.Red
    }
}

function PANEL:SetStyle(style)
    local styleColors = stylesMap[style]

    if (not styleColors) then
        return
    end

    self.colors.Background = styleColors[1]
    self.colors.BackgroundHover = styleColors[2]

    self.backgroundColor = self.colors.Background
end

vgui.Register("mvp.Button", PANEL, "DButton")