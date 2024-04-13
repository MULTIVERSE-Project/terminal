mvp = mvp or {}
mvp.package = mvp.package or {}
mvp.package.list = mvp.package.list or {}
mvp.package.lookup = mvp.package.lookup or {}

mvp.package.dependenciesResolverList = mvp.package.dependenciesResolverList or {}

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

    if (table.Count(package:GetDependencies()) == 0) then
        mvp.package.LoadPackage(package)
        return
    end

    -- resolve dependencies
    local shouldLoadImmediately = true
    for _, depId in ipairs(package:GetDependencies()) do
        mvp.package.dependenciesResolverList[id] = mvp.package.dependenciesResolverList[id] or {}

        if (mvp.package.list[depId] and mvp.package.list[depId].isLoaded) then
            mvp.package.dependenciesResolverList[id][depId] = true -- dependency is loaded earlier
        else
            mvp.package.dependenciesResolverList[id][depId] = false -- dependency is not loaded yet

            shouldLoadImmediately = false
        end
    end

    if (shouldLoadImmediately) then
        mvp.package.LoadPackage(package)
    end
end

function mvp.package.LoadPackage(package)
    for _, file in ipairs(package._files) do
        mvp.loader.LoadFile(file)
    end

    package.isLoaded = true

    mvp.logger.Log(mvp.LOG.INFO, "Packages", "Loaded package '" .. package:GetID() .. "@" .. package:GetVersion() .. "'")
    hook.Run("mvp.package.Registered", package)
end

hook.Add("mvp.package.Registered", "mvp.package.DependenceisResolver", function(package)
    local possibleDepId = package:GetID()

    local packagesInNeed = {}

    for id, deps in pairs(mvp.package.dependenciesResolverList) do
        if (deps[possibleDepId] == false) then
            table.insert(packagesInNeed, id)
        end
    end

    if (#packagesInNeed == 0) then
        return
    end

    for _, id in ipairs(packagesInNeed) do
        local package = mvp.package.list[id]

        if (not package) then
            mvp.logger.Log(mvp.LOG.ERROR, "Packages", "Could not resolve dependencies for package '" .. id .. "'! Package not found!")
            return
        end

        local allDepsLoaded = true

        for _, depId in ipairs(package:GetDependencies()) do
            if (not mvp.package.list[depId]) then
                allDepsLoaded = false
                break
            end

            if (not mvp.package.list[depId].isLoaded) then
                allDepsLoaded = false
                break
            end
        end

        if (allDepsLoaded) then
            mvp.package.dependenciesResolverList[id] = nil
            mvp.package.LoadPackage(package)
        end
    end
end)

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
        local packageFolder = string.match(cwd, "mvp/packages/([^/]+)/[^/]+")
        
        if (mvp.package.lookup[packageFolder]) then
            packageFolder = mvp.package.lookup[packageFolder]
        end

        if (not packageFolder or not mvp.package.list[packageFolder]) then
            mvp.logger.Log(mvp.LOG.ERROR, "Could not auto-find package! Please specify the package ID manually!\n" .. cwd)
        end

        id = packageFolder
    end

    local package = mvp.package.list[id]
    if (not package) then
        package = mvp.package.list[mvp.package.lookup[id]]
    end

    return package
end

--- Gets is package is registered
-- This function returns if a package is registered.
-- @tparam string id The ID of the package
-- @treturn bool If the package is registered
function mvp.package.IsRegistered(id)
    return mvp.package.list[id] and true or false
end

--- Gets is package is loaded
-- This function returns if a package is loaded.
-- @tparam string id The ID of the package
-- @treturn bool If the package is loaded
function mvp.package.IsLoaded(id)
    return mvp.package.list[id] and mvp.package.list[id].isLoaded or false
end

--- Gets all registered packages
-- This function returns all registered packages.
-- @treturn table The packages
function mvp.package.GetAll()
    return mvp.package.list
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
    mvp.logger.Log(mvp.LOG.INFO, "Packages", "Loading packages...")

    local _, folders = file.Find( mvp.loader.relativePath .. "packages/*", "LUA")

    for k, v in ipairs(folders) do
        local files = file.Find(mvp.loader.relativePath .. "packages/" .. v .. "/*.lua", "LUA")

        for _, v2 in pairs(files) do
            if (v2 == "sh_package.lua") then
                mvp.loader.LoadFile("packages/" .. v .. "/" .. v2)
            end
        end
    end

    for k, v in pairs(mvp.package.dependenciesResolverList) do
        local missingDeps = {}

        for depId, isLoaded in pairs(v) do
            if (not isLoaded) then
                table.insert(missingDeps, depId)
            end
        end

        mvp.q.LogFatal("Packages", "Could not resolve dependencies for package '" .. k .. "'! Missing dependencies: " .. table.concat(missingDeps, ", ") .. "!")
    end

    mvp.logger.Log(mvp.LOG.INFO, "Packages", "Loading packages!")
end