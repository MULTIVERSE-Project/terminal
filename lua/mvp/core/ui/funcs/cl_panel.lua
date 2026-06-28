local FUNCS = {}

-- SECTION: Events

function FUNCS:On(name, fn)
    return mvp.ui.g.AddEvent(self, name, fn)
end
function FUNCS:Call(name, ignoreRaw, ...)
    return mvp.ui.g.CallEvent(self, name, ignoreRaw, ...)
end
function FUNCS:InjectEventHandler(name)
    mvp.ui.g.InjectEventHandler(self, name)
end

-- SECTION: Misc

function FUNCS:Combine(pnl2, fnName)
    self[fnName] = function(_, ...)
        return pnl2[fnName](pnl2, ...)
    end
end
function FUNCS:CombineMutator(pnl2, mutatorName)
    self:Combine(pnl2, "Set" .. mutatorName)
    self:Combine(pnl2, "Get" .. mutatorName)
end

function FUNCS:MakeDispatchFn(pnl2, fnName)
    pnl2[fnName] = function(_, ...)
        return self:Call(fnName, nil, ...)
    end
end

function FUNCS:CallOnRemove(func)
    self:InjectEventHandler("OnRemove")

    self:On("OnRemove", function(pnl)
        func(pnl)
    end)
end

function FUNCS:Import(trait)
    mvp.ui.g.ImportTrait(self, trait)
end

-- SECTION: Animation

local function ease(t, b, c, d)
    t = t / d
    local ts = t * t
    local tc = ts * t

    return b + c * (-2 * tc + 3 * ts)
end

function FUNCS:Lerp(var, to, duration, callback)
    if (not duration) then duration = 0.5 end

    local start = self[var]

    local animation = self:NewAnimation(duration)
    animation.goalValue = to

    animation.Think = function(anim, panel, fraction)
        local newFraction = ease(fraction, 0, 1, 1)

        if (not anim.startValue) then
            anim.startValue = start
        end

        local value = Lerp(newFraction, anim.startValue, anim.goalValue)
        self[var] = value
    end

    if (callback) then
        animation.OnEnd = function(anim, panel)
            callback()
        end
    end
end

function FUNCS:LerpColor(var, to, duration, callback)
    if (not duration) then duration = 0.5 end

    local start = self[var]

    local animation = self:NewAnimation(duration)
    animation.goalValue = to

    animation.Think = function(anim, panel, fraction)
        local newFraction = ease(fraction, 0, 1, 1)

        if (not anim.startValue) then
            anim.startValue = start
        end

        local value = mvp.utils.LerpColor(newFraction, anim.startValue, anim.goalValue)
        self[var] = value
    end

    if (callback) then
        animation.OnEnd = function(anim, panel)
            callback()
        end
    end
end

-- SECTION: Register functions

for name, fn in pairs(FUNCS) do
    mvp.ui.g.RegisterFunc(name, fn)
end