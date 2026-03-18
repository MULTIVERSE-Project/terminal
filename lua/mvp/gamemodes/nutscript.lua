local gm = mvp.meta.gamemode:New()

gm:SetName("NutScript")
gm:SetDescription("Support for NutScript gamemode.")
gm:SetAuthor("Kot")
gm:SetVersion("1.0.0")
gm:SetLicense("MIT")

function gm:GetMoney(ply)
    return ply:getMoney() or 0
end

function gm:CanAfford(ply, sum)
    return ply:getChar():hasMoney(sum)
end

function gm:AddMoney(ply, sum)
    return ply:getChar():giveMoney(sum)
end

function gm:TakeMoney(ply, sum)
    return ply:getChar():takeMoney(sum)
end

function gm:FormatMoney(ply, sum)
    return nut.currency.get(sum)
end

function gm:GetAvailableModels(ply)
    return {ply:GetModel()}
end

mvp.gamemode.Register(gm)