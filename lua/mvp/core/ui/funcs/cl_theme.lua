local FUNCS = {}

function FUNCS:C(key, lightMod, alpha)
    return mvp.theme.Color(key, lightMod, alpha)
end

function FUNCS:F(pattern, size, unscaled, fromFigma, params)
    return mvp.theme.Font(pattern, size, unscaled, fromFigma, params)
end
function FUNCS:FF(pattern, size, unscaled, params)
    return mvp.theme.Font(pattern, size, unscaled, true, params)
end 

for name, fn in pairs(FUNCS) do
    mvp.ui.g.RegisterFunc(name, fn)
end