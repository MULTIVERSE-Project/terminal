PANEL = {}

local RNDX = mvp.RNDX

local SCROLLBAR_STYLE
mvp.theme.Hook("ScrollBar", function()
    return {
        mvp.C("primary", 0.45),
        mvp.C("primary"),
    }
end, function(style)
    SCROLLBAR_STYLE = style
    hook.Run("mvp.v2.ScrollBar.UpdateStyle")
end)

function PANEL:Init()
    mvp.ui.g.Extend(self.btnGrip)

    self:Import("smoothscroll")
    self:SetHideButtons(true)

    self.bgColor = ColorAlpha(self:C("background"), 150)

    self.btnGrip.color = Color(0, 0, 0)
    self.btnGrip:Import("hover")
    self.btnGrip:SetColorKey("color")
    self.btnGrip:SetColorIdle(SCROLLBAR_STYLE[1])
    self.btnGrip:SetColorHover(SCROLLBAR_STYLE[2])

    self.btnGrip.Paint = function(panel, w, h)
        RNDX().Rect(0, 0, w, h)
            :Color(panel.color)
            :Rad(8)
            :Draw()
    end

    hook.Add("mvp.v2.ScrollBar.UpdateStyle", self, function()
        self.btnGrip:SetColorIdle(SCROLLBAR_STYLE[1])
        self.btnGrip:SetColorHover(SCROLLBAR_STYLE[2])

        if self.btnGrip:IsHovered() then
            self.btnGrip.color = SCROLLBAR_STYLE[2]
        else
            self.btnGrip.color = SCROLLBAR_STYLE[1]
        end
    end)
end

function PANEL:Paint(w, h)
    RNDX().Rect(0, 0, w, h)
            :Color(self.bgColor)
            :Rad(8)
            :Draw()
end

function PANEL:OnMouseWheeled(delta)
    local hovered = vgui.GetHoveredPanel()

    if IsValid(hovered) and hovered ~= self and hovered.OnMouseWheeled then
        return
    end

    self.BaseClass.OnMouseWheeled(self, delta)
end

mvp.ui.g.Register("mvp.v2.ScrollPanel.Bar", PANEL, "DVScrollBar")