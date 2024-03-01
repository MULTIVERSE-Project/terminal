mvp = mvp or {}
mvp.menus = mvp.menus or {}

mvp.menus.admin = mvp.menus.admin or {}

local spaceBetween = mvp.ui.Scale(10)
local spacing = mvp.ui.Scale(10)

function mvp.menus.admin.Packages(container)
    local content = vgui.Create("EditablePanel", container)
    content:Dock(FILL)
    content:InvalidateParent(true)

    local title = vgui.Create("mvp.MenuHeader", content)
    title:Dock(TOP)
    title:SetTall(mvp.ui.Scale(64))  
    
    title:SetText(mvp.q.Lang("ui.packages"))
    title:SetDescription(mvp.q.Lang("ui.packages.description"))

    local pageContent = vgui.Create("EditablePanel", content)
    pageContent:Dock(FILL)
    pageContent:InvalidateParent(true)
    
    local grid = vgui.Create("ThreeGrid", pageContent)
    grid:Dock(FILL)
    grid:InvalidateParent(true)

    grid:SetColumns(2)
    grid:SetHorizontalMargin(spaceBetween * .5)
    grid:SetVerticalMargin(spaceBetween * .5)

    local packages = mvp.package.GetAll()

    for k, v in pairs(packages) do
        local package = vgui.Create("DPanel")
        package:SetTall(mvp.ui.Scale(128))

        local iconMaterial = v:GetIcon()
        local iconSize = mvp.ui.Scale(100)

        local packageName = v:GetName()
        local authorText = mvp.q.Lang("general.by_x", v:GetAuthor())
        local packageId = string.format("%s@%s", v:GetID(), v:GetVersion())
        local desription = v:GetDescription()

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

            local tw, th = draw.SimpleText(packageName, mvp.Font(28, 600), iconSize + spaceBetween * 2, h * .5 - spacing, mvp.colors.Accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(authorText, mvp.Font(20, 400), iconSize + spaceBetween * 2 + tw + spacing * .5, h * .5  - spacing - th * .5, ColorAlpha(mvp.colors.Text, 110), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(desription, mvp.Font(20, 400), iconSize + spaceBetween * 2, h * .5, mvp.colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(packageId, mvp.Font(20, 400), iconSize + spaceBetween * 2, h * .5 + spacing, ColorAlpha(mvp.colors.Text, 110), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end

        grid:AddCell(package)
    
    end
end