PANEL = {}

local s = mvp.ui.Scale

function PANEL:Init()
    self._sidebar = vgui.Create("mvp.v2.FrameSidebar", self)
    self._sidebar:Dock(LEFT)
    self._sidebar:DockMargin(0, 0, s(16), 0)
    self._sidebar:SetWide(s(280))

    self._content = vgui.Create("EditablePanel", self)
    self._content:Dock(FILL)
    mvp.ui.g.Extend(self._content)
end

function PANEL:AddButton(icon, title, cb, activeByDefault)
    local btn = self._sidebar:AddButton(icon, title, function()
        self._content:Clear()
        cb(self._content)
    end)

    if (activeByDefault) then
        btn:SetActive(true)
        
        self._content:Clear()
        cb(self._content)
    end
end

mvp.ui.g.Register("mvp.v2.FrameWithSidebar", PANEL, "mvp.v2.Frame")

-- mvp.ui.g.Test("mvp.v2.FrameWithSidebar", 1, 1, function(frame)
--     frame:MakePopup()

--     frame:SetTitle("Terminal") 
--     frame:SetSubTitle("Administration Panel")

--     frame:AddButton(Material("mvp/terminal/home.png", "smooth"), "DASHBOARD", function(content)
--         local lbl = vgui.Create("mvp.v2.Label", content)
--         lbl:Dock(TOP)
--         lbl:SetText("Welcome to the dashboard!")
--         lbl:SetFont(frame:FF("header@semibold", 24))
--         lbl:SizeToContentsY()
--     end, true)
--     frame:AddButton(Material("mvp/terminal/settings.png", "smooth"), "SETTINGS", function(content)
--         local lbl = vgui.Create("mvp.v2.Label", content)
--         lbl:Dock(TOP)
--         lbl:SetText("Here you can change your settings.")
--         lbl:SetFont(frame:FF("header@semibold", 24))
--         lbl:SizeToContentsY()
--     end)
--     frame:AddButton(Material("mvp/terminal/packages.png", "smooth"), "PACKAGES", function(content)
--         local lbl = vgui.Create("mvp.v2.Label", content)
--         lbl:Dock(TOP)
--         lbl:SetText("Here you can change your packages.")
--         lbl:SetFont(frame:FF("header@semibold", 24))
--         lbl:SizeToContentsY()
--     end)
--     frame:AddButton(Material("mvp/terminal/permissions.png", "smooth"), "PERMISSIONS", function(content)
--         local lbl = vgui.Create("mvp.v2.Label", content)
--         lbl:Dock(TOP)
--         lbl:SetText("Here you can change your permissions.")
--         lbl:SetFont(frame:FF("header@semibold", 24))
--         lbl:SizeToContentsY()
--     end)
--     frame:AddButton(Material("mvp/terminal/credits.png", "smooth"), "CREDITS", function(content)
--         local lbl = vgui.Create("mvp.v2.Label", content)
--         lbl:Dock(TOP)
--         lbl:SetText("Credits to everyone who helped!")
--         lbl:SetFont(frame:FF("header@semibold", 24))
--         lbl:SizeToContentsY()
--     end)
-- end)