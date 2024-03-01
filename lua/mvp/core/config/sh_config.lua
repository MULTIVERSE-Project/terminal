mvp = mvp or {}
mvp.config = mvp.config or {}

mvp.config.list = mvp.config.list or {}

mvp.config.categories = {}
mvp.config.sections = {}

function mvp.config.RegisterSection(name, sortIndex)
    if (mvp.config.sections[name]) then 
        return name, mvp.config.sections[name] 
    end

    local sectionTbl = {
        name = name,
        sortIndex = sortIndex or 99,
        categories = {}
    }

    mvp.config.sections[name] = sectionTbl

    return name, sectionTbl
end

function mvp.config.RegisterCategory(name, section, sortIndex)
    if (mvp.config.GetCategoryByName(name, section)) then 
        return mvp.config.GetCategoryByName(name, section)
    end
    
    local nextIndex = #mvp.config.categories + 1
    
    local categoryTbl = {
        name = name,
        section = section,
        sortIndex = sortIndex or 99,
        configs = {}
    }

    mvp.config.categories[nextIndex] = categoryTbl
    mvp.config.sections[section].categories[nextIndex] = categoryTbl

    return nextIndex, categoryTbl
end

function mvp.config.GetCategoryByName(name, section)
    for index, category in ipairs(mvp.config.categories) do
        if (not section) then
            if (category.name == name) then
                return index, category -- guess we can return first one we find
            end
        else
            if (category.name == name and category.section == section) then
                return index, category
            end
        end
    end
end

function mvp.config.GetCategory(index)
    return index, mvp.config.categories[index]
end

function mvp.config.Add(key, defaultValue, configuration, sortIndex)
    configuration = istable(configuration) and configuration or {}

    local oldConfig = mvp.config.list[key]
    local typeOf = configuration.typeOf or mvp.types.GetTypeFromValue(defaultValue)

    local success, message = mvp.utils.Assert(typeOf, "Invalid type for config key '" .. key .. "'")

    if (not success) then
        return mvp.logger.Log(mvp.LOG.ERROR, "Config", message)
    end

    local currentValue = defaultValue

    if (oldConfig ~= nil) then
        if (oldConfig.value ~= nil) then
            currentValue = oldConfig.value
        end

        if (oldConfig.default ~= nil) then
            defaultValue = oldConfig.default
        end
    end

    mvp.config.list[key] = {
        key = key,
        typeOf = typeOf,
        value = currentValue,
        default = defaultValue,

        description = configuration.description or "",
        category = configuration.category or "Other",

        isServerOnly = configuration.isServerOnly or false,
        isMapOnly = configuration.isMapOnly or false,

        preSet = configuration.preSet or function() end,
        postSet = configuration.postSet or function() end,

        ui = configuration.ui or {},
        sortIndex = sortIndex or 99
    }

    if (configuration.category) then
        local _, category = mvp.config.GetCategory(configuration.category)

        if (category) then
            category.configs[key] = mvp.config.list[key]
        end
    end

    mvp.logger.Log(mvp.LOG.DEBUG, "Config", "Added config key '" .. key .. "'")
    hook.Run("mvp.config.Added", key, defaultValue, configuration)
end

function mvp.config.Get(key, defaultValue)
    local config = mvp.config.list[key]

    if (config and config.typeOf) then
        if (config.value ~= nil) then
            return config.value
        end

        if (config.default ~= nil) then
            return config.default
        end
    end
    
    return defaultValue
end

function mvp.config.GetStored(key)
    local config = mvp.config.list[key]

    if (config and config.typeOf) then
        return config
    end
end

function mvp.config.GetList()
    return mvp.config.list
end

function mvp.config.Set(key, value)
    local config = mvp.config.list[key]

    if (not config or not config.typeOf) then
        -- @todo: throw error, for now just return
        return
    end

    if (SERVER) then
        mvp.config.UpdateValue(key, value)
    else
        net.Start("mvp.config.ChangeValue")
            net.WriteString(key)
            net.WriteType(value)
        net.SendToServer()
    end
end

function mvp.config.InitFolder(path)
    mvp.loader.LoadFolder(path)
end

function mvp.config.Init()
    mvp.q.LogInfo("Configs", "Loading Terminal configs system...")
    mvp.config.InitFolder("configs")

    hook.Run("mvp.config.Inited")
end