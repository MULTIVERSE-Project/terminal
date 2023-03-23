mvp = mvp or {}
mvp.logger = mvp.logger or {}

mvp.logger.adapters = {}

function mvp.logger.Log(level, ...)
    for _, adapter in pairs(mvp.logger.adapters) do
        adapter:Log(level, ...)
    end
end

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
end
