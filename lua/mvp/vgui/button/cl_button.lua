local PANEL = {}

DEFINE_BASECLASS("Panel")

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

    self.iconSize = 16
    self.icon = nil
end

function PANEL:Think()
    self:SetCursor(self:IsEnabled() and "hand" or "no")
end

function PANEL:SetIconSize(size)
    self.iconSize = size
end

function PANEL:SetIcon(icon, params)
    if (type(icon) ~= "IMaterial") then
        icon = Material(icon, params or "smooth")
    end

    self.icon = icon
end
function PANEL:PerformLayout(w, h)
    if (self.icon) then
        self.iconSize = h * .5
    end
end

function PANEL:SizeToContents(addedWidth, addedHeight)
    addedWidth = addedWidth or 0
    addedHeight = addedHeight or 0
    
    if (self.icon) then
        surface.SetFont(self:GetFont())
        local tw, th = surface.GetTextSize(self:GetText())

        self:SetSize(tw + self.iconSize + 5 + addedWidth, th + 10 + addedHeight)
    else
        BaseClass.SizeToContents(self, addedWidth, addedHeight)
    end
end

function PANEL:SizeToContentsX(addedWidth)
    addedWidth = addedWidth or 0
    
    if (self.icon) then
        surface.SetFont(self:GetFont())
        local tw, th = surface.GetTextSize(self:GetText())

        self:SetWide(tw + self.iconSize + 5 + addedWidth)
    else
        BaseClass.SizeToContentsX(self, addedWidth)
    end
end

function PANEL:SizeToContentsY(addedHeight)
    addedHeight = addedHeight or 0
    
    if (self.icon) then
        surface.SetFont(self:GetFont())
        local tw, th = surface.GetTextSize(self:GetText())

        self:SetTall(th + 10 + addedHeight)
    else
        BaseClass.SizeToContentsY(self, addedHeight)
    end
end

function PANEL:Paint(w, h)
    local col = self.backgroundColor
    
    if (not self:IsEnabled()) then
        col = Color(col.r * .4, col.g * .4, col.b * .4, col.a)
    end

    draw.RoundedBoxEx(self.roundness, 0, 0, w, h, col, unpack(self.extRoundness))
    
    if (self.icon) then
        surface.SetFont(self:GetFont())
        local tw, th = surface.GetTextSize(self:GetText())

        local iconSize = self.iconSize
        local iconX = (w - tw - iconSize) * .5 - 2.5
        local iconY = (h - iconSize) * .5

        local textX = iconX + iconSize + 5
        local textY = (h - th) * .5

        surface.SetDrawColor(self:GetTextColor())
        surface.SetMaterial(self.icon)
        surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)

        draw.SimpleText(self:GetText(), self:GetFont(), textX, textY, self:GetTextColor(), TEXT_ALIGN_LEFT)

        return true
    end

    draw.SimpleText(self:GetText(), self:GetFont(), w * .5, h * .5, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    return true
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
        mvp.ui.MuteColor(mvp.colors.Accent),
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

function PANEL:SetCustomStyle(color, hoverColor)
    self.colors.Background = color
    self.colors.BackgroundHover = hoverColor

    self.backgroundColor = self.colors.Background
end

vgui.Register("mvp.Button", PANEL, "DButton")