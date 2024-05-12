local PANEL = {}

DEFINE_BASECLASS( "DScrollPanel" )
local arrowMaterial

function PANEL:Init()
    self.pnlCanvas:DockPadding( 2, 2, 2, 2 )

    if (not arrowMaterial) then
        arrowMaterial = mvp.ui.images.Create("v_arrow", "mips smooth")
    end
end

function PANEL:AddItem( item )
    item:Dock( TOP )

    BaseClass.AddItem( self, item )
    self:InvalidateLayout(true)
end

function PANEL:Add( name )

    local Category = vgui.Create( "DCollapsibleCategory", self )
    Category:SetLabel( name )
    Category:SetList( self )

    Category:SetHeaderHeight(mvp.ui.Scale(48))

    Category.angle = Category:GetExpanded() and 180 or 0

    Category.Paint = function(pnl, w, h)
        local headerHeight = pnl:GetHeaderHeight()

        draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, headerHeight, mvp.colors.SecondaryBackground)

        surface.SetDrawColor(ColorAlpha(mvp.colors.Text, pnl:GetExpanded() and 255 or 150))
        arrowMaterial:DrawRotated(w - headerHeight * .5, headerHeight * .5, headerHeight * .5, headerHeight * .5, pnl.angle)
        
        -- surface.SetMaterial(arrowMaterial)
        -- surface.DrawTexturedRectRotated(w - headerHeight * .5, headerHeight * .5, headerHeight * .5, headerHeight * .5, pnl.angle)

        if (pnl:GetExpanded()) then
            pnl.angle = Lerp(FrameTime() * 10, pnl.angle, 180)
        else
            pnl.angle = Lerp(FrameTime() * 10, pnl.angle, 0)
        end
    end

    local catHeader = Category.Header
    catHeader:SetFont(mvp.Font(18, 600))
    catHeader:DockMargin(mvp.ui.Scale(10) - 5, 0, 0, mvp.ui.Scale(10) * .5)

    self:AddItem( Category )

    return Category
end

function PANEL:Paint(w, h)
    -- do nothing
end

vgui.Register("mvp.CategoryList", PANEL, "mvp.ScrollPanel")