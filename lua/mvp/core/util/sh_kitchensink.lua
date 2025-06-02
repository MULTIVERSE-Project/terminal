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

function mvp.utils.Hash(val)
    local hash = 0
    local len = string.len(val)

    for i = 1, len do
        hash = string.byte(val, i) + bit.lshift(hash, 6) + bit.lshift(hash, 16) - hash
    end

    return hash
end

function mvp.utils.UUID(length)
    local template = string.rep("x", length or 32, "")
    math.randomseed(SysTime())

    return string.gsub(template, "x", function(c)
        local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format("%x", v)
    end)
end

function mvp.utils.Assert(value, funcName, argNum)
    assert(value, string.format("bad argument #%i to \"%s\" (got nil)", argNum, funcName))
end

function mvp.utils.AssertNamed(value, name, funcName, argNum)
    assert(value, string.format("bad argument #%i to \"%s\" (got nil for %s)", argNum, funcName, name))
end

function mvp.utils.AssertType(value, expected, funcName, argNum)
    local valueType = mvp.types.GetTypeFromValue(value)

    assert(valueType == expected, string.format("bad argument #%i to \"%s\" (expected %s, got %s)", argNum, funcName, mvp.type[expected], mvp.type[valueType]))
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

function mvp.utils.DrawEntityDisplay(ent, text, description, displayUse)
    local pos = ent:GetPos()
    local ang = ent:GetAngles()
    local drawAngles = ent:GetAngles()

    drawAngles:RotateAroundAxis(drawAngles:Forward(), 90)
    drawAngles:RotateAroundAxis(drawAngles:Right(), -90)

    local OBBMaxs = ent:OBBMaxs()
    pos = pos + ang:Up() * 64

    if (ent:WorldToLocal(pos).z < OBBMaxs.z) then
        pos = pos + ang:Forward() * OBBMaxs.x
    end

    cam.Start3D2D(pos, drawAngles, 0.1)        
        surface.SetFont(mvp.q.Font(48, 800))
        local textWidth, textHeight = surface.GetTextSize(text)

        surface.SetFont(mvp.q.Font(32, 500))
        local descWidth, descHeight = surface.GetTextSize(description)

        local width = math.max(textWidth, descWidth)
        local height = textHeight + descHeight

        local useText = mvp.q.Lang("general.use", string.upper(input.LookupBinding("+use")))

        if (displayUse) then
            surface.SetFont(mvp.q.Font(24, 500))
            local useWidth, useHeight = surface.GetTextSize(useText)

            width = math.max(width, useWidth)
            height = height + useHeight + 5
        end

        draw.RoundedBox(mvp.ui.ScaleWithFactor(16), -width * .5 - 10, -height * .5 - 10, width + 20, height + 20, Color(0, 0, 0, 200))

        draw.SimpleText(text, mvp.q.Font(48, 800), 0, -height * .5, mvp.colors.Accent, TEXT_ALIGN_CENTER)
        draw.SimpleText(description, mvp.q.Font(32, 600), 0, -height * .5 + textHeight, mvp.colors.Text, TEXT_ALIGN_CENTER)

        if (displayUse) then
            mvp.utils.DrawTextWithButtons(useText, mvp.q.Font(27, 500), 0, -height * .5 + textHeight + descHeight + 5, ColorAlpha(mvp.colors.Text, 200), TEXT_ALIGN_CENTER)
        end
    cam.End3D2D()
end

function mvp.utils.DrawTextWithButtons(text, font, x, y, color, alignX, alignY)
    local buttons = {} -- {{btn:...}}

    -- split the text into buttons and text
    for btn in string.gmatch(text, "{{btn:(.-)}}") do
        table.insert(buttons, btn)
    end
    local text = string.Explode("{{btn:(.-)}}", text, true)

    local textWidth, textHeight = 0, 0
    surface.SetFont(font)
    for i, v in ipairs(text) do
        local tw, th = surface.GetTextSize(v)

        textWidth = textWidth + tw
        textHeight = math.max(textHeight, th)

        if (buttons[i]) then
            local bw, bh = th * 1.2, th * 1.2

            textWidth = textWidth + bw
            textHeight = math.max(textHeight, bh)
        end
    end

    local x, y = x, y
    if (alignX == TEXT_ALIGN_CENTER) then
        x = x - textWidth * .5
    elseif (alignX == TEXT_ALIGN_RIGHT) then
        x = x - textWidth
    end

    if (alignY == TEXT_ALIGN_CENTER) then
        y = y - textHeight * .5
    elseif (alignY == TEXT_ALIGN_BOTTOM) then
        y = y - textHeight
    end

    local currentX = x

    for i, v in ipairs(text) do
        local tw, th = surface.GetTextSize(v)

        draw.SimpleText(v, font, currentX, y, color)
        currentX = currentX + tw

        if (buttons[i]) then
            local btw = surface.GetTextSize(buttons[i])
            local bw, bh = math.max(th * 1.2, btw + 10), th * 1.2

            local col = ColorAlpha(mvp.colors.Text , color.a)

            local y = y - 2

            -- draw.RoundedBox(0, currentX, y, bw, bh, ColorAlpha(mvp.colors.Accent, color.a))
            mvp.ui.DrawOutlinedRoundedRect(8, currentX, y, bw, bh, 4, col)
            draw.SimpleText(buttons[i], font, currentX - .5 + bw * .5, y + textHeight * .5 - 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            currentX = currentX + bw
        end        
    end

    return textWidth, textHeight
end

function mvp.utils.ChatPrint(...)
    local args = {...}
    
    -- for i, v in ipairs(args) do
    --     if (mvp.utils.IsColor(v)) then
    --         args[i] = mvp.utils.ColorToFormattedString(v)
    --     end
    -- end

    -- find all color codes and replace them with the color

    local text = {}
    for _, arg in ipairs(args) do
        if (mvp.utils.IsColor(arg)) then
            table.insert(text, mvp.utils.ColorToFormattedString(arg))
        else
            table.insert(text, arg)
        end
    end
    text = table.concat(text, "")

    local colors = {}
    for col in string.gmatch(text, "{{color:(.-)}}") do
        if (mvp.colors[col]) then
            col = mvp.utils.ColorToFormattedString(mvp.colors[col])
        end

        table.insert(colors, col)
    end
    text = string.Explode("{{color:(.-)}}", text, true)

    local chatText = {}

    for i, v in ipairs(text) do
        table.insert(chatText, v)

        if (colors[i]) then
            local r, g, b, a = string.match(colors[i], "(%d+),(%d+),(%d+),(%d+)")
            table.insert(chatText, Color(r, g, b, a))
        end
    end

    chat.AddText(unpack(chatText))
end

function mvp.utils.ColorToFormattedString(col, onlyNumbers)
    if (onlyNumbers) then
        return col.r .. "," .. col.g .. "," .. col.b .. "," .. col.a
    end

    return "{{color:" .. col.r .. "," .. col.g .. "," .. col.b .. "," .. col.a .. "}}"
end