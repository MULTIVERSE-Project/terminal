mvp.ui = mvp.ui or {}
mvp.ui.images = mvp.ui.images or {}
mvp.ui.images.cache = mvp.ui.images.cache or {}

function mvp.ui.images.Register(name, url)
    mvp.utils.AssertType(name, mvp.type.string, "mvp.ui.images.Register", 1)
    mvp.utils.AssertType(url, mvp.type.string, "mvp.ui.images.Register", 2)
    
    mvp.ui.images.cache[name] = url
end

function mvp.ui.images.Create(name, params)
    mvp.utils.AssertType(name, mvp.type.string, "mvp.ui.images.Create", 1)

    local url = mvp.ui.images.cache[name]
    local invalid = false

    if (not url) then
        invalid = true

        mvp.q.LogError("Web Images", "Attempted to create an image with an invalid name: " .. name)
    end

    local format = invalid and "_INVALID_IMAGE" or string.match(url, ".%w+$")
    assert(format, "Invalid image format for url " .. url .. " (name: " .. name .. ")")

    local image = mvp.meta.image:New()
    image:SetName(name)
    image:SetURL(url)
    image:SetFormat(format)
    image:SetParameters(params)

    if (not invalid) then
        image:Download()
    end

    return image
end

do
    local quickUrlCache = {}

    -- helper functions
    local function encodeUrl(url)
        return util.CRC(url)
    end

    function mvp.ui.images.Quick(url, params)
        mvp.utils.AssertType(url, mvp.type.string, "mvp.ui.images.Quick", 1)
        
        if (not quickUrlCache[url]) then
            quickUrlCache[url] = encodeUrl(url)
        end
        local uid = quickUrlCache[url]

        mvp.ui.images.Register(uid, url)

        return mvp.ui.images.Create(uid, params)
    end
end

do -- loading queue
    local basePath = "mvp/images/"
    local queue = {}
    local downloadRate = 1 / 5

    local downloadFailedCode = "Failed to download image %s (url: %s, code: %s)"
    local downloadFailedReason = "Failed to download image %s (url: %s, reason: %s)"
    local downloadFailedMissingMat = "Failed to load material for image %s after download (url: %s)"
    local errorDuringDownload = "An error occurred during the download of image %s (url: %s, error: %s)"

    if (not file.Exists(basePath, "DATA")) then
        file.CreateDir(basePath)
    end

    -- helper functions
    local function encodeUrl(url)
        return util.CRC(url)
    end

    local function loadMaterial(name, format, params)
        local path = basePath .. name .. format

        if (file.Exists(path, "DATA")) then
            local mat = Material("data/" .. path, params)

            if (mat:IsError()) then
                mvp.q.LogError("Web Images", "Failed to load material for image " .. name .. " (format: " .. format .. ")")
            else
                return mat
            end
        end
    end

    local function saveMaterial(name, format, data)
        local path = basePath .. name .. format

        file.Write(path, data)
    end

    local function downloadImage(imageObject)
        local proxy = mvp.config.Get("imagesProxy", "")
        
        local name = imageObject:GetName() .. "_" .. encodeUrl(imageObject:GetURL())
        local url = proxy .. imageObject:GetURL()
        local format = imageObject:GetFormat()
        local params = imageObject:GetParameters()

        local success, errorString = pcall(function()
            local mat = loadMaterial(name, format, params)

            if (mat) then
                imageObject:SetMaterial(mat)
            else
                http.Fetch(url, function(body, size, headers, code)
                    if (code > 200) then
                        mvp.q.LogWarn("Web Images", downloadFailedCode:format(name, url, code))

                        return
                    end

                    saveMaterial(name, format, body)

                    local mat = loadMaterial(name, format, params)
                    if (mat and imageObject) then
                        imageObject:SetMaterial(mat)
                    else
                        mvp.q.LogError("Web Images", downloadFailedMissingMat:format(name, url))
                    end
                end, function(reason)
                    mvp.q.LogError("Web Images", downloadFailedReason:format(name, url, reason))
                end)
            end
        end)

        if (not success) then
            mvp.q.LogError("Web Images", errorDuringDownload:format(name, url, errorString))
        end
    end

    timer.Create("mvp.ui.images.DownloadQueue", downloadRate, 0, function()
        local data = queue[1]

        if (data) then
            table.remove(queue, 1)
            downloadImage(data)
        end
    end)

    function mvp.ui.images.QueueDownload(imageObject)
        local mat = loadMaterial(imageObject:GetName() .. "_" .. encodeUrl(imageObject:GetURL()), imageObject:GetFormat(), imageObject:GetParameters())

        if (mat) then
            imageObject:SetMaterial(mat)
        else
            table.insert(queue, imageObject)
        end
    end
end

-- Test section
-- do 
--     mvp.ui.images.Register("test", "https://i.imgur.com/QRipy9l.png")

--     local testImageSmooth = mvp.ui.images.Create("test", "smooth mips")
--     local testImageSharp = mvp.ui.images.Create("test")
--     local testImageQuick = mvp.ui.images.Quick("https://i.imgur.com/QRipy9l.png")

--     hook.Add("HUDPaint", "mvp.ui.images.Test", function()
--         local size = 64

--         testImageSmooth:Draw(0, size, size, size)
--         testImageSharp:Draw(size, size, size, size)
--         testImageQuick:Draw(size * 2, size, size, size)
--     end)
-- end