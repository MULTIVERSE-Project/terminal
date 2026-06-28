PANEL = {}

local RNDX = mvp.RNDX
local s = mvp.ui.Scale

MVP_STYLE_PRIMARY = 1
MVP_STYLE_SECONDARY = 2
MVP_STYLE_SUCCESS = 3
MVP_STYLE_ERROR = 4

local OUTLINE_COL = Color(151, 151, 151, 255 * .3)
local BUTTON_STYLES

mvp.theme.Hook("Button", function()    
    return {
        [MVP_STYLE_PRIMARY] = {mvp.C("primary", .19), mvp.C("primary", .26), mvp.C("primary", .2), mvp.C("foreground")},
        [MVP_STYLE_SECONDARY] = {mvp.C("secondary"), mvp.C("secondary", .25), mvp.C("secondary", .1), mvp.C("secondary-foreground")},
        [MVP_STYLE_SUCCESS] = {mvp.C("success", .25), mvp.C("success", .34), mvp.C("success", .2), mvp.C("foreground")},
        [MVP_STYLE_ERROR] = {mvp.C("error", .25), mvp.C("error", .34), mvp.C("error", .2), mvp.C("foreground")},
    }
end, function(styles)
    BUTTON_STYLES = styles
    hook.Run("mvp.v2.Button.UpdateStyle")
end)

local BUTTON_ALIGMENT = {
    [TEXT_ALIGN_LEFT] = function(w, totalW)
        return s(10)
    end,
    [TEXT_ALIGN_CENTER] = function(w, totalW)
        return (w - totalW) * .5
    end,
    [TEXT_ALIGN_RIGHT] = function(w, totalW)
        return w - totalW - s(10)
    end,
}

local function getTextWidth(font, text)
    text = text or "W"
    
    surface.SetFont(font)
    local w = surface.GetTextSize(text)

    return w
end
local function getTextHeight(font, text)
    text = text or "W"
    
    surface.SetFont(font)
    local _w, h = surface.GetTextSize(text)

    return h
end

AccessorFunc(PANEL, "_onlyIcon", "OnlyIcon", FORCE_BOOL)
AccessorFunc(PANEL, "_icon", "Icon")
AccessorFunc(PANEL, "_iconMult", "IconMultiplier")
AccessorFunc(PANEL, "_align", "Align")

AccessorFunc(PANEL, "_shouldDrawBg", "ShouldDrawBg", FORCE_BOOL)
AccessorFunc(PANEL, "_disabledColor", "DisabledColor")

AccessorFunc(PANEL, "_hoverOutlineAdd", "HoverOutlineAdd")

DEFINE_BASECLASS("Panel")

function PANEL:Init()
    self:Import("click")
    self:Import("hover")

    self._style = MVP_STYLE_PRIMARY

    self:SetColorKey("_bgColor")
    self:CenterText()

    self:Color("primary-foreground")
    self:FFont("default@regular", 14)

    self:SetStyle(MVP_STYLE_PRIMARY)
    self:SetAlign(TEXT_ALIGN_CENTER)
    self:SetIconMultiplier(.45)
    self:SetShouldDrawBg(true)

    self:SetHoverOutlineAdd(s(3))

    -- tl, tr, bl, br
    self._radii = {8, 8, 8, 8}

    hook.Add("mvp.v2.Button.UpdateStyle", self, function()
        self:UpdateStyle()
    end)
end

function PANEL:SetRad(rad)
    self._radii = {rad, rad, rad, rad}
end
function PANEL:SetRadii(tl, tr, bl, br)
    self._radii = {tl, tr, bl, br}
end

function PANEL:GetStyle(style)
    style = style or self._style

    return BUTTON_STYLES[style] or BUTTON_STYLES[MVP_STYLE_PRIMARY]
end
function PANEL:SetStyle(style)
    self._style = style

    local colors = self:GetStyle(style)

    self:SetColorIdle(colors[1])
    self:SetColorHover(colors[2])
    self:SetDisabledColor(colors[3])
    self:SetTextColor(colors[4])

    self._bgColor = self:IsHovered() and colors[2] or colors[1]
end
function PANEL:SetCustomStyle(idleCol, hoverCol, disabledCol, textCol)
    self._style = nil

    self:SetColorIdle(idleCol)
    self:SetColorHover(hoverCol)
    self:SetDisabledColor(disabledCol)
    self:SetTextColor(textCol)

    self._bgColor = self:IsHovered() and hoverCol or idleCol
end
function PANEL:UpdateStyle()
    if (not self._style) then return end
    self:SetStyle(self._style)
end

function PANEL:SetIcon(icon, params)
    self._icon = mvp.ui.images.From(icon, params or "smooth")
end
function PANEL:SetText(text)
    if (text == nil or text == "" or text == false) then
        self:SetOnlyIcon(true)
        BaseClass.SetText(self, "")
    else
        self:SetOnlyIcon(false)
        BaseClass.SetText(self, text)
    end
end

function PANEL:Paint(w, h)
    if (self:GetShouldDrawBg()) then
        if (self:IsHovered() and self:IsEnabled()) then
            self._outlineAdd = Lerp(FrameTime() * 8, self._outlineAdd or 0, self:GetHoverOutlineAdd())
        else
            self._outlineAdd = Lerp(FrameTime() * 8, self._outlineAdd or 0, 0)
        end

        RNDX().Rect(0, 0, w, h)
            :Color(self:IsEnabled() and self._bgColor or self._disabledColor)
            :Radii(unpack(self._radii))
            :Draw()
    
        RNDX().Rect(0, 0, w, h)
            :Color(OUTLINE_COL)
            :Radii(unpack(self._radii))
            :Outline(1 + (self._outlineAdd or 0))
            :Draw()
    end

    local textW = getTextWidth(self:GetFont(), self:GetText())

    local totalW = textW

    if (self._icon) then
        local iconSize = math.floor(h * self:GetIconMultiplier())
        
        if (not self:GetOnlyIcon()) then
            totalW = totalW + iconSize + s(5)
        else
            totalW = iconSize
        end
    end
    local x = BUTTON_ALIGMENT[self:GetAlign()] and BUTTON_ALIGMENT[self:GetAlign()](w, totalW) or 0

    if (self._icon) then
        local iconSize = math.floor(h * self:GetIconMultiplier())

        self._icon:Draw(x, h * .5 - iconSize * .5, iconSize, iconSize, self:C("foreground"))

        x = x + iconSize + s(5)

        if (self:GetOnlyIcon()) then return true end
    end

    draw.SimpleText(
        self:GetText(),
        self:GetFont(),
        x,
        h * .5,
        self:GetTextColor(),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )

    return true
end

function PANEL:SizeToContents(addX, addY)
    self:SizeToContentsX(addX)
    self:SizeToContentsY(addY)
end

function PANEL:SizeToContentsX(addX)
    addX = addX or 0
    
    local w = getTextWidth(self:GetFont(), self:GetText())

    if (self._icon) then
        local iconWidth = self:GetTall() * .45
        addX = addX + iconWidth + s(5)
    end

    if (self:GetOnlyIcon() and self._icon) then
        w = 0
    end

    self:SetWide(w + (addX or 0) + s(20))
end

function PANEL:SizeToContentsY(addY)
    local h = getTextHeight(self:GetFont(), self:GetText())

    self:SetTall(h + (addY or 0))
end

mvp.ui.g.Register("mvp.v2.Button", PANEL, "mvp.v2.Label")

