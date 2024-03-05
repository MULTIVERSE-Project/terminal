local PANEL = {}

AccessorFunc(PANEL, "roundness", "Roundness")

function PANEL:Init()
    self.textEntry = vgui.Create("DTextEntry", self)
    self.textEntry:Dock(FILL)
    self.textEntry:DockMargin(8, 0, 8, 0)
    self.textEntry:SetFont(mvp.Font(18, 600))
    self.textEntry:SetTextColor(mvp.colors.Text)
    self.textEntry:SetHighlightColor(mvp.colors.SecondaryBackground)
    self.textEntry:SetCursorColor(mvp.colors.Text)
    self.textEntry:SetPaintBackground(false)
    -- self.textEntry:SetText("das")

    self.textEntry.OnGetFocus = function()
        self:OnGetFocus()
    end
    self.textEntry.OnLoseFocus = function()
        self:OnLoseFocus()
    end

    self.textEntry.OnValueChange = function(_, val)
        self:OnValueChange(val)
    end

    -- self:DockPadding(8, 8, 8, 8)

    self:SetRoundness(mvp.ui.ScaleWithFactor(16))

    self.colors = {}
    self.colors.Background = mvp.colors.SecondaryBackground
    self.colors.BackgroundFocused = mvp.colors.SecondaryAccent

    self.backgroundColor = self.colors.Background

    local textEntryBase = baseclass.Get("DTextEntry")
    for k, v in pairs(textEntryBase) do
        if not self[k] then
            self[k] = function(_, ...)
                return v(self.textEntry, ...)
            end
        end
    end
end

function PANEL:SetText(text)
    self.textEntry:SetText(text)
end

function PANEL:GetText()
    return self.textEntry:GetText()
end

function PANEL:SetMultiline(val)
    self.textEntry:SetMultiline(val)    

    if (val) then
        self.textEntry:DockMargin(8, 8, 8, 8)
    else
        self.textEntry:DockMargin(8, 0, 8, 0)
    end
end

function PANEL:OnValueChange(val)
    -- override
end

function PANEL:Paint(w, h)
    draw.RoundedBox(self.roundness, 0, 0, w, h, self.backgroundColor)
end

function PANEL:OnGetFocus()
    self:LerpColor("backgroundColor", self.colors.BackgroundFocused, .2)
end

function PANEL:OnLoseFocus()
    self:LerpColor("backgroundColor", self.colors.Background, .2)
end

vgui.Register("mvp.TextEntry", PANEL, "EditablePanel")