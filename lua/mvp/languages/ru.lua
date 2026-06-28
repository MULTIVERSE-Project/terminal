local l = {}

l["general.terminal"] = "Terminal"

l["general.disabled"] = "Эта функция отключена."

l["general.by_x"] = "от %s"
l["general.no_permission"] = "У вас нет прав для выполнения этого действия."
l["general.use"] = "Нажмите {{btn:%s}}, чтобы взаимодействовать"
l["general.command_x"] = "Команда: %s"

l["general.unsaved_changes_prompt"] = "%d несохранённых"

l["general.screen_position.tl"] = "Сверху слева"
l["general.screen_position.tc"] = "Сверху по центру"
l["general.screen_position.tr"] = "Сверху справа"
l["general.screen_position.cl"] = "По центру слева"
l["general.screen_position.cc"] = "По центру"
l["general.screen_position.cr"] = "По центру справа"
l["general.screen_position.bl"] = "Снизу слева"
l["general.screen_position.bc"] = "Снизу по центру"
l["general.screen_position.br"] = "Снизу справа"

--[[
    UI
]]--

l["ui.general.save"] = "Сохранить"
l["ui.general.save.thing"] = "Сохранить %s"
l["ui.general.close"] = "Закрыть"
l["ui.general.none"] = "Нет"
l["ui.general.edit"] = "Изменить"
l["ui.general.discard_changes"] = "Отменить"

l["ui.home"] = "Главная"
l["ui.home.description"] = "Это главная страница панели администратора Терминала."

l["ui.config"] = "Настройки"
l["ui.config.save"] = "Сохранить настройки"
l["ui.config.description"] = "Здесь находятся настройки Терминала и его пакетов. Вы можете изменить название сервера, логотип, игровой режим и многое другое."

l["ui.config.saved"] = "Настройки успешно сохранены."
l["ui.config.saved.description"] = "Ваши настройки были успешно сохранены."

l["ui.permissions"] = "Разрешения"
l["ui.permissions.description"] = "Здесь перечислены все разрешения, зарегистрированные Терминалом и его пакетами."

l["ui.packages"] = "Пакеты"
l["ui.packages.description"] = "Здесь отображаются пакеты, которые в данный момент загружены в Терминал."
l["ui.packages.installed"] = "Установленные пакеты"
l["ui.packages.available"] = "Доступные пакеты"

l["ui.credits"] = "Авторы"
l["ui.credits.description"] = "Здесь указаны авторы Терминала и использованных материалов."
l["ui.credits.steam_profile"] = "Профиль Steam"

l["ui.credits.terminal"] = l["general.terminal"]
l["ui.credits.icons"] = "Иконки"
l["ui.credits.packages"] = "Пакеты"

l["ui.notifications.servername.title"] = "Название сервера не задано"
l["ui.notifications.servername.description"] = "Вы ещё не указали название сервера. Сейчас Терминал использует значение по умолчанию \"%s\". Вы можете изменить его в настройках."
l["ui.notifications.servername.action.1"] = "Указать название сервера"

l["ui.notifications.logo.title"] = "Логотип сервера не задан"
l["ui.notifications.logo.description"] = "Вы ещё не указали логотип сервера. Сейчас Терминал использует значение по умолчанию \"%s\". Вы можете изменить его в настройках."
l["ui.notifications.logo.action.1"] = "Указать логотип сервера"

l["ui.notifications.gamemode.title"] = "Игровой режим не задан"
l["ui.notifications.gamemode.description"] = "Вы ещё не указали игровой режим. Сейчас Терминал использует значение по умолчанию \"%s\". Вы можете изменить его в настройках."
l["ui.notifications.gamemode.action.1"] = "Указать игровой режим"
l["ui.notifications.gamemode.action.2"] = "Закрыть"

--[[
    Config Section
]]--

l["section.terminal"] = l["general.terminal"]
l["section.terminal.general"] = "Основное"
l["section.terminal.appearance"] = "Внешний вид"
l["section.terminal.webImages"] = "Изображения из интернета"
l["section.terminal.developer"] = "Разработчик"

l["value.prefix"] = "Префикс команд"
l["value.prefix.description"] = "Префикс для всех команд."

l["value.command.description"] = "Команда для открытия меню Терминала."

l["value.allowConsoleCommand"] = "Включить консольную команду"
l["value.allowConsoleCommand.description"] = "Разрешить использование консольной команды для открытия меню Терминала."

l["value.tag"] = "Тег в чате"
l["value.tag.description"] = "Тег для всех сообщений в чате."

l["value.language"] = "Язык"
l["value.language.description"] = "Язык, используемый Терминалом."

l["value.theme"] = "Тема"
l["value.theme.description"] = "Тема оформления Терминала."

l["value.useNotifications"] = "Включить уведомления"
l["value.useNotifications.description"] = "Использовать систему уведомлений. Если отключено, Терминал будет отправлять уведомления в чат."

l["value.notificationsPosition"] = "Положение уведомлений"
l["value.notificationsPosition.description"] = "Расположение уведомлений на экране."
l["value.notificationsPosition.ps.title"] = "Положение уведомлений Терминала"
l["value.notificationsPosition.ps.description"] = "Здесь будут отображаться уведомления на экране."

l["value.imagesProxy"] = "Прокси для изображений"
l["value.imagesProxy.description"] = "Использовать прокси для загрузки изображений. Полезно, если возникают проблемы с загрузкой изображений из интернета."

l["value.debug"] = "Режим отладки"
l["value.debug.description"] = "Включить режим отладки."

l["section.server"] = "Сервер"
l["section.server.gamemode"] = "Игровой режим"
l["section.server.branding"] = "Брендинг"

l["value.gamemode"] = "Игровой режим"
l["value.gamemode.description"] = "Игровой режим сервера."
l["value.logo"] = "Логотип сервера"
l["value.logo.description"] = "Фирменный стиль сервера."
l["value.servername"] = "Название сервера"
l["value.servername.description"] = "Фирменный стиль сервера."

--[[
    Permissions Section
]]--

l["permission.mvp.terminal.description"] = "Предоставляет доступ к меню Терминала."
l["permission.mvp.terminal.configs.description"] = "Предоставляет доступ к меню настроек Терминала."
l["permission.mvp.terminal.packages.description"] = "Позволяет управлять загружаемыми пакетами."


mvp.language.Register("ru", l)