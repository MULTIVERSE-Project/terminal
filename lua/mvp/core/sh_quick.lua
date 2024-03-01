mvp = mvp or {}
mvp.q = mvp.q or {}

local weightToName = {
    [100] = "Proxima Nova Th",
    [200] = "Proxima Nova Lt",
    [300] = "Proxima Nova Lt",
    [400] = "Proxima Nova Rg",
    [500] = "Proxima Nova Rg",
    [600] = "Proxima Nova Semibold",
    [700] = "Proxima Nova Bold",
    [800] = "Proxima Nova Extrabold",
    [900] = "Proxima Nova Bl"
}

function mvp.q.Font(size, weight)
    return mvp.fonts.Get(size, weightToName[weight] or "Proxima Nova Rg", weight)
end

function mvp.q.Lang(key, ...)
    return mvp.language.GetPhrase(key, ...)
end
function mvp.q.LangFallback(key, fallback, ...)
    local phrase = mvp.language.GetPhrase(key, ...)

    if (string.StartsWith(phrase, "notfound#")) then
        return string.format(fallback, ...)
    end

    return phrase
end

function mvp.q.Notify(type, title, text, duration, target)
    if (SERVER) then
        if (target ~= nil) then
            mvp.notification.Send(target, type, title, text, duration)
        else
            mvp.notification.SendAll(type, title, text, duration)
        end
    else
        mvp.notification.Add(type, title, text, duration)
    end
end
function mvp.q.NotifyInfo(title, text, duration, target)
    mvp.q.Notify(mvp.NOTIFICATION.INFO, title, text, duration, target)
end
function mvp.q.NotifyWarn(title, text, duration, target)
    mvp.q.Notify(mvp.NOTIFICATION.WARN, title, text, duration, target)
end
function mvp.q.NotifyError(title, text, duration, target)
    mvp.q.Notify(mvp.NOTIFICATION.ERROR, title, text, duration, target)
end
function mvp.q.NotifySuccess(title, text, duration, target)
    mvp.q.Notify(mvp.NOTIFICATION.SUCCESS, title, text, duration, target)
end
function mvp.q.NotifyFail(title, text, duration, target)
    mvp.q.Notify(mvp.NOTIFICATION.FAIL, title, text, duration, target)
end

function mvp.q.LogInfo(...)
    mvp.logger.Log(mvp.LOG.INFO, ...)
end
function mvp.q.LogWarn(...)
    mvp.logger.Log(mvp.LOG.WARN, ...)
end
function mvp.q.LogError(...)
    mvp.logger.Log(mvp.LOG.ERROR, ...)
end
function mvp.q.LogDebug(...)
    mvp.logger.Log(mvp.LOG.DEBUG, ...)
end
function mvp.q.LogFatal(...)
    mvp.logger.Log(mvp.LOG.FATAL, ...)
end

