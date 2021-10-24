QBCore.Functions = {}

-- Getters
-- Get your player first and then trigger a function on them
-- ex: local player = QBCore.Functions.GetPlayer(source)
-- ex: local example = player.Functions.functionname(parameter)

function QBCore.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
	return vector4(coords.x, coords.y, coords.z, heading)
end

function QBCore.Functions.GetIdentifier(source, idtype)
	local idtype = idtype or QBConfig.IdentifierType
	for _, identifier in pairs(GetPlayerIdentifiers(source)) do
		if string.find(identifier, idtype) then
			return identifier
		end
	end
	return nil
end

function QBCore.Functions.GetSource(identifier)
	for src, player in pairs(QBCore.Players) do
		local idens = GetPlayerIdentifiers(src)
		for _, id in pairs(idens) do
			if identifier == id then
				return src
			end
		end
	end
	return 0
end

function QBCore.Functions.GetPlayer(source)
	if type(source) == "number" then
		return QBCore.Players[source]
	else
		return QBCore.Players[QBCore.Functions.GetSource(source)]
	end
end

function QBCore.Functions.GetPlayerByCitizenId(citizenid)
	for src, player in pairs(QBCore.Players) do
		local cid = citizenid
		if QBCore.Players[src].PlayerData.citizenid == cid then
			return QBCore.Players[src]
		end
	end
	return nil
end

function QBCore.Functions.GetPlayers()
	local sources = {}
	for k, v in pairs(QBCore.Players) do
		table.insert(sources, k)
	end
	return sources
end

-- Will return an array of QB Player class instances
-- unlike the GetPlayers() wrapper which only returns IDs
function QBCore.Functions.GetQBPlayers()
	return QBCore.Players
end

-- Paycheckloop
function PaycheckLoop()
    local Players = QBCore.Functions.GetPlayers()
    for i=1, #Players, 1 do
        local Player = QBCore.Functions.GetPlayer(Players[i])
        if Player.PlayerData.job and Player.PlayerData.job.payment > 0 then
            Player.Functions.AddMoney('bank', Player.PlayerData.job.payment)
            TriggerClientEvent('QBCore:Notify', Players[i], 'You received your paycheck of $'..Player.PlayerData.job.payment)
        end
    end
    SetTimeout(QBCore.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckLoop)
end


-- Callbacks
function QBCore.Functions.CreateCallback(name, cb)
	QBCore.ServerCallbacks[name] = cb
end

function QBCore.Functions.TriggerCallback(name, source, cb, ...)
	if QBCore.ServerCallbacks[name] then
		QBCore.ServerCallbacks[name](source, cb, ...)
	end
end


-- Items
function QBCore.Functions.CreateUseableItem(item, cb)
	QBCore.UseableItems[item] = cb
end

function QBCore.Functions.CanUseItem(item)
	return QBCore.UseableItems[item] ~= nil
end

function QBCore.Functions.UseItem(source, item)
	QBCore.UseableItems[item.name](source, item)
end


-- Kick Player
function QBCore.Functions.Kick(source, reason, setKickReason, deferrals)
	reason = '\n'..reason..'\n🔸 Check our Discord for further information: '..QBCore.Config.Server.discord
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
					if(GetPlayerPing(source) >= 0) then
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
end


-- Check if player is whitelisted
function QBCore.Functions.IsWhitelisted(source)
	local plicense = QBCore.Functions.GetIdentifier(source, 'license')
	local identifiers = GetPlayerIdentifiers(source)
	if QBCore.Config.Server.whitelist then
		local result = exports.oxmysql:executeSync('SELECT * FROM whitelist WHERE license = ?', {plicense})
		if result[1] then
			for _, id in pairs(identifiers) do
				if result[1].license == id then
					return true
				end
			end
		end
	else
		return true
	end
	return false
end


-- Permissions
function QBCore.Functions.AddPermission(source, permission)
	local Player = QBCore.Functions.GetPlayer(source)
	local plicense = Player.PlayerData.license
	if Player then
		QBCore.Config.Server.PermissionList[plicense] = {
			license = plicense,
			permission = permission:lower(),
		}
		exports.oxmysql:execute('DELETE FROM permissions WHERE license = ?', {plicense})

		exports.oxmysql:insert('INSERT INTO permissions (name, license, permission) VALUES (?, ?, ?)', {
			GetPlayerName(source),
			plicense,
			permission:lower()
		})

		Player.Functions.UpdatePlayerData()
		TriggerClientEvent('QBCore:Client:OnPermissionUpdate', source, permission)
	end
end

function QBCore.Functions.RemovePermission(source)
	local Player = QBCore.Functions.GetPlayer(source)
	local license = Player.PlayerData.license
	if Player then
		QBCore.Config.Server.PermissionList[license] = nil	
		exports.oxmysql:execute('DELETE FROM permissions WHERE license = ?', { license })
		Player.Functions.UpdatePlayerData()
	end
end

function QBCore.Functions.HasPermission(source, permission)
	local license = QBCore.Functions.GetIdentifier(source, 'license')
	local permission = tostring(permission:lower())
	if permission == 'user' then
		return true
	else
		if QBCore.Config.Server.PermissionList[license] then
			if QBCore.Config.Server.PermissionList[license].license == license then
				if QBCore.Config.Server.PermissionList[license].permission == permission or QBCore.Config.Server.PermissionList[license].permission == "god" then
					return true
				end
			end
		end
	end
	return false
end

function QBCore.Functions.GetPermission(source)
	local Player = QBCore.Functions.GetPlayer(source)
	local license = Player.PlayerData.license
	if Player then
		if QBCore.Config.Server.PermissionList[Player.PlayerData.license] then 
			if QBCore.Config.Server.PermissionList[Player.PlayerData.license].license == license then
				return QBCore.Config.Server.PermissionList[license].permission
			end
		end
	end
	return retval
end


-- Opt in or out of admin reports
function QBCore.Functions.IsOptin(source)
	local license = QBCore.Functions.GetIdentifier(source, 'license')
	if QBCore.Functions.HasPermission(source, 'admin') then
		return QBCore.Config.Server.PermissionList[license].optin
	end
	return false
end

function QBCore.Functions.ToggleOptin(source)
	local license = QBCore.Functions.GetIdentifier(source, 'license')
	if QBCore.Functions.HasPermission(source, 'admin') then
		QBCore.Config.Server.PermissionList[license].optin = not QBCore.Config.Server.PermissionList[license].optin
	end
end


-- Check if player is banned
function QBCore.Functions.IsPlayerBanned(source)
	local src = source
	local retval = false
	local message = ''
	local plicense = QBCore.Functions.GetIdentifier(src, 'license')
    local result = exports.oxmysql:executeSync('SELECT * FROM bans WHERE license = ?', {plicense})
    if result[1] then
        if os.time() < result[1].expire then
            local timeTable = os.date('*t', tonumber(result.expire))
            message = 'You have been banned from the server:\n'..result[1].reason..'\nYour ban expires '..timeTable.day.. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour.. ':' .. timeTable.min .. '\n'
			return true, message
		else
            exports.oxmysql:execute('DELETE FROM bans WHERE id = ?', {result[1].id})
        end
    end
	return false, ''
end


-- Check for duplicate license
function QBCore.Functions.IsLicenseInUse(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local identifiers = GetPlayerIdentifiers(player)
        for _, id in pairs(identifiers) do
            if string.find(id, 'license') then
                local playerLicense = id
                if playerLicense == license then
                    return true
                end
            end
        end
    end
    return false
end
