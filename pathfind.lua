local Start = Vector(3270.075684, -949.181458, -3496.085449)--Vector( 8662.101563, 2229.285156, 162.809479 )
local End = Vector( -3228.089111, -580.685852, -3430.656738 )

local Radius = 25
local StepSize = 50
local MaxStepHeight = 50
local OffsetAng = 10

local BaseNode = Start
local CurNode = Start
local PathNodes = 0
local LastPathNodes = 0
local Offset = 0
local Dir = ((End-CurNode):GetNormalized():Angle()+Angle(0,Offset,0)):Forward()*Vector(1,1,0)
local HitGoal = false

debugoverlay.Cross( Start, 100, 10, Color( 100, 255, 100 ), true )
debugoverlay.Cross( End, 100, 10, Color( 255, 100, 100 ), true )
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
			NodeList[#NodeList+1] = BaseNode
			debugoverlay.Cross( BaseNode, 100, 10, Color( 100, 100, 255 ), true )
			Offset = 0
		end
		CurNode = BaseNode
		LastPathNodes = PathNodes
		PathNodes = 0
	else
		--run trace down to see if area can be stood in
		local downtrace = {}
			downtrace.start = Check.HitPos + Vector(0,0,MaxStepHeight*2)
			downtrace.endpos = Check.HitPos + Vector(0,0,-10000)
			downtrace.filter = {}
			downtrace.mins = Vector(-1,-1,-1)
			downtrace.maxs = Vector(1,1,1)
			downtrace.mask = MASK_SOLID_BRUSHONLY
		local CheckDown = util.TraceHull( downtrace )
		local watertrace = {}
			watertrace.start = Check.HitPos + Vector(0,0,MaxStepHeight*2)
			watertrace.endpos = Check.HitPos + Vector(0,0,-10000)
			watertrace.filter = {}
			watertrace.mins = Vector(-1,-1,-1)
			watertrace.maxs = Vector(1,1,1)
			watertrace.mask = MASK_WATER
		local Checkwater = util.TraceHull( watertrace )
		if CheckDown.HitPos:Distance(Check.HitPos)<=MaxStepHeight or CheckDown.HitPos:Distance(Check.HitPos)>MaxStepHeight*2 or Checkwater.Hit then
			--debugoverlay.Cross( Check.HitPos, 40, 10, Color( 255, 100, 100 ), true )
			Offset = Offset + OffsetAng
			Dir = ((End-CurNode):GetNormalized():Angle()+Angle(0,Offset,0)):Forward()*Vector(1,1,0)
			if PathNodes > LastPathNodes then
				Dir = (End-CurNode):GetNormalized()*Vector(1,1,0)
				BaseNode = CurNode
				debugoverlay.Line( NodeList[#NodeList], BaseNode, 10, Color( 100, 100, 255 ), true)
				NodeList[#NodeList+1] = BaseNode
				debugoverlay.Cross( BaseNode, 100, 10, Color( 100, 100, 255 ), true )
				Offset = 0
			end
			if CheckDown.HitPos:Distance(Check.HitPos)>MaxStepHeight*2 then
				CurNode = Vector(BaseNode.x,BaseNode.y,CheckDown.HitPos.z+20)
			else
				CurNode = BaseNode
			end
			LastPathNodes = PathNodes
			PathNodes = 0
		else
			CurNode = Vector(Check.HitPos.x,Check.HitPos.y,CheckDown.HitPos.z+20)
			debugoverlay.Cross( CurNode, 10, 10, Color( 255, 100, 100 ), true )
			PathNodes = PathNodes + 1
			if PathNodes > LastPathNodes and Offset > 0 then
				Dir = (End-CurNode):GetNormalized()*Vector(1,1,0)
				BaseNode = CurNode
				debugoverlay.Line( NodeList[#NodeList], BaseNode, 10, Color( 100, 100, 255 ), true)
				NodeList[#NodeList+1] = BaseNode
				debugoverlay.Cross( BaseNode, 100, 10, Color( 100, 100, 255 ), true )
				Offset = 0
			end
		end
	end
	if CurNode:Distance(End) <= 100 then
		BaseNode = CurNode
		debugoverlay.Line( NodeList[#NodeList], BaseNode, 10, Color( 100, 100, 255 ), true)
		NodeList[#NodeList+1] = BaseNode
		debugoverlay.Cross( BaseNode, 100, 10, Color( 100, 100, 255 ), true )
		HitGoal = true
	end
end
print("Cycles: "..runs)
print("Nodes: "..(#NodeList))
--PrintTable(NodeList)
