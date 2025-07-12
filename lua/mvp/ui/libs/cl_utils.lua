mvp.ui = mvp.ui or {}
mvp.ui.utils = mvp.ui.utils or {}

do -- Color utils
    local Color, math_Clamp = Color, math.Clamp

    function mvp.ui.utils.OffsetColor(color, offset)
        if not color then return nil end
        if not offset then return color end

        local r = math_Clamp(color.r + offset, 0, 255)
        local g = math_Clamp(color.g + offset, 0, 255)
        local b = math_Clamp(color.b + offset, 0, 255)

        return Color(r, g, b, a)
    end

    function mvp.ui.utils.CopyColor(color)
        if not color then return nil end

        return Color(color.r, color.g, color.b, color.a)
    end

    function mvp.ui.utils.EditHSVColor(color, hue, saturation, value)
        local h, s, v = ColorToHSV(color)

        return HSVToColor(hue or h, math.Clamp(saturation or s, 0, 1), math.Clamp(value or v, 0, 1))
    end
end

do -- Backdrop blur
    local matBlur = Material("pp/blurscreen")

    local surface_SetDrawColor, surface_SetMaterial, surface_DrawTexturedRect = surface.SetDrawColor, surface.SetMaterial, surface.DrawTexturedRect
    local render_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture

    function mvp.ui.utils.BackdropBlur(pnl, amount)
        local x, y = pnl:LocalToScreen(0, 0)
        local scrW, scrH = ScrW(), ScrH()

        surface_SetDrawColor(255, 255, 255)
        surface_SetMaterial(matBlur)

        for i = 1, 3 do
            matBlur:SetFloat("$blur", (i / 3) * (amount or 5))
            matBlur:Recompute()

            render_UpdateScreenEffectTexture()
            surface_DrawTexturedRect(x * -1, y * -1, scrW, scrH)
        end
    end
end

do -- drawing
    local surface_SetDrawColor, surface_SetMaterial, surface_DrawTexturedRect, surface_DrawTexturedRectRotated = surface.SetDrawColor, surface.SetMaterial, surface.DrawTexturedRect, surface.DrawTexturedRectRotated

    function mvp.ui.utils.DrawMaterial(mat, x, y, w, h, color)
        color = color or color_white

        surface_SetMaterial(mat)
        surface_SetDrawColor(color)
        surface_DrawTexturedRect(x, y, w, h)
    end

    function mvp.ui.utils.DrawMaterialRotated(mat, x, y, w, h, color, angle)
        color = color or color_white

        surface_SetMaterial(mat)
        surface_SetDrawColor(color)

        surface_DrawTexturedRectRotated(x, y, w, h, angle)
    end
end

do -- gradients
    local matGradientToBottom = Material("vgui/gradient-u")
    local matGradientToTop = Material("vgui/gradient-d")
    local matGradientToLeft = Material("vgui/gradient-l")
    local matGradientToRight = Material("vgui/gradient-r")

    local surface_SetMaterial, surface_SetDrawColor, surface_DrawTexturedRect = surface.SetMaterial, surface.SetDrawColor, surface.DrawTexturedRect
    local draw_RoundedBoxEx = draw.RoundedBoxEx

    function mvp.ui.utils.DrawMaterialGradient(x, y, w, h, dir, color)
        if dir == BOTTOM then
            surface_SetMaterial(matGradientToBottom)
        elseif (dir == LEFT) then
            surface_SetMaterial(matGradientToLeft)
        elseif (dir == RIGHT) then
            surface_SetMaterial(matGradientToRight)
        else
            surface_SetMaterial(matGradientToTop)
        end
        surface_SetDrawColor(color)
        surface_DrawTexturedRect(x, y, w, h)
    end

    function mvp.ui.utils.DrawDermaGradient(r, x, y, w, h, dir, colFrom, colTo)
        if (dir == BOTTOM) then
            draw_RoundedBoxEx(r, x, y, w, h - r, colTo, true, true, false, false)
            draw_RoundedBoxEx(r, x, y + r, w, h - r, colFrom, false, false, true, true)

            mvp.ui.utils.DrawMaterialGradient(x, y + r, w, h - (r * 2), dir, colTo)
        elseif (dir == LEFT) then
            draw_RoundedBoxEx(r, x, y, w - r, h, colTo, true, false, true, false)
            draw_RoundedBoxEx(r, x + r, y, w - r, h, colFrom, false, true, false, true)

            mvp.ui.utils.DrawMaterialGradient(x + r, y, w - (r * 2), h, dir, colTo)
        elseif (dir == RIGHT) then
            draw_RoundedBoxEx(r, x + w * .5, y, w * .5, h, colTo, false, true, false, true)
            draw_RoundedBoxEx(r, x, y, w - r, h, colFrom, true, false, true, false)

            mvp.ui.utils.DrawMaterialGradient(x + r, y, w - (r * 2), h, dir, colTo)
        else -- TOP
            draw_RoundedBoxEx(r, x, y + r, w, h - r, colTo, false, false, true, true)
            draw_RoundedBoxEx(r, x, y, w, h - r, colFrom, true, true, false, false)
            
            mvp.ui.utils.DrawMaterialGradient(x, y + r, w, h - (r * 2), dir, colTo)
        end
    end
end

do -- Poly rounded box
    local rad = math.rad
    local sin = math.sin
    local cos = math.cos
    local Round = math.Round

    local insert = table.insert
    local table_Add = table.Add

    local function calculateCircle(x0, y0, startAngle, angleLength, radius, vertices, addCenter)
        local startAngle = startAngle - 90
        local vertices = vertices or 32
        local step = Round(angleLength / vertices, 1)
        local tbl, count = {}, 0

        if (addCenter) then
            tbl[1] = {x = x0, y = y0}
            count = 1
        end

        for i = 0, vertices do
            local ang = startAngle + i * step
            local rad = rad(ang)
            local sin = sin(rad)
            local cos = cos(rad)

            local x = x0 + radius * cos
            local y = y0 + radius * sin

            count = count + 1
            tbl[count] = {x = x, y = y}
        end

        return tbl
    end


    function mvp.ui.utils.CalculateRoundedBoxEx(r, x, y, w, h, ruCorner, rbCorner, ldCorner, lbCorner)
        r = math.ceil(math.min(r, h / 2))

        if (r == 0) then
            ruCorner = false
            rbCorner = false
            ldCorner = false
            lbCorner = false
        end

        local vertices = {}

        insert(vertices, {x = x + r, y = y})

        -- Right Upper Corner
        if (ruCorner) then
            insert(vertices, {x = x + w - r, y = y})
            table_Add(vertices, calculateCircle(x + w - r, y + r, 0, 90, r, r))
            insert(vertices, {x = x + w, y = y + r})
        else
            insert(vertices, {x = x + w, y = y})
        end

        -- Right Bottom Corner
        if (rbCorner) then
            insert(vertices, {x = x + w, y = y + h - r})
            table_Add(vertices, calculateCircle(x + w - r, y + h - r, 90, 90, r, r))
            insert(vertices, {x = x + w - r, y = y + h})
        else
            insert(vertices, {x = x + w, y = y + h})
        end

        -- Left Bottom Corner
        if (ldCorner) then
            insert(vertices, {x = x + r, y = y + h})
            table_Add(vertices, calculateCircle(x + r, y + h - r, 180, 90, r, r))
            insert(vertices, {x = x, y = y + h - r})
        else
            insert(vertices, {x = x, y = y + h})
        end

        -- Left Upper Corner
        if (lbCorner) then
            insert(vertices, {x = x, y = y + r})
            table_Add(vertices, calculateCircle(x + r, y + r, 270, 90, r, r))
            insert(vertices, {x = x + r, y = y})
        else
            insert(vertices, {x = x, y = y})
        end

        return vertices
    end

    function mvp.ui.utils.CalculateRoundedBox(r, x, y, w, h)
        return mvp.ui.utils.CalculateRoundedBoxEx(r, x, y, w, h, true, true, true, true)
    end
end

do -- Stencil Masks
    function mvp.ui.utils.Mask(funcMask, funcDraw)
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

        funcMask()

        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)

        funcDraw()

        render.SetStencilEnable(false)
    end
end

do -- Text utils
    local surface_SetFont, surface_GetTextSize = surface.SetFont, surface.GetTextSize

    function mvp.ui.utils.GetTextSize(text, font)
        if (font) then
            surface_SetFont(font)
        end

        return surface_GetTextSize(text)
    end

    function mvp.ui.utils.GetTextWidth(text, font)
        return mvp.ui.utils.GetTextSize(text, font)
    end

    function mvp.ui.utils.GetTextHeight(text, font)
        local _, height = mvp.ui.utils.GetTextSize(text, font)
        return height
    end
end