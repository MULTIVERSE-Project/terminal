FEATURE = {}

AccessorFunc(FEATURE, "_colIdle", "ColorIdle")
AccessorFunc(FEATURE, "_colHover", "ColorHover")
AccessorFunc(FEATURE, "_colPressed", "ColorPressed")
AccessorFunc(FEATURE, "_hoverBlocked", "HoverBlocked")

local ANIM_DURATION = .2

local function isDisabled(panel)
    if panel.GetDisabled then
        return panel:GetDisabled()
    end
end

local function animColor(panel, targetKey, duration)
    local key = panel._colorKey

    if (not panel[targetKey]) then
        return
    end
    panel:Animate(key, panel[targetKey], duration or ANIM_DURATION)
end

function FEATURE:SetColorKey(colorKey)
    self._colorKey = colorKey
end

function FEATURE:SetColorIdle(color, offset)
    self._colIdle = color
    self[self._colorKey] = mvp.ui.utils.CopyColor(color)

    if (offset) then
        self:SetColorHover(mvp.ui.utils.OffsetColor(color, offset))
    end
end

function FEATURE:OnPress()
    if isDisabled(self) then return end
    if self:GetHoverBlocked() then return end

    animColor(self, "_colPressed")
end

function FEATURE:OnRelease()
    if isDisabled(self) then return end
    if self:GetHoverBlocked() then return end
    if self:IsHovered() then
        animColor(self, "_colHover")
    end
end

function FEATURE:OnCursorEntered()
    if isDisabled(self) then return end
    if self:GetHoverBlocked() then return end

    animColor(self, "_colHover")
end

function FEATURE:OnCursorExited()
    if isDisabled(self) then return end
    if self:GetHoverBlocked() then return end

    animColor(self, "_colIdle")
end

mvp.ui.features.Register("hover", FEATURE)