local GAMEMODES_SECTION = mvp.config.RegisterSection("Server", 1)

local SETTINGS_GROUP = mvp.config.RegisterCategory("Gamemode", GAMEMODES_SECTION, 1)

mvp.config.Add("gamemode", "blank", {
    description = "The gamemode you using on your server.",

    category = SETTINGS_GROUP, 

    ui = {
        type = "dropdown",
        choices = function()
            local gamemodes = mvp.gamemode.GetList()

            local choices = {}

            for k, v in pairs(gamemodes) do
                choices[v:GetID()] = v:GetName()
            end

            return choices
        end
    }
})

local BRANDING_GROUP = mvp.config.RegisterCategory("Branding", GAMEMODES_SECTION, 2)

mvp.config.Add("logo", "blank", {
    description = "The logo you want to use on your server. Should be a path to a image in you server's materials folder.",

    category = BRANDING_GROUP,
}, 1) 

mvp.config.Add("servername", "Example Server", {
    description = "The name of your server.",

    category = BRANDING_GROUP,
}, 2)
 