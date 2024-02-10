--- This is a loader for the Terminal framework.
-- This simply loads all the necessary files for the framework to work.
--
-- @module mvp.loader
mvp = mvp or {}
mvp.loader = {}
mvp.loader.relativePath = "mvp/"

mvp.loader.Print = function(...)
    if (not mvp.logger or not mvp.logger.isReady) then
        MsgC(Color(0, 168, 255), "[MVP]", Color(225, 177, 44), "[Loader] ", Color(255, 255, 255), ...)
        MsgC("\n")
        
        return
    end

    mvp.logger.Log(mvp.LOG.INFO, "Loader", ...)
end

--- Sends a file to client and loads it on server.
-- This function supposed to be called *only* on SHARED realm, otherwise it will not work properly.
--
-- @realm shared
-- @tparam string path Path to the file
-- @usage mvp.loader.LoadClientFile("mvp/modules/terminal/sh_terminal.lua")
function mvp.loader.LoadClientFile(path)
    if (SERVER) then
        AddCSLuaFile(path)
    else
        include(path)
    end

    mvp.loader.Print(Color(255, 174, 0), "▐▌", color_white, " Loaded ", Color(255, 174, 0), "CL", Color(255, 255, 255), " file: ", path)
end

--- Loads a file on server.
-- This function supposed to be called *only* on SERVER realm, if called on CLIENT - nothing will happen.
-- Can be called on SHARED realm, but it will not be sent to client and will be loaded only on server.
--
-- @realm shared
-- @tparam string path Path to the file
-- @usage mvp.loader.LoadServerFile("mvp/modules/terminal/sv_terminal.lua")
function mvp.loader.LoadServerFile(path)
    if (CLIENT) then return end

    include(path)

    mvp.loader.Print(Color(0, 102, 255), "▐▌", color_white, " Loaded ", Color(0, 102, 255), "SV", Color(255, 255, 255), " file: ", path)
end

--- Sends a file to client and loads it on both server and client.
-- This function supposed to be called *only* on SHARED realm, otherwise it will not work properly.
--
-- @realm shared
-- @tparam string path Path to the file
-- @usage mvp.loader.LoadSharedFile("mvp/modules/terminal/sh_terminal.lua")
function mvp.loader.LoadSharedFile(path)
    if (SERVER) then
        AddCSLuaFile(path)
    end
    include(path)

    mvp.loader.Print(Color(255, 174, 0), "▐", Color(0, 102, 255), "▌", color_white, " Loaded ", Color(255, 174, 0), "S", Color(0, 102, 255), "H", Color(255, 255, 255), " file: ", path)
end

--- Loads a file.
-- This function supposed to be called *only* on SHARED realm, otherwise it will not work properly.
--
-- @realm shared
-- @tparam string path Path to the file
-- @tparam[opt=shared] string forcedRealm Realm to load the file on. Can be "client", "server", otherwise it will be treated as "shared"
-- @tparam[opt=false] bool fromLua If true, then the path will be treated as a path from lua/ folder, otherwise it will be treated as a path from mvp/ folder
--
-- @usage mvp.loader.LoadFile("mvp/modules/terminal/sh_terminal.lua")
-- @usage mvp.loader.LoadFile("terminal/sh_terminal.lua", "client") -- will load the file on client
-- @usage mvp.loader.LoadFile("terminal/sh_terminal.lua", "server") -- will load the file on server
function mvp.loader.LoadFile(path, forcedRealm, fromLua)
    path = (fromLua and '' or mvp.loader.relativePath) .. path

    if (forcedRealm != nil) then
        forcedRealm = string.lower(forcedRealm)
    end

    if (forcedRealm == "client" or path:find("cl_")) then
        mvp.loader.LoadClientFile(path)
    elseif (forcedRealm == "server" or path:find("sv_")) then
        mvp.loader.LoadServerFile(path)
    else -- shared
        mvp.loader.LoadSharedFile(path)
    end
end

--- Loads a folder.
-- This function supposed to be called *only* on SHARED realm, otherwise it will not work properly.
--
-- @realm shared
-- @tparam string path Path to the folder
-- @tparam[opt=false] bool recursive If true, then the function will load all the files in the folder recursively
-- @tparam[opt=false] bool fromLua If true, then the path will be treated as a path from lua/ folder, otherwise it will be treated as a path from mvp/ folder
--
-- @usage mvp.loader.LoadFolder("mvp/modules/terminal/")
-- @usage mvp.loader.LoadFolder("terminal/", true) -- will load all the files in the folder recursively
function mvp.loader.LoadFolder(path, recursive, fromLua)
    path = (fromLua and '' or mvp.loader.relativePath) .. path

    if (not string.EndsWith(path, ".lua") and not string.EndsWith(path, "/")) then
        path = path .. "/"
    end

    local files, folders = file.Find(path .. "*", "LUA")

    for _, fileName in ipairs(files) do
        mvp.loader.LoadFile(path .. fileName, nil, true)
    end

    if (recursive) then
        for _, folderName in ipairs(folders) do
            mvp.loader.LoadFolder(path .. folderName .. "/", true, true)
        end
    end
end