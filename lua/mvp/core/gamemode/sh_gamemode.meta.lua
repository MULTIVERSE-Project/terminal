mvp = mvp or {}
mvp.meta.gamemode = mvp.meta.gamemode or {}

mvp.meta.gamemode.__proto = mvp.meta.gamemode

function mvp.meta.gamemode:New()
    local o = table.Copy(mvp.meta.gamemode.__proto)

    setmetatable(o, mvp.meta.gamemode)
    o.__index = self

    local cwd = debug.getinfo(2, "S").short_src
    local gamemodeFile = string.match(cwd, "mvp/gamemodes/([^/]+)%.lua")

    o:SetID(gamemodeFile)

    return o
end

AccessorFunc(mvp.meta.gamemode, "_id", "ID", FORCE_STRING)

mvp.meta.gamemode.__proto._name = "Unnamed gamemode"
AccessorFunc(mvp.meta.gamemode, "_name", "Name", FORCE_STRING)

mvp.meta.gamemode.__proto._description = "No description"
AccessorFunc(mvp.meta.gamemode, "_description", "Description", FORCE_STRING)

mvp.meta.gamemode.__proto._author = "Unknown"
AccessorFunc(mvp.meta.gamemode, "_author", "Author", FORCE_STRING)

mvp.meta.gamemode.__proto._version = "0.0.0"
AccessorFunc(mvp.meta.gamemode, "_version", "Version", FORCE_STRING)

mvp.meta.gamemode.__proto._license = "Unknown"
AccessorFunc(mvp.meta.gamemode, "_license", "License", FORCE_STRING)

--[[
    Economy functions
]]--
function mvp.meta.gamemode:GetMoney(player)
    error("Not implemented")
end
function mvp.meta.gamemode:CanAfford(player, sum)
    error("Not implemented")
end
function mvp.meta.gamemode:AddMoney(player, sum)
    error("Not implemented")
end
function mvp.meta.gamemode:TakeMoney(player, sum)
    error("Not implemented")
end
function mvp.meta.gamemode:FormatMoney(player, sum)
    error("Not implemented")
end