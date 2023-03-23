mvp = mvp or {}
mvp.meta = mvp.meta or {}

mvp.meta.logger = {}

function mvp.meta.logger:New()
    local logger = {}
    
    setmetatable(logger, self)
    self.__index = self
    
    return logger
end

function mvp.meta.logger:Log(level, ...)
    print(message)
end