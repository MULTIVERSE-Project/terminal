local PANEL = {}

function PANEL:Init()
    self.buttons = {}

    self:SetRoundness(mvp.ui.ScaleWithFactor(16))
end

local spaceBetween = mvp.ui.Scale(10)

AccessorFunc(PANEL, "roundness", "Roundness")

function PANEL:AddButton(text, callback)
    local button = vgui.Create("mvp.Button", self)
    button:SetText(text)
    button:Dock(LEFT)
    button:SetFont(mvp.Font(18, 600))
    button:SetRoundness(self:GetRoundness())
    if (callback) then
        button.DoClick = callback
    end

    table.insert(self.buttons, button)

    self:InvalidateLayout()

    return button
end

function PANEL:PerformLayout()
    local firstButton = self.buttons[1]
    local lastButton = self.buttons[#self.buttons]

    local buttonWidth = 0
    for k, v in pairs(self.buttons) do
        v:SetExtendedRoundness({false, false, false, false})
        v:SizeToContentsX(spaceBetween * 2)

        buttonWidth = buttonWidth + v:GetWide()
    end

    if (IsValid(firstButton)) then
        firstButton:SetRoundedTopLeft(true)
        firstButton:SetRoundedBottomLeft(true)
    end

    if (IsValid(lastButton)) then
        lastButton:SetRoundedTopRight(true)
        lastButton:SetRoundedBottomRight(true)
    end

    self:SetWide(buttonWidth)
end

vgui.Register("mvp.ButtonGroup", PANEL, "EditablePanel")