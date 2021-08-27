include("sh_player.lua")
include("shared.lua")

--

local ScaleX = ScrW()/1920
local ScaleY = ScrH()/1080

function erarecieve()
	Era = net.ReadString()
end
net.Receive( "DT_era", erarecieve)


function caprecieve()
	CapsInfo = net.ReadTable()
end
net.Receive( "DT_caps", caprecieve)

--[[
function botrecieve()
	RedBotPos = util.JSONToTable(net.ReadString())
	BlueBotPos = util.JSONToTable(net.ReadString())
end
net.Receive( "DT_bots", botrecieve)
--]]

do --Player loaded
	hook.Add("InitPostEntity", "DTPlayerLoaded", function()
	    net.Start("DTPlayerLoaded")
	    net.SendToServer()
	    hook.Remove("InitPostEntity", "DTPlayerLoaded")
	end)
end

do--Fonts Start
	surface.CreateFont("HUDKill", {
		font = "Arial",
		size = 50,
		outline = true,
		weight = 500
	})

	surface.CreateFont("HUDKillInfo", {
		font = "Arial",
		size = 65,
		outline = true,
		weight = 500
	})

	surface.CreateFont( "DakTekDefaultFont", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 35,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = true,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = true,
	} )
end--Fonts End

do--Gamemode Notifications Start
	function DakTankGamemodeNotification()
		local Notif = net.ReadInt(32)
		local Point = net.ReadInt(32)
		local color = Color( 155, 155, 155, 255)
		local duration = 3
		local fade = 1
		local start = CurTime()

		local function DTdrawToScreen()
			local alpha = 255
			local dtime = CurTime() - start

			if dtime > duration then
				hook.Remove("HUDPaint", "DTnotification" )
				return
			end

			if duration - dtime < fade then
				alpha = (duration - dtime) / fade
				alpha = alpha * 255
			else
				alpha = 255
			end
			color.a = alpha


			if Notif == 1 then
				draw.DrawText( "Blue team wins by caps.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
				draw.DrawText( "map restarts in 30 seconds.", "HUDKill", ScrW() * 0.5, ScrH() * 0.35, color, TEXT_ALIGN_CENTER)
			elseif Notif == 2 then
				draw.DrawText( "Red team wins by caps.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
				draw.DrawText( "map restarts in 30 seconds.", "HUDKill", ScrW() * 0.5, ScrH() * 0.35, color, TEXT_ALIGN_CENTER)
			elseif Notif == 3 then
				draw.DrawText( "Red team wins by attrition.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
				draw.DrawText( "map restarts in 30 seconds.", "HUDKill", ScrW() * 0.5, ScrH() * 0.35, color, TEXT_ALIGN_CENTER)
			elseif Notif == 4 then
				draw.DrawText( "Blue team wins by attrition.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
				draw.DrawText( "map restarts in 30 seconds.", "HUDKill", ScrW() * 0.5, ScrH() * 0.35, color, TEXT_ALIGN_CENTER)
			elseif Notif == 5 then
				draw.DrawText( "Red team just captured point "..Point, "HUDKill", ScrW() * 0.5, ScrH() * 0.35, color, TEXT_ALIGN_CENTER)
			elseif Notif == 6 then
				draw.DrawText( "Blue team just captured point "..Point, "HUDKill", ScrW() * 0.5, ScrH() * 0.35, color, TEXT_ALIGN_CENTER)
			elseif Notif == 7 then
				draw.DrawText( "Red team just lost point "..Point, "HUDKill", ScrW() * 0.5, ScrH() * 0.35, color, TEXT_ALIGN_CENTER)
			elseif Notif == 8 then
				draw.DrawText( "Blue team just lost point "..Point, "HUDKill", ScrW() * 0.5, ScrH() * 0.35, color, TEXT_ALIGN_CENTER)
			elseif Notif == 9 then
				draw.DrawText( "Blue team has just 100 points remaining.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 10 then
				draw.DrawText( "Red team has just 100 points remaining.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 11 then
				draw.DrawText( "Red Team has 30 seconds left to get a cap.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 12 then
				draw.DrawText( "Red Team only has 20 seconds left to get a cap.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 13 then
				draw.DrawText( "Red Team has just 10 seconds left to get a cap.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 14 then
				draw.DrawText( "Red Team has survived overtime.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 15 then
				draw.DrawText( "Blue Team has 30 seconds left to get a cap.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 16 then
				draw.DrawText( "Blue Team only has 20 seconds left to get a cap.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 17 then
				draw.DrawText( "Blue Team has just 10 seconds left to get a cap.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 18 then
				draw.DrawText( "Blue Team has survived overtime.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 19 then
				draw.DrawText( "Blue team has 750 points remaining.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 20 then
				draw.DrawText( "Red team has 750 points remaining.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 21 then
				draw.DrawText( "Blue team is down to 500 points remaining.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 22 then
				draw.DrawText( "Red team is down to 500 points remaining.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 23 then
				draw.DrawText( "Blue team has only 250 points remaining.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			elseif Notif == 24 then
				draw.DrawText( "Red team has only 250 points remaining.", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.35 - 55, color, TEXT_ALIGN_CENTER)
			end
		end
		if Notif == 1 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/no01.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/likethat.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 2 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/likethat.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/no01.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 3 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/likethat.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/no01.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 4 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/no01.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/likethat.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 5 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/gotone01.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/question11.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 6 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/question11.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/gotone01.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 7 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/ohno.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/nice.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 8 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/nice.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/ohno.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 9 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 10 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 11 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 12 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 13 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 14 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/yougotit02.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/whoops01.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 15 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 16 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 17 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "npc/attack_helicopter/aheli_damaged_alarm1.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 18 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/whoops01.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/yougotit02.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 19 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/nice.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/doingsomething.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 20 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/doingsomething.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/nice.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 21 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/fantastic01.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/evenodds.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 22 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/evenodds.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/fantastic01.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 23 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/yeah02.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/uhoh.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			elseif Notif == 24 then
				if LocalPlayer():Team() == 1 then
					sound.Play( "vo/npc/male01/uhoh.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				elseif LocalPlayer():Team() == 2 then
					sound.Play( "vo/npc/male01/yeah02.wav", LocalPlayer():GetPos(), 75, 100, 1 )
				end
			end
		hook.Add( "HUDPaint", "DTnotification", DTdrawToScreen )
	end
	net.Receive( "DakTankGamemodeNotification", DakTankGamemodeNotification)
end--Gamemode Notifications End

do--Kill points feedback Start
	function KillNotification()
		local killtype = net.ReadInt(32)
		local PointsGained = math.Round(net.ReadFloat(32),1)
		local color = Color( 155, 155, 155, 255)
		local duration = 3
		local fade = 1
		local start = CurTime()

		local function drawToScreen()
			local alpha = 255
			local dtime = CurTime() - start

			if dtime > duration then
				hook.Remove("HUDPaint", "KillNotification" )
				return
			end

			--if fade - dtime > 0 then
			--	alpha = (fade - dtime) / fade
			--	alpha = 1 - alpha
			--	alpha = alpha * 255
			--end
			
			if duration - dtime < fade then
				alpha = (duration - dtime) / fade
				alpha = alpha * 255
			else
				alpha = 255
			end
			color.a = alpha
			if killtype == 2 then
				if not(LocalPlayer():InVehicle()) then draw.DrawText( "+"..PointsGained, "HUDKill", ScrW() * 0.5, ScrH() * 0.25, color, TEXT_ALIGN_CENTER) end
				draw.DrawText( "Anti-Armor", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.25 - 55, color, TEXT_ALIGN_CENTER)
			elseif killtype == 1 then
				if not(LocalPlayer():InVehicle()) then draw.DrawText( PointsGained, "HUDKill", ScrW() * 0.5, ScrH() * 0.25, color, TEXT_ALIGN_CENTER) end
				color.g = 0
				color.b = 0
				draw.DrawText( "Friendly Fire", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.25 - 55, color, TEXT_ALIGN_CENTER)
			elseif killtype == 3 then
				if not(LocalPlayer():InVehicle()) then draw.DrawText( "+"..PointsGained, "HUDKill", ScrW() * 0.5, ScrH() * 0.25, color, TEXT_ALIGN_CENTER) end
				draw.DrawText( "Point Captured", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.25 - 55, color, TEXT_ALIGN_CENTER)
			else
				if not(LocalPlayer():InVehicle()) then draw.DrawText( "+"..PointsGained, "HUDKill", ScrW() * 0.5, ScrH() * 0.25, color, TEXT_ALIGN_CENTER) end
				draw.DrawText( "Kill", "HUDKillInfo", ScrW() * 0.5, ScrH() * 0.25 - 55, color, TEXT_ALIGN_CENTER)
			end
		end

		hook.Add( "HUDPaint", "KillNotification", drawToScreen )

		if not(LocalPlayer():InVehicle()) then
			if killtype == 2 then
				LocalPlayer():addPoints( PointsGained )
			elseif killtype == 1 then
				LocalPlayer():addPoints( PointsGained )
			elseif killtype == 3 then
				LocalPlayer():addPoints( PointsGained )
			else
				LocalPlayer():addPoints( PointsGained )
			end
		end
		sound.Play( "daktanks/extra/25mmBushmaster.mp3", LocalPlayer():GetPos(), 75, 100, 1 )
	end
	net.Receive( "DT_killnotification", KillNotification)
end--Kill points feedback End

do--HUD Start
	function DrawPoints()
		--draw.SimpleText( ( tostring( LocalPlayer():getPoints() ) or "0" ) .. " points", "HUDKill", 10, 10, color_white )
	end
	hook.Add( "HUDPaint", "DrawPoints", DrawPoints )


	hook.Add("HUDPaint","DakTankGamemodeHud",function()
		local ply = LocalPlayer()

		--HEALTH INDICATOR
		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 50, ScrH()-100, 500, 50 )
		surface.SetDrawColor( 255-(205*ply:Health()/ply:GetMaxHealth()), 255*(ply:Health()/ply:GetMaxHealth()), 50, 200 )
		surface.DrawRect( 55, ScrH()-95, 490*(ply:Health()/ply:GetMaxHealth()), 40 )
		draw.SimpleText( ply:Health().."/"..ply:GetMaxHealth(), "DakTekDefaultFont", 300, ScrH()-75, Color( 255, 255, 255, 255 ), 1, 1 )

		--RESOURCES
		surface.SetDrawColor( 150, 150, 150, 200 )
		surface.DrawOutlinedRect( 50, 50, 250, 50 )	
		surface.DrawOutlinedRect( 300, 50, 250, 50 )	
		surface.DrawOutlinedRect( 50, 100, 250, 50 )	
		surface.DrawOutlinedRect( 300, 100, 250, 50 )
		surface.DrawOutlinedRect( 50, 150, 250, 50 )
		surface.DrawOutlinedRect( 50, 200, 250, 50 )

		surface.SetDrawColor( 255, 50, 50, 200 )
		surface.DrawRect( 51, 51, 248, 48 )
		draw.SimpleText( "Red Resources", "DakTekDefaultFont", 51+125, 51+25, Color( 255, 255, 255, 255 ), 1, 1 )

		surface.SetDrawColor( 50, 50, 255, 200 )
		surface.DrawRect( 301, 51, 248, 48 )	
		draw.SimpleText( "Blue Resources", "DakTekDefaultFont", 301+125, 51+25, Color( 255, 255, 255, 255 ), 1, 1 )

		surface.SetDrawColor( 255, 150, 0, 200 )
		surface.DrawRect( 51, 151, 248, 48 )	
		draw.SimpleText( "Your Resources", "DakTekDefaultFont", 51+125, 151+25, Color( 255, 255, 255, 255 ), 1, 1 )

		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 51, 101, 248, 48 )
		draw.SimpleText( GetGlobalFloat("DakTankRedResources"), "DakTekDefaultFont", 51+125, 101+25, Color( 255, 255, 255, 255 ), 1, 1 )	

		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 301, 101, 248, 48 )
		draw.SimpleText( GetGlobalFloat("DakTankBlueResources"), "DakTekDefaultFont", 301+125, 101+25, Color( 255, 255, 255, 255 ), 1, 1 )

		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 51, 201, 248, 48 )
		draw.SimpleText( tostring( math.Round(LocalPlayer():getPoints(),1) ) or "0", "DakTekDefaultFont", 51+125, 201+25, Color( 255, 255, 255, 255 ), 1, 1 )	

	end)

	local hide = {
		CHudHealth = true,
		CHudBattery = true,
	}
	hook.Add( "HUDShouldDraw", "DakTankGamemodeHideDefaultHUD", function( name )
		if ( hide[ name ] ) then return false end
	end )

	hook.Add( "HUDPaint", "DakTankCompassPaint", function()
		local yaw = LocalPlayer():GetAngles().yaw-90 --yaw 0 equals east, 90 is north
		surface.SetFont( "DakTekDefaultFont" )
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.SetTextColor( 255, 150, 0, 255 )

		if (yaw >= -50 and yaw <= 50) then
			surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw), ScrH()/20, ScrW()/500, ScrH()/20 )
			surface.SetTextPos( ScrW()/2 + (ScrW()/180)*yaw-7.5, ScrH()/10 )
			surface.DrawText("N")
		end

		for i=1, 72 do
			if (yaw+(i*5) >= -50 and yaw+(i*5) <= 50) then
				if i*5 == 45 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw+(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw+(i*5))-(2*7.5), ScrH()/10 )
					surface.DrawText("NE")
				elseif i*5 == 90 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw+(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw+(i*5))-7.5, ScrH()/10 )
					surface.DrawText("E")
				elseif i*5 == 135 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw+(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw+(i*5))-(2*7.5), ScrH()/10 )
					surface.DrawText("SE")
				elseif i*5 == 180 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw+(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw+(i*5))-7.5, ScrH()/10 )
					surface.DrawText("S")
				elseif i*5 == 225 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw+(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw+(i*5))-(2*7.5), ScrH()/10 )
					surface.DrawText("SW")
				elseif i*5 == 270 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw+(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw+(i*5))-7.5, ScrH()/10 )
					surface.DrawText("W")
				elseif i*5 == 315 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw+(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw+(i*5))-(2*7.5), ScrH()/10 )
					surface.DrawText("NW")
				elseif i*5 == 360 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw+(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw+(i*5))-7.5, ScrH()/10 )
					surface.DrawText("N")
				end
				surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw+(i*5)), ScrH()/20, ScrW()/1000, ScrH()/40 )
			end
		end
		for i=1, 36 do
			if (yaw-(i*5) >= -50 and yaw-(i*5) <= 50) then
				if i*5 == 45 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw-(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw-(i*5))-(2*7.5), ScrH()/10 )
					surface.DrawText("NW")
				elseif i*5 == 90 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw-(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw-(i*5))-7.5, ScrH()/10 )
					surface.DrawText("W")
				elseif i*5 == 135 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw-(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw-(i*5))-(2*7.5), ScrH()/10 )
					surface.DrawText("SW")
				elseif i*5 == 180 then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw-(i*5)), ScrH()/20, ScrW()/500, ScrH()/20 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(yaw-(i*5))-7.5, ScrH()/10 )
					surface.DrawText("S")
				end
				surface.DrawRect( ScrW()/2 + (ScrW()/180)*(yaw-(i*5)), ScrH()/20, ScrW()/1000, ScrH()/40 )
			end
		end

		for i=1, #CapsInfo do
			if CapsInfo[i][2] == 1 then
				surface.SetDrawColor( 50, 50, 50, 255 )
				surface.SetTextColor( 255, 0, 0, 255 )
			elseif CapsInfo[i][2] == 2 then
				surface.SetDrawColor( 50, 50, 50, 255 )
				surface.SetTextColor( 0, 0, 255, 255 )
			else
				surface.SetDrawColor( 50, 50, 50, 255 )
				surface.SetTextColor( 255, 255, 255, 255 )
			end

			local CapYaw = -LocalPlayer():WorldToLocalAngles((CapsInfo[i][3]-LocalPlayer():GetPos()):Angle()).yaw
			if (CapYaw >= -50 and CapYaw <= 50) then
				surface.DrawRect( ScrW()/2 + (ScrW()/180)*(CapYaw), ScrH()/20, ScrW()/500, ScrH()/12 )
				surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(CapYaw)-7.5, ScrH()/7.5 )
				surface.DrawText(i)
			end
		end
		local Players = player.GetAll()
		for i=1, #Players do
			if IsValid(Players[i]) and Players[i]:Alive() and Players[i]:Team() == LocalPlayer():Team() and Players[i] ~= LocalPlayer() then
				if Players[i]:Team() == 1 then
					surface.SetDrawColor( 50, 50, 50, 255 )
					surface.SetTextColor( 255, 0, 0, 255 )
				elseif Players[i]:Team() == 2 then
					surface.SetDrawColor( 50, 50, 50, 255 )
					surface.SetTextColor( 0, 0, 255, 255 )
				else
					surface.SetDrawColor( 50, 50, 50, 255 )
					surface.SetTextColor( 255, 255, 255, 255 )
				end

				local PlayerYaw = -LocalPlayer():WorldToLocalAngles((Players[i]:GetPos()-LocalPlayer():GetPos()):Angle()).yaw
				if (PlayerYaw >= -50 and PlayerYaw <= 50) then
					surface.DrawRect( ScrW()/2 + (ScrW()/180)*(PlayerYaw), ScrH()/20, ScrW()/500, ScrH()/9 )
					surface.SetTextPos( ScrW()/2 + (ScrW()/180)*(PlayerYaw)-(string.len(Players[i]:Nick())*7.5), ScrH()/6.25 )
					surface.DrawText(Players[i]:Nick())
				end
			end
		end
	end )
end--HUD End

do--Team Select Start
	function set_team()
		SpawnSelect = vgui.Create( "DFrame" )
		SpawnSelect:Center()
		SpawnSelect:SetPos( ScrW() / 4, ScrH() / 4 )
		SpawnSelect:SetSize( 800*ScaleX, 600*ScaleY )
		SpawnSelect:SetTitle( "Team Select" )
		SpawnSelect:SetVisible( true )
		SpawnSelect:SetDraggable( false )
		SpawnSelect:ShowCloseButton( false )
		SpawnSelect:MakePopup()
		 
		Red = vgui.Create( "DButton", SpawnSelect )
		Red:SetPos( 20*ScaleX, 25*ScaleY )
		Red:SetSize( 140*ScaleX, 40*ScaleY )
		Red:SetText( "Red" )
		Red.DoClick = function()
			SpawnSelect:SetVisible( false )
			RunConsoleCommand( "dt_team1" )
		end

		Blue = vgui.Create( "DButton", SpawnSelect )
		Blue:SetPos( 250*ScaleX, 25*ScaleY )
		Blue:SetSize( 140*ScaleX, 40*ScaleY )
		Blue:SetText( "Blue" )
		Blue.DoClick = function()
			SpawnSelect:SetVisible( false )
			RunConsoleCommand( "dt_team2" )
		end
	end
	concommand.Add( "dt_start", set_team )
end--Team Select End

do--Respawning Start
	function set_respawn()
		local ply = LocalPlayer()
		if GetConVar("DakTankLoadoutArmor")==nil then
			CreateClientConVar( "DakTankLoadoutArmor", "0", true, true )
		end
		if GetConVar("DakTankLoadoutPrimary")==nil then
			CreateClientConVar( "DakTankLoadoutPrimary", "0", true, true )
		end
		if GetConVar("DakTankLoadoutSecondary")==nil then
			CreateClientConVar( "DakTankLoadoutSecondary", "0", true, true )
		end
		if GetConVar("DakTankLoadoutSpecial")==nil then
			CreateClientConVar( "DakTankLoadoutSpecial", "0", true, true )
		end
		if GetConVar("DakTankLoadoutPerk")==nil then
			CreateClientConVar( "DakTankLoadoutPerk", "0", true, true )
		end
		if GetConVar("DakTankLoadoutSpawn")==nil then
			CreateClientConVar( "DakTankLoadoutSpawn", "0", true, true )
		end
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

		ply.MapCenter = (righttrace.HitPos+lefttrace.HitPos+fronttrace.HitPos+backtrace.HitPos)*0.25
	 	ply.MapCenter.z = LocalPlayer():GetPos().z+2500--uptrace.HitPos.z-25

	 	if RespawnSelect == nil then
			RespawnSelect = vgui.Create( "DFrame" )
			RespawnSelect:SetPos( ScrW() / 4, ScrH() / 4 )
			RespawnSelect:SetSize( 1080*ScaleX, 810*ScaleY )
			RespawnSelect:SetTitle( "Respawn Screen" )
			RespawnSelect:SetVisible( true )
			RespawnSelect:SetDraggable( false )
			RespawnSelect:ShowCloseButton( false )
			RespawnSelect:MakePopup()
			RespawnSelect:Center()
			ply.RespawnScreenOpen = true
			
			RespawnMap = vgui.Create( "DPanel", RespawnSelect )
			RespawnMap:Center()

			function RespawnMap:Paint( w, h )
				local CamData = {}
				CamData.angles = Angle(90,90,0)
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
				CamData.znear = -100000
				CamData.zfar = 100000

				render.RenderView( CamData )
			end

			RespawnButton = vgui.Create( "DButton", RespawnSelect )
			RespawnButton:SetPos( (1080-147.5-70)*ScaleX, (810-25-50)*ScaleY )
			RespawnButton:SetSize( 150*ScaleX, 50*ScaleY )
			RespawnButton:SetText( "Respawn me" )
			RespawnButton.DoClick = function()
				local validcaps = 0
				for i=1, #CapsInfo do 
					if CapsInfo[i][2] == LocalPlayer():Team() then
						validcaps = validcaps + 1
					end
				end
				if validcaps < 1 then
					RespawnButton:SetText( "No Free Caps" )
				else
					RespawnSelect:SetVisible( false )
					ply.RespawnScreenOpen = false
					RunConsoleCommand( "dt_respawnfinish" )
				end
				
			end

			PlayerName = vgui.Create( "DLabel", RespawnSelect )
			PlayerName:SetFont( "DermaLarge" )
			PlayerName:SetPos( (1080-147.5-122.5)*ScaleX, (25)*ScaleY )
			PlayerName:SetSize( 245*ScaleX, 50*ScaleY )
			PlayerName:SetText( ply:Nick() ) 

			local LabelCost = vgui.Create( "DLabel", RespawnSelect )
			LabelCost:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+40)*ScaleY )
			LabelCost:SetText( "Pick Loadout to Determine Cost" )
			LabelCost:SizeToContents()

			local LabelSpeed = vgui.Create( "DLabel", RespawnSelect )
			LabelSpeed:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+60)*ScaleY )
			LabelSpeed:SetText( "Pick Loadout to Determine Speed" )
			LabelSpeed:SizeToContents()

			local function UpdateReadoutFunction()
				if ply.DakTankLoadout.ArmorCost and ply.DakTankLoadout.MainCost and ply.DakTankLoadout.SecondaryCost and ply.DakTankLoadout.SpecialCost then
					if (ply.DakTankLoadout.ArmorCost+ply.DakTankLoadout.MainCost+ply.DakTankLoadout.SecondaryCost+ply.DakTankLoadout.SpecialCost) > 10 then
						LabelCost:SetText( "Cost "..(ply.DakTankLoadout.ArmorCost+ply.DakTankLoadout.MainCost+ply.DakTankLoadout.SecondaryCost+ply.DakTankLoadout.SpecialCost) .. " - Loadout invalid" )
						LabelCost:SizeToContents()
						LabelSpeed:SetText( "Please lower cost below 10 to spawn" )
						LabelSpeed:SizeToContents()
						RespawnButton:SetVisible(false)
					else
						LabelCost:SetText( "Cost "..(ply.DakTankLoadout.ArmorCost+ply.DakTankLoadout.MainCost+ply.DakTankLoadout.SecondaryCost+ply.DakTankLoadout.SpecialCost) )
						if ply.DakTankLoadout.ArmorCost == 0 then
							LabelSpeed:SetText( "Speed 400" )
						elseif ply.DakTankLoadout.ArmorCost == 1 then
							LabelSpeed:SetText( "Speed 350" )
						elseif ply.DakTankLoadout.ArmorCost == 2 then
							LabelSpeed:SetText( "Speed 300" )
						elseif ply.DakTankLoadout.ArmorCost == 3 then
							LabelSpeed:SetText( "Speed 250" )
						elseif ply.DakTankLoadout.ArmorCost == 4 then
							LabelSpeed:SetText( "Speed 200" )
						end
						RespawnButton:SetVisible(true)
					end
				end
			end

			--MAIN GUN--
			Primary = vgui.Create( "DLabel", RespawnSelect )
			Primary:SetFont( "DermaLarge" )
			Primary:SetPos( (1080-147.5-122.5)*ScaleX, (25+75)*ScaleY )
			Primary:SetSize( 245*ScaleX, 50*ScaleY )
			Primary:SetText( "Primary Weapon" ) 

			local PrimaryMenu = vgui.Create( "DComboBox", RespawnSelect )
			PrimaryMenu:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+125)*ScaleY )
			PrimaryMenu:SetSize( 220*ScaleX, 20*ScaleY )
			PrimaryMenu:SetValue( "Main Gun" )
			PrimaryMenu:AddChoice( "AK-47" )
			PrimaryMenu:AddChoice( "Steyr AUG" )
			PrimaryMenu:AddChoice( "H&K G3SG/1" )
			PrimaryMenu:AddChoice( "IMI Galil" )
			PrimaryMenu:AddChoice( "Colt M4A1" )
			PrimaryMenu:AddChoice( "SIG SG 552" )
			PrimaryMenu:AddChoice( "MAC-10" )
			PrimaryMenu:AddChoice( "H&K MP5A3" )
			PrimaryMenu:AddChoice( "FN P90" )
			PrimaryMenu:AddChoice( "Steyr TMP" )
			PrimaryMenu:AddChoice( "H&K UMP" )

			--Default to M4A1, which is "5"
			if tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 0 then
				RunConsoleCommand( "DakTankLoadoutPrimary", "5" )
			else
				PrimaryMenu:ChooseOptionID( tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) )
			end

			if ply.DakTankLoadout==nil then ply.DakTankLoadout={} end
			PrimaryMenu.OnSelect = function( self, index, value )
				ply.DakTankLoadout.MainGun = index
				if value == "AK-47" then
					self.Label2desc:SetText("68.6 Damage, 600 RPM, 14.55 Pen, 3 Cost")
					ply.DakTankLoadout.MainCost = 3
					RunConsoleCommand( "DakTankLoadoutPrimary", "1" )
				elseif value == "Steyr AUG" then
					self.Label2desc:SetText("48.9 Damage, 750 RPM, 14.38 Pen, 2 Cost")
					ply.DakTankLoadout.MainCost = 2
					RunConsoleCommand( "DakTankLoadoutPrimary", "2" )
				elseif value == "H&K G3SG/1" then
					self.Label2desc:SetText("85.6 Damage, 600 RPM, 16.26 Pen, 4 Cost")
					ply.DakTankLoadout.MainCost = 4
					RunConsoleCommand( "DakTankLoadoutPrimary", "3" )
				elseif value == "IMI Galil" then
					self.Label2desc:SetText("46.9 Damage, 750 RPM, 14.09 Pen, 2 Cost")
					ply.DakTankLoadout.MainCost = 2
					RunConsoleCommand( "DakTankLoadoutPrimary", "4" )
				elseif value == "Colt M4A1" then
					self.Label2desc:SetText("42.6 Damage, 952 RPM, 13.42 Pen, 2 Cost")
					ply.DakTankLoadout.MainCost = 2
					RunConsoleCommand( "DakTankLoadoutPrimary", "5" )
				elseif value == "SIG SG 552" then
					self.Label2desc:SetText("27.3 Damage, 698 RPM, 10.75 Pen, 1 Cost")
					ply.DakTankLoadout.MainCost = 1
					RunConsoleCommand( "DakTankLoadoutPrimary", "6" )
				elseif value == "MAC-10" then
					self.Label2desc:SetText("35.4 Damage, 1091 RPM, 8.54 Pen, 1 Cost")
					ply.DakTankLoadout.MainCost = 1
					RunConsoleCommand( "DakTankLoadoutPrimary", "7" )
				elseif value == "H&K MP5A3" then
					self.Label2desc:SetText("35.3 Damage, 800 RPM, 9.6 Pen, 1 Cost")
					ply.DakTankLoadout.MainCost = 1
					RunConsoleCommand( "DakTankLoadoutPrimary", "8" )
				elseif value == "FN P90" then
					self.Label2desc:SetText("28.7 Damage, 909 RPM, 10.9 Pen, 1 Cost")
					ply.DakTankLoadout.MainCost = 1
					RunConsoleCommand( "DakTankLoadoutPrimary", "9" )
				elseif value == "Steyr TMP" then
					self.Label2desc:SetText("35.3 Damage, 800 RPM, 9.6 Pen, 1 Cost")
					ply.DakTankLoadout.MainCost = 1
					RunConsoleCommand( "DakTankLoadoutPrimary", "10" )
				elseif value == "H&K UMP" then
					self.Label2desc:SetText("36.7 Damage, 600 RPM, 8.69 Pen, 1 Cost")
					ply.DakTankLoadout.MainCost = 1
					RunConsoleCommand( "DakTankLoadoutPrimary", "11" )
				end
				UpdateReadoutFunction()
			end

			PrimaryMenu.Label2desc = vgui.Create( "DLabel", RespawnSelect )
			PrimaryMenu.Label2desc:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+150)*ScaleY )
			PrimaryMenu.Label2desc:SetText( "Description" )
			PrimaryMenu.Label2desc:SetSize(220*ScaleX, 30*ScaleY)
			PrimaryMenu.Label2desc:SetWrap( true )

			if tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 1 then
				PrimaryMenu.Label2desc:SetText("68.6 Damage, 600 RPM, 14.55 Pen, 3 Cost")
				ply.DakTankLoadout.MainCost = 3
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 2 then
				PrimaryMenu.Label2desc:SetText("48.9 Damage, 750 RPM, 14.38 Pen, 2 Cost")
				ply.DakTankLoadout.MainCost = 2
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 3 then
				PrimaryMenu.Label2desc:SetText("85.6 Damage, 600 RPM, 16.26 Pen, 4 Cost")
				ply.DakTankLoadout.MainCost = 4
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 4 then
				PrimaryMenu.Label2desc:SetText("46.9 Damage, 750 RPM, 14.09 Pen, 2 Cost")
				ply.DakTankLoadout.MainCost = 2
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 5 then
				PrimaryMenu.Label2desc:SetText("42.6 Damage, 952 RPM, 13.42 Pen, 2 Cost")
				ply.DakTankLoadout.MainCost = 2
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 6 then
				PrimaryMenu.Label2desc:SetText("27.3 Damage, 698 RPM, 10.75 Pen, 1 Cost")
				ply.DakTankLoadout.MainCost = 1
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 7 then
				PrimaryMenu.Label2desc:SetText("35.4 Damage, 1091 RPM, 8.54 Pen, 1 Cost")
				ply.DakTankLoadout.MainCost = 1
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 8 then
				PrimaryMenu.Label2desc:SetText("35.3 Damage, 800 RPM, 9.6 Pen, 1 Cost")
				ply.DakTankLoadout.MainCost = 1
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 9 then
				PrimaryMenu.Label2desc:SetText("28.7 Damage, 909 RPM, 10.9 Pen, 1 Cost")
				ply.DakTankLoadout.MainCost = 1
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 10 then
				PrimaryMenu.Label2desc:SetText("35.3 Damage, 800 RPM, 9.6 Pen, 1 Cost")
				ply.DakTankLoadout.MainCost = 1
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPrimary" )) == 11 then
				PrimaryMenu.Label2desc:SetText("36.7 Damage, 600 RPM, 8.69 Pen, 1 Cost")
				ply.DakTankLoadout.MainCost = 1
			end

			--SECONDARY GUN--
			Secondary = vgui.Create( "DLabel", RespawnSelect )
			Secondary:SetFont( "DermaLarge" )
			Secondary:SetPos( (1080-147.5-122.5)*ScaleX, (25+175)*ScaleY )
			Secondary:SetSize( 245*ScaleX, 50*ScaleY )
			Secondary:SetText( "Secondary Weapon" ) 

			local SecondaryMenu = vgui.Create( "DComboBox", RespawnSelect )
			SecondaryMenu:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+225)*ScaleY )
			SecondaryMenu:SetSize( 220*ScaleX, 20*ScaleY )
			SecondaryMenu:SetValue( "Secondary Gun" )
			SecondaryMenu:AddChoice( "IMI Desert Eagle" )
			SecondaryMenu:AddChoice( "FN Five-seveN" )
			SecondaryMenu:AddChoice( "Glock-18" )
			SecondaryMenu:AddChoice( "SIG P228" )
			SecondaryMenu:AddChoice( "H&K USP" )

			--Default to USP, which is "5"
			if tonumber(ply:GetInfo( "DakTankLoadoutSecondary" )) == 0 then
				RunConsoleCommand( "DakTankLoadoutSecondary", "5" )
			else
				SecondaryMenu:ChooseOptionID( tonumber(ply:GetInfo( "DakTankLoadoutSecondary" )) )
			end

			if ply.DakTankLoadout==nil then ply.DakTankLoadout={} end
			SecondaryMenu.OnSelect = function( self, index, value )
				ply.DakTankLoadout.SecondaryCost = index
				if value == "IMI Desert Eagle" then
					self.Label3desc:SetText("136.8 Damage, 600 RPM, 15.92 Pen, 3 Cost")
					ply.DakTankLoadout.SecondaryCost = 3
					RunConsoleCommand( "DakTankLoadoutSecondary", "1" )
				elseif value == "FN Five-seveN" then
					self.Label3desc:SetText("32.5 Damage, 600 RPM, 11.58 Pen, 2 Cost")
					ply.DakTankLoadout.SecondaryCost = 2
					RunConsoleCommand( "DakTankLoadoutSecondary", "2" )
				elseif value == "Glock-18" then
					self.Label3desc:SetText("31 Damage, 1200 RPM, 9 Pen, 2 Cost")
					ply.DakTankLoadout.SecondaryCost = 2
					RunConsoleCommand( "DakTankLoadoutSecondary", "3" )
				elseif value == "SIG P228" then
					self.Label3desc:SetText("35.3 Damage, 600 RPM, 9.6 Pen, 1 Cost")
					ply.DakTankLoadout.SecondaryCost = 1
					RunConsoleCommand( "DakTankLoadoutSecondary", "4" )
				elseif value == "H&K USP" then
					self.Label3desc:SetText("36.7 Damage, 600 RPM, 8.69 Pen, 1 Cost")
					ply.DakTankLoadout.SecondaryCost = 1
					RunConsoleCommand( "DakTankLoadoutSecondary", "5" )
				end
				UpdateReadoutFunction()
			end

			SecondaryMenu.Label3desc = vgui.Create( "DLabel", RespawnSelect )
			SecondaryMenu.Label3desc:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+250)*ScaleY )
			SecondaryMenu.Label3desc:SetText( "Description" )
			SecondaryMenu.Label3desc:SetSize(220*ScaleX, 30*ScaleY)
			SecondaryMenu.Label3desc:SetWrap( true )

			if tonumber(ply:GetInfo( "DakTankLoadoutSecondary" )) == 1 then
				SecondaryMenu.Label3desc:SetText("136.8 Damage, 600 RPM, 15.92 Pen, 3 Cost")
				ply.DakTankLoadout.SecondaryCost = 3
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSecondary" )) == 2 then
				SecondaryMenu.Label3desc:SetText("32.5 Damage, 600 RPM, 11.58 Pen, 2 Cost")
				ply.DakTankLoadout.SecondaryCost = 2
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSecondary" )) == 3 then
				SecondaryMenu.Label3desc:SetText("31 Damage, 1200 RPM, 9 Pen, 2 Cost")
				ply.DakTankLoadout.SecondaryCost = 2
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSecondary" )) == 4 then
				SecondaryMenu.Label3desc:SetText("35.3 Damage, 600 RPM, 9.6 Pen, 1 Cost")
				ply.DakTankLoadout.SecondaryCost = 1
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSecondary" )) == 5 then
				SecondaryMenu.Label3desc:SetText("36.7 Damage, 600 RPM, 8.69 Pen, 1 Cost")
				ply.DakTankLoadout.SecondaryCost = 1
			end

			--Special GUN--
			Special = vgui.Create( "DLabel", RespawnSelect )
			Special:SetFont( "DermaLarge" )
			Special:SetPos( (1080-147.5-122.5)*ScaleX, (25+275)*ScaleY )
			Special:SetSize( 245*ScaleX, 50*ScaleY )
			Special:SetText( "Special Weapon" ) 

			local SpecialMenu = vgui.Create( "DComboBox", RespawnSelect )
			
			SpecialMenu:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+325)*ScaleY )
			SpecialMenu:SetSize( 220*ScaleX, 20*ScaleY )
			SpecialMenu:SetValue( "Special" )
			if Era == "Cold War" then
				SpecialMenu:AddChoice( "AT4" )
				SpecialMenu:AddChoice( "M47 Dragon" )
			end
			SpecialMenu:AddChoice( "M249 SAW" )
			SpecialMenu:AddChoice( "Semiauto Shotgun" )
			SpecialMenu:AddChoice( "Medkit" )
			SpecialMenu:AddChoice( "Repair Tool" )
			SpecialMenu:AddChoice( "PTRS-41" )
			SpecialMenu:AddChoice( "Steyr SSG 08" )
			if Era == "WWII" then
				SpecialMenu:AddChoice( "Bazooka" )
				SpecialMenu:AddChoice( "Panzerschreck" )
			end
			if Era == "Modern" then
				SpecialMenu:AddChoice( "RPG-28" )
				SpecialMenu:AddChoice( "FGM-148 Javelin" )
			end
			

			--Default to PTRS, which is "6"
			if tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 0 or tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) > 8 then
				ply.DakTankLoadout.SpecialCost = 4
				RunConsoleCommand( "DakTankLoadoutSpecial", "6" )
			else
				SpecialMenu:ChooseOptionID( tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) )
			end

			if ply.DakTankLoadout==nil then ply.DakTankLoadout={} end
			SpecialMenu.OnSelect = function( self, index, value )
				ply.DakTankLoadout.SpecialCost = index
				if value == "AT4" then
					self.Label4desc:SetText("30 Damage (vehicular), 30 RPM, 420 Pen, 8 Cost")
					ply.DakTankLoadout.SpecialCost = 8
					RunConsoleCommand( "DakTankLoadoutSpecial", "1" )
				elseif value == "M47 Dragon" then
					self.Label4desc:SetText("17 Damage (vehicular), 30 RPM, 300 Pen, 7 Cost")
					ply.DakTankLoadout.SpecialCost = 7
					RunConsoleCommand( "DakTankLoadoutSpecial", "2" )
				elseif value == "M249 SAW" then
					self.Label4desc:SetText("43.5 Damage, 857 RPM, 13.56 Pen, 5 Cost")
					ply.DakTankLoadout.SpecialCost = 5
					RunConsoleCommand( "DakTankLoadoutSpecial", "3" )
				elseif value == "Semiauto Shotgun" then
					self.Label4desc:SetText("210 Damage, 300 RPM, 5.56 Pen, 3 Cost")
					ply.DakTankLoadout.SpecialCost = 3
					RunConsoleCommand( "DakTankLoadoutSpecial", "4" )
				elseif value == "PTRS-41" then
					self.Label4desc:SetText("2 Damage (vehicular), 60 RPM, 39.17 Pen, 4 Cost")
					ply.DakTankLoadout.SpecialCost = 4
					RunConsoleCommand( "DakTankLoadoutSpecial", "6" )
				elseif value == "Steyr SSG 08" then
					self.Label4desc:SetText("128 Damage, 60 RPM, 19.65 Pen, 3 Cost")
					ply.DakTankLoadout.SpecialCost = 3
					RunConsoleCommand( "DakTankLoadoutSpecial", "7" )
				elseif value == "Medkit" then
					self.Label4desc:SetText("Heal yourself and allied players, 1 Cost")
					ply.DakTankLoadout.SpecialCost = 1
					RunConsoleCommand( "DakTankLoadoutSpecial", "5" )
				elseif value == "Repair Tool" then
					self.Label4desc:SetText("Repair vehicles and emplacements, 3 Cost")
					ply.DakTankLoadout.SpecialCost = 3
					RunConsoleCommand( "DakTankLoadoutSpecial", "8" )
				elseif value == "Bazooka" then
					self.Label4desc:SetText("1 Damage (vehicular), 30 RPM, 102 Pen, 6 Cost")
					ply.DakTankLoadout.SpecialCost = 6
					RunConsoleCommand( "DakTankLoadoutSpecial", "1" )
				elseif value == "Panzerschreck" then
					self.Label4desc:SetText("5 Damage (vehicular), 30 RPM, 230 Pen, 8 Cost")
					ply.DakTankLoadout.SpecialCost = 8
					RunConsoleCommand( "DakTankLoadoutSpecial", "2" )
				elseif value == "RPG-28" then
					self.Label4desc:SetText("74 Damage (vehicular), 30 RPM, 900 Pen, 8 Cost")
					ply.DakTankLoadout.SpecialCost = 8
					RunConsoleCommand( "DakTankLoadoutSpecial", "1" )
				elseif value == "FGM-148 Javelin" then
					self.Label4desc:SetText("13 Damage (vehicular), 30 RPM, 750 Pen, 7 Cost")
					ply.DakTankLoadout.SpecialCost = 7
					RunConsoleCommand( "DakTankLoadoutSpecial", "2" )
				end
				UpdateReadoutFunction()
			end

			SpecialMenu.Label4desc = vgui.Create( "DLabel", RespawnSelect )
			SpecialMenu.Label4desc:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+350)*ScaleY )
			SpecialMenu.Label4desc:SetText( "Description" )
			SpecialMenu.Label4desc:SetSize(220*ScaleX, 30*ScaleY)
			SpecialMenu.Label4desc:SetWrap( true )

			if tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 1 and Era == "Cold War" then
				SpecialMenu.Label4desc:SetText("30 Damage (vehicular), 30 RPM, 420 Pen, 8 Cost")
				ply.DakTankLoadout.SpecialCost = 8
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 2 and Era == "Cold War" then
				SpecialMenu.Label4desc:SetText("17 Damage (vehicular), 30 RPM, 300 Pen, 7 Cost")
				ply.DakTankLoadout.SpecialCost = 7
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 3 then
				SpecialMenu.Label4desc:SetText("43.5 Damage, 857 RPM, 13.56 Pen, 5 Cost")
				ply.DakTankLoadout.SpecialCost = 5
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 4 then
				SpecialMenu.Label4desc:SetText("210 Damage, 300 RPM, 5.56 Pen, 3 Cost")
				ply.DakTankLoadout.SpecialCost = 3
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 6 then
				SpecialMenu.Label4desc:SetText("2 Damage (vehicular), 60 RPM, 39.17 Pen, 4 Cost")
				ply.DakTankLoadout.SpecialCost = 4
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 1 and Era == "WWII" then
				SpecialMenu.Label4desc:SetText("1 Damage (vehicular), 30 RPM, 102 Pen, 6 Cost")
				ply.DakTankLoadout.SpecialCost = 6
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 2 and Era == "WWII" then
				SpecialMenu.Label4desc:SetText("5 Damage (vehicular), 30 RPM, 230 Pen, 8 Cost")
				ply.DakTankLoadout.SpecialCost = 8
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 1 and Era == "Modern" then
				SpecialMenu.Label4desc:SetText("74 Damage (vehicular), 30 RPM, 900 Pen, 8 Cost")
				ply.DakTankLoadout.SpecialCost = 8
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 2 and Era == "Modern" then
				SpecialMenu.Label4desc:SetText("13 Damage (vehicular), 30 RPM, 750 Pen, 7 Cost")
				ply.DakTankLoadout.SpecialCost = 7
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 7 then
				SpecialMenu.Label4desc:SetText("128 Damage, 60 RPM, 19.65 Pen, 3 Cost")
				ply.DakTankLoadout.SpecialCost = 3
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 5 then
				SpecialMenu.Label4desc:SetText("Heal yourself and allied players, 1 Cost")
				ply.DakTankLoadout.SpecialCost = 1
			elseif tonumber(ply:GetInfo( "DakTankLoadoutSpecial" )) == 8 then
				SpecialMenu.Label4desc:SetText("Repair vehicles and emplacements, 3 Cost")
				ply.DakTankLoadout.SpecialCost = 3
			end

			--ARMOR--
			Armor = vgui.Create( "DLabel", RespawnSelect )
			Armor:SetFont( "DermaLarge" )
			Armor:SetPos( (1080-147.5-122.5)*ScaleX, (25+375)*ScaleY )
			Armor:SetSize( 245*ScaleX, 50*ScaleY )
			Armor:SetText( "Armor" ) 

			local ArmorMenu = vgui.Create( "DComboBox", RespawnSelect )
			ArmorMenu:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+425)*ScaleY )
			ArmorMenu:SetSize( 220*ScaleX, 20*ScaleY )
			ArmorMenu:SetValue( "Armor" )
			ArmorMenu:AddChoice( "1 - None" )
			ArmorMenu:AddChoice( "2 - Light" )
			ArmorMenu:AddChoice( "3 - Medium" )
			ArmorMenu:AddChoice( "4 - Heavy" )
			ArmorMenu:AddChoice( "5 - Super Heavy" )

			--Default to Medium, which is "3"
			if tonumber(ply:GetInfo( "DakTankLoadoutArmor" )) == 0 then
				RunConsoleCommand( "DakTankLoadoutArmor", "3" )
			else
				ArmorMenu:ChooseOptionID( tonumber(ply:GetInfo( "DakTankLoadoutArmor" )) )
			end

			if ply.DakTankLoadout==nil then ply.DakTankLoadout={} end
			ArmorMenu.OnSelect = function( self, index, value )
				RunConsoleCommand( "DakTankLoadoutArmor", tostring(index) )
				ply.DakTankLoadout.ArmorType = index
				if index == 1 then
					self.Label1desc:SetText("Damage reduced by 0, 0% damage reduction, 400 speed, 0 Cost")
					ply.DakTankLoadout.ArmorCost = 0
				elseif index == 2 then
					self.Label1desc:SetText("Damage reduced by 5, 10% damage reduction, 350 speed, 1 Cost")
					ply.DakTankLoadout.ArmorCost = 1
				elseif index == 3 then
					self.Label1desc:SetText("Damage reduced by 10, 20% damage reduction, 300 speed, 2 Cost")
					ply.DakTankLoadout.ArmorCost = 2
				elseif index == 4 then
					self.Label1desc:SetText("Damage reduced by 15, 30% damage reduction, 250 speed, 3 Cost")
					ply.DakTankLoadout.ArmorCost = 3
				elseif index == 5 then
					self.Label1desc:SetText("Damage reduced by 20, 40% damage reduction, 200 speed, 4 Cost")
					ply.DakTankLoadout.ArmorCost = 4
				end
				UpdateReadoutFunction()
			end

			ArmorMenu.Label1desc = vgui.Create( "DLabel", RespawnSelect )
			ArmorMenu.Label1desc:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+450)*ScaleY )
			ArmorMenu.Label1desc:SetText( "Description" )
			ArmorMenu.Label1desc:SetSize(220*ScaleX, 30*ScaleY)
			ArmorMenu.Label1desc:SetWrap( true )

			if tonumber(ply:GetInfo( "DakTankLoadoutArmor" )) == 1 then
				ArmorMenu.Label1desc:SetText("Damage reduced by 0, 0% damage reduction, 400 speed, 0 Cost")
				ply.DakTankLoadout.ArmorCost = 0
			elseif tonumber(ply:GetInfo( "DakTankLoadoutArmor" )) == 2 then
				ArmorMenu.Label1desc:SetText("Damage reduced by 5, 10% damage reduction, 350 speed, 1 Cost")
				ply.DakTankLoadout.ArmorCost = 1
			elseif tonumber(ply:GetInfo( "DakTankLoadoutArmor" )) == 3 then
				ArmorMenu.Label1desc:SetText("Damage reduced by 10, 20% damage reduction, 300 speed, 2 Cost")
				ply.DakTankLoadout.ArmorCost = 2
			elseif tonumber(ply:GetInfo( "DakTankLoadoutArmor" )) == 4 then
				ArmorMenu.Label1desc:SetText("Damage reduced by 15, 30% damage reduction, 250 speed, 3 Cost")
				ply.DakTankLoadout.ArmorCost = 3
			elseif tonumber(ply:GetInfo( "DakTankLoadoutArmor" )) == 5 then
				ArmorMenu.Label1desc:SetText("Damage reduced by 20, 40% damage reduction, 200 speed, 4 Cost")
				ply.DakTankLoadout.ArmorCost = 4
			end

			--PERKS--
			Perk = vgui.Create( "DLabel", RespawnSelect )
			Perk:SetFont( "DermaLarge" )
			Perk:SetPos( (1080-147.5-122.5)*ScaleX, (25+475)*ScaleY )
			Perk:SetSize( 245*ScaleX, 50*ScaleY )
			Perk:SetText( "Perk" ) 

			local PerkMenu = vgui.Create( "DComboBox", RespawnSelect )
			PerkMenu:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+525)*ScaleY )
			PerkMenu:SetSize( 220*ScaleX, 20*ScaleY )
			PerkMenu:SetValue( "Perk" )
			PerkMenu:AddChoice( "Extra Ammo" )
			PerkMenu:AddChoice( "Toughness" )
			PerkMenu:AddChoice( "Regeneration" )
			PerkMenu:AddChoice( "Bloodlust" )
			PerkMenu:AddChoice( "Steady Aim" )

			--Default to Regeneration, which is "3"
			if tonumber(ply:GetInfo( "DakTankLoadoutPerk" )) == 0 then
				RunConsoleCommand( "DakTankLoadoutPerk", "3" )
			else
				PerkMenu:ChooseOptionID( tonumber(ply:GetInfo( "DakTankLoadoutPerk" )) )
			end

			if ply.DakTankLoadout==nil then ply.DakTankLoadout={} end
			PerkMenu.OnSelect = function( self, index, value )
				RunConsoleCommand( "DakTankLoadoutPerk", tostring(index) )
				ply.DakTankLoadout.PerkType = index
				if index == 1 then
					self.Label5desc:SetText("Doubled ammo reserves, go nuts")
					ply.DakTankLoadout.PerkCost = 0
				elseif index == 2 then
					self.Label5desc:SetText("250 max health")
					ply.DakTankLoadout.PerkCost = 0
				elseif index == 3 then
					self.Label5desc:SetText("Regenerate 5hp per second")
					ply.DakTankLoadout.PerkCost = 0
				elseif index == 4 then
					self.Label5desc:SetText("Gain full hp and extra max hp on kill")
					ply.DakTankLoadout.PerkCost = 0
				elseif index == 5 then
					self.Label5desc:SetText("Recoil quartered")
					ply.DakTankLoadout.PerkCost = 0
				end
				UpdateReadoutFunction()
			end

			PerkMenu.Label5desc = vgui.Create( "DLabel", RespawnSelect )
			PerkMenu.Label5desc:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+550)*ScaleY )
			PerkMenu.Label5desc:SetText( "Description" )
			PerkMenu.Label5desc:SetSize(220*ScaleX, 30*ScaleY)
			PerkMenu.Label5desc:SetWrap( true )

			if tonumber(ply:GetInfo( "DakTankLoadoutPerk" )) == 1 then
				PerkMenu.Label5desc:SetText("Doubled ammo reserves, go nuts")
				ply.DakTankLoadout.PerkCost = 0
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPerk" )) == 2 then
				PerkMenu.Label5desc:SetText("250 max health")
				ply.DakTankLoadout.PerkCost = 0
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPerk" )) == 3 then
				PerkMenu.Label5desc:SetText("Regenerate 5hp per second")
				ply.DakTankLoadout.PerkCost = 0
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPerk" )) == 4 then
				PerkMenu.Label5desc:SetText("Gain full hp and extra max hp on kill")
				ply.DakTankLoadout.PerkCost = 0
			elseif tonumber(ply:GetInfo( "DakTankLoadoutPerk" )) == 5 then
				PerkMenu.Label5desc:SetText("Recoil quartered")
				ply.DakTankLoadout.PerkCost = 0
			end

			--SPAWN--
			Spawn = vgui.Create( "DLabel", RespawnSelect )
			Spawn:SetFont( "DermaLarge" )
			Spawn:SetPos( (1080-147.5-122.5)*ScaleX, (25+575)*ScaleY )
			Spawn:SetSize( 245*ScaleX, 50*ScaleY )
			Spawn:SetText( "Spawn" ) 

			--Set Values
			if (ply.DakTankLoadout.ArmorCost+ply.DakTankLoadout.MainCost+ply.DakTankLoadout.SecondaryCost+ply.DakTankLoadout.SpecialCost) > 10 then
				LabelCost:SetText( "Cost "..(ply.DakTankLoadout.ArmorCost+ply.DakTankLoadout.MainCost+ply.DakTankLoadout.SecondaryCost+ply.DakTankLoadout.SpecialCost) .. " - Loadout invalid" )
				LabelCost:SizeToContents()
				LabelSpeed:SetText( "Please lower cost below 10 to spawn" )
				LabelSpeed:SizeToContents()
				RespawnButton:SetVisible(false)
			else
				LabelCost:SetText( "Cost "..(ply.DakTankLoadout.ArmorCost+ply.DakTankLoadout.MainCost+ply.DakTankLoadout.SecondaryCost+ply.DakTankLoadout.SpecialCost) )
				if ply.DakTankLoadout.ArmorCost == 0 then
					LabelSpeed:SetText( "Speed 400" )
				elseif ply.DakTankLoadout.ArmorCost == 1 then
					LabelSpeed:SetText( "Speed 350" )
				elseif ply.DakTankLoadout.ArmorCost == 2 then
					LabelSpeed:SetText( "Speed 300" )
				elseif ply.DakTankLoadout.ArmorCost == 3 then
					LabelSpeed:SetText( "Speed 250" )
				elseif ply.DakTankLoadout.ArmorCost == 4 then
					LabelSpeed:SetText( "Speed 200" )
				end
				RespawnButton:SetVisible(true)
			end
		else
			ply.RespawnScreenOpen = true
			RespawnSelect:SetVisible( true )
		end

		if not(LocalPlayer():Team()==1 or LocalPlayer():Team()==2) then RespawnSelect:SetVisible( false ) end

		if GetConVar("DakTankLoadoutSpawn")==nil then RespawnButton:SetVisible(false) else RespawnButton:SetVisible(true) end
		local SpawnMenu = vgui.Create( "DComboBox", RespawnSelect )
		SpawnMenu:SetPos( (1080-147.5-122.5+25)*ScaleX, (25+625)*ScaleY )
		SpawnMenu:SetSize( 220*ScaleX, 20*ScaleY )
		SpawnMenu:SetValue( "Spawn" )
		local AllowedCaps = {}
		for i=1, #CapsInfo do 
			if CapsInfo[i][2] == LocalPlayer():Team() then
				SpawnMenu:AddChoice( tostring(CapsInfo[i][1]) )
				AllowedCaps[#AllowedCaps+1] = i
			end
		end
		--Default to Regeneration, which is "3"
		if tonumber(ply:GetInfo( "DakTankLoadoutSpawn" )) == 0 then
			RunConsoleCommand( "DakTankLoadoutSpawn", tostring(CapsInfo[AllowedCaps[math.random(1,#AllowedCaps)]][1]) )
		end

		SpawnMenu.OnSelect = function( self, index, value )
			RunConsoleCommand( "DakTankLoadoutSpawn", tostring(value) )
		end
	end
	concommand.Add( "dt_respawn", set_respawn )
end--Respawning End

local LastSpawnMenuReset = 0
do--Draw Map Markers Start
	hook.Add( "PostDrawTranslucentRenderables", "respawnscreendraws", function()
		if LocalPlayer().RespawnScreenOpen == true or LocalPlayer().MapUp == true then
			render.SetColorMaterial()
			for i=1, #CapsInfo do
				if CapsInfo[i][2] == 1 then
					render.DrawSphere( CapsInfo[i][3], 1000, 30, 30, Color( 255, 0, 0, 150 ) )
				elseif CapsInfo[i][2] == 2 then
					render.DrawSphere( CapsInfo[i][3], 1000, 30, 30, Color( 0, 0, 255, 150 ) )
				else
					render.DrawSphere( CapsInfo[i][3], 1000, 30, 30, Color( 255, 255, 255, 150 ) )
				end
				if CapsInfo[i][1] < 10 then
					local MDL = ClientsideModel( "models/sprops/misc/alphanum/alphanum_"..(CapsInfo[i][1])..".mdl" )
					MDL:SetPos(CapsInfo[i][3]+Vector(0,0,1000))
					MDL:SetAngles(Angle(0,180,90))
					MDL:SetModelScale( 125, 0 )
					MDL:SetColor(Color(150,150,150,255))
					MDL:Remove()
				else
					local MDL1 = ClientsideModel( "models/sprops/misc/alphanum/alphanum_"..(tonumber(tostring(CapsInfo[i][1])[1]))..".mdl" )
					MDL1:SetPos(CapsInfo[i][3]+Vector(-500,0,1000))
					MDL1:SetAngles(Angle(0,180,90))
					MDL1:SetModelScale( 125, 0 )
					MDL1:SetColor(Color(150,150,150,255))
					MDL1:Remove()
					local MDL2 = ClientsideModel( "models/sprops/misc/alphanum/alphanum_"..(tonumber(tostring(CapsInfo[i][1])[2]))..".mdl" )
					MDL2:SetPos(CapsInfo[i][3]+Vector(500,0,1000))
					MDL2:SetAngles(Angle(0,180,90))
					MDL2:SetModelScale( 125, 0 )
					MDL2:SetColor(Color(150,150,150,255))
					MDL2:Remove()
				end
			end
			local MDL = ClientsideModel( "models/sprops/misc/alphanum/alphanum_arrow_a.mdl" )
			MDL:SetPos(LocalPlayer():GetPos() + Vector(0,0,1000))
			MDL:SetAngles(Angle(0,LocalPlayer():GetAngles().yaw+90,90))
			MDL:SetModelScale( 50, 0 )
			MDL:Remove()
			render.DrawSphere( LocalPlayer():GetPos(), 500, 30, 30, Color( 0, 0, 0, 150 ) )
			--[[
			for i=1, #RedBotPos do
				render.DrawSphere( RedBotPos[i], 125, 30, 30, Color( 255, 0, 0, 150 ) )
			end
			for i=1, #BlueBotPos do
				render.DrawSphere( BlueBotPos[i], 125, 30, 30, Color( 0, 0, 255, 150 ) )
			end
			]]--
		end
	end )
end--Draw Map Markers End

do--Minimap Start
	local LastPress = 0
	hook.Add( "PlayerButtonDown", "DakTankMapScreen", function(ply, button)
		if button == 23 then
			if CurTime() > LastPress+0.1 then 
				LastPress = CurTime()
				if ply.MapUp == false or ply.MapUp == nil then
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

					ply.MapCenter = (righttrace.HitPos+lefttrace.HitPos+fronttrace.HitPos+backtrace.HitPos)*0.25
				 	ply.MapCenter.z = LocalPlayer():GetPos().z+2500--uptrace.HitPos.z-25

					PopupMap = vgui.Create( "DPanel")
					PopupMap:Center()

					function PopupMap:Paint( w, h )
						local CamData = {}
						CamData.angles = Angle(90,90,0)
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
						CamData.znear = -100000
						CamData.zfar = 100000

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

do--Gamemode Restrictions Start
	local function removeOldTabls()
	     for k, v in pairs( g_SpawnMenu.CreateMenu.Items ) do
	        if (v.Tab:GetText() == language.GetPhrase("spawnmenu.category.npcs") or 
	            v.Tab:GetText() == language.GetPhrase("spawnmenu.category.entities") or 
	            v.Tab:GetText() == language.GetPhrase("spawnmenu.category.weapons") or 
	            v.Tab:GetText() == language.GetPhrase("spawnmenu.category.vehicles") or 
	            v.Tab:GetText() == language.GetPhrase("spawnmenu.category.postprocess") or
	            v.Tab:GetText() == language.GetPhrase("spawnmenu.category.spawnlists") or
	            v.Tab:GetText() == language.GetPhrase("spawnmenu.category.dupes") or
	            v.Tab:GetText() == language.GetPhrase("spawnmenu.category.saves")) then
	            g_SpawnMenu.CreateMenu:CloseTab( v.Tab, true )
	            removeOldTabls()
	        end
	    end
	end
	hook.Add("SpawnMenuOpen", "DTblockmenutabs", removeOldTabls)
end--Gamemode Restrictions End