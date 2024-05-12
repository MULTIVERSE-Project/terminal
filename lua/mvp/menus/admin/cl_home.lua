mvp = mvp or {}
mvp.menus = mvp.menus or {}

mvp.menus.admin = mvp.menus.admin or {}
mvp.menus.admin.notifications = mvp.menus.admin.notifications or {}

local spaceBetween = mvp.ui.Scale(10)
local spacing = mvp.ui.Scale(10)

local linkTypeMaterials
local linkTypeNames = {
    ["workshop"] = "Steam Workshop",
    ["github"] = "GitHub",
    ["store"] = "Store"
}

function mvp.menus.admin.AddNotification(id, title, text, color, actions)
    mvp.menus.admin.notifications[#mvp.menus.admin.notifications + 1] = {
        id = id,
        title = title,
        text = text,
        color = color,
        actions = actions
    }
end
function mvp.menus.admin.ClearNotifications()
    mvp.menus.admin.notifications = {}
end
function mvp.menus.admin.GetNotifications()
    return mvp.menus.admin.notifications
end
function mvp.menus.admin.GetNotificationsCount()
    return #mvp.menus.admin.notifications
end
function mvp.menus.admin.RemoveNotification(id)
    for k, v in ipairs(mvp.menus.admin.notifications) do
        if (v.id == id) then
            table.remove(mvp.menus.admin.notifications, k)
            return
        end
    end
end
function mvp.menus.admin.HasNotification(id)
    for k, v in ipairs(mvp.menus.admin.notifications) do
        if (v.id == id) then
            return true
        end
    end

    return false
end

function mvp.menus.admin.AddNotificationPanel(pnl, title, text, color, actions)
    local scale = mvp.ui.ScaleWithFactor(8)
    
    local card = vgui.Create("EditablePanel", pnl)
    card:Dock(TOP)
    card:DockMargin(0, 0, 0, spaceBetween * .5)
    
    pnl:InvalidateLayout(true)
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
    local _, headerHeight = surface.GetTextSize(title)
    surface.SetFont(mvp.Font(20, 500))
    local _, wrappedTextHeight = surface.GetTextSize(wrappedText)

    card:SetTall(wrappedTextHeight + headerHeight + spaceBetween * 2)

    cardTexts.Paint = function(pnl, w, h)
        draw.SimpleText(title, mvp.Font(22, 600), 0, 5, color)
        draw.DrawText(wrappedText, mvp.Font(20, 500), 0, headerHeight + spaceBetween, mvp.colors.Text, TEXT_ALIGN_LEFT)
    end

    return card
end

function mvp.menus.admin.Home(container)
    if (not linkTypeMaterials) then
        linkTypeMaterials = {
            ["workshop"] = mvp.ui.images.Create("i_workshop", "smooth mips"),
            ["github"] = mvp.ui.images.Create("i_github", "smooth mips"),
            ["store"] = mvp.ui.images.Create("i_store", "smooth mips")
        }
    end

    local content = vgui.Create("EditablePanel", container)
    content:Dock(FILL)
    content:InvalidateParent(true)

    local title = vgui.Create("mvp.MenuHeader", content)
    title:Dock(TOP)
    title:SetTall(mvp.ui.Scale(64))
    title:SetText(mvp.q.Lang("ui.home"))
    title:SetDescription(mvp.q.Lang("ui.home.description"))

    local pageContent = vgui.Create("EditablePanel", content)
    pageContent:Dock(FILL)
    pageContent:DockMargin(0, spaceBetween, 0, 0)
    pageContent:InvalidateParent(true)

    local left = vgui.Create("EditablePanel", pageContent)
    left:Dock(LEFT)
    left:SetWide(pageContent:GetWide() * 0.6 - spaceBetween * 0.5)

    local serverHeader = vgui.Create("EditablePanel", left)
    serverHeader:Dock(TOP)
    serverHeader:SetTall(mvp.ui.Scale(80))

    local serverLogo

    if (mvp.config.Get("logo") ~= "blank") then -- backwards compatibility
        serverLogo = mvp.ui.images.Quick(mvp.config.Get("logo"), "smooth mips")
    end

    serverHeader.Paint = function(pnl, w, h)
        draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 100))

        draw.RoundedBox(mvp.ui.ScaleWithFactor(8), spaceBetween, h * .5 - mvp.ui.Scale(32), mvp.ui.Scale(64), mvp.ui.Scale(64), ColorAlpha(mvp.colors.SecondaryBackground, 150))
        if (not serverLogo) then
            draw.SimpleText("?", mvp.Font(32, 600), spaceBetween + mvp.ui.Scale(32), h * .5, mvp.colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            serverLogo:Draw(spaceBetween + 3, h * .5 - mvp.ui.Scale(32) + 3, mvp.ui.Scale(64) - 6, mvp.ui.Scale(64) - 6, mvp.colors.Text)
        end

        draw.SimpleText(mvp.config.Get("servername"), mvp.Font(32, 600), spaceBetween + mvp.ui.Scale(64) + spaceBetween, h * .5 - 5, mvp.colors.Accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Terminal Admin for", mvp.Font(22, 400), spaceBetween + mvp.ui.Scale(64) + spaceBetween, h * .5, ColorAlpha(mvp.colors.Text, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

        if (mvp.config.Get("logo") == "blank") then
            draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))
            draw.SimpleText("Change logo in the config!", mvp.Font(32, 800), w * .5, h * .5, mvp.colors.Red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local notifications = vgui.Create("EditablePanel", left)
    notifications:Dock(TOP)
    notifications:DockMargin(0, spaceBetween, 0, 0)
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

    for k, v in ipairs(mvp.menus.admin.GetNotifications()) do
        mvp.menus.admin.AddNotificationPanel(notificationsList, v.title, v.text, v.color, v.actions)
    end

    local right = vgui.Create("EditablePanel", pageContent)
    right:Dock(RIGHT)
    right:SetWide(pageContent:GetWide() * 0.4 - spaceBetween * 0.5)

    local packages = vgui.Create("EditablePanel", right)
    packages:Dock(FILL)
    -- packages:SetTall(mvp.ui.Scale(350))

    local packagesText = mvp.q.Lang("ui.packages")
    surface.SetFont(mvp.Font(22, 600))
    local _, h = surface.GetTextSize(packagesText)
    
    packages:DockPadding(spaceBetween, spaceBetween + h, spaceBetween, 0)
    packages:InvalidateParent(true)

    packages.Paint = function(pnl, w, h)
        draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 100))
        draw.SimpleText(packagesText, mvp.Font(22, 600), spaceBetween, spaceBetween, mvp.colors.Text)
    end

    local packagesList = vgui.Create("mvp.CategoryList", packages)
    packagesList:Dock(FILL)
    packagesList:DockMargin(0, spaceBetween - 2, 0, spaceBetween)
    packagesList:InvalidateParent(true)

    local installedPackagesCategory = packagesList:Add(mvp.q.Lang("ui.packages.installed"))
    local installedPackages = mvp.package.GetAll()

    local installedPackagesContent = vgui.Create("EditablePanel")
    installedPackagesCategory:SetContents(installedPackagesContent)

    local installedPackagesGrid = vgui.Create("mvp.ThreeGrid", installedPackagesContent)
    installedPackagesGrid:SetColumns(2)
    installedPackagesGrid:SetHorizontalMargin(spaceBetween * .5)
    installedPackagesGrid:SetVerticalMargin(spaceBetween * .5)

    installedPackagesContent:Dock(FILL)
    installedPackagesContent:InvalidateParent(true)
    installedPackagesGrid:Dock(TOP)
    installedPackagesGrid:InvalidateParent(true)
    
    for k, v in pairs(installedPackages) do
        local packagePanel = vgui.Create("DPanel")
        packagePanel:Dock(TOP)
        packagePanel:SetTall(mvp.ui.Scale(105))
        packagePanel:DockMargin(0, 0, 0, spaceBetween * .5)

        installedPackagesGrid:AddCell(packagePanel)

        local packageName = v:GetName()
        local packageDescription = v:GetDescription()

        function packagePanel:Paint(w, h)
            draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))
            
            local packageLoaded = v.isLoaded
            draw.SimpleText(packageLoaded and "Loaded" or "Not loaded", mvp.Font(20, 600), w - spacing, spacing + 2, packageLoaded and mvp.colors.Green or mvp.colors.Red, TEXT_ALIGN_RIGHT)

            draw.SimpleText(packageName, mvp.Font(22, 600), spacing, spacing, mvp.colors.Accent)

            local wrappedText = mvp.utils.WrapText(packageDescription, mvp.Font(20, 500), w - spacing * 2)
            draw.DrawText(wrappedText, mvp.Font(20, 500), spacing, spacing + 20, mvp.colors.Text, TEXT_ALIGN_LEFT)
        end
    end
    installedPackagesGrid:SetTall(installedPackagesGrid:GetRowsHeight())

    http.Fetch("https://raw.githubusercontent.com/MULTIVERSE-Project/terminal/lists/packages-list.json", function(data, _, _, code)
        if (code ~= 200) then
            return
        end

        local packages = util.JSONToTable(data)

        local avaliblePackagesCategory = packagesList:Add(mvp.q.Lang("ui.packages.available"))
        avaliblePackagesCategory:DockMargin(0, spaceBetween * .5, 0, 0)
        local avaliblePackagesContent = vgui.Create("EditablePanel")
        avaliblePackagesCategory:SetContents(avaliblePackagesContent)

        local avaliblePackagesGrid = vgui.Create("mvp.ThreeGrid", avaliblePackagesContent)
        avaliblePackagesGrid:SetColumns(2)
        avaliblePackagesGrid:SetHorizontalMargin(spaceBetween * .5)
        avaliblePackagesGrid:SetVerticalMargin(spaceBetween * .5)

        avaliblePackagesContent:Dock(FILL)
        avaliblePackagesContent:InvalidateParent(true)
        avaliblePackagesGrid:Dock(TOP)
        avaliblePackagesGrid:InvalidateParent(true)

        for k, v in pairs(packages) do
            if (installedPackages[v.id]) then
                continue
            end

            local packagePanel = vgui.Create("DPanel")
            packagePanel:Dock(TOP)
            packagePanel:SetTall(mvp.ui.Scale(140))
            packagePanel:DockMargin(0, 0, 0, spaceBetween * .5)

            avaliblePackagesGrid:AddCell(packagePanel)

            local packageName = v.name
            local packageDescription = v.description

            local price = v.isFree and "Free" or v.price .. "$"

            function packagePanel:Paint(w, h)
                draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))
                
                draw.SimpleText(price, mvp.Font(20, 600), w - spacing, spacing + 2, mvp.colors.Green, TEXT_ALIGN_RIGHT)

                draw.SimpleText(packageName, mvp.Font(22, 600), spacing, spacing, mvp.colors.Accent)

                local wrappedText = mvp.utils.WrapText(packageDescription, mvp.Font(20, 500), w - spacing * 2)
                draw.DrawText(wrappedText, mvp.Font(20, 500), spacing, spacing + 20, mvp.colors.Text, TEXT_ALIGN_LEFT)
            end

            local buttons = vgui.Create("mvp.ButtonGroup", packagePanel)
            buttons:Dock(BOTTOM)
            buttons:DockMargin(spaceBetween, spaceBetween * 1.3, spaceBetween, spaceBetween * 1.3)
            buttons:InvalidateParent(true)
            buttons:SetTall(mvp.ui.Scale(40))
            buttons:SetRoundness(mvp.ui.ScaleWithFactor(8))

            for k, v in pairs(v.links or {}) do
                if (v == "") then continue end

                buttons:AddButton(linkTypeNames[k] or k, function()
                    gui.OpenURL(v)
                end):SetIcon(linkTypeMaterials[k] or linkMaterial)
            end
        end
        avaliblePackagesGrid:SetTall(avaliblePackagesGrid:GetRowsHeight())
    end)
end