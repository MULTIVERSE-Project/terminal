mvp = mvp or {}
mvp.menus = mvp.menus or {}

local homeTitleFont = mvp.Font(28, 800)
local homeDescriptionFont = mvp.Font(22, 500)

local spaceBetween = mvp.ui.Scale(10)
local roundness = mvp.ui.ScaleWithFactor(16)

local arrowMaterial = Material("mvp/terminal/vgui/arrow.png", "smooth")
local restoreToDefaultMaterial = Material("mvp/terminal/vgui/undo.png", "smooth")
local linkMaterial = Material("mvp/terminal/vgui/link.png", "smooth mips")

local addNotification = function(container, header, text, color, actions)
    local scale = mvp.ui.ScaleWithFactor(8)

    local card = vgui.Create("EditablePanel", container)
    card:Dock(TOP)
    card:DockMargin(0, 0, 0, spaceBetween * .5)
    
    container:InvalidateLayout(true)
    card:InvalidateParent(true)

    card.Paint = function(pnl, w, h)
        draw.RoundedBox(scale, 0, 0, w - 3, h, color)
        draw.RoundedBoxEx(scale, scale, 0, w - scale, h, mvp.colors.BackgroundHover, false, true, false, true)
    end

    local cardActions = vgui.Create("EditablePanel", card)
    cardActions:Dock(RIGHT)
    cardActions:SetWide(mvp.ui.Scale(128))
    cardActions:DockMargin(0, spaceBetween, spaceBetween, 0)

    for k, v in ipairs(actions) do
        local action = vgui.Create("mvp.Button", cardActions)
        action:Dock(TOP)
        action:DockMargin(0, 0, 0, spaceBetween * .5)
        action:SetText(v.text)
        action:SetTall(mvp.ui.Scale(32))
        action:SetRoundness(mvp.ui.ScaleWithFactor(8))

        action.colors.BackgroundHover = mvp.colors.Background

        action.DoClick = function()
            if (v.callback) then
                v.callback()
            end
        end
    end

    local cardTexts = vgui.Create("DPanel", card)
    cardTexts:Dock(FILL)
    cardTexts:DockMargin(scale + spaceBetween, 0, spaceBetween, 0)
    cardTexts:InvalidateParent(true)

    local cardWidth = cardTexts:GetWide()

    
    local wrappedText = mvp.utils.WrapText(text, mvp.Font(20, 500), cardWidth)
    
    surface.SetFont(mvp.Font(22, 600))
    local _, headerHeight = surface.GetTextSize(header)

    surface.SetFont(mvp.Font(20, 500))
    local _, wrappedTextHeight = surface.GetTextSize(wrappedText)

    card:SetTall(wrappedTextHeight + headerHeight + spaceBetween * 2)

    cardTexts.Paint = function(pnl, w, h)
        draw.SimpleText(header, mvp.Font(22, 600), 0, 5, color)
        draw.DrawText(wrappedText, mvp.Font(20, 500), 0, headerHeight + spaceBetween, mvp.colors.Text, TEXT_ALIGN_LEFT)
    end
end

local linkTypeMaterials = {
    ["workshop"] = Material("mvp/terminal/icons/steam.png", "smooth mips"),
    ["github"] = Material("mvp/terminal/icons/github.png", "smooth mips"),
    ["store"] = Material("mvp/terminal/icons/store.png", "smooth mips")
}

local linkTypeNames = {
    ["workshop"] = "Steam Workshop",
    ["github"] = "GitHub",
    ["store"] = "Store"
}

function mvp.menus.AdminCredits(container, defaultActive)
    defaultActive = defaultActive or "terminal"

    local content = vgui.Create("EditablePanel", container)
    content:Dock(FILL)
    content:InvalidateParent(true)

    local title = vgui.Create("mvp.MenuHeader", content)
    title:Dock(TOP)
    title:SetTall(mvp.ui.Scale(64))  
    
    title:SetText("Credits")
    title:SetDescription("This is the credits for the Terminal or materials used in the Terminal")

    local pageContent = vgui.Create("EditablePanel", content)
    pageContent:Dock(FILL)
    pageContent:InvalidateParent(true)

    local topNavigation = vgui.Create("DHorizontalScroller", pageContent)
    topNavigation:Dock(TOP)
    topNavigation:SetTall(mvp.ui.Scale(38))
    topNavigation:SetOverlap( -spaceBetween * .5 )

    local creditsContent = vgui.Create("EditablePanel", pageContent)
    creditsContent:Dock(FILL)
    creditsContent:DockMargin(0, spaceBetween * .5, 0, 0)
    creditsContent:InvalidateParent(true)

    local buttonGroup = vgui.Create("mvp.ButtonGroup")
    topNavigation:AddPanel(buttonGroup)
    buttonGroup:SetRoundness(mvp.ui.ScaleWithFactor(8))

    local buttons = {}

    buttons["terminal"] = buttonGroup:AddButton("Terminal", function()
        creditsContent:Clear()

        local contributors = mvp.credits.GetContributors()

        local grid = vgui.Create("ThreeGrid", creditsContent)
        grid:Dock(FILL)
        grid:InvalidateParent(true)

        grid:SetColumns(2)
        grid:SetHorizontalMargin(spaceBetween * .5)
        grid:SetVerticalMargin(spaceBetween * .5)

        for k, v in ipairs(contributors) do
            local pnl = vgui.Create("DPanel")
            pnl:SetTall(mvp.ui.Scale(128))

            local avatar = vgui.Create("AvatarImage", pnl)
            avatar:Dock(LEFT)
            avatar:DockMargin(spaceBetween, spaceBetween, spaceBetween, spaceBetween)
            avatar:InvalidateParent(true)
            avatar:SetSteamID(v.steamId, 128)
            avatar:SetWide(avatar:GetTall())

            pnl.Paint = function(pnl, w, h)
                draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))

                local _, th = draw.SimpleText(v.name, mvp.Font(36, 600), spaceBetween + avatar:GetWide() + spaceBetween, spaceBetween, mvp.colors.Accent)
                draw.SimpleText(v.role, mvp.Font(24, 500), spaceBetween + avatar:GetWide() + spaceBetween, spaceBetween + th, mvp.colors.Text)
            end

            local button = vgui.Create("mvp.Button", pnl)
            button:Dock(BOTTOM)
            button:DockMargin(0, spaceBetween * 1.3, spaceBetween * 1.3, spaceBetween * 1.3)
            button:SetTall(mvp.ui.Scale(40))
            button:SetFont(mvp.Font(20, 500))
            button:SetRoundness(mvp.ui.ScaleWithFactor(8))
            button:SetText("Steam Profile")
            button:SetIcon(linkTypeMaterials["workshop"])
            
            button.DoClick = function()
                gui.OpenURL("https://steamcommunity.com/profiles/" .. v.steamId)
            end

            grid:AddCell(pnl)
        end
    end)
    buttons["icons"] = buttonGroup:AddButton("Icons", function()
        creditsContent:Clear()
        
        local icons = mvp.credits.GetIcons()

        local grid = vgui.Create("ThreeGrid", creditsContent)
        grid:Dock(FILL)
        grid:InvalidateParent(true)

        grid:SetColumns(3)
        grid:SetHorizontalMargin(spaceBetween * .5)
        grid:SetVerticalMargin(spaceBetween * .5)

        for k, v in pairs(icons) do
            local icon = vgui.Create("DPanel")
            icon:SetTall(mvp.ui.Scale(64))
            icon:DockMargin(0, 0, 0, spaceBetween * .5)

            local iconMaterial = v.icon
            local iconSize = mvp.ui.Scale(32)

            icon.Paint = function(pnl, w, h)
                draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))

                surface.SetDrawColor(mvp.colors.Text)
                surface.SetMaterial(iconMaterial)
                surface.DrawTexturedRect(spaceBetween * 2, h * .5 - iconSize * .5, iconSize, iconSize)

                draw.SimpleText(v.name, mvp.Font(24, 600), spaceBetween * 2 + iconSize + spaceBetween, h * .5, mvp.colors.Text, nil, TEXT_ALIGN_BOTTOM)
                draw.SimpleText("by " .. v.author.name, mvp.Font(20, 500), spaceBetween * 2 + iconSize + spaceBetween, h * .5, mvp.colors.Text, nil, TEXT_ALIGN_TOP)
            end

            local iconButton = vgui.Create("mvp.ImageButton", icon)
            iconButton:Dock(RIGHT)
            iconButton:DockMargin(0, spaceBetween * 1.3, spaceBetween * 1.3, spaceBetween * 1.3)
            iconButton:SetImage(linkMaterial)

            iconButton.DoClick = function()
                gui.OpenURL(v.author.url)
            end


            grid:AddCell(icon)
        end
    end)
    buttons["fonts"] = buttonGroup:AddButton("Fonts", function()
        creditsContent:Clear()
    end)
    buttons["packages"] = buttonGroup:AddButton("Packages", function()
        creditsContent:Clear()        
    end)
    
    if (not buttons[defaultActive]) then
        defaultActive = "terminal"
    end
    buttons[defaultActive]:DoClick()
end

function mvp.menus.Admin()
    if (IsValid(mvp.menu)) then
        mvp.menu:Remove()
    end

    local frame = vgui.Create("mvp.Menu")
    mvp.menu = frame

    frame:SetSize(ScrW() * 0.8, ScrH() * 0.8)
    frame:Center()
    frame:MakePopup()

    local buttons = {}

    buttons["home"] = frame:AddButton("Home", "mvp/terminal/icons/dashboard.png", true, function()
        local canvas = frame:GetCanvas()

        local content = vgui.Create("EditablePanel", canvas)
        content:Dock(FILL)
        content:InvalidateParent(true)

        local title = vgui.Create("EditablePanel", content)
        title:Dock(TOP)
        title:SetTall(mvp.ui.Scale(64))   
        
        title.Paint = function(pnl, w, h)
            draw.SimpleText("Home", homeTitleFont, 0, h * 0.5 + 5, mvp.colors.Accent, nil, TEXT_ALIGN_BOTTOM)
            draw.SimpleText("Welcome to the MVP Terminal", homeDescriptionFont, 0, h * 0.5 - 1, mvp.colors.Text, nil, TEXT_ALIGN_TOP)
        end

        local pageContent = vgui.Create("EditablePanel", content)
        pageContent:Dock(FILL)
        pageContent:DockMargin(0, spaceBetween, 0, 0)
        pageContent:InvalidateParent(true)

        local left = vgui.Create("EditablePanel", pageContent)
        left:Dock(LEFT)
        left:SetWide(pageContent:GetWide() * 0.6 - spaceBetween * 0.5)

        local indevWarning = vgui.Create("EditablePanel", left)
        indevWarning:Dock(TOP)
        indevWarning:DockMargin(0, 0, 0, spaceBetween)
        indevWarning:SetTall(mvp.ui.Scale(100))
        indevWarning:InvalidateParent(true)

        indevWarning.Paint = function(pnl, w, h)
            draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 100))

            draw.SimpleText("IN DEVELOPMENT", mvp.Font(32, 600), spaceBetween, spaceBetween, mvp.colors.Accent)
            draw.SimpleText("This is a work in progress version of the Terminal. Some features may not work as expected.", mvp.Font(20, 500), spaceBetween, spaceBetween + 24, mvp.colors.Text)
        end

        local notifications = vgui.Create("EditablePanel", left)
        notifications:Dock(TOP)
        notifications:SetTall(mvp.ui.Scale(350))

        surface.SetFont(mvp.Font(22, 600))
        local _, h = surface.GetTextSize("Notifications")

        notifications:DockPadding(0, spaceBetween + h, 0, 0)
        notifications:InvalidateParent(true)

        notifications.Paint = function(pnl, w, h)
            draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 100))

            draw.SimpleText("Notifications", mvp.Font(22, 600), spaceBetween, spaceBetween, mvp.colors.Text)
        end

        local notificationsList = vgui.Create("mvp.ScrollPanel", notifications)
        notificationsList:Dock(FILL)
        notificationsList:DockMargin(spaceBetween, spaceBetween, spaceBetween, spaceBetween)
        notificationsList:InvalidateParent(true)

        local serverName = mvp.config.GetStored("servername")

        if (serverName.value == serverName.default) then
            local header = "Server name not set"
            local text = "You haven't set a server name yet. Currently Terminal will use default value \"" .. serverName.default .. "\" as your server name. You can set a server name in the settings."

            addNotification(notificationsList:GetCanvas(), header, text, mvp.colors.Red, {
                {
                    text = "Settings",
                    callback = function()
                        frame:SelectButton("Credits", "icons")
                    end
                }
            })
        end

        local serverLogo = mvp.config.GetStored("logo")

        if (serverLogo.value == serverLogo.default) then
            local header = "Server logo not set"
            local text = "You haven't set a server logo yet. Currently Terminal will use logo of MULTIVERSE Project in places of your server logo. You can set a server logo in the settings."

            addNotification(notificationsList:GetCanvas(), header, text, mvp.colors.Red, {
                {
                    text = "Settings",
                    callback = function()
                        frame:SelectButton("Settings")
                    end
                }
            })
        end

        local selectedGamemode = mvp.config.GetStored("gamemode")
        if (selectedGamemode.value == selectedGamemode.default) then
            local header = "Gamemode not selected"
            local text = "You haven't selected a gamemode yet. Currently Terminal can't use your gamemode's features. (economy, jobs, etc.) You can select a gamemode in the settings. \n\nIf this is intended use of Terminal you can ignore this message."

            addNotification(notificationsList:GetCanvas(), header, text, mvp.colors.Yellow, {
                {
                    text = "Settings",
                    callback = function()
                        frame:SelectButton("Settings")
                    end
                },
                {
                    text = "Ignore",
                    callback = function()
                        frame:SelectButton("Home")
                    end
                }
            })
        end

        local right = vgui.Create("EditablePanel", pageContent)
        right:Dock(RIGHT)
        right:SetWide(pageContent:GetWide() * 0.4 - spaceBetween * 0.5)

        local packages = vgui.Create("EditablePanel", right)
        packages:Dock(FILL)
        -- packages:SetTall(mvp.ui.Scale(350))

        surface.SetFont(mvp.Font(22, 600))
        local _, h = surface.GetTextSize("Packages")
        
        packages:DockPadding(spaceBetween, spaceBetween + h, spaceBetween, 0)
        packages:InvalidateParent(true)

        packages.Paint = function(pnl, w, h)
            draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 100))

            draw.SimpleText("Packages", mvp.Font(22, 600), spaceBetween, spaceBetween, mvp.colors.Text)
        end

        local spacing = mvp.ui.Scale(10)

        local packagesList = vgui.Create("mvp.CategoryList", packages)
        packagesList:Dock(FILL)
        packagesList:DockMargin(0, spaceBetween - 2, 0, spaceBetween)
        packagesList:InvalidateParent(true)

        local cat = packagesList:Add("Installed packages")
        cat:SetExpanded(true)
        cat:SetHeaderHeight(mvp.ui.Scale(48))
        cat:DockMargin(0, 0, 0, spaceBetween)
        cat:InvalidateParent(true)

        cat.angle = cat:GetExpanded() and 180 or 0

        cat.Paint = function(pnl, w, h)
            local headerHeight = pnl:GetHeaderHeight()

            draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, headerHeight, mvp.colors.SecondaryBackground)

            surface.SetDrawColor(ColorAlpha(mvp.colors.Text, pnl:GetExpanded() and 255 or 150))
            surface.SetMaterial(arrowMaterial)
            surface.DrawTexturedRectRotated(w - headerHeight * .5, headerHeight * .5, headerHeight * .5, headerHeight * .5, pnl.angle)

            if (pnl:GetExpanded()) then
                pnl.angle = Lerp(FrameTime() * 10, pnl.angle, 180)
            else
                pnl.angle = Lerp(FrameTime() * 10, pnl.angle, 0)
            end
        end

        local catHeader = cat.Header
        catHeader:SetFont(mvp.Font(18, 600))
        catHeader:DockMargin(spacing - 5, 0, 0, spaceBetween * .5)

        local catContent = vgui.Create("EditablePanel")
        cat:SetContents(catContent)

        local grid = vgui.Create("ThreeGrid", catContent)
        
        grid:SetColumns(2)
        grid:SetHorizontalMargin(spaceBetween * .5)
        grid:SetVerticalMargin(spaceBetween * .5)

        catContent:Dock(FILL)
        catContent:InvalidateParent(true)
        
        grid:Dock(TOP)
        grid:InvalidateParent(true)

        for i = 1, 5 do
            local packagePanel = vgui.Create("DPanel")
            packagePanel:Dock(TOP)
            packagePanel:SetTall(mvp.ui.Scale(64))
            packagePanel:DockMargin(0, 0, 0, spaceBetween * .5)

            packagePanel.Paint = function(pnl, w, h)
                draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))

                draw.SimpleText(i, mvp.Font(22, 600), spacing, spacing, mvp.colors.Accent)
                draw.SimpleText(i, mvp.Font(20, 500), spacing, h - spacing, mvp.colors.Text, nil, TEXT_ALIGN_BOTTOM)
            end

            grid:AddCell(packagePanel)
        end
        grid:SetTall(grid:GetRowsHeight())


        timer.Simple(0, function()
            http.Fetch("https://raw.githubusercontent.com/MULTIVERSE-Project/terminal/lists/packages-list.json", function(body, _, _, code)
                if (code ~= 200) then 
                    return 
                end
    
                local packagesData = util.JSONToTable(body)
    
                local cat = packagesList:Add("Available packages")
                cat:SetExpanded(true)
                cat:SetHeaderHeight(mvp.ui.Scale(48))
                cat:DockMargin(0, 0, 0, spaceBetween)
                cat:InvalidateParent(true)
    
                cat.angle = cat:GetExpanded() and 180 or 0
    
                cat.Paint = function(pnl, w, h)
                    local headerHeight = pnl:GetHeaderHeight()
    
                    draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, headerHeight, mvp.colors.SecondaryBackground)
    
                    surface.SetDrawColor(ColorAlpha(mvp.colors.Text, pnl:GetExpanded() and 255 or 150))
                    surface.SetMaterial(arrowMaterial)
                    surface.DrawTexturedRectRotated(w - headerHeight * .5, headerHeight * .5, headerHeight * .5, headerHeight * .5, pnl.angle)
    
                    if (pnl:GetExpanded()) then
                        pnl.angle = Lerp(FrameTime() * 10, pnl.angle, 180)
                    else
                        pnl.angle = Lerp(FrameTime() * 10, pnl.angle, 0)
                    end
                end
    
                local catHeader = cat.Header
                catHeader:SetFont(mvp.Font(18, 600))
                catHeader:DockMargin(spacing - 5, 0, 0, spaceBetween * .5)
    
                local catContent = vgui.Create("EditablePanel")
                cat:SetContents(catContent)
    
                local grid = vgui.Create("ThreeGrid", catContent)
            
                grid:SetColumns(2)
                grid:SetHorizontalMargin(spaceBetween * .5)
                grid:SetVerticalMargin(spaceBetween * .5)
    
                catContent:Dock(FILL)
                catContent:InvalidateParent(true)
                
                grid:Dock(TOP)
                grid:InvalidateParent(true)
    
                for k, v in pairs(packagesData) do

                    local packagePanel = vgui.Create("DPanel")
                    packagePanel:Dock(TOP)
                    packagePanel:SetTall(mvp.ui.Scale(140))
                    packagePanel:DockMargin(0, 0, 0, spaceBetween * .5)
    
                    packagePanel.text = v.description
    
                    packagePanel.Paint = function(pnl, w, h)
                        draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))
    
                        draw.SimpleText(v.name, mvp.Font(22, 700), spacing, spacing, mvp.colors.Accent)
                        
                        if (v.isFree) then
                            draw.SimpleText("Free", mvp.Font(20, 600), w - spacing, spacing + 2, mvp.colors.Green, TEXT_ALIGN_RIGHT)
                        else
                            draw.SimpleText(v.price .. "$", mvp.Font(20, 600), w - spacing, spacing + 2, mvp.colors.Green, TEXT_ALIGN_RIGHT)
                        end

                        local wrappedText = mvp.utils.WrapText(v.description, mvp.Font(20, 500), w - spacing * 2)

                        draw.DrawText(wrappedText, mvp.Font(20, 500), spacing, spacing + mvp.ui.Scale(24), mvp.colors.Text, TEXT_ALIGN_LEFT)
                    end

                    local buttons = vgui.Create("mvp.ButtonGroup", packagePanel)
                    buttons:Dock(BOTTOM)
                    buttons:DockMargin(spaceBetween, spaceBetween * 1.3, spaceBetween, spaceBetween * 1.3)
                    buttons:InvalidateParent(true)
                    buttons:SetTall(mvp.ui.Scale(40))
                    buttons:SetRoundness(mvp.ui.ScaleWithFactor(8))

                    for k, v in pairs(v.links) do
                        if (v == "") then continue end

                        buttons:AddButton(linkTypeNames[k] or k, function()
                            gui.OpenURL(v)
                        end):SetIcon(linkTypeMaterials[k] or linkMaterial)
                    end
    
                    grid:AddCell(packagePanel)
                end
    
                grid:SetTall(grid:GetRowsHeight())
            end)
        end)
    end)

    frame:AddSeparator()

    buttons["settings"] = frame:AddButton("Settings", "mvp/terminal/icons/settings.png", false, function()
        local canvas = frame:GetCanvas()

        local content = vgui.Create("EditablePanel", canvas)
        content:Dock(FILL)
        content:InvalidateParent(true)

        local title = vgui.Create("mvp.MenuHeader", content)
        title:Dock(TOP)
        title:SetTall(mvp.ui.Scale(64))  
        
        title:SetText("Settings")
        title:SetDescription("This is your settings for the Terminal and it's packages. You can change your server name, logo, gamemode and more.")

        local restoreConfig = vgui.Create("mvp.Button", title)
        restoreConfig:Dock(RIGHT)
        restoreConfig:DockMargin(0, spaceBetween, 0, spaceBetween)
        restoreConfig:SetText("Restore")
        restoreConfig:SizeToContentsX(spaceBetween * 4)
        restoreConfig:SetStyle("danger")
        restoreConfig:SetFont(mvp.Font(20, 500))
        restoreConfig:SetEnabled(false)
        restoreConfig:SetRoundness(mvp.ui.ScaleWithFactor(8))

        local saveConfig = vgui.Create("mvp.Button", title)
        saveConfig:Dock(RIGHT)
        saveConfig:DockMargin(0, spaceBetween, spaceBetween, spaceBetween)
        saveConfig:SetText("Save")
        saveConfig:SizeToContentsX(spaceBetween * 4)
        saveConfig:SetStyle("success")
        saveConfig:SetFont(mvp.Font(20, 500))
        saveConfig:SetEnabled(false)
        saveConfig:SetRoundness(mvp.ui.ScaleWithFactor(8))

        local pageContent = vgui.Create("EditablePanel", content)
        pageContent:Dock(FILL)

        local sections = mvp.config.sections

        local topNavigation = vgui.Create("DHorizontalScroller", pageContent)
        topNavigation:Dock(TOP)
        topNavigation:SetTall(mvp.ui.Scale(38))
        topNavigation:SetOverlap( -spaceBetween * .5 )

        local buttonGroup = vgui.Create("mvp.ButtonGroup")
        topNavigation:AddPanel(buttonGroup)
        buttonGroup:SetRoundness(mvp.ui.ScaleWithFactor(8))

        local configsSpace = vgui.Create("EditablePanel", pageContent)
        configsSpace:Dock(FILL)
        configsSpace:DockMargin(0, spaceBetween * .5, 0, 0)

        for k, v in SortedPairsByMemberValue(sections, "sortIndex") do
            local but = buttonGroup:AddButton(v.name)

            but.DoClick = function()
                
                configsSpace:Clear()
                
                local configContent = vgui.Create("mvp.CategoryList", configsSpace)
                configContent:Dock(FILL)
                
                for _, category in SortedPairsByMemberValue(v.categories, "sortIndex") do
                    local spacing = mvp.ui.Scale(10)

                    local cat = configContent:Add(category.name)
                    cat:SetExpanded(true)
                    cat:SetHeaderHeight(mvp.ui.Scale(48))
                    cat:DockMargin(0, 0, 0, spaceBetween)

                    cat.angle = cat:GetExpanded() and 180 or 0

                    cat.Paint = function(pnl, w, h)
                        local headerHeight = pnl:GetHeaderHeight()

                        draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, headerHeight, mvp.colors.SecondaryBackground)

                        surface.SetDrawColor(ColorAlpha(mvp.colors.Text, pnl:GetExpanded() and 255 or 150))
                        surface.SetMaterial(arrowMaterial)
                        surface.DrawTexturedRectRotated(w - headerHeight * .5, headerHeight * .5, headerHeight * .5, headerHeight * .5, pnl.angle)

                        if (pnl:GetExpanded()) then
                            pnl.angle = Lerp(FrameTime() * 10, pnl.angle, 180)
                        else
                            pnl.angle = Lerp(FrameTime() * 10, pnl.angle, 0)
                        end
                    end

                    local catHeader = cat.Header
                    catHeader:SetFont(mvp.Font(18, 600))
                    catHeader:DockMargin(spacing - 5, 0, 0, spaceBetween * .5)

                    local catContent = vgui.Create("EditablePanel")

                    for key, config in SortedPairsByMemberValue(category.configs, "sortIndex") do
                        if (config.ui.hide) then continue end

                        local configPanel = vgui.Create("DPanel", catContent)
                        configPanel:Dock(TOP)
                        configPanel:SetTall(mvp.ui.Scale(64))
                        configPanel:DockMargin(0, 0, 0, spaceBetween * .5)

                        configPanel.Paint = function(pnl, w, h)
                            draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))

                            draw.SimpleText(key, mvp.Font(22, 600), spacing, spacing, mvp.colors.Accent)
                            draw.SimpleText(config.description, mvp.Font(20, 500), spacing, h - spacing, mvp.colors.Text, nil, TEXT_ALIGN_BOTTOM)
                        end

                        local restoreToDefault = vgui.Create("mvp.ImageButton", configPanel)
                        restoreToDefault:Dock(RIGHT)
                        restoreToDefault:DockMargin(0, spaceBetween * 1.3, spacing, spaceBetween * 1.3)
                        restoreToDefault:InvalidateParent(true)

                        restoreToDefault:SetWide(restoreToDefault:GetTall())

                        restoreToDefault:SetFont(mvp.Font(20, 500))
                        restoreToDefault:SetRoundness(mvp.ui.ScaleWithFactor(8))
                        restoreToDefault:SetImage(restoreToDefaultMaterial)

                        if (config.typeOf == mvp.type.string) then
                            local valueInput = vgui.Create("mvp.TextEntry", configPanel)
                            valueInput:Dock(RIGHT)
                            valueInput:DockMargin(0, spaceBetween * 1.3, spacing, spaceBetween * 1.3)
                            valueInput:SetWide(mvp.ui.Scale(180))
                            valueInput:SetRoundness(mvp.ui.ScaleWithFactor(8))

                            valueInput:SetText(tostring(config.value))
                        elseif (config.typeOf == mvp.type.number) then
                            local valueInput = vgui.Create("mvp.TextEntry", configPanel)
                            valueInput:Dock(RIGHT)
                            valueInput:DockMargin(0, spaceBetween * 1.3, spacing, spaceBetween * 1.3)
                            valueInput:SetWide(mvp.ui.Scale(180))

                            valueInput:SetNumeric(true)
                            valueInput:SetText(tostring(config.value))
                            valueInput:SetRoundness(mvp.ui.ScaleWithFactor(8))
                        elseif (config.typeOf == mvp.type.bool) then
                            local valueInput = vgui.Create("mvp.CheckBox", configPanel)
                            valueInput:Dock(RIGHT)
                            valueInput:DockMargin(0, spaceBetween * 1.3,spacing, spaceBetween * 1.3)
                            valueInput:InvalidateParent(true)
                            valueInput:SetWide(valueInput:GetTall())
                            valueInput:SetRoundness(mvp.ui.ScaleWithFactor(8))

                            valueInput:SetChecked(config.value)
                        end
                    end
                    
                    cat:SetContents(catContent)
                end
                
            end

            if not configsSpace.fk then
                configsSpace.fk = but
            end
        end

        configsSpace.fk:DoClick()
    end)
    -- buttons["language_editor"] = frame:AddButton("Language Editor", "mvp/terminal/icons/language.png", false, function()
    --     local canvas = frame:GetCanvas()

    --     local content = vgui.Create("EditablePanel", canvas)
    --     content:Dock(FILL)
    --     content:InvalidateParent(true)

    --     local title = vgui.Create("mvp.MenuHeader", content)
    --     title:Dock(TOP)
    --     title:SetTall(mvp.ui.Scale(64))  
        
    --     title:SetText("Language Editor (WIP)")
    --     title:SetDescription("Here you can edit your language file")
    -- end)

    buttons["permissions"] = frame:AddButton("Permissions", "mvp/terminal/icons/permissions.png", false, function()
        local canvas = frame:GetCanvas()

        local content = vgui.Create("EditablePanel", canvas)
        content:Dock(FILL)
        content:InvalidateParent(true)

        local title = vgui.Create("mvp.MenuHeader", content)
        title:Dock(TOP)
        title:SetTall(mvp.ui.Scale(64))  
        
        title:SetText("Permissions")
        title:SetDescription("All the permissions that Terminal or it's packages registered are listed here.")
    end)

    frame:AddSeparator()

    buttons["feedback"] = frame:AddButton("Feedback", "mvp/terminal/icons/feedback.png", false, function()
        local canvas = frame:GetCanvas()

        local content = vgui.Create("EditablePanel", canvas)
        content:Dock(FILL)
        content:InvalidateParent(true)

        local title = vgui.Create("mvp.MenuHeader", content)
        title:Dock(TOP)
        title:SetTall(mvp.ui.Scale(64))  
        
        title:SetText("Feedback")
        title:SetDescription("You can leave feedback for the Terminal here")
    end)

    buttons["credits"] = frame:AddButton("Credits", "mvp/terminal/icons/credits.png", false, function(_, defultActiveTab)
        local canvas = frame:GetCanvas()
        mvp.menus.AdminCredits(canvas, defultActiveTab)
    end)
end

hook.Add("mvp.config.Synchronized", "mvp.menus.Admin", function()
    mvp.menus.Admin()
end)

concommand.Add("mvp_terminal", function()
    mvp.menus.Admin()
end)

RunConsoleCommand("mvp_terminal")