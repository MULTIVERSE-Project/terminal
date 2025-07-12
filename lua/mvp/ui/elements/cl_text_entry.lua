local ScaleX, ScaleY = mvp.ui.scale.GetScaleX, mvp.ui.scale.GetScaleY
local Colors = mvp.ui.config.colors

local colorAccent = Colors.accent
local colorText, colorTextMuted = Colors.text, Colors.textMuted
local colorBackground = Colors.primary


local PANEL = {}

AccessorFunc(PANEL, "_placeholderText", "PlaceholderText")
AccessorFunc(PANEL, "_placeholderColor", "PlaceholderColor")
AccessorFunc(PANEL, "_placeholderFont", "PlaceholderFont")

AccessorFunc(PANEL, "_textSpace", "TextSpace")

local accessors = {
    "Font",
    "HistoryEnabled",
    "Multiline",
    "Numeric",
    "TabbingDisabled",
    "TextColor",
    "UpdateOnType",
    "Value"
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
}

function PANEL:Init()
    self:SetTextSpace(ScaleX(10))
    self:SetTall(ScaleY(30))

    self.textEntry = self:Add("DTextEntry")
    self.textEntry:Dock(FILL)
    self.textEntry:DockPadding(0, 0, 0, 0)
    self.textEntry:DockMargin(0, 0, 0, 0)
    -- self.textEntry:DrawBackground(false)

    self.textEntry.Paint = function(pnl, w, h)
        pnl:DrawTextEntryText(
            pnl:GetTextColor(),
            colorAccent,
            color_white
        )
    end

    for _, accessor in ipairs(accessors) do
        self:CombineAccessor(self.textEntry, accessor)
    end
    
    self:Combine(self.textEntry, "SetMultiline")
    self:Combine(self.textEntry, "IsMultiline")

    for _, fnName in ipairs(dispatch) do
        self:MakeDispatchFn(self.textEntry, fnName)
    end

    self:SetFont(mvp.ui.fonts.Get("default@16"))
    self:SetTextColor(color_white)

    self:SetPlaceholderFont(self:GetFont())
    self:SetPlaceholderColor(colorTextMuted)

    self.backgroundColor = colorBackground

    self:Feature("hover")
    self:SetColorKey("backgroundColor")
    self:SetColorIdle(colorBackground, -5)
end

function PANEL:SetDisabled(bool)
    self.textEntry:SetDisabled(bool)
    self.textEntry:SetCursor(bool and "no" or "beam")
    self._disabled = bool

    if (bool) then
        self:Call("OnDisabled")
    else
        self:Call("OnEnabled")
    end
end

function PANEL:GetDisabled()
    return self._disabled
end

function PANEL:PerformLayout(w, h)
    local space = self:GetTextSpace()
    local offset = 2
    local isMultiline = self:IsMultiline()

    local xPadding, yPadding = space - offset, isMultiline and space or 0

    self:DockPadding(xPadding, yPadding, xPadding, yPadding)
    -- self:DockMargin(0, 0, 0, 0)
end

function PANEL:OnGetFocus()
    self:SetHoverBlocked(true)
end
function PANEL:OnLoseFocus()
    self:SetHoverBlocked(false)
end

function PANEL:Paint(w, h)
    local backgroundColor = self.backgroundColor
    local text = self:GetPlaceholderText()
    local color = self:GetPlaceholderColor()

    local outlineThickness = 1
    local outlineColor = mvp.ui.utils.EditHSVColor(backgroundColor, nil, nil, 0.33)

    draw.RoundedBox(8, 0, 0, w, h, outlineColor)
    draw.RoundedBox(8, outlineThickness, outlineThickness, w - outlineThickness * 2, h - outlineThickness * 2, backgroundColor)

    if (self:GetValue() == "" and text and text ~= "") then
        local space = self:GetTextSpace()
        local x, y = space, self:IsMultiline() and space or h * .5

        draw.SimpleText(text, self:GetPlaceholderFont(), x, y, color, TEXT_ALIGN_LEFT, self:IsMultiline() and TEXT_ALIGN_TOP or TEXT_ALIGN_CENTER)
    end
end

mvp.ui.gui.Register("tui.TextEntry", PANEL)