AddCSLuaFile()

ENT.Base 	  = "base_nextbot"
ENT.Spawnable = true


DTTE.Bots = {
	Red = {},
	Blue = {}
}

function DTTE.KillBots()
	for _, v in ipairs(ents.FindByClass("dak_gamemode_bot")) do
		v:Remove()
	end
end

function DTTE.CreateBot(Pos, Team)
	Team = Team or (table.Count(DTTE.Bots.Blue) >= table.Count(DTTE.Bots.Red) and 1 or 2)

	local bot = ents.Create("dak_gamemode_bot")

	bot:SetPos(Pos)
	bot:SetAngles(Angle())

	if Team == 1 then
		bot:SetModel("models/Combine_Soldier.mdl")
		bot:SetSkin(1)

		DTTE.Bots.Red[bot] = true
	elseif Team == 2 then
		bot:SetModel("models/Combine_Super_Soldier.mdl")

		DTTE.Bots.Blue[bot] = true
	end

	bot:Spawn()

	bot.DakTeam = Team
	bot.Paths   = DTTE.Paths
	bot.Era     = DTTE.Era
	bot.Filter  = {bot}
end

do -- Sounds
	local Alert = {
		"npc/metropolice/vo/allunitsmovein.wav",
		"npc/combine_soldier/vo/movein.wav",
		"npc/combine_soldier/vo/prepforcontact.wav",
		"npc/combine_soldier/vo/contactconfim.wav",
		"npc/combine_soldier/vo/contact.wav",
		"npc/combine_soldier/vo/engaging.wav",
		"npc/combine_soldier/vo/sectorisnotsecure.wav",
		"npc/metropolice/vo/thereheis.wav",
		"npc/combine_soldier/vo/readyweaponshostilesinbound.wav",
		"npc/combine_soldier/vo/weaponsoffsafeprepforcontact.wav"
	}
	local Reload = {
		"npc/metropolice/vo/backmeupimout.wav",
		"npc/combine_soldier/vo/coverme.wav"
	}
	local Hurt = {
		"npc/metropolice/pain1.wav",
		"npc/metropolice/pain2.wav",
		"npc/metropolice/pain3.wav",
		"npc/metropolice/pain4.wav"
	}
	local Grenade = {
		"npc/metropolice/vo/grenade.wav",
		"npc/metropolice/vo/thatsagrenade.wav"
	}
	local Follow = {
		"npc/combine_soldier/vo/affirmative.wav",
		"npc/combine_soldier/vo/affirmative2.wav",
		"npc/combine_soldier/vo/copy.wav",
		"npc/combine_soldier/vo/copythat.wav",
		"npc/combine_soldier/vo/cover.wav",
		"npc/metropolice/vo/rodgerthat.wav"
	}
	local EngagingHealthy = {
		"npc/combine_soldier/vo/suppressing.wav",
		"npc/combine_soldier/vo/hardenthatposition.wav",
		"npc/combine_soldier/vo/movein.wav",
		"npc/metropolice/vo/destroythatcover.wav",
		"npc/combine_soldier/vo/heavyresistance.wav",
		"npc/metropolice/takedown.wav",
		"npc/metropolice/vo/covermegoingin.wav",
		"npc/metropolice/vo/minorhitscontinuing.wav",
		"npc/metropolice/vo/moveit.wav",
		"npc/combine_soldier/vo/gosharpgosharp.wav",
		"npc/combine_soldier/vo/sweepingin.wav",
		"npc/combine_soldier/vo/targetcompromisedmovein.wav",
		"npc/combine_soldier/vo/onedown.wav"
	}
	local EngagingWounded = {
		"npc/metropolice/vo/11-99officerneedsassistance.wav",
		"npc/metropolice/vo/officerneedshelp.wav",
		"npc/metropolice/vo/officerunderfiretakingcover.wav",
		"npc/metropolice/vo/getdown.wav",
		"npc/metropolice/vo/help.wav",
		"npc/metropolice/vo/lookout.wav",
		"npc/metropolice/vo/movingtocover.wav",
		"npc/metropolice/vo/takecover.wav",
		"npc/metropolice/vo/watchit.wav",
		"npc/combine_soldier/vo/coverhurt.wav",
		"npc/metropolice/takedown.wav",
		"npc/combine_soldier/vo/heavyresistance.wav",
		"npc/combine_soldier/vo/requestmedical.wav",
		"npc/combine_soldier/vo/onedown.wav"
	}
	local AllClear = {
		"npc/combine_soldier/vo/reportingclear.wav",
		"npc/combine_soldier/vo/sightlineisclear.wav",
		"npc/combine_soldier/vo/sectorissecurenovison.wav"
	}
	local Affirm = {
		"npc/metropolice/vo/affirmative.wav",
		"npc/metropolice/vo/affirmative2.wav",
		"npc/combine_soldier/vo/copy.wav",
		"npc/combine_soldier/vo/copythat.wav",
		"npc/metropolice/vo/rodgerthat.wav",
		"npc/combine_soldier/vo/cover.wav"
	}
	local LostContact = {
		"npc/combine_soldier/vo/stayalertreportsightlines.wav",
		"npc/combine_soldier/vo/lostcontact.wav",
		"npc/metropolice/vo/hidinglastseenatrange.wav",
		"npc/metropolice/vo/suspectlocationunknown.wav",
		"npc/metropolice/vo/sweepingforsuspect.wav"
	}
	local EnemiesEliminated = {
		"npc/metropolice/vo/protectioncomplete.wav",
		"npc/metropolice/vo/suspectisbleeding.wav",
		"npc/combine_soldier/vo/thatsitwrapitup.wav"
	}

	function ENT:PlayFindSound()
		self:EmitSound(Alert[math.random(#Alert)], 100, 100, 1, 6 )
	end


	function ENT:PlayReloadSound()
		self:EmitSound(Reload[math.random(#Reload)], 100, 100, 1, 6 )
	end


	function ENT:PlayHurtSound()
		self:EmitSound(Hurt[math.random(#Hurt)], 100, 100, 1, 6 )
	end


	function ENT:PlayGrenadeSound()
		self:EmitSound(Grenade[math.random(#Grenade)], 100, 100, 1, 6 )
	end


	function ENT:PlayFollowSound()
		self:EmitSound(Follow[math.random(#Follow)], 100, 100, 1, 6 )
	end

	function ENT:PlayIdleSound()
		local Sound

		if self:GetEnemy() then
			if self:Health() < 50 * self.HealthMult then
				Sound = EngagingWounded[math.random(#EngagingWounded)]
			else
				Sound = EngagingHealthy[math.random(#EngagingHealthy)]
			end
		else
			if self.LastLostEnemy + 10 > CurTime() then
				Sound = LostContact[math.random(#LostContact)]
			elseif self.LastLostEnemy + 10 > CurTime() and self.LastEnemyDiedTime + 5 > CurTime() then
				Sound = EnemiesEliminated[math.random(#EnemiesEliminated)]
			elseif self.AllyLastSpeakTime + 2 > CurTime() then
				Sound = Affirm[math.random(#Affirm)]
			else
				Sound = AllClear[math.random(#AllClear)]
			end
		end

		self:EmitSound(Sound, 100, 100, 1, 6)
	end
end

do -- Enemies
	Dak_Bogies = {}
	local Bogies = Dak_Bogies

	for _, V in pairs({"PlayerSpawnedNPC", "PlayerSpawn"}) do
		hook.Add(V, "DB Enemy Tracking", function(A, B)
			print("Spawned", A or B)
			Bogies[A or B] = true
		end)
	end

	for _, V in pairs({"OnNPCKilled", "PostPlayerDeath", "EntityRemoved"}) do
		hook.Add(V, "DB Enemy Tracking", function(A, B)
			Bogies[A or B] = nil
		end)
	end

	function ENT:SetEnemy(Ent)
		self.Enemy = Ent
	end

	function ENT:GetEnemy()
		return IsValid(self.Enemy) and self.Enemy:Health() > 0 and self.Enemy or nil
	end

	local TraceData = {start = true, endpos = true, mask = MASK_BLOCKLOS, filter = true}
	local Bones = { -- Ordered by priority -- TODO: Investigate if hitboxes are more reliable/faster. Hitboxes don't appear to have any sort of order however and we don't want to shoot at hands if torso is visible.
		"ValveBiped.Bip01_Spine4", -- Spines checked first for "center of mass"
		--"ValveBiped.Bip01_Spine3",
		"ValveBiped.Bip01_Spine2",
		--"ValveBiped.Bip01_Spine1",
		--"ValveBiped.Bip01_Spine",
		"ValveBiped.Bip01_Head",
		--"ValveBiped.Bip01_Neck1", -- A lot of models don't seem to have this/head sits right ontop of it
		--"ValveBiped.Bip01_L_UpperArm", -- These are actually the shoulders
		--"ValveBiped.Bip01_R_UpperArm",
		--"ValveBiped.Bip01_L_Forearm",
		--"ValveBiped.Bip01_R_Forearm",
		--"ValveBiped.Bip01_L_Hand",
		--"ValveBiped.Bip01_R_Hand",
		"ValveBiped.Bip01_Pelvis",
		--"ValveBiped.Bip01_L_Thigh", -- These are actually the hips (Redundant if checking for pelvis)
		--"ValveBiped.Bip01_R_Thigh",
		"ValveBiped.Bip01_L_Calf", -- These are actually the knees
		"ValveBiped.Bip01_R_Calf",
		--"ValveBiped.Bip01_L_Foot",
		--"ValveBiped.Bip01_R_Foot",
	}
	function ENT:CanSee(Ent)
		TraceData.start  = self:GetShootPos()
		TraceData.filter = self.Filter

		for _, Name in pairs(Bones) do
			local Bone = Ent:LookupBone(Name)

			if Bone then
				TraceData.endpos = Ent:GetBonePosition(Bone)

				local R = util.TraceLine(TraceData)

				if R.Entity == Ent or not R.Hit then
					debugoverlay.Line(self:GetShootPos(), R.HitPos, 1, Color(0, 255, 255), true)

					return true, R.HitPos
				end

				--debugoverlay.Line(self:GetShootPos(), R.HitPos, 1, Color(255, 0, 0), true)
			end
		end

		-- No hits on any bones, check directly at estimated camera pos
		TraceData.endpos = Ent:GetShootPos()

		local R = util.TraceLine(TraceData)

		if R.Entity == Ent or not R.Hit then
			debugoverlay.Line(self:GetShootPos(), R.HitPos, 1, Color(0, 255, 255), true)
			return true, R.HitPos
		end

		return false
	end

	function ENT:CanSeeVehicle(Ent) -- TODO: Targets vehicles through walls until something gets added here
		return true
	end

	function ENT:GetShootPos() -- Nextbots don't count as NPCs apparently so we need to define this method ourselves
		return self:GetPos() + Vector(0, 0, (self:OBBMaxs() - self:OBBMins()).z - 5)
	end

	local SIGHT_RADIUS = 5000
	local SIGHT_RADSQR = SIGHT_RADIUS^2

	function ENT:FindEnemy()
		local Eye  = self:GetShootPos()
		local Team = self.DakTeam

		local Min, Count, Target = math.huge, 0

		for Bogie in pairs(Bogies) do
			if Bogie:Health() <= 0 then continue end -- Not alive
			if Bogie:IsFlagSet(FL_FROZEN) then continue end -- Not sure why we're checking if they're frozen but ok
			if not Bogie:TestPVS(Eye) then continue end -- Not in our PVS
			if Bogie.DakTeam and Bogie.DakTeam == Team then continue end -- On the same team
			if Bogie.DakTeam and Bogie.DakTeam == 0 then continue end -- ignore spectators
			if Bogie.DakTeam and Bogie.DakTeam == 3 then continue end -- ignore spectators
			if Bogie:IsPlayer() and Bogie:GetObserverMode() ~= 0 then continue end -- ignore spectators

			local D = Eye:DistToSqr(Bogie:GetShootPos())
			if D > SIGHT_RADSQR then continue end -- Outside of side radius

			if self.ShootVehicles and Bogie.InVehicle and Bogie:InVehicle() then -- InVehicle does not exist for NextBots and must be checked for
				if D < Min and self:CanSeeVehicle(Bogie) then
					Min    = D
					Target = Bogie
					Count  = Count + 1
				end
			elseif D < Min and self:CanSee(Bogie) then
				Min    = D
				Target = Bogie
				Count  = Count + 1
			end
		end

		if Target then
			timer.Simple(math.random(0.2, 0.8), function()
				if not IsValid(self) then return end
				if not IsValid(Target) then return end
				if Target:Health() <= 0 then return end
				if not self:CanSee(Target) then return end

				debugoverlay.Line(self:GetShootPos(), Target:GetShootPos(), 3, Color(255, 0, 255), true)
				self:PlayFindSound()

				self.EnemyCount = Count -- TODO: Upgrade this behavior... Currently this causes a grenade to be thrown if multiple targets are spotted, regardless of clustering/distance from one another
				self:SetEnemy(Target)
			end)

			return true
		else
			return false
		end
	end
end

do -- Movement
	function ENT:Pathfind()
		if self.Leader == self or not(IsValid(self.Leader)) or self.Leader.Following==1 or self.Leader.pickedpath == nil or next( self.Leader.pickedpath ) == nil then
			if self.Paths ~= nil then
				--In gamemode hold a table of capture points gained by running a find once for all capture point ents then pick one that is neutral first and if no neutral then an enemy one then return vector as goal
				if self.caps == nil then self.caps = ents.FindByClass("daktank_cap") end
				local GoalCaps = {}
				local NeutralCaps = {}
				for i=1, #self.caps do
					if self.DakTeam ~= self.caps[i].DakTeam then
						if self.caps[i].DakTeam == 0 then
							NeutralCaps[#NeutralCaps+1] = self.caps[i]
						end
						GoalCaps[#GoalCaps+1] = self.caps[i]
					end
				end
				local CapTable = {}
				if #NeutralCaps > 0 then
					for i=1, #NeutralCaps do
						CapTable[#CapTable+1] = NeutralCaps[i]
					end
				else
					for i=1, #GoalCaps do
						CapTable[#CapTable+1] = GoalCaps[i]
					end
				end
				self.pickedcap = CapTable[math.random(1,#CapTable)]
				local pickedvec = self.pickedcap:GetPos()
				local TargetPaths = {}
				if #CapTable > 0 then
					for i=1, #self.Paths do
						if #self.Paths[i] > 0 then
							if pickedvec:Distance(self.Paths[i][#self.Paths[i]].Center) < 300 then --maybe 100 is too low, check if target paths is 0 size, try 300 size like the bots do
								TargetPaths[#TargetPaths+1] = self.Paths[i]
							end
						end
					end
				end
				local ShortestDist = math.huge
				self.pickedpath = {self:GetPos()}
				if #TargetPaths > 0 then
					for i=1, #TargetPaths do
						if #TargetPaths[i] > 0 then
							if self:GetPos():Distance(TargetPaths[i][1].Center) < ShortestDist then
								ShortestDist = self:GetPos():Distance(TargetPaths[i][1].Center)
								self.pickedpath = TargetPaths[i] --don't copy it yet, copy it at the end for optimization
							end
						end
					end
				end
				self.pickedpath = table.Copy(self.pickedpath)
				--PrintTable(self.pickedpath)
				self.Dest = self.pickedpath[1].Center
			else
				self.Dest = self:GetPos() + Vector(math.Rand(-1000000,1000000),math.Rand(-1000000,1000000),0)
			end
		else
			--self.Dest = self.Leader.Dest
			self.pickedpath = table.Copy(self.Leader.pickedpath)
			self.Dest = self.pickedpath[1].Center
		end
	end

	function ENT:MoveToPos( options )

		--add in some sort of jump ability, would need to detect if there is something infront of current step segment up to jump height but not above then jump over it
		--also would need to know if it is trying to jump into a new area in which it would fall to get to it
		--may also need to do this in the movetopos combat function and chase enemy and other relevant movement functions

		if self:GetClass() == "sstrp_chariot" then
			if CurTime() - self.StepTime > self.StepDelay then
				self:EmitSound( self.StepSounds[math.random(#self.StepSounds)], 100, 100, 0.2, 6 )
				self.StepTime = CurTime()
			end
		end
		local Speed = 26.25
		if game.SinglePlayer() then
			Speed = 5
		end
		local Dist = self.Dest:Distance(self:GetPos())
		local Direction = Vector(0,0,0)
		Direction = (self.Dest - self:GetPos()):GetNormalized() * Vector(1,1,0)
		local ent = self
		local mins = Vector(ent:OBBMins().x,ent:OBBMins().y,-ent:OBBMaxs().z*0.1)
		local maxs = Vector(ent:OBBMaxs().x,ent:OBBMaxs().y,ent:OBBMaxs().z*0.5)
		local startpos = ent:GetPos() + ent:OBBCenter()
		local tr = util.TraceHull( {
			start = startpos,
			endpos = startpos + Direction*Speed*self.SpeedMult*1.1,
			maxs = maxs*1,
			mins = mins*1,
			filter = {ent, ent.NPCTarget}
		} )
		local endgroundtrace = util.TraceHull( {
			start = startpos + Direction*Speed*self.SpeedMult+Vector(0,0,ent:OBBMaxs().z*0.5),
			endpos = (startpos + Direction*Speed*self.SpeedMult)+Vector(0,0,-10000),
			filter = {ent, ent.NPCTarget, self.Squad},
			mins = Vector(ent:OBBMins().x,ent:OBBMins().y,-ent:OBBMaxs().z*0.01),
			maxs = Vector(ent:OBBMaxs().x,ent:OBBMaxs().y,ent:OBBMaxs().z*0.01)
		} )
		local StepZChange = (endgroundtrace.HitPos - ent:GetPos()).z
		if not(tr.Hit) and StepZChange >= -ent:OBBMaxs().z*0.36 then
			if StepZChange < 0 then StepZChange = 0 end
			self:SetSequence( self.MovementAnimation )
			if (CurTime()-self.LastReset) >= self:SequenceDuration()/(self.SpeedMult*self.WalkAnimationMult) then
				self:SetSequence( self.MovementAnimation )
				self:ResetSequenceInfo()
				self:SetCycle( 0 )
				self.LastReset = CurTime()
			end
			self:SetPlaybackRate( 1.0*self.SpeedMult*self.WalkAnimationMult );
			self:SetPos(self:GetPos()+(Direction*Speed*self.SpeedMult)+Vector(0,0,StepZChange*1.2))
		else
			self.StuckTimer = CurTime()
			if math.random(0,1) == 1 then
				self.UnStuckDest = self:GetPos()+(self:GetRight()*100000)
			else
				self.UnStuckDest = self:GetPos()-(self:GetRight()*100000)
			end
		end
		if IsValid(tr.Entity) then
			if tr.Entity:GetClass() == self:GetClass() then
				self.StuckTimer = CurTime()
				if math.random(0,1) == 1 then
					self.UnStuckDest = self:GetPos()+(self:GetRight()*100000)
				else
					self.UnStuckDest = self:GetPos()-(self:GetRight()*100000)
				end
			end
		end
	end

	function ENT:MoveToPosCombat( options )
		if self:GetClass() == "sstrp_chariot" then
			if CurTime() - self.StepTime > self.StepDelay then
				self:EmitSound( self.StepSounds[math.random(#self.StepSounds)], 100, 100, 0.2, 6 )
				self.StepTime = CurTime()
			end
		end
		local Speed = 26.25
		if game.SinglePlayer() then
			Speed = 5
		end
		local Dist = self.Dest:Distance(self:GetPos())
		local Direction = Vector(0,0,0)
		Direction = (self.Dest - self:GetPos()):GetNormalized() * Vector(1,1,0)
		local ent = self
		local mins = Vector(ent:OBBMins().x,ent:OBBMins().y,-ent:OBBMaxs().z*0.1)
		local maxs = Vector(ent:OBBMaxs().x,ent:OBBMaxs().y,ent:OBBMaxs().z*0.5)
		local startpos = ent:GetPos() + ent:OBBCenter()
		local tr = util.TraceHull( {
			start = startpos,
			endpos = startpos + Direction*Speed*self.SpeedMult*1.1,
			maxs = maxs*1,
			mins = mins*1,
			filter = {ent, ent.NPCTarget}
		} )
		local endgroundtrace = util.TraceHull( {
			start = startpos + Direction*Speed*self.SpeedMult+Vector(0,0,ent:OBBMaxs().z*0.5),
			endpos = (startpos + Direction*Speed*self.SpeedMult)+Vector(0,0,-10000),
			filter = {ent, ent.NPCTarget, self.Squad},
			mins = Vector(ent:OBBMins().x,ent:OBBMins().y,-ent:OBBMaxs().z*0.01),
			maxs = Vector(ent:OBBMaxs().x,ent:OBBMaxs().y,ent:OBBMaxs().z*0.01)
		} )
		local StepZChange = (endgroundtrace.HitPos - ent:GetPos()).z
		if not(tr.Hit) and StepZChange >= -ent:OBBMaxs().z*0.36 then
			if StepZChange < 0 then StepZChange = 0 end
			self:SetSequence( self.CombatMovementAnimation )
			if (CurTime()-self.LastReset) >= self:SequenceDuration()/(self.SpeedMult*self.WalkAnimationMult) then
				self:SetSequence( self.CombatMovementAnimation )
				self:ResetSequenceInfo()
				self:SetCycle( 0 )
				self.LastReset = CurTime()
			end
			self:SetPlaybackRate( 1.0*self.SpeedMult*self.WalkAnimationMult );
			self:SetPos(self:GetPos()+(Direction*Speed*self.SpeedMult)+Vector(0,0,StepZChange*1.2))
		else
			self.StuckTimer = CurTime()
			if math.random(0,1) == 1 then
				self.UnStuckDest = self:GetPos()+(self:GetRight()*100000)
			else
				self.UnStuckDest = self:GetPos()-(self:GetRight()*100000)
			end
		end
		if IsValid(tr.Entity) then
			if tr.Entity:GetClass() == self:GetClass() then
				self.StuckTimer = CurTime()
				if math.random(0,1) == 1 then
					self.UnStuckDest = self:GetPos()+(self:GetRight()*100000)
				else
					self.UnStuckDest = self:GetPos()-(self:GetRight()*100000)
				end
			end
		end
	end

	function ENT:ChaseEnemy( options )
		local Speed = 26.25
		if game.SinglePlayer() then
			Speed = 5
		end
		local Target = self:GetEnemy()
		local Dist = Target:GetPos():Distance(self:GetPos())
		local TarSpeed = Target:GetVelocity()
		local Direction = Vector(0,0,0)
		Direction = (Target:GetPos() - self:GetPos()):GetNormalized() * Vector(1,1,0)

		local ent = self
		local mins = Vector(ent:OBBMins().x,ent:OBBMins().y,-ent:OBBMaxs().z*0.1)
		local maxs = Vector(ent:OBBMaxs().x,ent:OBBMaxs().y,ent:OBBMaxs().z*0.5)
		local startpos = ent:GetPos() + ent:OBBCenter()
		local tr = util.TraceHull( {
			start = startpos,
			endpos = startpos + Direction*Speed*self.SpeedMult*1.1,
			maxs = maxs*1,
			mins = mins*1,
			filter = {ent, ent.NPCTarget}
		} )
		local endgroundtrace = util.TraceHull( {
			start = startpos + Direction*Speed*self.SpeedMult+Vector(0,0,ent:OBBMaxs().z*0.5),
			endpos = (startpos + Direction*Speed*self.SpeedMult)+Vector(0,0,-10000),
			filter = {ent, ent.NPCTarget, self.Squad},
			mins = Vector(ent:OBBMins().x,ent:OBBMins().y,-ent:OBBMaxs().z*0.01),
			maxs = Vector(ent:OBBMaxs().x,ent:OBBMaxs().y,ent:OBBMaxs().z*0.01)
		} )
		local StepZChange = (endgroundtrace.HitPos - ent:GetPos()).z
		if not(tr.Hit) and StepZChange >= -ent:OBBMaxs().z*0.36 then
			if StepZChange < 0 then StepZChange = 0 end
			self:SetSequence( self.CombatMovementAnimation )
			if (CurTime()-self.LastReset) >= self:SequenceDuration()/(self.SpeedMult*self.WalkAnimationMult) then
				self:SetSequence( self.CombatMovementAnimation )
				self:ResetSequenceInfo()
				self:SetCycle( 0 )
				self.LastReset = CurTime()
			end
			self:SetPlaybackRate( 1.0*self.SpeedMult*self.WalkAnimationMult );
			self:SetPos(self:GetPos()+(Direction*Speed*self.SpeedMult)+Vector(0,0,StepZChange*1.2))
		else
			self.StuckTimer = CurTime()
			if math.random(0,1) == 1 then
				self.UnStuckDest = self:GetPos()+(self:GetRight()*100000)
			else
				self.UnStuckDest = self:GetPos()-(self:GetRight()*100000)
			end
		end
		if IsValid(tr.Entity) then
			if tr.Entity:GetClass() == self:GetClass() then
				self.StuckTimer = CurTime()
				if math.random(0,1) == 1 then
					self.UnStuckDest = self:GetPos()+(self:GetRight()*100000)
				else
					self.UnStuckDest = self:GetPos()-(self:GetRight()*100000)
				end
			end
		end
	end

	function ENT:ChaseEnemyWeave( options )
		local Speed = 26.25/1.414
		if game.SinglePlayer() then
			Speed = 5
		end
		local Target = self:GetEnemy()
		local Dist = Target:GetPos():Distance(self:GetPos())
		local TarSpeed = Target:GetVelocity()
		local Direction = Vector(0,0,0)

		if self.WeaveDir == 0 then
			Direction = (Target:GetPos()+self:GetRight()*Dist - self:GetPos()):GetNormalized() * Vector(1,1,0)
		else
			Direction = (Target:GetPos()-self:GetRight()*Dist - self:GetPos()):GetNormalized() * Vector(1,1,0)
		end

		local ent = self
		local mins = Vector(ent:OBBMins().x,ent:OBBMins().y,-ent:OBBMaxs().z*0.1)
		local maxs = Vector(ent:OBBMaxs().x,ent:OBBMaxs().y,ent:OBBMaxs().z*0.5)
		local startpos = ent:GetPos() + ent:OBBCenter()
		local tr = util.TraceHull( {
			start = startpos,
			endpos = startpos + Direction*Speed*self.SpeedMult*1.1,
			maxs = maxs*1,
			mins = mins*1,
			filter = {ent, ent.NPCTarget}
		} )
		local endgroundtrace = util.TraceHull( {
			start = startpos + Direction*Speed*self.SpeedMult+Vector(0,0,ent:OBBMaxs().z*0.5),
			endpos = (startpos + Direction*Speed*self.SpeedMult)+Vector(0,0,-10000),
			filter = {ent, ent.NPCTarget, self.Squad},
			mins = Vector(ent:OBBMins().x,ent:OBBMins().y,-ent:OBBMaxs().z*0.01),
			maxs = Vector(ent:OBBMaxs().x,ent:OBBMaxs().y,ent:OBBMaxs().z*0.01)
		} )
		local StepZChange = (endgroundtrace.HitPos - ent:GetPos()).z
		if not(tr.Hit) and StepZChange >= -ent:OBBMaxs().z*0.36 then
			if StepZChange < 0 then StepZChange = 0 end
			self:SetSequence( self.CombatMovementAnimation )
			if (CurTime()-self.LastReset) >= self:SequenceDuration()/(self.SpeedMult*self.WalkAnimationMult) then
				self:SetSequence( self.CombatMovementAnimation )
				self:ResetSequenceInfo()
				self:SetCycle( 0 )
				self.LastReset = CurTime()
			end
			self:SetPlaybackRate( 1.0*self.SpeedMult*self.WalkAnimationMult );
			self:SetPos(self:GetPos()+(Direction*Speed*self.SpeedMult)+Vector(0,0,StepZChange*1.2))
		else
			self.StuckTimer = CurTime()
			if math.random(0,1) == 1 then
				self.UnStuckDest = self:GetPos()+(self:GetRight()*100000)
			else
				self.UnStuckDest = self:GetPos()-(self:GetRight()*100000)
			end
		end
		if IsValid(tr.Entity) then
			if tr.Entity:GetClass() == self:GetClass() then
				self.StuckTimer = CurTime()
				if math.random(0,1) == 1 then
					self.UnStuckDest = self:GetPos()+(self:GetRight()*100000)
				else
					self.UnStuckDest = self:GetPos()-(self:GetRight()*100000)
				end
			end
		end
	end

	function ENT:Unstuck( options )
		if self.UnStuckDest then
			local Speed = 26.25
			if game.SinglePlayer() then
				Speed = 5
			end
			self.loco:FaceTowards( self.UnStuckDest )
			local Direction = (self.UnStuckDest - self:GetPos()):GetNormalized() * Vector(1,1,0)
			local ent = self
			local mins = Vector(ent:OBBMins().x,ent:OBBMins().y,-ent:OBBMaxs().z*0.1)
			local maxs = Vector(ent:OBBMaxs().x,ent:OBBMaxs().y,ent:OBBMaxs().z*0.5)
			local startpos = ent:GetPos() + ent:OBBCenter()
			local tr = util.TraceHull( {
				start = startpos,
				endpos = startpos + Direction*Speed*self.SpeedMult*self.SpeedBoostOnStuck*1.1,
				maxs = maxs*1,
				mins = mins*1,
				filter = {ent, ent.NPCTarget}
			} )
			local endgroundtrace = util.TraceHull( {
				start = startpos + Direction*Speed*self.SpeedMult+Vector(0,0,ent:OBBMaxs().z*0.5),
				endpos = (startpos + Direction*Speed*self.SpeedMult)+Vector(0,0,-10000),
				filter = {ent, ent.NPCTarget, self.Squad},
				mins = Vector(ent:OBBMins().x,ent:OBBMins().y,-ent:OBBMaxs().z*0.01),
				maxs = Vector(ent:OBBMaxs().x,ent:OBBMaxs().y,ent:OBBMaxs().z*0.01)
			} )
			local StepZChange = (endgroundtrace.HitPos - ent:GetPos()).z
			if not(tr.Hit) and StepZChange >= -ent:OBBMaxs().z*0.36 then
				if StepZChange < 0 then StepZChange = 0 end
				self:SetSequence( self.MovementAnimation )
				if (CurTime()-self.LastReset) >= self:SequenceDuration()/(self.SpeedMult*self.WalkAnimationMult) then
					self:SetSequence( self.MovementAnimation )
					self:ResetSequenceInfo()
					self:SetCycle( 0 )
					self.LastReset = CurTime()
				end
				self:SetPlaybackRate( 1.0*self.SpeedMult*self.WalkAnimationMult );
				self:SetPos(self:GetPos()+(Direction*Speed*self.SpeedBoostOnStuck*self.SpeedMult)+Vector(0,0,StepZChange*1.2))
			else
				self:SetSequence(self.IdleAnimation)
			end
		end
	end

	function ENT:OnContact( ent )
		if ent:IsPlayer() then
			ent:SetPos( ent:GetPos()+(ent:GetPos()-self:GetPos()):GetNormalized()*10+Vector(0,0,1) )
		end
	end

	function ENT:FaceTowardsAndWait(pos)
		--if self:EnemyInRange() then return end
		local eye = self:EyePos()
		eye = Vector(eye.x,eye.y,0)
		pos = Vector(pos.x,pos.y,0)
		local dir = (pos - eye):GetNormal(); -- replace with eyepos if you want

		while (dir:Dot( self:GetForward() ) < 0.75) do
			self.loco:FaceTowards(pos)
			coroutine.yield()
		end
	end

	function ENT:GetYawPitch(vec)
		--This gets the offset from 0,2,0 on the entity to the vec specified as a vector
		local yawAng=vec-self:EyePos()
		--Then converts it to a vector on the entity and makes it an angle ("local angle")
		local yawAng=self:WorldToLocal(self:GetPos()+yawAng):Angle()
		
		--Same thing as above but this gets the pitch angle. Since the turret's pitch axis and the turret's yaw axis are seperate I need to do this seperately.
		local pAng=vec-self:LocalToWorld((yawAng:Forward()*8)+Vector(0,0,50))
		local pAng=self:WorldToLocal(self:GetPos()+pAng):Angle()

		--Y=Yaw. This is a number between 0-360.	
		local y=yawAng.y
		--P=Pitch. This is a number between 0-360.
		local p=pAng.p
		
		--Numbers from 0 to 360 don't work with the pose parameters, so I need to make it a number from -180 to 180
		if y>=180 then y=y-360 end
		if p>=180 then p=p-360 end
		if y<-60 || y>60 then return false end
		if p<-81.2 || p>50 then return false end
		--Returns yaw and pitch as numbers between -180 and 180	
		return y,p
	end

	function ENT:Aim(vec)
		local y,p=self:GetYawPitch(vec)
		if y==false then
			return false
		end

		self:SetPoseParameter("aim_yaw",math.Clamp(y,self.lasty-1,self.lasty+1))
		self:SetPoseParameter("aim_pitch",math.Clamp(p,self.lastp-1,self.lastp+1))
		self.lasty = math.Clamp(y,self.lasty-1,self.lasty+1)
		self.lastp = math.Clamp(p,self.lastp-1,self.lastp+1)

		return true
	end
end

do -- Attacking
	if SERVER then util.AddNetworkString( "daktankshotfired" ) end -- TODO: Move this *entire* file to server, there's no reason to have this shared

	function ENT:FireMelee(damage)
		if self:GetEnemy() then
			self.loco:FaceTowards( self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter() )
			local trace = {}
				trace.start = self:GetPos()+self:GetEnemy():OBBCenter()
				trace.endpos = (self:GetPos()+self:GetEnemy():OBBCenter()) + ((self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())-(self:GetPos()+self:GetEnemy():OBBCenter())):GetNormalized()*self.meleerange
				maxs = Vector(3,3,10)
				mins = Vector(-3,-3,-10)
				trace.filter = {self}
			local Hit = util.TraceHull( trace )
			local List = {}
			if Hit.Hit then
				List = {"npc/zombie/claw_strike3.wav","npc/fast_zombie/claw_strike3.wav"}
				self:EmitSound( List[math.random(2)], 100, 100, 1, 2 )
			else
				List = {"npc/fast_zombie/claw_miss1.wav","npc/fast_zombie/claw_miss2.wav"}
				self:EmitSound( List[math.random(2)], 100, 100, 1, 2 )
			end
			if not(Hit.Entity==NULL) then
				Hit.Entity:SetVelocity( ( (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()) - (self:GetPos()+self:OBBCenter())):GetNormalized() * 75 )
				local Pain = DamageInfo()
				Pain:SetDamageForce( ( (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()) - (self:GetPos()+self:OBBCenter())):GetNormalized()*500 )
				Pain:SetDamage(damage)
				Pain:SetAttacker( self )
				Pain:SetInflictor( self )
				Pain:SetReportedPosition( Hit.HitPos )
				Pain:SetDamagePosition( Hit.Entity:GetPos() )
				Pain:SetDamageType(DMG_CLUB)
				Hit.Entity:TakeDamageInfo( Pain )
			end
		end
	end

	function ENT:FireShell()
		if self:GetEnemy() then
			self:FaceTowardsAndWait( self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter() )
			if self:GetEnemy() then
				local missvec = self:GetRight()*25
				if math.random(0,1) == 0 then
					missvec = -self:GetRight()*25
				end
				local EnemyPos
				if self:GetEnemy():IsPlayer() and self:GetEnemy():InVehicle() then
					if math.random(1,100) <= self.HitChance then
						EnemyPos = self:GetEnemy():GetVehicle():GetPos()
					else
						EnemyPos = self:GetEnemy():GetVehicle():GetPos()+missvec
					end
				else
					if math.random(1,100) <= self.HitChance then
						EnemyPos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()
					else
						EnemyPos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()+missvec
					end
					if self:GetEnemy():LookupAttachment("eyes") > 0 then
						if math.random(1,100) <= self.HitChance then
							EnemyPos = self:GetEnemy():GetAttachment(self:GetEnemy():LookupAttachment("eyes")).Pos
						else
							EnemyPos = self:GetEnemy():GetAttachment(self:GetEnemy():LookupAttachment("eyes")).Pos+missvec
						end
					end
				end
				local SelfPos = self:GetPos()+self:OBBCenter()
				local EnemyVel = self:GetEnemy():GetVelocity()
				if self:GetEnemy():IsPlayer() and self:GetEnemy():InVehicle() then
					EnemyVel = self:GetEnemy():GetVehicle():GetVelocity()
					if IsValid(self:GetEnemy():GetVehicle():GetParent()) then
						EnemyVel = self:GetEnemy():GetVehicle():GetParent():GetVelocity()
					end
					if IsValid(self:GetEnemy():GetVehicle():GetParent():GetParent()) then
						EnemyVel = self:GetEnemy():GetVehicle():GetParent():GetParent():GetVelocity()
					end
				end
				local TravelTime = 0
				local Diff
				local X
				local Y
				local Disc
				local Ang
				local V = self.DakVelocity
				local G=math.abs(physenv.GetGravity().z)
				for i=1, 2 do
					Diff = EnemyPos - SelfPos
					X = (Diff*Vector(1,1,0)):Length()
					Y = Diff.z * 0.018975
					Disc = (V^4) - G*(G*X*X + 2*Y*V*V)
					Ang = math.deg( math.atan(-(V^2 - math.sqrt(Disc))/(G*X)) )
					TravelTime=X/(V*math.deg(math.cos(Ang)))
				end
				local CorrectionAng = (Angle(Ang*1.01,0,0)+(EnemyPos + EnemyVel*EnemyPos:Distance(SelfPos)/(V) - SelfPos):Angle())
				local FireAng = CorrectionAng
				local FriendlyTrace = {}
					FriendlyTrace.start = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos
					FriendlyTrace.endpos = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos + FireAng:Forward()*1000000
					FriendlyTrace.filter = {self}
					FriendlyTrace.Mins = Vector(-5,-5,-5)
					FriendlyTrace.Maxs = Vector(5,5,5)
				local CheckFire = util.TraceHull( FriendlyTrace )
				if CheckFire.Entity~= nil then
					if CheckFire.Entity.DakTeam == self.DakTeam or (CheckFire.Entity:IsPlayer() and self.AttackPlayers==false) then
						self.NoFire = 1
					else
						self.NoFire = 0
					end
				end
				if self.PrimaryLastFire+self.PrimaryCooldown<CurTime() and not(self.NoFire == 1) then
					if self:GetEnemy() then
						for i=1, self.ShotCount do
							local shell = {}
							shell.Pos = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos + FireAng:Forward()*90
							--shell.Ang = FireAng + Angle(math.Rand(-self.Spread,self.Spread),math.Rand(-self.Spread,self.Spread),math.Rand(-self.Spread,self.Spread))
							shell.DakTrail = self.DakTrail
							shell.DakCaliber = self.DakCaliber
							shell.DakShellType = self.DakShellType
							shell.DakPenLossPerMeter = self.DakPenLossPerMeter
							shell.DakExplosive = self.DakExplosive
							shell.DakVelocity = self.DakVelocity*(FireAng+Angle(math.Rand(-self.Spread,self.Spread),math.Rand(-self.Spread,self.Spread),math.Rand(-self.Spread,self.Spread))):Forward()
							shell.DakBaseVelocity = self.DakVelocity
							shell.DakMass = (math.pi*((self.DakCaliber*0.001*0.5)^2)*(self.DakCaliber*0.001*5))*7700
							shell.DakDamage = shell.DakMass*((shell.DakBaseVelocity*0.0254)*(shell.DakBaseVelocity*0.0254))*0.01*0.002
							shell.DakIsPellet = false
							shell.DakSplashDamage = self.DakCaliber*0.375
							shell.DakPenetration = (self.DakCaliber*2)*self.ShellLengthMult
							shell.DakBlastRadius = (self.DakCaliber/25*39)
							shell.DakPenSounds = {"daktanks/daksmallpen1.wav","daktanks/daksmallpen2.wav","daktanks/daksmallpen3.wav","daktanks/daksmallpen4.wav"}
							shell.DakBasePenetration = (self.DakCaliber*2)*self.ShellLengthMult
							shell.DakGun = self
							shell.DakGun.DakOwner = self
							shell.Filter = {self}
							shell.LifeTime = 0
							shell.Gravity = 0
							shell.DakFragPen = (self.DakCaliber/2.5)

							if shell.DakShellType == "HEAT" then
								shell.DakPenetration = self.HeatPen
								shell.DakBasePenetration = self.HeatPen
								shell.IsTandem = self.IsTandem
							end
							if shell.DakShellType == "HEATFS" then
								shell.DakPenetration = self.HeatPen
								shell.DakBasePenetration = self.HeatPen
								shell.IsTandem = self.IsTandem
							end
							DakTankShellList[#DakTankShellList+1] = shell
						end
						self.PrimaryLastFire = CurTime()
						local effectdata = EffectData()
						--effectdata:SetOrigin( self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos+((self:GetEnemy():GetPos()+Vector(0,0,self:GetEnemy():OBBCenter().z))-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):GetNormalized()*25 )
						effectdata:SetOrigin( self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos + ((self:GetEnemy():GetPos()+Vector(0,0,self:GetEnemy():OBBCenter().z))-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):GetNormalized()*20 )
						effectdata:SetAngles( ((self:GetEnemy():GetPos()+Vector(0,0,self:GetEnemy():OBBCenter().z))-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):Angle() )
						effectdata:SetEntity(self)
						effectdata:SetScale( 0.1 )
						util.Effect( "dakteballisticfirelight", effectdata )
						--self:EmitSound( self.FireSound, 140, 100, 1, 2)

						net.Start( "daktankshotfired" )
						net.WriteVector( self:GetPos() )
						net.WriteFloat( math.min(self.DakCaliber,10) )
						net.WriteString( self.FireSound )
						net.Broadcast()


						self.ShotsSinceReload = self.ShotsSinceReload + 1
						if self.ShotsSinceReload >= self.MagSize then
							self.Reloading = 1
							self.ReloadStart = CurTime()
						end
					end
				end
			end
		end
	end

	function ENT:FirePrimary()
		if self:GetEnemy() then
			self:FaceTowardsAndWait( self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter() )
			if self:GetEnemy() then

				local FireAng = Angle()
				local SpreadAng = Angle(math.Rand(-self.Spread,self.Spread),math.Rand(-self.Spread,self.Spread),math.Rand(-self.Spread,self.Spread))
				local missvec = self:GetRight()*25
				if math.random(0,1) == 0 then
					missvec = -self:GetRight()*25
				end
				if math.random(1,100) <= self.HitChance then
					if self:GetEnemy() and self:GetEnemy():LookupAttachment("eyes") > 0 then
						FireAng = ((self:GetEnemy():GetAttachment(self:GetEnemy():LookupAttachment("eyes")).Pos)-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):Angle()
					else
						FireAng = ((self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):Angle()
					end
				else
					if self:GetEnemy() and self:GetEnemy():LookupAttachment("eyes") > 0 then
						FireAng = ((self:GetEnemy():GetAttachment(self:GetEnemy():LookupAttachment("eyes")).Pos + missvec)-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):Angle()
					else
						FireAng = ((self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()+missvec)-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):Angle()
					end
				end
				
				local FriendlyTrace = {}
					FriendlyTrace.start = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos
					FriendlyTrace.endpos = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos + FireAng:Forward()*1000000
					FriendlyTrace.filter = {self}
					FriendlyTrace.Mins = Vector(-5,-5,-5)
					FriendlyTrace.Maxs = Vector(5,5,5)
				local CheckFire = util.TraceHull( FriendlyTrace )
				if CheckFire.Entity then
					if CheckFire.Entity.DakTeam == self.DakTeam or (CheckFire.Entity:IsPlayer() and self.AttackPlayers==false) then
						self.NoFire = 1
					else
						self.NoFire = 0
					end
				end
				if self.PrimaryLastFire+self.PrimaryCooldown<CurTime() and not(self.NoFire == 1) then
					if self:GetEnemy() then
						local bullet = {} 
						bullet.Num = self.ShotCount 
						bullet.Src = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos
						bullet.Dir = FireAng:Forward()
						bullet.Spread = Vector( self.Spread*0.1, self.Spread*0.1, 0) 
						bullet.Tracer = 1
						bullet.TracerName = "Tracer" 
						bullet.Force = self.PrimaryForce 
						bullet.Damage = self.PrimaryDamage/2 --divide by two since they are set to always headshot
						self:FireBullets(bullet)
						self.PrimaryLastFire = CurTime()
						local effectdata = EffectData()
						--effectdata:SetOrigin( self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos+((self:GetEnemy():GetPos()+Vector(0,0,self:GetEnemy():OBBCenter().z))-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):GetNormalized()*25 )
						effectdata:SetOrigin( self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos )
						effectdata:SetAngles( ((self:GetEnemy():GetPos()+Vector(0,0,self:GetEnemy():OBBCenter().z))-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):Angle() )
						effectdata:SetEntity(self)
						effectdata:SetScale( 0.1 )
						util.Effect( "dakteballisticfirelight", effectdata )
						self:EmitSound( self.FireSound, 140, 100, 1, 2)
						self.ShotsSinceReload = self.ShotsSinceReload + 1
						if self.ShotsSinceReload >= self.MagSize then
							self.Reloading = 1
							self.ReloadStart = CurTime()
						end
					end
				end
			end
		end
	end

	local function BotRecurseTraceExplosion(nade, start, endpos, filter, target, damage)
		local trace = {}
			trace.start = start
			trace.endpos = endpos
			trace.filter = filter
		local FireTrace = util.TraceLine( trace )
		if IsValid(FireTrace.Entity) then
			if FireTrace.Entity == target then
				local Pain = DamageInfo()
				Pain:SetDamageForce( ( (target:GetPos()+target:OBBCenter()) - (nade:GetPos())):GetNormalized()*500 )
				Pain:SetDamage(damage)
				if IsValid(nade.owner) then
					Pain:SetAttacker( nade.owner )
					Pain:SetInflictor( nade.owner )
				else
					Pain:SetAttacker( nade )
					Pain:SetInflictor( nade )
				end
				Pain:SetReportedPosition( target:GetPos() )
				Pain:SetDamagePosition( target:GetPos() )
				Pain:SetDamageType(DMG_BLAST)
				target:TakeDamageInfo( Pain )
			else
				if FireTrace.Entity:IsValid() then
					if FireTrace.Entity:Health() then
						filter[#filter+1] = FireTrace.Entity
						BotRecurseTraceExplosion(nade, start, endpos, filter, target, damage)
					end
				end
			end
		end
	end

	local function BotFireExplosion(nade, damage, radius)
		Targets = ents.FindInSphere( nade:GetPos(), radius )
		for i=1, #Targets do
			if IsValid(Targets[i]) then
				if Targets[i]:Health() then
					local trace = {}
					trace.start = nade:GetPos()
					trace.endpos = Targets[i]:GetPos()+Targets[i]:OBBCenter()
					trace.filter = {nade}
					local CheckTrace = util.TraceLine( trace )
					if CheckTrace.Entity == Targets[i] then
						local Pain = DamageInfo()
						Pain:SetDamageForce( ( (Targets[i]:GetPos()+Targets[i]:OBBCenter()) - (nade:GetPos())):GetNormalized()*500 )
						Pain:SetDamage(damage)
						if IsValid(nade.owner) then
							Pain:SetAttacker( nade.owner )
							Pain:SetInflictor( nade.owner )
						else
							Pain:SetAttacker( nade )
							Pain:SetInflictor( nade )
						end
						Pain:SetReportedPosition( Targets[i]:GetPos() )
						Pain:SetDamagePosition( Targets[i]:GetPos() )
						Pain:SetDamageType(DMG_BLAST)
						Targets[i]:TakeDamageInfo( Pain )
					else
						if CheckTrace.Entity:IsValid() then
							if CheckTrace.Entity:Health() then
								BotRecurseTraceExplosion(nade, nade:GetPos(), Targets[i]:GetPos()+Targets[i]:OBBCenter(), {nade}, Targets[i], damage)
							end
						end
					end
				end
			end
		end
	end

	function ENT:ThrowNade()
		if self.NadeLastFire+self.NadeCooldown<CurTime() then
			if self:GetEnemy() then
				local Nade = ents.Create("prop_physics")
					Nade:SetModel("models/Items/grenadeAmmo.mdl")
					util.SpriteTrail( Nade, -1, Color(255,0,0,150), true, 5, 1, 1, 1 / ( 5 + 1 ) * 0.5, "trails/smoke.vmt" )
					Nade:SetPos(self:GetAttachment(self:LookupAttachment("anim_attachment_LH")).Pos)
					Nade.owner = self
					Nade:Spawn()
					if self:GetEnemy():GetPos():Distance(self:GetPos()) > 1500 then
						Nade:GetPhysicsObject():SetVelocity(((self:GetEnemy():GetPos()+Vector(0,0,self:GetEnemy():OBBCenter().z))-self:GetAttachment(self:LookupAttachment("anim_attachment_LH")).Pos):GetNormalized()*self:GetEnemy():GetPos():Distance(self:GetPos())*1.2+Vector(0,0,500))
					else
						Nade:GetPhysicsObject():SetVelocity(((self:GetEnemy():GetPos()+Vector(0,0,self:GetEnemy():OBBCenter().z))-self:GetAttachment(self:LookupAttachment("anim_attachment_LH")).Pos):GetNormalized()*self:GetEnemy():GetPos():Distance(self:GetPos())*0.9+Vector(0,0,500))
					end
					timer.Simple( 2, function()
						if IsValid(Nade) then
							BotFireExplosion(Nade, 250, 200)
							local effectdata = EffectData()
							effectdata:SetOrigin(Nade:GetPos())
							effectdata:SetEntity(Nade)
							effectdata:SetAttachment(1)
							effectdata:SetMagnitude(.5)
							effectdata:SetScale(200)
							util.Effect("botscalingexplosion", effectdata)
							Nade:EmitSound( "bot/grenadeexplode.wav", 100, 75, 1)
							Nade:Remove()
						end
					end )
				self:PlayGrenadeSound()
				self.NadeLastFire = CurTime()
			end
		end
	end
end

do -- Taking damage
	function ENT:OnInjured( info )
		--if info:GetAttacker():GetClass()~=self:GetClass() then
		--	self.NextTarget = info:GetAttacker()
		--end
		self.LastFind = CurTime()
	end

	function ENT:OnKilled( dmginfo )
		--self:Remove()
		timer.Simple( engine.TickInterval()*2, function()
			self:Remove()
			self:SetColor(Color(255,255,255,0))
		end )
		--self:SetColor(Color(255,255,255,0))

		local SoundList = {"npc/combine_soldier/die1.wav","npc/combine_soldier/die2.wav","npc/combine_soldier/die3.wav"}
		self:EmitSound( SoundList[math.random(#SoundList)], 100, 100, 1, 2 )

		if SERVER then
			if self:IsOnFire() then
				self:SetModel("models/humans/charple0" .. math.random(1, 4) .. ".mdl")
			end

			self:BecomeRagdoll( dmginfo )
		end
		--TODO: sometimes ragdoll doesn't appear
		--TODO: gibs?

		--[[
		local body = ents.Create( "prop_ragdoll" )
		body:SetPos( self:GetPos() )
		body:SetModel( self:GetModel() )
		body:Spawn()
		body.DakHealth=1000000
		body.DakMaxHealth=1000000
		local SoundList = {"npc/metropolice/die1.wav","npc/metropolice/die2.wav","npc/metropolice/die3.wav","npc/metropolice/die4.wav","npc/metropolice/pain4.wav"}
		body:EmitSound( SoundList[math.random(5)], 100, 100, 1, 2 )
		timer.Simple( 5, function()
			body:Remove()
		end )
		]]--
		hook.Run( "OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
		
	end

	function ENT:OnTakeDamage( dmginfo )
		self:SetHealth(self:Health()-dmginfo:GetDamage())
	--	if self:Health() <= 0 then 
	--		hook.Run( "OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	--		self:Remove()
	--	end
	end
end

do -- Squad behavior and interaction
	function ENT:FormSquad()
		if #self.Squad < 5 then
			_ents = ents.FindInSphere( self:GetPos(), 500 )
			for k, v in pairs( _ents ) do
				if v.DakTeam and #self.Squad < 5 then
					if v:Health()>0 and v.DakTeam==self.DakTeam and not(v.Following==1) and v:GetClass() == self:GetClass() then
						self.Squad[#self.Squad+1] = v
					end
				end
			end
		end
		if #self.Squad > 1 then
			for i=1, #self.Squad do
				self.Squad[i].Squad = self.Squad
				self.Squad[i].Leader = self.Squad[1]
				self.Squad[i].SquadPos = i
			end
		end
	end

	function ENT:TalkNearbyAlly()
		local Origin  = self:GetPos() + Vector(0, 0, 72) -- Offset to get better PVS results
		for _, V in pairs(ents.FindInSphere(Origin),500) do
			if IsValid(V) and V:GetClass()==self:GetClass() and V.DakTeam == self.DakTeam and V:Health()>0 then
				V.AllyLastSpeakTime = CurTime()
			end
		end
	end

	function ENT:Use(activator,caller,useType)
		if self.AttackPlayers == false or self.DakTeam==caller.DakTeam then
			if IsValid( caller ) and caller:IsPlayer() and self.LastUse+1<CurTime() then
				self:PlayFollowSound()
				if self.commander == caller then
					self.Following = 0
					self.commander = nil
				else
					self.Following = 1
					self.commander = caller
				end
				self.LastUse = CurTime()
			end
		end
	end
end

do -- Think
	function ENT:Think()
		if IsValid(self) then
			if self:GetEnemy() then
				debugoverlay.Line(self:GetShootPos(), self.Enemy:GetShootPos() + VectorRand(), 0.03, Color(255, 0, 0), true)
				self:Aim(self.Enemy:EyePos())
			end
			if SERVER then
				if (self.LastThink+0.1) < CurTime() then
						if self:Health()<=0 then
							self:EmitSound( self.DeathSoundList[math.random(#self.DeathSoundList)], 100, 100, 1, 6 )
							--self:Remove()
						else
							--self:PlayHurtSound()
						end
						if self.Enemy then
							if not IsValid(self.Enemy) or self.Enemy:Health()<=0 or not self:CanSee(self.Enemy) then
								self.LastEnemyDiedTime = CurTime()
								timer.Simple(self.FindDelay,function()
									if IsValid(self) then
										self.Enemy = false
										self.LastLostEnemy = CurTime()
										self:FindEnemy()
									end
								end)
							end
						end
						if self.commander~=nil then
							self.Dest = self.commander:GetPos()
							if self:GetPos():Distance(self.Dest) > 200 then
								self.shouldmove = 1
							end
							if self:GetPos():Distance(self.Dest) < 100 and self.shouldmove == 1 then
								self.shouldmove = 0
							end
						end
						if IsValid(self.commander) then
							if self.commander:Health()<=0 then
								self.commander = nil
							end
						else
							self.commander = nil
						end
					
					self.LastThink = CurTime()
				end
			end
		end
		if self.MadeRagdoll == true then
			if SERVER then
				self:Remove()
			end
		end
		if self:Health() <= 0 and self.MadeRagdoll == nil then
			if CLIENT then
				self:BecomeRagdollOnClient()
			end
			self.MadeRagdoll = true
		end
		self:NextThink( CurTime() )
		return true
	end

	function ENT:RunBehaviour()
		while ( true ) do
			if CurTime() - self.LastFind > 3 then
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
				if self.HasMissionTarget ~= true then
					timer.Simple(self.FindDelay,function()
						if IsValid(self) then
							self:FindEnemy()
						end
					end)
				end
				self.LastFind = CurTime()
			end
			if self.NextTarget then
				if self:GetEnemy() then
				else
					self:SetEnemy(self.NextTarget)
					self.NextTarget = nil
				end
			end
			if CurTime() - self.LastIdleSound > self.RandomDelay then
				self:PlayIdleSound()
				self.LastIdleSound = CurTime()
				self.RandomDelay = math.Rand(10,20)
				self.Tactic = math.random(0,1)
				if self.DakTank then
					self:FormSquad()
				end
			end
			if CurTime() - self.LastWeaveChange > self.ShortRandomDelay then
				self.ShortRandomDelay = math.Rand(1,3)
				self.LastWeaveChange = CurTime()
				if self.WeaveDir == 0 then
					self.WeaveDir = 1
				else
					self.WeaveDir = 0
				end
			end
			if GetConVarNumber("ai_disabled")==0 then
				if ( self:GetEnemy() ) then
					self:SetSequence(self.CombatIdleAnimation)
					if CurTime() - self.StuckTimer > 0.5 and self:GetEnemy() then
						local dist = self:GetEnemy():GetPos():Distance(self:GetPos())
						if self.commander then
							if self.shouldmove == 1 then
								self.loco:FaceTowards( self.Dest )
							else
								if dist > 200 then
									self.loco:FaceTowards( self:GetEnemy():GetPos() + self:GetEnemy():GetVelocity()*(self:GetEnemy():GetPos():Distance(self:GetPos())/(5000)) )
								else
									self.loco:FaceTowards( self:GetEnemy():GetPos())
								end
							end
						else
							if dist > 200 then
								self.loco:FaceTowards( self:GetEnemy():GetPos() + self:GetEnemy():GetVelocity()*(self:GetEnemy():GetPos():Distance(self:GetPos())/(5000)) )
							else
								self.loco:FaceTowards( self:GetEnemy():GetPos())
							end
						end
						
						local Forward = self:GetForward()
						local Goal = (self:GetEnemy():GetPos() - self:GetPos()):GetNormalized()
						if (self:GetEnemy():GetPos()):Distance(self:GetPos()) <= self.meleerange*0.75 then
							if math.abs(Goal.y-Forward.y) < 0.1 then
								coroutine.wait( 0.1 )
								self:SetSequence( "melee_gunhit" )
								self:ResetSequenceInfo()
								self:SetCycle( 0 )
								self:SetPlaybackRate( 1.5 );
								coroutine.wait( 0.5 )
								self:FireMelee(self.MeleeDamage*1)
								coroutine.wait( 0.1 )
								self:SetSequence( "Idle1" )
							end
						elseif (self:GetEnemy():GetPos()):Distance(self:GetPos()) <= self.shootrange then
							local rand = math.random(1,20)
							if self.commander and self:GetPos():Distance(self.Dest)<=100 then
								rand = 1
							end
							if self.PrimaryLastFire+self.PrimaryCooldown<CurTime() and self.LastBurstTime+1<CurTime() and rand == 1 then
								if math.abs(Goal.y-Forward.y) < 0.1 then
									coroutine.wait( math.Rand(0.1,0.3) ) --simulate response time
									if self:GetEnemy() then -- Grenade throwing
										if self.EnemyCount >= 2 and self.NadeLastFire+self.NadeCooldown<CurTime() and math.random(1,10)<=self.EnemyCount and (self:GetEnemy():GetPos()):Distance(self:GetPos())>self.shootrange*0.5 then
											self:SetSequence( "grenThrow" )
											self:ResetSequenceInfo()
											self:SetCycle( 0 )
											self:SetPlaybackRate( 1.0 );
											coroutine.wait( 0.5 )
											self:ThrowNade()
										end
									end
									if math.random(1,4) == 1 then
										self:PlaySequenceAndWait( "Combat_stand_to_crouch" )
										self:SetSequence( "crouch_aim_ar2" )
										self.Spread = self.BaseSpread*0.5
										self.HitChance = self.CrouchingHitChance
										for i=1, math.random(math.max(self.MagSize*0.5,1),self.MagSize) do
											if self.ShotsSinceReload<self.MagSize then
												if self:GetEnemy() then
													if self.DakTank then
														self:FireShell()
													else
														self:FirePrimary()
													end
													coroutine.wait( self.PrimaryCooldown )
												end
											else
												if self.Reloading == 1 then
													self:AddGesture( ACT_GESTURE_RELOAD )
													self:PlayReloadSound()
													self.Reloading = 0
													timer.Simple(self.ReloadTime,function() 
														if IsValid(self) then
															self.ShotsSinceReload = 0
														end
													end)
												end
											end
										end
										coroutine.wait( 0.1 )
										self:PlaySequenceAndWait( "Crouch_to_combat_stand" )
										self.LastBurstTime = CurTime()
									else
										self:SetSequence(self.CombatIdleAnimation)
										self.Spread = self.BaseSpread*1
										self.HitChance = self.StandingHitChance
										for i=1, math.random(self.BurstMin,self.BurstMax) do
											if self:GetEnemy() then
												if self.ShotsSinceReload<self.MagSize then
													if self.DakTank then
														self:FireShell()
													else
														self:FirePrimary()
													end
													coroutine.wait( self.PrimaryCooldown )
													self.LastBurstTime = CurTime()
												else
													if self.Reloading == 1 then
														self:AddGesture( ACT_GESTURE_RELOAD )
														self:PlayReloadSound()
														self.Reloading = 0
														timer.Simple(self.ReloadTime,function() 
															if IsValid(self) then
																self.ShotsSinceReload = 0
															end
														end)
													end
												end
											end
										end
										if self:GetEnemy() then
											self.LastBurstTime = CurTime()
										else
											if self:GetEnemy() then
												self.LastEnemyDiedTime = CurTime()
												timer.Simple(self.FindDelay,function()
													if IsValid(self) then
														if self:GetEnemy() then
															self:FindEnemy()
														end
													end
												end)
											else
												timer.Simple(self.FindDelay,function()
													if IsValid(self) then
														self:FindEnemy()
													end
												end)
											end
											self.LastBurstTime = CurTime()-1
										end
									end
								end
							else
								if self.commander then
									if self.shouldmove == 1 then
										self:MoveToPosCombat()
									else
										self:SetSequence(self.CombatIdleAnimation)
									end
								else
									if self.Stationary == false then
										if self:GetEnemy() then
											self:ChaseEnemyWeave()
										else
											self:SetSequence(self.CombatIdleAnimation)
										end
									else
										self:SetSequence(self.CombatIdleAnimation)
									end
								end
								if self.Tactic == 0 then
									if self.PrimaryLastFire+self.PrimaryCooldown<CurTime() and self.LastRunBurstTime+1<CurTime() then
										if self:GetEnemy() then
											if self.ShotsSinceReload<self.MagSize then
												self.Spread = self.BaseSpread*1.0
												self.HitChance = self.RunningBurstHitChance
												if self.DakTank then
													self:FireShell()
												else
													self:FirePrimary()
												end
												self.CurRunBurst = self.CurRunBurst + 1
												if self.CurRunBurst >= self.BurstMax then
													self.LastRunBurstTime = CurTime()
													self.CurRunBurst = 0
												end
											else
												if self.Reloading == 1 then
													self:AddGesture( ACT_GESTURE_RELOAD )
													self:PlayReloadSound()
													self.Reloading = 0
													timer.Simple(self.ReloadTime,function() 
														if IsValid(self) then
															self.ShotsSinceReload = 0
														end
													end)
												end
											end
										else
											self.LastEnemyDiedTime = CurTime()
										end
									end
								else
									if self.PrimaryLastFire+self.PrimaryCooldown<CurTime() then
										if self:GetEnemy() then
											if self.ShotsSinceReload<self.MagSize then
												self.HitChance = self.RunningFullAutoHitChance
												self.Spread = self.BaseSpread*1.5
												if self.DakTank then
													self:FireShell()
												else
													self:FirePrimary()
												end
												self.CurRunBurst = self.CurRunBurst + 1
												if self.CurRunBurst >= self.MagSize then
													self.LastRunBurstTime = CurTime()
													self.CurRunBurst = 0
												end
											else
												if self.Reloading == 1 then
													self:AddGesture( ACT_GESTURE_RELOAD )
													self:PlayReloadSound()
													self.Reloading = 0
													timer.Simple(self.ReloadTime,function() 
														if IsValid(self) then
															self.ShotsSinceReload = 0
														end
													end)
												end
											end
										else
											self.LastEnemyDiedTime = CurTime()
										end
									end
								end
							end
						else
							if self.commander then
								if self.shouldmove == 1 then
									self:MoveToPosCombat()
								else
									self:SetSequence(self.CombatIdleAnimation)
								end
							else
								if self.Stationary == false then
									self:ChaseEnemy()
								else
									self:SetSequence(self.CombatIdleAnimation)
								end
							end
							if self.Tactic == 0 then
								if self.PrimaryLastFire+self.PrimaryCooldown<CurTime() and self.LastRunBurstTime+1<CurTime() and self.LastBurstTime+1<CurTime() then
									if self:GetEnemy() then
										if self.ShotsSinceReload<self.MagSize then
											self.Spread = self.BaseSpread*1.0
											self.HitChance = self.RunningBurstHitChance
											if self.DakTank then
												self:FireShell()
											else
												self:FirePrimary()
											end
											self.CurRunBurst = self.CurRunBurst + 1
											if self.CurRunBurst >= self.BurstMax then
												self.LastRunBurstTime = CurTime()
												self.CurRunBurst = 0
											end
										else
											if self.Reloading == 1 then
												self:AddGesture( ACT_GESTURE_RELOAD )
												self:PlayReloadSound()
												self.Reloading = 0
												timer.Simple(self.ReloadTime,function() 
													if IsValid(self) then
														self.ShotsSinceReload = 0
													end
												end)
											end
										end
									else
										self.LastEnemyDiedTime = CurTime()
									end
								end
							else
								if self.PrimaryLastFire+self.PrimaryCooldown<CurTime() then
									if self:GetEnemy() then
										if self.ShotsSinceReload<self.MagSize then
											self.HitChance = self.RunningFullAutoHitChance
											self.Spread = self.BaseSpread*1.5
											if self.DakTank then
												self:FireShell()
											else
												self:FirePrimary()
											end
											self.CurRunBurst = self.CurRunBurst + 1
											if self.CurRunBurst >= self.MagSize then
												self.LastRunBurstTime = CurTime()
												self.CurRunBurst = 0
											end
										else
											if self.Reloading == 1 then
												self:AddGesture( ACT_GESTURE_RELOAD )
												self:PlayReloadSound()
												self.Reloading = 0
												timer.Simple(self.ReloadTime,function() 
													if IsValid(self) then
														self.ShotsSinceReload = 0
													end
												end)
											end
										end
									else
										self.LastEnemyDiedTime = CurTime()
									end
								end
							end
						end
					else
						if self.Stationary == false then
							self:Unstuck()
						else
							self:SetSequence(self.CombatIdleAnimation)
						end
					end
				else
					if CurTime() - self.StuckTimer > 0.5 then
						if self.Dest == nil then self.Dest = self:GetPos() end
						self.loco:FaceTowards( self.Dest )
						if self.commander then
							if self.shouldmove == 1 then
								self:MoveToPos()
							else
								self:SetSequence(self.IdleAnimation)
							end
						else
							if self.Stationary == false then
								if self.pickedpath==nil then self.pickedpath = {} end
								if self.pickedcap == nil then self:Pathfind() end
								if self.pickedcap and #self.pickedpath == 0 then
									--check if goal capture point is captured by their team first then pathfind to next area if so
									if self.DakTeam == self.pickedcap.DakTeam or (self.pickedcap:GetPos()*Vector(1,1,0)):Distance(self:GetPos()*Vector(1,1,0))>300 then
										self:Pathfind()
									end
								end
								if self.Dest ~= nil then --i don't know how it happens but it does
									if (self:GetPos()*Vector(1,1,0)):Distance((self.Dest*Vector(1,1,0))) > 300 then
										self:MoveToPos()
									else
										table.remove( self.pickedpath, 1 )
										if self.pickedpath[1] ~= nil then
											self.Dest = self.pickedpath[1].Center
										end
										self:MoveToPos()
									end
								end
							else
								self:SetSequence(self.IdleAnimation)
							end
						end
					else
						if self.Stationary == false then
							self:Unstuck()
						else
							self:SetSequence(self.IdleAnimation)
						end
					end
				end
			else
				self:SetSequence(self.IdleAnimation)
			end
			coroutine.wait( 0.0 )
		end
	end
end

function ENT:GiveWeapon(wep)
	local Gun = ents.Create("prop_physics")
	Gun:SetModel(wep)
	local pos = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos
	Gun:SetOwner(self)
	Gun:SetPos(pos)
	Gun:Spawn()
	Gun.DontPickUp = true
	Gun:SetSolid(SOLID_NONE)	
	Gun:SetParent(self)
	Gun:Fire("setparentattachment", "anim_attachment_RH")
	Gun:AddEffects(EF_BONEMERGE)
	self.Weapon = Gun
end

function ENT:OnRemove()
	DTTE.Bots[self.DakTeam == 1 and "Red" or "Blue"][self] = nil
end