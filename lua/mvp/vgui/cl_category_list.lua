local PANEL = {}

DEFINE_BASECLASS( "DScrollPanel" )

function PANEL:Init()

    self.pnlCanvas:DockPadding( 2, 2, 2, 2 )

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

    self:AddItem( Category )

    return Category
end

function PANEL:Paint(w, h)
    -- do nothing
end

vgui.Register("mvp.CategoryList", PANEL, "mvp.ScrollPanel")