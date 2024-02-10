local gm = mvp.meta.gamemode:New()

gm:SetName("Blank")
gm:SetDescription("A blank gamemode for testing purposes.")
gm:SetAuthor("Kot")
gm:SetVersion("1.0.0")
gm:SetLicense("MIT")

function gm:GetMoney(ply)
    return 99999
end

function gm:CanAfford(ply, sum)
    return true
end

function gm:AddMoney(ply, sum)
    return true
end

function gm:TakeMoney(ply, sum)
    return true
end

function gm:FormatMoney(sum)
    return tostring(sum) .. " mvp$"
end

mvp.gamemode.Register(gm)