mvp = mvp or {}
mvp.ui = mvp.ui or {}
mvp.ui.g = mvp.ui.g or {}

mvp.ui.g.traits = mvp.ui.g.traits or {}
mvp.ui.g.funcs = mvp.ui.g.funcs or {}

function mvp.ui.g.Register(name, meta, parent)
    mvp.ui.g.Extend(meta)
    
    vgui.Register(name, meta, parent)
end

function mvp.ui.g.RegisterFunc(name, fn)
    mvp.ui.g.funcs[name] = fn
end
function mvp.ui.g.GetFunc(name)
    return mvp.ui.g.funcs[name]
end

function mvp.ui.g.RegisterTrait(name, trait)
    mvp.ui.g.traits[name] = trait
end
function mvp.ui.g.GetTrait(name)
    return mvp.ui.g.traits[name]
end

local traitHooksList = {
    ["Think"] = true,
    ["OnMousePressed"] = true,
    ["OnMouseReleased"] = true,
    ["PerformLayout"] = true,
    ["OnCursorEntered"] = true,
    ["OnCursorExited"] = true
}

function mvp.ui.g.ImportTrait(panel, id)
    panel.mvpTraits = panel.mvpTraits or {}

    local data = mvp.ui.g.GetTrait(id)
    if (not data) then return false end

    if (panel.mvpTraits[id]) then return false end

    local initFunc = data.Init

    for k, v in pairs(data) do
        if (k == "Init") then
            continue
        end

        if (traitHooksList[k]) then
            mvp.ui.g.InjectEventHandler(panel, k)
            mvp.ui.g.AddEvent(panel, k, v)
        else
            panel[k] = v
        end
    end

    if (initFunc) then
        initFunc(panel)
    end

    panel.mvpTraits[id] = true

    return true
end

function mvp.ui.g.Extend(pnl)
    for name, fn in pairs(mvp.ui.g.funcs) do
        pnl[name] = fn
    end
end

function mvp.ui.g.AddEvent(pnl, name, func)
    pnl.mvpEvents = pnl.mvpEvents or {}
    pnl.mvpEvents[name] = pnl.mvpEvents[name] or {
        count = 0,
    }

    local events = pnl.mvpEvents[name]
    local index = events.count + 1

    events.count = index
    events[index] = func

    if (not pnl.mvpEventHandlers or not pnl.mvpEventHandlers[name]) then
        mvp.ui.g.InjectEventHandler(pnl, name)
    end

    return index
end

function mvp.ui.g.RemoveEvent(pnl, name, index)
    if (not pnl.mvpEvents) then
        return false
    end

    local cache = pnl.mvpEvents[name]
    if (not cache) then return false end
    if (not cache[index]) then return false end

    cache[index] = nil

    return true
end

function mvp.ui.g.CallEvent(pnl, name, ignoreRaw, ...)
    local events = pnl.mvpEvents and pnl.mvpEvents[name] or {}
    
    if (not ignoreRaw) then
        local raw = pnl[name]

        if (raw) then
            local result = {raw(pnl, ...)}

            if (result and result[1] ~= nil) then
                return unpack(result)
            end
        end
    end

    if (events and events.count) then
        for i = 1, events.count do
            local fn = events[i]

            if (fn and isfunction(fn)) then
                local result = {fn(pnl, ...)}

                if (result and result[1] ~= nil) then
                    return unpack(result)
                end
            end
        end
    end
end

function mvp.ui.g.InjectEventHandler(pnl, fnName)
    pnl.mvpEventHandlers = pnl.mvpEventHandlers or {}

    if (pnl.mvpEventHandlers[fnName]) then
        return false
    end

    local oldFn = pnl[fnName]

    pnl[fnName] = function(self, ...)
        if (oldFn) then
            oldFn(self, ...)
        end

        mvp.ui.g.CallEvent(self, fnName, true, ...)
    end

    pnl.mvpEventHandlers[fnName] = true

    return true
end

function mvp.ui.g.HasEventHandler(pnl, fnName)
    return pnl.mvpEventHandlers and pnl.mvpEventHandlers[fnName]
end

function mvp.ui.g.Test(class, w, h, fn)
    if (IsValid(mvp.ui.g.testPanel)) then
        mvp.ui.g.testPanel:Remove()
    end

    local pnl = vgui.Create(class)

    if (IsValid(pnl)) then
        mvp.ui.g.testPanel = pnl

        local sizeW, sizeH = ScrW() * w, ScrH() * h
        if (w > 1) then
            sizeW = w
        end
        if (h > 1) then
            sizeH = h
        end

        pnl:SetSize(sizeW, sizeH)
        pnl:Center()

        if (fn) then
            fn(pnl, pnl:GetWide(), pnl:GetTall())
        end
    end
end