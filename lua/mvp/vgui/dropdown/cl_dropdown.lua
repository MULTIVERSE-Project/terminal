local PANEL = {}

DEFINE_BASECLASS("DMenu")

AccessorFunc(PANEL, "roundness", "Roundness")

function PANEL:Init()
    BaseClass.Init(self)

    self:SetPadding(0)
    self:SetAlpha(0)
    self:AlphaTo(255, 0.1, 0)

    self:SetRoundness(mvp.ui.Scale(16))

    self.colors = {
        Background = mvp.colors.Background
    }

    self.backgroundColor = self.colors.Background
end

function PANEL:PerformLayout( w, h )

	local w = self:GetMinimumWidth()

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		pnl:InvalidateLayout( true )
		w = math.max( w, pnl:GetWide() )
	end

	self:SetWide( w )

	local y = self:GetPadding()

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		pnl:SetWide( w )
		pnl:SetPos( 0, y )

		y = y + pnl:GetTall()
	end

	y = math.min( y, self:GetMaxHeight() )

	self:SetTall( y + self:GetPadding() )

	DScrollPanel.PerformLayout( self, w, h )
end

function PANEL:AddOption(name, func)
    local option = vgui.Create("mvp.DropdownMenuOption", self)
    option:SetMenu(self)
    option:SetText(name)
    option:SetFont(mvp.Font(18, 500))
    option:SetTall(mvp.ui.Scale(40))
    option:SetRoundness(self.roundness)

    option.colors.Background = Color(0, 0, 0, 0)
    option.backgroundColor = option.colors.Background

    if (func and isfunction(func)) then
        option.DoClick = func
    end

    self:AddPanel(option)

    return option
end

function PANEL:AddSpacer()
    local spacer = vgui.Create("DPanel", self)
    spacer:SetTall(1)
    spacer.Paint = function(pnl, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end

    self:AddPanel(spacer)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(self.roundness, 0, 0, w, h, self.backgroundColor)
end

vgui.Register("mvp.DropdownMenu", PANEL, "DMenu")