local C = mvp.meta.command:New()

C:SetID("terminal")
C:SetName("terminal")
C:SetDescription("Open a terminal")

function C:Execute(ply)
    -- only executed on the server

    net.Start("mvp.terminal.open")
    net.Send(ply)
end

if (SERVER) then
    util.AddNetworkString("mvp.terminal.open")
else
    net.Receive("mvp.terminal.open", function()
        mvp.menus.admin.Open()
    end)
end

mvp.command.Register(C)