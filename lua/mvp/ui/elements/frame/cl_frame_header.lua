local PANEL = {}

local secondaryColor = mvp.ui.config.colors.secondary

function PANEL:Init()
   self.label = self:Add("tui.Label")
   self.label:SetContentAlignment(5) 
   self.label:Font("heading@21")

   self.close =  self:Add("tui.ImageButton")
   self.close:SetMaterial("mvp/terminal/close.png", "smooth")
   self.close:SetColorHover(mvp.ui.config.colors.red)
   self.close:SetColorPressed(mvp.ui.utils.EditHSVColor(mvp.ui.config.colors.red, nil, nil, 0.66))
   self.close:SetImageScale(.6)

   self.close.DoClick = function()
      self:GetParent():Close()
   end
end

function PANEL:Paint(w, h)
   draw.RoundedBoxEx(8, 0, 0, w, h, secondaryColor, true, true, false, false)
end

function PANEL:PerformLayout(w, h)
   self.label:SetSize(w, h)

   self.close:Dock(RIGHT)
   self.close:SetWide(h)
end

function PANEL:SetTitle(title)
    self.label:SetText(title)
end

mvp.ui.gui.Register("tui.Frame.Header", PANEL)

mvp.ui.gui.Test("tui.Frame", mvp.ui.scale.GetScaleX(1400), mvp.ui.scale.GetScaleY(800), function(pnl, w, h)
    pnl:MakePopup()
end)