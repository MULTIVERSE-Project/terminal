mvp = mvp or {}
mvp.meta.command = mvp.meta.command or {}

mvp.meta.command.__proto = mvp.meta.command

mvp.meta.command.__proto._name = "Unnamed"
AccessorFunc(mvp.meta.command, "_name", "Name")

mvp.meta.command.__proto._description = "No description provided."
AccessorFunc(mvp.meta.command, "_description", "Description")

mvp.meta.command.__proto._id = "unnamed_command"
AccessorFunc(mvp.meta.command, "_id", "ID")

function mvp.meta.command:New()
    local o = table.Copy(mvp.meta.command.__proto)

    setmetatable(o, mvp.meta.command)
    o.__index = self

    return o
end

mvp.meta.command.__proto._permissions = {}
function mvp.meta.command:SetPermissions(permissions)
    self._permissions = permissions
end

function mvp.meta.command:CanRun(ply)
    if (#self._permissions == 0) then
        return true
    end
    
    return mvp.permissions.CheckAll(ply, self._permissions)
end

function mvp.meta.command:Run(ply, args)
    if not self:CanRun(ply) then
        mvp.q.NotifyError(mvp.q.Lang("general.command_x", self._name), mvp.q.Lang("general.no_permission"), nil, ply)
        
        return ""
    end

    return self:Execute(ply, args)
end

function mvp.meta.command:Execute(ply, args)
    error("Command has no execute function.")
end