--- This is utility module for loading files through the Terminal
-- by default, it will load files from the mvp/ folder.
-- @module mvp.loader

mvp = mvp or {}
mvp.loader = mvp.loader or {}

mvp.loader.relativePath = 'mvp/'

function mvp.loader.Print(...)
    if mvp.logger and mvp.logger.ready then
        mvp.logger.Log(...)
    else
        MsgC(mvp.CYAN, '[MVP | Terminal]', mvp.ORANGE, '[Loader] ', Color(255, 255, 255), ...)
        MsgC('\n')
    end
end

local p = mvp.loader.Print

--- Loads a file for the client. Must be called on both the client and server.
-- @realm shared
-- @string path The path to the file, relative to the mvp/ folder.
-- @bool[opt=false] fromLuaFolder Whether or not ignore relative path and load from the lua/ folder directly.
function mvp.loader.LoadClFile(path, fromLuaFolder)
    local fullPath = fromLuaFolder and path or (mvp.loader.relativePath .. path)

    if SERVER then
        AddCSLuaFile(fullPath)
    else
        include(fullPath)
    end

    p(Color(255, 174, 0), '▐▌', mvp.WHITE, ' Loaded ', Color(255, 174, 0), 'CL', mvp.WHITE, ' file: ', path)
end

--- Loads a file fir server and client. Must be called on both the client and server.
-- @realm shared
-- @string path The path to the file, relative to the mvp/ folder.
-- @bool[opt=false] fromLuaFolder Whether or not ignore relative path and load from the lua/ folder directly.
function mvp.loader.LoadShFile(path, fromLuaFolder)
    local fullPath = fromLuaFolder and path or (mvp.loader.relativePath .. path)

    if SERVER then
        AddCSLuaFile(fullPath)
    end

    include(fullPath)

    p(Color(255, 174, 0), '▐', mvp.BLUE, '▌', mvp.WHITE, ' Loaded ', Color(255, 174, 0), '▐', mvp.BLUE, '▌', mvp.WHITE, ' Loaded ', Color(255, 174, 0), 'S', mvp.BLUE, 'H', mvp.WHITE, ' file: ', path)
end

--- Loads a file for the server. Must be called on the server.
-- @realm shared
-- @string path The path to the file, relative to the mvp/ folder.
-- @bool[opt=false] fromLuaFolder Whether or not ignore relative path and load from the lua/ folder directly.
function mvp.loader.LoadSvFile(path, fromLuaFolder)
    local fullPath = fromLuaFolder and path or (mvp.loader.relativePath .. path)

    if SERVER then
        include(fullPath)
    end

    p(mvp.BLUE, '▐▌', mvp.WHITE, ' Loaded ', mvp.BLUE, 'SV', mvp.WHITE, ' file: ', path)
end

--- Loads a file based on the realm. If the realm is not specified, it will try to guess it based on the file name.
--
-- `sv_` prefix will load the file for the server only,
-- `cl_` prefix will load the file for the client only,
-- in other cases, it will load the file for both the server and client (`shared`).
-- 
-- @realm shared
-- @string path The path to the file, relative to the mvp/ folder.
-- @string[opt] realm The realm to load the file for. Can be `server`, `client` or `shared`.
function mvp.loader.LoadFile(path, realm)
	if ((realm == 'server' or path:find('sv_')) and SERVER) then
		return mvp.loader.LoadSvFile(path)
	elseif (realm == 'client' or path:find('cl_')) then
		return mvp.loader.LoadClFile(path)
    else
        return mvp.loader.LoadShFile(path)
    end
end

--- Loads all files in folder recursively. If the realm is not specified, it will try to guess it based on the file name. See `mvp.loader.LoadFile` for more info about file naming.
-- @realm shared
-- @string path The path to the folder, relative to the mvp/ folder.
-- @string[opt] realm The realm to load the files for. Can be `server`, `client` or `shared`.
function mvp.loader.LoadFolder(path, realm)
    local files, folders = file.Find(path .. '/*', 'LUA')

    for _, file in ipairs(files) do
        mvp.loader.LoadFile(path .. '/' .. file, realm)
    end

    for _, folder in ipairs(folders) do
        mvp.loader.LoadFolder(path .. '/' .. folder, realm)
    end
end