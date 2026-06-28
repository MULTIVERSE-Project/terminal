PANEL = {}

local s = mvp.ui.Scale
local RNDX = mvp.RNDX


local CONTENT_MARGIN = s(55)
local HEADER_MARGIN = s(42)

local gradient1Mat, gradient2Mat = Material("mvp/terminal/vgui/frame/gradient1.png", "smooth"), Material("mvp/terminal/vgui/frame/gradient2.png", "smooth")
local foreground = Material("mvp/terminal/vgui/frame/foreground.png", "smooth")
local defaultBackground = Material("mvp/terminal/vgui/frame/default_background.png", "smooth")

local function rndxedMaterial(mat, x, y, w, h, color)
    return RNDX().Rect(x, y, w, h):Material(mat):Color(color)
end 

AccessorFunc(PANEL, "background", "Background")

function PANEL:Init()
    self:DockPadding(CONTENT_MARGIN, CONTENT_MARGIN, HEADER_MARGIN, CONTENT_MARGIN)
    self:SetBackground(defaultBackground)

    self._header = vgui.Create("mvp.v2.FrameHeader", self)
    self._header:Dock(TOP)
    self._header:DockMargin(0, 0, 0, HEADER_MARGIN)
    self._header:SetTall(s(54))

    self:Combine(self._header, "SetTitle")
    self:Combine(self._header, "SetSubTitle")
    self:Combine(self._header, "SetIcon")
    self:Combine(self._header, "SetPlayerInfoVisible")

    self._startTime = SysTime()
end

function PANEL:Clear()
    local children = self:GetChildren()
    for _, child in ipairs(children) do
        if (child ~= self._header and not child.PreventClear) then
            child:Remove()
        end
    end
end

function PANEL:SetBackground(bgLinkOrMaterial)
    self._background = mvp.ui.images.From(bgLinkOrMaterial, "smooth")
end

function PANEL:Paint(w, h)
    -- print(self:C("primary"))

    local blurValue = math.Approach(0.22, .65, (SysTime() - self._startTime) * .5)

    -- rndxedMaterial(testImage, 0, 0, w, h, color_white):Draw()

    if (self._background) then
        self._background:RNDX(0, 0, w, h, color_white):Draw()
    end

    if (self.AdditionalPaint) then
        self:AdditionalPaint(w, h)
    end

    RNDX().Rect(0, 0, w, h):Blur(blurValue):Draw()
    
    rndxedMaterial(foreground, 0, 0, w, h, color_white):Draw()
    rndxedMaterial(gradient1Mat, 0, 0, w, h, self:C("primary")):Draw()
    rndxedMaterial(gradient2Mat, 0, 0, w, h, self:C("primary", 0.55)):Draw()

end

mvp.ui.g.Register("mvp.v2.Frame", PANEL, "EditablePanel")

-- local wardrobeIcon = Material("mvp/perfectbodygroups/wardrobe.png", "smooth mips")
-- mvp.ui.g.Test("mvp.v2.Frame", 1, 1, function(frame)
--     frame:MakePopup()
--     frame:SetTitle("Персональные дела")
--     frame:SetSubTitle("Этот терминал позволяет вам просматривать и управлять персональные дела.")
--     frame:SetIcon(wardrobeIcon)
-- end) 
