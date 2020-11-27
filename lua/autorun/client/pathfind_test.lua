DakPath = DakPath or {}
DakPath.Nodes = DakPath.Nodes or {}
DakPath.Unused = DakPath.Unused or {}

local StartColor = Color(0, 255, 0)
local EndColor   = Color(255, 0, 0)
local LineColor  = Color(255, 255, 255)
local NodeColor  = Color(255, 0, 255)
local PathColor  = Color(0, 0, 255)
local GridColor  = Color(255, 255, 0)
local SideColor  = Color(0, 255, 255)

local Nodes         = DakPath.Nodes
local Unused        = DakPath.Unused
local Duration      = 10
local Radius        = 25
local StepSize      = 50
local MaxHeight     = 50
local OffsetAng     = 10
local Normal        = Vector(1, 1, 0)
local PosOffset     = Vector(0, 0, 10)
local UpNormal      = Vector(0, 0, 1)
local MaxSlope      = math.cos(math.rad(45))
local MinimumPath   = 30
local MaxIterations = 50000
local GridSize      = 75
local GridHeight    = 75
local JumpHeight    = 56 -- Totally not a random number I decided to pick because of the stairs
local GridCube      = Vector(GridSize, GridSize, GridHeight) * 0.495 -- Leaving a small gap between each of them
local HalfHeight    = Vector(0, 0, GridHeight * 0.5)
local VectorFormat  = "[%s, %s, %s]"

local CheckNode = {}
local DownTrace = { start = true, endpos = true, mins = Vector(), maxs = Vector(), mask = MASK_SOLID_BRUSHONLY }
local WaterTrace = { start = true, endpos = true, mins = Vector(), maxs = Vector(), mask = MASK_WATER }
local NodeTrace = { start = true, endpos = true, mins = Vector(-Radius, -Radius, -5), maxs = Vector(Radius, Radius, 20), mask = MASK_SOLID_BRUSHONLY, output = CheckNode }

local function GetCoordinate(Position)
	return math.Round(Position.x / GridSize), math.Round(Position.y / GridSize), math.Round(Position.z / GridHeight)
end

local function IsValidNode(Top, Bottom)
	DownTrace.start  = Top
	DownTrace.endpos = Bottom

	local CheckDown = util.TraceHull(DownTrace)

	if not CheckDown.Hit then return false end
	if CheckDown.StartSolid then return false end
	if CheckDown.HitNotSolid then return false end
	if UpNormal:Dot(CheckDown.HitNormal) < MaxSlope then return false end

	DownTrace.start = CheckDown.HitPos
	DownTrace.endpos = CheckDown.HitPos - CheckDown.Normal * 72

	if util.TraceHull(DownTrace).Hit then return false end -- Players won't fit

	WaterTrace.start = Top
	WaterTrace.endpos = Bottom

	local CheckWater = util.TraceHull(WaterTrace)

	if CheckWater.Hit then return false end

	return true, CheckDown
end

local function GetNode(Position)
	local X, Y, Z = GetCoordinate(Position)
	local Key = VectorFormat:format(X, Y, Z)

	return Nodes[Key], Key
end

local function GetNodeNoKey(Position)
	local X, Y, Z = GetCoordinate(Position)
	local Key = VectorFormat:format(X, Y, Z)

	return Nodes[Key]
end

local function AddNode(Position)
	local Node, Key = GetNode(Position)

	if not Node or Unused[Key] then
		local X, Y, Z    = GetCoordinate(Position)
		local Coordinate = Vector(X, Y, Z)
		local Center     = Vector(X * GridSize, Y * GridSize, Z * GridHeight)
		local Top, Bottom = Center + HalfHeight, Center - HalfHeight
		local Valid, CheckDown = IsValidNode(Top, Bottom)

		if not Valid then
			Unused[Key] = true
			return
		end

		Node = {
			Key        = Key,
			Coordinate = Coordinate,
			Center     = Center,
			Top        = Top,
			Floor      = CheckDown.HitPos,
			Bottom     = Bottom,
			Sides      = {},
			SideCount  = 0,
		}

		Nodes[Key] = Node
	end

	return Node
end

local function RemoveNode(Position)
	local Node, Key = GetNode(Position)

	if Node then
		for Side in pairs(Node.Sides) do
			Side.Sides[Node] = nil
		end

		Nodes[Key] = nil
	end
end

local function ClearNodes()
	for Node in pairs(Nodes) do
		Nodes[Node] = nil
	end

	for Node in pairs(Unused) do
		Unused[Node] = nil
	end
end

local function DrawNodes()
	local Position = LocalPlayer():GetEyeTrace().HitPos
	local Center   = Vector(GetCoordinate(Position))
	local Offset   = Vector()
	local NoAngle  = Angle()
	local Amount   = 5

	for X = Center.x - Amount, Center.x + Amount do
		for Y = Center.y - Amount, Center.y + Amount do
			for Z = Center.z - Amount, Center.z + Amount do
				Offset.x = X
				Offset.y = Y
				Offset.z = Z

				local Key = VectorFormat:format(X, Y, Z)
				local Node = Nodes[Key]

				if not Node then continue end

				render.DrawWireframeBox(Node.Center, NoAngle, -GridCube, GridCube, GridColor, true)
				render.DrawWireframeSphere(Node.Floor, 10, 4, 4, StartColor, true)

				if Node.SideCount == 0 then continue end

				local NodeFloor = Node.Floor + PosOffset

				for Side in pairs(Node.Sides) do
					render.DrawLine(NodeFloor, Side.Floor + PosOffset, SideColor, true)
				end
			end
		end
	end
end

-- TODO: Add more garbage here
local function CanConnect(Node1, Node2)
	DownTrace.start = Node1.Top
	DownTrace.endpos = Node2.Top

	if util.TraceHull(DownTrace).Hit then return false end

	local Floor1 = Node1.Floor
	local Floor2 = Node2.Floor

	DownTrace.start = Floor1
	DownTrace.endpos = Floor2

	if util.TraceHull(DownTrace).Hit then
		local Height = math.abs(Floor1.z - Floor2.z)

		if Height > JumpHeight then return false end
	end

	return true
end

local function GetNeighbours(Node, Checked)
	local Start  = Vector(Node.Center:Unpack())
	local Count  = Node.SideCount
	local Sides  = Node.Sides
	local Offset = Vector()
	local Found  = {}

	for X = -1, 1 do
		for Y = -1, 1 do
			for Z = -1, 1 do
				Offset.x = X * GridSize
				Offset.y = Y * GridSize
				Offset.z = Z * GridHeight

				local Position = Start + Offset
				local Current  = AddNode(Position)

				if not Current then continue end
				if not CanConnect(Node, Current) then
					if Current.SideCount == 0 then
						RemoveNode(Position)
					end

					continue
				end

				local Distance = Start:DistToSqr(Position)
				local CurSides = Current.Sides
				local Key      = Current.Key

				if not Sides[Current] then
					Sides[Current] = {
						Distance = Distance,
					}

					Count = Count + 1
				end

				if not CurSides[Node] then
					CurSides[Node] = {
						Distance = Distance,
					}

					Current.SideCount = Current.SideCount + 1
				end

				if not Checked[Key] then
					Found[Key] = Current
				end
			end
		end
	end

	Node.SideCount = Count

	return Found
end

-- runs astar test and shows path
concommand.Add("path_run_astar", function()
	AStar(DakPath.Start, DakPath.End)
end)

-- Activates the node debug view
concommand.Add("path_grid_show", function()
	hook.Add("PostDrawOpaqueRenderables", "Path Grid Display", DrawNodes)
end)

-- Deactivates the node debug view
concommand.Add("path_grid_hide", function()
	hook.Remove("PostDrawOpaqueRenderables", "Path Grid Display")
end)

-- Clears nodes and unused nodes from memory
concommand.Add("path_grid_clear", function()
	ClearNodes()

	hook.Remove("PostDrawOpaqueRenderables", "Path Grid Display")
end)

-- Sets the start position for the pathfinder
concommand.Add("path_start", function(Player)
	local Start = Player:GetEyeTrace().HitPos

	DakPath.Start = Start

	Player:ChatPrint("Path start has been setup as " .. tostring(Start))

	debugoverlay.Cross(Start, 100, Duration, StartColor, true)
end)

-- Sets the end position for the pathfinder
concommand.Add("path_end", function(Player)
	local End = Player:GetEyeTrace().HitPos

	DakPath.End = End

	Player:ChatPrint("Path end has been setup as " .. tostring(End))

	debugoverlay.Cross(End, 100, Duration, EndColor, true)
end)

-- Runs the test pathfinder
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

-- Generates a set of walkable nodes with the start position as origin
concommand.Add("path_generate", function()
	if not DakPath.Start then return print("No starting point has been setup with path_start") end

	ClearNodes() -- I don't want to call path_grid_clear every time I do this

	local StartPos   = DakPath.Start
	local Checked    = {}
	local Pending    = { AddNode(StartPos) }
	local Count      = #Pending -- Could be one or zero
	local Total      = Count
	local Iterations = 0
	local Start      = SysTime()

	while Count > 0 do
		Iterations = Iterations + 1
		Count = 0

		for Key, Current in pairs(Pending) do
			Checked[Key] = true
			Pending[Key] = nil

			local Neighbours = GetNeighbours(Current, Checked)

			for New, Node in pairs(Neighbours) do
				Pending[New] = Node

				Count = Count + 1
				Total = Total + 1
			end
		end
	end

	local Finish = SysTime()

	print("Finished propagation")
	print("Iterations:", Iterations)
	print("Duration:", Finish - Start)
	print("Total Nodes:", Total)
end)

function AStar(Start, End)
	local OpenList = {GetNodeNoKey(Start)}
	local ClosedList = {}
	local Goal = false
	local F
	local G
	local H
	local CurrentNode = GetNodeNoKey(Start)
	local runs = 0
	local CameFrom = {}
	while Goal == false and runs < 1000 do
		runs = runs + 1
		G = 0
		H = math.sqrt(math.pow(Start.x - End.x,2) + math.pow(Start.y - End.y,2)) --euclidean
		F = G + H

		if CurrentNode == GetNodeNoKey(End) then
			Goal = true
		else
			ClosedList[CurrentNode.Key] = CurrentNode
			--table.RemoveByValue( OpenList, CurrentNode )
			--PrintTable(OpenList)
			local Options = GetNeighbours(CurrentNode,ClosedList)

			for New, Node in pairs(Options) do
				if Node.Bottom~=nil then
					OpenList[Node.Key] = Node
				end
			end
			local LowestF = math.huge
			local lowestNode
			local potentialG
			for New, Node in pairs(OpenList) do
				if istable(Node) then
					potentialG = G + math.sqrt(math.pow(CurrentNode.Bottom.x - Node.Bottom.x,2) + math.pow(CurrentNode.Bottom.y - Node.Bottom.y,2))
					H = math.sqrt(math.pow(Node.Bottom.x - End.x,2) + math.pow(Node.Bottom.y - End.y,2)) --euclidean
					F = potentialG + H
					
					if F < LowestF and potentialG>0 and not(ClosedList[Node.Key]) then
						LowestF = F
						lowestNode = Node
					end
				end
			end
			G = G + potentialG
			CameFrom[lowestNode.Key] = CurrentNode.Key
			CurrentNode = lowestNode
			debugoverlay.Cross(DakPath.Start, 100, 10, Color(0,255,0), true )
			debugoverlay.Cross(DakPath.End, 100, 10, Color(255,0,0), true )
			--debugoverlay.Cross(CurrentNode.Bottom, 10, 10, Color(0,0,255), true )
		end
	end
	print(runs)

	--some sort of backtracing attempt but then i realized that it's all one big line anyway that needs to be untangled
	local Traced = false
	local runs = 0
	local key = GetNodeNoKey(End).Key
	local waypoints = {}
	while Traced == false and runs < 1000 do
		waypoints[#waypoints+1] = Nodes[key].Bottom
		debugoverlay.Cross(Nodes[key].Bottom, 10, 10, Color(0,0,255), true )
		if key == GetNodeNoKey(Start).Key then
			Traced = true
		else
			key = CameFrom[key]
		end
	end
end