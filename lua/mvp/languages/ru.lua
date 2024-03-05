local l = {}

l["general.terminal"] = "Terminal"

l["general.by_x"] = "by %s"
l["general.no_permission"] = "У вас нет разрешения на это."
l["general.use"] = "Нажмите {{btn:%s}} для взаимодействия"

l["general.screen_position.tl"] = "Верхний левый угол"
l["general.screen_position.tc"] = "Верхний центр"
l["general.screen_position.tr"] = "Верхний правый угол"
l["general.screen_position.cl"] = "Центр слева"
l["general.screen_position.cc"] = "Центр"
l["general.screen_position.cr"] = "Центр справа"
l["general.screen_position.bl"] = "Нижний левый угол"
l["general.screen_position.bc"] = "Нижний центр"
l["general.screen_position.br"] = "Нижний правый угол"

--[[
    UI
]]--

l["ui.general.save"] = "Сохранить"
l["ui.general.save.thing"] = "Сохранить %s"
l["ui.general.close"] = "Закрыть"
l["ui.general.none"] = "Нет"

l["ui.home"] = "Главная"
l["ui.home.description"] = "Это главная страница меню администратора Терминала."

l["ui.config"] = "Настройки"
l["ui.config.save"] = "Сохранить настройки"
l["ui.config.description"] = "Это ваши настройки для Терминала и его пакетов. Вы можете изменить имя сервера, логотип, игровой режим и многое другое."

l["ui.config.saved"] = "Настройки сохранены"
l["ui.config.saved.description"] = "Настройки Терминала были успешно сохранены."

l["ui.permissions"] = "Права"
l["ui.permissions.description"] = "Здесь перечислены все права, зарегистрированные терминалом или его пакетами."

l["ui.packages"] = "Пакеты"
l["ui.packages.description"] = "Это пакеты, которые в данный момент загружены в терминал."
l["ui.packages.installed"] = "Установленные пакеты"
l["ui.packages.available"] = "Доступные пакеты"

l["ui.credits"] = "Авторы"
l["ui.credits.description"] = "Здесь указаны авторы Терминала и материалов, использованных в терминале."
l["ui.credits.steam_profile"] = "Профиль Steam"

l["ui.credits.terminal"] = l["general.terminal"]
l["ui.credits.icons"] = "Иконки"
l["ui.credits.packages"] = "Пакеты"

l["ui.notifications.servername.title"] = "Имя сервера не установлено"
l["ui.notifications.servername.description"] = "Вы еще не установили имя сервера. В настоящее время Терминал будет использовать значение по умолчанию \"%s\" в качестве имени вашего сервера. Вы можете установить имя сервера в настройках."
l["ui.notifications.servername.action.1"] = "Установить имя сервера"

l["ui.notifications.logo.title"] = "Логотип сервера не установлен"
l["ui.notifications.logo.description"] = "Вы еще не установили логотип сервера. В настоящее время Терминал будет использовать значение по умолчанию \"%s\" в качестве логотипа вашего сервера. Вы можете установить логотип сервера в настройках."
l["ui.notifications.logo.action.1"] = "Установить логотип сервера"

l["ui.notifications.gamemode.title"] = "Игровой режим не установлен"
l["ui.notifications.gamemode.description"] = "Вы еще не установили игровой режим. В настоящее время Терминал будет использовать значение по умолчанию \"%s\" в качестве вашего игрового режима. Вы можете установить игровой режим в настройках."
l["ui.notifications.gamemode.action.1"] = "Установить игровой режим"
l["ui.notifications.gamemode.action.2"] = "Отмена"


--[[
    Config Section
]]--

l["section.terminal"] = l["general.terminal"]
l["section.terminal.general"] = "Общие"
l["section.terminal.appearance"] = "Внешний вид"
l["section.terminal.developer"] = "Разработчик"

l["value.prefix.description"] = "Префикс для всех команд."
l["value.command.description"] = "Команда для открытия меню Терминала."
l["value.allowConsoleCommand.description"] = "Разрешить консольную команду для открытия меню Терминала."

l["value.tag.description"] = "Тег для всех сообщений в чате."
l["value.language.description"] = "Язык для использования в Терминале."
l["value.useNotifications.description"] = "Использовать систему уведомлений. Если выключено - уведомления будут появляться в чате."
l["value.notificationsPosition.description"] = "Позиция для уведомлений."
l["value.notificationsPosition.ps.title"] = "Уведомление от Терминала"
l["value.notificationsPosition.ps.description"] = "Теперь уведомления от терминала будут отображаться здесь."

l["value.debug.description"] = "Включить режим отладки."

l["section.server"] = "Сервер"
l["section.server.gamemode"] = "Игровой режим"
l["section.server.branding"] = "Брендинг"

l["value.gamemode.description"] = "Игровой режим сервера."
l["value.logo.description"] = "Брендинг сервера."
l["value.servername.description"] = "Брендинг сервера."

--[[
    Permissions Section
]]--

l["permission.mvp.terminal.description"] = "Позволяет получить доступ к меню Терминала"
l["permission.mvp.terminal.configs.description"] = "Позволяет получить доступ к меню конфигурации Терминала"
l["permission.mvp.terminal.packages.description"] = "Позволяет контролировать загружаемые пакеты"


mvp.language.Register("ru", l)