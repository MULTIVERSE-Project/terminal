mvp = mvp or {}
mvp.permissions = mvp.permissions or {}

mvp.permissions.list = mvp.permissions.list or {}

function mvp.permissions.AddPermission(name, defaulAccess, description, sortOrder)
    local passed, nameErr = mvp.utils.Assert(name, "Cannot add permission: name is nil")

    if (not passed) then
        return mvp.logger.Log(mvp.LOG.ERROR, "Permissions", nameErr)
    end

    local passed, defaulAccessErr = mvp.utils.Assert(defaulAccess, "Setting default access to admin for permission " .. name .. " because it defaulAccess is nil")
    if (not passed) then
        mvp.logger.Log(mvp.LOG.WARNING, "Permissions", defaulAccessErr)
        defaulAccess = "admin"
    end

    local permissionCAMI = {
        Name = name,
        Description = description or "This permission has no description",
        MinAccess = defaulAccess
    }

    local permissionMVP = {
        name = name,
        description = description or "This permission has no description",
        defaultAccess = defaulAccess,
        sortOrder = sortOrder or 99
    }

    CAMI.RegisterPrivilege(permissionCAMI)
    mvp.permissions.list[name] = permissionMVP
end

function mvp.permissions.Check(ply, permission)
    local passed, plyErr = mvp.utils.Assert(ply, "Cannot check permission: ply is nil")
    if (not passed) then
        return mvp.logger.Log(mvp.LOG.ERROR, "Permissions", plyErr)
    end

    local passed, permissionErr = mvp.utils.Assert(permission, "Cannot check permission: permission is nil")
    if (not passed) then
        return mvp.logger.Log(mvp.LOG.ERROR, "Permissions", permissionErr)
    end

    return CAMI.PlayerHasAccess(ply, permission)
end

function mvp.permissions.CheckAll(ply, permissions)
    local passed, plyErr = mvp.utils.Assert(ply, "Cannot check permissions: ply is nil")
    if (not passed) then
        return mvp.logger.Log(mvp.LOG.ERROR, "Permissions", plyErr)
    end

    local passed, permissionsErr = mvp.utils.Assert(istable(permissions), "Cannot check permissions: permissions is nil or not a table")
    if (not passed) then
        return mvp.logger.Log(mvp.LOG.ERROR, "Permissions", permissionsErr)
    end

    for _, permission in pairs(permissions) do
        if (not mvp.permissions.Check(ply, permission)) then
            return false
        end
    end

    return true
end

function mvp.permissions.CheckSome(ply, permissions)
    local passed, plyErr = mvp.utils.Assert(ply, "Cannot check permissions: ply is nil")
    if (not passed) then
        return mvp.logger.Log(mvp.LOG.ERROR, "Permissions", plyErr)
    end

    local passed, permissionsErr = mvp.utils.Assert(istable(permissions), "Cannot check permissions: permissions is nil or not a table")
    if (not passed) then
        return mvp.logger.Log(mvp.LOG.ERROR, "Permissions", permissionsErr)
    end

    for _, permission in pairs(permissions) do
        if (mvp.permissions.Check(ply, permission)) then
            return true
        end
    end

    return false
end

function mvp.permissions.GetPermission(name)
    local passed, nameErr = mvp.utils.Assert(name, "Cannot get permission: name is nil")
    if (not passed) then
        return mvp.logger.Log(mvp.LOG.ERROR, "Permissions", nameErr)
    end

    return mvp.permissions.list[name]
end

function mvp.permissions.GetPermissionList()
    return mvp.permissions.list
end