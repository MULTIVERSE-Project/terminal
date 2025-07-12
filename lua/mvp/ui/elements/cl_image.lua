local PANEL = {}

AccessorFunc(PANEL, "_material", "Material")
AccessorFunc(PANEL, "_color", "Color")

AccessorFunc(PANEL, "_imgWidth", "ImageWidth", FORCE_NUMBER)
AccessorFunc(PANEL, "_imgHeight", "ImageHeight", FORCE_NUMBER)
AccessorFunc(PANEL, "_imgScale", "ImageScale", FORCE_NUMBER)
AccessorFunc(PANEL, "_imgAngle", "ImageAngle", FORCE_NUMBER)

function PANEL:Init()
    self:SetImageScale(1)
    self:SetImageAngle(0)

    self:SetColor(color_white)
    self:SetMaterial("mvp/terminal/icons/question.png")
end

function PANEL:SetImageSize(w, h)
    h = h or w

    self:SetImageWidth(w)
    self:SetImageHeight(h)
end

function PANEL:SetMaterial(path, params)
    self._material = Material(path, params or "")
end

function PANEL:Paint(w, h)
    self:Call("PaintBackground", w, h)

    local material = self:GetMaterial()
    local color = self:GetColor()
    local scale = self:GetImageScale()
    local angle = self:GetImageAngle()

    local imgW, imgH = self:GetImageWidth() or w, self:GetImageHeight() or h
    local imgX, imgY = w * .5, h * .5

    imgW, imgH = imgW * scale, imgH * scale

    if (material) then
        mvp.ui.utils.DrawMaterialRotated(
            material,
            imgX, imgY,
            imgW, imgH,
            color,
            angle
        )
    end
end

mvp.ui.gui.Register("tui.Image", PANEL)

mvp.ui.gui.Test("tui.Frame", mvp.ui.scale.GetScaleX(1400), mvp.ui.scale.GetScaleY(800), function(pnl, w, h)
    pnl:MakePopup()
end)