--- @classmod mvp.meta.package

mvp = mvp or {}
mvp.meta = mvp.meta or {}

mvp.meta.package = {}

mvp.meta.package.__proto = mvp.meta.package

mvp.meta.package.__proto.isPackage = true
mvp.meta.package.__proto.isLoaded = false

function mvp.meta.package:New()
    local o = table.Copy(self.__proto)

    setmetatable(o, self)
    o.__index = self

    local cwd = debug.getinfo(2, "S").short_src

    -- addons/mvp_terminal/lua/mvp/packages/{{cwd}}/sh_package.lua
    -- convert this regex to lua pattern addons\/[^\/]+\/lua\/mvp\/packages\/([^\/]+)\/sh_package\.lua
    local packageFolder = string.match(cwd, "addons/[^/]+/lua/mvp/packages/([^/]+)/sh_package%.lua")
    o:SetCWD(packageFolder)
    o:SetID(packageFolder)

    return o
end

--[[
    Getters and Setters for simple package information
]]--  
AccessorFunc(mvp.meta.package, "_id", "ID", FORCE_STRING)

mvp.meta.package.__proto._name = "Unnamed Package"
AccessorFunc(mvp.meta.package, "_name", "Name", FORCE_STRING)

mvp.meta.package.__proto._description = "Missing description"
AccessorFunc(mvp.meta.package, "_description", "Description", FORCE_STRING)

mvp.meta.package.__proto._author = "Unknown"
AccessorFunc(mvp.meta.package, "_author", "Author", FORCE_STRING)

mvp.meta.package.__proto._version = "0.0.0"
AccessorFunc(mvp.meta.package, "_version", "Version", FORCE_STRING)

mvp.meta.package.__proto._license = "Unknown"
AccessorFunc(mvp.meta.package, "_license", "License", FORCE_STRING)

AccessorFunc(mvp.meta.package, "_cwd", "CWD", FORCE_STRING)

--[[
    Meta functions
]]--
function mvp.meta.package:__tostring()
    return string.format("Package %s (%s)", self:GetName(), self:GetID())
end

function mvp.meta.package:__eq(other)
    return self:GetID() == other:GetID()
end

--[[
    Dependencies
]]--
mvp.meta.package.__proto._dependencies = {}
function mvp.meta.package:AddDependency(id)
    self._dependencies = self._dependencies or {}
    
    self._dependencies[#self._dependencies + 1] = id
end
function mvp.meta.package:GetDependencies()
    return self._dependencies
end

--[[
    Package functions
]]--
mvp.meta.package.__proto._files = {}
function mvp.meta.package:AddFile(path)
    local cwd = "packages/" .. self:GetCWD()
    local fullPath = cwd .. "/" .. path

    if not file.Exists(fullPath, "LUA") then
        error(string.format("File %s does not exist", fullPath))
    end

    self._files[#self._files + 1] = fullPath
end
function mvp.meta.package:AddFolder(path, recursive)
    local cwd = "packages/" .. self:GetCWD()
    local fullPath = cwd .. "/" .. path

    local files, folders = file.Find(fullPath .. "/*", "LUA")

    for _, file in ipairs(files) do
        self:AddFile(path .. "/" .. file)
    end

    if (recursive) then
        for _, folder in ipairs(folders) do
            self:AddFolder(path .. "/" .. folder, true)
        end
    end
end

--[[
    Configuration functions
]]--
function mvp.meta.package:AddConfigsFolder(path)
    if (not path) then
        path = "configs"
    end

    if (string.StartsWith(path, "/")) then
        path = string.sub(path, 2)
    end

    self:AddFolder(path, true)
end