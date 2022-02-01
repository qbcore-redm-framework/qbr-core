-- Player load and unload handling
-- New method for checking if logged in across all scripts (optional)
-- if LocalPlayer.state['isLoggedIn'] then
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    ShutdownLoadingScreenNui()
    LocalPlayer.state:set('isLoggedIn', true, false)
    if QBConfig.Server.pvp then
        NetworkSetFriendlyFireOption(true)
    end
    if QBConfig.Player.RevealMap then
		SetMinimapHideFow(true)
	end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    LocalPlayer.state:set('isLoggedIn', false, false)
end)

RegisterNetEvent('QBCore:Client:PvpHasToggled', function(pvp_state)
    NetworkSetFriendlyFireOption(pvp_state)
end)

-- QBCore Teleport Events
RegisterNetEvent('QBCore:Command:TeleportToPlayer', function(coords)
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('QBCore:Command:TeleportToCoords', function(x, y, z)
    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z)
end)

RegisterNetEvent('QBCore:Command:GoToMarker', function()
    local ped = PlayerPedId()
    if DoesEntityExist(ped) then
        local blipCoords = GetWaypointCoords()
        for height = 1, 1000 do
			SetEntityCoords(ped, blipCoords.x, blipCoords.y, height + 0.0)
            local foundGround, zPos = GetGroundZAndNormalFor_3dCoord(blipCoords.x, blipCoords.y, height + 0.0)
            if foundGround then
                SetEntityCoords(ped, blipCoords.x, blipCoords.y, height + 0.0)
                break
            end
            Wait(0)
        end
    end
end)

-- Vehicle | Horse Events
RegisterNetEvent('QBCore:Command:SpawnVehicle', function(model)
	QBCore.Functions.SpawnVehicle(model, function(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end)
end)

RegisterNetEvent('QBCore:Command:DeleteVehicle', function()
	local ped = PlayerPedId()
	local vehicle = QBCore.Functions.GetClosestVehicle()
	if IsPedInAnyVehicle(ped) then vehicle = GetVehiclePedIsIn(ped, false) else vehicle = QBCore.Functions.GetClosestVehicle() end
	QBCore.Functions.DeleteVehicle(vehicle)
end)

RegisterNetEvent('QBCore:Command:SpawnHorse', function(HorseName)
    local ped = PlayerPedId()
    local hash = tostring(HorseName)
    if hash then
        if npc then
            DeleteEntity(npc)
        end
        local animalHash = GetHashKey(hash)
        if not IsModelValid(animalHash) then
            return
        end
        QBCore.Functions.LoadModel(animalHash)
		local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 4.0, 0.5))
        npc = CreatePed(animalHash, x, y, z, GetEntityHeading(ped)+90, 1, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x25ACFC650B65C538,npc, num)
		while not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, npc) do
			Wait(0)
		end
		Citizen.InvokeNative(0x704C908E9C405136, npc)
		Citizen.InvokeNative(0xAAB86462966168CE, npc, 1)
        Wait(500)
    else
		QBCore.Functions.Notify("Model not found", "error")
    end
end)

-- Other stuff
RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    QBCore.PlayerData = val
end)

RegisterNetEvent('QBCore:Player:UpdatePlayerData', function()
    TriggerServerEvent('QBCore:UpdatePlayer')
end)

RegisterNetEvent('QBCore:Notify', function(text, type, length)
    QBCore.Functions.Notify(text, type, length)
end)

RegisterNetEvent('QBCore:Notification', function(id, text, duration, subtext, dict, icon, color)
    QBCore.Functions.Notification(id, text, duration, subtext, dict, icon, color)
end)

RegisterNetEvent('QBCore:Client:TriggerCallback', function(name, ...)
    if QBCore.ServerCallbacks[name] then
        QBCore.ServerCallbacks[name](...)
        QBCore.ServerCallbacks[name] = nil
    end
end)

RegisterNetEvent('QBCore:Client:UseItem', function(item)
    TriggerServerEvent('QBCore:Server:UseItem', item)
end)
