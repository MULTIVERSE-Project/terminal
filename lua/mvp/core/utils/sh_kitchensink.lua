mvp = mvp or {}
mvp.utils = mvp.utils or {}

function mvp.utils.IsSteamID(value)
    if (value == nil) then return false end

    return string.match(value, "^STEAM_%d:%d:%d+$") ~= nil
end

function mvp.utils.IsSteamID64(value)
    if (value == nil) then return false end

    return string.match(value, "^[0-9]+$") ~= nil
end

function mvp.utils.IsColor(color)
    return type(color) == "table" and color.r and color.g and color.b and color.a
end

function mvp.utils.UUID(length)
    local template = string.rep("x", length or 32, "")
    math.randomseed(SysTime())

    return string.gsub(template, "x", function(c)
        local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format("%x", v)
    end)
end

function mvp.utils.Assert(condition, message)
    if (condition == nil) then
        mvp.logger.Log(mvp.LOG.ERROR, nil, "Assertion failed: ", message)

        error(message, 2) 

        return false, message
    end

    return true, condition
end

function mvp.utils.GetTrace()
    local level = 2
    local trace = "Traceback:\n"

    while (true) do
        local info = debug.getinfo(level, "Sln")
        if (not info) then break end

        if (info.what == "C") then
            trace = trace .. string.format( "\t\t%i: C function\t\"%s\"\n", level - 1, info.name )
        else
            trace = trace .. string.format( "\t\t%i: Line %d\t\"%s\"\t\t%s\n", level - 1, info.currentline, info.name, info.short_src )
        end

        level = level + 1
    end

    return trace
end

function mvp.utils.ExtractCWD(folder)
    mvp.utils.Assert(folder, "Folder cannot be nil")
    
    local cwd = debug.getinfo(2, "S").short_src
    local c = string.match(cwd, "addons/[^/]+/lua/mvp/" .. folder .. "/([^/]+)/[^/]+")

    return c
end

local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub('.', function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return '\n' .. char
        end

        return char
    end)

    return text, totalWidth
end

function mvp.utils.WrapText(text, font, maxWidth)
    local totalWidth = 0
    local totalHeight = 0

    surface.SetFont(font)

    local spaceWidth, spaceHeight = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                totalWidth = 0
                
            end

            if char == "\n" then
                totalHeight = totalHeight + spaceHeight
            end

            local wordlen = surface.GetTextSize(word)
            totalWidth = totalWidth + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= maxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
                totalWidth = splitPoint

                totalHeight = totalHeight + spaceHeight

                return splitWord
            elseif totalWidth < maxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                totalWidth = wordlen - spaceWidth
                totalHeight = totalHeight + spaceHeight

                return '\n' .. string.sub(word, 2)
            end

            totalWidth = wordlen
            totalHeight = totalHeight + spaceHeight
            return '\n' .. word
        end)

    return text, totalHeight
end