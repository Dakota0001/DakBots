DakPath = DakPath or {}
DakPath.Nodes = DakPath.Nodes or {}
DakPath.Unused = DakPath.Unused or {}

local StartColor = Color(0, 255, 0)
local EndColor   = Color(255, 0, 0)
local LineColor  = Color(255, 255, 255)
local NodeColor  = Color(255, 0, 255)
local PathColor  = Color(0, 0, 255)
local GridColor  = Color(255, 255, 0)

local Nodes         = DakPath.Nodes
local Unused        = DakPath.Unused
local Duration      = 10
local Radius        = 25
local StepSize      = 50
local MaxHeight     = 50
local OffsetAng     = 10
local Normal        = Vector(1, 1, 0)
local MinimumPath   = 30
local MaxIterations = 50000
local GridSize      = 150
local GridCube      = Vector(GridSize, GridSize, GridSize) * 0.495 -- Leaving a small gap between each of them
local HalfHeight    = Vector(0, 0, GridSize * 0.5)
local VectorFormat  = "[%s, %s, %s]"

local CheckNode = {}
local DownTrace = { start = true, endpos = true, mins = Vector(), maxs = Vector(), mask = MASK_SOLID_BRUSHONLY }
local WaterTrace = { start = true, endpos = true, mins = Vector(), maxs = Vector(), mask = MASK_WATER }
local NodeTrace = { start = true, endpos = true, mins = Vector(-Radius, -Radius, -5), maxs = Vector(Radius, Radius, 20), mask = MASK_SOLID_BRUSHONLY, output = CheckNode }

local function GetCoordinate(Position)
	return math.Round(Position.x / GridSize), math.Round(Position.y / GridSize), math.Round(Position.z / GridSize)
end

local function AddNode(Position)
	local X, Y, Z = GetCoordinate(Position)
	local Key = VectorFormat:format(X, Y, Z)

	if not Nodes[Key] then
		local Center = Vector(X, Y, Z) * GridSize

		DownTrace.start = Center + HalfHeight
		DownTrace.endpos = Center - HalfHeight

		local CheckDown = util.TraceHull(DownTrace)

		if not CheckDown.Hit then
			Unused[Key] = {
				Center = Center
			}

			return
		end

		Nodes[Key] = {
			Center = Center,
			Floor = CheckDown.HitPos,
		}
	end
end

local function DrawNodes()
	local Ang = Angle()

	for _, Data in pairs(Nodes) do
		render.DrawWireframeBox(Data.Center, Ang, -GridCube, GridCube, GridColor, true)
		render.DrawWireframeSphere(Data.Floor, 10, 10, 10, StartColor, true)
	end

	for _, Data in pairs(Unused) do
		render.DrawWireframeBox(Data.Center, Ang, -GridCube, GridCube, EndColor, true)
	end
end

concommand.Add("path_grid_display", function()
	hook.Add("PostDrawOpaqueRenderables", "Path Grid Display", DrawNodes)

	timer.Simple(Duration, function()
		hook.Remove("PostDrawOpaqueRenderables", "Path Grid Display")
	end)
end)

concommand.Add("path_grid_clear", function()
	for Node in pairs(Nodes) do
		Nodes[Node] = nil
	end

	for Node in pairs(Unused) do
		Unused[Node] = nil
	end

	hook.Remove("PostDrawOpaqueRenderables", "Path Grid Display")
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
	local Direction     = (End - CurNode):GetNormalized() * Normal
	local HitGoal       = false
	local NodeList      = { BaseNode }
	local NodeCount     = 1
	local Iterations    = 0
	local DebugStart    = SysTime()

	AddNode(CurNode)

	while HitGoal == false and Iterations < MaxIterations do
		Iterations = Iterations + 1

		NodeTrace.start = CurNode - Direction * Radius + Vector(0, 0, MaxHeight)
		NodeTrace.endpos = CurNode + Direction * StepSize + Vector(0, 0, MaxHeight)

		util.TraceHull(NodeTrace)

		if CheckNode.Hit then
			Offset    = Offset + OffsetAng
			Direction = ((End - CurNode):GetNormalized():Angle() + Angle(0, Offset, 0)):Forward() * Normal

			if PathNodes > LastPathNodes then
				debugoverlay.Line(BaseNode, CurNode, Duration, LineColor, true)

				Direction = (End - CurNode):GetNormalized() * Normal
				NodeCount = NodeCount + 1
				BaseNode  = CurNode
				Offset    = 0

				NodeList[NodeCount] = CurNode

				AddNode(CurNode)

				debugoverlay.Cross(BaseNode, 100, Duration, NodeColor, true)
			end

			CurNode = BaseNode
			LastPathNodes = math.max(PathNodes,MinimumPath)
			PathNodes = 0

			AddNode(CurNode)
		else
			--run trace down to see if area can be stood in
			DownTrace.start = CheckNode.HitPos + Vector(0, 0, MaxHeight * 2)
			DownTrace.endpos = CheckNode.HitPos + Vector(0, 0, -10000)
			local CheckDown = util.TraceHull(DownTrace)

			WaterTrace.start = CheckNode.HitPos + Vector(0, 0, MaxHeight * 2)
			WaterTrace.endpos = CheckNode.HitPos + Vector(0, 0, -10000)
			local CheckWater = util.TraceHull(WaterTrace)

			if CheckDown.HitPos:Distance(CheckNode.HitPos) < MaxHeight or CheckDown.HitPos:Distance(CheckNode.HitPos) > MaxHeight * 2 or (CheckWater.Hit and CheckWater.HitPos.z > CheckDown.HitPos.z) then
				--debugoverlay.Cross( CheckNode.HitPos, 40, Duration, Color( 255, 100, 100 ), true )
				Offset    = Offset + OffsetAng
				Direction = ((End-CurNode):GetNormalized():Angle() + Angle(0, Offset, 0)):Forward() * Normal

				if PathNodes > LastPathNodes then
					debugoverlay.Line(BaseNode, CurNode, Duration, LineColor, true)

					Direction  = (End - CurNode):GetNormalized() * Normal
					NodeCount = NodeCount + 1
					BaseNode  = CurNode
					Offset    = 0

					NodeList[NodeCount] = CurNode

					debugoverlay.Cross(CurNode, 100, Duration, NodeColor, true)
				end

				if CheckDown.HitPos:Distance(CheckNode.HitPos) > MaxHeight * 2 then
					if CheckDown.HitPos:Distance(CheckNode.HitPos) > MaxHeight * 3 then
						CurNode = BaseNode
					else
						CurNode = Vector(BaseNode.x,BaseNode.y,CheckDown.HitPos.z + 20)
					end
				else
					CurNode = BaseNode
				end

				LastPathNodes = math.max(PathNodes,MinimumPath)
				PathNodes = 0

				AddNode(CurNode)
			else
				CurNode   = Vector(CheckNode.HitPos.x,CheckNode.HitPos.y,CheckDown.HitPos.z + 20)
				PathNodes = PathNodes + 1

				AddNode(CurNode)

				debugoverlay.Cross(CurNode, 10, Duration, PathColor, true)

				if PathNodes > LastPathNodes and Offset > 0 then
					debugoverlay.Line(BaseNode, CurNode, Duration, LineColor, true)

					Direction = (End - CurNode):GetNormalized() * Normal
					NodeCount = NodeCount + 1
					BaseNode  = CurNode
					PathNodes = 0
					Offset    = 0

					NodeList[NodeCount] = CurNode

					AddNode(CurNode)

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
