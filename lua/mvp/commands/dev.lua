local C = mvp.meta.command:New()

C:SetID("dev")
C:SetName("dev")
C:SetDescription("Open a terminal")

function C:Execute(ply)
    -- only executed on the server

    if (not mvp.config.Get("debug", false)) then
        -- @notes: This command is only available in debug mode.
        return
    end

    net.Start("mvp.terminal.dev")
    net.Send(ply)
end

if (SERVER) then
    util.AddNetworkString("mvp.terminal.dev")
else
    net.Receive("mvp.terminal.dev", function()
        mvp.menus.admin.Open()
    end)
end

mvp.command.Register(C)