AddCSLuaFile()

ENT.Base 			= "dak_bot_base"
ENT.Spawnable		= true

if not(GLOBALreddaktroopers) then
	GLOBALreddaktroopers = {}
end
if not(GLOBALbluedaktroopers) then
	GLOBALbluedaktroopers = {}
end

function ENT:Initialize()
	if SERVER then
		------------------------------------------
		----------------EDIT START----------------
		------------------------------------------

		--self:SetBloodColor( BLOOD_COLOR_YELLOW ) --uncomment to set blood color of bot
		self.SpeedMult = 1 --multiplier to movement speed
		--self.DakTeam = 2 --sets the bot's team, bots will not attack other bots of the same team, does not effect players unless players are given this flag
		self.AttackPlayers = true --will got bot target players
		self.Stationary = false --will bot stand still and defend one spot when not following
		
		self.meleerange = 75 --range that a melee attack can hit from
		self.MeleeDamage = 25 --damage of melee attack

		self.RandomDelay = math.Rand(10,20) --randomized delay between playing idle sounds and swapping between on the move tactics (burst fire vs full auto)
		self.ShortRandomDelay = math.Rand(1,3) --randomized delay between picking a direction to move in when in combat and dodging

		self.SpeedBoostOnStuck = 1.25 --speed boost for when bot is walking around an obstacle
		
 		if self.BotType == nil then
			self.BotType = math.random(1,10) --note: set this value to be something like math.random(1,2) if you want a second bot that spawns in with a 50% rate, set it to 1,3 for a 33% rate or for extra bots
		end
		self.DakTank = true
		--Rifleman
		self.HealthMult = 1 --multiplies bot health, base value is 100, please edit this value here instead of editing the base value
		self.ShotCount = 1 --shots fired per trigger pull, basically can make a shotgun
		self.GunModel = "models/weapons/w_rif_ak47.mdl" --model for gun that bot will hold
		self.FireSound = "weapons/ak47/ak47-1.wav" --fire sound for gun
		self.BaseSpread = 1 --base spread value, is modified when the bot crouches or is running
		self.MagSize = 30 --shots per magazine
		self.ReloadTime = 2 --time it takes to reload magazine
		self.PrimaryForce = 40 --impact force of shot
		self.PrimaryDamage = 40 --damage of shot
		self.PrimaryCooldown = 0.1 --time between each shot
		self.BurstMin = 1 --minimum amount of bullets bot can fire in a burst
		self.BurstMax = 3 --maximum amount of bullets bot can fire in a burst (note, the bot still can do full auto, but that is another tactic)
		self.shootrange = 2500 --effective range for bot, they'll still fire at targets very far off, but with extremely bad accuracy
		self.NadeCooldown = 10 --minimum time between grenade throws
		self.CrouchingHitChance = 50 --80% chance to hit when bot is stationary and crouched
		self.StandingHitChance = 30 --60% chance to hit when bot is standing still and firing
		self.RunningBurstHitChance = 15 --40% chance to hit when bot is moving around and firing in controlled bursts
		self.RunningFullAutoHitChance = 5 --20% chance to hit when bot is moving and firing in full auto
		self.DakTrail = "dakteballistictracer"
		self.DakCaliber = 7.62
		self.DakShellType = "AP"
		self.DakPenLossPerMeter = 0.0005
		self.DakExplosive = false
		self.DakVelocity = 28200
		self.ShellLengthMult = self.DakVelocity/29527.6
		self.ShootVehicles = false

		--secondary bot example, it will not spawn in unless BotType is set to 2, for example by using the bot type setting variable above
		if self.BotType == 10 or self.BotType == 9 or self.BotType == 8 then --AT
			self.HealthMult = 1
			self.ShotCount = 1
			self.GunModel = "models/weapons/w_rocket_launcher.mdl"
			self.FireSound = "daktanks/extra/76mmUSA2.mp3"
			self.BaseSpread = 0.25
			
			self.PrimaryCooldown = 5
			self.BurstMin = 1
			self.BurstMax = 1

			self.MagSize = 1
			self.ReloadTime = 2

			self.shootrange = 1500

			self.DakTrail = "daktemissiletracer"
			self.DakCaliber = 84
			self.DakShellType = "HEATFS"
			self.DakPenLossPerMeter = 0
			self.DakExplosive = true
			self.ShellLengthMult = 1
			self.DakVelocity = 7500
			self.ShootVehicles = true

			self.CrouchingHitChance = 100
			self.StandingHitChance = 100
			self.RunningBurstHitChance = 100
			self.RunningFullAutoHitChance = 100
		end
		if self.BotType == 7 then --Shotgun
			self.HealthMult = 1
			self.ShotCount = 10
			self.GunModel = "models/weapons/w_shotgun.mdl"
			self.FireSound = "weapons/xm1014/xm1014-1.wav"
			self.BaseSpread = 2.5
			
			self.MagSize = 5
			self.ReloadTime = 2

			self.PrimaryCooldown = 0.2
			self.BurstMin = 1
			self.BurstMax = 3

			self.shootrange = 500

			self.DakTrail = "dakteballistictracer"
			self.DakCaliber = 5.56
			self.DakShellType = "AP"
			self.DakPenLossPerMeter = 0.0005
			self.DakExplosive = false
			self.ShellLengthMult = 0.5
			self.DakVelocity = 25000
			self.ShootVehicles = false

			self.CrouchingHitChance = 100
			self.StandingHitChance = 100
			self.RunningBurstHitChance = 100
			self.RunningFullAutoHitChance = 100
		end
		--[[
		if self.BotType == 6 then --Sniper
			self.HealthMult = 1
			self.ShotCount = 1
			self.GunModel = "models/weapons/w_snip_awp.mdl"
			self.FireSound = "weapons/g3sg1/g3sg1-1.wav"
			self.BaseSpread = 1
			
			self.MagSize = 1
			self.ReloadTime = 1

			self.PrimaryCooldown = 1
			self.BurstMin = 1
			self.BurstMax = 1

			self.shootrange = 4000

			self.DakTrail = "dakteballistictracer"
			self.DakCaliber = 14.5
			self.DakShellType = "AP"
			self.DakPenLossPerMeter = 0.0005
			self.DakExplosive = false
			self.ShellLengthMult = 1.1
			self.DakVelocity = 39370
			self.ShootVehicles = true

			self.CrouchingHitChance = 50
			self.StandingHitChance = 30
			self.RunningBurstHitChance = 10
			self.RunningFullAutoHitChance = 5
		end
		]]--
		if self.BotType == 6 then --MG
			self.HealthMult = 1
			self.ShotCount = 1
			self.GunModel = "models/weapons/w_mach_m249para.mdl"
			self.FireSound = "weapons/m249/m249-1.wav"
			self.BaseSpread = 1.1
			
			self.MagSize = 200
			self.ReloadTime = 5

			self.PrimaryCooldown = 0.07
			self.BurstMin = 25
			self.BurstMax = 50

			self.shootrange = 3000

			self.DakTrail = "dakteballistictracer"
			self.DakCaliber = 5.56
			self.DakShellType = "AP"
			self.DakPenLossPerMeter = 0.0005
			self.DakExplosive = false
			self.DakVelocity = 36000
			self.ShellLengthMult = self.DakVelocity/29527.6
			self.ShootVehicles = false

			self.CrouchingHitChance = 25
			self.StandingHitChance = 15
			self.RunningBurstHitChance = 5
			self.RunningFullAutoHitChance = 2
		end
		if self.BotType == 5 or self.BotType == 4 then --SMG
			self.HealthMult = 1
			self.ShotCount = 1
			self.GunModel = "models/weapons/w_smg_ump45.mdl"
			self.FireSound = "weapons/ump45/ump45-1.wav"
			self.BaseSpread = 1.5
			
			self.MagSize = 25
			self.ReloadTime = 2

			self.PrimaryCooldown = 0.1
			self.BurstMin = 10
			self.BurstMax = 25

			self.shootrange = 1500

			self.DakTrail = "dakteballistictracer"
			self.DakCaliber = 11.43
			self.DakShellType = "AP"
			self.DakPenLossPerMeter = 0.0005
			self.DakExplosive = false
			self.DakVelocity = 11220
			self.ShellLengthMult = self.DakVelocity/29527.6
			self.ShootVehicles = false

			self.CrouchingHitChance = 75
			self.StandingHitChance = 45
			self.RunningBurstHitChance = 30
			self.RunningFullAutoHitChance = 10
		end

		self.DeathSoundList = {
			"npc/combine_soldier/die1.wav",
			"npc/combine_soldier/die2.wav",
			"npc/combine_soldier/die3.wav"
		}

		self.MovementAnimation = "RunALL" --running animation when not in combat
		self.CombatMovementAnimation = "RunAIMALL1" --running animation when in combat, please use an animation which is setup for aiming
		self.IdleAnimation = "Idle1" --animation when bot is doing nothing
		self.CombatIdleAnimation = "CombatIdle1" --animation when bot is in combat and stationary
		self.WalkAnimationMult = 1 --multiplier for the walking animation's play speed
		
		------------------------------------------
		-----------------EDIT END-----------------
		------------------------------------------
		self:SetModel( "models/Combine_Soldier.mdl" )

		self.SpeedMult = self.SpeedMult * 1
		self.HealthMult = self.HealthMult * 1
		self.PrimaryForce = self.PrimaryForce * 1
		self.PrimaryDamage = self.PrimaryDamage * 1

		local finalgoalvalue = math.random(1,3)
		if finalgoalvalue == 1 then
			self.FinalGoal = Vector(-595.649902, -858.946228, 957.299561)
		end
		if finalgoalvalue == 2 then
			self.FinalGoal = Vector(9342.692383, 12371.257813, -1058.609497)
		end
		if finalgoalvalue == 3 then
			self.FinalGoal = Vector(-12851.048828, -13006.345703, -1215.968750)
		end

		self.Entity:SetCollisionBounds( Vector(-16,-16,0), Vector(16,16,80) ) 
		self.HasEnemy = 0
	    self.LastLostEnemy = 0
	    self.PrimaryLastFire = 0
	    self.LastThink = 0
 		self.Lastchecktrace = 0
 		self.OldNode = 0
 		self.StartPos = self:GetPos()
		self.LastFind = 0
		self.LastReset = 0
		self.StuckTimer = 0
		self.LastIdleSound = CurTime()
		self.NadeLastFire = 0
		self.FindDelay = 0.2
		self.TargetSwapFireDelay = 0.2
		self.TargetAge = 0
		self.Tactic = 0
		self.WeaveDir = 0
		self.LastWeaveChange = 0
		self.lasty = 0
		self.lastp = 0
		self.AllyLastSpeakTime = 0
		self.LastEnemyDiedTime = 0
		self.LastUse = 0
		self.commander = nil
		self.shouldmove = 0
		self.Squad = {self}
 		self.Leader = self
 		self.LastBurstTime = 0
 		self.CurRunBurst = 0
 		self.LastRunBurstTime = 0
 		self:Pathfind()
 		self.ShotsSinceReload = 0

 		if self.DakTeam == nil then
 			if #GLOBALreddaktroopers >= #GLOBALbluedaktroopers then
 				self.DakTeam = 2
 			else
 				self.DakTeam = 1
 			end
			--self.DakTeam = math.random(1,2)
		end
 		if self.DakTeam == 1 then
 			GLOBALreddaktroopers[#GLOBALreddaktroopers+1] = self
 			self:SetModel( "models/Combine_Soldier.mdl" )
 			--self:SetColor(Color(255,0,0,255))
 			self:SetSkin( 1 )
 		end
 		if self.DakTeam == 2 then
 			GLOBALbluedaktroopers[#GLOBALbluedaktroopers+1] = self
 			self:SetModel( "models/Combine_Super_Soldier.mdl" )
 			--self:SetColor(Color(0,0,255,255))
 			--self:SetSkin( 0 )
 		end

		local enemy = ents.FindByClass( "npc_*" ) --Find any spawned entity in map with class beginning at npc
		if IsValid(self.NPCTarget1) then
			for _, x in pairs( enemy ) do --for every found entity do
				if x:IsNPC() then
					if x:GetClass() != self.NPCTarget1:GetClass() then -- if found entity is not self entity then continue
						x:AddEntityRelationship( self.NPCTarget1, D_HT, 99 ) -- found entity will hate self entity
						x:AddEntityRelationship( self.NPCTarget2, D_HT, 99 )
						x:AddEntityRelationship( self.NPCTarget3, D_HT, 99 )
						x:AddEntityRelationship( self.NPCTarget4, D_HT, 99 )
					end
				end
			end
		end

		self:SetHealth(100*self.HealthMult)
		if not IsValid(self.Weapon) then
	        self:GiveWeapon(self.GunModel)
	    end
	    --the base isn't actually a nextbot, I use this so it shows up as based on a nextbot for ease of finding either these types of bots or nextbots
	    self.Base = "base_nextbot"
	end
end

list.Set( "NPC", "dak_gamemode_bot", {
	Name = "DakTank Gamemode Trooper",
	Class = "dak_gamemode_bot",
	Category = "DakTank Gamemode"
} )