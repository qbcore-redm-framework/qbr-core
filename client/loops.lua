local isLoggedIn = false
AddStateBagChangeHandler('isLoggedIn', nil, function(bagName, key, value)
    isLoggedIn = value
end)

CreateThread(function()
    while true do
        Wait(0)
        if isLoggedIn then
            Wait((1000 * 60) * QBConfig.UpdateInterval)
            TriggerServerEvent('QBCore:UpdatePlayer')
        end
    end
end)

CreateThread(function()
    while true do
        Wait(QBConfig.StatusInterval)
        if isLoggedIn then
            if QBCore.PlayerData.metadata['hunger'] <= 0 or QBCore.PlayerData.metadata['thirst'] <= 0 then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                SetEntityHealth(ped, currentHealth - math.random(5, 10))
            end
        end
    end
end)

CreateThread(function ()
    if QBConfig.Hud.HidePlayersCore then
        for _, v in pairs(PlayersCore) do
            Citizen.InvokeNative(0xC116E6DF68DCE667, v, 2)
        end
    end
    if QBConfig.Hud.HideHorseCore then
        for _, v in pairs(HorseCore) do
            Citizen.InvokeNative(0xC116E6DF68DCE667, v, 2)
        end
    end
end)
