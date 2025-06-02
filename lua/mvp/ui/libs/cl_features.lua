mvp.ui = mvp.ui or {}
mvp.ui.features = mvp.ui.features or {}

mvp.ui.features.list = mvp.ui.features.list or {}

function mvp.ui.features.Register(id, data)
    mvp.ui.features.list[id] = data
end
function mvp.ui.features.Get(id)
    return mvp.ui.features.list[id]
end

local hookList = {
    ["Think"] = true,
    ["OnMousePressed"] = true,
    ["OnMouseReleased"] = true,
    ["PerformLayout"] = true,
    ["OnCursorEntered"] = true,
    ["OnCursorExited"] = true,
}

function mvp.ui.features.Import(pnl, id)
    pnl.mvpFeatures = pnl.mvpFeatures or {}

    local feature = mvp.ui.features.Get(id)
    if (not feature) then
        error("Feature '" .. id .. "' does not exist.")
        return
    end

    if (pnl.mvpFeatures[id]) then return end

    local initFn = feature.Init
    for k, v in pairs(feature) do
        if (k == "Init") then
            continue
        end

        if (hookList[k]) then
            pnl:CreateEventHandler(k)
            pnl:On(k, v)
        else
            pnl[k] = v
        end
    end

    if (initFn) then
        initFn(pnl)
    end

    pnl.mvpFeatures[id] = true

    return true
end