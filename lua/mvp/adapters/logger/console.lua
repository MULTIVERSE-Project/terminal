local adapter = mvp.meta.logger:New()

function adapter:Log( level, ... )
    local logTime = os.date( '%Y-%m-%d %H:%M:%S' )
    local levelText, levelColor = 'INFO', mvp.BLUE

    if level == mvp.LOG_ERROR then
        levelText, levelColor = 'ERROR', mvp.RED
    elseif level == mvp.LOG_WARNING then
        levelText, levelColor = 'WARNING', mvp.YELLOW
    end

    if level == mvp.LOG_DEBUG then
        levelText, levelColor = 'DEBUG', mvp.GREEN
        if mvp.DEBUG then
            MsgC( mvp.BLUE, '[MVP | Terminal]', levelColor, '[', levelText, '] ', mvp.GRAY, '[', mvp.WHITE, logTime, mvp.GRAY, '] ', mvp.WHITE, ... )
        end
    else
        MsgC( mvp.BLUE, '[MVP | Terminal]', levelColor, '[', levelText, '] ', mvp.GRAY, '[', mvp.WHITE, logTime, mvp.GRAY, '] ', mvp.WHITE, ... )
    end

    
    MsgC('\n')
end

return adapter