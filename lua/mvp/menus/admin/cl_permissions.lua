mvp = mvp or {}
mvp.menus = mvp.menus or {}

mvp.menus.admin = mvp.menus.admin or {}

local spaceBetween = mvp.ui.Scale(10)
local spacing = mvp.ui.Scale(10)

function mvp.menus.admin.Permissions(container)
    local content = vgui.Create("EditablePanel", container)
    content:Dock(FILL)
    content:InvalidateParent(true)

    local title = vgui.Create("mvp.MenuHeader", content)
    title:Dock(TOP)
    title:SetTall(mvp.ui.Scale(64))  
    
    title:SetText("Permissions")
    title:SetDescription("All the permissions that Terminal or it's packages registered are listed here.")

    local pageContent = vgui.Create("EditablePanel", content)
    pageContent:Dock(FILL)
    pageContent:InvalidateParent(true)

    local permissions = mvp.permissions.GetPermissionList()

    local permissionsList = vgui.Create("mvp.ScrollPanel", pageContent)
    permissionsList:Dock(FILL)
    permissionsList:DockMargin(0, spaceBetween, spaceBetween, spaceBetween)
    permissionsList:InvalidateParent(true)

    for k, v in SortedPairsByMemberValue(permissions, "sortOrder") do
        local permissionPanel = vgui.Create("DPanel", permissionsList:GetCanvas())
        permissionPanel:Dock(TOP)
        permissionPanel:SetTall(mvp.ui.Scale(64))
        permissionPanel:DockMargin(0, 0, 0, spaceBetween * .5)

        local name = v.name
        local description = mvp.q.LangFallback("permission." .. v.name .. ".description", v.description)

        permissionPanel.Paint = function(pnl, w, h)
            draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))

            draw.SimpleText(name, mvp.Font(22, 600), spaceBetween, spaceBetween, mvp.colors.Accent)
            draw.SimpleText(description, mvp.Font(20, 500), spaceBetween, h - spaceBetween, mvp.colors.Text, nil, TEXT_ALIGN_BOTTOM)
        end
    end
end