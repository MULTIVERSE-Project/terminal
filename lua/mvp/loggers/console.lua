local LOGGER = mvp.meta.logger:New()

function LOGGER:Init()
    -- not needed
end

local LEVEL_TO_COLOR_MAP = {
    [mvp.LOG.INFO] = Color(0, 174, 255),
    [mvp.LOG.WARN] = Color(255, 255, 0),
    [mvp.LOG.ERROR] = Color(255, 0, 0),
    [mvp.LOG.FATAL] = Color(174, 0, 255),

    [mvp.LOG.DEBUG] = Color(4, 0, 255),
}

function LOGGER:Log(level, caller, ...)
    local color = LEVEL_TO_COLOR_MAP[level] or Color(255, 255, 255)

    local msg = {}

    msg[#msg + 1] = color
    msg[#msg + 1] = "▌ "
    msg[#msg + 1] = mvp.LOG[level]
    msg[#msg + 1] = "\t"
    msg[#msg + 1] = Color(255, 255, 255)
    
    if (caller) then
        msg[#msg + 1] = "["
        msg[#msg + 1] = Color(255, 255, 0)
        msg[#msg + 1] = caller
        msg[#msg + 1] = Color(255, 255, 255)
        msg[#msg + 1] = "] "
    end

    table.Add(msg, {...})

    MsgC(unpack(msg))
    Msg("\n")
end

mvp.logger.Register(LOGGER)