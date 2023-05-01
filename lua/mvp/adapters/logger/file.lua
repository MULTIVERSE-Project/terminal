local adapter = mvp.meta.logger:New()

adapter.logfilePath = 'mvp/logs/'
adapter.currentWorkingFile = nil

function adapter:Init()
    local currentTimestamp = os.date('%Y-%m-%d')
    local logFileName = 'log-' .. currentTimestamp

    if not file.Exists(self.logfilePath, 'DATA') then
        file.CreateDir(self.logfilePath)
    end

    if not file.Exists(self.logfilePath .. logFileName .. '.txt', 'DATA') then
        file.Write(self.logfilePath .. logFileName .. '.txt', 'This is a start of log file for ' .. currentTimestamp .. '\n')
    end
    self.currentWorkingFile = self.logfilePath .. logFileName .. '.txt'
end

function adapter:WriteToFile(message)
    if self.currentWorkingFile then
        file.Append(self.currentWorkingFile, message .. '\n')
    end
end

function adapter:SanitazeMessage(message)
    local sanitizedMessage = ''

    if type(message) == 'table' then
        for k, v in pairs(message) do
            if type(v) == 'table' then
                sanitizedMessage = sanitizedMessage .. ' [table]'
            else
                sanitizedMessage = sanitizedMessage .. tostring(v)
            end
        end
    else
        sanitizedMessage = tostring(message)
    end

    return sanitizedMessage
end

function adapter:Log(timestamp, level, ...)
    if not self.currentWorkingFile then
        self:Init()
    end

    local logTime = timestamp or os.date('%Y-%m-%d %H:%M:%S')

    local message = self:SanitazeMessage({...})

    local levelText = 'INFO'
    if level == mvp.LOG_ERROR then
        levelText = 'ERROR'
    elseif level == mvp.LOG_WARNING then
        levelText = 'WARNING'
    end

    if level == mvp.LOG_DEBUG then
        levelText = 'DEBUG'
        if mvp.DEBUG then
            self:WriteToFile('[' .. logTime .. '] ' .. '[' .. levelText .. '] ' .. message)
        end
    else
        self:WriteToFile('[' .. logTime .. '] ' .. '[' .. levelText .. '] ' .. message)
    end
end

return adapter