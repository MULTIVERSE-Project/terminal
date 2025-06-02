local FEATURE = {}

local HOVER_SOUND, CLICK_SOUND = "mvp/ui/hover.ogg", "mvp/ui/click.ogg"

AccessorFunc(FEATURE, "_Depressed", "Depressed", FORCE_BOOL)
AccessorFunc(FEATURE, "_Disabled", "Disabled", FORCE_BOOL)

function FEATURE:Init()
    self:SetDepressed(false)
    self:SetCursor("hand")
    self:SetMouseInputEnabled(true)

    self.OnMousePressed = function(s, code)
        if (s:GetDisabled()) then
            return 
        end

        s:SetDepressed(true)
        s:Call("OnPress", nil, code)
    end
    self.OnMouseReleased = function(s, code)
        if (s:GetDisabled()) then
            return
        end

        s:Call("OnRelease", nil, code)

        if (code == MOUSE_LEFT) then
            s:Call("DoClick")
        elseif (code == MOUSE_RIGHT) then
            s:Call("DoRightClick")
        elseif (code == MOUSE_MIDDLE) then
            s:Call("DoMiddleClick")
        end

        s:SetDepressed(false)
    end
end

function FEATURE:SetDisabled(disabled)
    self._Disabled = disabled

    if (disabled) then
        self:SetCursor("no")
        self:Call("OnDisabled")
    else
        self:SetCursor("hand")
        self:Call("OnEnabled")
    end
end

function FEATURE:AddHoverSound()
    self:CreateEventHandler("OnCursorEntered")
    self:CreateEventHandler("OnRelease")

    self:On("OnCursorEntered", function()
        if (not self:GetDisabled()) then
            surface.PlaySound(HOVER_SOUND)
        end
    end)
    self:On("OnRelease", function()
        surface.PlaySound(CLICK_SOUND)
    end)
end

mvp.ui.features.Register("click", FEATURE)