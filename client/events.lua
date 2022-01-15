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
