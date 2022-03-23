QBCore = {}
QBCore.ServerCallbacks = {}
QBCore.UseableItems = {}

-- Get permissions on server start

CreateThread(function()
    local result = MySQL.Sync.fetchAll('SELECT * FROM permissions', {})
    if result[1] then
        for k, v in pairs(result) do
            QBConfig.Server.PermissionList[v.license] = {
                license = v.license,
                permission = v.permission,
                optin = true,
            }
        end
    end
end)