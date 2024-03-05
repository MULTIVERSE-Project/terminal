mvp = mvp or {}
mvp.language = mvp.language or {}

mvp.language.list = mvp.language.list or {}
mvp.language.codes = mvp.language.codes or {}

local LANGUAGE_DEFAULT_FALLBACK = "en"
local LANGUAGE_CODES_URL = ""

function mvp.language.Register(id, langTable)
    if (not mvp.language.list[id]) then
        mvp.language.list[id] = langTable

        mvp.q.LogInfo("Language", "Registered new language " .. id)

        return mvp.language.list[id]
    end

    local storedLanguage = mvp.language.list[id]

    for k, v in pairs(langTable) do
        storedLanguage[k] = v
    end

    mvp.language.list[id] = storedLanguage

    return mvp.language.list[id]
end

function mvp.language.Get(id)
    return mvp.language.list[id]
end

function mvp.language.GetPhrase(id, ...)
    local lang = mvp.language.list[mvp.config.Get("language", LANGUAGE_DEFAULT_FALLBACK)]
    local phrase = lang[id]

    if (not phrase) then        
        lang = mvp.language.list[LANGUAGE_DEFAULT_FALLBACK]
        phrase = lang[id]

        if not phrase then
            return "notfound#" .. id
        end

        mvp.q.LogDebug("Language", "Phrase " .. id .. " not found in " .. mvp.config.Get("language", LANGUAGE_DEFAULT_FALLBACK) .. " falling back to " .. LANGUAGE_DEFAULT_FALLBACK)
    end

    if (type(phrase) == "function") then
        return phrase(...)
    else
        -- replace {{lang:(.*)}} with the language phrase
        phrase = string.gsub(phrase, "{{lang:(.-)}}", function(match)
            return mvp.language.GetPhrase(match)
        end)
    end

    return string.format(phrase, ...)
end

function mvp.language.LoadFromFolder(path)
    mvp.loader.LoadFolder(path, false, true)
end

--[[
    Language codes
]]--
function mvp.language.FetchCodes()
    http.Fetch(LANGUAGE_CODES_URL, function(body)
        local data = util.JSONToTable(body)
        if not data then return end

        mvp.language.codes = data

        mvp.logger.Log(mvp.LOG.DEBUG, "Language", "Fetched language " .. table.Count(data) .. " codes")
    end)
end
function mvp.language.GetCode(id)
    return mvp.language.codes[id]
end
function mvp.language.GetCodes()
    return mvp.language.codes
end

function mvp.language.Init()
    -- mvp.language.FetchCodes()
    mvp.q.LogInfo("Language", "Loading languages...")

    mvp.language.LoadFromFolder("mvp/languages/")

    mvp.q.LogInfo("Language", "Loaded languages!")
end