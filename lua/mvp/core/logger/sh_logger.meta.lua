mvp = mvp or {}
mvp.meta = mvp.meta or {}

mvp.meta.logger = mvp.meta.logger or {}
mvp.meta.logger.__proto = mvp.meta.logger

mvp.meta.logger.__proto.isLogger = true

function mvp.meta.logger:New()
    local o = table.Copy(self.__proto)

    setmetatable(o, self)
    o.__index = self

    return o
end

function mvp.meta.logger:Init()
    ErrorNoHalt("Not implemented")
end

function mvp.meta.logger:Log(...)
    ErrorNoHalt("Not implemented")
end