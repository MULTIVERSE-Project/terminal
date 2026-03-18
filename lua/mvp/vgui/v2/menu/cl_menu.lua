local s = mvp.ui.Scale
local PANEL = {}

DEFINE_BASECLASS("DMenu")

AccessorFunc(PANEL, "MinWidth", "MinimumWidth", FORCE_NUMBER)

function PANEL:Init()
    BaseClass.Init(self)

    self:SetPadding(0)
    self:SetAlpha(0)
    self:AlphaTo(255, 0.1, 0)

    self._options = {}
end

function PANEL:RoundButtons()
    local count = #self._options
    for i, option in ipairs(self._options) do
        if (count == 1) then
            option:SetRad(s(8))
        elseif (i == 1) then
            option:SetRadii(s(8), s(8), 0, 0)
        elseif (i == count) then
            option:SetRadii(0, 0, s(8), s(8))
        else
            option:SetRad(0)
        end
    end
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
    local option = vgui.Create("mvp.v2.MenuOption", self)
    option:SetMenu(self)
    option:SetText(name)
    option:SetTall(s(40))
    option:SetStyle(MVP_STYLE_SECONDARY)

    option.DoClick = function(pnl)
        local menu = pnl:GetMenu()
        while (IsValid(menu)) do
            menu:Remove()
            menu = menu:GetParent()
        end

        if (func and isfunction(func)) then
            func()
        end
    end


    self:AddPanel(option)
    table.insert(self._options, option)

    self:RoundButtons()

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

end

mvp.ui.g.Register("mvp.v2.Menu", PANEL, "DMenu")

-- mvp.ui.g.Test("mvp.v2.Frame", 1, 1, function(frame)
--     frame:MakePopup()

--     local btn = vgui.Create("mvp.v2.Button", frame)
--     btn:SetText("Open Menu")
--     btn:SizeToContentsX(s(20))
--     btn:SetTall(s(40))
--     btn:Center()

--     btn.DoClick = function(pnl)
--         local menu = vgui.Create("mvp.v2.Menu")
--         menu:SetMinimumWidth(pnl:GetWide())
--         menu:AddOption("Option 1", function() print("Option 1 selected") end)
--         menu:AddOption("Option 2", function() print("Option 2 selected") end)

--         local subMenuOption = menu:AddOption("Submenu")
--         local subMenu = subMenuOption:AddSubMenu()
--         subMenu:AddOption("Sub Option 1", function() print("Sub Option 1 selected") end)
--         subMenu:AddOption("Sub Option 2", function() print("Sub Option 2 selected") end)

--         menu:Open(pnl:LocalToScreen(0, pnl:GetTall()))
--     end

-- end) 