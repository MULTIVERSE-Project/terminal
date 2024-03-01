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

    mvp.logger.Log(mvp.LOG.INFO, "Gamemodes", "Registered gamemode '" .. id .. "@" .. gm:GetVersion() .. "'")
    hook.Run("mvp.gamemode.Registered", gm)
end

function mvp.gamemode.GetList()
    return mvp.gamemode.list
end

function mvp.gamemode.Get(id)
    return mvp.gamemode.list[id]
end

function mvp.gamemode.GetActiveID()
    return mvp.config.Get("gamemode", "blank")
end

function mvp.gamemode.GetActive()
    return mvp.gamemode.Get(mvp.gamemode.GetActiveID())
end

function mvp.gamemode.Init()
    mvp.logger.Log(mvp.LOG.INFO, "Gamemodes", "Initializing gamemodes...")

    mvp.loader.LoadFolder("gamemodes")

    mvp.logger.Log(mvp.LOG.INFO, "Gamemodes", "Initialized gamemodes!")
end

--[[
    Gamemode functions
]]--

function mvp.gamemode.GetBalance(ply)
    local gm = mvp.gamemode.GetActive()

    return gm:GetMoney(ply)
end

function mvp.gamemode.GetBalanceFormatted(ply)
    local gm = mvp.gamemode.GetActive()

    return gm:FormatMoney(ply, gm:GetMoney(ply))
end

function mvp.gamemode.CanAfford(ply, amount)
    local gm = mvp.gamemode.GetActive()

    return gm:CanAfford(ply, amount)
end

function mvp.gamemode.AddMoney(ply, amount)
    local gm = mvp.gamemode.GetActive()

    return gm:AddMoney(ply, amount)
end

function mvp.gamemode.TakeMoney(ply, amount)
    local gm = mvp.gamemode.GetActive()

    return gm:TakeMoney(ply, amount)
end

function mvp.gamemode.FormatMoney(ply, amount)
    local gm = mvp.gamemode.GetActive()

    return gm:FormatMoney(ply, amount)
end