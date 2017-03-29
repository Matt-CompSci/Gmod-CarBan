util.AddNetworkString("CarBanUserMessage")

function sendClientMessage(Ply, Message)
    net.Start("CarBanUserMessage")
    net.WriteString(Message)
    net.Send(Ply)
end

function sendAllClientsMessage(Message)
    for k, v in pairs(player.GetAll()) do
        sendClientMessage(v, Message)
    end
end

function findPlayerByName(Name)
    for k, v in pairs(player.GetAll()) do
		if string.find(string.lower(v:Name()), string.lower(Name)) then
			return v
		end
	end
end

hook.Add("InitPostEntity", "carban_ulxload", function()
    if ulx then
        ULib.ucl.registerAccess("ulx_carban", ULib.ACCESS_ADMIN, "Ability to ban players from using cars", "Cmds - Utility")
        ULib.ucl.registerAccess("ulx_uncarban", ULib.ACCESS_ADMIN, "Ability to unban players from using cars", "Cmds - Utility")
    end
end)

local Player = FindMetaTable("Player")

function Player:vehicleBan()
    self:SetPData("VehicleBanned", 1)
end

function Player:vehicleUnban()
    self:SetPData("VehicleBanned", 0)
end

function Player:canVehicleBan()
    if ulx then
        return ULib.ucl.query(self, "ulx_carban")
    else
		return self:IsAdmin()
	end
end

function Player:isVehicleBanned()
    return tonumber(self:GetPData("VehicleBanned")) == 1
end

hook.Add("PlayerInitialSpawn", "CarbanInit", function(ply)
    local VehicleBanned = ply:GetPData("VehicleBanned")

    if VehicleBanned == nil then
        ply:SetPData("VehicleBanned", 0)
    end
end)

hook.Add("PlayerSay", "CarBanChatCommands", function(sender, text, team)
    ChatExplode = string.Explode(" ", text)

    if string.lower(ChatExplode[1]) == "!carban" then
        table.remove(ChatExplode, 1)
        PlyName = table.concat(ChatExplode, " ")

        if not ULib.ucl.query(sender, "ulx_carban") then
            sendClientMessage(sender, "You don't have permission for this command!")
            return ""
        end

        local Ply = findPlayerByName(PlyName)

        if Ply and IsValid(Ply) and Ply:IsPlayer() then
            Ply:vehicleBan()
            sendAllClientsMessage(sender:Name() .. " banned " .. Ply:Name() .. " From using vehicles!")
            return ""
        else
            sendClientMessage(sender, "Nobody could be found with that name")
            return ""
        end

    elseif string.lower(ChatExplode[1]) == "!carunban" then
        table.remove(ChatExplode, 1)
        PlyName = table.concat(ChatExplode, " ")

        local Ply = findPlayerByName(PlyName)
		
		if ulx then
			if not ULib.ucl.query(sender, "ulx_uncarban") then
				sendClientMessage(sender, "You don't have permission for this command!")
				return ""
			end
		else
			if not sender:IsAdmin() then
				sendClientMessage(sender, "You don't have permission for this command!")
				return ""
			end
		end

        if Ply and IsValid(Ply) and Ply:IsPlayer() then
            if not Ply:isVehicleBanned() then
                sendClientMessage(sender, Ply:Name() .. " isn't car banned!")
                return ""
            end
            Ply:vehicleUnban()
            sendAllClientsMessage(sender:Name() .. " unbanned " .. Ply:Name() .. " From using vehicles!")
        end
        return ""
    end
end)

hook.Add("CanPlayerEnterVehicle", "CarBanPlayerEntered", function(ply, vehicle, role)
    if ply:isVehicleBanned() then
        sendClientMessage(ply, "You tried to enter a vehicle, but you're banned from using vehicles!")
        return false
    end
end)
