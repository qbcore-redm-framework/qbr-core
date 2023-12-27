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
