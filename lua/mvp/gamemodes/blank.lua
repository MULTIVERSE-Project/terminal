local gm = mvp.meta.gamemode:New()

gm:SetName("Blank")
gm:SetDescription("A blank gamemode for testing purposes.")
gm:SetAuthor("Kot")
gm:SetVersion("1.0.0")
gm:SetLicense("MIT")

-- Economy functions

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

function gm:FormatMoney(ply, sum)
    return tostring(sum) .. " mvp$"
end

-- Models functions

function gm:GetAvailableModels(ply)
    return {ply:GetModel()}
end

function gm:GetJobTable(ply)
    return nil
end

mvp.gamemode.Register(gm)