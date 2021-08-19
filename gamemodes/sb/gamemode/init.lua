include("shared.lua")
include("sh_player.lua")
include("sv_dakmin.lua")

--

SetGlobalFloat("DakTankRedResources", 2500)
SetGlobalFloat("DakTankBlueResources", 2500)
local Reds, Blues, Specs = 1,2,3
util.AddNetworkString("DT_killnotification")
--Caps = ents.FindByClass( "daktank_cap" )
util.AddNetworkString( "DakTankGamemodeNotification" )
util.AddNetworkString( "DT_caps" )
util.AddNetworkString( "DT_era" )
util.AddNetworkString( "DT_bots" )
local Paths = nil
if file.Exists( "dakpaths/"..game.GetMap()..".txt", "DATA" ) then
	Paths = util.JSONToTable(util.Decompress(file.Read( "dakpaths/"..game.GetMap()..".txt", "DATA" )))
end
local BotMax

do -- Global Settings
	DTTE.RespawnTime = 5 -- Respawn time in seconds
end


do--Map Limits Start
	Era = "WWII" -- other options are "Cold War" and "Modern"
	StartPoints = 0
	BotMax = 20 --per team

	if game.GetMap() == "gm_bay" then --inactive
		Era = "WWII"
		StartPoints = 10
		BotMax = 0
	elseif game.GetMap() == "gm_emp_cyclopean" then
		Era = "Modern"
		StartPoints = 150
		BotMax = 80
	elseif game.GetMap() == "gm_emp_coast" then --inactive
		Era = "WWII"
		StartPoints = 30
		BotMax = 40
	elseif game.GetMap() == "gm_emp_palmbay" then
		Era = "WWII"
		StartPoints = 20
		BotMax = 40
	elseif game.GetMap() == "gm_emp_canyon" then
		Era = "Cold War"
		StartPoints = 50
		BotMax = 40
	elseif game.GetMap() == "gm_emp_bush" then
		Era = "Cold War"
		StartPoints = 75
		BotMax = 100
	elseif game.GetMap() == "gm_emp_mesa" then --inactive
		Era = "Modern"
		StartPoints = 100
		BotMax = 40
	elseif game.GetMap() == "gm_emp_chain" then
		Era = "Cold War"
		StartPoints = 60
		BotMax = 100
	elseif game.GetMap() == "gm_emp_manticore" then
		Era = "WWII"
		StartPoints = 10
		BotMax = 75
	end
	--MapList = {"gm_bay","gm_emp_cyclopean","gm_emp_coast","gm_emp_palmbay","gm_emp_canyon","gm_emp_bush","gm_emp_mesa"}
	MapList = {"gm_emp_manticore","gm_emp_chain","gm_emp_cyclopean","gm_emp_palmbay","gm_emp_canyon","gm_emp_bush"}
	--figure out what is up with gm_emp_coast bots stuck in the cave point and other places
	--deal with issue of ai getting underwater and in bad places on gm_emp_mesa too often, also the central point on mesa can't be gotten to by AI which breaks their pathfinding if they try
end--Map Limits End

DTTE.Paths = Paths
DTTE.Era   = Era

do--Player Spawn Start
	function GM:PlayerSpawn( ply )
	    self.BaseClass:PlayerSpawn( ply )
	    ply:SetGravity( 1 )  

	    ply.ArmorType = tonumber(ply:GetInfo( "DakTankLoadoutArmor" ))
	    ply.PerkType = tonumber(ply:GetInfo( "DakTankLoadoutPerk" ))
	    ply.SpawnPoint = tonumber(ply:GetInfo( "DakTankLoadoutSpawn" ))

	    if ply.ArmorType == 1 then
			ply:SetWalkSpeed( 400 )  
			ply:SetRunSpeed( 400 ) 
		elseif ply.ArmorType == 2 then
			ply:SetWalkSpeed( 350 )  
			ply:SetRunSpeed( 350 ) 
		elseif ply.ArmorType == 3 then
			ply:SetWalkSpeed( 300 )  
			ply:SetRunSpeed( 300 ) 
		elseif ply.ArmorType == 4 then
			ply:SetWalkSpeed( 250 )  
			ply:SetRunSpeed( 250 ) 
		elseif ply.ArmorType == 5 then
			ply:SetWalkSpeed( 200 )  
			ply:SetRunSpeed( 200 ) 
		end

		if ply.PerkType == 2 then
			ply:SetMaxHealth( 250 ) 
			ply:SetHealth(250)
		else
			if ply.BloodStacks ~= nil then
				if ply.PerkType == 4 then
					ply:SetMaxHealth( 100 + ply.BloodStacks*5 ) 
					ply:SetHealth(100 + ply.BloodStacks*5 )
				else
					ply:SetMaxHealth( 100 ) 
					ply:SetHealth(100)
				end
			else
				ply:SetMaxHealth( 100 ) 
				ply:SetHealth(100)
			end
			
		end

		if ply.SpawnPoint ~= nil then
			if #Caps>=ply.SpawnPoint and IsValid(Caps[ply.SpawnPoint]) and Caps[ply.SpawnPoint]:GetCapTeam() == ply:Team() then
				local randspawn = math.random(1,4)
				local spawnpos
				if randspawn == 1 then
					spawnpos = (Caps[ply.SpawnPoint]:GetPos()+Vector(100,100,50))
				elseif randspawn == 2 then
					spawnpos = (Caps[ply.SpawnPoint]:GetPos()+Vector(-100,100,50))
				elseif randspawn == 3 then
					spawnpos = (Caps[ply.SpawnPoint]:GetPos()+Vector(100,-100,50))
				else
					spawnpos = (Caps[ply.SpawnPoint]:GetPos()+Vector(-100,-100,50))
				end

				--TODO: make players not spawn on bots which can happen randomly sometimes if a bot happens to be here
				local spawntrace = util.TraceLine( {
					start = spawnpos+Vector(0,0,1000),
					endpos = spawnpos-Vector(0,0,1000),
					mask = MASK_NPCWORLDSTATIC
				} )
				ply:SetPos(spawntrace.HitPos+Vector(0,0,25))

			else
				ply:ChatPrint("Invalid spawn, pick another.")
				local lastteam = ply:Team()
				GAMEMODE:PlayerSpawnAsSpectator( ply )
				ply:Spectate( 6 )
				ply:SetTeam(lastteam)
				ply.DakTeam = lastteam
				ply:ConCommand( "dt_respawn" )
			end
		end

		local TransmitTable = {}
		for i=1, #Caps do
			if IsValid(Caps[i]) then
				TransmitTable[#TransmitTable+1] = {Caps[i]:GetNWInt("number"),Caps[i]:GetCapTeam(),Caps[i]:GetPos()}
			end
		end
		net.Start( "DT_caps" )
			net.WriteTable( TransmitTable )
		net.Send( ply )
	end

	function GM:PlayerSetModel( ply )
	   	if ply.DakTeam == 1 then
			ply:SetModel( "models/player/combine_soldier.mdl" )
			ply:SetSkin( 1 )
	   	end
	   	if ply.DakTeam == 2 then
			ply:SetModel( "models/player/combine_super_soldier.mdl" )
	   	end
	end

    util.AddNetworkString("DTPlayerLoaded")
    net.Receive("DTPlayerLoaded", function(_, Player)
        hook.Run("DTOnPlayerLoaded", Player)
    end)

	hook.Add("DTOnPlayerLoaded", "DTPlayerSpawn", function( ply )
		if ply.dakloaded ~= true then
			ply.dakloaded = true
			GAMEMODE:PlayerSpawnAsSpectator( ply )
			ply:Spectate( 6 )
			ply:SetTeam( 3 )
			ply.DakTeam = 3
			ply:addPoints(StartPoints)
			ply.TeamPicked = false
			--ply:ConCommand( "dt_start" )

			local RedCount = 0
			local BlueCount = 0
			local Players = player.GetAll()
			for i=1, #Players do
				if Players[i]:Team() == 1 then
					RedCount = RedCount + 1
				elseif Players[i]:Team() == 2 then
					BlueCount = BlueCount + 1
				end
			end
			if RedCount <= BlueCount then
				ply:SetTeam( 1 )
				ply.DakTeam = 1
				ply:SetModel( "models/player/combine_soldier.mdl" )
				ply:SetSkin( 1 )
				ply:PrintMessage( HUD_PRINTTALK, "Red team picked." )
				timer.Simple(1,function() 
					ply:ConCommand( "dt_respawn" )
				end)
				ply.JustPickedTeam = true
			elseif RedCount > BlueCount then
				ply:SetTeam( 2 )
				ply.DakTeam = 2
				ply:SetModel( "models/player/combine_super_soldier.mdl" )
				ply:PrintMessage( HUD_PRINTTALK, "Blue team picked." )
				timer.Simple(1,function() 
					ply:ConCommand( "dt_respawn" )
				end)
				ply.JustPickedTeam = true
			end

			local TransmitTable = {}
			for i=1, #Caps do
				if IsValid(Caps[i]) then
					TransmitTable[#TransmitTable+1] = {Caps[i]:GetNWInt("number"),Caps[i]:GetCapTeam(),Caps[i]:GetPos()}
				end
			end
			net.Start( "DT_caps" )
				net.WriteTable( TransmitTable )
			net.Send( ply )
			net.Start( "DT_era" )
				net.WriteString( Era )
			net.Send( ply )
		end
	end)
end--Player Spawn End

do--Loadout Fill Start
	function GM:PlayerLoadout( ply )

		local PrimaryType = tonumber(ply:GetInfo( "DakTankLoadoutPrimary" ))
		local SecondaryType = tonumber(ply:GetInfo( "DakTankLoadoutSecondary" ))
		local SpecialType = tonumber(ply:GetInfo( "DakTankLoadoutSpecial" ))
		ply.PerkType = tonumber(ply:GetInfo( "DakTankLoadoutPerk" ))
		ply.SpawnPoint = tonumber(ply:GetInfo( "DakTankLoadoutSpawn" ))

		if SpecialType == 8 then
			SpecialType = 12
		end
		if Era == "WWII" then
			if SpecialType == 1 then
				SpecialType = 8
			end
			if SpecialType == 2 then
				SpecialType = 9
			end
		elseif Era == "Modern" then
			if SpecialType == 1 then
				SpecialType = 10
			end
			if SpecialType == 2 then
				SpecialType = 11
			end
		end

		local Primaries = {"dak_ak47","dak_aug","dak_g3sg1","dak_galil","dak_m4a1","dak_sg552","dak_mac10","dak_mp5","dak_p90","dak_tmp","dak_ump"}
		local Secondaries = {"dak_deagle","dak_fiveseven","dak_g18","dak_p228","dak_usp"}
		local Specials = {"dak_at4","dak_dragon","dak_m249","dak_teshotgun","weapon_medkit","dak_ptrs41","dak_ssg08","dak_bazooka","dak_panzerschreck","dak_rpg28","dak_javelin","dak_repair_gun"}

		ply:StripWeapons()
		ply:StripAmmo()
		ply:Give( "gmod_tool", true )
		ply:Give( "weapon_physgun", true )
		ply:Give( "weapon_fists", true )

		if PrimaryType ~= nil then
			ply:Give( Primaries[PrimaryType], false )
			ply:Give( Secondaries[SecondaryType], false )
			ply:Give( Specials[SpecialType], false )
			if ply.PerkType == 1 then
				ply:Give( Primaries[PrimaryType], false )
				ply:Give( Secondaries[SecondaryType], false )
				ply:Give( Specials[SpecialType], false )
			end

			--Caps = ents.FindByClass( "daktank_cap" )
			if ply.SpawnPoint ~= nil then
				local randspawn = math.random(1,4)
				local spawnpos
				if randspawn == 1 then
					spawnpos = (Caps[ply.SpawnPoint]:GetPos()+Vector(100,100,50))
				elseif randspawn == 2 then
					spawnpos = (Caps[ply.SpawnPoint]:GetPos()+Vector(-100,100,50))
				elseif randspawn == 3 then
					spawnpos = (Caps[ply.SpawnPoint]:GetPos()+Vector(100,-100,50))
				else
					spawnpos = (Caps[ply.SpawnPoint]:GetPos()+Vector(-100,-100,50))
				end

				local spawntrace = util.TraceLine( {
					start = spawnpos+Vector(0,0,1000),
					endpos = spawnpos-Vector(0,0,1000),
					mask = MASK_NPCWORLDSTATIC
				} )
				ply:SetPos(spawntrace.HitPos+Vector(0,0,25))
			end
		end
	end
end--Loadout Fill End

local RedBotCount = 0
local BlueBotCount = 0
do--Bot Death Start
	function GM:OnNPCKilled( ply, att, inf )
		if ply ~= att then
			if att:IsPlayer() and IsValid( att ) then
				local PointsGained = 0
				if att:Team()~=ply.DakTeam then
					if att.PerkType == 4 then
						att:SetMaxHealth(att:GetMaxHealth() + 5)
						att:SetHealth(att:GetMaxHealth())
						if att.BloodStacks == nil then att.BloodStacks = 0 end
						att.BloodStacks = att.BloodStacks + 1
					end
					if Era == "WWII" then
						PointsGained = 0.25
					elseif Era == "Cold War" then
						PointsGained = 0.5
					else
						PointsGained = 1.0
					end
					net.Start( "DT_killnotification" )
						net.WriteInt(0, 32)
						net.WriteFloat(PointsGained, 32)
					net.Send( att )
					if not(att:InVehicle()) then att:addPoints( PointsGained ) end
					--if ply.DakTeam == 1 then
						--SetGlobalFloat("DakTankRedResources", GetGlobalFloat("DakTankRedResources") - 1 )
					--elseif ply.DakTeam == 2 then
						--SetGlobalFloat("DakTankBlueResources", GetGlobalFloat("DakTankBlueResources") - 1 )
					--end
				else
					if Era == "WWII" then
						PointsGained = -0.5
					elseif Era == "Cold War" then
						PointsGained = -1.0
					else
						PointsGained = -2.0
					end
					net.Start( "DT_killnotification" )
						net.WriteInt(1, 32)
						net.WriteFloat(PointsGained, 32)
					net.Send( att )
					att:addPoints( PointsGained )
				end
			end
		end
		if ply.DakTeam == 1 then
			RedBotCount = RedBotCount - 1
			SetGlobalFloat("DakTankRedResources", GetGlobalFloat("DakTankRedResources") - 1 )
		elseif ply.DakTeam == 2 then
			BlueBotCount = BlueBotCount - 1
			SetGlobalFloat("DakTankBlueResources", GetGlobalFloat("DakTankBlueResources") - 1 )
		end
		local deathsounds = {
			"npc/combine_soldier/die1.wav",
			"npc/combine_soldier/die2.wav",
			"npc/combine_soldier/die3.wav"
		}
		ply:EmitSound( deathsounds[math.random(1,#deathsounds)], 100, 100 )
	end
end--Bot Death End

do--Player Death Start
	function GM:PlayerDeath( ply, inf, att )
		timer.Destroy( "HPRegen_" .. ply:UniqueID() )
		if ply.BloodStacks ~= nil then ply.BloodStacks = 0 end
		if ply ~= att then
			ply:AddFrags( 1 )
			if att:IsPlayer() and IsValid( att ) then
				local PointsGained = 0
				if att:Team()~=ply:Team() then
					if att.PerkType == 4 then
						att:SetMaxHealth(att:GetMaxHealth() + 25)
						att:SetHealth(att:GetMaxHealth())
						if att.BloodStacks == nil then att.BloodStacks = 0 end
						att.BloodStacks = att.BloodStacks + 5
					end
					if ply:InVehicle() == true then
						if Era == "WWII" then
							PointsGained = 5
						elseif Era == "Cold War" then
							PointsGained = 10
						else
							PointsGained = 20
						end
						net.Start( "DT_killnotification" )
							net.WriteInt(2, 32)
							net.WriteFloat(PointsGained, 32)
						net.Send( att )
						if not(att:InVehicle()) then att:addPoints( PointsGained ) end
						if ply:Team() == 1 then
							SetGlobalFloat("DakTankRedResources", GetGlobalFloat("DakTankRedResources") - 5 )
						elseif ply:Team() == 2 then
							SetGlobalFloat("DakTankBlueResources", GetGlobalFloat("DakTankBlueResources") - 5 )
						end
					else
						if Era == "WWII" then
							PointsGained = 1
						elseif Era == "Cold War" then
							PointsGained = 2
						else
							PointsGained = 5
						end
						net.Start( "DT_killnotification" )
							net.WriteInt(0, 32)
							net.WriteFloat(PointsGained, 32)
						net.Send( att )
						if not(att:InVehicle()) then att:addPoints( PointsGained ) end
						if ply:Team() == 1 then
							SetGlobalFloat("DakTankRedResources", GetGlobalFloat("DakTankRedResources") - 1 )
						elseif ply:Team() == 2 then
							SetGlobalFloat("DakTankBlueResources", GetGlobalFloat("DakTankBlueResources") - 1 )
						end
					end
				else
					if Era == "WWII" then
						PointsGained = -5
					elseif Era == "Cold War" then
						PointsGained = -10
					else
						PointsGained = -20
					end
					net.Start( "DT_killnotification" )
						net.WriteInt(1, 32)
						net.WriteFloat(PointsGained, 32)
					net.Send( att )
					att:addPoints( PointsGained )
				end
			end
		end
		
		for k, v in pairs( player.GetAll() ) do
			if att:IsWorld() then
				local WorldKill = {
					ply:Nick().." went splat.",
					ply:Nick().." took a long fall.",
					"The world hated "..ply:Nick()..".",
					ply:Nick().."'s in a whole lot of pieces.",
					ply:Nick().."'s stain isn't coming out.",
					"There's a little bit of "..ply:Nick().." everywhere.",
					ply:Nick().." just made the janitor's day.",
					ply:Nick().." tripped.",
					ply:Nick().." fell.",
					ply:Nick().." has fallen and can't get up."
				}
				v:ChatPrint(WorldKill[math.random(1,#WorldKill)])
			elseif ply == att then
				local Suicide = {
					ply:Nick().." ownzonerized himself.",
					ply:Nick().." finally did it.",
					ply:Nick().." gave up.",
					ply:Nick().." killed "..ply:Nick()..".",
					ply:Nick().." blew himself up.",
					ply:Nick().." was a good man, what a rotten way to die."
				}
				v:ChatPrint(Suicide[math.random(1,#Suicide)])
			else
				if att:IsPlayer() and att:Nick() ~= nil then
					local Killed = {
						ply:Nick().." just got BLASTED by "..att:Nick(),
						ply:Nick().." just got OWNED by "..att:Nick(),
						ply:Nick().." just got DESTROYED by "..att:Nick(),
						ply:Nick().." just got ABSOLUTELY DEMOLISHED by "..att:Nick(),
						ply:Nick().." just got ANNIHILATED by "..att:Nick()
					}
					v:ChatPrint(Killed[math.random(1,#Killed)])
				else
					if att:GetClass() == "dak_gamemode_bot" then
						local BotKill = {
							ply:Nick().." died to BOTS!",
							ply:Nick().." got TERMINATED.",
							"The bots were too much for "..ply:Nick()..".",
							ply:Nick().." couldn't handle the aimbot",
							ply:Nick().." has been lost to the swarm",
							ply:Nick()..": 0, Machine 1",
						}
						v:ChatPrint(BotKill[math.random(1,#BotKill)])
					else
						local WorldKill = {
							ply:Nick().." went splat.",
							ply:Nick().." took a long fall.",
							"The world hated "..ply:Nick()..".",
							ply:Nick().."'s in a whole lot of pieces.",
							ply:Nick().."'s stain isn't coming out.",
							"There's a little bit of "..ply:Nick().." everywhere.",
							ply:Nick().." just made the janitor's day.",
							ply:Nick().." tripped.",
							ply:Nick().." fell.",
							ply:Nick().." has fallen and can't get up."
						}
						v:ChatPrint(WorldKill[math.random(1,#WorldKill)])
					end
				end
			end
		end
		local deathsounds = {
			"npc/combine_soldier/die1.wav",
			"npc/combine_soldier/die2.wav",
			"npc/combine_soldier/die3.wav"
		}
		ply:EmitSound( deathsounds[math.random(1,#deathsounds)], 100, 100 )
		ply:Spectate( 6 )
		ply:ChatPrint("Respawning in " .. DTTE.RespawnTime .. " seconds")

		timer.Create("RespawnTimer_" .. ply:UniqueID(), DTTE.RespawnTime, 1, function()
			ply:ConCommand( "dt_respawn" )
		end)
	end

	function GM:PlayerDeathThink( ply )
		return false
	end

	function GM:PlayerDeathSound() return true end
end--Player Death End

do--Player Fall Damage Start
	function GM:GetFallDamage( ply, speed )
	    return ( speed / 8 )
	end
end--Player Fall Damage End

do--Player Regeneration Start
	function GM:PlayerHurt ( ply, att, hp, dt )
		timer.Destroy( "HPRegen_" .. ply:UniqueID() )
		if ply.PerkType == 3 then
			timer.Create( "HPRegen_" ..ply:UniqueID(), 1, math.ceil((ply:GetMaxHealth() - ply:Health())*0.2), function()
				if ply.PerkType == 3 then
					ply:SetHealth( ply:Health() + 5)
					if ply:Health()>ply:GetMaxHealth() then ply:SetHealth( ply:GetMaxHealth() ) end
				end
			end )
		end
	end
end--Player Regeneration End

hook.Add( "EntityTakeDamage", "DakTankGamemodeArmor", function( ply, dmginfo )
	if not(ply.ApplyingDamage == true) then
		ply.ApplyingDamage = true
	    if ( ply:IsPlayer() ) then
	    	if ply.ArmorType == 1 then
	    		dmginfo:SetDamage( dmginfo:GetDamage() )
	            --ply:TakeDamageInfo(dmginfo)
	    	elseif ply.ArmorType == 2 then
	    		dmginfo:SetDamage( math.max(0,(dmginfo:GetDamage()-5)) * 0.9 )
	            --ply:TakeDamageInfo(dmginfo)
	        elseif ply.ArmorType == 3 then
	    		dmginfo:SetDamage( math.max(0,(dmginfo:GetDamage()-10)) * 0.8 )
	            --ply:TakeDamageInfo(dmginfo)
	        elseif ply.ArmorType == 4 then
	    		dmginfo:SetDamage( math.max(0,(dmginfo:GetDamage()-15)) * 0.7 )
	            --ply:TakeDamageInfo(dmginfo)
	        elseif ply.ArmorType == 5 then
	    		dmginfo:SetDamage( math.max(0,(dmginfo:GetDamage()-20)) * 0.6 )
	            --ply:TakeDamageInfo(dmginfo)
	    	end
	    else
	    	ply:TakeDamageInfo(dmginfo)
	    end
	    ply.ApplyingDamage = false
	end
end )

do--Player Spawn and Respawn Finalization Start
	function dt_team1( ply )
		ply:SetTeam( 1 )
		ply.DakTeam = 1
		ply:SetModel( "models/player/combine_soldier.mdl" )
		ply:SetSkin( 1 )
		ply:PrintMessage( HUD_PRINTTALK, "Red team picked." )
		timer.Simple(1,function() 
			ply:ConCommand( "dt_respawn" )
		end)
		ply.JustPickedTeam = true
	end
	concommand.Add( "dt_team1", dt_team1 )
	function dt_team2( ply )
		ply:SetTeam( 2 )
		ply.DakTeam = 2
		ply:SetModel( "models/player/combine_super_soldier.mdl" )
		ply:PrintMessage( HUD_PRINTTALK, "Blue team picked." )
		timer.Simple(1,function() 
			ply:ConCommand( "dt_respawn" )
		end)
		ply.JustPickedTeam = true
	end
	concommand.Add( "dt_team2", dt_team2 )
	function dt_respawnfinish( ply )
		ply:UnSpectate()
		ply:Spawn()
		ply.TeamPicked = true
		if ply.JustPickedTeam == true then
			ply:PrintMessage( HUD_PRINTTALK, "Welcome, the era is "..Era..". Please spawn your tanks appropriately." )
			ply.JustPickedTeam = false
		elseif ply.SpawnedFromCap == true then
			ply:PrintMessage( HUD_PRINTTALK, "Loadout Edited." )
			ply.SpawnedFromCap = false
		else
			local RespawnMessages = {
				"Try not dying next time.",
				"Hold the pin, throw the other side.",
				"You're supposed to dodge *out* of the way.",
				"They're still picking pieces of you out of the walls.",
				"Lol you got owned.",
				"That looked like it hurt.",
				"Good thing this isn't economy.",
				"Was that a new record?",
				"I'd tell you how long you survived, but I'm not programmed to.",
				"Go out there and get revenge."
			}
			ply:PrintMessage( HUD_PRINTTALK, RespawnMessages[math.random(1,#RespawnMessages)] )
		end
		
	end
	concommand.Add( "dt_respawnfinish", dt_respawnfinish )
end--Player Spawn and Respawn Finalization End

do--Add Cap Point Start
	local CapCount = 0
	function AddCap(map, pos, team)
		if game.GetMap() == map then
			local cap = ents.Create("daktank_cap")
			if not cap:IsValid() then return end
			cap:SetPos(pos)
			cap:SetCapTeam(team)
			if team == 1 then
				cap.RedTicks = 10
				cap.BlueTicks = 0
			elseif team == 2 then
				cap.RedTicks = 0
				cap.BlueTicks = 10
			else
				cap.RedTicks = 0
				cap.BlueTicks = 0
			end
			CapCount = CapCount + 1
			cap:SetNWInt("number",CapCount)
			cap.Era = Era
			cap:Spawn()
			cap:DropToFloor()
		end
	end
	hook.Add("InitPostEntity", "DakTankCapSpawn", function()
		--Define spawns
		--Example Map
		AddCap("gm_map", Vector(100,0,0), 1 )
		AddCap("gm_map", Vector(0,0,0), 0 )
		AddCap("gm_map", Vector(-100,0,0), 2 )
		--gm_flatgrass
		AddCap("gm_flatgrass", Vector(40.760136, -75.042305, -12223.968750), 0)
		AddCap("gm_flatgrass", Vector(2500, 0, -12223.968750), 1)
		AddCap("gm_flatgrass", Vector(-2500, 0, -12223.968750), 2)
		AddCap("gm_flatgrass", Vector(0, 2500, -12223.968750), 0)
		AddCap("gm_flatgrass", Vector(0, -2500, -12223.968750), 0)
		--gm_bay
		AddCap("gm_bay", Vector(3346.129395, -1509.921021, 211.584290), 1)
		AddCap("gm_bay", Vector(290.891510, -3789.339355, 220.031250), 0)
		AddCap("gm_bay", Vector(-4151.327637, -68.190239, 274.095551), 0)
		AddCap("gm_bay", Vector(-1256.798950, 2300.822021, 138.507370), 0)
		AddCap("gm_bay", Vector(231.229477, 4668.490723, 224.031250), 0)
		AddCap("gm_bay", Vector(4215.393066, 579.943542, 111.919479), 0)
		AddCap("gm_bay", Vector(-4157.171387, 2828.334961, 132.723877), 2)
		--gm_emp_cyclopean
		AddCap("gm_emp_cyclopean", Vector(8343.555664, -10086.312500, 3376.031250), 0)
		AddCap("gm_emp_cyclopean", Vector(6137.738281, 1248.062622, 2719.822266), 0)
		AddCap("gm_emp_cyclopean", Vector(10387.305664, 9959.908203, 3368.031250), 1)
		AddCap("gm_emp_cyclopean", Vector(30.444704, 8613.874023, 2368.031250), 0)
		AddCap("gm_emp_cyclopean", Vector(1834.775024, -1075.389526, 2270.761230), 0)
		AddCap("gm_emp_cyclopean", Vector(-10111.933594, -10227.226563, 3368.031250), 2)
		AddCap("gm_emp_cyclopean", Vector(-5272.229492, 2796.873291, 2737.434570), 0)
		AddCap("gm_emp_cyclopean", Vector(-11754.385742, 10937.160156, 4147.003906), 0)
		--gm_emp_coast
		AddCap("gm_emp_coast", Vector(641.94915771484, 1939.0076904297, 824.03125), 0)
		AddCap("gm_emp_coast", Vector(-360.71417236328, 14465.139648438, 100.83126831055), 0)
		AddCap("gm_emp_coast", Vector(-377.65539550781, -8393.970703125, 537.8193359375), 0)
		AddCap("gm_emp_coast", Vector(11176.348632813, 4945.646484375, 498.98565673828), 0)
		AddCap("gm_emp_coast", Vector(-10717.245117188, -1661.9329833984, 317.25704956055), 0)
		AddCap("gm_emp_coast", Vector(-9371.2109375, 8421.5537109375, 129.69058227539), 1)
		AddCap("gm_emp_coast", Vector(11237.416992188, -5095.6333007813, 128.03125), 2)
		--gm_emp_palmbay
		AddCap("gm_emp_palmbay", Vector(-8020.9624023438, -6747.1743164063, -2330.3911132813), 1)
		AddCap("gm_emp_palmbay", Vector(3700.7368164063, -9836.2275390625, -2575.96875), 1)
		AddCap("gm_emp_palmbay", Vector(3800.0705566406, -1593.5148925781, -2954.0405273438), 0)
		AddCap("gm_emp_palmbay", Vector(10389.444335938, 982.81701660156, -2063.9711914063), 2)
		AddCap("gm_emp_palmbay", Vector(9119.900390625, 10735.4296875, -2331.96875), 2)
		AddCap("gm_emp_palmbay", Vector(-7949.4086914063, 6239.8110351563, -2933.0256347656), 0)
		--gm_emp_canyon
		AddCap("gm_emp_canyon", Vector(11469.577148438, -6255.041015625, 20.59476852417), 2)
		AddCap("gm_emp_canyon", Vector(8473.134765625, 325.95901489258, 520.21319580078), 0)
		AddCap("gm_emp_canyon", Vector(8803.6962890625, 5931.8852539063, 0.47704315185547), 0)
		AddCap("gm_emp_canyon", Vector(11827.244140625, 10962.939453125, 18.160446166992), 0)
		AddCap("gm_emp_canyon", Vector(1796.6341552734, 6945.3681640625, 15.336364746094), 0)
		AddCap("gm_emp_canyon", Vector(747.47930908203, 214.9630279541, 32.358711242676), 0)
		AddCap("gm_emp_canyon", Vector(-8750.994140625, 2618.8464355469, 16.548538208008), 0)
		AddCap("gm_emp_canyon", Vector(-7314.5634765625, 11391.150390625, 25.019695281982), 1)
		AddCap("gm_emp_canyon", Vector(-6729.2905273438, -4935.2368164063, 19.781524658203), 0)
		--gm_emp_bush
		AddCap("gm_emp_bush", Vector(461.644196, -183.797287, -3609.968750), 0)
		AddCap("gm_emp_bush", Vector(1033.4080810547, -11927.537109375, -2931.0432128906), 0)
		AddCap("gm_emp_bush", Vector(-12372.145507813, -11344.141601563, -3327.9558105469), 1)
		AddCap("gm_emp_bush", Vector(-9305.3740234375, 941.68090820313, -3321.1452636719), 0)
		AddCap("gm_emp_bush", Vector(-12777.774414063, 7177.6962890625, -2993.7590332031), 0)
		AddCap("gm_emp_bush", Vector(-6259.2866210938, 2982.8078613281, -3294.0197753906), 0)
		AddCap("gm_emp_bush", Vector(-5839.708984375, -8377.15625, -3647.3486328125), 0)
		AddCap("gm_emp_bush", Vector(-754.16394042969, 9957.4892578125, -3308.4055175781), 0)
		AddCap("gm_emp_bush", Vector(3425.7854003906, 6805.392578125, -2992.5424804688), 0)
		AddCap("gm_emp_bush", Vector(1462.0169677734, -6538.375, -3212.3059082031), 0)
		AddCap("gm_emp_bush", Vector(9223.1982421875, -6720.69140625, -3002.7626953125), 0)
		AddCap("gm_emp_bush", Vector(11080.934570313, -3762.5844726563, -2934.8410644531), 0)
		AddCap("gm_emp_bush", Vector(7897.71875, 2508.1240234375, -3320.9345703125), 0)
		AddCap("gm_emp_bush", Vector(11560.930664063, 12248.51171875, -3327.96875), 0)
		AddCap("gm_emp_bush", Vector(5303.6704101563, 9606.1435546875, -2999.4294433594), 2)
		--gm_emp_mesa
		AddCap("gm_emp_mesa", Vector(10849.646484375, -9665.6513671875, 512.03125), 0)
		AddCap("gm_emp_mesa", Vector(-1935.9918212891, 548.43914794922, 1743.03125), 0)
		AddCap("gm_emp_mesa", Vector(1497.2092285156, 13140.393554688, 160.03125), 0)
		AddCap("gm_emp_mesa", Vector(-2498.0358886719, -13811.28515625, 160.03125), 0)
		AddCap("gm_emp_mesa", Vector(-13969.802734375, -11518.235351563, 608.03125), 1)
		AddCap("gm_emp_mesa", Vector(11756.094726563, 14226.184570313, 192.03125), 2)
		AddCap("gm_emp_mesa", Vector(-10521.319335938, 10493.283203125, 216.35948181152), 0)
		--gm_emp_chain
		AddCap("gm_emp_chain", Vector(13969.4375, 10955.375, -1084.28125+25), 1)
		AddCap("gm_emp_chain", Vector(-13249.75, 9978.21875, -1084.375+25), 2)
		AddCap("gm_emp_chain", Vector(-3358.75, 2094.40625, -1143.6875+25), 2)
		AddCap("gm_emp_chain", Vector(4454.4375, -5777.65625, -1647.6875+25), 1)
		AddCap("gm_emp_chain", Vector(13280.0625, -12846.96875, -1103.4375+25), 1)
		AddCap("gm_emp_chain", Vector(747.125, -2458.8125, -1402.75+25), 0)
		AddCap("gm_emp_chain", Vector(-5281.34375, -8283.0625, -1759.6875+25), 0)
		AddCap("gm_emp_chain", Vector(-13177.53125, -12754.8125, -1135.0625+25), 2)
		AddCap("gm_emp_chain", Vector(-12984.21875, -4274.65625, -1135+25), 0)
		AddCap("gm_emp_chain", Vector(7657.46875, 777.5, -1142.25+25), 0)
		AddCap("gm_emp_chain", Vector(11205.25, -5642.21875, -1135.6875+25), 0)
		AddCap("gm_emp_chain", Vector(14428.59375, 4990.09375, -1143.6875+25), 0)
		AddCap("gm_emp_chain", Vector(1680.15625, 12556.53125, -1143.6875+25), 0)
		AddCap("gm_emp_chain", Vector(-7703, 12065.15625, -1143.6875+25), 0)
		--gm_emp_manticore
		AddCap("gm_emp_manticore", Vector(-4293.71875, 4164.875, 1719.71875), 1)
		AddCap("gm_emp_manticore", Vector(4521.40625, -4828.6875, 1719.3125), 2)
		AddCap("gm_emp_manticore", Vector(2880.625, 1123.6875, 1179.03125), 0)
		AddCap("gm_emp_manticore", Vector(-5548.21875, -239.375, 1239.78125), 0)
		AddCap("gm_emp_manticore", Vector(-7461.90625, 9851.3125, 1211.1875), 1)
		AddCap("gm_emp_manticore", Vector(7434.4375, -11102.09375, 1159.3125), 2)
		AddCap("gm_emp_manticore", Vector(-2540.9375, -3092.9375, 1719.3125), 0)
		AddCap("gm_emp_manticore", Vector(4242.375, 5819.125, 1719.28125), 0)
		AddCap("gm_emp_manticore", Vector(10482.78125, -198.15625, 1735.375), 0)
		AddCap("gm_emp_manticore", Vector(-12926.375, -4013.46875, 1671.40625), 0)
		AddCap("gm_emp_manticore", Vector(-12635.03125, 2757.21875, 1670.53125), 0)

		Caps = ents.FindByClass( "daktank_cap" )
	end)
end--Add Cap Point End

local LastBlueCount = nil
local LastRedCount = nil
local RedOvertime = 0
local BlueOvertime = 0
local mapreset = false
SetGlobalBool("gameover",false)

do--Conquest point ticker Start
	local LastThink = CurTime()
	local BlueScore750 = false
	local RedScore750 = false
	local BlueScore500 = false
	local RedScore500 = false
	local BlueScore250 = false
	local RedScore250 = false
	local BlueScore100 = false
	local RedScore100 = false
	function GM:Think()
		if CurTime()>=LastThink+1 then
			LastThink = CurTime()
			local BlueCount = 0
			local RedCount = 0
			for i=1, #Caps do
				if IsValid(Caps[i]) then
					if Caps[i]:GetCapTeam() == 1 then RedCount = RedCount + 1 end
					if Caps[i]:GetCapTeam() == 2 then BlueCount = BlueCount + 1 end
				end
			end
			if RedCount > BlueCount then
				SetGlobalFloat("DakTankBlueResources", GetGlobalFloat("DakTankBlueResources") - (RedCount-BlueCount))
			end
			if RedCount < BlueCount then
				SetGlobalFloat("DakTankRedResources", GetGlobalFloat("DakTankRedResources") - (BlueCount-RedCount))
			end

			if GetGlobalFloat("DakTankBlueResources") < 750 then
				if BlueScore750 == false then
					net.Start( "DakTankGamemodeNotification" )
						net.WriteInt(19, 32)
						net.WriteInt(0, 32)
					net.Broadcast()
					BlueScore750 = true
				end
			end
			if GetGlobalFloat("DakTankRedResources") < 750 then
				if RedScore750 == false then
					net.Start( "DakTankGamemodeNotification" )
						net.WriteInt(20, 32)
						net.WriteInt(0, 32)
					net.Broadcast()
					RedScore750 = true
				end
			end
			if GetGlobalFloat("DakTankBlueResources") < 500 then
				if BlueScore500 == false then
					net.Start( "DakTankGamemodeNotification" )
						net.WriteInt(21, 32)
						net.WriteInt(0, 32)
					net.Broadcast()
					BlueScore500 = true
				end
			end
			if GetGlobalFloat("DakTankRedResources") < 500 then
				if RedScore500 == false then
					net.Start( "DakTankGamemodeNotification" )
						net.WriteInt(22, 32)
						net.WriteInt(0, 32)
					net.Broadcast()
					RedScore500 = true
				end
			end
			if GetGlobalFloat("DakTankBlueResources") < 250 then
				if BlueScore250 == false then
					net.Start( "DakTankGamemodeNotification" )
						net.WriteInt(23, 32)
						net.WriteInt(0, 32)
					net.Broadcast()
					BlueScore250 = true
				end
			end
			if GetGlobalFloat("DakTankRedResources") < 250 then
				if RedScore250 == false then
					net.Start( "DakTankGamemodeNotification" )
						net.WriteInt(24, 32)
						net.WriteInt(0, 32)
					net.Broadcast()
					RedScore250 = true
				end
			end
			if GetGlobalFloat("DakTankBlueResources") < 100 then
				if BlueScore100 == false then
					net.Start( "DakTankGamemodeNotification" )
						net.WriteInt(9, 32)
						net.WriteInt(0, 32)
					net.Broadcast()
					BlueScore100 = true
				end
			end
			if GetGlobalFloat("DakTankRedResources") < 100 then
				if RedScore100 == false then
					net.Start( "DakTankGamemodeNotification" )
						net.WriteInt(10, 32)
						net.WriteInt(0, 32)
					net.Broadcast()
					RedScore100 = true
				end
			end

			if LastBlueCount ~= BlueCount or LastRedCount ~= RedCount then
				local TransmitTable = {}
				for i=1, #Caps do
					if IsValid(Caps[i]) then
						TransmitTable[#TransmitTable+1] = {Caps[i]:GetNWInt("number"),Caps[i]:GetCapTeam(),Caps[i]:GetPos()}
					end
				end
				net.Start( "DT_caps" )
					net.WriteTable( TransmitTable )
				net.Broadcast()
			end
			LastBlueCount = BlueCount
			LastRedCount = RedCount
			if RedCount <= 0 and BlueCount > 0 and RedOvertime == 0 then
				net.Start( "DakTankGamemodeNotification" )
					net.WriteInt(11, 32)
					net.WriteInt(0, 32)
				net.Broadcast()
				--PlayerList[i]:ChatPrint("Red Team has 30 seconds left to get a cap.")
				timer.Create( "RedNoCaps" ..math.Rand(0,1000), 1, 30, function()
					local BlueCount = 0
					local RedCount = 0
					for i=1, #Caps do 
						if IsValid(Caps[i]) then
							if Caps[i]:GetCapTeam() == 1 then RedCount = RedCount + 1 end
							if Caps[i]:GetCapTeam() == 2 then BlueCount = BlueCount + 1 end
						end
					end
					if RedCount <= 0 and BlueCount > 0 then
						RedOvertime = RedOvertime + 1
						if RedOvertime == 10 then
							net.Start( "DakTankGamemodeNotification" )
								net.WriteInt(12, 32)
								net.WriteInt(0, 32)
							net.Broadcast()
							--PlayerList[i]:ChatPrint("Red Team only has 20 seconds left to get a cap.")
						elseif RedOvertime == 20 then
							net.Start( "DakTankGamemodeNotification" )
								net.WriteInt(13, 32)
								net.WriteInt(0, 32)
							net.Broadcast()
							--PlayerList[i]:ChatPrint("Red Team has just 10 seconds left to get a cap.")
						elseif RedOvertime == 30 then
							SetGlobalBool("gameover",true)
							net.Start( "DakTankGamemodeNotification" )
								net.WriteInt(1, 32)
								net.WriteInt(0, 32)
							net.Broadcast()
							--PlayerList[i]:ChatPrint("Blue Team has won by capturing all points, map restarts in 30 seconds.")
						end
					else
						if RedOverTime > 0 then
							RedOvertime = 0
							net.Start( "DakTankGamemodeNotification" )
								net.WriteInt(14, 32)
								net.WriteInt(0, 32)
							net.Broadcast()
						end
						--PlayerList[i]:ChatPrint("Red Team has survived overtime.")
					end
				end )
			elseif BlueCount <= 0 and RedCount > 0 and BlueOvertime == 0 then
				net.Start( "DakTankGamemodeNotification" )
					net.WriteInt(15, 32)
					net.WriteInt(0, 32)
				net.Broadcast()
				--PlayerList[i]:ChatPrint("Red Team has 30 seconds left to get a cap.")
				timer.Create( "BlueNoCaps" ..math.Rand(0,1000), 1, 30, function()
					local BlueCount = 0
					local RedCount = 0
					for i=1, #Caps do 
						if IsValid(Caps[i]) then
							if Caps[i]:GetCapTeam() == 1 then RedCount = RedCount + 1 end
							if Caps[i]:GetCapTeam() == 2 then BlueCount = BlueCount + 1 end
						end
					end
					if BlueCount <= 0 and RedCount > 0 then
						BlueOvertime = BlueOvertime + 1
						if BlueOvertime == 10 then
							net.Start( "DakTankGamemodeNotification" )
								net.WriteInt(16, 32)
								net.WriteInt(0, 32)
							net.Broadcast()
							--PlayerList[i]:ChatPrint("Blue Team only has 20 seconds left to get a cap.")
						elseif BlueOvertime == 20 then
							net.Start( "DakTankGamemodeNotification" )
								net.WriteInt(17, 32)
								net.WriteInt(0, 32)
							net.Broadcast()
							--PlayerList[i]:ChatPrint("Blue Team has just 10 seconds left to get a cap.")
						elseif BlueOvertime == 30 then
							SetGlobalBool("gameover",true)
							net.Start( "DakTankGamemodeNotification" )
								net.WriteInt(2, 32)
								net.WriteInt(0, 32)
							net.Broadcast()
							--PlayerList[i]:ChatPrint("Red Team has won by capturing all points, map restarts in 30 seconds.")
						end
					else
						if BlueOvertime > 0 then
							BlueOvertime = 0
							net.Start( "DakTankGamemodeNotification" )
								net.WriteInt(18, 32)
								net.WriteInt(0, 32)
							net.Broadcast()
						end
						--PlayerList[i]:ChatPrint("Blue Team has survived overtime.")
					end
				end )
			end
			if GetGlobalBool("gameover") == false then
				if GetGlobalFloat("DakTankBlueResources") <= 0 then
					net.Start( "DakTankGamemodeNotification" )
						net.WriteInt(3, 32)
						net.WriteInt(0, 32)
					net.Broadcast()
						--PlayerList[i]:ChatPrint("Red Team has won by attrition, map restarts in 30 seconds.")
					SetGlobalBool("gameover",true)
				elseif GetGlobalFloat("DakTankRedResources") <= 0 then
					net.Start( "DakTankGamemodeNotification" )
						net.WriteInt(4, 32)
						net.WriteInt(0, 32)
					net.Broadcast()
					--PlayerList[i]:ChatPrint("Blue Team has won by attrition, map restarts in 30 seconds.")
					SetGlobalBool("gameover",true)
				end
			end
			if GetGlobalBool("gameover")==true and mapreset == false then
				mapreset = true
				timer.Create( "DakTankGamemodeMapChange", 30, 1, function()
					local NewMaps = table.Copy( MapList )
					table.RemoveByValue(NewMaps,game.GetMap())
					RunConsoleCommand("changelevel",NewMaps[math.random(1,#NewMaps)])
				end)
			end

			do--Bot Spawn Start
				if RedBotCount < BotMax or BlueBotCount < BotMax then
					local redcaps = {}
					local bluecaps = {}
					for i=1, #Caps do
						if IsValid(Caps[i]) then
							if Caps[i]:GetCapTeam() == 1 then
								redcaps[#redcaps+1] = Caps[i]
							end
							if Caps[i]:GetCapTeam() == 2 then
								bluecaps[#bluecaps+1] = Caps[i]
							end
						end
					end
					if RedBotCount < BotMax then
						for i=1, BotMax-RedBotCount do
							local rand1 = math.random(0,1)
							local rand2 = math.random(0,1)
							local mult1 = -1
							if rand1 == 1 then
								mult1 = 1
							end
							local mult2 = -1
							if rand2 == 1 then
								mult2 = 1
							end
							local spawnpos = (redcaps[math.random(1,#redcaps)]:GetPos()+Vector(math.Rand(50,150)*mult1,math.Rand(50,150)*mult2,50))
							local spawntrace = util.TraceHull( {
								start = spawnpos+Vector(0,0,1000),
								endpos = spawnpos-Vector(0,0,1000),
								mins = Vector(-50,-50,5),
								maxs = Vector(50,50,10),
							} )
							if spawntrace.Entity:IsWorld() == true then
								DTTE.CreateBot(spawntrace.HitPos + Vector(0, 0, 25), 1)
								RedBotCount = RedBotCount + 1
							end
						end
					end
					if BlueBotCount < BotMax then
						for i=1, BotMax-BlueBotCount do
							local rand1 = math.random(0,1)
							local rand2 = math.random(0,1)
							local mult1 = -1
							if rand1 == 1 then
								mult1 = 1
							end
							local mult2 = -1
							if rand2 == 1 then
								mult2 = 1
							end
							local spawnpos = (bluecaps[math.random(1,#bluecaps)]:GetPos()+Vector(math.Rand(50,150)*mult1,math.Rand(50,150)*mult2,50))
							local spawntrace = util.TraceHull( {
								start = spawnpos+Vector(0,0,1000),
								endpos = spawnpos-Vector(0,0,1000),
								mins = Vector(-50,-50,5),
								maxs = Vector(50,50,10),
							} )
							if spawntrace.Entity:IsWorld() == true then
								DTTE.CreateBot(spawntrace.HitPos + Vector(0, 0, 25), 2)
								BlueBotCount = BlueBotCount + 1
							end
						end
					end
				end
			end--Bot Spawn End

			do--send bot info
			--it's kinda really laggy to do this and eliminates fps
			--[[
				local bots = ents.FindByClass("dak_gamemode_bot")
				local redbotpos = {}
				local redbotang = {}
				local bluebotpos = {}
				local bluebotang = {}
				for i=1, #bots do
					if bots[i].DakTeam == 1 then
						redbotpos[#redbotpos+1] = bots[i]:GetPos()
						redbotang[#redbotang+1] = bots[i]:GetAngles()
					end
					if bots[i].DakTeam == 2 then
						bluebotpos[#bluebotpos+1] = bots[i]:GetPos()
						bluebotang[#bluebotang+1] = bots[i]:GetAngles()
					end
				end
				net.Start( "DT_bots" )
					net.WriteString(util.TableToJSON( redbotpos ))
					net.WriteString(util.TableToJSON( bluebotpos ))
				net.Broadcast()
			]]--
			end--send bot info
		end
	end
end--Conquest point ticker End

do--Gamemode restrictions Start
	hook.Add( "PlayerNoClip", "DakTankGamemodeNoNoClip", function(ply, ent)
		return false
	end)
	hook.Add("PhysgunPickup", "DakTankGamemodeNoPhysgunHold", function(ply, ent)
		return false
	end)
end--Gamemode restrictions End

do--Contraption Spawning Start
	local function GetPhysCons( ent, Results )
		local Results = Results or {}
		if not IsValid( ent ) then return end
			if Results[ ent ] then return end
			Results[ ent ] = ent
			local Constraints = constraint.GetTable( ent )
			for k, v in ipairs( Constraints ) do
				if not (v.Type == "NoCollide") then
					for i, Ent in pairs( v.Entity ) do
						GetPhysCons( Ent.Entity, Results )
					end
				end
			end
		return Results
	end

	local function GetParents( ent, Results )
		local Results = Results or {}
		local Parent = ent:GetParent()
		Results[ ent ] = ent
		if IsValid(Parent) then
			GetParents(Parent, Results)
		end
		return Results
	end

	hook.Add( "OnPhysgunReload", "DakTankUnfreeze", function(physgun,ply) 
		local trace = ply:GetEyeTrace()
		if IsValid(trace.Entity) then
			if trace.Entity.DakGamemodeSpawned == nil then
				local Contraption = {}
				table.Add(Contraption,GetParents(trace.Entity))
				for k, v in pairs(GetParents(trace.Entity)) do
					table.Add(Contraption,GetPhysCons(v))
				end
				local Mass = 0
				for i=1, #Contraption do
					table.Add( Contraption, Contraption[i]:GetChildren() )
					table.Add( Contraption, Contraption[i]:GetParent() )
				end
				local Children = {}
				for i2=1, #Contraption do
					if table.Count(Contraption[i2]:GetChildren()) > 0 then
						table.Add( Children, Contraption[i2]:GetChildren() )
					end
				end
				table.Add( Contraption, Children )
				local hash = {}
				local res = {}
				for _,v in ipairs(Contraption) do
		   			if (not hash[v]) then
		    			res[#res+1] = v
		    	   		hash[v] = true
		   			end
				end
				local Core = nil
				for i=1, #res do
					if res[i]:GetClass() == "dak_tankcore" then
						Core = res[i]
					end
				end
				if Core ~= nil then
					if Core.CanSpawn == true then
						if ply:getPoints() < Core.Cost then
							for i=1, #res do
								if IsValid(res[i]) then
									res[i]:Remove()
								end
							end
							ply:ChatPrint("You don't have the resources for this right now, removing, Cost: "..Core.Cost)
						else
							if Era == "WWII" then
								if Core.Modern == 1 or Core.ColdWar == 1 then
									ply:ChatPrint("Current era is WWII, your tank is from the future, removing.")
									for i=1, #res do
										if IsValid(res[i]) then
											res[i]:Remove()
										end
									end
								else
									for i=1, #res do
										if res[i]:IsSolid() then
											res[i].DakGamemodeSpawned = 1
										end
									end
									local PlayerList = player.GetAll()	
									for i=1, #PlayerList do
										if ply.DakTeam == PlayerList[i].DakTeam then
											PlayerList[i]:ChatPrint(ply:GetName().." has spawned a "..math.Round(Core.Cost,0).." point vehicle.")
										end
									end
									Core.LegalUnfreeze = true
									ply:addPoints(-Core.Cost)
								end
							elseif Era == "Cold War" then
								if Core.Modern == 1 then
									ply:ChatPrint("Current era is Cold War, your tank is from the future, removing.")
									for i=1, #res do
										if IsValid(res[i]) then
											res[i]:Remove()
										end
									end
								else
									for i=1, #res do
										if res[i]:IsSolid() then
											res[i].DakGamemodeSpawned = 1
										end
									end
									local PlayerList = player.GetAll()	
									for i=1, #PlayerList do
										if ply.DakTeam == PlayerList[i].DakTeam then
											PlayerList[i]:ChatPrint(ply:GetName().." has spawned a "..math.Round(Core.Cost,0).." point vehicle.")
										end
									end
									Core.LegalUnfreeze = true
									ply:addPoints(-Core.Cost)
								end
							else
								for i=1, #res do
									if res[i]:IsSolid() then
										res[i].DakGamemodeSpawned = 1
									end
								end
								local PlayerList = player.GetAll()	
								for i=1, #PlayerList do
									if ply.DakTeam == PlayerList[i].DakTeam then
										PlayerList[i]:ChatPrint(ply:GetName().." has spawned a "..math.Round(Core.Cost,0).." point vehicle.")
									end
								end
								Core.LegalUnfreeze = true
								ply:addPoints(-Core.Cost)
							end
						end
					else
						ply:ChatPrint("You are attempting to unfreeze the vehicle too quickly after spawning, please wait.")
						return false
					end
				else
					ply:ChatPrint("No TankCore detected on contraption, removing.")
					for i=1, #res do
						if IsValid(res[i]) then
							res[i]:Remove()
						end
					end
				end
			end
		end
	end)
end--Contraption Spawning End

do--EZ enter vehicle Start
	hook.Add( "PlayerUse", "DakTankEasyVehicleEnter", function( ply, ent )
		if ply.LastInVehicle == nil then
			ply.LastInVehicle = 0
		end
		if CurTime()-1 > ply.LastInVehicle then
			if ply:InVehicle() == false then
				if ent.Controller and ent.Controller:IsValid() then
					if ent.Controller.Seats[1]:IsValid() then
						ply:EnterVehicle( ent.Controller.Seats[1] )
					end
				end
			end
		end
	end )

	function GM:CanExitVehicle(veh, ply)
		ply.LastInVehicle = CurTime()
	    return true
	end
end--EZ enter vehicle end

--[[
hook.Add( "PlayerUse", "DakTankSalvage", function( ply, ent )
	if ply.LastSalvageAttemptTime == nil then
		ply.LastSalvageAttemptTime = 0
	end
	if ply.DakTankSalvageStacks == nil then
		ply.DakTankSalvageStacks = 0
	end
	if ent.Controller:IsValid() then
		if ply.LastSalvageAttemptEnt == ent.Controller then
			ply.DakTankSalvageStacks = ply.DakTankSalvageStacks + 1
		else
			ply.DakTankSalvageStacks = 0
		end
		ply.LastSalvageAttemptEnt = ent.Controller
		ply.LastSalvageAttemptTime = CurTime()

		print(ply.DakTankSalvageStacks)
	end
end)
]]--