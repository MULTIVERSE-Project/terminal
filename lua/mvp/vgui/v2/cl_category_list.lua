local PANEL = {}
local s = mvp.ui.Scale

local RNDX = mvp.RNDX

DEFINE_BASECLASS( "DScrollPanel" )

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

function PANEL:Init()
    self.canvas:DockPadding( 2, 2, 2, 2 )

    self._arrowMaterial = mvp.ui.images.From(Material("mvp/terminal/vgui/arrow.png", "smooth"))
end

function PANEL:AddItem( item )
    item:Dock( TOP )

    BaseClass.AddItem( self, item )
    self:InvalidateLayout(true)
end

function PANEL:AddCategory( name )
    local cat = vgui.Create("DCollapsibleCategory")
    cat:SetLabel(name)
    cat:SetHeaderHeight(s(28))
    cat._angle = cat:GetExpanded() and 180 or 0

    cat.Paint = function(pnl, w, h)
        local hh = pnl:GetHeaderHeight()

        -- RNDX().Rect(0, 0, w, hh)
        --     :Color(self:C("primary"))
        --     :Rad(8)
        --     :Draw()

        local tw = getTextWidth(pnl.Header:GetFont(), pnl.Header:GetText())

        self._arrowMaterial:DrawRotated(w - s(12 + 8), hh * .5, s(24), s(24), pnl._angle, self:C("foreground", pnl:GetExpanded() and 1 or .6))

        RNDX().Rect(tw + s(25), hh * .5 - 1, w - (tw + s(15) + s(32 + 28)), 1)
            :Color(pnl:GetExpanded() and self:C("foreground", .65) or ColorAlpha(self:C("foreground"), 100))
            :Draw()

        if (pnl:GetExpanded()) then
            pnl._angle = Lerp(FrameTime() * 10, pnl._angle, 180)
        else
            pnl._angle = Lerp(FrameTime() * 10, pnl._angle, 0)
        end
    end

    cat.Clear = function(pnl)
        for _, pnl2 in ipairs(pnl:GetChildren()) do
            if (pnl2 ~= pnl.Header and pnl2 ~= pnl.List) then
                pnl2:Remove()
            end
        end
    end

    local catHeader = cat.Header
    catHeader:SetFont(self:FF("default@light", 20))

    -- local Category = self:Add( "DCollapsibleCategory" )
    -- Category:SetLabel( name )
    -- Category:SetList( self )

    -- Category:SetHeaderHeight(mvp.ui.Scale(48))

    -- Category.angle = Category:GetExpanded() and 180 or 0

    -- Category.Paint = function(pnl, w, h)
    --     local headerHeight = pnl:GetHeaderHeight()

    --     draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, headerHeight, mvp.colors.SecondaryBackground)

    --     surface.SetDrawColor(ColorAlpha(mvp.colors.Text, pnl:GetExpanded() and 255 or 150))
    --     arrowMaterial:DrawRotated(w - headerHeight * .5, headerHeight * .5, headerHeight * .5, headerHeight * .5, pnl.angle)
        
    --     -- surface.SetMaterial(arrowMaterial)
    --     -- surface.DrawTexturedRectRotated(w - headerHeight * .5, headerHeight * .5, headerHeight * .5, headerHeight * .5, pnl.angle)

    --     if (pnl:GetExpanded()) then
    --         pnl.angle = Lerp(FrameTime() * 10, pnl.angle, 180)
    --     else
    --         pnl.angle = Lerp(FrameTime() * 10, pnl.angle, 0)
    --     end
    -- end

    -- local catHeader = Category.Header
    -- catHeader:SetFont(mvp.Font(18, 600))
    -- catHeader:DockMargin(mvp.ui.Scale(10) - 5, 0, 0, mvp.ui.Scale(10) * .5)

    -- self:AddItem( Category )

    -- return Category

    self:AddPanel(cat)
    return cat
end

function PANEL:Paint(w, h)
    -- do nothing
end

mvp.ui.g.Register("mvp.v2.CategoryList", PANEL, "mvp.v2.ScrollPanel")

-- mvp.ui.g.Test("mvp.v2.Frame", 1, 1, function(pnl) 
--     pnl:MakePopup()
--     pnl:SetTitle("ScrollPanel Test")

--     local list = pnl:Add("mvp.v2.CategoryList")
--     list:Dock(FILL)
--     -- list:DockMargin(15, 10, 15, 5)

--     for i = 1, 5 do
--         local cat = list:AddCategory("Test Category #" .. i)
        
--         for j = 1, 10 do
--             local lbl = vgui.Create("mvp.v2.Label", cat)
--             lbl:Dock(TOP)
--             lbl:DockMargin(10, 5, 10, 5)
--             lbl:SetText("Item #" .. j .. " in Category #" .. i)
--             lbl:SetFont(pnl:FF("default@regular", 16))
--             lbl:SizeToContentsY()
--         end
--     end
-- end)