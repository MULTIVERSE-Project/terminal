mvp = mvp or {}
mvp.menus = mvp.menus or {}

mvp.menus.terminal = mvp.menus.terminal or {}
mvp.menus.terminal.frame = nil

local s = mvp.ui.Scale
local RNDX = mvp.RNDX
local OUTLINE_COL = Color(151, 151, 151, 255 * .3)

mvp.menus.terminal.packagesCache = mvp.menus.terminal.packagesCache or {
    fetchedAt = 0,
    packages = nil
}

mvp.menus.terminal.editedConfigs = mvp.menus.terminal.editedConfigs or {}
mvp.menus.terminal.inputTypes = {
    [mvp.type.string] = function(config)
        local currentValue = mvp.menus.terminal.editedConfigs[config.key] or config.value

        local valueInput = vgui.Create("mvp.v2.TextInput")
        -- valueInput:SetRoundness(mvp.ui.ScaleWithFactor(8))
        valueInput:SetWide(s(200))
        valueInput:SetValue(tostring(currentValue))
        valueInput:SetUpdateOnType(true)

        function valueInput:OnValueChange(value)
            valueInput.UpdateConfigValue(value)
        end
        function valueInput:SetConfigValue(val)
            self:KillFocus()

            timer.Simple(0, function()
                self:SetValue(tostring(val))
            end)
        end

        return valueInput
    end,
    [mvp.type.number] = function(config)
        local currentValue = mvp.menus.terminal.editedConfigs[config.key] or config.value

        local valueInput = vgui.Create("mvp.v2.TextInput")
        -- valueInput:SetRoundness(mvp.ui.ScaleWithFactor(8))
        valueInput:SetWide(s(200))
        valueInput:SetValue(tostring(currentValue))
        valueInput:SetUpdateOnType(true)
        valueInput:SetNumeric(true)

        function valueInput:OnValueChange(value)
            valueInput.UpdateConfigValue(tonumber(value))
        end
        function valueInput:SetConfigValue(val)
            self:KillFocus()

            timer.Simple(0, function()
                self:SetValue(tostring(val))
            end)
        end
        
        return valueInput
    end,

    [mvp.type.bool] = function(config)
        local currentValue = config.value
        if (mvp.menus.terminal.editedConfigs[config.key] ~= nil) then
            currentValue = mvp.menus.terminal.editedConfigs[config.key]
        end

        local valueInput = vgui.Create("mvp.v2.Checkbox")
        valueInput:SetChecked(currentValue)

        function valueInput:OnValueChange(value)
            valueInput.UpdateConfigValue(value)
        end
        function valueInput:SetConfigValue(val)
            self:SetValue(val)
        end

        function valueInput:PerformLayout(w, h)
            if (self:GetWide() ~= h) then
                self:SetWide(h)
            end
        end

        return valueInput
    end,

    ["dropdown"] = function(config)
        local val = mvp.menus.terminal.editedConfigs[config.key] ~= nil and mvp.menus.terminal.editedConfigs[config.key] or config.value
        
        local choices = config.ui.choices()
        local currentChoice = val

        local currentChoiceText = choices[currentChoice] or mvp.q.Lang("ui.general.none")

        local valueInput = vgui.Create("mvp.v2.Button", configPanel)
        valueInput:SetFont(mvp.Font(20, 500))
        valueInput:SetText(currentChoiceText)
        valueInput:SetStyle(MVP_STYLE_SECONDARY)
        valueInput:SetWide(s(200))

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

            dropdown:Open(x, y + s(10) * .5)
        end

        return valueInput
    end,

    ["custom"] = function(config, content)
        local currentValue = mvp.menus.terminal.editedConfigs[config.key] or config.value

        local editButton = vgui.Create("mvp.v2.Button")
        editButton:SetText(mvp.q.Lang("ui.general.open_editor"))
        editButton:SetStyle(MVP_STYLE_PRIMARY)
        editButton:SetWide(s(250))

        function editButton:OnValueChange(value)
            editButton.UpdateConfigValue(value)
        end
        function editButton:SetConfigValue(val)
            -- self:SetText(tostring(val))
        end

        function editButton:DoClick()
            local _, category = mvp.config.GetCategory(config.category)
            local section = mvp.config.GetSection(category.section)
            
            if (section.packageId == "terminal") then
                mvp.menus.terminal.Open("settings", section.name, config.key)
            else
                mvp.menus.terminal.Open("packages", section.packageId, section.name, config.key)
            end
        end

        return editButton
    end,
}

mvp.menus.terminal.inputFiels = {}
local function onChangeFuncBuilder(config)
    return function(value)
        if (value == config.value) then
            mvp.menus.terminal.editedConfigs[config.key] = nil
            mvp.menus.terminal.frame:Call("ConfigEdited", true)
            return
        end


        mvp.menus.terminal.editedConfigs[config.key] = value
        mvp.menus.terminal.frame:Call("ConfigEdited", true)
    end
end
local function buildSection(sectionContent, section)
    local categoryList = vgui.Create("mvp.v2.CategoryList", sectionContent)
    categoryList:Dock(FILL)

    for _, category in SortedPairsByMemberValue(section.categories, "sortIndex") do
        local catPanel = categoryList:AddCategory(mvp.q.Lang("section." .. section.name .. "." .. category.name) or category.name)

        for configIndex, config in SortedPairsByMemberValue(category.configs, "sortIndex") do
            if (config.ui and config.ui.hide) then
                if (isfunction(config.ui.hide)) then
                    if (config.ui.hide(config)) then
                        continue
                    end
                else
                    continue
                end
            end

            local inputType = config.ui.type and config.ui.type or config.typeOf
            local inputBuilder = mvp.menus.terminal.inputTypes[inputType] or nil

            local configPanel = vgui.Create("mvp.v2.Panel", catPanel)
            configPanel:Dock(TOP)
            configPanel:DockMargin(0, s(8), 0, 0)

            configPanel:SetTall(s(72))

            -- configPanel:SetConfigData(config)

            configPanel.Paint = function(pnl, w, h)
                RNDX().Rect(0, 0, w, h)
                    :Color(pnl:C("secondary", nil, 180))
                    :Rad(8)
                    :Draw()

                RNDX().Rect(1, 1, w - 2, h - 2)
                    :Color(OUTLINE_COL)
                    :Rad(8)
                    :Outline(1)
                    :Draw()

                draw.SimpleText(
                    mvp.q.LangFallback("value." .. config.key, config.key) or config.key,
                    pnl:FF("header@bold", 18),
                    s(12),
                    h * .2,
                    pnl:C("foreground"),
                    TEXT_ALIGN_LEFT,
                    TEXT_ALIGN_TOP
                )
                draw.SimpleText(
                    mvp.q.LangFallback("value." .. config.key .. ".description", config.description or "This is a configuration value."),
                    pnl:FF("default@light", 14),
                    s(12),
                    h * .5,
                    pnl:C("foreground", 0.75),
                    TEXT_ALIGN_LEFT,
                    TEXT_ALIGN_TOP,
                    w - s(24)
                )

                if (not inputBuilder) then
                    draw.SimpleText(
                        "Missing input type: " .. tostring(inputType),
                        pnl:FF("default@bold", 16),
                        w - s(12),
                        h * .5,
                        Color(255, 100, 100),
                        TEXT_ALIGN_RIGHT,
                        TEXT_ALIGN_CENTER
                    )
                end
            end

            local restoreToDefault
            if (inputType ~= "custom" and inputBuilder) then
                restoreToDefault = vgui.Create("mvp.v2.Button", configPanel)
                restoreToDefault:Dock(RIGHT)
                restoreToDefault:DockMargin(0, s(18), s(12), s(18))
                restoreToDefault:InvalidateParent(true)

                restoreToDefault:SetWide(restoreToDefault:GetTall())
                restoreToDefault:SetText("")
                restoreToDefault:SetIcon(Material("mvp/terminal/vgui/refresh.png", "smooth"))
                restoreToDefault:SetIconMultiplier(0.65)
                restoreToDefault:SetStyle(MVP_STYLE_SECONDARY)
                restoreToDefault:SetAlign(TEXT_ALIGN_CENTER)  
            end

            if (not inputBuilder) then
                continue
            end

            local inputPanel = inputBuilder(config, sectionContent)
            inputPanel.UpdateConfigValue = onChangeFuncBuilder(config)

            inputPanel:SetParent(configPanel)
            inputPanel:Dock(RIGHT)
            inputPanel:DockMargin(0, s(18), s(12), s(18))
            inputPanel:InvalidateParent(true)

            inputPanel.Reset = function(pnl)
                local valueToSet = config.default

                if (valueToSet ~= mvp.menus.terminal.editedConfigs[config.key] or valueToSet ~= config.value) then
                    pnl:SetConfigValue(valueToSet)
                end
            end
            inputPanel.ResetToStored = function(pnl)
                local storedValue = mvp.config.Get(config.key)

                if (storedValue ~= mvp.menus.terminal.editedConfigs[config.key]) then
                    pnl:SetConfigValue(storedValue)
                end
            end

            mvp.menus.terminal.inputFiels[config.key] = inputPanel

            if (restoreToDefault) then
                restoreToDefault.DoClick = function()
                    inputPanel:Reset()
                end
            end
        end
    end

    return categoryList
end
local function buildSectionsTabs(parent, content, sections, defaultSection)
    local selected = nil
    local sectionsButtonContainer = vgui.Create("mvp.v2.Panel", parent)
    sectionsButtonContainer:Dock(LEFT)
    sectionsButtonContainer:DockPadding(s(3), s(3), s(3), s(3))
    -- sectionsButtonContainer:SetTall(s(45))

    sectionsButtonContainer._currentX = 0
    sectionsButtonContainer._currentW = nil
    sectionsButtonContainer.Paint = function(pnl, w, h)
        RNDX().Rect(0, 0, w, h)
            :Color(pnl:C("background", 0.1, 100))
            :Rad(8)
            :Draw()

        if (selected and IsValid(selected)) then
            if (not pnl._currentW) then
                pnl._currentW = selected:GetWide()
            end

            pnl._currentX = Lerp(FrameTime() * 10, pnl._currentX, selected:GetX() - s(3))
            pnl._currentW = Lerp(FrameTime() * 10, pnl._currentW, selected:GetWide() + s(6))

            RNDX().Rect(pnl._currentX, 0, pnl._currentW, h)
                :Color(pnl:C("primary"))
                :Rad(8)
                :Draw()
        end
    end

    sectionsButtonContainer.PerformLayout = function(pnl)
        local children = pnl:GetChildren()
        local totalW = 0

        for _, child in ipairs(children) do
            totalW = totalW + child:GetWide()
        end

        totalW = totalW + s(6)

        pnl:SetWide(totalW)
    end

    local counter = 0
    local sectionsNum = table.Count(sections)

    local sectionContent = vgui.Create("mvp.v2.Panel", content)
    sectionContent:Dock(FILL)
    sectionContent:DockMargin(0, s(10), 0, 0)

    for k, v in SortedPairsByMemberValue(sections, "sortIndex") do
        counter = counter + 1

        local btn = vgui.Create("mvp.v2.Button", sectionsButtonContainer)
        btn:Dock(LEFT)
        btn:DockMargin(0, 0, 0, 0)
        btn:SetText(mvp.q.Lang("section." .. v.name) or k)
        btn:SizeToContentsX(s(15))

        btn:SetStyle(MVP_STYLE_SECONDARY)
        btn:SetRadii(
            counter == 1 and 8 or 0,
            counter == sectionsNum and 8 or 0,
            counter == 1 and 8 or 0,
            counter == sectionsNum and 8 or 0
        )

        if (counter > 1) then
            btn:DockMargin(-1, 0, 0, 0)
        end
        btn.DoClick = function(pnl)
            selected = pnl

            sectionContent:Clear()
            buildSection(sectionContent, v)
        end

        if (defaultSection and defaultSection == k) then
            btn:DoClick()
        end
        if (not selected) then
            btn:DoClick()
        end
    end
end
local function getPackagesInfo()
    local installedPackages = mvp.package.GetAll()
    local availablePackages = {}

    for k, v in pairs(mvp.menus.terminal.packagesCache.packages or {}) do
        if (not installedPackages[v.id] and v.available ~= false) then
            table.insert(availablePackages, v)
        end
    end

    return installedPackages, availablePackages
end
local function getPackageInfo(id)
    local pkgs = mvp.menus.terminal.packagesCache.packages or {}

    for k, v in pairs(pkgs) do
        if (v.id == id) then
            return v
        end
    end

    return nil
end

mvp.menus.terminal.pages = {
    {
        id = "dashboard",
        icon = Material("mvp/terminal/home.png", "smooth"),
        onClick = function(content)
            local header = vgui.Create("mvp.v2.Panel", content)
            header:Dock(TOP)
            header:SetTall(s(30))

            header.Paint = function(pnl, w, h)
                local hw = draw.SimpleText("Dashboard", pnl:FF("header@semibold", 24), 0, h * .5, pnl:C("foreground"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                local sw = draw.SimpleText("make Terminal yours", pnl:FF("default@light", 16), w, h * .5, pnl:C("foreground", 0.65), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

                RNDX().Rect(hw + s(15), h * .5 - 1, w - hw - sw - s(30), 2)
                    :Color(pnl:C("foreground", 0.65))
                    :Draw()
            end

            local notice = vgui.Create("mvp.v2.Panel", content)
            notice:Dock(TOP)
            notice:DockMargin(0, s(10), 0, 0)
            notice:SetTall(s(120))

            notice.Paint = function(pnl, w, h)
                local y = 0
                local _, th = draw.SimpleText("Welcome to Terminal!", pnl:FF("default@semibold", 16), s(12), 0, pnl:C("foreground"), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                y = y + th + s(10)

                _, th = draw.SimpleText("This is updated look of Terminal. We're still working on the dashboard page.", pnl:FF("default@light", 14), s(12), y, pnl:C("foreground", 0.75), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                y = y + th + s(10)

                _, th = draw.SimpleText("You can access settings and packages from the left menu.", pnl:FF("default@light", 14), s(12), y, pnl:C("foreground", 0.75), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                y = y + th
                _, th = draw.SimpleText("Setting for Terminal are under \"Settings\" page, settings for individual packages can be found on their respective pages in the \"Packages\" section.", pnl:FF("default@light", 14), s(12), y, pnl:C("foreground", 0.75), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end,
    },
    {
        id = "settings",
        icon = Material("mvp/terminal/settings.png", "smooth"),
        onClick = function(content, extra)
            local sectionId = extra[1] or nil
            local customConfigKey = extra[2] or nil

            local header = vgui.Create("mvp.v2.Panel", content)
            header:Dock(TOP)
            header:SetTall(s(30))

            local headerText = "Settings"

            header.Paint = function(pnl, w, h)
                local hw = draw.SimpleText(headerText, pnl:FF("header@semibold", 24), 0, h * .5, pnl:C("foreground"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                local sw = draw.SimpleText("make Terminal yours", pnl:FF("default@light", 16), w, h * .5, pnl:C("foreground", 0.65), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

                RNDX().Rect(hw + s(15), h * .5 - 1, w - hw - sw - s(30), 2)
                    :Color(pnl:C("foreground", 0.65))
                    :Draw()
            end

            local sections = mvp.config.GetSections("terminal")

            local topBar = vgui.Create("mvp.v2.Panel", content)
            topBar:Dock(TOP)
            topBar:DockMargin(0, s(10), 0, 0)
            topBar:SetTall(s(42))

            if (customConfigKey) then
                local config = mvp.config.GetStored(customConfigKey)
                local inputType = config.ui.type and config.ui.type or config.typeOf
                if (config and inputType == "custom") then
                    local backButton = vgui.Create("mvp.v2.Button", topBar)
                    backButton:Dock(LEFT)
                    backButton:DockMargin(0, s(3), s(10), s(3))
                    backButton:SetStyle(MVP_STYLE_SECONDARY)
                    backButton:SetText()
                    backButton:SetIcon(Material("mvp/terminal/vgui/undo.png", "smooth"))
                    -- backButton:SetIconMultiplier(0.6)
                    backButton:SetAlign(TEXT_ALIGN_CENTER)
                    backButton:SizeToContentsX()

                    backButton.DoClick = function()
                        mvp.menus.terminal.Open("settings", sectionId)
                    end

                    headerText = mvp.q.Lang("menu.terminal.settings") .. " / " .. (mvp.q.Lang("value." .. config.key) or config.key)

                    if (config.ui.customTools) then
                        for _, tool in pairs(config.ui.customTools) do
                            local toolButton = vgui.Create("mvp.v2.Button", topBar)
                            toolButton:Dock(LEFT)
                            toolButton:DockMargin(0, s(3), s(10), s(3))
                            toolButton:SetStyle(MVP_STYLE_SECONDARY)
                            toolButton:SetText(tool.text)
                            if (tool.icon) then
                                toolButton:SetIcon(tool.icon)
                                toolButton:SetIconMultiplier(0.7)
                            end
                            toolButton:SizeToContentsX(s(15))

                            toolButton.DoClick = function()
                                if (tool.onClick) then
                                    tool.onClick(config, mvp.menus.terminal.editedConfigs[config.key] or config.value)
                                end
                            end
                        end
                    end

                    local onChangeFunc = onChangeFuncBuilder(config)

                    if (config.ui.onOpenEditor) then
                        config.ui.onOpenEditor(config, mvp.menus.terminal.editedConfigs[config.key] or config.value, onChangeFunc, content, backButton)
                    end

                    return 
                end                
            end

            buildSectionsTabs(topBar, content, sections, sectionId)
        end,
    },
    {
        id = "packages",
        icon = Material("mvp/terminal/packages.png", "smooth"),
        onClick = function(content, extra)
            local packageId = extra[1] or nil
            local sectionId = extra[2] or nil
            local customConfigKey = extra[3] or nil
            
            local headerText = "Packages"

            local header = vgui.Create("mvp.v2.Panel", content)
            header:Dock(TOP)
            header:SetTall(s(30))

            header.Paint = function(pnl, w, h)
                local hw = draw.SimpleText(headerText, pnl:FF("header@semibold", 24), 0, h * .5, pnl:C("foreground"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                local sw = draw.SimpleText("build your Terminal", pnl:FF("default@light", 16), w, h * .5, pnl:C("foreground", 0.65), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

                RNDX().Rect(hw + s(15), h * .5 - 1, w - hw - sw - s(30), 2)
                    :Color(pnl:C("foreground", 0.65))
                    :Draw()
            end

            local topBar = vgui.Create("mvp.v2.Panel", content)
            topBar:Dock(TOP)
            topBar:DockMargin(0, s(10), 0, 0)
            topBar:SetTall(s(42))

            if (customConfigKey) then
                local pkg = mvp.package.Get(packageId)
                local config = mvp.config.GetStored(customConfigKey)
                local inputType = config.ui.type and config.ui.type or config.typeOf
                if (config and inputType == "custom") then
                    local backButton = vgui.Create("mvp.v2.Button", topBar)
                    backButton:Dock(LEFT)
                    backButton:DockMargin(0, s(3), s(10), s(3))
                    backButton:SetStyle(MVP_STYLE_SECONDARY)
                    backButton:SetText()
                    backButton:SetIcon(Material("mvp/terminal/vgui/undo.png", "smooth"))
                    -- backButton:SetIconMultiplier(0.6)
                    backButton:SetAlign(TEXT_ALIGN_CENTER)
                    backButton:SizeToContentsX()

                    backButton.DoClick = function()
                        mvp.menus.terminal.Open("packages", packageId, sectionId)
                    end

                    headerText = mvp.q.Lang("menu.terminal.packages") .. " / " .. pkg:GetName() .. " / " .. (mvp.q.Lang("value." .. config.key) or config.key)

                    if (config.ui.customTools) then
                        for _, tool in pairs(config.ui.customTools) do
                            local toolButton = vgui.Create("mvp.v2.Button", topBar)
                            toolButton:Dock(LEFT)
                            toolButton:DockMargin(0, s(3), s(10), s(3))
                            toolButton:SetStyle(MVP_STYLE_SECONDARY)
                            toolButton:SetText(tool.text)
                            if (tool.icon) then
                                toolButton:SetIcon(tool.icon)
                                toolButton:SetIconMultiplier(0.7)
                            end
                            toolButton:SizeToContentsX(s(15))

                            toolButton.DoClick = function()
                                if (tool.onClick) then
                                    tool.onClick(config, mvp.menus.terminal.editedConfigs[config.key] or config.value)
                                end
                            end
                        end
                    end

                    local onChangeFunc = onChangeFuncBuilder(config)

                    if (config.ui.onOpenEditor) then
                        config.ui.onOpenEditor(config, mvp.menus.terminal.editedConfigs[config.key] or config.value, onChangeFunc, content, backButton)
                    end

                    return 
                end
            end

            if (packageId) then
                local v = mvp.package.Get(packageId)
                local sections = mvp.config.GetSections(packageId)
                if (table.Count(sections) ~= 0) then
                    topBar:Clear()

                    local backButton = vgui.Create("mvp.v2.Button", topBar)
                    backButton:Dock(LEFT)
                    backButton:DockMargin(0, s(3), s(10), s(3))
                    backButton:SetStyle(MVP_STYLE_SECONDARY)
                    backButton:SetText()
                    backButton:SetIcon(Material("mvp/terminal/vgui/undo.png", "smooth"))
                    -- backButton:SetIconMultiplier(0.6)
                    backButton:SetAlign(TEXT_ALIGN_CENTER)
                    backButton:SizeToContentsX()

                    backButton.DoClick = function()
                        mvp.menus.terminal.Open("packages")
                    end

                    headerText = mvp.q.Lang("menu.terminal.packages") .. " / " .. (v:GetName() or "Package")
                    buildSectionsTabs(topBar, content, sections, sectionId)
                end

                return 
            end

            local refreshPackages = vgui.Create("mvp.v2.Button", topBar)
            refreshPackages:Dock(LEFT)
            refreshPackages:DockMargin(0, s(3), 0, s(3))
            -- refreshPackages:SetWide(s(180))
            refreshPackages:SetStyle(MVP_STYLE_SECONDARY)
            refreshPackages:SetText("Refresh Packages")
            refreshPackages:SetIcon(Material("mvp/terminal/vgui/refresh.png", "smooth"))
            refreshPackages:SetIconMultiplier(0.7)
            refreshPackages:SizeToContentsX(s(15))

            refreshPackages.DoClick = function(pnl)
                http.Fetch("https://raw.githubusercontent.com/MULTIVERSE-Project/terminal/refs/heads/lists/packages-list.json",
                    function(body, len, headers, code)
                        local suc, data = pcall(util.JSONToTable, body)

                        if (suc and data) then
                            mvp.menus.terminal.packagesCache.packages = data
                            mvp.menus.terminal.packagesCache.fetchedAt = CurTime()

                            -- mvp.q.Notify("Packages list updated.", NOTIFY_SUCCESS)
                            mvp.q.NotifySuccess("Packages", "Packages list updated.", 5)
                        else
                            mvp.q.NotifyError("Packages", "Failed to update packages list. Invalid data received.", 5)
                            -- mvp.q.Notify("Failed to update packages list. Invalid data received.", NOTIFY_ERROR)
                        end

                        hook.Run("mvp.terminal.PackagesListUpdated", suc and data or nil)
                    end,
                    function(error)
                        -- mvp.q.Notify("Failed to update packages list. Error: " .. error, NOTIFY_ERROR)
                        mvp.q.NotifyError("Packages", "Failed to update packages list. Error: " .. error, 5)
                    end
                )
            end

            local packagesList = vgui.Create("mvp.v2.CategoryList", content)
            packagesList:Dock(FILL)
            packagesList:DockMargin(0, s(10), 0, 0)

            local installedPackages, availablePackages = getPackagesInfo()

            local installedCat = packagesList:AddCategory("Installed Packages (" .. table.Count(installedPackages) .. ")")
            local availableCat = packagesList:AddCategory("Available Packages (" .. #availablePackages .. ")")

            local function populateCategories()
                local installedGrid = vgui.Create("mvp.v2.Grid", installedCat)
                installedGrid:Dock(TOP)
                installedGrid:SetColumnCount(3)
                installedGrid:SetSpaceX(s(5))
                installedGrid:SetSpaceY(s(5))
                
                for k, v in pairs(installedPackages) do
                    local pkgPanel = vgui.Create("mvp.v2.Panel", installedGrid)
                    pkgPanel:SetTall(s(85))

                    pkgPanel.Paint = function(pnl, w, h)
                        RNDX().Rect(0, 0, w, h)
                            :Color(pnl:C("secondary", nil, 180))
                            :Rad(8)
                            :Draw()

                        RNDX().Rect(1, 1, w - 2, h - 2)
                            :Color(OUTLINE_COL)
                            :Rad(8)
                            :Outline(1)
                            :Draw()

                        local x = s(10)

                        RNDX().Rect(x, h * .5 - s(32), s(64), s(64))
                            :Color(pnl:C("background"))
                            :Rad(16)
                            :Draw()

                        if (v.icon) then
                            local iconMat = mvp.ui.images.From(v.icon, "smooth")

                            iconMat:RNDX(x, h * .5 - s(32), s(64), s(64))
                                :Rad(16)
                                :Draw()
                        else
                            draw.SimpleText(
                                "?",
                                pnl:FF("header@bold", 48),
                                x + s(32),
                                h * .5,
                                pnl:C("foreground", 0.5),
                                TEXT_ALIGN_CENTER,
                                TEXT_ALIGN_CENTER
                            )
                        end

                        x = x + s(74)

                        draw.SimpleText(
                            v:GetName(),
                            pnl:FF("header@semibold", 24),
                            x,
                            h * .5 + s(8),
                            pnl:C("foreground"),
                            TEXT_ALIGN_LEFT,
                            TEXT_ALIGN_BOTTOM
                        )
                        draw.SimpleText(
                            string.format("by %s - v%s", v:GetAuthor() or "Unknown", v:GetVersion() or "N/A"),
                            pnl:FF("default@regular", 13),
                            x,
                            h * .5,
                            pnl:C("foreground", 0.75),
                            TEXT_ALIGN_LEFT,
                            TEXT_ALIGN_TOP
                        )
                    end

                    local buttonsContainer = vgui.Create("mvp.v2.Panel", pkgPanel)
                    buttonsContainer:Dock(FILL)
                    buttonsContainer:DockMargin(0, s(10), s(10), s(10))

                    local pkgInfo = getPackageInfo(v:GetID())
                    
                    if (pkgInfo) then
                        local linkType = pkgInfo and (pkgInfo.links and (pkgInfo.links.workshop and "workshop" or pkgInfo.links.store and "store") or nil) or nil
                        local link = linkType and pkgInfo.links[linkType] or nil

                        local currVersion = tonumber(string.Replace(v:GetVersion(), ".", "")) or 0
                        local latestVersion = tonumber(string.Replace(pkgInfo.version or "0", ".", "")) or 0

                        local updateButton = vgui.Create("mvp.v2.Button", buttonsContainer)
                        updateButton:SetTall(s(30))
                        -- updateButton:SetStyle(MVP_STYLE_PRIMARY)
                        updateButton:SetText("Update available")

                        if (linkType == "workshop" or linkType == "store") then
                            local iconPath = "mvp/terminal/vgui/" .. linkType .. ".png"
                            updateButton:SetIcon(Material(iconPath, "smooth"))
                            updateButton:SetIconMultiplier(0.7)
                        end

                        if (latestVersion > currVersion) then
                            updateButton:SetStyle(MVP_STYLE_PRIMARY)
                            updateButton.DoClick = function()
                                gui.OpenURL(link)
                            end
                        else
                            updateButton:SetStyle(MVP_STYLE_SUCCESS)
                            updateButton:SetText("Up to date")
                            updateButton:SetDisabled(true)
                            updateButton.DoClick = function()  end
                        end
                    else
                        local unknowPackageButton = vgui.Create("mvp.v2.Button", buttonsContainer)
                        unknowPackageButton:SetTall(s(30))
                        unknowPackageButton:SetStyle(MVP_STYLE_ERROR)
                        unknowPackageButton:SetText("Unknown package")
                        unknowPackageButton:SetDisabled(true)
                    end

                    local sections = mvp.config.GetSections(v:GetID())
                    local configButton = vgui.Create("mvp.v2.Button", buttonsContainer)
                    configButton:SetTall(s(30))
                    configButton:SetStyle(MVP_STYLE_SECONDARY)
                    configButton:SetText("Settings")
                    configButton:SetIcon(Material("mvp/terminal/settings.png", "smooth"))
                    configButton:SetIconMultiplier(0.7)

                    if (table.Count(sections) == 0) then
                        configButton:SetDisabled(true)
                    else
                        configButton.DoClick = function()
                            packagesList:Remove()
                            topBar:Clear()

                            local backButton = vgui.Create("mvp.v2.Button", topBar)
                            backButton:Dock(LEFT)
                            backButton:DockMargin(0, s(3), s(10), s(3))
                            backButton:SetStyle(MVP_STYLE_SECONDARY)
                            backButton:SetText()
                            backButton:SetIcon(Material("mvp/terminal/vgui/undo.png", "smooth"))
                            -- backButton:SetIconMultiplier(0.6)
                            backButton:SetAlign(TEXT_ALIGN_CENTER)
                            backButton:SizeToContentsX()

                            backButton.DoClick = function()
                                mvp.menus.terminal.Open("packages")
                            end

                            headerText = mvp.q.Lang("menu.terminal.packages") .. " / " .. (v:GetName() or "Package")
                            buildSectionsTabs(topBar, content, sections)
                        end
                    end

                    buttonsContainer.PerformLayout = function(pnl)
                        local children = pnl:GetChildren()
                        local currentY = 0

                        for _, child in ipairs(children) do
                            child:SizeToContentsX(s(15))
                            child:SetY(currentY)
                            child:SetX(pnl:GetWide() - child:GetWide())

                            currentY = currentY + child:GetTall() + s(5)
                        end
                    end
                end

                local availableGrid = vgui.Create("mvp.v2.Grid", availableCat)
                availableGrid:Dock(TOP)
                availableGrid:SetColumnCount(3)
                availableGrid:SetSpaceX(s(5))
                availableGrid:SetSpaceY(s(5))

                for _, v in ipairs(availablePackages) do
                    local pkgPanel = vgui.Create("mvp.v2.Panel", availableGrid)
                    pkgPanel:SetTall(s(85))

                    pkgPanel.Paint = function(pnl, w, h)
                        RNDX().Rect(0, 0, w, h)
                            :Color(pnl:C("secondary", nil, 180))
                            :Rad(8)
                            :Draw()

                        RNDX().Rect(1, 1, w - 2, h - 2)
                            :Color(OUTLINE_COL)
                            :Rad(8)
                            :Outline(1)
                            :Draw()

                        local x = s(10)

                        RNDX().Rect(x, h * .5 - s(32), s(64), s(64))
                            :Color(pnl:C("background"))
                            :Rad(16)
                            :Draw()

                        if (v.icon) then
                            local iconMat = mvp.ui.images.From(v.icon, "smooth")

                            iconMat:RNDX(x, h * .5 - s(32), s(64), s(64))
                                :Rad(16)
                                :Draw()
                        else
                            draw.SimpleText(
                                "?",
                                pnl:FF("header@bold", 48),
                                x + s(32),
                                h * .5,
                                pnl:C("foreground", 0.5),
                                TEXT_ALIGN_CENTER,
                                TEXT_ALIGN_CENTER
                            )
                        end

                        x = x + s(74)

                        draw.SimpleText(
                            v.name,
                            pnl:FF("header@semibold", 24),
                            x,
                            h * .5 + s(8),
                            pnl:C("foreground"),
                            TEXT_ALIGN_LEFT,
                            TEXT_ALIGN_BOTTOM
                        )
                        draw.SimpleText(
                            string.format("by %s - v%s", v.author or "Unknown", v.version or "N/A"),
                            pnl:FF("default@regular", 13),
                            x,
                            h * .5,
                            pnl:C("foreground", 0.75),
                            TEXT_ALIGN_LEFT,
                            TEXT_ALIGN_TOP
                        )
                    end

                    local buttonsContainer = vgui.Create("mvp.v2.Panel", pkgPanel)
                    buttonsContainer:Dock(FILL)
                    buttonsContainer:DockMargin(0, s(10), s(10), s(10))
                    -- buttonsContainer:SetWide(s(250))
                    
                    local linkType = v.links and (v.links.workshop and "workshop" or v.links.store and "store" or nil) or nil
                    local link = linkType and v.links[linkType] or nil

                    if (link) then
                        local linkButton = vgui.Create("mvp.v2.Button", buttonsContainer)
                        linkButton:SetTall(s(30))
                        linkButton:SetStyle(MVP_STYLE_PRIMARY)
                        linkButton:SetText("Get " .. (linkType == "workshop" and "on workshop" or "on Store"))

                        if (linkType == "workshop" or linkType == "store") then
                            local iconPath = "mvp/terminal/vgui/" .. linkType .. ".png"
                            linkButton:SetIcon(Material(iconPath, "smooth"))
                            linkButton:SetIconMultiplier(0.7)
                        end

                        linkButton.DoClick = function()
                            gui.OpenURL(link)
                        end
                    end

                    local moreOptionsButton = vgui.Create("mvp.v2.Button", buttonsContainer)
                    moreOptionsButton:SetTall(s(30))
                    moreOptionsButton:SetStyle(MVP_STYLE_SECONDARY)
                    moreOptionsButton:SetText("More details")
                    moreOptionsButton:SetIcon(Material("mvp/terminal/vgui/more.png", "smooth"))
                    moreOptionsButton:SetIconMultiplier(0.7)

                    moreOptionsButton.DoClick = function()
                        packagesList:Remove()
                        topBar:Clear()

                        local backButton = vgui.Create("mvp.v2.Button", topBar)
                        backButton:Dock(LEFT)
                        backButton:DockMargin(0, s(3), 0, s(3))
                        backButton:SetStyle(MVP_STYLE_SECONDARY)
                        backButton:SetText()
                        backButton:SetIcon(Material("mvp/terminal/vgui/undo.png", "smooth"))
                        -- backButton:SetIconMultiplier(0.6)
                        backButton:SetAlign(TEXT_ALIGN_CENTER)
                        backButton:SizeToContentsX()

                        headerText = mvp.q.Lang("menu.terminal.packages") .. " / " .. (v.name or "Package")
                        backButton.DoClick = function()
                            mvp.menus.terminal.Open("packages")
                        end

                        if (link) then
                            local linkButton = vgui.Create("mvp.v2.Button", topBar)
                            linkButton:Dock(RIGHT)
                            linkButton:DockMargin(0, s(3), 0, s(3))
                            linkButton:SetStyle(MVP_STYLE_PRIMARY)
                            linkButton:SetText("Get " .. (linkType == "workshop" and "on workshop" or "on store"))

                            if (linkType == "workshop" or linkType == "store") then
                                local iconPath = "mvp/terminal/vgui/" .. linkType .. ".png"
                                linkButton:SetIcon(Material(iconPath, "smooth"))
                                linkButton:SetIconMultiplier(0.7)
                            end

                            linkButton:SizeToContentsX(s(15))

                            linkButton.DoClick = function()
                                gui.OpenURL(link)
                            end
                        end

                        local pkgDetailPanel = vgui.Create("mvp.v2.Panel", content)
                        pkgDetailPanel:Dock(FILL)
                        pkgDetailPanel:DockMargin(0, s(10), 0, 0)

                        pkgDetailPanel.Paint = function(pnl, w, h)
                            RNDX().Rect(0, 0, w, h)
                                :Color(pnl:C("background", 0.1, 100))
                                :Rad(8)
                                :Draw()

                            draw.SimpleText(
                                v.name .. "@" .. v.version,
                                pnl:FF("header@bold", 24),
                                s(20),
                                s(20),
                                pnl:C("foreground"),
                                TEXT_ALIGN_LEFT,
                                TEXT_ALIGN_TOP
                            )

                            draw.SimpleText(
                                v.description or "No description provided.",
                                pnl:FF("default@regular", 16),
                                s(20),
                                s(60),
                                pnl:C("foreground", 0.85),
                                TEXT_ALIGN_LEFT,
                                TEXT_ALIGN_TOP,
                                w - s(40)
                            )
                        end
                    end

                    buttonsContainer.PerformLayout = function(pnl)
                        local children = pnl:GetChildren()
                        local currentY = 0

                        for _, child in ipairs(children) do
                            child:SizeToContentsX(s(15))
                            child:SetY(currentY)
                            child:SetX(pnl:GetWide() - child:GetWide())

                            currentY = currentY + child:GetTall() + s(5)
                        end
                    end
                end
            end

            hook.Add("mvp.terminal.PackagesListUpdated", refreshPackages, function(newPackages)
                installedPackages, availablePackages = getPackagesInfo()

                if (not IsValid(packagesList)) then return end
                if (not IsValid(installedCat)) then return end
                if (not IsValid(availableCat)) then return end

                installedCat:SetLabel("Installed Packages (" .. table.Count(installedPackages) .. ")")
                availableCat:SetLabel("Available Packages (" .. #availablePackages .. ")")
                
                installedCat:Clear()
                availableCat:Clear()

                populateCategories()
            end)

            -- refresh packages list if it's older than 6 hours
            if ((mvp.menus.terminal.packagesCache.fetchedAt + 6 * 60 * 60 < CurTime()) or mvp.menus.terminal.packagesCache.fetchedAt == 0) then
                refreshPackages:DoClick()
            else
                hook.Run("mvp.terminal.PackagesListUpdated", mvp.menus.terminal.packagesCache.packages)
            end
        end,
    }
}

function mvp.menus.terminal.Open(defaultTab, ...)
    if (IsValid(mvp.menu)) then
        mvp.menu:Remove()
    end

    defaultTab = defaultTab or mvp.menus.terminal.pages[1].id
    mvp.menus.terminal.inputFiels = {}

    local frame = vgui.Create("mvp.v2.FrameWithSidebar")
    frame:SetTitle(mvp.q.Lang("menu.terminal.title"))
    frame:SetSubTitle(mvp.q.Lang("menu.terminal.subTitle"))

    frame:SetSize(ScrW(), ScrH())
    frame:Center()
    frame:MakePopup()

    mvp.menu = frame
    mvp.menus.terminal.frame = frame

    local args = {...}

    for _, page in ipairs(mvp.menus.terminal.pages) do
        frame:AddButton(page.icon, mvp.q.Lang("menu.terminal." .. page.id), function(content)
            page.onClick(content, args)
        end, page.id == defaultTab)
    end

    frame:On("ConfigEdited", function()
        local numChanged = table.Count(mvp.menus.terminal.editedConfigs)
        local saveConfigPromt = mvp.menus.terminal.saveConfigPromt

        local wasValid = IsValid(saveConfigPromt)
        timer.Simple(0, function()
            frame._sidebar:InvalidateParent(true)
            local sidebarX, sidebarY = frame._sidebar:GetPos()
            local sidebarW, sidebarH = frame._sidebar:GetSize()

            local text = mvp.q.Lang("general.unsaved_changes_prompt", numChanged)
            
            if (not IsValid(saveConfigPromt)) then
                saveConfigPromt = vgui.Create("mvp.v2.Panel", frame)
                saveConfigPromt:SetSize(sidebarW, s(100))
                saveConfigPromt:SetDrawOnTop(true)
                -- saveConfigPromt:MakePopup()
                saveConfigPromt._text = text
                local y = wasValid and sidebarY + sidebarH - saveConfigPromt:GetTall() or sidebarY + sidebarH * 2
                saveConfigPromt:SetPos(sidebarX, y)

                saveConfigPromt:On("Think", function(pnl)            
                    pnl:MoveToFront()
                end)

                saveConfigPromt.Paint = function(pnl, w, h)
                    local textH = s(65)

                    RNDX().Rect(0, 0, w, h)
                        :Color(pnl:C("secondary", nil, 200))
                        :Rad(8)
                        :Draw()

                    RNDX().Rect(0, 0, w, h)
                        :Color(OUTLINE_COL)
                        :Rad(8)
                        :Outline(1)
                        :Draw()

                    draw.SimpleText(
                        "You have unsaved changes!",
                        pnl:FF("header@semibold", 18),
                        s(15),
                        textH * .5,
                        pnl:C("warning"),
                        TEXT_ALIGN_LEFT,
                        TEXT_ALIGN_BOTTOM

                    )
                    draw.SimpleText(
                        pnl._text,
                        pnl:FF("default@regular", 16),
                        s(15),
                        textH * .5,
                        pnl:C("foreground")
                    )
                end

                local buttonsGrid = vgui.Create("mvp.v2.Grid", saveConfigPromt)
                buttonsGrid:Dock(BOTTOM)
                buttonsGrid:DockMargin(s(15), s(10), s(15), s(15))
                buttonsGrid:SetColumnCount(2)
                buttonsGrid:SetSpaceX(s(10))
                buttonsGrid:SetMouseInputEnabled(true)

                local saveButton = vgui.Create("mvp.v2.Button", buttonsGrid)
                saveButton:SetStyle(MVP_STYLE_SUCCESS)
                saveButton:SetText(mvp.q.Lang("ui.general.save"))
                saveButton:SetTall(s(30))
                saveButton:SetMouseInputEnabled(true)
                
                saveButton.DoClick = function()
                    for k, v in pairs(mvp.menus.terminal.editedConfigs) do
                        local success = mvp.config.Set(k, v)

                        if (not success) then
                            mvp.notification.Add(mvp.NOTIFICATION.ERROR, mvp.q.Lang("ui.config.save_failed", k), mvp.q.Lang("ui.config.save_failed.description", k))
                            return
                        end
                    end
                    mvp.menus.terminal.editedConfigs = {}

                    frame:Call("ConfigEdited", true)

                    mvp.notification.Add(mvp.NOTIFICATION.SUCCESS, mvp.q.Lang("ui.config.saved"), mvp.q.Lang("ui.config.saved.description"))
                end

                local resetButton = vgui.Create("mvp.v2.Button", buttonsGrid)
                resetButton:SetStyle(MVP_STYLE_DANGER)
                resetButton:SetText(mvp.q.Lang("ui.general.discard_changes"))
                resetButton:SetTall(s(30))
                resetButton:SetMouseInputEnabled(true)

                resetButton.DoClick = function()
                    mvp.menus.terminal.editedConfigs = {}

                    for _, input in pairs(mvp.menus.terminal.inputFiels) do
                        if (IsValid(input) and input.ResetToStored) then
                            input:ResetToStored()
                        end
                    end

                    frame:Call("ConfigEdited", true)
                end

                mvp.menus.terminal.saveConfigPromt = saveConfigPromt
            end

            saveConfigPromt._text = text
            if (numChanged == 0 and IsValid(saveConfigPromt)) then
                saveConfigPromt:MoveTo(
                    sidebarX,
                    sidebarY + sidebarH * 2,
                    0.5,
                    0,
                    -1,
                    function()
                        if (IsValid(saveConfigPromt)) then
                            saveConfigPromt:Remove()
                            mvp.menus.terminal.saveConfigPromt = nil
                        end
                    end
                )
            elseif (numChanged > 0 and IsValid(saveConfigPromt)) then
                saveConfigPromt:MoveTo(
                    sidebarX,
                    sidebarY + sidebarH - saveConfigPromt:GetTall(),
                    0.2,
                    0,
                    -1
                )
            else
                saveConfigPromt._text = text
                saveConfigPromt:InvalidateLayout(true)
            end
        end)
    end)

    if (table.Count(mvp.menus.terminal.editedConfigs) > 0) then
        frame:Call("ConfigEdited", true)
    end

    args = {}
end

concommand.Add("mvp_terminal", function()
    if (mvp.permissions.Check(LocalPlayer(), "mvp.terminal")) then
        mvp.menus.terminal.Open()
    else
        chat.AddText(mvp.colors.Red, mvp.q.Lang("general.no_permission"))
    end
end)