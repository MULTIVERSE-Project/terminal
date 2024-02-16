--- @module mvp

mvp = mvp or {}

--- A table of variable types that are used throughout the framework. It represents types as a table with the keys being the
-- name of the type, and the values being some number value. **You should never directly use these number values!** Using the
-- values from this table will ensure backwards compatibility if the values in this table change.
--
-- This table also contains the numerical values of the types as keys. This means that if you need to check if a type exists, or
-- if you need to get the name of a type, you can do a table lookup with a numerical value. Note that special types are not
-- included since they are not real types that can be compared with.
-- @table mvp.type
-- @realm shared
-- @field string A regular string.
-- @field number Any number.
-- @field player Any player that matches the given query string in `mvp.util.FindPlayer`.
-- @field steamid A string that matches the Steam ID format of `STEAM_X:X:XXXXXXXX`.
-- @field bool A string representation of a bool - `false` and `0` will return `false`, anything else will return `true`.
-- @field color A color represented by its red/green/blue/alpha values.
-- @field vector A 3D vector represented by its x/y/z values.
-- @field array Any table.
-- @usage -- checking if type exists
-- print(mvp.type[2] ~= nil)
-- > true
--
-- -- getting name of type
-- print(mvp.type[mvp.type.string])
-- > 'string'

mvp.type = {
    [2] = "string",
    [4] = "text",
    [8] = "number",
    [16] = "player",
    [32] = "steamid",
    [64] = "bool",
    [1024] = "color",
    [2048] = "vector",

    string = 2,
    text = 4,
    number = 8,
    player = 16,
    steamid = 32,
    bool = 64,
    color = 1024,
    vector = 2048,

    optional = 256,
    array = 512
} 

mvp.LOG = {
    INFO = 1,
    WARN = 2,
    ERROR = 3,
    FATAL = 4,
    DEBUG = 5,

    [1] = "INFO",
    [2] = "WARN",
    [3] = "ERROR",
    [4] = "FATAL",
    [5] = "DEBUG"
}

mvp.loader.LoadFile("core/sh_data.lua")

--[[ 

    Logger
    This loads core of the logger and then loads all loggers, since we need to have logging before anything else

]]--
mvp.loader.LoadFolder("core/logger")
mvp.loader.LoadFolder("loggers")

mvp.loader.LoadFile("core/sh_types.lua")
mvp.loader.LoadFile("core/sh_permissions.lua")

mvp.loader.LoadFolder("core/ui")
mvp.loader.LoadFile("core/cl_fonts.lua") 

--[[ 

    Thirdparty
    This loads thirdparty libraries, we need to load them before anything else

]]--
mvp.loader.LoadFolder("thirdparty", true) -- true means load recursively

--[[ 

    Utilities
    This loads core of the utilities

]]--
mvp.loader.LoadFolder("core/utils")

--[[ 

    Configurations
    This loads core of the configurations

]]--
mvp.loader.LoadFolder("core/config")
mvp.config.Init()

--[[ 

    Packages
    This loads core of the packages

]]--
mvp.loader.LoadFolder("core/package") 
mvp.package.Init()

--[[
    Gamemodes support
]]-- 
mvp.loader.LoadFolder("core/gamemode")
mvp.gamemode.Init()

mvp.loader.LoadFolder("core/credits")
mvp.loader.LoadFolder("credits") -- there is no need to initialize credits, they are loaded automatically

mvp.loader.LoadFolder("vgui", true)
mvp.loader.LoadFolder("menus", true) 

mvp.permissions.AddPermission("mvp.terminal", "superadmin", "Allows access to the Terminal menu", 1)
mvp.permissions.AddPermission("mvp.terminal.configs", "superadmin", "Allows to change Terminal configurations", 2)
mvp.permissions.AddPermission("mvp.terminal.packages", "superadmin", "Allows to control what packages are being loaded", 3)