local ScaleX, ScaleY = mvp.ui.scale.GetScaleX, mvp.ui.scale.GetScaleY

local colorAccent = mvp.ui.config.colors.accent
local colorText = mvp.ui.config.colors.text
local colorDisabled = mvp.ui.config.colors.textMuted


do -- Navbar Tab
    local PANEL = {}

    AccessorFunc(PANEL, "_name", "Name")
    AccessorFunc(PANEL, "_font", "Font")

    AccessorFunc(PANEL, "_icon", "Icon")
    AccessorFunc(PANEL, "_iconSize", "IconSize")
    AccessorFunc(PANEL, "_iconMargin", "IconMargin")

    AccessorFunc(PANEL, "_active", "Active", FORCE_BOOL)

    function PANEL:Init()
        self:SetWide(ScaleX(120))
        
        self:SetName("Tab")
        self:Font("default@21", 600)
        self:SetIconSize(ScaleY(18))
        self:SetIconMargin(ScaleX(5))
        
        self:Feature("click")
        self:AddHoverSound()
        self.hoverAnimFraction = 0
    end

    function PANEL:Paint(w, h)
        local cx, cy = w * .5, h * .5
        local textCol = self:IsHovered() and colorText or colorDisabled
        local animFraction = self.hoverAnimFraction or 0

        if (animFraction < 1) then
            self:PaintContent(cx, cy, textCol)
        end

        if (animFraction > 0) then
            local screenX, screenY = self:LocalToScreen(0, 0)

            local animHeight = h * animFraction

            render.SetScissorRect(screenX, screenY + h * .5 - animHeight * 0.5, screenX + w, screenY + h * .5 + animHeight * 0.5, true)
                self:PaintContent(cx, cy, colorAccent)
            render.SetScissorRect(0, 0, 0, 0, false)
        end
    end

    function PANEL:PaintContent(cx, cy, col)
        local name = self:GetName()
        local font = self:GetFont()
        local icon = self:GetIcon()
        
        if (icon) then
            local iconSize = self:GetIconSize()
            local iconMargin = self:GetIconMargin()
            local textW = mvp.ui.utils.GetTextWidth(name, font)

            local totalW = textW + iconSize + iconMargin
            local x = cx - totalW * .5

            mvp.ui.utils.DrawMaterial(icon, x, cy - iconSize * .5, iconSize, iconSize, col)
            draw.SimpleText(name, font, x + iconSize + iconMargin, cy, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(name, font, cx, cy, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    function PANEL:Setup(data)
        self:SetName(data.name or "Tab")
        
        if (data.font) then
            self:SetFont(data.font)
        end

        if (data.icon) then
            print("Navbar Tab: Setting icon", data.icon)
            if (type(data.icon) == "string") then
                self:SetIcon(Material(data.icon))
            else
                self:SetIcon(data.icon)
            end
        end
    end

    function PANEL:SetActive(active)
        self._active = active

        self:Animate("hoverAnimFraction", active and 1 or 0)
    end

    function PANEL:SizeToContents(margin)
        margin = margin or 0

        local textW = mvp.ui.utils.GetTextWidth(self:GetName(), self:GetFont())

        local totalW = textW + margin * 2

        if (self:GetIcon()) then
            totalW = totalW + self:GetIconSize() + self:GetIconMargin()
        end

        self:SetWide(totalW)
    end
    function PANEL:Font(...)
        self:SetFont(mvp.ui.fonts.Get(...))
    end

    mvp.ui.gui.Register("tui.Navbar.Tab", PANEL)
end

do -- Navbar
    local PANEL = {}

    AccessorFunc(PANEL, "_container", "Container")
    AccessorFunc(PANEL, "_activeTab", "ActiveTab")
    AccessorFunc(PANEL, "_keepTabContent", "KeepTabContent")

    AccessorFunc(PANEL, "_margin", "Margin", FORCE_NUMBER)
    AccessorFunc(PANEL, "_strech", "Strech", FORCE_BOOL)
    
    function PANEL:Init()
        self.tabs = {}

        self:SetMargin(0)

        self.animLineCurrent = 0
        self.animLineTarget = 0
        self.animLineX = 0
        self.animLineW = 0
    end

    function PANEL:AddTab(data)
        local tab = self:Add("tui.Navbar.Tab")
        tab:Dock(LEFT)
        tab:DockMargin(0, 0, self:GetMargin(), 0)
        tab:Setup(data)

        tab.DoClick = function()
            self:SelectTab(tab)
        end

        tab.tabData = data
        tab.navbar = self
        tab.tabIndex = table.insert(self.tabs, tab)
        
        self:Call("OnTabAdded", nil, tab)

        return tab
    end

    function PANEL:GetTabs()
        return self.tabs
    end

    function PANEL:SelectTab(tab, force)
        local keepContent = self:GetKeepTabContent()
        local container = self:GetContainer()

        assert(IsValid(container), "Navbar: Container is not set or invalid!")

        local data = tab.tabData
        if (data.onClick and not data.onClick(force)) then
            return
        end

        local activeTab = self:GetActiveTab()
        if (IsValid(activeTab)) then
            if (activeTab == tab and not force) then
                return 
            end

            activeTab:SetActive(false)
        end

        self:SetActiveTab(tab)
        tab:SetActive(true)

        if (IsValid(activeTab) and IsValid(activeTab.content)) then
            if (keepContent) then
                activeTab.content:Hide()
            else
                activeTab.content:Remove()
            end
        end

        if (IsValid(tab.content)) then
            tab.content:Show()
        else
            tab.content = container:Add(data.class or "tui.Panel")
            tab.content:Dock(FILL)
            tab.content.tab = tab

            if (data.onBuild) then
                data.onBuild(tab.content, tab)
            end
        end

        self:Call("OnTabSelected", nil, tab, tab.content)

        self.animLineTarget = tab.tabIndex
        if (not self.animLineStart) then
            self.animLineCurrent = tab.tabIndex
            self.animLineX = tab:GetPos()
            self.animLineW = tab:GetWide()
        else
            self:Animate("animLineCurrent", self.animLineTarget, .33, math.ease.InOutSine)
            self:Animate("animLineX", select(1, tab:GetPos()), .33, math.ease.InOutSine)
            self:Animate("animLineW", tab:GetWide(), .33, math.ease.InOutSine)
        end

        self.animLineStart = self.animLineCurrent
    end

    function PANEL:PaintOver(w, h)
        local current = self.animLineCurrent
        if (current <= 0) then return end

        local target = self.animLineTarget
        if (target <= 0) then return end

        local gradientH = h * .33
        local x = self.animLineX
        local wide = self.animLineW

        if (wide == 0 and current == target) then
            local tab = self:GetChild(target - 1)

            x = tab:GetPos()
            wide = tab:GetWide()
        end

        surface.SetDrawColor(colorAccent)
        surface.DrawRect(x, h - 2, wide, 2)

        -- x, y, w, h, dir, color
        mvp.ui.utils.DrawMaterialGradient(x, h- gradientH, wide, gradientH, TOP, ColorAlpha(colorAccent, 25))
    end

    function PANEL:PerformLayout(w, h)
        local strech = self:GetStrech()

        if (strech) then
            local tabsCount = #self.tabs
            local tabWidth = (w - self:GetMargin() * (tabsCount - 1)) / tabsCount
            for _, tab in ipairs(self.tabs) do
                tab:SetWide(tabWidth)
            end
        else
            for _, tab in ipairs(self.tabs) do
                tab:SizeToContents(ScaleX(25))
            end
        end

        self.animLineCurrent = self.animLineTarget
        self.animLineX = self:GetChild(self.animLineCurrent - 1):GetPos()
        self.animLineW = self:GetChild(self.animLineCurrent - 1):GetWide()

    end

    mvp.ui.gui.Register("tui.Navbar", PANEL)
end

-- mvp.ui.gui.Test("tui.Frame", ScaleX(1400), ScaleY(800), function(pnl, w, h)
--     pnl:MakePopup()

--     local content = pnl:Add("tui.Panel")
--     content:Dock(FILL)
--     content:DockPadding(ScaleX(10), ScaleY(10), ScaleX(10), ScaleY(10))

--     local navbar = pnl:Add("tui.Navbar")
--     navbar:Dock(TOP)
--     navbar:SetTall(ScaleY(40))
--     navbar:SetStrech(true)
--     navbar:SetMargin(ScaleX(100))

--     local container = content:Add("tui.Panel")
--     container:Dock(FILL)

--     navbar:SetContainer(container)

--     local defaultTab = navbar:AddTab({
--         name = "HOME 123123123",
--         icon = Material("mvp/terminal/icons/dashboard.png", "smooth mips"),
--         class = "tui.Panel",
--         onBuild = function(panel, tab)
--             local label = panel:Add("tui.Label")
--             label:Dock(FILL)

--             label:SetText("Welcome to the Home tab!")
--             label:SetContentAlignment(5)

--             print("Home tab built")
--         end
--     })
--     navbar:AddTab({
--         name = "SETTINGS",
--         icon = Material("mvp/terminal/icons/settings.png", "smooth mips"),
--         class = "tui.Panel",
--         onBuild = function(panel, tab)
--             local label = panel:Add("tui.Label")
--             label:Dock(FILL)

--             label:SetText("Welcome to the Settings tab!")
--             label:SetContentAlignment(5)

--             print("Settings tab built")
--         end
--     })
--     navbar:AddTab({
--         name = "ABOUT",
--         icon = Material("mvp/terminal/icons/credits.png", "smooth mips"),
--         class = "tui.Panel",
--         onBuild = function(panel, tab)
--             local label = panel:Add("tui.Label")
--             label:Dock(FILL)

--             label:SetText("Welcome to the About tab!")
--             label:SetContentAlignment(5)

--             print("About tab built")
--         end
--     })

--     navbar:SelectTab(defaultTab, true)
-- end)