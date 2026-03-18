TRAIT = {}

AccessorFunc(TRAIT, "m_colIdle", "ColorIdle")
AccessorFunc(TRAIT, "m_colHover", "ColorHover")
AccessorFunc(TRAIT, "m_colPressed", "ColorPressed")
AccessorFunc(TRAIT, "m_hoverBlocked", "HoverBlocked")

local ANIM_DURATION = .2

local function isDisabled(panel)
    if panel.GetDisabled then
        return panel:GetDisabled()
    end
end

local function animColor(panel, targetkey, duration)
    local key = panel.m_ColorKey

    if (not panel[targetkey]) then
        return
    end
    panel:LerpColor(key, panel[targetkey], duration or ANIM_DURATION)
end

function TRAIT:SetColorKey(colorKey)
    self.m_ColorKey = colorKey
end

function TRAIT:SetColorIdle(col)
    self.m_colIdle = col
    
    if (self.m_ColorKey) then
        self[self.m_ColorKey] = col
    end
end

function TRAIT:OnPress()
    if isDisabled(self) then return end
    if self:GetHoverBlocked() then return end

    animColor(self, "m_colPressed")
end

function TRAIT:OnRelease()
    if isDisabled(self) then return end
    if self:GetHoverBlocked() then return end
    if self:IsHovered() then
        animColor(self, "m_colHover")
    end
end

function TRAIT:OnCursorEntered()
    if isDisabled(self) then return end
    if self:GetHoverBlocked() then return end

    animColor(self, "m_colHover")
end

function TRAIT:OnCursorExited()
    if isDisabled(self) then return end
    if self:GetHoverBlocked() then return end

    animColor(self, "m_colIdle")
end

mvp.ui.g.RegisterTrait("hover", TRAIT)