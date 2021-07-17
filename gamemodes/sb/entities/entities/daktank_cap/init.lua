AddCSLuaFile("init_cl.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/column02a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow( true )
	self:SetKeyValue( "gmod_allowphysgun", 0 )
	self.DakMaxHealth = 500000000000000
	self.DakHealth = 500000000000000000
	self.DakTeam = 0
end

util.AddNetworkString( "DakTankGamemodeNotification" )

function ENT:Think()
	self.DakHealth = 500000000000000000
	local NearbyReds = 0
	local NearbyBlues = 0
	for k, ply in pairs( player.GetAll() ) do 
		if ply:Alive() and ply:GetObserverMode()==0 and ply.TeamPicked==true and ply:InVehicle()==false and not(ply:IsFlagSet(FL_FROZEN)) then
			if ply:GetPos():Distance(self:GetPos()) <= 500 then
				if ply:Team() == 1 then NearbyReds = NearbyReds + 1 end
				if ply:Team() == 2 then NearbyBlues = NearbyBlues + 1 end
			end
		end
	end
	for k, bot in pairs( ents.FindByClass("dak_gamemode_bot") ) do 
		if bot:GetPos():Distance(self:GetPos()) <= 500 then
			if bot.DakTeam == 1 then NearbyReds = NearbyReds + 1 end
			if bot.DakTeam == 2 then NearbyBlues = NearbyBlues + 1 end
		end
	end
	for k, tank in pairs( ents.FindByClass("dak_tankcore") ) do 
		if tank:GetPos():Distance(self:GetPos()) <= 500 then
			if tank.DakOwner and tank.DakOwner:Team() == self.DakTeam then
				local filled = 0
				for I=1, #tank.Ammoboxes do
					if filled == 0 then
						if tank.Ammoboxes[I].DakAmmo < tank.Ammoboxes[I].DakMaxAmmo then
							tank.Ammoboxes[I].DakAmmo = math.Min(tank.Ammoboxes[I].DakAmmo + math.ceil(tank.Ammoboxes[I].DakMaxAmmo*0.1),tank.Ammoboxes[I].DakMaxAmmo)
							filled = 1
						end
					end
				end
			end
		end
	end

	if NearbyReds>NearbyBlues then
		if self.BlueTicks > 0 then 
			self.BlueTicks = self.BlueTicks - 1 
		else
			if self.RedTicks < 10 then self.RedTicks = self.RedTicks + 1 end
		end
	elseif NearbyReds<NearbyBlues then
		if self.RedTicks > 0 then 
			self.RedTicks = self.RedTicks - 1 
		else
			if self.BlueTicks < 10 then self.BlueTicks = self.BlueTicks + 1 end
		end
	end
	if self.RedTicks == 10 then 
		self:SetCapTeam(1)
	elseif self.BlueTicks == 10 then 
		self:SetCapTeam(2)
	else
		self:SetCapTeam(0)
	end

	if self:GetCapTeam() == 1 then
		self.DakTeam = 1
	elseif self:GetCapTeam() == 2 then
		self.DakTeam = 2
	else
		self.DakTeam = 0
	end

	if self.BlueTicks > 0 then
		self:SetColor(Color(255-(25.5*self.BlueTicks), 255-(25.5*self.BlueTicks), 255, 255))
	elseif self.RedTicks > 0 then
		self:SetColor(Color(255, 255-(25.5*self.RedTicks), 255-(25.5*self.RedTicks), 255))
	else
		self:SetColor(Color(255, 255, 255, 255))
	end

	if self:GetCapTeam() == 0 then 
		if NearbyReds+NearbyBlues == 0 then
			if self.BlueTicks > 0 then self.BlueTicks = self.BlueTicks - 1 end
			if self.RedTicks > 0 then self.RedTicks = self.RedTicks - 1 end
		end
	end

	if self.LastTeam == 0 and self:GetCapTeam() == 1 then
		--RedCapped
		net.Start( "DakTankGamemodeNotification" )
			net.WriteInt(5,32)
			net.WriteInt(self:GetNWInt("number"),32)
		net.Broadcast()
		for k, v in pairs( player.GetAll() ) do
			--v:ChatPrint("Red team just captured point "..self:GetNWInt("number"))
			if v:Team() == 1 and v:GetPos():Distance(self:GetPos()) <= 500 and v:Alive() and v:GetObserverMode()==0 and v.TeamPicked==true and v:InVehicle()==false then
				if self.Era == "WWII" then
					PointsGained = 5
				elseif self.Era == "Cold War" then
					PointsGained = 10
				else
					PointsGained = 20
				end
				net.Start( "DT_killnotification" )
					net.WriteInt(3, 32)
					net.WriteFloat(PointsGained, 32)
				net.Send( v )
				if not(v:InVehicle()) then v:addPoints( PointsGained ) end
			end
		end
	end
	if self.LastTeam == 0 and self:GetCapTeam() == 2 then
		--BlueCapped
		net.Start( "DakTankGamemodeNotification" )
			net.WriteInt(6,32)
			net.WriteInt(self:GetNWInt("number"),32)
		net.Broadcast()
		for k, v in pairs( player.GetAll() ) do
			--v:ChatPrint("Blue team just captured point "..self:GetNWInt("number"))
			if v:Team() == 2 and v:GetPos():Distance(self:GetPos()) <= 500 and v:Alive() and v:GetObserverMode()==0 and v.TeamPicked==true and v:InVehicle()==false then
				if self.Era == "WWII" then
					PointsGained = 5
				elseif self.Era == "Cold War" then
					PointsGained = 10
				else
					PointsGained = 20
				end
				net.Start( "DT_killnotification" )
					net.WriteInt(3, 32)
					net.WriteFloat(PointsGained, 32)
				net.Send( v )
				if not(v:InVehicle()) then v:addPoints( PointsGained ) end
			end
		end
	end
	if self.LastTeam == 1 and self:GetCapTeam() == 0 then
		--RedLost
		net.Start( "DakTankGamemodeNotification" )
			net.WriteInt(7,32)
			net.WriteInt(self:GetNWInt("number"),32)
		net.Broadcast()
		--for k, v in pairs( player.GetAll() ) do
			--v:ChatPrint("Red team just lost point "..self:GetNWInt("number"))
		--end
	end
	if self.LastTeam == 2 and self:GetCapTeam() == 0 then
		--BlueLost
		net.Start( "DakTankGamemodeNotification" )
			net.WriteInt(8,32)
			net.WriteInt(self:GetNWInt("number"),32)
		net.Broadcast()
		--for k, v in pairs( player.GetAll() ) do
			--v:ChatPrint("Blue team just lost point "..self:GetNWInt("number"))
		--end
	end
	self.LastTeam = self:GetCapTeam()

	self:NextThink(CurTime()+1)
    return true
end

function ENT:Use( activator )
	if activator:IsPlayer() then 
		if self:GetCapTeam() == activator:Team() then
			activator:ChatPrint("Change loadout or teleport to new cap.")
			activator.SpawnedFromCap = true
			activator:ConCommand( "dt_respawn" )
		end
	end
end