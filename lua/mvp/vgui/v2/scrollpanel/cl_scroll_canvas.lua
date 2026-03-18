PANEL = {}

local s = mvp.ui.Scale

AccessorFunc(PANEL, "_space", "Space")

function PANEL:Init()
    self.container = self:Add("Panel")

    self:SetSpace(s(10))
end

function PANEL:PerformLayout(w, h)
    self:UpdateSize()
end

function PANEL:GetPanels()
    return self.container:GetChildren()
end

function PANEL:CalculateTall()
    local panels = self:GetPanels()
    local count = #panels
    local size = 0

    for index, child in ipairs(panels) do
        if child:IsVisible() then
            local _, top, _, bottom = child:GetDockMargin()

            size = size + child:GetTall()
            size = size + top
            size = size + (index ~= count and bottom or 0)
        end
    end

    return size
end

function PANEL:UpdateSize()
    local w, h = self:GetWide(), self:CalculateTall()

    self.container:SetSize(w, h)

    self:Call("OnContainerTallUpdated", nil, self:GetTall(), h)
end

function PANEL:AddPanel(panel)
    panel:SetParent(self.container)
    panel:Dock(TOP)
    panel:DockMargin(0, 0, 0, self:GetSpace())

    local class = panel.ClassName or "Panel"

    if not class:find("mvp") then
        mvp.ui.g.Extend(panel)
    end

    panel:InjectEventHandler("PerformLayout")
    panel:On("PerformLayout", function()
        self:UpdateSize()
    end)

    self:Call("OnPanelAdded", nil, panel)

    return panel
end

function PANEL:RemovePanel(panel)
    panel:Remove()
    self:UpdateSize()
end

function PANEL:OnPanelAdded()
end

mvp.ui.g.Register("mvp.v2.ScrollPanel.Canvas", PANEL)