local TERMINAL_SECTION = mvp.config.RegisterSection("terminal", -1)

local GENERAL_GROUP = mvp.config.RegisterCategory("general", TERMINAL_SECTION, 1)

mvp.config.Add("prefix", "!", {
    description = "Prefix for all commands.",
    category = GENERAL_GROUP,

    ui = {} 
}, 1)

mvp.config.Add("allowConsoleCommand", true, {
    description = "Controls whether or not the console command for opening menu is allowed.",
    category = GENERAL_GROUP,

    ui = {}
}, 3)

local APPEARANCE_GROUP = mvp.config.RegisterCategory("appearance", TERMINAL_SECTION, 2)

mvp.config.Add("tag", "[Terminal]", {
    description = "Tag for all chat messages.",
    category = APPEARANCE_GROUP,

    ui = {}
}, 1)

mvp.config.Add("language", "en", {
    description = "Language for Terminal to use.",
    category = APPEARANCE_GROUP,

    ui = {
        type = "dropdown",
        choices = function()
            local storedLanguages = mvp.language.list
            local languages = {}

            for k, v in pairs(storedLanguages) do
                languages[k] = k
            end

            return languages
        end
    }
}, 2)

mvp.config.Add("useNotifications", true, {
    description = "Controls whether or not notifications are used.",
    category = APPEARANCE_GROUP,

    ui = {}
}, 3)

mvp.config.Add("notificationsPosition", "bc", {
    description = "Position of notifications.",
    category = APPEARANCE_GROUP,

    postSet = function()
        if (CLIENT) then
            mvp.notification.Add(mvp.NOTIFICATION.INFO, mvp.q.Lang("value.notificationsPosition.ps.title"), mvp.q.Lang("value.notificationsPosition.ps.description"), 5)
        end
    end,

    ui = {
        type = "dropdown",
        choices = function()
            local positionsKeys = {"tl", "tc", "tr", "cl", "cc", "cr", "bl", "bc", "br"}
            local positions = {}

            for _, pos in ipairs(positionsKeys) do
                positions[pos] = mvp.q.Lang("general.screen_position." .. pos)
            end

            return positions
        end
    }
}, 4)

local ICONS_GROUP = mvp.config.RegisterCategory("webImages", TERMINAL_SECTION, 3)

mvp.config.Add("imagesProxy", "", {
    description = "You can pass there a proxy URL, which will be used to download images.",
    category = ICONS_GROUP,

    ui = {}
}, 1)

local DEVELOPER_GROUP = mvp.config.RegisterCategory("developer", TERMINAL_SECTION, 100)

mvp.config.Add("debug", false, {
    description = "Controls whether or not debug messages are printed to the console.",
    category = DEVELOPER_GROUP,

    ui = {}
}, 1)

