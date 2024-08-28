mvp = mvp or {}
mvp.menus = mvp.menus or {}

mvp.menus.admin = mvp.menus.admin or {}
mvp.menus.admin.frame = nil

function mvp.menus.admin.Open(defaultTab, ...)
    if (IsValid(mvp.menu)) then
        mvp.menu:Remove()
    end

    local extra = {...}
    local frame = vgui.Create("mvp.Menu")
    mvp.menu = frame
    mvp.menus.admin.frame = frame

    frame:SetSize(ScrW() * 0.8, ScrH() * 0.8)
    frame:Center()
    frame:MakePopup()

    local buttons = {}
    buttons["home"] = frame:AddButton(mvp.q.Lang("ui.home"), "mvp/terminal/icons/dashboard.png", function()
        local canvas = frame:GetCanvas()

        mvp.menus.admin.Home(canvas)
    end)

    if (mvp.permissions.CheckSome(LocalPlayer(), {"mvp.terminal.configs", "mvp.terminal.packages"})) then
        frame:AddSeparator()
    end

    if (mvp.permissions.Check(LocalPlayer(), "mvp.terminal.configs")) then
        buttons["settings"] = frame:AddButton(mvp.q.Lang("ui.config"), "mvp/terminal/icons/settings.png", function(_, section)
            local canvas = frame:GetCanvas()

            if (not section) then
                section = extra[1] or nil
                extra = {}
            end

            
            mvp.menus.admin.Settings(canvas, section)
        end)

        buttons["permissions"] = frame:AddButton(mvp.q.Lang("ui.permissions"), "mvp/terminal/icons/permissions.png", function()
            local canvas = frame:GetCanvas()

            mvp.menus.admin.Permissions(canvas)
        end)
    end

    if (mvp.permissions.Check(LocalPlayer(), "mvp.terminal.packages")) then
        buttons["packages"] = frame:AddButton(mvp.q.Lang("ui.packages"), "mvp/terminal/icons/package.png", function()
            local canvas = frame:GetCanvas()

            mvp.menus.admin.Packages(canvas)
        end)
    end

    frame:AddSeparator()

    buttons["credits"] = frame:AddButton(mvp.q.Lang("ui.credits"), "mvp/terminal/icons/credits.png", function(_, section)
        local canvas = frame:GetCanvas()

        if (not section) then
            section = extra[1] or nil
            extra = {}
        end

        mvp.menus.admin.Credits(canvas)
    end)

    if (not buttons[defaultTab]) then
        defaultTab = "home"
    end
    buttons[defaultTab]:DoClick()
end

hook.Add("mvp.config.Synchronized", "CreateDefaultWarnings", function()
    local nameValue = mvp.config.GetStored("servername")
    local logoValue = mvp.config.GetStored("logo")
    local gamemodeValue = mvp.config.GetStored("gamemode")

    if (nameValue.value == nameValue.default and not mvp.menus.admin.HasNotification("servername")) then
        mvp.menus.admin.AddNotification(
            "servername",
            mvp.q.Lang("ui.notifications.servername.title"), 
            mvp.q.Lang("ui.notifications.servername.description", nameValue.default), 
            mvp.colors.Red,
            {
                {
                    text = mvp.q.Lang("ui.notifications.servername.action.1"),
                    callback = function()
                        mvp.menus.admin.Open("settings", "server")
                    end
                }
            })

        mvp.logger.Log(mvp.LOG.DEBUG, nil, "Adding notification for server name not set")
    end

    if (logoValue.value == logoValue.default and not mvp.menus.admin.HasNotification("logo")) then
        mvp.menus.admin.AddNotification(
            "logo",
            mvp.q.Lang("ui.notifications.logo.title"), 
            mvp.q.Lang("ui.notifications.logo.description", logoValue.default),
            mvp.colors.Red,
            {
                {
                    text = mvp.q.Lang("ui.notifications.logo.action.1"),
                    callback = function()
                        mvp.menus.admin.Open("settings", "server")
                    end
                }
            })
        
        mvp.logger.Log(mvp.LOG.DEBUG, nil, "Adding notification for server logo not set")
    end

    if (gamemodeValue.value == gamemodeValue.default and not mvp.menus.admin.HasNotification("gamemode")) then
        mvp.menus.admin.AddNotification(
            "gamemode",
            mvp.q.Lang("ui.notifications.gamemode.title"), 
            mvp.q.Lang("ui.notifications.gamemode.description", gamemodeValue.default),
            mvp.colors.Yellow,
            {
                {
                    text = mvp.q.Lang("ui.notifications.gamemode.action.1"),
                    callback = function()
                        mvp.menus.admin.Open("settings", "server")
                    end
                }
            })

        mvp.logger.Log(mvp.LOG.DEBUG, nil, "Adding notification for gamemode not set")
    end
end)

local checkKeys = {
    ["servername"] = true,
    ["logo"] = true,
    ["gamemode"] = true
}
hook.Add("mvp.config.Updated", "ManageDefaultWarnings", function(key, value)
    if (not checkKeys[key]) then return end

    local storedValue = mvp.config.GetStored(key)

    if (value ~= storedValue.default) then
        mvp.menus.admin.RemoveNotification(key)
    end
end)

concommand.Add("mvp_terminal", function()
    if (mvp.permissions.Check(LocalPlayer(), "mvp.terminal")) then
        mvp.menus.admin.Open()
    else
        chat.AddText(mvp.colors.Red, mvp.q.Lang("general.no_permission"))
    end
end)