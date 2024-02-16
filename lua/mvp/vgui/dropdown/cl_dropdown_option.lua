local PANEL = {}

DEFINE_BASECLASS( "mvp.Button" )

AccessorFunc( PANEL, "menu", "Menu" )
AccessorFunc( PANEL, "checked", "Checked" )
AccessorFunc( PANEL, "isCheckable", "IsCheckable" )

function PANEL:Init()
    
end

function PANEL:SetSubMenu(menu)
    self.SubMenu = menu
end

function PANEL:AddSubMenu()
    local SubMenu = vgui.Create("mvp.DropdownMenu")
    SubMenu:SetVisible(false)
    SubMenu:SetParent(self)

    self:SetSubMenu(SubMenu)

    return SubMenu
end

function PANEL:DoClickInternal()
	self:GetMenu():Remove()
end

function PANEL:OnCursorEntered()
	BaseClass.OnCursorEntered( self )

	if ( IsValid( self.ParentMenu ) ) then
		self.ParentMenu:OpenSubMenu( self, self.SubMenu )
		return
	end

	self:GetParent():OpenSubMenu( self, self.SubMenu )
end

function PANEL:Paint(w, h)
    BaseClass.Paint(self, w, h)

    if (self.SubMenu) then
        -- @todo: draw arrow
    end

    return true
end

vgui.Register("mvp.DropdownMenuOption", PANEL, "mvp.Button")