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

local noOp = function() end

local msgC = MsgC
local mvpLog = mvp.LOG
function LOGGER:Log(level, caller, ...)
    if (level == mvpLog.DEBUG) then
        if (not mvp.config or not mvp.config.Get("debug", false)) then
            return 
        end
    end

    local color = LEVEL_TO_COLOR_MAP[level] or COLOR_WHITE

    if (caller) then
        msgC(
            color, "▌ ", mvpLog[level], "\t",
            COLOR_YELLOW, "[", caller, "] ",
            COLOR_WHITE, ...,
            "\n"
        )
        return 
    end
    
    msgC(
        color, "▌ ", mvpLog[level], "\t",
        COLOR_WHITE, ...,
        "\n"
    )
end

function LOGGER:LogOld(level, caller, ...)
    local shouldDisplayDebug = mvp.config and mvp.config.Get("debug", false)
    if (not shouldDisplayDebug and level == mvp.LOG.DEBUG) then
        return
    end

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

local function testNew()
    LOGGER:Log(mvp.LOG.INFO, "TestCaller", "This is an info message")
end
local function testNewNoCaller()
    LOGGER:Log(mvp.LOG.INFO, nil, "This is an info message")
end
local function testOld()
    LOGGER:LogOld(mvp.LOG.INFO, "TestCaller", "This is an info message")
end
local function testOldNoCaller()
    LOGGER:LogOld(mvp.LOG.INFO, nil, "This is an info message")
end

concommand.Add("mvp_log_test", function()
    LuctusCompareOften(10, 0.1, 5000, {
        {"new implementation, with caller", testNew},
        {"new implementation, without caller", testNewNoCaller},

        {"old implementation, with caller", testOld},
        {"old implementation, without caller", testOldNoCaller}
    })
end)