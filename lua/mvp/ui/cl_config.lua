mvp.ui = mvp.ui or {}
mvp.ui.config = mvp.ui.config or {}

-- @todo: do this in a in-game config? Idk about this yet
mvp.ui.config.fonts = {
    ["default"] = {
        font = "Manrope",
        weights = {
            [100] = "ExtraLight",
            [200] = "ExtraLight",
            [300] = "Light",
            [500] = "Regular",
            [600] = "Medium",
            [700] = "SemiBold",
            [800] = "Bold",
            [900] = "ExtraBold"
        }
    },
    ["heading"] = {
        font = "Montserrat",
        weights = {
            [100] = "Thin",
            [200] = "ExtraLight",
            [300] = "Light",
            [500] = "Medium",
            [600] = "SemiBold",
            [700] = "Bold",
            [800] = "ExtraBold",
            [900] = "Black"
        }
    }
}

mvp.ui.config.colors = {}
mvp.ui.config.colors.primary = Color(33, 33, 33, 255)
mvp.ui.config.colors.secondary = Color(42, 42, 42, 255)
mvp.ui.config.colors.tertiary = Color(60, 54, 50, 255)

mvp.ui.config.colors.accent = Color(201, 138, 75, 255)

mvp.ui.config.colors.gray = Color(67, 72, 82) -- rgb()
mvp.ui.config.colors.red = Color(235, 77, 75)
mvp.ui.config.colors.green = Color(39, 174, 96)

mvp.ui.config.colors.text = Color(243, 243, 243)
mvp.ui.config.colors.textMuted = Color(167, 167, 167)
mvp.ui.config.colors.textDark = Color(49, 49, 49)