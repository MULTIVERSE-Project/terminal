mvp = mvp or {}
mvp.package = mvp.package or {}
mvp.package.list = mvp.package.list or {}
mvp.package.lookup = mvp.package.lookup or {}

--- Registers a package
-- This function registers a package and loads all files that are specified in the package.
-- @tparam mvp.meta.package The package to register
function mvp.package.Register(package)
    local id = package:GetID()

    if (mvp.package.list[id]) then
        mvp.logger.Log(mvp.LOG.WARN, "Packages", "Package '" .. id .. "' already registered! Overwriting...")
        mvp.logger.Log(mvp.LOG.WARN, "Packages", "This is probably a bug! Since this should not happen outside of development!")

        mvp.logger.Log(mvp.LOG.DEBUG, nil, "ID: " .. id)
        mvp.logger.Log(mvp.LOG.DEBUG, nil, "Original CWD: " .. mvp.package.list[id]:GetCWD())
        mvp.logger.Log(mvp.LOG.DEBUG, nil, "New CWD: " .. package:GetCWD())

        mvp.package.list[id] = nil
    end

    mvp.package.list[id] = package

    if (#package._files > 0) then
        for _, file in ipairs(package._files) do
            mvp.loader.LoadFile(file)
        end
    end

    -- @todo: add proper dependency handling
    mvp.logger.Log(mvp.LOG.INFO, "Packages", "Loaded package '" .. id .. "@" .. package:GetVersion() .. "'")
    hook.Run("mvp.package.Registered", package)
end

--- Gets a package by its ID
-- This function returns a package by its ID. If not ID is specified, it will try to auto-find the package.
-- Auto-finding the package is only possible if the function is called from a file that is located in the package's folder.
-- If package ID differs from the folder name, you can add a lookup value with `mvp.package.AddLookupValue`.
-- If the package could not be found, an error will be thrown.
-- @tparam[opt] string id The ID of the package
-- @treturn mvp.meta.package The package
function mvp.package.Get(id)
    if (not id) then
        local cwd = debug.getinfo(2, "S").short_src
        local packageFolder = string.match(cwd, "addons/[^/]+/lua/mvp/packages/([^/]+)/[^/]+")
        
        if (mvp.package.lookup[packageFolder]) then
            packageFolder = mvp.package.lookup[packageFolder]
        end

        if (not packageFolder or not mvp.package.list[packageFolder]) then
            mvp.logger.Log(mvp.LOG.ERROR, "Could not auto-find package! Please specify the package ID manually!\n" .. cwd)
        end

        id = packageFolder
    end

    return mvp.package.list[id]
end

--- Adds a lookup value
-- This function adds a lookup value for a package.
-- This is useful if the package ID differs from the folder name.
-- @tparam string original The original folder name
-- @tparam string lookFor The package ID
function mvp.package.AddLookupValue(original, lookFor)
    if (mvp.package.lookup[original]) then

        mvp.logger.Log(mvp.LOG.WARN, "Packages", "Lookup value '" .. original .. "' already registered! Overwriting...")
        mvp.logger.Log(mvp.LOG.WARN, "Packages", "This is probably a bug! Since this should not happen outside of development!")

        mvp.logger.Log(mvp.LOG.DEBUG, nil, "Key: " .. original)
        mvp.logger.Log(mvp.LOG.DEBUG, nil, "Original: " .. mvp.package.lookup[original])
        mvp.logger.Log(mvp.LOG.DEBUG, nil, "New: " .. lookFor)

        mvp.package.lookup[original] = nil
    end

    mvp.package.lookup[original] = lookFor
end

function mvp.package.Init()
    mvp.logger.Log(mvp.LOG.INFO, "Packages", "Initializing packages...")

    mvp.loader.LoadFolder("packages", true)

    mvp.logger.Log(mvp.LOG.INFO, "Packages", "Initialized packages!")
end