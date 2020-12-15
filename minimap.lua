do--Minimap Start
	local ScaleX = ScrW()/1920
	local ScaleY = ScrH()/1080

	local LastPress = 0
	hook.Add( "PlayerButtonDown", "DakTankMapScreen", function(ply, button)
		if button == 23 and not(ply:InVehicle()) then
			if CurTime() > LastPress+0.1 then 
				LastPress = CurTime()
				if ply.MapUp == false or ply.MapUp == nil then
					Caps = ents.FindByClass( "daktank_cap" )
					local uptrace = util.TraceLine( {
						start = Vector(0,0,2000),
						endpos = Vector(0,0,2000)+Vector(0,0,1)*1000000,
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

					
					local pos = LocalPlayer():GetPos()
					print("AddCap(\""..game.GetMap().."\", Vector("..pos.x..", "..pos.y..", "..pos.z.."), 0)")

					ply.MapCenter = (righttrace.HitPos+lefttrace.HitPos+fronttrace.HitPos+backtrace.HitPos)*0.25
				 	ply.MapCenter.z = LocalPlayer():GetPos().z+2500--uptrace.HitPos.z-25

					PopupMap = vgui.Create( "DPanel")
					PopupMap:Center()

					function PopupMap:Paint( w, h )
						local CamData = {}
						CamData.angles = Angle(90,0,0)
						CamData.origin = ply.MapCenter
						CamData.aspectratio = 1
						CamData.x = (ScrW() / 2) - 380*ScaleX - 135*ScaleX
						CamData.y = (ScrH() / 2) - 380*ScaleY

						CamData.w = 760*ScaleX
						CamData.h = 760*ScaleY

						local MapSize = (righttrace.HitPos):Distance((lefttrace.HitPos))
						MapSize = MapSize*0.5

						CamData.ortho = true
						CamData.ortholeft = -MapSize - 250
						CamData.orthoright = MapSize + 250
						CamData.orthotop = -MapSize - 250
						CamData.orthobottom = MapSize + 250
						CamData.znear = -10000
						CamData.zfar = 10000

						render.RenderView( CamData )
					end
				end

				if ply.MapUp == nil then 
					ply.MapUp = true
				elseif ply.MapUp == true then
					ply.MapUp = false
					PopupMap:Remove()
				elseif ply.MapUp == false then
					ply.MapUp = true
				end
			end
		end
	end )
end--Minimap End

hook.Add( "PostDrawViewModel", "respawnscreendraws", function()
	if LocalPlayer().MapUp == true then
		render.SetColorMaterial()
		local MDL = ClientsideModel( "models/sprops/misc/alphanum/alphanum_arrow_a.mdl" )
		MDL:SetPos(LocalPlayer():GetPos() + Vector(0,0,1000))
		MDL:SetAngles(Angle(0,LocalPlayer():GetAngles().yaw+90,90))
		MDL:SetModelScale( 50, 0 )
		MDL:Remove()
		render.DrawSphere( LocalPlayer():GetPos(), 500, 30, 30, Color( 0, 0, 0, 150 ) )

		local thumps = ents.FindByClass("prop_thumper")
		for i=1, #thumps do
			local pos = thumps[i]:GetPos()
			render.DrawSphere( pos, 750, 30, 30, Color( 255, 255, 255, 50 ) )

			if i < 10 then
				local MDL = ClientsideModel( "models/sprops/misc/alphanum/alphanum_"..(i)..".mdl" )
				MDL:SetPos(pos+Vector(0,0,1000))
				MDL:SetAngles(Angle(0,90,90))
				MDL:SetModelScale( 50, 0 )
				MDL:SetColor(Color(255,255,255,255))
				MDL:Remove()
			else
				local MDL1 = ClientsideModel( "models/sprops/misc/alphanum/alphanum_"..(tonumber(tostring(i)[1]))..".mdl" )
				MDL1:SetPos(pos+Vector(0,200,1000))
				MDL1:SetAngles(Angle(0,90,90))
				MDL1:SetModelScale( 50, 0 )
				MDL1:SetColor(Color(255,255,255,255))
				MDL1:Remove()
				local MDL2 = ClientsideModel( "models/sprops/misc/alphanum/alphanum_"..(tonumber(tostring(i)[2]))..".mdl" )
				MDL2:SetPos(pos+Vector(0,-200,1000))
				MDL2:SetAngles(Angle(0,90,90))
				MDL2:SetModelScale( 50, 0 )
				MDL2:SetColor(Color(255,255,255,255))
				MDL2:Remove()
			end


		end
	end
end )

concommand.Add("dt_thumpers", function()
	local thumps = ents.FindByClass("prop_thumper")
	for i=1, #thumps do
		local pos = thumps[i]:GetPos()
		print("AddCap(\""..game.GetMap().."\", Vector("..pos.x..", "..pos.y..", "..(pos.z-25).."), 0)")
	end
	print(#thumps.." Points")
end)