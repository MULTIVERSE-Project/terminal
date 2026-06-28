PANEL = {}

local s = mvp.ui.Scale
local RNDX = mvp.RNDX

function PANEL:Init()
    self._buttons = {}
end

function PANEL:AddButton(icon, title, cb)
    local btn = vgui.Create("mvp.v2.Button", self)
    
    AccessorFunc(btn, "_active", "Active", FORCE_COLOR)

    btn:Dock(TOP)
    btn:DockMargin(0, 0, 0, 1)
    btn:SetTall(s(34))

    btn:FFont("default@light", 24)
    btn:SetText(title)
    btn:SetCustomStyle(self:C("foreground", 0.8), self:C("foreground"), self:C("primary", 0.35), self:C("foreground"))
    if (icon) then
        btn:SetIcon(icon)
    end

    btn._iconCol, btn._textCol = self:C("foreground", 0.8), self:C("foreground", 0.8)

    btn.Paint = function(pnl, w, h)
        local x = 0

        if (pnl._active) then
            pnl._iconCol = mvp.utils.LerpColor(FrameTime() * 10, btn._iconCol, self:C("primary"))
            pnl._textCol = mvp.utils.LerpColor(FrameTime() * 10, btn._textCol, self:C("foreground"))
        else
            pnl._iconCol = mvp.utils.LerpColor(FrameTime() * 10, btn._iconCol, pnl._bgColor)
            pnl._textCol = mvp.utils.LerpColor(FrameTime() * 10, btn._textCol, pnl._bgColor)
        end

        if (pnl._icon) then
            local iconSize = h

            pnl._icon:Draw(x, h * .5 - iconSize * .5, iconSize, iconSize, pnl._iconCol)

            x = x + iconSize + s(5)
        end

        draw.SimpleText(
            pnl:GetText(),
            pnl:GetFont(),
            x,
            h * .5,
            pnl._textCol,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )
        
        return true
    end

    btn.DoClick = function(pnl)
        for k, v in ipairs(self._buttons) do
            v._active = false
        end

        pnl._active = true
        cb()
    end

    btn.UpdateStyle = function(pnl)
        pnl:SetCustomStyle(self:C("foreground", 0.8), self:C("foreground"), self:C("primary", 0.35), self:C("foreground"))
        pnl._iconCol, pnl._textCol = self:C("foreground", 0.8), self:C("foreground", 0.8)
    end

    table.insert(self._buttons, btn)

    return btn
end

mvp.ui.g.Register("mvp.v2.FrameSidebar", PANEL, "EditablePanel")


-- mvp.ui.g.Test("mvp.v2.Frame", 1, 1, function(frame)
--     frame:MakePopup()

--     local sidebar = vgui.Create("mvp.v2.FrameSidebar", frame)
--     sidebar:Dock(LEFT)
--     sidebar:DockMargin(0, 0, s(16), 0)
--     sidebar:SetWide(s(280))

--     sidebar:AddButton(Material("mvp/terminal/home.png", "smooth"), "DASHBOARD", function()
--         print("Dashboard clicked")
--     end)
--     sidebar:AddButton(Material("mvp/terminal/settings.png", "smooth"), "SETTINGS", function()
--         print("Settings clicked")
--     end)
--     sidebar:AddButton(Material("mvp/terminal/packages.png", "smooth"), "PACKAGES", function()
--         print("Packages clicked")
--     end)
--     sidebar:AddButton(Material("mvp/terminal/permissions.png", "smooth"), "PERMISSIONS", function()
--         print("Permissions clicked")
--     end)
--     sidebar:AddButton(Material("mvp/terminal/credits.png", "smooth"), "CREDITS", function()
--         print("Credits clicked")
--     end)

--     local content = vgui.Create("DPanel", frame)
--     content:Dock(FILL)
-- end) 