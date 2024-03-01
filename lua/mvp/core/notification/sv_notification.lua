mvp = mvp or {}
mvp.notification = mvp.notification or {}

util.AddNetworkString("mvp.notification")

function mvp.notification.Send(target, notificationType, title, text, duration)
    net.Start("mvp.notification")
        net.WriteUInt(notificationType, 8)
        net.WriteString(title)
        net.WriteString(text)
        net.WriteUInt(duration or 5, 8)
    net.Send(target)
end

function mvp.notification.SendAll(notificationType, title, text, duration)
    net.Start("mvp.notification")
        net.WriteUInt(notificationType, 8)
        net.WriteString(title)
        net.WriteString(text)
        net.WriteUInt(duration or 5, 8)
    net.Broadcast()
end