mvp.ui = mvp.ui or {}
mvp.ui.gui = mvp.ui.gui or {}

mvp.ui.gui.ext = mvp.ui.gui.ext or {}

function mvp.ui.gui.Register(name, panelTable, parent)
    mvp.ui.gui.Extend(panelTable)

    return vgui.Register(name, panelTable, parent)
end

function mvp.ui.gui.Extend(pnl)
    for k, v in pairs(mvp.ui.gui.ext) do
        pnl[k] = v
    end
end

-- Registers a new extension (or overrides an existing one) for the mvp.ui.gui.Extend
function mvp.ui.gui.RegisterExt(name, ext)
    mvp.ui.gui.ext[name] = ext
end

--[[

    Panel events

]]--

function mvp.ui.gui.AddEvent(pnl, name, fn)
    pnl.mvpEvents = pnl.mvpEvents or {}
    pnl.mvpEvents[name] = pnl.mvpEvents[name] or {
        count = 0
    }

    local eventsFns = pnl.mvpEvents[name]
    local count = eventsFns.count + 1

    eventsFns.count = count
    eventsFns[count] = fn

    return count
end

function mvp.ui.gui.RemoveEvent(pnl, name, index)
    if (not pnl.mvpEvents) then
        return false
    end

    local eventsFns = pnl.mvpEvents[name]
    if (not eventsFns) then
        return false
    end

    local func = eventsFns[index]
    if (not func) then
        return false
    end

    eventsFns[index] = nil

    return true
end

function mvp.ui.gui.CallEvent(pnl, name, ignoreRaw, ...)
    local events = pnl.mvpEvents or {}

    if (not ignoreRaw) then
        local rawEvent = pnl[name]
        if (rawEvent and isfunction(rawEvent)) then
            local val = rawEvent(pnl, ...)
            if (val) then
                return val
            end
        end
    end

    local eventsFns = events[name]
    if (eventsFns) then
        for i = 1, eventsFns.count do
            local fn = eventsFns[i]
            if (fn) then
                local val = fn(pnl, ...)
                if (val) then
                    return val
                end
            end
        end
    end
end

function mvp.ui.gui.CreateEventHandler(pnl, name)
    pnl.mvpEventHandlers = pnl.mvpEventHandlers or {}

    if (pnl.mvpEventHandlers[name]) then
        return false
    end

    local old = pnl[name]
    pnl[name] = function(self, v1, v2, v3, v4, v5, v6) -- max 6 arguments I think
        if (old) then
            old(self, v1, v2, v3, v4, v5, v6)
        end

        if (self.mvpEventHandlers[name]) then
            mvp.ui.gui.CallEvent(self, name, true, v1, v2, v3, v4, v5, v6)
        end
    end

    pnl.mvpEventHandlers[name] = true

    return true
end

--[[

    Panel testing functions

]]--

function mvp.ui.gui.Test(class, w, h, fn)
    if (not mvp.config.Get("debug", false)) then
        return
    end

    if (IsValid(mvp.ui.gui.testPanel)) then
        mvp.ui.gui.testPanel:Remove()
    end
    if (IsValid(mvp.ui.gui.closeTestPanel)) then
        mvp.ui.gui.closeTestPanel:Remove()
    end

    local pnl = vgui.Create(class)
    if (IsValid(pnl)) then
        pnl:SetSize(w or 200, h or 200)
        pnl:Center()
        pnl:MakePopup()

        if (fn) then
            fn(pnl, pnl:GetWide(), pnl:GetTall())
        end

        local w, h = ScrW(), ScrH()
        -- Add a close button to the panel
        local closeButton = vgui.Create("DButton")
        closeButton:SetSize(w - 50, 30)
        closeButton:SetPos(25, h - 50)
        closeButton:SetText("Close test panel")
        closeButton.DoClick = function(p)
            p:Remove()
            
            pnl:Remove()
        end

        mvp.ui.gui.testPanel = pnl
        mvp.ui.gui.closeTestPanel = closeButton
    else
        print("Failed to create panel of class:", class)
    end
end