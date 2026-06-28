PANEL = {}

local s = mvp.ui.Scale
local RNDX = mvp.RNDX
local sf = mvp.ui.ScaleWithFactor
local closeMat = Material("mvp/terminal/vgui/close.png", "smooth")

local chevronMat = Material("mvp/terminal/vgui/frame/chevron.png", "smooth")
local chevronW, chevronH = s(30), s(78)
local iconSize = s(24)
local OUTLINE_COL = Color(151, 151, 151, 255 * .3)

AccessorFunc(PANEL, "_title", "Title", FORCE_STRING)
AccessorFunc(PANEL, "_subtitle", "SubTitle", FORCE_STRING)
AccessorFunc(PANEL, "_icon", "Icon")

local shadowColor = Color(0, 0, 0, 255 * .5)
local function drawText(text, font, x, y, color, alignX, alignY)
    draw.SimpleText(text, font, x + 2, y + 2, shadowColor, alignX, alignY)
    return draw.SimpleText(text, font, x, y, color, alignX, alignY)
end

function PANEL:Init()
    self:SetTitle("Little frame")
    self:SetSubTitle("In a full screen >-<")

    self._frame = self:GetParent()
    
    self._text = vgui.Create("EditablePanel", self)
    self._text:Dock(FILL)
    self._text.Paint = function(pnl, w, h)
        local x = 0
        local y = h * .5

        if (self._icon) then
            DisableClipping(true)
            
            RNDX().Rect(x, y - chevronH * .5, chevronW, chevronH)
                :Material(chevronMat)
                :Color(self:C("primary"))
                :Draw()

            self._icon:RNDX(x + (chevronW - iconSize) * .5, y - iconSize * .5, iconSize, iconSize, self:C("primary")):Draw()

            x = x + chevronW + s(10)
            DisableClipping(false)
        end

        drawText(self:GetTitle(), self:FF("header@semibold", 32), x, y + s(8), self:C("foreground"), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        drawText(self:GetSubTitle(), self:FF("default@light", 18), x, y + s(2), self:C("foreground", 0.75), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self._closeButton = vgui.Create("mvp.v2.Button", self)
    self._closeButton:SetOnlyIcon(true)
    self._closeButton:SetIcon(closeMat)
    self._closeButton:SetAlign(TEXT_ALIGN_CENTER)
    self._closeButton:SetCustomStyle(mvp.C("background"), mvp.C("error", 0.65), mvp.C("background", 0.35), mvp.C("foreground"))
    self._closeButton.DoClick = function()
        self._frame:Remove()
    end
end
function PANEL:SetIcon(icon, params)
    self._icon = mvp.ui.images.From(icon, params or "smooth")
end

MVP_FRAME_FIELD_AVATAR = 1
MVP_FRAME_FIELD_NAME = 2
MVP_FRAME_FIELD_JOB = 3
MVP_FRAME_FIELD_MONEY = 4

function PANEL:SetPlayerInfoVisible(visible, fields, ply)
    if (not visible and self._playerInfo) then
        self._playerInfo:Remove()
        self._playerInfo = nil

        self._closeButton:Dock(NODOCK)
    elseif (visible and not self._playerInfo) then
        ply = ply or LocalPlayer()

        fields = fields or {
            [MVP_FRAME_FIELD_AVATAR] = true,
            [MVP_FRAME_FIELD_NAME] = true,
            [MVP_FRAME_FIELD_JOB] = true,
            [MVP_FRAME_FIELD_MONEY] = true,
        }

        local subFields = {
            {
                id = MVP_FRAME_FIELD_MONEY,
                draw = function(x, y)
                    local moneyStr = mvp.gamemode.GetBalanceFormatted(ply)
                    local tw = draw.SimpleText(moneyStr, self:FF("default@medium", 16), x, y, self:C("foreground"), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

                    return tw
                end
            },
            {
                id = MVP_FRAME_FIELD_JOB,
                draw = function(x, y)
                    local jobTbl = mvp.gamemode.GetJobTable(ply)

                    local tw = draw.SimpleText(jobTbl and jobTbl.name or "Безработный", self:FF("default@medium", 16), x, y, jobTbl.color or self:C("foreground"), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

                    return tw
                end
            }
        }
        hook.Run("mvp.PopulatePlayerInfoFields", ply, subFields, #subFields)

        local hasFields = false
        for field, enabled in pairs(fields) do
            if ((field ~= MVP_FRAME_FIELD_AVATAR and field ~= MVP_FRAME_FIELD_NAME) and enabled) then

                local found = false
                for k, subField in ipairs(subFields) do
                    if (subField.id == field) then
                        found = true
                        break
                    end
                end
                if (not found) then
                    mvp.logger.Log(mvp.LOG.WARN, "FrameHeader", "Field with id '" .. field .. "' is enabled but not found in subFields. Please make sure to add it in the 'mvp.PopulatePlayerInfoFields' hook.")
                end

                hasFields = true
                break
            end
        end

        self._playerInfo = vgui.Create("DPanel", self)
        self._playerInfo:SetMouseInputEnabled(false)
        self._playerInfo:Dock(RIGHT)
        self._playerInfo:DockMargin(0, 0, s(8), 0)
        self._playerInfo:SetWide(s(350))

        self._closeButton:SetIconMultiplier(0.3)
        self._closeButton:Dock(RIGHT)
        self._closeButton:SetCustomStyle(mvp.C("error", .1, 100), mvp.C("error", 0.65, 150), mvp.C("background", 0.35), mvp.C("foreground"))


        local avatar
        
        if (fields[MVP_FRAME_FIELD_AVATAR]) then
            avatar = vgui.Create("AvatarImage", self._playerInfo)
            avatar:Dock(RIGHT)
            avatar:SetPlayer(ply, 128)
            avatar:SetPaintedManually(true)
        end

        
        self._playerInfo.Paint = function(pnl, w, h)
            local x = w - (fields[MVP_FRAME_FIELD_AVATAR] and (avatar:GetWide() + s(12)) or 0)

            -- RNDX().Rect(0, 0, w, h)
            --     :Color(self:C("background", nil, 100))
            --     :Rad(8)
            --     :Draw()

            if (avatar) then
                mvp.utils.MaskFn(function()
                    RNDX().Rect(w - h, 0, h, h)
                        :Rad(8)
                        :Draw()
                end, function()
                    avatar:PaintManual()
                end)
            end

            -- RNDX().Rect(0, 0, w, h)
            --     :Color(OUTLINE_COL)
            --     :Rad(8)
            --     :Outline(1)
            --     :Draw()

            if (fields[MVP_FRAME_FIELD_NAME]) then
                draw.SimpleText(ply:Nick(), self:FF("header@medium", 24), x, h * .5 + (hasFields and s(5) or 0), self:C("foreground"), TEXT_ALIGN_RIGHT, hasFields and TEXT_ALIGN_BOTTOM or TEXT_ALIGN_CENTER)
            end

            local cur = 0
            for k, field in ipairs(subFields) do
                if (not fields[field.id]) then continue end

                cur = cur + 1

                local fieldWidth = field.draw(x, h * .5, self:C("foreground"))
                x = x - fieldWidth - s(5)

                local hasOtherFields = false
                for j = k + 1, #subFields do
                    local nextField = subFields[j]
                    if (fields[nextField.id]) then
                        hasOtherFields = true
                        break
                    end
                end

                if (hasOtherFields) then
                    local sepW = draw.SimpleText("✦", self:FF("default@medium", 16), x, h * .5, self:C("foreground", .65), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                    x = x - sepW - s(5)
                end
            end
        end

        self._playerInfo.PerformLayout = function(pnl, w, h)
            avatar:SetWide(h)
            -- pnl:SetWide(totalW + s(16))
        end
    end
end

function PANEL:PerformLayout(w, h)

    if (self._playerInfo) then
        local closeBtnTall = self._closeButton:GetTall()
        self._closeButton:SetWide(closeBtnTall)
    else
        self._closeButton:SetSize(sf(32), sf(32))
        self._closeButton:SetPos(w - self._closeButton:GetWide() - s(8), 0)
    end
end

mvp.ui.g.Register("mvp.v2.FrameHeader", PANEL, "EditablePanel")

-- mvp.ui.g.Test("mvp.v2.Frame", 1, 1, function(frame)
--     frame:MakePopup()
--     frame:SetIcon(Material("mvp/terminal/notifications/success.png", "smooth mips"))

--     frame._header:SetPlayerInfoVisible(true, {
--         [MVP_FRAME_FIELD_AVATAR] = true,
--         [MVP_FRAME_FIELD_NAME] = true,
--         [MVP_FRAME_FIELD_JOB] = true,
--         [MVP_FRAME_FIELD_MONEY] = true,
--     })
-- end) 