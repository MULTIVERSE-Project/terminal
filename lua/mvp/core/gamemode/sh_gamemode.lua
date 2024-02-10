mvp = mvp or {}
mvp.gamemode = mvp.gamemode or {}

mvp.gamemode.list = {}

function mvp.gamemode.Register(gm)
    local id = gm:GetID()

    if (mvp.gamemode.list[id]) then
        mvp.logger.Log(mvp.LOG.WARN, "Gamemodes", "Gamemode '" .. id .. "' already registered! Overwriting...")
        mvp.logger.Log(mvp.LOG.WARN, "Gamemodes", "This is probably a bug! Since this should not happen outside of development!")

        mvp.logger.Log(mvp.LOG.DEBUG, nil, "ID: " .. id)

        mvp.gamemode.list[id] = nil
    end

    mvp.gamemode.list[id] = gm

    mvp.logger.Log(mvp.LOG.DEBUG, "Gamemodes", "Registered gamemode '" .. id .. "@" .. gm:GetVersion() .. "'")
    hook.Run("mvp.gamemode.Registered", gm)
end

function mvp.gamemode.GetList()
    return mvp.gamemode.list
end

function mvp.gamemode.Get(id)
    return mvp.gamemode.list[id]
end

function mvp.gamemode.GetActiveID()
    return mvp.config.Get("activeGamemode", "blank")
end

function mvp.gamemode.GetActive()
    return mvp.gamemode.Get(mvp.gamemode.GetActiveID())
end

function mvp.gamemode.Init()
    mvp.logger.Log(mvp.LOG.DEBUG, "Gamemodes", "Initializing gamemodes...")

    mvp.loader.LoadFolder("gamemodes")

    mvp.logger.Log(mvp.LOG.DEBUG, "Gamemodes", "Initialized gamemodes!")
end