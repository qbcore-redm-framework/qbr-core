QBCore = {}
QBCore.Player = {}
QBCore.Players = {}
QBCore.UseableItems = {}
QBCore.ServerCallbacks = {}

function GetPlayers()
    local sources = {}
    for k, v in pairs(QBCore.Players) do
        sources[#sources+1] = k
    end
    return sources
end
exports('GetPlayers', GetPlayers)

-- Returns the entire player object
exports('GetQBPlayers', function()
    return QBCore.Players
end)

-- Returns a player's specific identifier
-- Accepts steamid, license, discord, xbl, liveid, ip
function GetIdentifier(source, idtype)
    if type(idtype) ~= "string" then return print('Invalid usage') end
    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end
    return nil
end
exports('GetIdentifier', GetIdentifier)

-- Returns the object of a single player by ID
function GetPlayer(source)
    return QBCore.Players[source]
end
exports('GetPlayer', GetPlayer)

-- Returns the object of a single player by Citizen ID
exports('GetPlayerByCitizenId', function(citizenid)
    for k, v in pairs(QBCore.Players) do
        local cid = citizenid
        if QBCore.Players[k].PlayerData.citizenid == cid then
            return QBCore.Players[k]
        end
    end
    return nil
end)

--- Gets a list of all on duty players of a specified job and the amount
exports('GetPlayersOnDuty', function(job)
    local players = {}
    local count = 0
    for k, v in pairs(QBCore.Players) do
        if v.PlayerData.job.name == job then
            if v.PlayerData.job.onduty then
                players[#players + 1] = k
                count = count + 1
            end
        end
    end
    return players, count
end)

-- Returns only the amount of players on duty for the specified job
exports('GetDutyCount', function(job)
    local count = 0
    for k, v in pairs(QBCore.Players) do
        if v.PlayerData.job.name == job then
            if v.PlayerData.job.onduty then
                count = count + 1
            end
        end
    end
    return count
end)

-- Callbacks

function CreateCallback(name, cb)
    QBCore.ServerCallbacks[name] = cb
end
exports('CreateCallback', CreateCallback)

function TriggerCallback(name, source, cb, ...)
    if not QBCore.ServerCallbacks[name] then return end
    QBCore.ServerCallbacks[name](source, cb, ...)
end
exports('TriggerCallback', TriggerCallback)

-- Items

-- Creates an item as usable
exports('CreateUseableItem', function(item, cb)
    QBCore.UseableItems[item] = cb
end)

-- Checks if an item can be used
exports('CanUseItem', function(item)
    return QBCore.UseableItems[item]
end)

-- Uses an item
exports('UseItem', function(source, item)
    QBCore.UseableItems[item.name](source, item)
end)

-- Kick Player with reason
exports('KickPlayer', function(source, reason, setKickReason, deferrals)
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. QBConfig.Discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if source then
            DropPlayer(source, reason)
        end
        local i = 0
        while (i <= 4) do
            i = i + 1
            while true do
                if source then
                    if (GetPlayerPing(source) >= 0) then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(source, reason)
                    end)
                end
            end
            Wait(5000)
        end
    end)
end)

-- Setting & Removing Permissions

function AddPermission(source, permission)
    local src = source
    local license = GetIdentifier(src, 'license')
    ExecuteCommand(('add_principal identifier.%s qbcore.%s'):format(license, permission))
    RefreshCommands(src)
end
exports('AddPermission', AddPermission)

function RemovePermission(source, permission)
    local src = source
    local license = GetIdentifier(src, 'license')
    if permission then
        if IsPlayerAceAllowed(src, permission) then
            ExecuteCommand(('remove_principal identifier.%s qbcore.%s'):format(license, permission))
            RefreshCommands(src)
        end
    else
        for k,v in pairs(QBConfig.Permissions) do
            if IsPlayerAceAllowed(src, v) then
                ExecuteCommand(('remove_principal identifier.%s qbcore.%s'):format(license, v))
                RefreshCommands(src)
            end
        end
    end
end
exports('RemovePermission', RemovePermission)

-- Checking for Permission Level

function HasPermission(source, permission)
    local src = source
    if IsPlayerAceAllowed(src, permission) then return true end
    return false
end
exports('HasPermission', HasPermission)

function GetPermissions(source)
    local src = source
    local perms = {}
    for k,v in pairs (QBConfig.Permissions) do
        if IsPlayerAceAllowed(src, v) then
            perms[v] = true
        end
    end
    return perms
end
exports('GetPermissions', GetPermissions)

-- Opt in or out of admin reports

function IsOptin(source)
    local src = source
    local license = GetIdentifier(src, 'license')
    if not license or not HasPermission(src, 'admin') then return false end
    local Player = GetPlayer(src)
    return Player.PlayerData.metadata['optin']
end
exports('IsOptin', IsOptin)

function ToggleOptin(source)
    local src = source
    local license = GetIdentifier(src, 'license')
    if not license or not HasPermission(src, 'admin') then return end
    local Player = GetPlayer(src)
    Player.PlayerData.metadata['optin'] = not Player.PlayerData.metadata['optin']
    Player.Functions.SetMetaData('optin', Player.PlayerData.metadata['optin'])
end
exports('ToggleOptin', ToggleOptin)