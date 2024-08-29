mvp = mvp or {}
mvp.ui = mvp.ui or {}

function mvp.ui.RegisterPanel(name, meta, base)
    meta = meta or {}
    base = base or "EditablePanel"

    mvp.ui.ExtendPanel(meta)
    
    return vgui.Register(name, meta, base)
end

function mvp.ui.ExtendPanel(pnl)
    for k, v in pairs(mvp.ui.funcs) do
        pnl[k] = v
    end
end

do -- SECTION: UI Functions
    mvp.ui.funcs = mvp.ui.funcs or {}
    function mvp.ui.RegisterFunction(id, func)
        mvp.ui.funcs[id] = func
    end

    function mvp.ui.GetFunction(id)
        return mvp.ui.funcs[id]
    end

    function mvp.ui.GetAllFunctions()
        return mvp.ui.funcs
    end
end

do -- SECTION: UI Events
    function mvp.ui.AddPanelEvent(pnl, name, fn)
        pnl.mvp_events = pnl.mvp_events or {}
        pnl.mvp_events[name] = pnl.mvp_events[name] or {
            count = 0
        }

        local events = pnl.mvp_events[name]
        local index = events.count + 1

        events.count = index
        events[index] = fn

        return index
    end

    function mvp.ui.RemovePanelEvent(pnl, name, index)
        if (not pnl.mvp_events) then return false end

        local events = pnl.mvp_events[name]
        if (not events) then return false end
        if (not events[index]) then return false end

        events[index] = nil

        return true
    end

    function mvp.ui.CallPanelEvent(pnl, name, ignoreRaw, ...)
        local events = pnl.mvp_events and pnl.mvp_events[name] or {}

        if (not ignoreRaw) then
            local raw = pnl[name]

            if (raw and isfunction(raw)) then
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

    function mvp.ui.InjectPanelEventHandler(pnl, fnName)
        pnl.mvp_event_handlers = pnl.mvp_event_handlers or {}

        if (pnl.mvp_event_handlers[fnName]) then return false end

        local oldFn = pnl[fnName]
        
        pnl[fnName] = function(self, ...)
            if (oldFn) then
                oldFn(self, ...)
            end

            return mvp.ui.CallPanelEvent(self, fnName, true, ...)
        end

        pnl.mvp_event_handlers[fnName] = true
        return true
    end

    function mvp.ui.HasPanelEventHandler(pnl, fnName)
        return pnl.mvp_event_handlers and pnl.mvp_event_handlers[fnName] or false
    end
end

do -- SECTION: UI Tests
    function mvp.ui.TestPanel(class, w, h, fn)
        if (not mvp.config.Get("debug", false)) then return end -- Only run this in debug mode

        if (IsValid(mvp.ui.testPanel)) then
            mvp.ui.testPanel:Remove()
        end

        local pnl = vgui.Create(class)
        if (IsValid(pnl)) then
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
end