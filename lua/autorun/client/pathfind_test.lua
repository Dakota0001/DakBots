DakPath = DakPath or {}

local StartColor = Color(0, 255, 0)
local EndColor   = Color(255, 0, 0)
local LineColor  = Color(255, 255, 255)
local NodeColor  = Color(0, 0, 255)
local PathColor  = Color(0, 0, 0)

local Duration      = 10
local Radius        = 25
local StepSize      = 50
local MaxHeight     = 50
local OffsetAng     = 10
local Normal        = Vector(1, 1, 0)
local MinimumPath   = 30
local MaxIterations = 30000

concommand.Add("path_start", function(Player)
	DakPath.Start = Player:GetEyeTrace().HitPos

	Player:ChatPrint("Path start has been setup as " .. tostring(DakPath.Start))
end)

concommand.Add("path_end", function(Player)
	DakPath.End = Player:GetEyeTrace().HitPos

	Player:ChatPrint("Path end has been setup as " .. tostring(DakPath.End))
end)

concommand.Add("path_run", function()
	if not DakPath.Start then return print("No starting point has been setup with path_start") end
	if not DakPath.End then return print("No ending point has been setup with path_end") end

	local Start = DakPath.Start
	local End   = DakPath.End

	debugoverlay.Cross(Start, 100, Duration, StartColor, true)
	debugoverlay.Cross(End, 100, Duration, EndColor, true)

	local BaseNode      = Start
	local CurNode       = Start
	local PathNodes     = 0
	local LastPathNodes = MinimumPath
	local Offset        = 0
	local Dir           = (End - CurNode):GetNormalized() * Normal
	local HitGoal       = false
	local NodeList      = {BaseNode}
	local Iterations    = 0
	local DebugStart    = SysTime()

	while HitGoal == false and Iterations < MaxIterations do
		Iterations = Iterations + 1

		local trace = {}
			trace.start = CurNode - Dir * Radius + Vector(0,0,MaxHeight)
			trace.endpos = CurNode + Dir * StepSize + Vector(0,0,MaxHeight)
			trace.filter = {}
			trace.mins = Vector(-Radius,-Radius,-5)
			trace.maxs = Vector(Radius,Radius,20)
			trace.mask = MASK_SOLID_BRUSHONLY
		local Check = util.TraceHull( trace )
		--debugoverlay.Cross( Check.HitPos, 10, 10, Color( 255, 255, 100 ), true )

		if Check.Hit then
			print("World hit, ", PathNodes, LastPathNodes)
			--debugoverlay.Cross( Check.HitPos, 40, 10, Color( 255, 100, 100 ), true )
			Offset = Offset + OffsetAng
			Dir = ((End-CurNode):GetNormalized():Angle() + Angle(0,Offset,0)):Forward() * Normal

			if PathNodes > LastPathNodes then
				Dir = (End-CurNode):GetNormalized() * Normal
				BaseNode = CurNode
				NodeList[#NodeList + 1] = BaseNode
				debugoverlay.Cross( BaseNode, 100, 10, NodeColor, true )
				Offset = 0
			end
			CurNode = BaseNode
			LastPathNodes = math.max(PathNodes,MinimumPath)
			PathNodes = 0
		else
			--run trace down to see if area can be stood in
			local downtrace = {}
				downtrace.start = Check.HitPos + Vector(0,0,MaxHeight * 2)
				downtrace.endpos = Check.HitPos + Vector(0,0,-10000)
				downtrace.filter = {}
				downtrace.mins = Vector()
				downtrace.maxs = Vector()
				downtrace.mask = MASK_SOLID_BRUSHONLY
			local CheckDown = util.TraceHull( downtrace )
			local watertrace = {}
				watertrace.start = Check.HitPos + Vector(0,0,MaxHeight * 2)
				watertrace.endpos = Check.HitPos + Vector(0,0,-10000)
				watertrace.filter = {}
				watertrace.mins = Vector()
				watertrace.maxs = Vector()
				watertrace.mask = MASK_WATER
			local Checkwater = util.TraceHull( watertrace )

			print("Tracedown shit ", CheckDown.HitPos:Distance(Check.HitPos), MaxHeight)
			if CheckDown.HitPos:Distance(Check.HitPos) < MaxHeight or CheckDown.HitPos:Distance(Check.HitPos) > MaxHeight * 2 or (Checkwater.Hit and Checkwater.HitPos.z > CheckDown.HitPos.z) then
				--debugoverlay.Cross( Check.HitPos, 40, 10, Color( 255, 100, 100 ), true )
				Offset = Offset + OffsetAng
				Dir = ((End-CurNode):GetNormalized():Angle() + Angle(0,Offset,0)):Forward() * Normal
				if PathNodes > LastPathNodes then
					Dir = (End-CurNode):GetNormalized() * Normal
					BaseNode = CurNode
					debugoverlay.Line( NodeList[#NodeList], BaseNode, 10, LineColor, true)
					NodeList[#NodeList + 1] = BaseNode
					debugoverlay.Cross( BaseNode, 100, 10, NodeColor, true )
					Offset = 0
				end
				if CheckDown.HitPos:Distance(Check.HitPos) > MaxHeight * 2 then
					if CheckDown.HitPos:Distance(Check.HitPos) > MaxHeight * 3 then
						CurNode = BaseNode
					else
						CurNode = Vector(BaseNode.x,BaseNode.y,CheckDown.HitPos.z + 20)
					end
				else
					CurNode = BaseNode
				end
				LastPathNodes = math.max(PathNodes,MinimumPath)
				PathNodes = 0
			else
				CurNode = Vector(Check.HitPos.x,Check.HitPos.y,CheckDown.HitPos.z + 20)
				debugoverlay.Cross( CurNode, 10, 10, PathColor, true )
				PathNodes = PathNodes + 1
				if PathNodes > LastPathNodes and Offset > 0 then
					Dir = (End-CurNode):GetNormalized() * Normal
					BaseNode = CurNode
					debugoverlay.Line( NodeList[#NodeList], BaseNode, 10, LineColor, true)
					NodeList[#NodeList + 1] = BaseNode
					debugoverlay.Cross( BaseNode, 100, 10, NodeColor, true )
					Offset = 0
					PathNodes = 0
				end
			end
		end
		if CurNode:Distance(End) <= 100 then
			BaseNode = CurNode
			debugoverlay.Line( NodeList[#NodeList], BaseNode, 10, LineColor, true)
			NodeList[#NodeList + 1] = BaseNode
			debugoverlay.Cross( BaseNode, 100, 10, NodeColor, true )
			HitGoal = true
		end
	end

	print("Cycles: " .. Iterations)
	print("Nodes: " .. (#NodeList))
	print("Time: " .. SysTime() - DebugStart)
end)
