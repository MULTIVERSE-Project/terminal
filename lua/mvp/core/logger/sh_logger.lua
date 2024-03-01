mvp = mvp or {}
mvp.logger = mvp.logger or {}

mvp.logger.list = {}
mvp.logger.isReady = mvp.logger.isReady or false

function mvp.logger.Register(logger)
    if (not logger.isLogger) then
        error("Logger must be a logger!")
    end

    local success = pcall(function()
        logger:Init()
    end)

    if (not success) then
        error("Logger failed to initialize!")
    end

    mvp.logger.list[#mvp.logger.list + 1] = logger

    mvp.logger.isReady = true

    return logger
end

function mvp.logger.Log(level, caller, ...)
    if (not isnumber(level)) then
        level = mvp.LOG[level] or mvp.LOG.INFO
    end

    local args = {...}

    for _, logger in ipairs(mvp.logger.list) do
        pcall(function()
            logger:Log(level, caller, unpack(args))
        end)
        
        if (level == mvp.LOG.ERROR) then
            pcall(function()
                local trace = mvp.utils.GetTrace()

                logger:Log(mvp.LOG.DEBUG, caller, trace)
            end)
        end
    end
end