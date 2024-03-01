local gm = mvp.meta.gamemode:New()

gm:SetName("DarkRP")
gm:SetDescription("Support for DarkRP gamemode.")
gm:SetAuthor("Kot")
gm:SetVersion("1.0.0")
gm:SetLicense("MIT")

function gm:GetMoney(ply)
    return ply:getDarkRPVar("money") or 0
end

function gm:CanAfford(ply, sum)
    print(ply, sum)
    return ply:canAfford(sum)
end

function gm:AddMoney(ply, sum)
    return ply:addMoney(sum)
end

function gm:TakeMoney(ply, sum)
    return ply:addMoney(-sum)
end

function gm:FormatMoney(ply, sum)
    return DarkRP.formatMoney(sum)
end

mvp.gamemode.Register(gm)