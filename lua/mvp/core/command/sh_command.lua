mvp = mvp or {}
mvp.command = mvp.command or {}

mvp.command.list = mvp.command.list or {}

function mvp.command.Register(command)
    local id = command:GetID()

    if (id == "unnamed_command") then
        mvp.q.LogError("Commands", "Unnamed command registered")

        return
    end

    if (mvp.command.list[id]) then
        mvp.q.LogWarn("Commands", "Command with id '" .. id .. "' already exists")
        mvp.q.LogWarn("Commands", "This is probably a bug! Since this should not happen outside of development!")

        mvp.q.LogDebug("Commands", "ID: " .. id)

        mvp.command.list[id] = nil
    end

    mvp.command.list[id] = command

    mvp.q.LogInfo("Commands", "Registered command with id '" .. id .. "'")
    hook.Run("mvp.command.Registered", command)
end

function mvp.command.GetList()
    return mvp.command.list
end

function mvp.command.Get(id)
    return mvp.command.list[id]
end

function mvp.command.Init()
    mvp.q.LogInfo("Commands", "Initializing commands...")

    mvp.loader.LoadFolder("commands")

    mvp.q.LogInfo("Commands", "Initialized commands")
end

hook.Add("PlayerSay", "mvp.command.PlayerSay", function(ply, text)
    local prefix = string.sub(text, 1, 1)
    local configPrefix = mvp.config.Get("prefix")

    if (prefix ~= configPrefix) then return end

    local args = string.Explode(" ", text)
    local command = string.lower(string.sub(args[1], 2))

    table.remove(args, 1)

    local commandObject = mvp.command.Get(command)
    if (not commandObject) then return end

    return commandObject:Run(ply, args) or ""
end)