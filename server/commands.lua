local CommandList = {}
local IgnoreList = { -- Ignore old perm levels while keeping backwards compatibility
    ['god'] = true, -- We don't need to create an ace because god is allowed all commands
    ['user'] = true -- We don't need to create an ace because builtin.everyone
}

CreateThread(function() -- Add ace to node for perm checking
    for k,v in pairs(QBConfig.Permissions) do
        ExecuteCommand(('add_ace qbcore.%s %s allow'):format(v, v))
    end
end)

-- Register & Refresh Commands

local function AddCommand(name, help, arguments, argsrequired, callback, permission)
    local restricted = true -- Default to restricted for all commands
    if not permission then permission = 'user' end -- some commands don't pass permission level
    if permission == 'user' then restricted = false end -- allow all users to use command
    RegisterCommand(name, callback, restricted) -- Register command within fivem
    if not IgnoreList[permission] then -- only create aces for extra perm levels
        ExecuteCommand(('add_ace qbcore.%s command.%s allow'):format(permission, name))
    end
    CommandList[name:lower()] = {
        name = name:lower(),
        permission = tostring(permission:lower()),
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end
exports('AddCommand', AddCommand)

function RefreshCommands(source)
    local src = source
    local Player = GetPlayer(src)
    local suggestions = {}
    if Player then
        for command, info in pairs(CommandList) do
            local hasPerm = IsPlayerAceAllowed(tostring(src), 'command.'..command)
            if hasPerm then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            else
                TriggerClientEvent('chat:removeSuggestion', src, '/'..command)
            end
        end
        TriggerClientEvent('chat:addSuggestions', src, suggestions)
    end
end
exports('RefreshCommands', RefreshCommands)

-- Teleport

AddCommand('tp', 'TP To Player or Coords (Admin Only)', { { name = 'id/x', help = 'ID of player or X position' }, { name = 'y', help = 'Y position' }, { name = 'z', help = 'Z position' } }, false, function(source, args)
    local src = source
    if args[1] and not args[2] and not args[3] then
        local target = GetPlayerPed(tonumber(args[1]))
        if target ~= 0 then
            local coords = GetEntityCoords(target)
            TriggerClientEvent('QBCore:Command:TeleportToPlayer', src, coords)
        else
            TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.not_online'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
        end
    else
        if args[1] and args[2] and args[3] then
            local x = tonumber((args[1]:gsub(",",""))) + .0
            local y = tonumber((args[2]:gsub(",",""))) + .0
            local z = tonumber((args[3]:gsub(",",""))) + .0
            if (x ~= 0) and (y ~= 0) and (z ~= 0) then
                TriggerClientEvent('QBCore:Command:TeleportToCoords', src, x, y, z)
            else
                TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.wrong_format'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.missing_args'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
        end
    end
end, 'admin')

AddCommand('tpm', 'TP To Marker (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('QBCore:Command:GoToMarker', src)
end, 'mod')

AddCommand('togglepvp', 'Toggle PVP on the server (Admin Only)', {}, false, function(source)
    local pvp_state = QBConfig.EnablePVP
    QBConfig.EnablePVP = not pvp_state
    TriggerClientEvent('QBCore:Client:PvpHasToggled', -1, QBConfig.EnablePVP)
end, 'god')

-- -- Permissions

AddCommand('addpermission', 'Give Player Permissions (God Only)', { { name = 'id', help = 'ID of player' }, { name = 'permission', help = 'Permission level' } }, true, function(source, args)
    local src = source
    local Player = GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        AddPermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.not_online'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
    end
end, 'god')

AddCommand('removepermission', 'Remove Players Permissions (God Only)', { { name = 'id', help = 'ID of player' }, { name = 'permission', help = 'Permission level' } }, true, function(source, args)
    local src = source
    local Player = GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        RemovePermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.not_online'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
    end
end, 'god')

-- Vehicle

AddCommand('car', 'Spawn Vehicle (Admin Only)', { { name = 'model', help = 'Model name of the vehicle' } }, true, function(source, args)
    local src = source
    TriggerClientEvent('QBCore:Command:SpawnVehicle', src, args[1])
end, 'admin')

AddCommand('dv', 'Delete Vehicle (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('QBCore:Command:DeleteVehicle', src)
end, 'mod')

AddCommand('horse', 'Spawn Horse (Admin Only)', { { name = 'model', help = 'Model name of the horse' } }, true, function(source, args)
    local src = source
    TriggerClientEvent('QBCore:Command:SpawnHorse', src, args[1])
end, 'admin')

AddCommand('coords', 'Get your current coords (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('QBCore:Command:GetCoords', src)
end, 'user')

-- Money

AddCommand('givemoney', 'Give A Player Money (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local src = source
    local Player = GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.not_online'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
    end
end, 'god')

AddCommand('setmoney', 'Set Players Money Amount (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local src = source
    local Player = GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.not_online'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
    end
end, 'god')

-- Xp Commands

AddCommand("givexp", "Give A Player Xp (Admin Only)", {{name="id", help="Player ID"},{name="skill", help="Type of skill (mining, etc)"}, {name="amount", help="Amount of xp"}}, true, function(source, args)
	local Player = GetPlayer(tonumber(args[1]))
	if Player then
		if Player.PlayerData.metadata["xp"][tostring(args[2])] then
			Player.Functions.AddXp(tostring(args[2]), tonumber(args[3]))
			TriggerClientEvent('QBCore:Notify', source, 9, Lang:t('info.xp_added'), 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			TriggerClientEvent('QBCore:Notify', source, 9, Lang:t('error.no_skill'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	else
		TriggerClientEvent('QBCore:Notify', source, 9, Lang:t('error.not_online'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
	end
end, 'god')

AddCommand("removexp", "Give A Player Xp (Admin Only)", {{name="id", help="Player ID"},{name="skill", help="Type of skill (mining, etc)"}, {name="amount", help="Amount of xp"}}, true, function(source, args)
	local Player = GetPlayer(tonumber(args[1]))
	if Player then
		if Player.PlayerData.metadata["xp"][tostring(args[2])] then
			Player.Functions.RemoveXp(tostring(args[2]), tonumber(args[3]))
			TriggerClientEvent('QBCore:Notify', source, 9, Lang:t('info.xp_removed'), 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			TriggerClientEvent('QBCore:Notify', source, 9, Lang:t('error.no_skill'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	else
		TriggerClientEvent('QBCore:Notify', source, 9, Lang:t('error.not_online'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
	end
end, 'god')

AddCommand("xp", "Check How Much Xp You Have", {{name="skill", help="Type of skill (mining, etc)"}}, true, function(source, args)
	local Player = GetPlayer(source)
	local Xp = Player.PlayerData.metadata["xp"][tostring(args[1])]
	if Player then
		if Xp then
			TriggerClientEvent('QBCore:Notify', source, 9, Lang:t('info.xp_info', {value = Xp, value2 = tostring(args[1])}), 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			TriggerClientEvent('QBCore:Notify', source, 9, Lang:t('error.no_skill'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end
end, 'god')

AddCommand("level", "Check Which Level You Are", {{name="skill", help="Type of skill (mining, etc)"}}, true, function(source, args)
	local Player = GetPlayer(source)
	local Level = Player.PlayerData.metadata["levels"][tostring(args[1])]
	if Player then
		if Level then
			TriggerClientEvent('QBCore:Notify', source, 9, Lang:t('info.level_info', {value = Level, value2 = tostring(args[1])}), 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			TriggerClientEvent('QBCore:Notify', source, 9, Lang:t('error.no_skill'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end
end, 'god')

-- Job

AddCommand('job', 'Check Your Job', {}, false, function(source)
    local src = source
    local PlayerJob = GetPlayer(src).PlayerData.job
    TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('info.job_info', {value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty}), 5000, 0, 'toasts_mp_generic', 'butcher_table_production', 'COLOR_WHITE')
end, 'user')

AddCommand('setjob', 'Set A Players Job (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'job', help = 'Job name' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
    local src = source
    local Player = GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetJob(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.not_online'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
    end
end, 'admin')

-- Gang

AddCommand('gang', 'Check Your Gang', {}, false, function(source)
    local src = source
    local PlayerGang = GetPlayer(source).PlayerData.gang
    TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('info.gang_info', {value = PlayerGang.label, value2 = PlayerGang.grade.name}), 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
end, 'user')

AddCommand('setgang', 'Set A Players Gang (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'gang', help = 'Name of a gang' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
    local src = source
    local Player = GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.not_online'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
    end
end, 'admin')

-- Inventory (should be in qb-inventory?)

AddCommand('clearinv', 'Clear Players Inventory (Admin Only)', { { name = 'id', help = 'Player ID' } }, false, function(source, args)
    local src = source
    local playerId = args[1] or src
    local Player = GetPlayer(tonumber(playerId))
    if Player then
        Player.Functions.ClearInventory()
    else
        TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.not_online'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
    end
end, 'god')

-- Out of Character Chat

AddCommand('ooc', 'OOC Chat Message', {}, false, function(source, args)
    local src = source
    local message = table.concat(args, ' ')
    local Players = GetPlayers()
    local Player = GetPlayer(src)
    for k, v in pairs(Players) do
        if v == src then
            TriggerClientEvent('chat:addMessage', v, {
                color = { 0, 0, 255},
                multiline = true,
                args = {'OOC | '.. GetPlayerName(src), message}
            })
        elseif #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(v))) < 20.0 then
            TriggerClientEvent('chat:addMessage', v, {
                color = { 0, 0, 255},
                multiline = true,
                args = {'OOC | '.. GetPlayerName(src), message}
            })
        elseif HasPermission(v, 'admin') then
            if IsOptin(v) then
                TriggerClientEvent('chat:addMessage', v, {
                    color = { 0, 0, 255},
                    multiline = true,
                    args = {'Proxmity OOC | '.. GetPlayerName(src), message}
                })
                TriggerEvent('qbr-log:server:CreateLog', 'ooc', 'OOC', 'white', '**' .. GetPlayerName(src) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. src .. ') **Message:** ' .. message, false)
            end
        end
    end
end, 'user')
