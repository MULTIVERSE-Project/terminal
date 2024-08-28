mvp = mvp or {}
mvp.notification = mvp.notification or {}

mvp.notification.list = mvp.notification.list or {}
mvp.notification.currentNotification = mvp.notification.currentNotification or nil

local spacing = mvp.ui.Scale(15)
local roundness = mvp.ui.ScaleWithFactor(16)
local iconSize = mvp.ui.Scale(50)

local POSITION_MAP = {
    ["tl"] = function(sx, sy)
        return 0 + spacing, 0 + spacing, -sx, -sy
    end,
    ["tc"] = function(sx, sy)
        return ScrW() * .5 - sx * .5, 0 + spacing, ScrW() * .5 - sx * .5, -sy
    end,
    ["tr"] = function(sx, sy)
        return ScrW() - sx - spacing, 0 + spacing, ScrW(), -sy
    end,
    ["cl"] = function(sx, sy)
        return 0 + spacing, ScrH() * .5 - sy * .5, -sx, ScrH() * .5 - sy * .5
    end,
    ["cc"] = function(sx, sy)
        return ScrW() * .5 - sx * .5, ScrH() * .5 + sy, ScrW() * .5 - sx * .5, ScrH() 
    end,
    ["cr"] = function(sx, sy)
        return ScrW() - sx - spacing, ScrH() * .5 - sy * .5, ScrW(), ScrH() * .5 - sy * .5
    end,
    ["bl"] = function(sx, sy)
        return 0 + spacing, ScrH() - sy - spacing, -sx - spacing, ScrH()
    end,
    ["bc"] = function(sx, sy)
        return ScrW() * .5 - sx * .5, ScrH() - sy - spacing, ScrW() * .5 - sx * .5, ScrH()
    end,
    ["br"] = function(sx, sy)
        return ScrW() - sx - spacing, ScrH() - sy - spacing, ScrW(), ScrH()
    end
}
local TYPE_MAP = {
    [mvp.NOTIFICATION.INFO] = {
        color = mvp.colors.Blue,
        icon = Material("mvp/terminal/notifications/info.png", "smooth")
    },
    [mvp.NOTIFICATION.WARN] = {
        color = mvp.colors.Yellow,
        icon = Material("mvp/terminal/notifications/warn.png", "smooth")
    },
    [mvp.NOTIFICATION.ERROR] = {
        color = mvp.colors.Red,
        icon = Material("mvp/terminal/notifications/error.png", "smooth")
    },
    
    [mvp.NOTIFICATION.SUCCESS] = {
        color = mvp.colors.Green,
        icon = Material("mvp/terminal/notifications/success.png", "smooth")
    },
    [mvp.NOTIFICATION.FAIL] = {
        color = mvp.colors.Red,
        icon = Material("mvp/terminal/notifications/error.png", "smooth")
    }
}

function mvp.notification.ProccesQueue()
    local inQueue = #mvp.notification.list

    if (inQueue == 0) then
        return -- No notifications to show
    end

    if (inQueue == 1) then
        mvp.notification.currentNotification = mvp.notification.list[1]
        mvp.notification.currentNotification:Show()
    else
        if (IsValid(mvp.notification.currentNotification)) then
            return -- We are already showing a notification
        end

        mvp.notification.currentNotification = mvp.notification.list[1]
        mvp.notification.currentNotification:Show()
    end
end

function mvp.notification.Add( notificationType, title, text, duration )
    local useNotifications = mvp.config.Get("useNotifications", true)

    if (isstring(notificationType)) then
        notificationType = TYPE_MAP[notificationType]
    end
    local notificationData = TYPE_MAP[notificationType]
    local color = notificationData.color
    local icon = notificationData.icon

    if (not useNotifications) then
        local tag = mvp.config.Get("tag", "[Terminal]")

        return chat.AddText(mvp.colors.Accent, tag, " ", color, title, " ", mvp.colors.Text, text)
    end

    duration = duration or 5

    local notificationPosition = mvp.config.Get("notificationsPosition", "bc")
    local position = POSITION_MAP[notificationPosition]

    local notificationPanel = vgui.Create("DPanel")
    local sizeX, sizeY = mvp.ui.Scale(450), mvp.ui.Scale(100)

    surface.SetFont(mvp.q.Font(26, 600))
    local titleWidth, _ = surface.GetTextSize(title)
    titleWidth = titleWidth + iconSize + spacing * 3
    
    surface.SetFont(mvp.q.Font(21, 600))
    local textWidth, _ = surface.GetTextSize(text)
    textWidth = textWidth + iconSize + spacing * 3

    sizeX = math.max(titleWidth, textWidth, sizeX)
    
    notificationPanel:SetSize(sizeX, sizeY)

    local x, y, sx, sy = position(sizeX, sizeY)
    notificationPanel:SetPos(sx, sy)
    
    function notificationPanel:Paint(w, h)
        draw.RoundedBox(roundness, 0, 0, w, h, mvp.colors.Background)
        
        if (self.startTime) then
            local timePassed = CurTime() - self.startTime
            local progress = w * (timePassed / duration)

            draw.RoundedBox(roundness, 0, 0, progress, h, ColorAlpha(color, 5))
        end

        surface.SetDrawColor(color)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(spacing, h * .5 - iconSize * .5, iconSize, iconSize)

        draw.SimpleText(title, mvp.q.Font(26, 600), spacing + iconSize + spacing, h * .5 - 10, mvp.colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(text, mvp.q.Font(21, 400), spacing + iconSize + spacing, h * .5 + 10, mvp.colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    function notificationPanel:Show()
        self:MoveTo(x, y, 0.5, 0, 0.5, function(_, pnl)
            pnl.startTime = CurTime()
            self:MoveTo(sx, sy, 0.5, duration or 1, 0.5, function(_, pnl)
                pnl:Remove()
                table.remove(mvp.notification.list, 1)
                mvp.notification.ProccesQueue()
            end)
        end)
    end

    table.insert(mvp.notification.list, notificationPanel)
    mvp.notification.ProccesQueue()
end

net.Receive("mvp.notification", function()
    local type = net.ReadUInt(8)
    local title = net.ReadString()
    local text = net.ReadString()
    local duration = net.ReadUInt(8)

    mvp.notification.Add(type, title, text, duration)
end)