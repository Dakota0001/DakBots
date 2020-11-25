AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

function ENT:PlayFindSound()
	local SoundList = {
		"npc/combine_soldier/vo/copy.wav",
		"npc/combine_soldier/vo/copythat.wav",
		"npc/combine_soldier/vo/cover.wav"
	}
	if self.HasEnemy == 1 then
		SoundList = {
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
	end
	self:EmitSound( SoundList[math.random(#SoundList)], 100, 100, 1, 6 )
end

function ENT:PlayReloadSound()
	local SoundList = {
		"npc/metropolice/vo/backmeupimout.wav",
		"npc/combine_soldier/vo/coverme.wav"
	}
	self:EmitSound( SoundList[math.random(#SoundList)], 100, 100, 1, 6 )
end

function ENT:PlayHurtSound()
	local SoundList = {
		"npc/metropolice/pain1.wav",
		"npc/metropolice/pain2.wav",
		"npc/metropolice/pain3.wav",
		"npc/metropolice/pain4.wav"
	}
	self:EmitSound( SoundList[math.random(#SoundList)], 100, 100, 1, 6 )
end

function ENT:PlayGrenadeSound()
	local SoundList = {
		"npc/metropolice/vo/grenade.wav",
		"npc/metropolice/vo/thatsagrenade.wav"
	}
	self:EmitSound( SoundList[math.random(#SoundList)], 100, 100, 1, 6 )
end

function ENT:PlayFollowSound()
	local SoundList = {
		"npc/combine_soldier/vo/affirmative.wav",
		"npc/combine_soldier/vo/affirmative2.wav",
		"npc/combine_soldier/vo/copy.wav",
		"npc/combine_soldier/vo/copythat.wav",
		"npc/combine_soldier/vo/cover.wav",
		"npc/metropolice/vo/rodgerthat.wav"
	}
	self:EmitSound( SoundList[math.random(#SoundList)], 100, 100, 1, 6 )
end

function ENT:PlayIdleSound()
	local SoundList = {
		"npc/combine_soldier/vo/copy.wav",
		"npc/combine_soldier/vo/copythat.wav",
		"npc/combine_soldier/vo/cover.wav"
	}
	if self.HasEnemy == 1 and self:Health() == 100*self.HealthMult then
		SoundList = {
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
	end
	if self.HasEnemy == 1 and self:Health() < 50*self.HealthMult then
		SoundList = {
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
	end
	if self.HasEnemy == 0 then
		SoundList = {
			"npc/combine_soldier/vo/reportingclear.wav",
			"npc/combine_soldier/vo/sightlineisclear.wav",
			"npc/combine_soldier/vo/sectorissecurenovison.wav"
		}
	end
	if self.AllyLastSpeakTime + 2 > CurTime() then
		SoundList = {
			"npc/metropolice/vo/affirmative.wav",
			"npc/metropolice/vo/affirmative2.wav",
			"npc/combine_soldier/vo/copy.wav",
			"npc/combine_soldier/vo/copythat.wav",
			"npc/metropolice/vo/rodgerthat.wav",
			"npc/combine_soldier/vo/cover.wav"
		}
	end
	if self.LastLostEnemy + 10 > CurTime() and self.HasEnemy == 0 then
		SoundList = {
			"npc/combine_soldier/vo/stayalertreportsightlines.wav",
			"npc/combine_soldier/vo/lostcontact.wav",
			"npc/metropolice/vo/hidinglastseenatrange.wav",
			"npc/metropolice/vo/suspectlocationunknown.wav",
			"npc/metropolice/vo/sweepingforsuspect.wav"
		}
	end
	if self.LastLostEnemy + 10 > CurTime() and self.LastEnemyDiedTime + 5 > CurTime() and self.HasEnemy == 0 then
		SoundList = {
			"npc/metropolice/vo/protectioncomplete.wav",
			"npc/metropolice/vo/suspectisbleeding.wav",
			"npc/combine_soldier/vo/thatsitwrapitup.wav"
		}
	end
	self:EmitSound( SoundList[math.random(#SoundList)], 100, 100, 1, 6 )
end

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

function ENT:Pathfind()
	if file.Exists( "daktankmappaths/"..game.GetMap()..".txt", "DATA" ) then
		if not(GLOBALmapnodes) then
			local Nodes = string.Split( file.Read( "daktankmappaths/"..game.GetMap()..".txt", "DATA" ) , "|" )
			GLOBALmapnodes = {} 
			for i = 1, #Nodes do
				if #Nodes[i] > 0 then
					local Nodesplit = string.Split( Nodes[i] , "," )
					local newnode = {tonumber(Nodesplit[1]),Vector(tonumber(Nodesplit[2]),tonumber(Nodesplit[3]),tonumber(Nodesplit[4]))}
					if #Nodesplit > 4 then
						local links = {}
						for j = 1, #Nodesplit do
							if j > 4 then
								links[#links+1] = tonumber(Nodesplit[j])
							end
						end
						newnode[3] = links
					end
					GLOBALmapnodes[#GLOBALmapnodes+1] = newnode
				end
			end
		end
	end

	if self.Leader == self or not(IsValid(self.Leader)) or self.Leader.Following==1 then
		if GLOBALmapnodes then
			local Dist = 10000000000000000
			local SelfPos = self:GetPos()
			local TarPos = Vector()
			local DistanceBetween = Vector()
			local Target = nil
			for i = 1, #GLOBALmapnodes do
				TarPos = GLOBALmapnodes[i][2]
				DistanceBetween = SelfPos:Distance(TarPos)
				if Dist > DistanceBetween then
					Dist = DistanceBetween
					Target = GLOBALmapnodes[i]
				end
			end
			if SelfPos:Distance(Target[2]) < 100 then
				self.OnNode = 1
				local SelfPos2 = self.FinalGoal
				local TarPos2 = Vector()
				local ValidNodes = {}
				for i = 1, #Target[3] do
					TarPos2 = GLOBALmapnodes[Target[3][i]][2]
					if not(self.OldNode == GLOBALmapnodes[Target[3][i]][1]) then
						ValidNodes[#ValidNodes+1] = GLOBALmapnodes[Target[3][i]]
					end
				end
				if #ValidNodes==0 then
					self.Dest = GLOBALmapnodes[self.OldNode][2]
					self.OldNode = Target[1]
				else
					self.OldNode = Target[1]
					self.Dest = ValidNodes[math.random(#ValidNodes)][2]
				end
			else
				self.OnNode = 0
				self.Dest = Target[2]
			end
		else
			self.Dest = self:GetPos() + Vector(math.Rand(-1000000,1000000),math.Rand(-1000000,1000000),0)
		end
	else
		self.Dest = self.Leader.Dest
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

function ENT:SetEnemy( ent )
	self.Enemy = ent
end
function ENT:GetEnemy()
	return self.Enemy
end

function ENT:HaveEnemy()
	if ( self:GetEnemy() and IsValid( self:GetEnemy() ) ) then
		if ( self:GetEnemy():IsPlayer() and !self:GetEnemy():Alive() ) then
			return self:FindEnemy()
		end
		return true
	else
		return self:FindEnemy()
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
function ENT:FindEnemy()
    local Origin  = self:GetPos() + Vector(0, 0, 72) -- Offset to get better PVS results
    local Min     = math.huge -- inf
    local Target  = nil
    local ValidTargets = {}
    for _, V in pairs(ents.FindInPVS(Origin)) do
    	local ValidTarget = false
    	if self.AttackPlayers == true then
    		ValidTarget = not(V:IsFlagSet(FL_FROZEN)) and IsValid(V) and V.BugNoTrack ~= 1 and (V:IsNPC() or (V:IsPlayer() and V.DakTeam ~= self.DakTeam) or V.Bug or (V.DakTeam~=nil and V.DakTeam ~= self.DakTeam)) and V:Health()>0
    	else
    		ValidTarget = not(V:IsFlagSet(FL_FROZEN)) and IsValid(V) and V.BugNoTrack ~= 1 and (V:IsNPC() or V.Bug or (V.DakTeam~=nil and V.DakTeam ~= self.DakTeam)) and V:Health()>0 and not(V:IsPlayer())
    	end
        if ValidTarget then
	        local SightTrace = {}
		        SightTrace.start = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos
		        if V:IsPlayer() and V:InVehicle() then
		        	SightTrace.endpos = V:GetVehicle():GetPos()
		        else
			        if V:LookupAttachment("eyes") > 0 then
				        SightTrace.endpos = V:GetAttachment(V:LookupAttachment("eyes")).Pos
				    else
				    	SightTrace.endpos = V:GetPos()+V:OBBCenter()
				    end
				end
				SightTrace.filter = {self}
		    local CheckSightFire = util.TraceLine( SightTrace )
		    if IsValid(CheckSightFire.Entity) or CheckSightFire.Entity:IsWorld() then
		    	if self.ShootVehicles == true then
		    		if CheckSightFire.Entity == V or CheckSightFire.Entity.SPPOwner == V then
				    	ValidTargets[#ValidTargets+1] = V
		            	local Len = (V:GetPos() - Origin):LengthSqr()
			            if Len < Min then
			                Min = Len
			                Target = V
			            end
			        end
		    	else
				    if CheckSightFire.Entity == V then
				    	ValidTargets[#ValidTargets+1] = V
		            	local Len = (V:GetPos() - Origin):LengthSqr()
			            if Len < Min then
			                Min = Len
			                Target = V
			            end
			        end
			    end
		    else
		    	local SightTraceUp = {}
			        SightTraceUp.start = V:GetPos()+V:OBBCenter()
				    SightTraceUp.endpos = V:GetPos()+V:OBBCenter()+Vector(0,0,250)
					SightTraceUp.filter = {self}
			    local CheckSightFireUp = util.TraceLine( SightTraceUp )
			    if CheckSightFireUp.Entity == V then
			    	ValidTargets[#ValidTargets+1] = V
	            	local Len = (V:GetPos() - Origin):LengthSqr()
		            if Len < Min then
		                Min = Len
		                Target = V
		            end
		        else
		        	local SightTraceDown = {}
				        SightTraceDown.start = V:GetPos()+V:OBBCenter()
					    SightTraceDown.endpos = V:GetPos()+V:OBBCenter()+Vector(0,0,-250)
						SightTraceDown.filter = {self}
			    	local CheckSightFireDown = util.TraceLine( SightTraceDown )
		        	if CheckSightFireDown.Entity == V then
			        	ValidTargets[#ValidTargets+1] = V
		            	local Len = (V:GetPos() - Origin):LengthSqr()
			            if Len < Min then
			                Min = Len
			                Target = V
			            end
			        end
		        end
		    end
        end
    end
    if not(IsValid(self.Enemy)) and Target then
	    self:PlayFindSound()
    end
    self.EnemyCount = #ValidTargets
    self.Enemy = Target
    self.TargetAge = CurTime()
   
    return Target and true or false
end

function ENT:FindCloseEnemy(pos)
    local Origin  = self:GetPos() + Vector(0, 0, 72) -- Offset to get better PVS results
    local Min     = math.huge -- inf
    local Target  = nil
    local ValidTargets = {}
    for _, V in pairs(ents.FindInPVS(Origin)) do
        local ValidTarget = false
    	if self.AttackPlayers == true then
    		ValidTarget = not(V:IsFlagSet(FL_FROZEN)) and IsValid(V) and V.BugNoTrack ~= 1 and (V:IsNPC() or (V:IsPlayer() and V.DakTeam ~= self.DakTeam) or V.Bug or (V.DakTeam~=nil and V.DakTeam ~= self.DakTeam)) and V:Health()>0
    	else
    		ValidTarget = not(V:IsFlagSet(FL_FROZEN)) and IsValid(V) and V.BugNoTrack ~= 1 and (V:IsNPC() or V.Bug or (V.DakTeam~=nil and V.DakTeam ~= self.DakTeam)) and V:Health()>0 and not(V:IsPlayer())
    	end
        if ValidTarget then
	        local SightTrace = {}
		        SightTrace.start = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos
		        if V:IsPlayer() and V:InVehicle() then
		        	SightTrace.endpos = V:GetVehicle():GetPos()
		        else
			        if V:LookupAttachment("eyes") > 0 then
				        SightTrace.endpos = V:GetAttachment(V:LookupAttachment("eyes")).Pos
				    else
				    	SightTrace.endpos = V:GetPos()+V:OBBCenter()
				    end
				end
				SightTrace.filter = {self}
		    local CheckSightFire = util.TraceLine( SightTrace )
		    if IsValid(CheckSightFire.Entity) or CheckSightFire.Entity:IsWorld() then
			    if CheckSightFire.Entity == V then
			    	ValidTargets[#ValidTargets+1] = V
	            	local Len = (V:GetPos() - Origin):LengthSqr()
		            if Len < Min then
		                Min = Len
		                Target = V
		            end
		        end
		    else
		    	local SightTraceUp = {}
			        SightTraceUp.start = V:GetPos()+V:OBBCenter()
				    SightTraceUp.endpos = V:GetPos()+V:OBBCenter()+Vector(0,0,250)
					SightTraceUp.filter = {self}
			    local CheckSightFireUp = util.TraceLine( SightTraceUp )
			    if CheckSightFireUp.Entity == V then
			    	ValidTargets[#ValidTargets+1] = V
	            	local Len = (V:GetPos() - Origin):LengthSqr()
		            if Len < Min then
		                Min = Len
		                Target = V
		            end
		        else
		        	local SightTraceDown = {}
				        SightTraceDown.start = V:GetPos()+V:OBBCenter()
					    SightTraceDown.endpos = V:GetPos()+V:OBBCenter()+Vector(0,0,-250)
						SightTraceDown.filter = {self}
			    	local CheckSightFireDown = util.TraceLine( SightTraceDown )
		        	if CheckSightFireDown.Entity == V then
			        	ValidTargets[#ValidTargets+1] = V
		            	local Len = (V:GetPos() - Origin):LengthSqr()
			            if Len < Min then
			                Min = Len
			                Target = V
			            end
			        end
		        end
		    end
        end
    end
    self.EnemyCount = #ValidTargets
    self.Enemy = Target
    self.TargetAge = CurTime()
    return Target and true or false
end

function ENT:MoveToPos( options )
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

function ENT:FireMelee(damage)
	if IsValid(self:GetEnemy()) then
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

function ENT:OnInjured( info )
	if info:GetAttacker():GetClass()~=self:GetClass() then
		self.NextTarget = info:GetAttacker()
	end
	self.LastFind = CurTime()
end
util.AddNetworkString( "daktankshotfired" )
function ENT:FireShell()
	if IsValid(self:GetEnemy()) then
		self:FaceTowardsAndWait( self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter() )
		if IsValid(self:GetEnemy()) then
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
			for i=1, 10 do
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
		    if CheckFire.Entity then
		    	if CheckFire.Entity.DakTeam == self.DakTeam or (CheckFire.Entity:IsPlayer() and self.AttackPlayers==false) then
		    		self.NoFire = 1
		    	else
		    		self.NoFire = 0
		    	end
		    end
			if self.PrimaryLastFire+self.PrimaryCooldown<CurTime() and not(self.NoFire == 1) then
				if IsValid(self:GetEnemy()) then
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
							shell.DakPenetration = (self.DakCaliber*1.20)
							shell.DakBasePenetration = (self.DakCaliber*1.20)
						end
						if shell.DakShellType == "HEATFS" then
							shell.DakPenetration = (self.DakCaliber*5.40)
							shell.DakBasePenetration = (self.DakCaliber*5.40)
						end
						DakTankShellList[#DakTankShellList+1] = shell
					end
					self.PrimaryLastFire = CurTime()
					local effectdata = EffectData()
					--effectdata:SetOrigin( self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos+((self:GetEnemy():GetPos()+Vector(0,0,self:GetEnemy():OBBCenter().z))-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):GetNormalized()*25 )
					effectdata:SetOrigin( self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos )
					effectdata:SetAngles( ((self:GetEnemy():GetPos()+Vector(0,0,self:GetEnemy():OBBCenter().z))-self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos):Angle() )
					effectdata:SetEntity(self)
					effectdata:SetScale( 0.1 )
					util.Effect( "dakteballisticfirelight", effectdata )
					self:EmitSound( self.FireSound, 140, 100, 1, 2)

					net.Start( "daktankshotfired" )
					net.WriteVector( self:GetPos() )
					net.WriteFloat( self.DakCaliber )
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
	if IsValid(self:GetEnemy()) then
		self:FaceTowardsAndWait( self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter() )
		if IsValid(self:GetEnemy()) then

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
				if IsValid(self:GetEnemy()) then
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

function ENT:OnKilled( dmginfo )
	--self:Remove()
	timer.Simple( engine.TickInterval()*2, function()
		self:Remove()
		self:SetColor(Color(255,255,255,0))
	end )
	--self:SetColor(Color(255,255,255,0))

	local SoundList = {"npc/combine_soldier/die1.wav","npc/combine_soldier/die2.wav","npc/combine_soldier/die3.wav"}
	self:EmitSound( SoundList[math.random(#SoundList)], 100, 100, 1, 2 )

	self:BecomeRagdoll( dmginfo )
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


function ENT:Think()
	if IsValid(self) then
		if IsValid(self.Enemy) then
			self:Aim(self.Enemy:EyePos())
			self.HasEnemy = 1
		else
			self.HasEnemy = 0
		end
		if SERVER then
			if (self.LastThink+0.1) < CurTime() then
					if self:Health()<=0 then
						self:EmitSound( self.DeathSoundList[math.random(#self.DeathSoundList)], 100, 100, 1, 6 )
						--self:Remove()
					else
						--self:PlayHurtSound()
					end
					if IsValid(self.Enemy) then
						if self.Enemy:Health()<=0 then
							self.LastEnemyDiedTime = CurTime()
							timer.Simple(self.FindDelay,function()
								if IsValid(self) then
									self.LastLostEnemy = CurTime()
									if IsValid(self:GetEnemy()) then
										self:FindCloseEnemy(self:GetEnemy():GetPos())
									end
								end
							end)
						end
					end
					if self.commander then
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

function BotFireExplosion(nade, damage, radius)
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
		if IsValid(self:GetEnemy()) then
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

function BotRecurseTraceExplosion(nade, start, endpos, filter, target, damage)
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

function ENT:OnContact( ent )
    if ent:IsPlayer() then
        ent:SetPos( ent:GetPos()+self:GetForward()*10+Vector(0,0,1)  )
    end
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
			if IsValid(self:GetEnemy()) then
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
				if CurTime() - self.StuckTimer > 0.5 and IsValid(self:GetEnemy()) then
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
					    		if IsValid(self:GetEnemy()) then
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
											if IsValid(self:GetEnemy()) then
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
										if IsValid(self:GetEnemy()) and self:GetEnemy():Health() > 0 then
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
				        			if IsValid(self:GetEnemy()) and self:GetEnemy():Health() > 0 then
				        				self.LastBurstTime = CurTime()
				        			else
				        				if IsValid(self:GetEnemy()) then
				        					self.LastEnemyDiedTime = CurTime()
				        					timer.Simple(self.FindDelay,function()
				        						if IsValid(self) then
				        							if IsValid(self:GetEnemy()) then
														self:FindCloseEnemy(self:GetEnemy():GetPos())
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
									if IsValid(self:GetEnemy()) then
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
									if self:GetEnemy():Health() > 0 then
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
									if self:GetEnemy():Health() > 0 then
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
								if self:GetEnemy():Health() > 0 then
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
								if self:GetEnemy():Health() > 0 then
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
					self.loco:FaceTowards( self.Dest )
					if self.commander then
						if self.shouldmove == 1 then
							self:MoveToPos()
						else
							self:SetSequence(self.IdleAnimation)
						end
					else
						if self.Stationary == false then
							if self:GetPos():Distance(self.Dest) > 100 then
								self:MoveToPos()
							else
								self:Pathfind()
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