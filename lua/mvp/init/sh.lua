mvp = mvp or {}

-- default colors for console
mvp.WHITE = Color(255, 255, 255, 255)
mvp.BLACK = Color(0, 0, 0, 255)
mvp.RED = Color(255, 0, 0, 255)
mvp.GREEN = Color(0, 255, 0, 255)
mvp.BLUE = Color(0, 102, 255)
mvp.CYAN = Color(0, 168, 255)
mvp.YELLOW = Color(255, 255, 0, 255)
mvp.ORANGE = Color(225, 177, 44)
mvp.GRAY = Color(207, 207, 207)
 
-- log levels
mvp.LOG_DEBUG = 0
mvp.LOG_INFO = 1
mvp.LOG_WARNING = 2
mvp.LOG_ERROR = 3  

-- Load loader for later use
if SERVER then AddCSLuaFile('mvp/core/sh_loader.lua') end
include('mvp/core/sh_loader.lua')

mvp.loader.LoadServerFile('init/sv.lua')
mvp.loader.LoadClientFile('init/cl.lua')

mvp.loader.LoadFolder('core/logger')
mvp.logger.Init()