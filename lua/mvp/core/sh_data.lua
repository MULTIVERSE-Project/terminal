mvp = mvp or {}
mvp.data = mvp.data or {}

mvp.data.bucket = "mvp/" -- path to save data in "data/" folder
mvp.data.cache = {
    global = {}, -- global cache
    map = {}, -- map cache
} -- cache of data

function mvp.data.Set(key, value, isMap)
    -- mvp/global/[key].txt
    -- mvp/maps/[map]/[key].txt

    local destination = isMap and (game.GetMap() .. "/") or "global/"

    local folderPath = mvp.data.bucket .. destination
    local filePath = folderPath .. key .. ".txt"

    if not file.Exists(folderPath, "DATA") then
        file.CreateDir(folderPath)
    end

    file.Write(filePath, util.TableToJSON({value}))
    mvp.data.cache[isMap and "map" or "global"][key] = value

    return value
end

function mvp.data.Get(key, default, isMap, skipCache)
    -- mvp/global/[key].txt
    -- mvp/maps/[map]/[key].txt

    local destination = isMap and (game.GetMap() .. "/") or "global/"
    local cacheType = isMap and "map" or "global"

    local folderPath = mvp.data.bucket .. destination
    local filePath = folderPath .. key .. ".txt"

    if (not skipCache and not mvp.data.cache[cacheType][key]) then
        return mvp.data.cache[cacheType][key]
    end

    local data = file.Read(filePath, "DATA")
    if (data) then
        mvp.data.cache[cacheType][key] = util.JSONToTable(data)[1]
        return util.JSONToTable(data)[1]
    end

    return default
end