PANEL = {}

AccessorFunc(PANEL, "_checked", "Checked", FORCE_BOOL)
AccessorFunc(PANEL, "_disabledColor", "DisabledColor")

AccessorFunc(PANEL, "_hoverOutlineAdd", "HoverOutlineAdd")

local RNDX = mvp.RNDX
local s = mvp.ui.Scale

local STYLE = {mvp.C("secondary"), mvp.C("secondary", .25), mvp.C("secondary", .1)}
local OUTLINE_COL = Color(151, 151, 151, 255 * .3)

function PANEL:Init()
    self._checked = false

    self:Import("click")
    self:Import("hover")

    self:SetColorKey("_bgColor")

    self:SetStyle(STYLE)
    self:SetHoverOutlineAdd(s(3))

    self._icon = mvp.ui.images.From("mvp/terminal/icons/check.png", "smooth")
end

function PANEL:Paint(w, h)
    if (self:IsHovered()) then
        self._outlineAdd = Lerp(FrameTime() * 8, self._outlineAdd or 0, self:GetHoverOutlineAdd())
    else
        self._outlineAdd = Lerp(FrameTime() * 8, self._outlineAdd or 0, 0)
    end

    RNDX().Rect(0, 0, w, h)
        :Color(self:IsEnabled() and self._bgColor or self._disabledColor)
        :Rad(8)
        :Draw()

    RNDX().Rect(0, 0, w, h)
        :Color( OUTLINE_COL )
        :Rad(8)
        :Outline(1)
        :Draw()

    self._iconReveal = Lerp(FrameTime() * 12, self._iconReveal or 0, self:GetChecked() and 1 or 0)

    -- reveal icon from center
    local xz, yz = self:LocalToScreen(0, 0)
    render.SetScissorRect(
        xz + w * 0.5 - (w * 0.5 * self._iconReveal),
        yz + h * 0.5 - (h * 0.5 * self._iconReveal),
        xz + w * 0.5 + (w * 0.5 * self._iconReveal),
        yz + h * 0.5 + (h * 0.5 * self._iconReveal),
        true
    )
    
    -- surface.SetDrawColor(255, 255, 255, 255)
    -- surface.DrawRect(0, 0, w, h)

    if (self._icon and self._iconReveal >= 0.008) then
        RNDX().Rect(w * 0.5 - (w * 0.5 * self._iconReveal),
                    h * 0.5 - (h * 0.5 * self._iconReveal),
                    w * 0.5 + (w * 0.5 * self._iconReveal), h * 0.5 + (h * 0.5 * self._iconReveal))
            :Color(mvp.C("foreground", nil, 50))
            :Rad(8)
            :Draw()
        
        local iconSize = math.floor(math.min(w, h) * 0.6)
        self._icon:Draw(
            w * 0.5 - iconSize * 0.5,
            h * 0.5 - iconSize * 0.5,
            iconSize,
            iconSize,
            self:C("foreground")
        )
    end
    render.SetScissorRect(0, 0, 0, 0, false)
end

function PANEL:DoClick()
    self:SetValue(not self:GetChecked())
end
function PANEL:SetChecked(val)
    self._checked = val
end
function PANEL:SetValue(val)
    self:SetChecked(val)
    self:Call("OnValueChange", nil, val)
end

function PANEL:SetStyle(colors)
    self:SetColorIdle(colors[1])
    self:SetColorHover(colors[2])
    self:SetDisabledColor(colors[3])
    -- self:SetTextColor(colors[4])

    self._bgColor = self:IsHovered() and colors[2] or colors[1]
end
function PANEL:SetCustomStyle(idleCol, hoverCol, disabledCol)
    self:SetColorIdle(idleCol)
    self:SetColorHover(hoverCol)
    self:SetDisabledColor(disabledCol)
    -- self:SetTextColor(textCol)

    self._bgColor = self:IsHovered() and hoverCol or idleCol
end

function PANEL:SetDisabled(bool)
    self._disabled = bool
end
function PANEL:GetDisabled()
    return self._disabled
end
function PANEL:IsEnabled()
    return not self._disabled
end

mvp.ui.g.Register("mvp.v2.Checkbox", PANEL)
-- mvp.menus.terminal.Open("settings")
