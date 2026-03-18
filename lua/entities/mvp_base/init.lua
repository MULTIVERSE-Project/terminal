AddCSLuaFile("cl_init.lua")

AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("mcore.entity.action")

function ENT:Initialize()
    self:SetModel(self.Model)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:Wake()
    end

    self:SetUseType(SIMPLE_USE)

    if (self.OnInitialize) then
        self:OnInitialize()
    end
end

function ENT:Use(ply)
    if (not self.Action) then return end
    if (not IsValid(ply) or not ply:IsPlayer()) then return end

    if (ply:KeyDown(IN_SPEED)) then
        self:Action(ply, MVP_ENT_ACTION_SHIFT_USE)
    else
        self:Action(ply, MVP_ENT_ACTION_USE)
    end
end