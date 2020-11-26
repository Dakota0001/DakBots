DakPath = DakPath or {}
DakPath.Nodes = DakPath.Nodes or {}

local StartColor = Color(0, 255, 0)
local EndColor   = Color(255, 0, 0)
local LineColor  = Color(255, 255, 255)
local NodeColor  = Color(255, 0, 255)
local PathColor  = Color(0, 0, 255)
local GridColor  = Color(255, 255, 0)

local Nodes         = DakPath.Nodes
local Duration      = 10
local Radius        = 25
local StepSize      = 50
local MaxHeight     = 50
local OffsetAng     = 10
local Normal        = Vector(1, 1, 0)
local MinimumPath   = 30
local MaxIterations = 50000
local GridSize      = 250
local GridHeight    = 50

local function GetCoordinate(Position)
	return Vector(
		math.floor(Position.x / GridSize),
		math.floor(Position.y / GridSize),
		math.floor(Position.z / GridHeight)
	)
end

local function GetPosition(Coordinate)
	return Vector(
		math.floor(Coordinate.x * GridSize),
		math.floor(Coordinate.y * GridSize),
		math.floor(Coordinate.z * GridHeight)
	)
end

local function AddGrid(Position)
	local Coord = GetCoordinate(Position)

	Nodes[Coord] = true
end

concommand.Add("path_grid_display", function()
	for Grid in pairs(Nodes) do
		debugoverlay.Cross(GetPosition(Grid), 10, Duration, GridColor, true)
	end
end)

concommand.Add("path_grid_clear", function()
	for Grid in pairs(Nodes) do
		Nodes[Grid] = nil
	end
end)

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
	local NodeList      = { BaseNode }
	local NodeCount     = 1
	local Iterations    = 0
	local DebugStart    = SysTime()

	AddGrid(CurNode)

	while HitGoal == false and Iterations < MaxIterations do
		Iterations = Iterations + 1

		local trace = {
			start = CurNode - Dir * Radius + Vector(0, 0, MaxHeight),
			endpos = CurNode + Dir * StepSize + Vector(0, 0, MaxHeight),
			mins = Vector(-Radius, -Radius, -5),
			maxs = Vector(Radius, Radius, 20),
			mask = MASK_SOLID_BRUSHONLY,
		}
		local Check = util.TraceHull(trace)
		--debugoverlay.Cross( Check.HitPos, 10, Duration, Color( 255, 255, 100 ), true )

		if Check.Hit then
			Offset = Offset + OffsetAng
			Dir    = ((End - CurNode):GetNormalized():Angle() + Angle(0, Offset, 0)):Forward() * Normal

			if PathNodes > LastPathNodes then
				debugoverlay.Line(BaseNode, CurNode, Duration, LineColor, true)

				Dir       = (End - CurNode):GetNormalized() * Normal
				NodeCount = NodeCount + 1
				BaseNode  = CurNode
				Offset    = 0

				NodeList[NodeCount] = CurNode

				AddGrid(CurNode)

				debugoverlay.Cross(BaseNode, 100, Duration, NodeColor, true)
			end

			CurNode = BaseNode
			LastPathNodes = math.max(PathNodes,MinimumPath)
			PathNodes = 0

			AddGrid(CurNode)
		else
			--run trace down to see if area can be stood in
			local downtrace = {
				start = Check.HitPos + Vector(0, 0, MaxHeight * 2),
				endpos = Check.HitPos + Vector(0, 0, -10000),
				mins = Vector(),
				maxs = Vector(),
				mask = MASK_SOLID_BRUSHONLY,
			}
			local CheckDown = util.TraceHull(downtrace)

			local watertrace = {
				start = Check.HitPos + Vector(0,0,MaxHeight * 2),
				endpos = Check.HitPos + Vector(0,0,-10000),
				mins = Vector(),
				maxs = Vector(),
				mask = MASK_WATER,
			}
			local Checkwater = util.TraceHull(watertrace)

			if CheckDown.HitPos:Distance(Check.HitPos) < MaxHeight or CheckDown.HitPos:Distance(Check.HitPos) > MaxHeight * 2 or (Checkwater.Hit and Checkwater.HitPos.z > CheckDown.HitPos.z) then
				--debugoverlay.Cross( Check.HitPos, 40, Duration, Color( 255, 100, 100 ), true )
				Offset = Offset + OffsetAng
				Dir    = ((End-CurNode):GetNormalized():Angle() + Angle(0, Offset, 0)):Forward() * Normal

				if PathNodes > LastPathNodes then
					debugoverlay.Line(BaseNode, CurNode, Duration, LineColor, true)

					Dir       = (End - CurNode):GetNormalized() * Normal
					NodeCount = NodeCount + 1
					BaseNode  = CurNode
					Offset    = 0

					NodeList[NodeCount] = CurNode

					debugoverlay.Cross(CurNode, 100, Duration, NodeColor, true)
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

				AddGrid(CurNode)
			else
				CurNode   = Vector(Check.HitPos.x,Check.HitPos.y,CheckDown.HitPos.z + 20)
				PathNodes = PathNodes + 1

				AddGrid(CurNode)

				debugoverlay.Cross(CurNode, 10, Duration, PathColor, true)

				if PathNodes > LastPathNodes and Offset > 0 then
					debugoverlay.Line(BaseNode, CurNode, Duration, LineColor, true)

					Dir       = (End - CurNode):GetNormalized() * Normal
					NodeCount = NodeCount + 1
					BaseNode  = CurNode
					PathNodes = 0
					Offset    = 0

					NodeList[NodeCount] = CurNode

					debugoverlay.Cross(CurNode, 100, Duration, NodeColor, true )
				end
			end
		end
		if CurNode:Distance(End) <= 100 then
			debugoverlay.Line(BaseNode, CurNode, Duration, LineColor, true)

			BaseNode  = CurNode
			NodeCount = NodeCount + 1
			HitGoal   = true

			NodeList[NodeCount] = CurNode

			debugoverlay.Cross(CurNode, 100, Duration, NodeColor, true )
		end
	end

	print("Cycles: " .. Iterations)
	print("Nodes: " .. NodeCount)
	print("Time: " .. SysTime() - DebugStart)
end)
