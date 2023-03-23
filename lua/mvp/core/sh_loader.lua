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