include("shared.lua")

local FONT_TITLE = mvp.F("heading@500", 105, true )
local FONT_BUTTON = mvp.F("default@500", 50, true )
local FONT_DESC = mvp.F("default@400", 42, true )

local gradientDown = Material("gui/gradient_down")
local gradientUp = Material("gui/gradient_up")

local RNDX = mvp.RNDX

function ENT:Initialize()
    self.UI = table.Inherit(self.UI or {}, self._UI)
    self.Actions = table.Inherit(self.Actions or {}, self._Actions)

    local maxViewDist, minViewDist = self.View[1] ^ 2, self.View[2] ^ 2
    self.ViewDistSqr = {maxViewDist, minViewDist}
end

local function inverseLerp( pos, p1, p2 )
    local range = 0
    range = p2 - p1

    if range == 0 then return 1 end
    return (pos - p1) / range
end

function ENT:DrawTranslucent()
    local maxViewDist, minViewDist = self.ViewDistSqr[1], self.ViewDistSqr[2]
    local distance = LocalPlayer():EyePos():DistToSqr(self:GetPos())
    
    if (distance > maxViewDist) then return end

    local uiW, uiH = self.UI.Size[1], self.UI.Size[2]

    local header = self.UI.Header or "Interactable"
    local desc = self.UI.Description or "This is an interactable entity base. This should not exist in the world and is only meant to be used as a base for other entities. Please report to the developer if you see this in the world."
    local icon = self.UI.Icon and mvp.ui.images.From(self.UI.Icon, "smooth") or nil

    local headerWidth, headerHeight = mvp.theme.GetFontSize(header, FONT_TITLE)
    local _, buttonHeight = mvp.theme.GetFontSize("E", FONT_BUTTON)
    local iconSize = 80

    uiW = math.max(uiW, headerWidth + 20 + (icon and iconSize or 0))

    -- mvp.utils.WrapText(text, font, maxWidth)
    local wrappedDesc = mvp.utils.WrapText(desc, FONT_DESC, uiW - 25)
    local _, descHeight = mvp.theme.GetFontSize(wrappedDesc, FONT_DESC)

    local buttonCount = 0

    uiH = math.max(uiH, headerHeight + descHeight)
    local useAction = self.Actions and self.Actions[MVP_ENT_ACTION_USE]
    if (useAction and useAction.Active ~= false) then
        uiH = uiH + buttonHeight + 15
        buttonCount = buttonCount + 1
    end

    local shiftUseAction = self.Actions and self.Actions[MVP_ENT_ACTION_SHIFT_USE]
    if (shiftUseAction and shiftUseAction.Active ~= false) then
        uiH = uiH + buttonHeight + 15
        buttonCount = buttonCount + 1
    end

    local fraction = math.Clamp(inverseLerp(distance, maxViewDist, minViewDist), 0, 1)
    local zOffset = 5 * fraction

    local drawPos = self:GetPos()
    if (not self.UI.CustomPos) then
        local _mMin, mMax = self:GetModelBounds()
        drawPos = self:OBBCenter() + Vector(0, 0, (mMax.z * .5) + zOffset + uiH * 0.05)
    else
        drawPos = self.UI.CustomPos + Vector(0, 0, zOffset)
    end
    local drawAng = self:GetAngles()

    if (self.UI.FollowPlayer) then -- @TODO: UIFollowPlayer
        drawAng = (LocalPlayer():EyePos() - self:GetPos()):Angle()
        drawAng:RotateAroundAxis(drawAng:Up(), 90)
        drawAng:RotateAroundAxis(drawAng:Forward(), 90)
    else
        drawAng:RotateAroundAxis(drawAng:Up(), 90)
        drawAng:RotateAroundAxis(drawAng:Forward(), 90)
    end

    drawPos = self:LocalToWorld(drawPos)
    -- drawAng = self:LocalToWorldAngles(drawAng)

    local originX, originY = -uiW * 0.5, -uiH * 0.5
    local x, y = originX, originY
    cam.Start3D2D(drawPos, drawAng, 0.05)
        RNDX().Rect(originX - 15, originY - 15, uiW + 30, uiH + 30)
            :Color(20, 20, 20, 160 * fraction)
            :Radii(12, 12)
            :Draw()

        surface.SetAlphaMultiplier(fraction)

        if (useAction and useAction.Active ~= false) then
            RNDX().Rect(x, y, buttonHeight, buttonHeight)
                :Color(mvp.C("foreground"))
                :Rad(8)
                :Draw()

            draw.SimpleText("E", FONT_BUTTON, x + buttonHeight * 0.5, y + buttonHeight * 0.5, mvp.C("background"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(useAction.Text, FONT_BUTTON, x + buttonHeight + 20, y + buttonHeight * 0.5, mvp.C("foreground"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            y = y + buttonHeight + 15
        end
        if (shiftUseAction and shiftUseAction.Active ~= false) then
            local shiftWidth = mvp.theme.GetFontSize("SHIFT", FONT_BUTTON)

            RNDX().Rect(x, y, shiftWidth + 20, buttonHeight)
                :Color(mvp.C("foreground"))
                :Rad(8)
                :Draw()

            draw.SimpleText("SHIFT", FONT_BUTTON, x + shiftWidth * 0.5 + 10, y + buttonHeight * 0.5, mvp.C("background"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("+", FONT_BUTTON, x + shiftWidth + 40, y + buttonHeight * 0.5, mvp.C("foreground"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            RNDX().Rect(x + shiftWidth + 60, y, buttonHeight, buttonHeight)
                :Color(mvp.C("foreground"))
                :Rad(8)
                :Draw()
            draw.SimpleText("E", FONT_BUTTON, x + shiftWidth + 60 + buttonHeight * 0.5, y + buttonHeight * 0.5, mvp.C("background"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            draw.SimpleText(shiftUseAction.Text, FONT_BUTTON, x + shiftWidth + 60 + buttonHeight + 20, y + buttonHeight * 0.5, mvp.C("foreground"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            y = y + buttonHeight + 15
        end

        local gradientColor = ColorAlpha(mvp.C("primary"), 255 * .3)
        local gradientY = y
        local gradientH = uiH + 15 - (buttonCount * (buttonHeight + 15))
        RNDX().Rect(originX - 15, gradientY, uiW + 30, gradientH * .5)
            :Color(gradientColor)
            :Material(gradientDown)
            :Draw()

        RNDX().Rect(originX - 15, gradientY + gradientH * .5, uiW + 30, gradientH * .5)
            :Color(gradientColor)
            :Material(gradientUp)
            :Draw()

        RNDX().Rect(originX - 15, gradientY, uiW + 30, 4)
            :Color(mvp.C("primary"))
            :Draw()
        RNDX().Rect(originX - 15, gradientY + gradientH - 4, uiW + 30, 4)
            :Color(mvp.C("primary"))
            :Draw()

        local titleMargin = 0
        if (icon) then
            titleMargin = iconSize + 15
        end
        draw.SimpleText(header, FONT_TITLE, x + titleMargin, y + headerHeight * 0.5, mvp.C("foreground"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if (icon) then
            icon:Draw(x, y + headerHeight * .5 - iconSize * .5, iconSize, iconSize)
        end

        draw.DrawText(wrappedDesc, FONT_DESC, x + 10, y + headerHeight, mvp.C("secondary-foreground"), TEXT_ALIGN_LEFT)

        surface.SetAlphaMultiplier(1)
    cam.End3D2D()
end