--[[--
Logging module for Terminal. 
]]
-- @module mvp.logger

mvp = mvp or {}
mvp.logger = mvp.logger or {}

mvp.logger.adapters = {}

mvp.logger.ready = false
mvp.logger.earlyLogs = {}

--- Logs a message to all adapters.
-- @realm shared
-- @param level The log level.
-- @param ... The message to log.
function mvp.logger.Log(level, ...)
    if not mvp.logger.ready then
        mvp.logger.earlyLogs[#mvp.logger.earlyLogs + 1] = {
            timestamp = os.date('%Y-%m-%d %H:%M:%S'), 
            level = level, 
            message = {...}
        }
        
        return
    end

    for _, adapter in pairs(mvp.logger.adapters) do
        adapter:Log(nil, level, ...) -- let adapter record the time by itself
    end
end

--- Initializes the logger.
-- @realm shared
-- @internal
function mvp.logger.Init()
    mvp.logger.adapters = {}

    local basePath = mvp.loader.relativePath .. 'adapters/logger/'
    local adapters = file.Find( basePath .. '*.lua', 'LUA')

    for _, adapterFile in pairs(adapters) do
        local adapterPath = basePath .. adapterFile
        local adapterName = string.StripExtension(adapterFile)

        if SERVER then 
            AddCSLuaFile(adapterPath)
        end

        print('Loading logger adapter: ' .. adapterName) 

        mvp.logger.adapters[adapterName] = include(adapterPath)

        if SERVER and mvp.logger.adapters[adapterName].Init then
            mvp.logger.adapters[adapterName]:Init()
        end
    end

    mvp.logger.ready = true
    mvp.logger.Log(mvp.LOG_INFO, 'Logger initialized and ready to go!')
    mvp.logger.Log(mvp.LOG_INFO, 'Checking for early logs...')

    for _, log in pairs(mvp.logger.earlyLogs) do
        for _, adapter in pairs(mvp.logger.adapters) do
            adapter:Log(log.timestamp, log.level, mvp.GREEN, '[EARLY] ', mvp.WHITE, unpack(log.message))
        end
    end
end
