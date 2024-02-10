local PANEL = {}

function PANEL:Init()
    local vbar = self:GetVBar()
    vbar:SetHideButtons(true)
    vbar:SetWide(mvp.ui.Scale(15))
    
    vbar.Paint = function(pnl, w, h)
        draw.RoundedBox(mvp.ui.ScaleWithFactor(h * .5), 0, 0, w, h, mvp.colors.SecondaryBackground)
    end

    vbar.btnGrip.backgroundColor = mvp.colors.Background

    vbar.btnGrip.colors = {
        Background = mvp.colors.Background,
        BackgroundHover = mvp.colors.SecondaryAccent,
    }

    vbar.btnGrip.OnCursorEntered = function(pnl)
        pnl:LerpColor("backgroundColor", pnl.colors.BackgroundHover, 0.2)
    end

    vbar.btnGrip.OnCursorExited = function(pnl)
        pnl:LerpColor("backgroundColor", pnl.colors.Background, 0.2)
    end

    vbar.btnGrip.Paint = function(pnl, w, h)
        draw.RoundedBox(mvp.ui.ScaleWithFactor(h * .5), 2, 2, w - 4, h - 4, pnl.backgroundColor)
    end

end

function PANEL:PerformLayoutInternal()
    local tall = self.pnlCanvas:GetTall()
    local wide = self:GetWide()

    local y = 0

    self:Rebuild()

    self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
    y = self.VBar:GetOffset()

    if ( self.VBar.Enabled ) then wide = wide - mvp.ui.Scale(3) - self.VBar:GetWide() end

    self.pnlCanvas:SetPos( 0, y )
    self.pnlCanvas:SetWide( wide )

    self:Rebuild()

    if ( tall != self.pnlCanvas:GetTall() ) then
        self.VBar:SetScroll( self.VBar:GetScroll() ) -- Make sure we are not too far down!
    end
end

vgui.Register("mvp.ScrollPanel", PANEL, "DScrollPanel")