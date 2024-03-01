local gm = mvp.meta.gamemode:New()

gm:SetName("Helix")
gm:SetDescription("Support for Helix gamemode.")
gm:SetAuthor("Kot")
gm:SetVersion("1.0.0")
gm:SetLicense("MIT")

function gm:GetMoney(ply)
    return ply:GetCharacter():GetMoney() or 0
end

function gm:CanAfford(ply, sum)
    return ply:GetCharacter():HasMoney(sum)
end

function gm:AddMoney(ply, sum)
    return ply:GetCharacter():GiveMoney(sum)
end

function gm:TakeMoney(ply, sum)
    return ply:GetCharacter():TakeMoney(sum)
end

function gm:FormatMoney(ply, sum)
    return ix.currency.Get(amount)
end

mvp.gamemode.Register(gm)