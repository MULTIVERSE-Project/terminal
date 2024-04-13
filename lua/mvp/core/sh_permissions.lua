mvp = mvp or {}
mvp.permissions = mvp.permissions or {}

mvp.permissions.list = mvp.permissions.list or {}

function mvp.permissions.AddPermission(name, defaulAccess, description, sortOrder)
    mvp.utils.AssertType(name, mvp.type.string, "mvp.permissions.AddPermission", 1)
    mvp.utils.AssertType(defaulAccess, mvp.type.string, "mvp.permissions.AddPermission", 2)

    local permissionCAMI = {
        Name = name,
        Description = description or "This permission has no description",
        MinAccess = defaulAccess
    }

    local permissionInternal = {
        name = name,
        description = description or "This permission has no description",
        defaultAccess = defaulAccess,
        sortOrder = sortOrder or 99
    }

    CAMI.RegisterPrivilege(permissionCAMI)
    mvp.permissions.list[name] = permissionInternal
end

function mvp.permissions.Check(ply, permission)
    mvp.utils.AssertType(ply, mvp.type.player, "mvp.permissions.Check", 1)
    mvp.utils.AssertType(permission, mvp.type.string, "mvp.permissions.Check", 2)

    return CAMI.PlayerHasAccess(ply, permission)
end

function mvp.permissions.CheckAll(ply, permissions)
    mvp.utils.AssertType(ply, mvp.type.player, "mvp.permissions.CheckAll", 1)
    mvp.utils.AssertType(permissions, mvp.type.array, "mvp.permissions.CheckAll", 2)

    for _, permission in pairs(permissions) do
        if (not mvp.permissions.Check(ply, permission)) then
            return false
        end
    end

    return true
end

function mvp.permissions.CheckSome(ply, permissions)
    mvp.utils.AssertType(ply, mvp.type.player, "mvp.permissions.CheckSome", 1)
    mvp.utils.AssertType(permissions, mvp.type.array, "mvp.permissions.CheckSome", 2)

    for _, permission in pairs(permissions) do
        if (mvp.permissions.Check(ply, permission)) then
            return true
        end
    end

    return false
end

function mvp.permissions.GetPermission(name)
    mvp.utils.AssertType(name, mvp.type.string, "mvp.permissions.GetPermission", 1)

    return mvp.permissions.list[name]
end

function mvp.permissions.GetPermissionList()
    return mvp.permissions.list
end