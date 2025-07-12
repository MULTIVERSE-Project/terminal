local PANEL = {}

AccessorFunc(PANEL, "_spacing", "Spacing", FORCE_NUMBER)

local scaleY = mvp.ui.scale.GetScaleY

function PANEL:Init()
    self._container = self:Add("tui.Panel")

    self:SetSpacing(scaleY(2))
end

function PANEL:GetPanels()
    return self._container:GetChildren()
end

function PANEL:CalculateHeight()
    local panels = self:GetPanels()
    local count = #panels

    local height = 0

    for i, pnl in ipairs(panels) do
        if (pnl:IsVisible()) then
            local  _, top, _, bottom = pnl:GetDockMargin()

            height = height + pnl:GetTall() + top + (i ~= count and bottom or 0)
        end
    end

    return height
end

function PANEL:UpdateSize()
    local w, h = self:GetWide(), self:CalculateHeight()

    self._container:SetSize(w, h)
    self:Call("OnContainerSizeChanged", nil, self:GetTall(), h)
end

function PANEL:AddPanel(pnl)
    pnl:SetParent(self._container)
    pnl:Dock(TOP)
    pnl:DockMargin(0, 0, 0, self:GetSpacing())

    local class = pnl.ClassName or "Panel"
    if (not class:find("tui")) then
        mvp.ui.gui.Extend(pnl)
    end

    pnl:CreateEventHandler("PerformLayout")
    pnl:On("PerformLayout", function()
        self:UpdateSize()
    end)

    self:Call("OnPanelAdded", nil, pnl)
end

function PANEL:OnPanelAdded(pnl)
end

mvp.ui.gui.Register("tui.Scroll.Canvas", PANEL)