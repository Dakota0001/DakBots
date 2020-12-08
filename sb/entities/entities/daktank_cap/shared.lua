ENT.Type = "anim"
ENT.Base = "base_wire_entity"
ENT.PrintName = "Cap Point"
ENT.Author = "Dakota"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:GetTeam()
	return self:GetNWInt( "team" )
end

function ENT:GetNumber()
	return self:GetNWInt( "number" )
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "CapTeam" )
end