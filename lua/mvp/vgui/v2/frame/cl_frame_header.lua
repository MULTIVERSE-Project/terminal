PANEL = {}

local s = mvp.ui.Scale
local RNDX = mvp.RNDX
local sf = mvp.ui.ScaleWithFactor
local closeMat = Material("mvp/terminal/vgui/close.png", "smooth")

local chevronMat = Material("mvp/terminal/vgui/frame/chevron.png", "smooth")
local chevronW, chevronH = s(30), s(78)
local iconSize = s(24)

AccessorFunc(PANEL, "_title", "Title", FORCE_STRING)
AccessorFunc(PANEL, "_subtitle", "SubTitle", FORCE_STRING)
AccessorFunc(PANEL, "_icon", "Icon")

local shadowColor = Color(0, 0, 0, 255 * .5)
local function drawText(text, font, x, y, color, alignX, alignY)
    draw.SimpleText(text, font, x + 2, y + 2, shadowColor, alignX, alignY)
    return draw.SimpleText(text, font, x, y, color, alignX, alignY)
end

function PANEL:Init()
    self:SetTitle("Little frame")
    self:SetSubTitle("In a full screen >-<")

    self._frame = self:GetParent()
    
    self._text = vgui.Create("EditablePanel", self)
    self._text:Dock(FILL)
    self._text.Paint = function(pnl, w, h)
        local x = 0
        local y = h * .5

        if (self._icon) then
            DisableClipping(true)
            
            RNDX().Rect(x, y - chevronH * .5, chevronW, chevronH)
                :Material(chevronMat)
                :Color(self:C("primary"))
                :Draw()

            self._icon:RNDX(x + (chevronW - iconSize) * .5, y - iconSize * .5, iconSize, iconSize, self:C("primary")):Draw()

            x = x + chevronW + s(10)
            DisableClipping(false)
        end

        drawText(self:GetTitle(), self:FF("header@semibold", 32), x, y + s(8), self:C("foreground"), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        drawText(self:GetSubTitle(), self:FF("default@light", 18), x, y + s(2), self:C("foreground", 0.75), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self._closeButton = vgui.Create("mvp.v2.Button", self)
    self._closeButton:SetOnlyIcon(true)
    self._closeButton:SetIcon(closeMat)
    self._closeButton:SetAlign(TEXT_ALIGN_CENTER)
    self._closeButton:SetCustomStyle(mvp.C("background"), mvp.C("error", 0.65), mvp.C("background", 0.35), mvp.C("foreground"))
    self._closeButton.DoClick = function()
        self._frame:Remove()
    end
end
function PANEL:SetIcon(icon, params)
    self._icon = mvp.ui.images.From(icon, params or "smooth")
end

function PANEL:PerformLayout(w, h)
    self._closeButton:SetSize(sf(32), sf(32))
    self._closeButton:SetPos(w - self._closeButton:GetWide() - s(8), 0)
end

mvp.ui.g.Register("mvp.v2.FrameHeader", PANEL, "EditablePanel")

-- mvp.ui.g.Test("mvp.v2.Frame", 1, 1, function(frame)
--     frame:MakePopup()
--     frame:SetIcon(Material("mvp/terminal/notifications/success.png", "smooth mips"))
-- end) 