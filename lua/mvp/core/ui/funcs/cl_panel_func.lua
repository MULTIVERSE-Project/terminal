local FUNCS = {}

do -- SECTION: Panel Events
    function FUNCS:On(name, fn)
        return mvp.ui.AddPanelEvent(self, name, fn)
    end
    function FUNCS:Call(name, ignoreRaw, ...)
        return mvp.ui.CallPanelEvent(self, name, ignoreRaw, ...)
    end
    function FUNCS:InjectEventHandler(name)
        mvp.ui.InjectEventHandler(self, name)
    end
end

do -- SECTION: Mischellaneous
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
end

do -- SECTION: Animation
    local ANIMATION_DEFAULT_DURATION = 0.5

    local function ease(t, b, c, d)
        t = t / d
        local ts = t * t
        local tc = ts * t

        return b + c * (-2 * tc + 3 * ts)
    end

    function FUNCS:Lerp(var, to, duration, callback)
        if (not duration) then duration = ANIMATION_DEFAULT_DURATION end

        local start = self[var]

        local animation = self:NewAnimation(duration)
        animation.goalVal = to

        animation.Think = function(anim, pnl, fraction)
            fraction = ease(fraction, 0, 1, 1)

            if (not anim.startVal) then
                anim.startVal = start
            end

            self[var] = Lerp(fraction, anim.startVal, anim.goalVal)
        end

        if (callback) then
            animation.OnEnd = function(anim, pnl)
                callback(pnl)
            end
        end

        return animation
    end
end

for name, fn in pairs(FUNCS) do
    mvp.ui.RegisterFunction(name, fn)
end