local theme = mvp.meta.theme:New()

theme:SetName("Default")
theme:SetDescription("The default Terminal theme")
theme:SetAuthor("Kot @ multiverse project")
theme:SetVersion("1.0.0")
theme:SetLicense("MIT")

--[[
@section:
    Colors
    Here we define all colors used in the theme
]]--
theme:SetColor("background", Color(32, 32, 32))
theme:SetColor("foreground", Color(240, 240, 240))

theme:SetColor("primary", Color(255, 192, 92))
theme:SetColor("primary-foreground", Color(0, 0, 0))

theme:SetColor("secondary", Color(48, 48, 48))
theme:SetColor("secondary-foreground", Color(200, 200, 200))

theme:SetColor("accent", Color(92, 219, 211))

theme:SetColor("success", Color(34, 197, 94))
theme:SetColor("warning", Color(251, 191, 36))
theme:SetColor("error", Color(239, 68, 68))
theme:SetColor("info", Color(59, 130, 246))

--[[
@section:
    Fonts
    Here we define all fonts used in the theme
]]--
theme:SetDefaultFont({
    font = "Manrope", -- Base font family
    weights = { -- weight mapping, using provided constants
        [MVP_FONT_THIN] = "ExtraLight",
        [MVP_FONT_EXTRALIGHT] = "ExtraLight",
        [MVP_FONT_LIGHT] = "Light",
        [MVP_FONT_MEDIUM] = "Medium",
        [MVP_FONT_SEMIBOLD] = "SemiBold",
        [MVP_FONT_BOLD] = "Bold",
        [MVP_FONT_EXTRABOLD] = "ExtraBold",
        [MVP_FONT_BLACK] = "ExtraBold"
    }
})
theme:SetHeaderFont({
    font = "Montserrat",
    weights = {
        [MVP_FONT_THIN] = "Thin",
        [MVP_FONT_EXTRALIGHT] = "ExtraLight",
        [MVP_FONT_LIGHT] = "Light",
        [MVP_FONT_MEDIUM] = "Medium",
        [MVP_FONT_SEMIBOLD] = "SemiBold",
        [MVP_FONT_BOLD] = "Bold",
        [MVP_FONT_EXTRABOLD] = "ExtraBold",
        [MVP_FONT_BLACK] = "Black"
    }
})

if (SERVER) then -- @todo: probably need to check if content addon is installed?
    resource.AddFile("resource/fonts/Montserrat-Light.ttf")
    resource.AddFile("resource/fonts/Montserrat-ExtraLight.ttf")
    resource.AddFile("resource/fonts/Montserrat-Thin.ttf")
    resource.AddFile("resource/fonts/Montserrat-Regular.ttf")
    resource.AddFile("resource/fonts/Montserrat-Medium.ttf")
    resource.AddFile("resource/fonts/Montserrat-SemiBold.ttf")
    resource.AddFile("resource/fonts/Montserrat-Bold.ttf")
    resource.AddFile("resource/fonts/Montserrat-ExtraBold.ttf")
    resource.AddFile("resource/fonts/Montserrat-Black.ttf")

    resource.AddFile("resource/fonts/Manrope-Bold.ttf")
    resource.AddFile("resource/fonts/Manrope-ExtraBold.ttf")
    resource.AddFile("resource/fonts/Manrope-ExtraLight.ttf")
    resource.AddFile("resource/fonts/Manrope-Light.ttf")
    resource.AddFile("resource/fonts/Manrope-Medium.ttf")
    resource.AddFile("resource/fonts/Manrope-Regular.ttf")
    resource.AddFile("resource/fonts/Manrope-SemiBold.ttf")
end

mvp.theme.Register(theme)