local PANEL = {}

local backgroundCol = mvp.ui.config.colors.primary
local accentCol = mvp.ui.config.colors.secondary

function PANEL:Init()
    self.header = self:Add("tui.Frame.Header")
    self:Combine(self.header, "SetTitle")

    self:SetTitle("FRAME TITLE")

    self.focusMultiplier = 0
    self.focusDisabledPanels = {}

    self._Remove = self.Remove
    self.Remove = function(pnl)
        pnl:Close()
    end
end

function PANEL:PerformLayout(w, h)
    self.header:Dock(TOP)
    self.header:SetTall(mvp.ui.scale.GetScaleY(32))
end

function PANEL:ShowCloseButton(show)
    self.header.close:SetVisible(show)
end

function PANEL:Paint(w, h)
    if (self.focused and self.focusMultiplier > 0) then
        local x, y = self:LocalToScreen(0, 0)

        DisableClipping(true)

        mvp.ui.utils.BackdropBlur(self, self.focusMultiplier)
        draw.RoundedBox(8, -1, -1, w + 2, h + 2, accentCol)

        DisableClipping(false)        
    end

    draw.RoundedBox(8, 0, 0, w, h, backgroundCol)
end

function PANEL:Focus()

    local panels = vgui.GetWorldPanel():GetChildren()
    for _, pnl in ipairs(panels) do
        if (pnl:IsVisible() and pnl ~= self and pnl:IsMouseInputEnabled()) then
            pnl:SetMouseInputEnabled(false)

            table.insert(self.focusDisabledPanels, pnl)
        end
    end

    self.focused = true
    self.focusMultiplier = 0

    -- valueName, to, duration, easingFn, callback)
    self:Animate("focusMultiplier", 5, 0.33)
end
function PANEL:UnFocus()
    for _, pnl in ipairs(self.focusDisabledPanels) do
        if (IsValid(pnl)) then
            pnl:SetMouseInputEnabled(true)
        end
    end

    self.focusDisabledPanels = {}
    self.focused = false
end

function PANEL:OnRemove()
    self:UnFocus()
end

function PANEL:Close()
    self:AlphaTo(0, 0.2, 0, function(_, pnl)
        if (IsValid(pnl)) then
            pnl:_Remove()
        end
    end)
end

mvp.ui.gui.Register("tui.Frame", PANEL, "EditablePanel")

-- mvp.ui.gui.Test("tui.Frame", 800, 600, function(pnl, w, h)
--     pnl:MakePopup()
--     -- pnl:Focus()

--     local focusButton = pnl:Add("DButton")
--     focusButton:SetText("Focus/Unfocus")
--     focusButton:SetSize(100, 30)
--     focusButton:SetPos(10, h - 40)
--     focusButton.DoClick = function()
--         local frame2 = vgui.Create("tui.Frame")
--         frame2:SetSize(400, 300)
--         frame2:SetPos(math.random(0, ScrW() - 400), math.random(0, ScrH() - 300))
--         frame2:MakePopup()
--         frame2:Focus()

--         local closeButton = frame2:Add("DButton")
--         closeButton:SetText("Close")
--         closeButton:SetSize(100, 30)
--         closeButton:SetPos(10, 10)
--         closeButton.DoClick = function()
--             frame2:Close()
--         end
--     end
-- end)