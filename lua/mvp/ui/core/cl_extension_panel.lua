local PANEL = {}

-- Events
function PANEL:CreateEventHandler(name)
    mvp.ui.gui.CreateEventHandler(self, name)
end
function PANEL:On(name, fn)
    return mvp.ui.gui.AddEvent(self, name, fn)
end
function PANEL:Call(name, ignoreRaw, ...)
    return mvp.ui.gui.CallEvent(self, name, ignoreRaw, ...)    
end

-- Features
function PANEL:Feature(id)
    return mvp.ui.features.Import(self, id)
end

-- Utilities
function PANEL:Combine(pnl, name)
    self[name] = function(_, ...)
        return pnl[name](pnl, ...)
    end
end
function PANEL:CombineAccessor(pnl, accessorName)
    self:Combine(pnl, "Get" .. accessorName)
    self:Combine(pnl, "Set" .. accessorName)
end
function PANEL:MakeDispatchFn(pnl, fnName)
    pnl[fnName] = function(_, ...)
        return self:Call(fnName, nil, ...)
    end
end

-- Animations
local function unclampedLerp(delta, from, to)
    return from + (to - from) * delta
end
local function colorLerp(delta, from, to)
    return Color(
        math.Clamp(unclampedLerp(delta, from.r, to.r), 0, 255),
        math.Clamp(unclampedLerp(delta, from.g, to.g), 0, 255),
        math.Clamp(unclampedLerp(delta, from.b, to.b), 0, 255),
        math.Clamp(unclampedLerp(delta, from.a, to.a), 0, 255)
    )
end

function PANEL:Animate(valueName, to, duration, easingFn, callback)
    duration = duration or 0.2
    easingFn = easingFn or function(x) return x end -- Linear easing function (no easing, bruh)

    local startValue = self[valueName]
    if (not startValue) then
        error("PANEL:Animate - Value '" .. valueName .. "' does not exist on the panel.")
    end
    if (type(startValue) ~= type(to)) then
        error("PANEL:Animate - Value type mismatch: '" .. valueName .. "' is " .. type(startValue) .. " but target is " .. type(to) .. ".")
    end

    local lerpFn = IsColor(startValue) and colorLerp or unclampedLerp

    local anim = self:NewAnimation(duration, 0, 1, callback)
    anim.goalValue = to
    anim.startValue = startValue

    anim.Think = function(s, pnl, fraction)
        local easedFraction = easingFn(fraction)
        if (not s.startValue) then
            s.startValue = pnl[valueName]
        end

        local value = lerpFn(easedFraction, s.startValue, s.goalValue)
        pnl[valueName] = value
    end
end


for k, v in pairs(PANEL) do
    mvp.ui.gui.RegisterExt(k, v)
end