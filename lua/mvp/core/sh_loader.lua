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

function mvp.loader.LoadClFile(path, fromLuaFolder)
    local fullPath = fromLuaFolder and path or (mvp.loader.relativePath .. path)

    if SERVER then
        AddCSLuaFile(fullPath)
    else
        include(fullPath)
    end

    p(Color(255, 174, 0), '▐▌', mvp.WHITE, ' Loaded ', Color(255, 174, 0), 'CL', mvp.WHITE, ' file: ', path)
end

function mvp.loader.LoadShFile(path, fromLuaFolder)
    local fullPath = fromLuaFolder and path or (mvp.loader.relativePath .. path)

    if SERVER then
        AddCSLuaFile(fullPath)
    end

    include(fullPath)

    p(Color(255, 174, 0), '▐', mvp.BLUE, '▌', mvp.WHITE, ' Loaded ', Color(255, 174, 0), '▐', mvp.BLUE, '▌', mvp.WHITE, ' Loaded ', Color(255, 174, 0), 'S', mvp.BLUE, 'H', mvp.WHITE, ' file: ', path)
end

function mvp.loader.LoadSvFile(path, fromLuaFolder)
    local fullPath = fromLuaFolder and path or (mvp.loader.relativePath .. path)

    if SERVER then
        include(fullPath)
    end

    p(mvp.BLUE, '▐▌', mvp.WHITE, ' Loaded ', mvp.BLUE, 'SV', mvp.WHITE, ' file: ', path)
end

function mvp.loader.LoadFile(path, realm)
	if ((realm == 'server' or path:find('sv_')) and SERVER) then
		return mvp.loader.LoadSvFile(path)
	elseif (realm == 'client' or path:find('cl_')) then
		return mvp.loader.LoadClFile(path)
    else
        return mvp.loader.LoadShFile(path)
    end
end

function mvp.loader.LoadFolder(path, realm)
    local files, folders = file.Find(path .. '/*', 'LUA')

    for _, file in ipairs(files) do
        mvp.loader.LoadFile(path .. '/' .. file, realm)
    end

    for _, folder in ipairs(folders) do
        mvp.loader.LoadFolder(path .. '/' .. folder, realm)
    end
end