GM.Name		= "DakTank"
GM.Author	= "Dakota"
DeriveGamemode( "sandbox" )
 
local Reds, Blues, Specs = 1,2,3

team.SetUp(1, "Red", Color(255,0,0) )
team.SetUp(2, "Blue", Color(0,0,255) )
team.SetUp(3, "Spectators", Color(150,150,150) )