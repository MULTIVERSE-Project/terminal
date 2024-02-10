mvp = mvp or {}

AddCSLuaFile("mvp/core/sh_loader.lua")
include("mvp/core/sh_loader.lua")

-- @notes: 
-- this is a mess. Workaround for the issue of the player not being fully loaded when the PlayerInitialSpawn hook is called from 2016.
-- https://github.com/Facepunch/garrysmod-requests/issues/718
mvp.loadingPlayers = mvp.loadingPlayers or {}

hook.Add("PlayerInitialSpawn", "mvp.general.PlayerInitialSpawn", function(ply)
    mvp.loadingPlayers[ply] = true
end)

hook.Add("SetupMove", "mvp.general.SetupMove", function(ply, mv, cmd)
    if (mvp.loadingPlayers[ply] and not cmd:IsForced()) then
        mvp.loadingPlayers[ply] = nil
        
        hook.Run("mvp.PlayerLoaded", ply)
    end
end)