--[[--
Logger adapter. This is the base class for all logger implementations. You can create your own logger by inheriting from this class.

Example:
    local logger = mvp.meta.logger:New()

    function logger:Init()
        print("Logger initialized")
    end

    function logger:Log(timestamp, level, ...)
        print(timestamp, level, ...)
    end

    return logger

⚠️ **Warning:** Please remember to return the logger instance at the end of the file. Otherwise it won't be loaded.

All your implementations of adapters should go under `mvp/adapters/` and should be named `mvp/adapters/<name>.lua` wihtout realm prefix. All adapters are loaded automatically on shared realm.
]]--
-- @classmod mvp.meta.logger


mvp = mvp or {}
mvp.meta = mvp.meta or {}

mvp.meta.logger = {}

--- Create a new logger adapter.
-- @realm shared
-- @treturn mvp.meta.logger A new logger adapter.
function mvp.meta.logger:New()
    local logger = {}
    
    setmetatable(logger, self)
    self.__index = self
    
    return logger
end

--- Initialize the logger.
-- Meant to be overridden by the logger implementation.
-- @realm shared
function mvp.meta.logger:Init()
    error("Not implemented")
end

--- Log a message.
-- Meant to be overridden by the logger implementation.
-- @realm shared
-- @string timestamp The timestamp of the log message.
-- @param level The log level of the message.
-- @param ... The message to log.
function mvp.meta.logger:Log(timestamp, level, ...)
    error("Not implemented")
end