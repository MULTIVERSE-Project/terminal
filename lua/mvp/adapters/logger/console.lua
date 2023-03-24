local adapter = mvp.meta.logger:New()

function adapter:Init()

end

function adapter:Log( timestamp, level, ... )
    local logTime = timestamp or os.date( '%Y-%m-%d %H:%M:%S' )
    local levelText, levelColor = 'INFO', mvp.BLUE

    if level == mvp.LOG_ERROR then
        levelText, levelColor = 'ERROR', mvp.RED
    elseif level == mvp.LOG_WARNING then
        levelText, levelColor = 'WARNING', mvp.YELLOW
    end

    if level == mvp.LOG_DEBUG then
        levelText, levelColor = 'DEBUG', mvp.GREEN
        if mvp.DEBUG then
            local args = {...}
            if args and #args > 0 then
                MsgC( mvp.BLUE, '[MVP | Terminal]', levelColor, '[', levelText, '] ', mvp.GRAY, '[', mvp.WHITE, logTime, mvp.GRAY, '] ', mvp.WHITE, unpack(args) )
            else
                MsgC( mvp.BLUE, '[MVP | Terminal]', levelColor, '[', levelText, '] ', mvp.GRAY, '[', mvp.WHITE, logTime, mvp.GRAY, '] ' )
            end
        end
    else
        local args = {...}
        if args and #args > 0 then
            MsgC( mvp.BLUE, '[MVP | Terminal]', levelColor, '[', levelText, '] ', mvp.GRAY, '[', mvp.WHITE, logTime, mvp.GRAY, '] ', mvp.WHITE, unpack(args) )
        else
            MsgC( mvp.BLUE, '[MVP | Terminal]', levelColor, '[', levelText, '] ', mvp.GRAY, '[', mvp.WHITE, logTime, mvp.GRAY, '] ' )
        end
    end

    MsgC('\n')
end

return adapter