local PANEL = {}

function PANEL:Init()
    self:Feature("click")
    self:AddHoverSound()

    self:Feature("hover")

    self:SetColorKey("_color")
    self:SetColorIdle(mvp.ui.config.colors.text)
    self:SetColorHover(mvp.ui.config.colors.accent)

    self:AddScaleAnim()
end

function PANEL:SetImageScale(scale)
    self._imgScale = scale - .2
    self._imgScaleOriginal = scale
end

local SCALE_ANIM_DURATION = .1

function PANEL:AddScaleAnim()
    self:CreateEventHandler("OnCursorEntered")
    self:CreateEventHandler("OnCursorExited")

    self:On("OnCursorEntered", function()
        if (self:GetDisabled()) then return end

        self:Animate("_imgScale", self._imgScaleOriginal - .1, SCALE_ANIM_DURATION, math.ease.InOutQuad)
    end)
    self:On("OnCursorExited", function()
        if (self:GetDisabled()) then return end

        self:Animate("_imgScale", self._imgScaleOriginal - .2, SCALE_ANIM_DURATION, math.ease.InOutQuad)
    end)

    self:On("OnPress", function()
        if (self:GetDisabled()) then return end

        -- "_imgScale", self._imgScaleOriginal, SCALE_ANIM_DURATION, math.ease.InOutQuad, callback
        self:Animate("_imgScale", self._imgScaleOriginal, SCALE_ANIM_DURATION, math.ease.InOutQuad)
    end)
    self:On("OnRelease", function(panel)
        if (panel:IsHovered()) then
            if (panel:GetDisabled()) then return end

            panel:Animate("_imgScale", self._imgScaleOriginal - .1, SCALE_ANIM_DURATION, math.ease.InOutQuad)
        end
    end)
end

mvp.ui.gui.Register("tui.ImageButton", PANEL, "tui.Image")

-- mvp.ui.gui.Test("mvp.Frame", mvp.ui.scale.GetScaleX(1400), mvp.ui.scale.GetScaleY(800), function(pnl, w, h)
--     pnl:MakePopup()
-- end)
