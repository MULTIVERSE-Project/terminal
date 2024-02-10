local PANEL = {}

AccessorFunc(PANEL, "text", "Text", FORCE_STRING)
AccessorFunc(PANEL, "subText", "Description", FORCE_STRING)

AccessorFunc(PANEL, "textFont", "TextFont", FORCE_STRING)
AccessorFunc(PANEL, "subTextFont", "SubDescriptionFont", FORCE_STRING)

function PANEL:Init()
    self.text = ""
    self.subText = ""

    self.textFont = mvp.Font(28, 800)
    self.subTextFont = mvp.Font(22, 500)
end

function PANEL:Paint(w, h)
    draw.SimpleText(self.text, self.textFont, 0, h * 0.5 + 5, mvp.colors.Accent, nil, TEXT_ALIGN_BOTTOM)
    draw.SimpleText(self.subText, self.subTextFont, 0, h * 0.5 - 1, mvp.colors.Text, nil, TEXT_ALIGN_TOP)
end

vgui.Register("mvp.MenuHeader", PANEL, "Panel")