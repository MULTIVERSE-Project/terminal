mvp = mvp or {}
mvp.ui = mvp.ui or {}

function mvp.ui.Ease(t, b, c, d)
    t = t / d
    local ts = t * t
    local tc = ts * t

    return b + c * (-2 * tc + 3 * ts)
end

local PNL = FindMetaTable("Panel")

function PNL:Lerp(var, to, duration, callback)
    if (not duration) then duration = 0.5 end

    local start = self[var]

    local animation = self:NewAnimation(duration)
    animation.goalValue = to

    animation.Think = function(anim, panel, fraction)
        local newFraction = mvp.ui.Ease(fraction, 0, 1, 1)

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

function PNL:LerpColor(var, to, duration, callback)
    if (not duration) then duration = 0.5 end

    local start = self[var]

    local animation = self:NewAnimation(duration)
    animation.goalValue = to

    animation.Think = function(anim, panel, fraction)
        local newFraction = mvp.ui.Ease(fraction, 0, 1, 1)

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

function PNL:LerpPositionX(to, duration, callback)
    if (not duration) then duration = 0.5 end

    local start = self:GetX()
    local animation = self:NewAnimation(duration)
    animation.goalValue = to

    animation.Think = function(anim, panel, fraction)
        local newFraction = mvp.ui.Ease(fraction, 0, 1, 1)

        if (not anim.startValue) then
            anim.startValue = start
        end

        local value = Lerp(newFraction, anim.startValue, anim.goalValue)
        self:SetX(value)
    end

    if (callback) then
        animation.OnEnd = function(anim, panel)
            callback()
        end
    end
end