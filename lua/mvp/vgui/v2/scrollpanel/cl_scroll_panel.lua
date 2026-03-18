PANEL = {}

local s = mvp.ui.Scale

function PANEL:Init()
    self.canvas = vgui.Create("mvp.v2.ScrollPanel.Canvas", self)
    self.scroll = vgui.Create("mvp.v2.ScrollPanel.Bar", self)

    self.canvas:On("OnContainerTallUpdated", function(panel, canvasTall, containerTall)
        self.scroll:SetUp(canvasTall, containerTall)
    end)

    self:Combine(self.canvas, "AddPanel")
    self:Combine(self.canvas, "RemovePanel")
    self:Combine(self.canvas, "OnPanelAdded")
    self:Combine(self.scroll, "OnMouseWheeled")
    self:CombineMutator(self.canvas, "Space")
end

function PANEL:PerformLayout(w, h)
    self.canvas:Dock(FILL)

    self.scroll:Dock(RIGHT)
    self.scroll:SetWide(s(6))
    self.scroll:DockMargin(s(5), 0, 0, 0)
end

function PANEL:OnVScroll(offset)
    self:GetContainer():SetY(offset)
end

function PANEL:GetContainer()
    return self.canvas.container
end

function PANEL:GetCanvas()
    return self.canvas
end

function PANEL:GetItems()
    return self:GetContainer():GetChildren()
end

function PANEL:Add(class)
    local panel = vgui.Create(class)

    assert(panel, "Panel class \"" .. class .. "\" doesn\'t exist")

    self.canvas:InvalidateParent(true)

    self:AddPanel(panel)

    return panel
end

function PANEL:Clear()
    self.canvas.container:Clear()
    self.canvas:UpdateSize()

    PrintTable(self:GetChildren())
end

function PANEL:Think()
    local scroll = self.scroll:GetScroll()
    local canvasSize = self.scroll.CanvasSize

    if (scroll ~= canvasSize) then
        local target = math.min(scroll, canvasSize)
        self.scroll:SetScroll(target)

        if (canvasSize <= 1) then
            self.canvas.container:SetPos(0, -scroll)
            self.scroll.Current = 0
            self.scroll.Scroll = 0
        end
    end
end

mvp.ui.g.Register("mvp.v2.ScrollPanel", PANEL)

-- mvp.ui.g.Test("mvp.v2.Frame", 1, 1, function(pnl) 
--     pnl:MakePopup()
--     pnl:SetTitle("ScrollPanel Test")

--     local list = pnl:Add("mvp.v2.ScrollPanel")
--     list:Dock(FILL)
--     list:DockMargin(15, 10, 15, 5)

--     for i = 1, 150 do
--         local btn = list:Add("mvp.v2.Button")
--         btn:SetText("Button #" .. i)
--         btn:SetStyle(MVP_STYLE_SECONDARY)
--         btn:Dock(TOP)
--         btn:DockMargin(0, 0, 0, 5)
--     end
-- end)