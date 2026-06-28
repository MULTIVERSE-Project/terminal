local PANEL = {}

DEFINE_BASECLASS( "mvp.v2.Button" )

AccessorFunc( PANEL, "menu", "Menu" )
AccessorFunc( PANEL, "checked", "Checked" )
AccessorFunc( PANEL, "isCheckable", "IsCheckable" )

function PANEL:Init()

end

function PANEL:SetSubMenu(menu)
    self.SubMenu = menu
end

function PANEL:AddSubMenu()
    local SubMenu = vgui.Create("mvp.v2.Menu")
    SubMenu:SetVisible(false)
    SubMenu:SetParent(self)

    self:SetSubMenu(SubMenu)

    return SubMenu
end

function PANEL:OnCursorEntered()
    BaseClass.OnCursorEntered( self )

    if ( IsValid( self.ParentMenu ) ) then
        self.ParentMenu:OpenSubMenu( self, self.SubMenu )
        return
    end

    self:GetParent():OpenSubMenu( self, self.SubMenu )
end

mvp.ui.g.Register("mvp.v2.MenuOption", PANEL, "mvp.v2.Button")