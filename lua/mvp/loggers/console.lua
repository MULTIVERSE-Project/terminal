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

local COLOR_WHITE = Color(255, 255, 255)
local COLOR_YELLOW = Color(255, 255, 0)

function LOGGER:Log(level, caller, ...)
    local shouldDisplayDebug = mvp.config and mvp.config.Get("debug", false)
    if (not shouldDisplayDebug and level == mvp.LOG.DEBUG) then
        return
    end

    local color = LEVEL_TO_COLOR_MAP[level] or COLOR_WHITE

    MsgC(
        color, "▌ ", mvp.LOG[level], "\t",
        COLOR_YELLOW, caller and ("[" .. caller .. "] ") or "",
        COLOR_WHITE, ...,
        "\n"
    )
end

mvp.logger.Register(LOGGER)