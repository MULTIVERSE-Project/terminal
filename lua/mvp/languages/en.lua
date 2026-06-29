local l = {}

l["general.terminal"] = "Terminal"
l["general.disabled"] = "This feature is disabled."

l["general.by_x"] = "by %s"
l["general.no_permission"] = "You don't have permission to do that."
l["general.use"] = "Press {{btn:%s}} to interact"
l["general.command_x"] = "Command: %s"

l["general.unsaved_changes_prompt"] = "%d unsaved"

l["general.screen_position.tl"] = "Top Left"
l["general.screen_position.tc"] = "Top Center"
l["general.screen_position.tr"] = "Top Right"
l["general.screen_position.cl"] = "Center Left"
l["general.screen_position.cc"] = "Center Center"
l["general.screen_position.cr"] = "Center Right"
l["general.screen_position.bl"] = "Bottom Left"
l["general.screen_position.bc"] = "Bottom Center"
l["general.screen_position.br"] = "Bottom Right"

--[[
    UI
]]--

l["ui.general.save"] = "Save"
l["ui.general.save.thing"] = "Save %s"
l["ui.general.close"] = "Close"
l["ui.general.none"] = "None"
l["ui.general.edit"] = "Edit"
l["ui.general.discard_changes"] = "Discard"
l["ui.general.open_editor"] = "Open Editor"

l["ui.home"] = "Home"
l["ui.home.description"] = "This is the home page for the Terminal admin menu."

l["ui.config"] = "Settings"
l["ui.config.save"] = "Save settings"
l["ui.config.description"] = "This is your settings for the Terminal and it's packages. You can change your server name, logo, gamemode and more."

l["ui.config.saved"] = "Settings saved successfully."
l["ui.config.saved.description"] = "Your settings have been saved successfully."

l["ui.permissions"] = "Permissions"
l["ui.permissions.description"] = "All the permissions that Terminal or it's packages registered are listed here."

l["ui.packages"] = "Packages"
l["ui.packages.description"] = "This is the packages that are currently loaded into Terminal."
l["ui.packages.installed"] = "Installed packages"
l["ui.packages.available"] = "Available packages"

l["ui.credits"] = "Credits"
l["ui.credits.description"] = "This is the credits for the Terminal and materials used in the Terminal"
l["ui.credits.steam_profile"] = "Steam Profile"

l["ui.credits.terminal"] = l["general.terminal"]
l["ui.credits.icons"] = "Icons"
l["ui.credits.packages"] = "Packages"

--[[
    Menus
]]--

l["menu.terminal.title"] = l["general.terminal"]
l["menu.terminal.subTitle"] = "Administrative Interface"

l["menu.terminal.dashboard"] = "Dashboard"
l["menu.terminal.dashboard.tag_line"] = "make Terminal yours"
l["menu.terminal.settings"] = "Settings"
l["menu.terminal.settings.tag_line"] = "make Terminal yours"
l["menu.terminal.packages"] = "Packages"
l["menu.terminal.settings.tag_line"] = "build your own Terminal"

--[[
    Config Section
]]--

l["section.terminal"] = l["general.terminal"]
l["section.terminal.general"] = "General"
l["section.terminal.appearance"] = "Appearance"
l["section.terminal.webImages"] = "Web Images"
l["section.terminal.developer"] = "Developer"

l["value.prefix"] = "Command prefix"
l["value.prefix.description"] = "Prefix for the all commands."

l["value.command.description"] = "Command for opening Terminal menu."

l["value.allowConsoleCommand"] = "Enable console command"
l["value.allowConsoleCommand.description"] = "Allow console command for opening Terminal menu."

l["value.tag"] = "Chat tag"
l["value.tag.description"] = "Tag for all chat messages."

l["value.language"] = "Language"
l["value.language.description"] = "Language for Terminal to use."

l["value.theme"] = "Theme"
l["value.theme.description"] = "Theme for Terminal to use."

l["value.useNotifications"] = "Enable notifications"
l["value.useNotifications.description"] = "Use notifications system. If set to false, Terminal will use chat for notifications."

l["value.notificationsPosition"] = "Notifications position"
l["value.notificationsPosition.description"] = "Position for notifications on screen."
l["value.notificationsPosition.ps.title"] = "Terminal notifications position"
l["value.notificationsPosition.ps.description"] = "This is where the notifications will appear on the screen."

l["value.imagesProxy"] = "Images proxy"
l["value.imagesProxy.description"] = "Use proxy for downloading images. Useful if you have issues with downloading images from the web."

l["value.debug"] = "Debug mode"
l["value.debug.description"] = "Enable debug mode."

l["section.server"] = "Server"
l["section.server.gamemode"] = "Gamemode"
l["section.server.branding"] = "Branding"

l["value.gamemode"] = "Gamemode"
l["value.gamemode.description"] = "Gamemode for the server."
l["value.logo"] = "Server logo"
l["value.logo.description"] = "Branding for the server."
l["value.servername"] = "Server name"
l["value.servername.description"] = "Branding for the server."

--[[
    Permissions Section
]]--

l["permission.mvp.terminal.description"] = "Allows access to the Terminal menu."
l["permission.mvp.terminal.configs.description"] = "Allows access to the Terminal configuration menu."
l["permission.mvp.terminal.packages.description"] = "Allows to control what packages are being loaded."


mvp.language.Register("en", l)