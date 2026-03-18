TRAIT = {}

AccessorFunc(TRAIT, "m_bDepressed", "Depressed", FORCE_BOOL)
AccessorFunc(TRAIT, "m_bDisabled", "Disabled", FORCE_BOOL)

function TRAIT:Init()
    self:SetDepressed(false)
    self:SetCursor("hand")
    self:SetMouseInputEnabled(true)

    self.OnMousePressed = function(self, code)
        if not self:GetDisabled() then
            self:SetDepressed(true)
            self:Call("OnPress", nil, code)

            self.m_LastPressTime = CurTime()
        end
    end

    self.OnMouseReleased = function(self, code)
        if self:GetDisabled() then return end
        if not self:GetDepressed() then return end

        -- if (CurTime() - (self.m_LastPressTime or 0) > .2) then
            self:Call("OnRelease", nil, code)

            if code == MOUSE_LEFT then
                self:Call("DoClick")
            elseif code == MOUSE_RIGHT then
                self:Call("DoRightClick")
            else
                self:Call("DoMiddleClick")
            end
        end

        self:SetDepressed(false)
    -- end
end

function TRAIT:SetDisabled(bool)
    self.m_bDisabled = bool

    if bool then
        self:SetCursor("no")
        self:Call("OnDisabled", nil)
    else
        self:SetCursor("hand")
        self:Call("OnEnabled", nil)
    end
end

mvp.ui.g.RegisterTrait("click", TRAIT)