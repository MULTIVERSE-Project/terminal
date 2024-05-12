mvp = mvp or {}
mvp.meta.image = mvp.meta.image or {}

mvp.meta.image.__proto = mvp.meta.image
mvp.meta.image.__proto.isImage = true

mvp.meta.image.__proto._name = "Unnamed image"
AccessorFunc(mvp.meta.image, "_name", "Name")

mvp.meta.image.__proto._url = nil
AccessorFunc(mvp.meta.image, "_url", "URL")

mvp.meta.image.__proto._format = nil
AccessorFunc(mvp.meta.image, "_format", "Format")

mvp.meta.image.__proto._material = nil
AccessorFunc(mvp.meta.image, "_material", "Material")

mvp.meta.image.__proto._params = nil
AccessorFunc(mvp.meta.image, "_params", "Parameters")

function mvp.meta.image:New()
    local o = table.Copy(mvp.meta.image.__proto)

    setmetatable(o, mvp.meta.image)
    o.__index = self


    return o
end

function mvp.meta.image:Download()
    mvp.ui.images.QueueDownload(self)
end 

do
    local surface_SetMaterial = surface.SetMaterial
    local surface_SetDrawColor = surface.SetDrawColor
    local surface_DrawTexturedRect = surface.DrawTexturedRect
    local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated

    mvp.ui.images.Register("loading", "https://i.imgur.com/mBQx6t0.png")
    local loadingMat = mvp.ui.images.Create("loading", "smooth mips")

    function mvp.meta.image:Draw(x, y, w, h, color)
        color = color or color_white
        
        local mat = self._material
        if (mat) then 
            surface_SetMaterial(mat)
            surface_SetDrawColor(color)
            surface_DrawTexturedRect(x, y, w, h)
        elseif (loadingMat) then
            self._r = self._r or 0
            surface_SetMaterial(loadingMat:GetMaterial())
            surface_SetDrawColor(color_white)

            local rotationSpeed = 1 + math.abs(math.sin(CurTime()) * 3)
            self._r = self._r + (FrameTime()  * 80) * rotationSpeed
            
            surface_DrawTexturedRectRotated(x + w * .5, y + h * .5, w, h, -self._r)
        end
    end

    function mvp.meta.image:DrawRotated(x, y, w, h, r, color)
        color = color or color_white
        r = r or 0

        local mat = self._material
        if (mat) then 
            surface_SetMaterial(mat)
            surface_SetDrawColor(color)
            surface_DrawTexturedRectRotated(x, y, w, h, r)
        elseif (loadingMat) then
            self._r = self._r or 0
            surface_SetMaterial(loadingMat:GetMaterial())
            surface_SetDrawColor(color_white)

            local rotationSpeed = 1 + math.abs(math.sin(CurTime()) * 3)
            self._r = self._r + (FrameTime()  * 80) * rotationSpeed
            
            surface_DrawTexturedRectRotated(x, y, w, h, -self._r)
        end
    end
end

function mvp.meta.image:GetWidth()
    return self._material and self._material:Width() or 0
end

function mvp.meta.image:GetHeight()
    return self._material and self._material:Height() or 0
end