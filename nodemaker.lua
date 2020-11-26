--note, get a Z position that is comfortably inside the world, there's seemingly 0 standardization on those things
local ZPos = 0
local uptrace = util.TraceLine( {
	start = Vector(0,0,ZPos),
	endpos = Vector(0,0,ZPos)+Vector(0,0,1)*1000000,
	mask = MASK_NPCWORLDSTATIC
} )

local startpos = Vector(0,0,uptrace.HitPos.z-25)
local righttrace = util.TraceLine( {
	start = startpos,
	endpos = startpos+Vector(0,1,0)*1000000,
	mask = MASK_NPCWORLDSTATIC
} )
local lefttrace = util.TraceLine( {
	start = startpos,
	endpos = startpos-Vector(0,1,0)*1000000,
	mask = MASK_NPCWORLDSTATIC
} )
local fronttrace = util.TraceLine( {
	start = startpos,
	endpos = startpos+Vector(1,0,0)*1000000,
	mask = MASK_NPCWORLDSTATIC
} )
local backtrace = util.TraceLine( {
	start = startpos,
	endpos = startpos-Vector(1,0,0)*1000000,
	mask = MASK_NPCWORLDSTATIC
} )

local MapCenter = (righttrace.HitPos+lefttrace.HitPos+fronttrace.HitPos+backtrace.HitPos)*0.25
local NodeStart = Vector(fronttrace.HitPos.x,lefttrace.HitPos.y,uptrace.HitPos.z)

local StepSize = 50
local XDist = math.abs(fronttrace.HitPos.x)+math.abs(backtrace.HitPos.x)
local YDist = math.abs(lefttrace.HitPos.y)+math.abs(righttrace.HitPos.y)
local XNodes = XDist/StepSize
local YNodes = YDist/StepSize
local CurVector = Vector(0,0,0)
local Nodes = {}

local testtrace = util.TraceHull( {
	start = Vector(-30.389648, 120.099884, -29.856628),
	endpos = Vector(-30.389648, 120.099884, -29.856628)+Vector(0,0,-1)*1000000,
	mask = MASK_SOLID_BRUSHONLY
} )

for i=1, XNodes do
	for j=1, YNodes do
		CurVector = Vector(-StepSize*i,StepSize*j,0)
		local downtrace = {}
			downtrace.start = NodeStart + CurVector
			downtrace.endpos = NodeStart + CurVector + Vector(0,0,-10000)
			downtrace.filter = {}
			downtrace.mins = Vector(0)
			downtrace.maxs = Vector(0)
			downtrace.mask = MASK_SOLID_BRUSHONLY
		local CheckDown = util.TraceHull( downtrace )
		local watertrace = {}
			watertrace.start = NodeStart + CurVector
			watertrace.endpos = NodeStart + CurVector + Vector(0,0,-10000)
			watertrace.filter = {}
			watertrace.mins = Vector(0)
			watertrace.maxs = Vector(0)
			watertrace.mask = MASK_WATER
		local Checkwater = util.TraceHull( watertrace )
		if not(Checkwater.Hit and Checkwater.HitPos.z>CheckDown.HitPos.z) then
			Nodes[#Nodes+1] = CheckDown.HitPos
			debugoverlay.Cross( CheckDown.HitPos, 10, 10, Color( 255, 255, 255 ), true )
		end
	end
end

