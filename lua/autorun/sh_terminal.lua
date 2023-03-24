mvp = {}

AddCSLuaFile()

-- Make sure to load the shared file first
-- from that file we will load the rest of the files
if SERVER then
    AddCSLuaFile('mvp/init/sh.lua')
end

include('mvp/init/sh.lua')