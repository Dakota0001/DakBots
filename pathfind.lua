local Start = Vector( 7231.784180, -10556.130859, -2948.645996 )--Vector( 8662.101563, 2229.285156, 162.809479 )
local End = Vector( -3228.089111, -580.685852, -3430.656738 )

local Radius = 25
local StepSize = 50
local MaxStepHeight = 50
local OffsetAng = 10
local MinimumPath = 30

local BaseNode = Start
local CurNode = Start
local PathNodes = 0
local LastPathNodes = MinimumPath
local Offset = 0
local Dir = ((End-CurNode):GetNormalized():Angle()+Angle(0,Offset,0)):Forward()*Vector(1,1,0)
local HitGoal = false

debugoverlay.Cross( Start, 100, 10, Color( 0, 255, 0 ), true )
debugoverlay.Cross( End, 100, 10, Color( 255, 0, 0 ), true )
local NodeList = {BaseNode}
local runs = 0
while HitGoal == false and runs < 10000 do
	runs = runs + 1
	local trace = {}
		trace.start = CurNode - Dir * Radius + Vector(0,0,MaxStepHeight)
		trace.endpos = CurNode + Dir * StepSize + Vector(0,0,MaxStepHeight)
		trace.filter = {}
		trace.mins = Vector(-Radius,-Radius,-5)
		trace.maxs = Vector(Radius,Radius,30)
		trace.mask = MASK_SOLID_BRUSHONLY
	local Check = util.TraceHull( trace )
	--debugoverlay.Cross( Check.HitPos, 10, 10, Color( 255, 100, 100 ), true )
	if Check.Hit then
		--debugoverlay.Cross( Check.HitPos, 40, 10, Color( 255, 100, 100 ), true )
		Offset = Offset + OffsetAng
		Dir = ((End-CurNode):GetNormalized():Angle()+Angle(0,Offset,0)):Forward()*Vector(1,1,0)
		if PathNodes > LastPathNodes then
			Dir = (End-CurNode):GetNormalized()*Vector(1,1,0)
			BaseNode = CurNode
			debugoverlay.Line( NodeList[#NodeList], BaseNode, 10, Color( 255, 255, 255 ), true)
			NodeList[#NodeList+1] = BaseNode
			debugoverlay.Cross( BaseNode, 100, 10, Color( 0, 0, 255 ), true )
			Offset = 0
		end
		CurNode = BaseNode
		LastPathNodes = math.max(PathNodes,MinimumPath)
		PathNodes = 0
	else
		--run trace down to see if area can be stood in
		local downtrace = {}
			downtrace.start = Check.HitPos + Vector(0,0,MaxStepHeight*2)
			downtrace.endpos = Check.HitPos + Vector(0,0,-10000)
			downtrace.filter = {}
			downtrace.mins = Vector(0)
			downtrace.maxs = Vector(0)
			downtrace.mask = MASK_SOLID_BRUSHONLY
		local CheckDown = util.TraceHull( downtrace )
		local watertrace = {}
			watertrace.start = Check.HitPos + Vector(0,0,MaxStepHeight*2)
			watertrace.endpos = Check.HitPos + Vector(0,0,-10000)
			watertrace.filter = {}
			watertrace.mins = Vector(0)
			watertrace.maxs = Vector(0)
			watertrace.mask = MASK_WATER
		local Checkwater = util.TraceHull( watertrace )
		if CheckDown.HitPos:Distance(Check.HitPos)<MaxStepHeight or CheckDown.HitPos:Distance(Check.HitPos)>MaxStepHeight*2 or (Checkwater.Hit and Checkwater.HitPos.z>CheckDown.HitPos.z) then
			--debugoverlay.Cross( Check.HitPos, 40, 10, Color( 255, 100, 100 ), true )
			Offset = Offset + OffsetAng
			Dir = ((End-CurNode):GetNormalized():Angle()+Angle(0,Offset,0)):Forward()*Vector(1,1,0)
			if PathNodes > LastPathNodes then
				Dir = (End-CurNode):GetNormalized()*Vector(1,1,0)
				BaseNode = CurNode
				debugoverlay.Line( NodeList[#NodeList], BaseNode, 10, Color( 255, 255, 255 ), true)
				NodeList[#NodeList+1] = BaseNode
				debugoverlay.Cross( BaseNode, 100, 10, Color( 0, 0, 255 ), true )
				Offset = 0
			end
			if CheckDown.HitPos:Distance(Check.HitPos)>MaxStepHeight*2 then
				if CheckDown.HitPos:Distance(Check.HitPos)>MaxStepHeight*3 then
					CurNode = BaseNode
				else
					CurNode = Vector(BaseNode.x,BaseNode.y,CheckDown.HitPos.z+20)
				end
			else
				CurNode = BaseNode
			end
			LastPathNodes = math.max(PathNodes,MinimumPath)
			PathNodes = 0
		else
			CurNode = Vector(Check.HitPos.x,Check.HitPos.y,CheckDown.HitPos.z+20)
			--debugoverlay.Cross( CurNode, 10, 10, Color( 0, 0, 0 ), true )
			PathNodes = PathNodes + 1
			if PathNodes > LastPathNodes and Offset > 0 then
				Dir = (End-CurNode):GetNormalized()*Vector(1,1,0)
				BaseNode = CurNode
				debugoverlay.Line( NodeList[#NodeList], BaseNode, 10, Color( 255, 255, 255 ), true)
				NodeList[#NodeList+1] = BaseNode
				debugoverlay.Cross( BaseNode, 100, 10, Color( 0, 0, 255 ), true )
				Offset = 0
				PathNodes = 0
			end
		end
	end
	if CurNode:Distance(End) <= 100 then
		BaseNode = CurNode
		debugoverlay.Line( NodeList[#NodeList], BaseNode, 10, Color( 255, 255, 255 ), true)
		NodeList[#NodeList+1] = BaseNode
		--debugoverlay.Cross( BaseNode, 100, 10, Color( 0, 0, 255 ), true )
		HitGoal = true
	end
end

--run LOS check and ground check steps to each position ahead of current node starting from furthest and stopping at next in line to see if it can directly move there
local FinalWaypoints = {Start}

CurNode = FinalWaypoints[#FinalWaypoints]
BaseNode = FinalWaypoints[#FinalWaypoints]
End = NodeList[#NodeList]
Dir = (End-CurNode):GetNormalized()*Vector(1,1,0)
local failedpaths = 0
local lastwaypoint = 1
HitGoal = false
local runs2 = 0
local runs3 = 0
HitFinalGoal = false 
while HitFinalGoal == false and runs3 < 10000 do
	runs3 = runs3 + 1

	CurNode = FinalWaypoints[#FinalWaypoints]
	BaseNode = FinalWaypoints[#FinalWaypoints]
	End = NodeList[#NodeList]
	Dir = (End-CurNode):GetNormalized()*Vector(1,1,0)
	failedpaths = 0
	runs2 = 0
	HitGoal = false
	while HitGoal == false and runs2 < 10000 do
		runs2 = runs2 + 1
		local trace = {}
			trace.start = CurNode - Dir * Radius + Vector(0,0,MaxStepHeight)
			trace.endpos = CurNode + Dir * StepSize + Vector(0,0,MaxStepHeight)
			trace.filter = {}
			trace.mins = Vector(-Radius,-Radius,-5)
			trace.maxs = Vector(Radius,Radius,30)
			trace.mask = MASK_SOLID_BRUSHONLY
		local Check = util.TraceHull( trace )
		--debugoverlay.Cross( Check.HitPos, 10, 10, Color( 255, 100, 100 ), true )
		if Check.Hit then
			CurNode = BaseNode
			failedpaths = failedpaths + 1
			End = NodeList[#NodeList-failedpaths]
			Dir = (End-CurNode):GetNormalized()*Vector(1,1,0)
		else
			--run trace down to see if area can be stood in
			local downtrace = {}
				downtrace.start = Check.HitPos + Vector(0,0,MaxStepHeight*2)
				downtrace.endpos = Check.HitPos + Vector(0,0,-10000)
				downtrace.filter = {}
				downtrace.mins = Vector(0)
				downtrace.maxs = Vector(0)
				downtrace.mask = MASK_SOLID_BRUSHONLY
			local CheckDown = util.TraceHull( downtrace )
			local watertrace = {}
				watertrace.start = Check.HitPos + Vector(0,0,MaxStepHeight*2)
				watertrace.endpos = Check.HitPos + Vector(0,0,-10000)
				watertrace.filter = {}
				watertrace.mins = Vector(0)
				watertrace.maxs = Vector(0)
				watertrace.mask = MASK_WATER
			local Checkwater = util.TraceHull( watertrace )
			if CheckDown.HitPos:Distance(Check.HitPos)<MaxStepHeight or CheckDown.HitPos:Distance(Check.HitPos)>MaxStepHeight*2 or (Checkwater.Hit and Checkwater.HitPos.z>CheckDown.HitPos.z) then
				if CheckDown.HitPos:Distance(Check.HitPos)>MaxStepHeight*2 then
					if CheckDown.HitPos:Distance(Check.HitPos)>MaxStepHeight*3 then
						CurNode = BaseNode
					else
						CurNode = Vector(BaseNode.x,BaseNode.y,CheckDown.HitPos.z+20)
					end
				else
					CurNode = BaseNode
				end
				failedpaths = failedpaths + 1
				End = NodeList[#NodeList-failedpaths]
				Dir = (End-CurNode):GetNormalized()*Vector(1,1,0)
			else
				CurNode = Vector(Check.HitPos.x,Check.HitPos.y,CheckDown.HitPos.z+20)
			end
		end
		if (#NodeList-failedpaths) == lastwaypoint+1 then
			print("thingy")
		end
		if CurNode:Distance(End) <= 100 or (#NodeList-failedpaths) == lastwaypoint+1 then
			debugoverlay.Line( FinalWaypoints[#FinalWaypoints], End, 10, Color( 0, 0, 0 ), true)
			print(#NodeList-failedpaths)
			lastwaypoint = (#NodeList-failedpaths)
			FinalWaypoints[#FinalWaypoints+1] = End
			HitGoal = true
		end
	end
	if #FinalWaypoints==10 then--FinalWaypoints[#FinalWaypoints]:Distance(NodeList[#NodeList]) <= 100 then
		HitFinalGoal = true
	end
end
print(NodeList[1])
debugoverlay.Cross( (NodeList[50]), 100, 10, Color( 0, 0, 255 ), true )
print("Cycles: "..runs)
print("Nodes: "..(#NodeList))
print("Waypoints: "..(#FinalWaypoints))
--PrintTable(NodeList)
