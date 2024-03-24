mvp = mvp or {}
mvp.config = mvp.config or {}

mvp.config.list = mvp.config.list or {}

util.AddNetworkString("mvp.config.Synchronize") -- used to synchronize the client with the server, when the client joins
util.AddNetworkString("mvp.config.RequestSynchronization") -- used to request a synchronization from the client, when the client joins
util.AddNetworkString("mvp.config.UpdateValue") -- used when a config value is changed, to update the client
util.AddNetworkString("mvp.config.ChangeValue") -- used when a config value is changed, to notify the server about the change, and to notify the client if the change was successful

net.Receive("mvp.config.RequestSynchronization", function(len, ply)
    mvp.config.Synchronize(ply)
end)

net.Receive("mvp.config.ChangeValue", function(len, ply)
    -- @todo: Check if the player is allowed to change the config
    
    local key = net.ReadString()
    local value = net.ReadType()

    local success, finalValue = mvp.config.UpdateValue(key, value)

    net.Start("mvp.config.ChangeValue")
        net.WriteBool(success)
        net.WriteString(key)
        net.WriteType(finalValue)
    net.Send(ply)
end)

function mvp.config.UpdateValue(key, value)
    local config = mvp.config.list[key]

    if (not config or not config.typeOf) then
        -- @todo: throw error, for now just return
        return
    end

    local oldValue = config.value

    local finalValue = value

    if (config.preSet) then
        local overwrittenValue = config.preSet(value, oldValue)
        
        local valueType = mvp.types.GetTypeFromValue(value)
        local overwrittenValueType = mvp.types.GetTypeFromValue(overwrittenValue)

        if (overwrittenValue ~= nil) then
            if (valueType == overwrittenValueType) then
                finalValue = overwrittenValue
            else
                -- @todo: throw no halting error
                -- @notes: maybe return a reason why it failed

                return false, finalValue
            end
        end
    end

    finalValue = mvp.types.SanitizeType(config.typeOf, finalValue)

    -- there are some room for extension here
    -- @notes: additional checks can be added here, for example if the value is a number, check if it is within a certain range
    config.value = finalValue

    if (not config.isServerOnly) then
        net.Start("mvp.config.UpdateValue")
            net.WriteString(key)
            net.WriteType(finalValue)
        net.Broadcast()
    end

    if (config.postSet) then
        config.postSet(finalValue, oldValue)
    end

    if (oldValue ~= finalValue) then
        hook.Run("mvp.config.ValueChanged", key, finalValue, oldValue)
    end

    mvp.config.Save()

    return true, finalValue
end

function mvp.config.GetChangedValues(sanitaze)
    local changed = {}
    local configs = mvp.config.GetList()

    for key, config in pairs(configs) do
        if (sanitaze and config.isServerOnly) then
            continue
        end

        if (config.value ~= config.defaultValue) then
            changed[key] = config.value
        end
    end

    return changed
end

function mvp.config.Synchronize(ply)
    local changed = mvp.config.GetChangedValues(true)

    net.Start("mvp.config.Synchronize")
        net.WriteTable(changed)
    net.Send(ply)

    mvp.logger.Log(mvp.LOG.DEBUG, "Config", "Send synchronization packet to " .. ply:Nick())
end

hook.Add("mvp.PlayerLoaded", "mvp.config.Synchronize", function(ply)
    mvp.config.Synchronize(ply)
end)

function mvp.config.Save()
    local globals = {}
    local mapVars = {}

    local changed = mvp.config.GetChangedValues(false)

    for key, value in pairs(changed) do
        if (mvp.config.list[key].isMapOnly) then
            mapVars[key] = value
        else
            globals[key] = value
        end
    end

    mvp.data.Set("config", globals)
    mvp.data.Set("config", mapVars, true)
end

hook.Add("mvp.config.Inited", "LoadStoredConfig", function()
    local globals = mvp.data.Get("config", {}, false, true) or {}
    local mapVars = mvp.data.Get("config", {}, true, true) or {}

    for key, value in pairs(globals) do
        local storedConfig = mvp.config.list[key]

        if (storedConfig) then
            mvp.config.list[key].value = value
        else
            mvp.config.list[key] = {
                value = value
            }
        end
    end

    for key, value in pairs(mapVars) do
        local storedConfig = mvp.config.list[key]

        if (storedConfig) then
            mvp.config.list[key].value = value
        else
            mvp.config.list[key] = {
                value = value
            }
        end
    end
end)