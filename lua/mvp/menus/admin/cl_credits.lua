mvp = mvp or {}
mvp.menus = mvp.menus or {}

mvp.menus.admin = mvp.menus.admin or {}

local spaceBetween = mvp.ui.Scale(10)
local spacing = mvp.ui.Scale(10)

local linkMaterial = Material("mvp/terminal/vgui/link.png", "smooth mips")
local linkTypeMaterials = {
    ["workshop"] = Material("mvp/terminal/icons/steam.png", "smooth mips"),
    ["github"] = Material("mvp/terminal/icons/github.png", "smooth mips"),
    ["store"] = Material("mvp/terminal/icons/store.png", "smooth mips")
}

function mvp.menus.admin.Credits(container, defaultActive)
    defaultActive = defaultActive or "terminal"

    local content = vgui.Create("EditablePanel", container)
    content:Dock(FILL)
    content:InvalidateParent(true)

    local title = vgui.Create("mvp.MenuHeader", content)
    title:Dock(TOP)
    title:SetTall(mvp.ui.Scale(64))  
    
    title:SetText(mvp.q.Lang("ui.credits"))
    title:SetDescription(mvp.q.Lang("ui.credits.description"))

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

    buttons["terminal"] = buttonGroup:AddButton(mvp.q.Lang("ui.credits.terminal"), function()
        creditsContent:Clear()

        local contributors = mvp.credits.GetContributors()

        local grid = vgui.Create("mvp.ThreeGrid", creditsContent)
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
            button:SetText(mvp.q.Lang("ui.credits.steam_profile"))
            button:SetIcon(linkTypeMaterials["workshop"])
            
            button.DoClick = function()
                gui.OpenURL("https://steamcommunity.com/profiles/" .. v.steamId)
            end

            grid:AddCell(pnl)
        end
    end)
    buttons["icons"] = buttonGroup:AddButton(mvp.q.Lang("ui.credits.icons"), function()
        creditsContent:Clear()
        
        local icons = mvp.credits.GetIcons()

        local grid = vgui.Create("mvp.ThreeGrid", creditsContent)
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

            local text = mvp.q.Lang("general.by_x", v.author.name)

            icon.Paint = function(pnl, w, h)
                draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))

                surface.SetDrawColor(mvp.colors.Text)
                surface.SetMaterial(iconMaterial)
                surface.DrawTexturedRect(spaceBetween * 2, h * .5 - iconSize * .5, iconSize, iconSize)

                draw.SimpleText(v.name, mvp.Font(24, 600), spaceBetween * 2 + iconSize + spaceBetween, h * .5, mvp.colors.Accent, nil, TEXT_ALIGN_BOTTOM)
                draw.SimpleText(text, mvp.Font(20, 500), spaceBetween * 2 + iconSize + spaceBetween, h * .5, mvp.colors.Text, nil, TEXT_ALIGN_TOP)
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
    buttons["packages"] = buttonGroup:AddButton(mvp.q.Lang("ui.credits.packages"), function()
        creditsContent:Clear() 
        
        local grid = vgui.Create("mvp.ThreeGrid", creditsContent)
        grid:Dock(FILL)
        grid:InvalidateParent(true)

        grid:SetColumns(3)
        grid:SetHorizontalMargin(spaceBetween * .5)
        grid:SetVerticalMargin(spaceBetween * .5)

        local packages = mvp.package.GetAll()

        for k, v in pairs(packages) do
            local package = vgui.Create("DPanel")
            package:SetTall(mvp.ui.Scale(80))

            local iconMaterial = v:GetIcon()
            local iconSize = mvp.ui.Scale(64)

            local packageName = v:GetName()
            local authorText = mvp.q.Lang("general.by_x", v:GetAuthor())

            package.Paint = function(pnl, w, h)
                draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))

                if (iconMaterial and not iconMaterial:IsError()) then
                    surface.SetDrawColor(mvp.colors.Text)
                    surface.SetMaterial(iconMaterial)
                    surface.DrawTexturedRect(spaceBetween, h * .5 - iconSize * .5, iconSize, iconSize)
                else
                    draw.RoundedBox(mvp.ui.ScaleWithFactor(8), spaceBetween, h * .5 - iconSize * .5, iconSize, iconSize, mvp.colors.SecondaryBackground)
                    draw.SimpleText("?", mvp.Font(32, 600), spaceBetween + iconSize * .5, h * .5, mvp.colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                draw.SimpleText(packageName, mvp.Font(24, 600), spaceBetween + iconSize + spaceBetween, h * .5, mvp.colors.Accent, nil, TEXT_ALIGN_BOTTOM)
                draw.SimpleText(authorText, mvp.Font(20, 500), spaceBetween + iconSize + spaceBetween, h * .5, mvp.colors.Text, nil, TEXT_ALIGN_TOP)
            end

            grid:AddCell(package)
        
        end
    end)
    
    if (not buttons[defaultActive]) then
        defaultActive = "terminal"
    end
    buttons[defaultActive]:DoClick()
end