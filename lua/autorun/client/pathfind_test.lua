DakPath = DakPath or {}
DakPath.Nodes = DakPath.Nodes or {}
DakPath.Unused = DakPath.Unused or {}
DakPath.Paths = DakPath.Paths or {}

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
local StepSize      = 26.25 --current bot step size
local MaxHeight     = 50
local OffsetAng     = 10
local WadeDepth		= 48
local Normal        = Vector(1, 1, 0)
local PosOffset     = Vector(0, 0, 10)
local UpNormal      = Vector(0, 0, 1)
local MaxSlope      = math.cos(math.rad(45))
local MinimumPath   = 30
local MaxIterations = 50000
local GridSize      = 75
local GridHeight    = 150
local JumpHeight    = 35 --actual bot step height currently as no jumping is allowed --56 -- Totally not a random number I decided to pick because of the stairs
local GridCube      = Vector(GridSize, GridSize, GridHeight) * 0.495 -- Leaving a small gap between each of them
local HalfHeight    = Vector(0, 0, GridHeight * 0.5)
local VectorFormat  = "[%s, %s, %s]"

local CheckNode = {}
local DownTrace = { start = true, endpos = true, mins = Vector(), maxs = Vector(), mask = MASK_SOLID_BRUSHONLY }
local WaterTrace = { start = true, endpos = true, mins = Vector(), maxs = Vector(), mask = MASK_WATER }
local NodeTrace = { start = true, endpos = true, mins = Vector(-Radius, -Radius, -5), maxs = Vector(Radius, Radius, 20), mask = MASK_SOLID_BRUSHONLY, output = CheckNode }

local function DropVector(Vec)
	DownTrace.start  = Vec+Vector(0,0,25)
	DownTrace.endpos = Vec-Vector(0,0,500)
	local CheckDown = util.TraceHull(DownTrace)
	return CheckDown.HitPos
end

local function VectorToGrid(Position)
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

	if CheckWater.Hit and CheckDown.HitPos.z+WadeDepth<CheckWater.HitPos.z then return false end

	return true, CheckDown
end

local function GetNode(Position)
	local X, Y, Z = VectorToGrid(Position)
	local Key = VectorFormat:format(X, Y, Z)

	return Nodes[Key], Key
end

local function GetNodeFromVector(Position)
	local X, Y, Z = VectorToGrid(Position)
	local Key = VectorFormat:format(X, Y, Z)

	return Nodes[Key]
end

local function AddNode(Position)
	local Node, Key = GetNode(Position)

	if not Node or Unused[Key] then
		local X, Y, Z    = VectorToGrid(Position)
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
			Connections = {}
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
	local Center   = Vector(VectorToGrid(Position))
	local Offset   = Vector()
	local NoAngle  = Angle()
	local Amount   = 10

	for X = Center.x - Amount, Center.x + Amount do
		for Y = Center.y - Amount, Center.y + Amount do
			for Z = Center.z - Amount, Center.z + Amount do
				Offset.x = X
				Offset.y = Y
				Offset.z = Z

				local Key = VectorFormat:format(X, Y, Z)
				local Node = Nodes[Key]

				if not Node then continue end

				--render.DrawWireframeBox(Node.Center, NoAngle, -GridCube, GridCube, GridColor, true)
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
				if Current == Node then continue end
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

				Node.Connections[Current] = Distance

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

concommand.Add("path_make_all_paths", function()
	--gm_emp_cyclopean
	local cyclopeanTable = {
		Vector(8343.555664, -10086.312500, 3376.031250), --had to be changed
		Vector(6137.738281, 1248.062622, 2719.822266),
		Vector(10387.305664, 9959.908203, 3368.031250),
		Vector(30.444704, 8613.874023, 2368.031250),
		Vector(1834.775024, -1075.389526, 2270.761230),
		Vector(-10111.933594, -10227.226563, 3368.031250),
		Vector(-5272.229492, 2796.873291, 2737.434570),
		Vector(-11754.385742, 10937.160156, 4147.003906) --had to be changed
	}
	--gm_emp_coast
	local coastTable = {
		Vector(680.035828, 1934.840698, 728.031250),
		Vector(-360.71417236328, 14465.139648438, 100.83126831055),
		Vector(-377.65539550781, -8393.970703125, 537.8193359375),
		Vector(11176.348632813, 4945.646484375, 498.98565673828),
		Vector(-10717.245117188, -1661.9329833984, 317.25704956055),
		Vector(-9371.2109375, 8421.5537109375, 129.69058227539),
		Vector(11237.416992188, -5095.6333007813, 128.03125)
	}
	--gm_emp_palmbay
	local palmbayTable = {
		Vector(-8020.9624023438, -6747.1743164063, -2330.3911132813),
		Vector(3700.7368164063, -9836.2275390625, -2575.96875),
		Vector(3800.0705566406, -1593.5148925781, -2954.0405273438),
		Vector(10389.444335938, 982.81701660156, -2063.9711914063),
		Vector(9119.900390625, 10735.4296875, -2331.96875),
		Vector(-7949.4086914063, 6239.8110351563, -2933.0256347656)
	}
	--gm_emp_canyon
	local canyonTable = {
		Vector(11469.577148438, -6255.041015625, 20.59476852417),
		Vector(8473.134765625, 325.95901489258, 520.21319580078),
		Vector(8803.6962890625, 5931.8852539063, 0.47704315185547),
		Vector(11827.244140625, 10962.939453125, 18.160446166992),
		Vector(1796.6341552734, 6945.3681640625, 15.336364746094),
		Vector(747.47930908203, 214.9630279541, 32.358711242676),
		Vector(-8750.994140625, 2618.8464355469, 16.548538208008),
		Vector(-7314.5634765625, 11391.150390625, 25.019695281982),
		Vector(-6729.2905273438, -4935.2368164063, 19.781524658203)
	}
	--gm_emp_bush
	local bushTable = {
		Vector(461.644196, -183.797287, -3609.968750), --changed
		Vector(1033.4080810547, -11927.537109375, -2931.0432128906),
		Vector(-12372.145507813, -11344.141601563, -3327.9558105469),
		Vector(-9305.3740234375, 941.68090820313, -3321.1452636719),
		Vector(-12777.774414063, 7177.6962890625, -2993.7590332031),
		Vector(-6259.2866210938, 2982.8078613281, -3294.0197753906),
		Vector(-5839.708984375, -8377.15625, -3647.3486328125),
		Vector(-754.16394042969, 9957.4892578125, -3308.4055175781),
		Vector(3425.7854003906, 6805.392578125, -2992.5424804688),
		Vector(1462.0169677734, -6538.375, -3212.3059082031),
		Vector(9223.1982421875, -6720.69140625, -3002.7626953125),
		Vector(11080.934570313, -3762.5844726563, -2934.8410644531),
		Vector(7897.71875, 2508.1240234375, -3320.9345703125),
		Vector(11560.930664063, 12248.51171875, -3327.96875),
		Vector(5303.6704101563, 9606.1435546875, -2999.4294433594)
	}
	--gm_emp_mesa
	local mesaTable = {
		Vector(10849.646484375, -9665.6513671875, 512.03125),
		--Vector(-1935.9918212891, 548.43914794922, 1743.03125), --this is the tower on the middle of the map that requires ladders to get to
		Vector(1497.2092285156, 13140.393554688, 160.03125),
		Vector(-2498.0358886719, -13811.28515625, 160.03125),
		Vector(-13969.802734375, -11518.235351563, 608.03125),
		Vector(11756.094726563, 14226.184570313, 192.03125),
		Vector(-10521.319335938, 10493.283203125, 216.35948181152)
	}
	--gm_emp_chain
	local chainTable = {
		Vector(13969.4375, 10955.375, -1084.28125+25),
		Vector(-13249.75, 9978.21875, -1084.375+25),
		Vector(-3358.75, 2094.40625, -1143.6875+25),
		Vector(4454.4375, -5777.65625, -1647.6875+25),
		Vector(13280.0625, -12846.96875, -1103.4375+25),
		Vector(747.125, -2458.8125, -1402.75+25),
		Vector(-5281.34375, -8283.0625, -1759.6875+25),
		Vector(-13177.53125, -12754.8125, -1135.0625+25),
		Vector(-12984.21875, -4274.65625, -1135+25),
		Vector(7657.46875, 777.5, -1142.25+25),
		Vector(11205.25, -5642.21875, -1135.6875+25),
		Vector(14428.59375, 4990.09375, -1143.6875+25),
		Vector(1680.15625, 12556.53125, -1143.6875+25),
		Vector(-7703, 12065.15625, -1143.6875+25)
	}
	--gm_emp_manticore
	local manticoreTable = {
		Vector(-4293.71875, 4164.875, 1719.71875),
		Vector(4521.40625, -4828.6875, 1719.3125),
		Vector(2880.625, 1123.6875, 1179.03125),
		Vector(-5548.21875, -239.375, 1239.78125),
		Vector(-7461.90625, 9851.3125, 1211.1875),
		Vector(7434.4375, -11102.09375, 1159.3125),
		Vector(-2540.9375, -3092.9375, 1719.3125),
		Vector(4242.375, 5819.125, 1719.28125),
		Vector(10482.78125, -198.15625, 1735.375),
		Vector(-12926.375, -4013.46875, 1671.40625),
		Vector(-12635.03125, 2757.21875, 1670.53125)
	}
	
	local VecTable = manticoreTable
	local Fine = true
	local Broke = {}
	for i=1, #VecTable do
		if GetNodeFromVector(DropVector(VecTable[i])) == nil then 
			Fine = false
			Broke[#Broke+1] = i
			debugoverlay.Box(DropVector(VecTable[i]), Vector(GridSize, GridSize, GridHeight) * -0.5, Vector(GridSize, GridSize, GridHeight) * 0.5, 15, Color(255, 0, 0))
		end
	end
	if Fine == true then
		for i=1, #VecTable do
			for j=1, #VecTable do
				AStar(DropVector(VecTable[j]), DropVector(VecTable[i]))
			end
		end
	else
		print("Invalid Node Positions:")
		PrintTable(Broke)
	end
end)

-- Activates the node debug view
concommand.Add("path_grid_show", function()
	hook.Add("PostDrawOpaqueRenderables", "Path Grid Display", DrawNodes)
end)

concommand.Add("path_save", function()
	if not(file.Exists( "dakpaths", "DATA" )) then file.CreateDir( "dakpaths" ) end
	file.Write( "dakpaths/"..game.GetMap()..".txt", util.Compress( util.TableToJSON( DakPath.Paths ) ) )
	print("File Saved as: dakpaths/"..game.GetMap()..".txt")
end)

concommand.Add("path_load", function()
	if file.Exists( "dakpaths/"..game.GetMap()..".txt", "DATA" ) then
		DakPath.Paths = util.JSONToTable(util.Decompress(file.Read( "dakpaths/"..game.GetMap()..".txt", "DATA" )))
		print("Path file loaded")
	else
		print("No path file found")
	end
end)

concommand.Add("path_clear", function()
	DakPath.Paths = {}
	print("Path list purged.")
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

concommand.Add("show_astar_paths", function()
	for i=1, #DakPath.Paths do
		for I, V in ipairs(DakPath.Paths[i]) do
			debugoverlay.Box(V.Floor, Vector(GridSize, GridSize, 2) * -0.5, Vector(GridSize, GridSize, 2) * 0.5, 30, HSVToColor(I * (360 / #DakPath.Paths[i]), 1, 1))
		end
	end
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

local Open, gScore, fScore, parent

-- TODO: Rewrite this!!
-- If the nodes/scores were stored in an ordered list it would have O(1) cost, this is currently O(n)
local function GetLowestNode()
	local min = math.huge
	local choice

	for K in pairs(Open) do
		if fScore[K] < min then
			min    = fScore[K]
			choice = K
		end
	end

	return choice
end

function AStar(Start, End)
	local StartNode = GetNodeFromVector(Start)
	local EndNode   = GetNodeFromVector(End)
	local Found

	Open   = {[StartNode] = true}
	gScore = {[StartNode] = 0}
	fScore = {[StartNode] = StartNode.Floor:DistToSqr(End)}
	parent = {}

	local ENDTIME
	local STARTTIME = SysTime()

	while next(Open) do
		local CurNode = GetLowestNode()
		local BaseG   = gScore[CurNode]

		Open[CurNode] = nil

		if CurNode == EndNode then
			Found = true
			ENDTIME = SysTime()
			break
		end

		for Node, Dist in pairs(CurNode.Connections) do
			local G = BaseG + Dist * 10000 -- Turning up the G cost will provide a more optimal path but may take longer to calculate

			if not gScore[Node] or G < gScore[Node] then -- Undiscovered node or the path to this node from the current is the fastest
				parent[Node] = CurNode
				gScore[Node] = G
				fScore[Node] = G + Node.Floor:DistToSqr(End)

				Open[Node] = true
				--debugoverlay.Cross(Node.Floor + Vector(0, 0, 5) + VectorRand() * 5, 5, 30, ColorRand(100, 255))
			end
		end
	end

	if Found then
		print("Found! Took " .. math.Round(ENDTIME - STARTTIME, 4) .. " seconds")

		local CurNode = EndNode
		local Route   = {}

		while parent[CurNode] do
			Route[#Route + 1] = parent[CurNode]

			CurNode = parent[CurNode]
		end

		for I, V in ipairs(Route) do
			debugoverlay.Box(V.Floor, Vector(GridSize, GridSize, 2) * -0.5, Vector(GridSize, GridSize, 2) * 0.5, 30, HSVToColor(I * (360 / #Route), 1, 1))
		end
		DakPath.Paths[#DakPath.Paths+1] = Route
	end
end