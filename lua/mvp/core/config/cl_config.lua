mvp = mvp or {}
mvp.config = mvp.config or {}

-- @todo: retrieve configs from server
function mvp.config.RequestSynchronization()
    net.Start("mvp.config.RequestSynchronization")
    net.SendToServer()
end

net.Receive("mvp.config.Synchronize", function()
    local configs = net.ReadTable()

    for k, v in pairs(configs) do
        if (not mvp.config.list[k]) then
           continue 
        end

        mvp.config.list[k].value = v
    end

    mvp.logger.Log(mvp.LOG.DEBUG, "Config", "Synchronized configs with server")

    hook.Run("mvp.config.Synchronized")
end)

net.Receive("mvp.config.UpdateValue", function()
    local key = net.ReadString()
    local value = net.ReadType()

    local config = mvp.config.list[key]

    if (not config) then
        return
    end
    
    local oldValue = config.value

    config.preSet(value, oldValue)
    config.value = value
    config.postSet(value, oldValue)

    if (value ~= oldValue) then
        hook.Run("mvp.config.Updated", key, value, oldValue)
    end
end)