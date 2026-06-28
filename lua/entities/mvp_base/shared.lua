ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "ENT"
ENT.Category = "Multiverse ✦ Bases"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.RenderGroup = RENDERGROUP_BOTH

-- For overwriting
ENT.Model = "models/hunter/blocks/cube05x05x05.mdl"
ENT.UI = {}
ENT.Actions = {}

ENT.View = {250, 250 * .75} -- {max, min}

ENT._UI = {
    Header = "Interactable",
    Description = "Это интерактивный объект. Но его не должно существовать во время нормальной игры.",
    Icon = "https://i.ibb.co/YBbF0ch0/box.png",

    Size = {100, 20},
    FollowPlayer = false
}
ENT._Actions = {
    -- [ENT_ACTION_USE] = {
    --     Text = "Взаимодействовать"
    -- }
}