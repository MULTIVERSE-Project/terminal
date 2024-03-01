mvp = mvp or {}
mvp.utils = mvp.utils or {}

function mvp.utils.LerpColor(t, from, to)
    return Color(
        Lerp(t, from.r, to.r),
        Lerp(t, from.g, to.g),
        Lerp(t, from.b, to.b),
        Lerp(t, from.a, to.a)
    )
end

function mvp.utils.LerpVector(t, from, to)
    return LerpVector(t, from, to)
end

function mvp.utils.LerpAngle(t, from, to)
    return LerpAngle(t, from, to)
end

function mvp.utils.Lerp(t, from, to)
    return Lerp(t, from, to)
end