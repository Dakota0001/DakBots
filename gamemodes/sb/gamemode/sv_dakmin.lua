
dakmin = dakmin or util.JSONToTable(file.Read("dakmin.txt", "DATA") or "")
        or {
            users = {},
            bans  = {}
        }

function dakmin.save()
    file.Write("dakmin.txt", util.TableToJSON({users = dakmin.users, bans = dakmin.bans}))
end

--

local function findPlayer(str)
    str = string.lower(str)
    -- exact match
    for _, ply in pairs(player.GetAll()) do
        if string.lower(ply:Nick()) == str then
            print(ply)
            return ply
        end
    end

    -- not exact match
    for _, ply in pairs(player.GetAll()) do
        if string.find(string.lower(ply:Nick()), str) then
            print(ply)
            return ply
        end
    end
end

local function timeConvert(str)
    local d = string.lower(string.Right(str))

    if d == "d" then
        string.TrimRight(str, d)

        return tonumber(str) * 86400
    elseif d == "w" then
        string.TrimRight(str, d)

        return tonumber(str) * 604800
    elseif d == "m" then
        string.TrimRight(str, d)

        return tonumber(str) * 2628000
    elseif d == "y" then
        string.TrimRight(str, d)

        return tonumber(str) * 31540000
    end

    return tonumber(str)
end

local commands = {
    kick = function(caller, name, reason)
        if IsValid(caller) and not caller:IsAdmin() then return end

        print(caller, name, reason)
        local target = findPlayer(name)

        if IsValid(target) then
            target:Kick(reason)

            MsgAll(caller, "kicked", target:Nick(), reason)
        end
    end,
    ban = function(caller, name, time, reason)
        local target = findPlayer(name)

        if IsValid(target) then
            dakmin.bans[target:SteamID()] = {
                time = os.time() + (time and timeConvert(time) or math.huge),
                reason = reason
            }

            dakmin.save()

            MsgAll(caller, "banned", target:Nick(), time, reason)
        end
    end,
    banid = function(caller, steamid, time, reason)
        if IsValid(caller) and not caller:IsSuperAdmin() then return end

        dakmin.bans[steamid] = {
            time   = os.time() + (time and timeConvert(time) or math.huge),
            reason = reason
        }

        dakmin.save()

        MsgAll(caller, "banned", steamid, time, reason)
    end,
    unban = function(caller, steamid)
        if IsValid(caller) and not caller:IsSuperAdmin() then return end

        if dakmin.bans[steamid] then
            dakmin.bans[steamid] = nil
            dakmin.save()

            MsgAll(caller or "server", "unbanned", steamid)
        end
    end,
    slay = function(caller, name)
        if IsValid(caller) and not caller:IsAdmin() then return end

        local target = findPlayer(name)

        if IsValid(target) then
            target:Kill()

            MsgAll(caller, "slayed", target:Nick())
        end
    end,
    adduser = function(caller, name, rank)
        local target = findPlayer(name)

        rank = string.lower(rank)

        if IsValid(target) and rank == "admin" or rank == "superadmin" then
            dakmin.users[target:SteamID()] = rank
            dakmin.save()

            target:SetUserGroup(rank)
        end
    end,
    removeuser = function(caller, name)
        local target = findPlayer(name)

        if IsValid(target) then
            dakmin.users[target:SteamID()] = nil
            dakmin.save()
        end
    end
}

concommand.Add("dakmin", function(ply, cmd, args)
    print(ply, cmd, unpack(args))
    if commands[args[1]] then
        local c = args[1]
        table.remove(args, 1)
        commands[c](ply, unpack(args))
    end
end)


hook.Add("PlayerSpawn", "updaterank", function(ply)
    if dakmin.users[ply:SteamID()] then
        ply:SetUserGroup(dakmin.users[ply:SteamID()])
    end
end)

hook.Add("PlayerAuthed", "dakmin.ban", function(ply, steamid)
    if dakmin.bans[steamid] then
        if dakmin.bans[steamid].time > os.time() then
            game.KickID((steamid), dakmin.bans[steamid].reason)
        else
            commands.unban(nil, steamid)
        end
    end
end)