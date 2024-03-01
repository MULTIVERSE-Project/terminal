--- @module mvp.types

mvp = mvp or {}
mvp.types = mvp.types or {}

--- Sanitizes a value to a specific type
-- @tparam mvp.type type The type to sanitize to
-- @param input The value to sanitize
-- @treturn any The sanitized value
function mvp.types.SanitizeType(type, input)
    if ( type == mvp.type.string ) then return tostring(input) end
    if ( type == mvp.type.text ) then return tostring(input) end
    if ( type == mvp.type.number ) then return tonumber(input) end
    if ( type == mvp.type.bool ) then return tobool(input) end
    if ( type == mvp.type.color ) then return istable(input) and Color(input.r or 255, input.g or 255, input.b or 255, input.a or 255) or color_white end
    if ( type == mvp.type.vector ) then return isvector(input) and input or vector_origin end
    if ( type == mvp.type.array ) then return istable(input) and input or {} end

    error("Attemped to sanitaze " .. ( mvp.type[type] and ("invalid type" .. mvp.type[type] ) or ("unknown type" .. type) ))
end

local typeMap = {
    ["string"] = mvp.type.string,
    ["number"] = mvp.type.number,
    ["boolean"] = mvp.type.bool,
    ["vector"] = mvp.type.vector,
    ["table"] = mvp.type.array,

    ["Player"] = mvp.type.player
}

local tableMap = {
    [mvp.type.color] = function(input)
        return mvp.utils.IsColor(input)
    end,
}

function mvp.types.GetTypeFromValue(input)
    local inputType = type(input)

    if typeMap[inputType] then return typeMap[inputType] end

    if (istable(input)) then
        for typeName, func in pairs(tableMap) do
            if func(input) then return typeName end
        end
    end

    return nil -- unknown type
end