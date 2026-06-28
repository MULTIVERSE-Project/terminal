local margin = mvp.ui.Scale(8)
local s = mvp.ui.Scale
local RNDX = mvp.RNDX

DEFINE_BASECLASS("EditablePanel")

PANEL = {}

AccessorFunc(PANEL, "_PlaceholderText", "PlaceholderText")
AccessorFunc(PANEL, "_colPlaceholderColor", "PlaceholderColor")
AccessorFunc(PANEL, "_PlaceholderFont", "PlaceholderFont")
AccessorFunc(PANEL, "_TextSuffix", "TextSuffix")
AccessorFunc(PANEL, "_iconMult", "IconMultiplier")
AccessorFunc(PANEL, "_disabledColor", "DisabledColor")
AccessorFunc(PANEL, "_hoverOutlineAdd", "HoverOutlineAdd")


--            {idleCol, hoverCol, disabledCol, textCol}
local STYLE = {mvp.C("secondary"), mvp.C("secondary", .25), mvp.C("secondary", .1), mvp.C("secondary-foreground")}
local OUTLINE_COL = Color(151, 151, 151, 255 * .3)

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

local mutators = {
    "Font",
    "HistoryEnabled",
    "Numeric",
    "TabbingDisabled",
    "TextColor",
    "UpdateOnType",
    "Value",
    "Text",
    "CaretPos",
}

local dispatch = {
    "OnLoseFocus",
    "OnGetFocus",
    "AllowInput",
    "OnChange",
    "OnEnter",
    "OnKeyCode",
    "OnValueChange",
    "OnCursorEntered",
    "OnCursorExited",
    "KillFocus"
}

function PANEL:Init()
    self.textEntry = vgui.Create("DTextEntry", self) 

    self.textEntry:Dock(FILL)
    self.textEntry:DockMargin(margin, 0, margin, 0)

    self.textEntry.Paint = function(panel, w, h)
        panel:DrawTextEntryText(panel:GetTextColor(), mvp.C("primary"), color_white)
    end

    for _, name in pairs(mutators) do
        self:CombineMutator(self.textEntry, name)
    end

    for _, name in pairs(dispatch) do
        -- self.textEntry:InjectEventHandler(name)
        self:MakeDispatchFn(self.textEntry, name)
    end

    self:SetFont(mvp.FF("default@500", 14))
    self:SetTextColor(mvp.C("secondary-foreground"))

    self:SetPlaceholderFont(self:GetFont())
    self:SetPlaceholderColor(Color(125, 125, 125))

    self:Import("hover")
    self:SetColorKey("_bgColor")
    self:SetIconMultiplier(.45)
    self:SetStyle(STYLE)

    self:SetHoverOutlineAdd(s(3))

    self._radii = {8, 8, 8, 8}
end

function PANEL:SetRad(rad)
    self._radii = {rad, rad, rad, rad}
end
function PANEL:SetRadii(tl, tr, bl, br)
    self._radii = {tl, tr, bl, br}
end

function PANEL:SetStyle(colors)
    self:SetColorIdle(colors[1])
    self:SetColorHover(colors[2])
    self:SetDisabledColor(colors[3])
    self:SetTextColor(colors[4])

    self._bgColor = self:IsHovered() and colors[2] or colors[1]
end
function PANEL:SetCustomStyle(idleCol, hoverCol, disabledCol, textCol)
    self:SetColorIdle(idleCol)
    self:SetColorHover(hoverCol)
    self:SetDisabledColor(disabledCol)
    self:SetTextColor(textCol)

    self._bgColor = self:IsHovered() and hoverCol or idleCol
end

function PANEL:SetDisabled(bool)
    self.textEntry:SetDisabled(bool)
    self.textEntry:SetCursor(bool and "no" or "beam")

    self._disabled = bool
end
function PANEL:GetDisabled()
    return self._disabled
end
function PANEL:IsEnabled()
    return not self._disabled
end

function PANEL:OnGetFocus()
    self:OnCursorEntered()
    self:SetHoverBlocked(true)
end
function PANEL:OnLoseFocus()
    self:SetHoverBlocked(false)
    self:OnCursorExited()
end

function PANEL:SetMultiline(bool)
    self.textEntry:SetMultiline(bool)

    self.textEntry:DockMargin(margin, margin, margin, margin)
end
function PANEL:IsMultiline()
    return self.textEntry:IsMultiline()
end

-- function PANEL:IsHovered()
--     -- print("Checking hover state. Hovered:", BaseClass.IsHovered(self), "Child Hovered:", self:IsChildHovered(), "Hover Blocked:", self:GetHoverBlocked(), "Text Entry Focused:", self._textEntryFocused)
--     if (self._textEntryFocused) then return true end

--     return BaseClass.IsHovered(self)
-- end

function PANEL:SetIcon(icon, params)
    self._icon = mvp.ui.images.From(icon, params or "smooth")
end

function PANEL:RequestFocus()
    self.textEntry:RequestFocus()
end

function PANEL:Paint(w, h)
    local text = self:GetPlaceholderText()
    local textColor = self:GetPlaceholderColor()

    if ((self:IsHovered() or self:IsChildHovered() or self:GetHoverBlocked() or self._textEntryFocused) and self:IsEnabled()) then
        self._outlineAdd = Lerp(FrameTime() * 8, self._outlineAdd or 0, self:GetHoverOutlineAdd())
    else
        self._outlineAdd = Lerp(FrameTime() * 8, self._outlineAdd or 0, 0)
    end

    RNDX().Rect(0, 0, w, h)
        :Color(self._bgColor)
        :Radii(unpack(self._radii))
        :Draw()
    RNDX().Rect(0, 0, w, h)
        :Color(OUTLINE_COL)
        :Radii(unpack(self._radii))
        :Outline(1 + (self._outlineAdd or 0))
        :Draw()

    if (self:GetValue() == "" and text and text ~= "") then
        local isMultiline = self:IsMultiline()
        draw.SimpleText(text, self:GetPlaceholderFont(), margin, isMultiline and margin or h * .5, textColor, TEXT_ALIGN_LEFT, isMultiline and TEXT_ALIGN_TOP or TEXT_ALIGN_CENTER)
    end
end

function PANEL:AllowInput(val)
    if (self._disabled) then return false end

    if (self.textEntry:CheckNumeric(val)) then 
        return true 
    end
end

mvp.ui.g.Register("mvp.v2.TextInput", PANEL, "EditablePanel")

-- mvp.ui.g.Test("mvp.v2.Frame", 1, 1, function(frame)
--     frame:MakePopup()
-- end) 
 
-- mvp.ui.g.Test("mvp.v2.Frame", 1, 1, function(s)
--     s:MakePopup()

--     local input = vgui.Create("mvp.v2.TextInput", s)
--     input:Dock(TOP)
--     input:DockMargin(margin, margin, margin, 0)
--     input:SetPlaceholderText("Обычное поле")
--     input:SetTall(32)

--     local input = vgui.Create("mvp.v2.TextInput", s)
--     input:Dock(TOP)
--     input:DockMargin(margin, margin, margin, 0)
--     input:SetPlaceholderText("Отключенное поле")
--     input:SetTall(32)
--     input:SetDisabled(true)
-- end)