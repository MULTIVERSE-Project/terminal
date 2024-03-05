-- Requires: https://github.com/tochnonement/spoly

mvp = mvp or {}
mvp.ui = mvp.ui or {}

do
    local function calculateArc(x, y, ang, p, rad, seg)
        seg = seg or 80
        ang = (-ang) + 180
        local circle = {}

        table.insert(circle, {
            x = x,
            y = y
        })
        for i = 0, seg do
            local a = math.rad((i / seg) * -p + ang)
            table.insert(circle, {
                x = x + math.sin(a) * rad,
                y = y + math.cos(a) * rad
            })
        end

        return circle
    end
    
    -- 32 = 4
    -- 24 = 6
    -- 16 = 8
    -- 8 = 16
    for roundness = 32, 8, -8 do
        local index = roundness / 8
        local multiplier = roundness * 2 / math.pow(2, index)
    
        if (index == 1) then
            multiplier = multiplier * 2
        end
    
        for thickness = 1, 4 do
            local scaledThickness = thickness * 64
            local id = 'arc_' .. thickness .. '_' .. roundness
    
            spoly.Generate(id, function(w, h)
    
                local startAng = 0
                local endAng = 90
                local radius = h
                local x, y = 0, h
                                            -- 
                local arcInner = calculateArc(x - scaledThickness, y + scaledThickness, startAng, endAng, radius, 128, true)
                local arcOuter = calculateArc(x, y, startAng, endAng, radius, 128, true)
            
                render.SetStencilWriteMask(255)
                render.SetStencilTestMask(255)
                render.SetStencilReferenceValue(0)
                render.SetStencilPassOperation(STENCIL_KEEP)
                render.SetStencilZFailOperation(STENCIL_KEEP)
                render.ClearStencil()

                render.SetStencilEnable(true)
                render.SetStencilReferenceValue(1)
                render.SetStencilCompareFunction(STENCIL_NEVER)
                render.SetStencilFailOperation(STENCIL_REPLACE)

                    surface.DrawPoly(arcInner)

                render.SetStencilCompareFunction(STENCIL_GREATER)
                render.SetStencilFailOperation(STENCIL_KEEP)
                render.SetStencilZFailOperation(STENCIL_KEEP)

                    surface.DrawPoly(arcOuter)

                render.SetStencilEnable(false)
    
            end) 
        end
    end
end

function mvp.ui.DrawOutlinedRoundedRect(r, x, y, w, h, thickness, color)
    local thickness = thickness or 1
    local id = 'arc_' .. thickness .. '_' .. r

    thickness = math.floor(r * 0.15)

    local w = math.ceil(w)
    local h = math.ceil(h)

    -- x = x - thickness * .5

    local half = math.Round(r * .5)

    if (color) then
        surface.SetDrawColor(color)
    end

    spoly.DrawRotated(id, x + half, y + half, r, r, 90)
    spoly.DrawRotated(id, x + w - half, y + half, r, r, 0)
    spoly.DrawRotated(id, x + w - half, y + h - half, r, r, 270)
    spoly.DrawRotated(id, x + half, y + h - half, r, r, 180)

    surface.DrawRect(x + r, y, (w - r * 2), thickness)
    surface.DrawRect(x + w - thickness, y + r, thickness, (h - r * 2))
    surface.DrawRect(x + r, y + h - thickness, (w - r * 2), thickness)
    surface.DrawRect(x, y + r, thickness, (h - r * 2))
end