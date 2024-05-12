mvp = mvp or {}
mvp.menus = mvp.menus or {}

mvp.menus.admin = mvp.menus.admin or {}

mvp.menus.admin.editedConfigs = mvp.menus.admin.editedConfigs or {}

local spaceBetween = mvp.ui.Scale(10)
local spacing = mvp.ui.Scale(10)

-- @notes: Maybe add a global storage for types and their input functions
local inputTypes = {
    -- 3 basic types
    [mvp.type.string] = function(config)
        local val = mvp.menus.admin.editedConfigs[config.key] or config.value
        
        local valueInput = vgui.Create("mvp.TextEntry")
        valueInput:SetRoundness(mvp.ui.ScaleWithFactor(8))
        
        valueInput:SetText(tostring(val))
        valueInput:SetUpdateOnType(true)

        function valueInput:OnValueChange(value)
            valueInput.UpdateConfigValue(value)
        end
        function valueInput:SetConfigValue(val)
            self:SetText(tostring(val))
        end

        return valueInput
    end,
    [mvp.type.number] = function(config)
        local val = mvp.menus.admin.editedConfigs[config.key] or config.value

        local valueInput = vgui.Create("mvp.TextEntry")
        valueInput:SetRoundness(mvp.ui.ScaleWithFactor(8))

        valueInput:SetText(tostring(val))
        valueInput:SetUpdateOnType(true)
        valueInput:SetNumeric(true)

        function valueInput:OnValueChange(value)
            valueInput.UpdateConfigValue(value)
        end
        function valueInput:SetConfigValue(val)
            self:SetText(tostring(val))
        end
        
        return valueInput
    end,
    [mvp.type.bool] = function(config)
        local val = config.value

        if (mvp.menus.admin.editedConfigs[config.key] ~= nil) then
            val = mvp.menus.admin.editedConfigs[config.key]
        end

        local valueInput = vgui.Create("mvp.CheckBox", configPanel)
        valueInput:SetRoundness(mvp.ui.ScaleWithFactor(8))

        valueInput:SetChecked(val)

        function valueInput:OnChanged(value)
            valueInput.UpdateConfigValue(value)
        end
        function valueInput:SetConfigValue(val)
            self:SetChecked(tobool(val))
        end


        return valueInput
    end,

    -- combo box
    ["dropdown"] = function(config)
        local val = mvp.menus.admin.editedConfigs[config.key] ~= nil and mvp.menus.admin.editedConfigs[config.key] or config.value
        
        local choices = config.ui.choices()
        local currentChoice = val

        local currentChoiceText = choices[currentChoice] or mvp.q.Lang("ui.general.none")

        local valueInput = vgui.Create("mvp.Button", configPanel)
        valueInput:SetRoundness(mvp.ui.ScaleWithFactor(8))
        valueInput:SetFont(mvp.Font(20, 500))
        valueInput:SetText(currentChoiceText)

        function valueInput:SetConfigValue(val)
            self:SetText(choices[val] or mvp.q.Lang("ui.general.none"))
        end

        valueInput.DoClick = function()
            local dropdown = vgui.Create("mvp.DropdownMenu")
            dropdown:SetRoundness(mvp.ui.ScaleWithFactor(8))
            dropdown:SetMinimumWidth(mvp.ui.Scale(200))

            for k, v in pairs(choices) do
                dropdown:AddOption(v, function()
                    valueInput:SetText(v)
                    valueInput.UpdateConfigValue(k)
                end)
            end

            local x, y = valueInput:LocalToScreen(0, valueInput:GetTall())

            dropdown:Open(x, y + spacing * .5)
        end

        return valueInput
    end,

    -- custom
    ["custom"] = function(config)
        local valueInput = vgui.Create("mvp.Button", configPanel)
        valueInput:SetRoundness(mvp.ui.ScaleWithFactor(8))
        valueInput:SetFont(mvp.Font(20, 500))
        valueInput:SetText(mvp.q.Lang("ui.general.edit"))

        function valueInput:DoClick()
            local value = mvp.menus.admin.editedConfigs[config.key] ~= nil and mvp.menus.admin.editedConfigs[config.key] or config.value
            config.ui.open(config, value, function(val)
                valueInput.UpdateConfigValue(val)
            end)
        end
        
        function valueInput:SetConfigValue(val)
            -- don't need this one here, since there no UI to update immediately
            -- leaving it here to avoid creating edge cases and errors
        end

        return valueInput
    end
}

function mvp.menus.admin.SettingsInput(container, restoreToDefaulButton, config)
    local inputType = config.ui.type and config.ui.type or config.typeOf
    local inputFunction = inputTypes[inputType]

    if (not inputFunction) then
        mvp.logger.Log(mvp.LOG.ERROR, nil, "No input function found for config " .. config.key)
        
        return
    end

    local onChange = function(value)
        mvp.menus.admin.editedConfigs[config.key] = value
    end

    local valueInput = inputFunction(config)
    valueInput.UpdateConfigValue = onChange

    valueInput:SetParent(container)
    valueInput:Dock(RIGHT)
    valueInput:DockMargin(0, spaceBetween * 1.3, spacing, spaceBetween * 1.3)
    valueInput:InvalidateParent(true)

    valueInput:SetWide(inputType == mvp.type.bool and valueInput:GetTall() or mvp.ui.Scale(200))

    restoreToDefaulButton.DoClick = function()
        valueInput:SetConfigValue(config.default)
        mvp.menus.admin.editedConfigs[config.key] = config.default
    end

    return valueInput
end

local restoreToDefaultMaterial
function mvp.menus.admin.SettingsCategory(container, configs)
    if (not restoreToDefaultMaterial) then
        restoreToDefaultMaterial = mvp.ui.images.Create("v_undo", "smooth")
    end

    for key, config in SortedPairsByMemberValue(configs, "sortIndex") do
        if (config.ui.hide) then continue end

        local configPanel = vgui.Create("EditablePanel", container)
        configPanel:Dock(TOP)
        configPanel:DockMargin(0, 0, 0, spaceBetween)
        configPanel:SetTall(mvp.ui.Scale(64))

        local description = mvp.q.Lang("value." .. config.key .. ".description")
        if (string.StartsWith(description, "notfound#")) then
            description = config.description
        end

        configPanel.Paint = function(pnl, w, h)
            draw.RoundedBox(mvp.ui.ScaleWithFactor(8), 0, 0, w, h, ColorAlpha(mvp.colors.SecondaryBackground, 150))

            draw.SimpleText(key, mvp.Font(22, 600), spacing, spacing, mvp.colors.Accent)
            draw.SimpleText(description, mvp.Font(20, 500), spacing, h - spacing, mvp.colors.Text, nil, TEXT_ALIGN_BOTTOM)
        end

        local restoreToDefault = vgui.Create("mvp.ImageButton", configPanel)
        restoreToDefault:Dock(RIGHT)
        restoreToDefault:DockMargin(0, spaceBetween * 1.3, spacing, spaceBetween * 1.3)
        restoreToDefault:InvalidateParent(true)

        restoreToDefault:SetWide(restoreToDefault:GetTall())

        restoreToDefault:SetFont(mvp.Font(20, 500))
        restoreToDefault:SetRoundness(mvp.ui.ScaleWithFactor(8))
        restoreToDefault:SetImage(restoreToDefaultMaterial)

        local valueInput = mvp.menus.admin.SettingsInput(configPanel, restoreToDefault, config)
    end
end

function mvp.menus.admin.SettingsSection(container, categories)
    local configContent = vgui.Create("mvp.CategoryList", container)
    configContent:Dock(FILL)

    for _, category in SortedPairsByMemberValue(categories, "sortIndex") do
        local categoryPanel = configContent:Add(mvp.q.Lang("section." .. category.section .. "." .. category.name))
        categoryPanel:SetExpanded(true)
        categoryPanel:DockMargin(0, 0, 0, spaceBetween)

        local categoryContent = vgui.Create("EditablePanel")

        mvp.menus.admin.SettingsCategory(categoryContent, category.configs)

        categoryPanel:SetContents(categoryContent)
    end
end

function mvp.menus.admin.Settings(container, defaultActive)
    defaultActive = defaultActive or "terminal"
    mvp.menus.admin.editedConfigs = {}

    local content = vgui.Create("EditablePanel", container)
    content:Dock(FILL)
    content:InvalidateParent(true)

    local title = vgui.Create("mvp.MenuHeader", content)
    title:Dock(TOP)
    title:SetTall(mvp.ui.Scale(64))  
    
    title:SetText(mvp.q.Lang("ui.config"))
    title:SetDescription(mvp.q.Lang("ui.config.description"))

    local saveConfig = vgui.Create("mvp.Button", title)
    saveConfig:Dock(RIGHT)
    saveConfig:DockMargin(0, spaceBetween, spaceBetween, spaceBetween)
    saveConfig:SetText(mvp.q.Lang("ui.config.save"))
    saveConfig:SetStyle("success")
    saveConfig:SetFont(mvp.Font(20, 500))
    saveConfig:SetEnabled(false)
    saveConfig:SetRoundness(mvp.ui.ScaleWithFactor(8))
    saveConfig:SetIcon(mvp.ui.images.Create("v_save", "mips"))
    saveConfig:SizeToContentsX(spaceBetween * 4)

    function saveConfig:DoClick()
        for k, v in pairs(mvp.menus.admin.editedConfigs) do
            mvp.config.Set(k, v)
        end
        mvp.menus.admin.editedConfigs = {}

        mvp.notification.Add(mvp.NOTIFICATION.SUCCESS, mvp.q.Lang("ui.config.saved"), mvp.q.Lang("ui.config.saved.description"))
    end

    function content:Think()
        local hasChanges = false
        for k, v in pairs(mvp.menus.admin.editedConfigs) do
            if (v == "") then
                mvp.menus.admin.editedConfigs[k] = nil
                continue 
            end

            if (mvp.config.Get(k) ~= v) then
                hasChanges = true
                break 
            end
        end

        saveConfig:SetEnabled(hasChanges)
    end

    local sections = mvp.config.sections
    local configSectionButtons = {}

    local pageContent = vgui.Create("EditablePanel", content)
    pageContent:Dock(FILL)

    local topNavigation = vgui.Create("DHorizontalScroller", pageContent)
    topNavigation:Dock(TOP)
    topNavigation:SetTall(mvp.ui.Scale(38))
    topNavigation:SetOverlap( -spaceBetween * .5 )

    local buttonGroup = vgui.Create("mvp.ButtonGroup")
    topNavigation:AddPanel(buttonGroup)
    buttonGroup:SetRoundness(mvp.ui.ScaleWithFactor(8))

    local configsSpace = vgui.Create("EditablePanel", pageContent)
    configsSpace:Dock(FILL)
    configsSpace:DockMargin(0, spaceBetween * .5, 0, 0)

    for k, v in SortedPairsByMemberValue(sections, "sortIndex") do
        local button = buttonGroup:AddButton(mvp.q.Lang("section." .. v.name), function()
            configsSpace:Clear()

            mvp.menus.admin.SettingsSection(configsSpace, v.categories)
        end)
        configSectionButtons[v.name] = button

        if (not configSectionButtons[defaultActive]) then
            defaultActive = v.name
        end
    end

    if (not configSectionButtons[defaultActive]) then
        defaultActive = "terminal"
    end

    configSectionButtons[defaultActive]:DoClick()
end