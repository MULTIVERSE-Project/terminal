local TERMINAL_SECTION = mvp.config.RegisterSection("Terminal", -1)

local GENERAL_GROUP = mvp.config.RegisterCategory("General", TERMINAL_SECTION, 1)

mvp.config.Add("prefix", "!", {
    description = "Prefix for all commands.",
    category = GENERAL_GROUP,

    ui = {} 
}, 1)

mvp.config.Add("command", "mvp", {
    description = "Command for opening the terminal.",
    category = GENERAL_GROUP,

    ui = {}
}, 2)

mvp.config.Add("allowConsoleCommand", true, {
    description = "Controls whether or not the console command for opening menu is allowed.",
    category = GENERAL_GROUP,

    ui = {}
}, 3)

mvp.config.Add("showConfigPopups", true, {
    description = "Controls whether or not the config popups when config edited are shown.",
    category = GENERAL_GROUP,
 
    ui = {}
}, 4) 

local APPEARANCE_GROUP = mvp.config.RegisterCategory("Appearance", TERMINAL_SECTION, 2)

mvp.config.Add("tag", "[Terminal]", {
    description = "Tag for all chat messages.",
    category = APPEARANCE_GROUP,

    ui = {}
}, 1) 

mvp.config.Add("language", "english", {
    description = "Language for Terminal to use.",
    category = APPEARANCE_GROUP,

    ui = {
        type = "dropdown",
        choices = function()
            return {
                english = "English",
                russian = "Russian",
                chinese = "Chinese",
            }
        end
    }
}, 2)

mvp.config.Add("theme", "dark", {
    description = "Theme for the Terminal.",
    category = APPEARANCE_GROUP,

    ui = {
        type = "dropdown",
        choices = function()
            return {
                dark = "Dark",
                light = "Light"
            }
        end
    }
}, 3)

local DEVELOPER_GROUP = mvp.config.RegisterCategory("Developer", TERMINAL_SECTION, 100)

mvp.config.Add("debug", false, {
    description = "Controls whether or not debug messages are printed to the console.",
    category = DEVELOPER_GROUP,

    ui = {}
}, 1) 

mvp.config.Add("debugHUD", false, {
    description = "Controls whether or not debug HUD is shown.",
    category = DEVELOPER_GROUP,

    ui = {}
}, 2) 

