local PANEL = {}

AccessorFunc(PANEL, "m_iColumnCount", "ColumnCount")
AccessorFunc(PANEL, "m_iSpaceX", "SpaceX")
AccessorFunc(PANEL, "m_iSpaceY", "SpaceY")
AccessorFunc(PANEL, "m_fSizeRatio", "SizeRatio")

function PANEL:Init()
    self:SetSpaceX(0)
    self:SetSpaceY(0)
    self:SetColumnCount(4)
end

function PANEL:PerformLayout(w, h)
    self:Layout(w, h)

    local contentHeight = self:GetContentHeight()
    -- print(self, contentHeight, h)
    if (contentHeight ~= h) then
        self:SetSizeToContents()
    end
end

function PANEL:SizeToContentsY()
    local contentHeight = self:GetContentHeight()
    self:SetTall(contentHeight)
end

-- function PANEL:Clear()
--     for _, child in ipairs(self:GetChildren()) do
--         child:Remove()
--     end

--     self:InvalidateLayout()
-- end

function PANEL:SetSpace(space)
    self:SetSpaceX(space)
    self:SetSpaceY(space)
end

function PANEL:Layout(w, h)
    local children = self:GetVisibleChildren()

    local spaceX, spaceY = self:GetSpaceX(), self:GetSpaceY()
    local columnCount = self:GetColumnCount()

    local pl, pt, pr, pb = self:GetDockPadding()

    local wide = math.floor((w - spaceX * (columnCount - 1) - pl - pr) / columnCount)

    local x, y = pl, pt
    local ratio = self:GetSizeRatio()

    for i, child in ipairs(children) do
        child:SetWide(wide)
        child:SetPos(x, y)

        if (ratio) then
            child:SetTall(math.Round(wide * ratio))
        end

        x = x + wide + spaceX

        if (i % columnCount == 0) then
            y = y + child:GetTall() + spaceY
            x = pl
        end
    end
end

function PANEL:GetVisibleChildren()
    local result, count = {}, 0
    for _, ch in ipairs(self:GetChildren()) do
        if (ch:IsVisible()) then
            count = count + 1
            result[count] = ch
        end
    end
    return result
end

function PANEL:GetContentHeight()
    local height = 0
    local children = self:GetChildren()
    local visible = 0

    for _, child in ipairs(children) do
        if (child:IsVisible()) then
            visible = visible + 1
        end
    end

    local rows = math.ceil(visible / self:GetColumnCount())
    local _pl, pt, _pr, pb = self:GetDockPadding()

    local height = rows * self:GetRowHeight() + (rows - 1) * self:GetSpaceY() + pt + pb

    return height
end

function PANEL:GetRowHeight()
    local rowHeight = 0
    for _, ch in ipairs(self:GetVisibleChildren()) do
        rowHeight = math.max(rowHeight, ch:GetTall())
    end
    return rowHeight
end

-- function PANEL:Paint(w, h)
--     surface.SetDrawColor(255, 0, 0)
--     surface.DrawRect(0, 0, w, h)
-- end

function PANEL:SetSizeToContents()
    local contentHeight = self:GetContentHeight()
    self:SetTall(contentHeight)
end

function PANEL:AddItem(panel)
end

function PANEL:GetItems()
    return self:GetChildren()
end

mvp.ui.g.Register("mvp.v2.Grid", PANEL, "EditablePanel")