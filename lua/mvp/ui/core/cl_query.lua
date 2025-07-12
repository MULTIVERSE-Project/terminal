mvp.ui = mvp.ui or {}

function mvp.ui.QueryText(title, description, placeHolder, okCallback, okText, cancelCallback, cancelText)
    local space = mvp.ui.scale.GetScaleY(5)
    local margin = mvp.ui.scale.GetScaleY(15)
    
    local frame = vgui.Create("tui.Frame")
    frame:SetTitle(title)
    frame:SetSize(ScrW() * .4, ScrH() * .25)
    frame:Center()
    frame:MakePopup()

    frame:ShowCloseButton(false)
    frame:Focus()

    local content = frame:Add("tui.Panel")
    content:Dock(FILL)
    content:DockMargin(margin, margin, margin, margin)

    local descriptionLabel = content:Add("tui.Label")
    descriptionLabel:Dock(TOP)
    descriptionLabel:SetText(description)
    descriptionLabel:SetAutoStretchVertical(true)
    descriptionLabel:DockMargin(0, 0, 0, space)

    local textEntry = content:Add("tui.TextEntry")
    textEntry:Dock(TOP)
    textEntry:SetPlaceholderText(placeHolder)
    textEntry:SetTall(mvp.ui.scale.GetScaleY(30))
    textEntry:DockMargin(0, 0, 0, space)

    local okBtn, cancelBtn = nil, nil
    
    local footer = content:Add("tui.Panel")
    footer:Dock(BOTTOM)
    footer:SetTall(mvp.ui.scale.GetScaleY(30))
    footer.PerformLayout = function(s, w, h)
        if (okBtn) then
            okBtn:SetSize(w * 0.5 - space, h)
            okBtn:Dock(LEFT)
        end
        if (cancelBtn) then
            cancelBtn:SetSize(w * 0.5 - space, h)
            cancelBtn:Dock(RIGHT)
        end        
    end

    okBtn = footer:Add("tui.Button")
    okBtn:SetText(okText or "OK")
    okBtn:SetColorIdle(mvp.ui.config.colors.green, 35)
    okBtn:SetGradientColor(mvp.ui.utils.EditHSVColor(mvp.ui.config.colors.green, nil, nil, 0.8))

    okBtn.DoClick = function()
        if (okCallback(textEntry:GetValue()) ~= false) then
            frame:Remove()
        end
    end

    cancelBtn = footer:Add("tui.Button")
    cancelBtn:SetText(cancelText or "Cancel")
    cancelBtn:SetColorIdle(mvp.ui.config.colors.red, 35)
    cancelBtn:SetGradientColor(mvp.ui.utils.EditHSVColor(mvp.ui.config.colors.red, nil, nil, 0.8))
    cancelBtn.DoClick = function()
        frame:Remove()
        if (cancelCallback) then
            cancelCallback()
        end
    end

    return frame
end