local function LoadInventory(PlayerData)
    PlayerData.items = {}
    local inventory = MySQL.Sync.prepare('SELECT inventory FROM players WHERE citizenid = ?', { PlayerData.citizenid })
    if inventory then
        inventory = json.decode(inventory)
        if next(inventory) then
            for _, item in pairs(inventory) do
                if item then
                    local itemInfo = QBShared.Items[item.name:lower()]
                    if itemInfo then
                        PlayerData.items[item.slot] = {
                            name = itemInfo['name'],
                            amount = item.amount,
                            info = item.info or '',
                            label = itemInfo['label'],
                            description = itemInfo['description'] or '',
                            weight = itemInfo['weight'],
                            type = itemInfo['type'],
                            unique = itemInfo['unique'],
                            useable = itemInfo['useable'],
                            image = itemInfo['image'],
                            shouldClose = itemInfo['shouldClose'],
                            slot = item.slot,
                            combinable = itemInfo['combinable']
                        }
                    end
                end
            end
        end
    end
    return PlayerData
end

local function SaveInventory(source)
    if QBCore.Players[source] then
        local PlayerData = QBCore.Players[source].PlayerData
        local items = PlayerData.items
        local ItemsJson = {}
        if items and next(items) then
            for slot, item in pairs(items) do
                if items[slot] then
                    ItemsJson[#ItemsJson+1] = {
                        name = item.name,
                        amount = item.amount,
                        info = item.info,
                        type = item.type,
                        slot = slot,
                    }
                end
            end
            MySQL.Async.prepare('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode(ItemsJson), PlayerData.citizenid })
        else
            MySQL.Async.prepare('UPDATE players SET inventory = ? WHERE citizenid = ?', { '[]', PlayerData.citizenid })
        end
    end
end

local function GetTotalWeight(items)
    local weight = 0
    if items then
        for slot, item in pairs(items) do
            weight = weight + (item.weight * item.amount)
        end
    end
    return tonumber(weight)
end
exports('GetTotalWeight', GetTotalWeight)

local function GetSlotsByItem(items, itemName)
    local slotsFound = {}
    if items then
        for slot, item in pairs(items) do
            if item.name:lower() == itemName:lower() then
                slotsFound[#slotsFound+1] = slot
            end
        end
    end
    return slotsFound
end
exports('GetSlotsByItem', GetSlotsByItem)

local function GetFirstSlotByItem(items, itemName)
    if items then
        for slot, item in pairs(items) do
            if item.name:lower() == itemName:lower() then
                return tonumber(slot)
            end
        end
    end
    return nil
end
exports('GetFirstSlotByItem', GetFirstSlotByItem)

local function CreateCitizenId()
    local UniqueFound = false
    local CitizenId = nil
    while not UniqueFound do
        CitizenId = tostring(QBShared.RandomStr(3) .. QBShared.RandomInt(5)):upper()
        local result = MySQL.Sync.prepare('SELECT COUNT(*) as count FROM players WHERE citizenid = ?', { CitizenId })
        if result == 0 then
            UniqueFound = true
        end
    end
    return CitizenId
end

local function SavePlayer(source)
    local ped = GetPlayerPed(source)
    local pcoords = GetEntityCoords(ped)
    local PlayerData = QBCore.Players[source].PlayerData
    if PlayerData then
        MySQL.Async.insert('INSERT INTO players (citizenid, cid, license, name, money, charinfo, job, gang, position, metadata) VALUES (:citizenid, :cid, :license, :name, :money, :charinfo, :job, :gang, :position, :metadata) ON DUPLICATE KEY UPDATE cid = :cid, name = :name, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid),
            license = PlayerData.license,
            name = PlayerData.name,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(pcoords),
            metadata = json.encode(PlayerData.metadata)
        })
        SaveInventory(source)
        ShowSuccess(GetCurrentResourceName(), PlayerData.name .. ' PLAYER SAVED!')
    else
        ShowError(GetCurrentResourceName(), 'ERROR PLAYER SAVE - PLAYERDATA IS EMPTY!')
    end
end

local function CreatePlayer(PlayerData)
    local self = {}
    self.Functions = {}
    self.PlayerData = PlayerData

    self.Functions.UpdatePlayerData = function(dontUpdateChat)
        TriggerClientEvent('QBCore:Player:SetPlayerData', self.PlayerData.source, self.PlayerData)
        if dontUpdateChat == nil then
            RefreshCommands(self.PlayerData.source)
        end
    end

    self.Functions.SetJob = function(job, grade)
        local job = job:lower()
        local grade = tostring(grade) or '0'

        if QBShared.Jobs[job] then
            self.PlayerData.job.name = job
            self.PlayerData.job.label = QBShared.Jobs[job].label
            self.PlayerData.job.onduty = QBShared.Jobs[job].defaultDuty

            if QBShared.Jobs[job].grades[grade] then
                local jobgrade = QBShared.Jobs[job].grades[grade]
                self.PlayerData.job.grade = {}
                self.PlayerData.job.grade.name = jobgrade.name
                self.PlayerData.job.grade.level = tonumber(grade)
                self.PlayerData.job.payment = jobgrade.payment or 30
                self.PlayerData.job.isboss = jobgrade.isboss or false
            else
                self.PlayerData.job.grade = {}
                self.PlayerData.job.grade.name = 'No Grades'
                self.PlayerData.job.grade.level = 0
                self.PlayerData.job.payment = 30
                self.PlayerData.job.isboss = false
            end

            self.Functions.UpdatePlayerData()
            TriggerClientEvent('QBCore:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
            return true
        end

        return false
    end

    self.Functions.SetGang = function(gang, grade)
        local gang = gang:lower()
        local grade = tostring(grade) or '0'

        if QBShared.Gangs[gang] then
            self.PlayerData.gang.name = gang
            self.PlayerData.gang.label = QBShared.Gangs[gang].label
            if QBShared.Gangs[gang].grades[grade] then
                local ganggrade = QBShared.Gangs[gang].grades[grade]
                self.PlayerData.gang.grade = {}
                self.PlayerData.gang.grade.name = ganggrade.name
                self.PlayerData.gang.grade.level = tonumber(grade)
                self.PlayerData.gang.isboss = ganggrade.isboss or false
            else
                self.PlayerData.gang.grade = {}
                self.PlayerData.gang.grade.name = 'No Grades'
                self.PlayerData.gang.grade.level = 0
                self.PlayerData.gang.isboss = false
            end

            self.Functions.UpdatePlayerData()
            TriggerClientEvent('QBCore:Client:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
            return true
        end
        return false
    end

    self.Functions.SetJobDuty = function(onDuty)
        self.PlayerData.job.onduty = onDuty
        self.Functions.UpdatePlayerData()
    end

    self.Functions.SetMetaData = function(meta, val)
        local meta = meta:lower()
        if val ~= nil then
            self.PlayerData.metadata[meta] = val
            self.Functions.UpdatePlayerData()
        end
    end

    self.Functions.AddJobReputation = function(amount)
        local amount = tonumber(amount)
        self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] = self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] + amount
        self.Functions.UpdatePlayerData()
    end

    self.Functions.AddMoney = function(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)
        if amount < 0 then
            return
        end
        if self.PlayerData.money[moneytype] then
            self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype], true)
            else
                TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype])
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
            return true
        end
        return false
    end

    self.Functions.RemoveMoney = function(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)
        if amount < 0 then
            return
        end
        if self.PlayerData.money[moneytype] then
            for _, mtype in pairs(QBConfig.Money.DontAllowMinus) do
                if mtype == moneytype then
                    if self.PlayerData.money[moneytype] - amount < 0 then
                        return false
                    end
                end
            end
            self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('qbr-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype], true)
            else
                TriggerEvent('qbr-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype])
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
            return true
        end
        return false
    end

    self.Functions.SetMoney = function(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)
        if amount < 0 then
            return
        end
        if self.PlayerData.money[moneytype] then
            self.PlayerData.money[moneytype] = amount
            self.Functions.UpdatePlayerData()
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'SetMoney', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') set, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype])
            return true
        end
        return false
    end

    self.Functions.GetMoney = function(moneytype)
        if moneytype then
            local moneytype = moneytype:lower()
            return self.PlayerData.money[moneytype]
        end
        return false
    end

    self.Functions.AddXp = function(skill, amount)
		local skill = skill:lower()
		local amount = tonumber(amount)
		if self.PlayerData.metadata['xp'][skill] and amount > 0 then
			self.PlayerData.metadata['xp'][skill] = self.PlayerData.metadata['xp'][skill] + amount
			self.Functions.UpdateLevelData(skill)
			self.Functions.UpdatePlayerData()
			TriggerEvent('qbr-log:server:CreateLog', 'levels', 'AddXp', 'lightgreen', '**'..GetPlayerName(self.PlayerData.source) .. ' (citizenid: '..self.PlayerData.citizenid..' | id: '..self.PlayerData.source..')** has received: '..amount..'xp in the skill: '..skill..'. Their current xp amount is: '..self.PlayerData.metadata['xp'][skill])
			return true
		end
		return false
	end

	self.Functions.RemoveXp = function(skill, amount)
		local skill = skill:lower()
		local amount = tonumber(amount)
		if self.PlayerData.metadata['xp'][skill] and amount > 0 then
			self.PlayerData.metadata['xp'][skill] = self.PlayerData.metadata['xp'][skill] - amount
			self.Functions.UpdateLevelData(skill)
			self.Functions.UpdatePlayerData()
			TriggerEvent('qbr-log:server:CreateLog', 'levels', 'RemoveXp', 'lightgreen', '**'..GetPlayerName(self.PlayerData.source) .. ' (citizenid: '..self.PlayerData.citizenid..' | id: '..self.PlayerData.source..')** was stripped of: '..amount..'xp in the skill: '..skill..'. Their current xp amount is: '..self.PlayerData.metadata['xp'][skill])
			return true
		end
		return false
	end

    self.Functions.AddItem = function(item, amount, slot, info)
        local totalWeight = GetTotalWeight(self.PlayerData.items)
        local itemInfo = QBShared.Items[item:lower()]
        if itemInfo == nil then
            TriggerClientEvent('QBCore:Notify', self.PlayerData.source, Lang:t('error.item_not_exist'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
            return
        end
        local amount = tonumber(amount)
        local slot = tonumber(slot) or GetFirstSlotByItem(self.PlayerData.items, item)
        if itemInfo['type'] == 'weapon' and info == nil then
            info = {
                serie = tostring(QBShared.RandomInt(2) .. QBShared.RandomStr(3) .. QBShared.RandomInt(1) .. QBShared.RandomStr(2) .. QBShared.RandomInt(3) .. QBShared.RandomStr(4)),
            }
        end
        if (totalWeight + (itemInfo['weight'] * amount)) <= QBConfig.Player.MaxWeight then
            if (slot and self.PlayerData.items[slot]) and (self.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo['type'] == 'item' and not itemInfo['unique']) then
                self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount + amount
                self.Functions.UpdatePlayerData()
                TriggerEvent('qbr-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. self.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. self.PlayerData.items[slot].amount)
                return true
            elseif (not itemInfo['unique'] and slot or slot and self.PlayerData.items[slot] == nil) then
                self.PlayerData.items[slot] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = slot, combinable = itemInfo['combinable'] }
                self.Functions.UpdatePlayerData()
                TriggerEvent('qbr-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. self.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. self.PlayerData.items[slot].amount)
                return true
            elseif (itemInfo['unique']) or (not slot or slot == nil) or (itemInfo['type'] == 'weapon') then
                for i = 1, QBConfig.Player.MaxInvSlots, 1 do
                    if self.PlayerData.items[i] == nil then
                        self.PlayerData.items[i] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = i, combinable = itemInfo['combinable'] }
                        self.Functions.UpdatePlayerData()
                        TriggerEvent('qbr-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** got item: [slot:' .. i .. '], itemname: ' .. self.PlayerData.items[i].name .. ', added amount: ' .. amount .. ', new total amount: ' .. self.PlayerData.items[i].amount)
                        return true
                    end
                end
            end
        else
            TriggerClientEvent('QBCore:Notify', self.PlayerData.source, Lang:t('error.too_heavy'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
        end
        return false
    end

    self.Functions.RemoveItem = function(item, amount, slot)
        local amount = tonumber(amount)
        local slot = tonumber(slot)
        if slot then
            if self.PlayerData.items[slot].amount > amount then
                self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amount
                self.Functions.UpdatePlayerData()
                TriggerEvent('qbr-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** lost item: [slot:' .. slot .. '], itemname: ' .. self.PlayerData.items[slot].name .. ', removed amount: ' .. amount .. ', new total amount: ' .. self.PlayerData.items[slot].amount)
                return true
            elseif self.PlayerData.items[slot].amount == amount then
                self.PlayerData.items[slot] = nil
                self.Functions.UpdatePlayerData()
                TriggerEvent('qbr-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** lost item: [slot:' .. slot .. '], itemname: ' .. item .. ', removed amount: ' .. amount .. ', item removed')
                return true
            end
        else
            local slots = GetSlotsByItem(self.PlayerData.items, item)
            local amountToRemove = amount
            if slots then
                for _, slot in pairs(slots) do
                    if self.PlayerData.items[slot].amount > amountToRemove then
                        self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amountToRemove
                        self.Functions.UpdatePlayerData()
                        TriggerEvent('qbr-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** lost item: [slot:' .. slot .. '], itemname: ' .. self.PlayerData.items[slot].name .. ', removed amount: ' .. amount .. ', new total amount: ' .. self.PlayerData.items[slot].amount)
                        return true
                    elseif self.PlayerData.items[slot].amount == amountToRemove then
                        self.PlayerData.items[slot] = nil
                        self.Functions.UpdatePlayerData()
                        TriggerEvent('qbr-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** lost item: [slot:' .. slot .. '], itemname: ' .. item .. ', removed amount: ' .. amount .. ', item removed')
                        return true
                    end
                end
            end
        end
        return false
    end

    self.Functions.SetInventory = function(items, dontUpdateChat)
        self.PlayerData.items = items
        self.Functions.UpdatePlayerData(dontUpdateChat)
        TriggerEvent('qbr-log:server:CreateLog', 'playerinventory', 'SetInventory', 'blue', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** items set: ' .. json.encode(items))
    end

    self.Functions.ClearInventory = function()
        self.PlayerData.items = {}
        self.Functions.UpdatePlayerData()
        TriggerEvent('qbr-log:server:CreateLog', 'playerinventory', 'ClearInventory', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** inventory cleared')
    end

    self.Functions.GetItemByName = function(item)
        local item = tostring(item):lower()
        local slot = GetFirstSlotByItem(self.PlayerData.items, item)
        if slot then
            return self.PlayerData.items[slot]
        end
        return nil
    end

    self.Functions.GetItemsByName = function(item)
        local item = tostring(item):lower()
        local items = {}
        local slots = GetSlotsByItem(self.PlayerData.items, item)
        for _, slot in pairs(slots) do
            if slot then
                items[#items+1] = self.PlayerData.items[slot]
            end
        end
        return items
    end

    self.Functions.GetItemBySlot = function(slot)
        local slot = tonumber(slot)
        if self.PlayerData.items[slot] then
            return self.PlayerData.items[slot]
        end
        return nil
    end

    self.Functions.Save = function()
        SavePlayer(self.PlayerData.source)
    end

    QBCore.Players[self.PlayerData.source] = self
    SavePlayer(self.PlayerData.source)

    -- At this point we are safe to emit new instance to third party resource for load handling
    TriggerEvent('QBCore:Server:PlayerLoaded', self)
    self.Functions.UpdatePlayerData()
end

local function CheckPlayerData(source, PlayerData)
    PlayerData = PlayerData or {}
    PlayerData.source = source
    PlayerData.citizenid = PlayerData.citizenid or CreateCitizenId()
    PlayerData.license = PlayerData.license or GetIdentifier(source, 'license')
    PlayerData.name = GetPlayerName(source)
    PlayerData.cid = PlayerData.cid or 1
    PlayerData.money = PlayerData.money or {}
    for moneytype, startamount in pairs(QBConfig.Money.MoneyTypes) do
        PlayerData.money[moneytype] = PlayerData.money[moneytype] or startamount
    end
    -- Charinfo
    PlayerData.charinfo = PlayerData.charinfo or {}
    PlayerData.charinfo.firstname = PlayerData.charinfo.firstname or 'Firstname'
    PlayerData.charinfo.lastname = PlayerData.charinfo.lastname or 'Lastname'
    PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate or '00-00-0000'
    PlayerData.charinfo.gender = PlayerData.charinfo.gender or 0
    PlayerData.charinfo.nationality = PlayerData.charinfo.nationality or 'USA'
    PlayerData.charinfo.account = PlayerData.charinfo.account or PlayerData.charinfo.lastname..'-'..math.random(111111,999999)

    -- Metadata
    PlayerData.metadata = PlayerData.metadata or {}
    PlayerData.metadata['hunger'] = PlayerData.metadata['hunger'] or 100
    PlayerData.metadata['thirst'] = PlayerData.metadata['thirst'] or 100
    PlayerData.metadata['stress'] = PlayerData.metadata['stress'] or 0
    PlayerData.metadata['isdead'] = PlayerData.metadata['isdead'] or false
    PlayerData.metadata['inlaststand'] = PlayerData.metadata['inlaststand'] or false
    PlayerData.metadata['armor'] = PlayerData.metadata['armor'] or 0
    PlayerData.metadata['ishandcuffed'] = PlayerData.metadata['ishandcuffed'] or false
    PlayerData.metadata['injail'] = PlayerData.metadata['injail'] or 0
    PlayerData.metadata['jailitems'] = PlayerData.metadata['jailitems'] or {}
    PlayerData.metadata['status'] = PlayerData.metadata['status'] or {}
    PlayerData.metadata['commandbinds'] = PlayerData.metadata['commandbinds'] or {}
    PlayerData.metadata['bloodtype'] = PlayerData.metadata['bloodtype'] or QBConfig.Player.Bloodtypes[math.random(1, #QBConfig.Player.Bloodtypes)]
    PlayerData.metadata['dealerrep'] = PlayerData.metadata['dealerrep'] or 0
    PlayerData.metadata['craftingrep'] = PlayerData.metadata['craftingrep'] or 0
    PlayerData.metadata['callsign'] = PlayerData.metadata['callsign'] or 'NO CALLSIGN'

    PlayerData.metadata['inside'] = PlayerData.metadata['inside'] or {
        house = nil,
        apartment = {
            apartmentType = nil,
            apartmentId = nil,
        }
    }

    PlayerData.metadata['xp'] = PlayerData.metadata['xp'] or {
		['main'] = 0,
		['herbalism'] = 0,
		['mining'] = 0
	}

    PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
        ['weapon'] = false
    }

	PlayerData.metadata['levels'] = PlayerData.metadata['levels'] or {
		['main'] = 0,
		['herbalism'] = 0,
		['mining'] = 0
	}

    PlayerData.metadata['optin'] = PlayerData.metadata['optin'] or true

    -- Job
    PlayerData.job = PlayerData.job or {}
    PlayerData.job.name = PlayerData.job.name or 'unemployed'
    PlayerData.job.label = PlayerData.job.label or 'Civilian'
    PlayerData.job.payment = PlayerData.job.payment or 10
    if QBShared.ForceJobDefaultDutyAtLogin or PlayerData.job.onduty == nil then
        PlayerData.job.onduty = QBShared.Jobs[PlayerData.job.name].defaultDuty
    end
    PlayerData.job.isboss = PlayerData.job.isboss or false
    PlayerData.job.grade = PlayerData.job.grade or {}
    PlayerData.job.grade.name = PlayerData.job.grade.name or 'Freelancer'
    PlayerData.job.grade.level = PlayerData.job.grade.level or 0
    -- Gang
    PlayerData.gang = PlayerData.gang or {}
    PlayerData.gang.name = PlayerData.gang.name or 'none'
    PlayerData.gang.label = PlayerData.gang.label or 'No Gang Affiliaton'
    PlayerData.gang.isboss = PlayerData.gang.isboss or false
    PlayerData.gang.grade = PlayerData.gang.grade or {}
    PlayerData.gang.grade.name = PlayerData.gang.grade.name or 'none'
    PlayerData.gang.grade.level = PlayerData.gang.grade.level or 0
    -- Other
    PlayerData.position = PlayerData.position or QBConfig.DefaultSpawn
    PlayerData.LoggedIn = true
    PlayerData = LoadInventory(PlayerData)
    CreatePlayer(PlayerData)
end

exports('Login', function(source, citizenid, newData)
    if source then
        if citizenid then
            local license = GetIdentifier(source, 'license')
            local PlayerData = MySQL.Sync.prepare('SELECT * FROM players where citizenid = ?', { citizenid })
            if PlayerData and license == PlayerData.license then
                PlayerData.money = json.decode(PlayerData.money)
                PlayerData.job = json.decode(PlayerData.job)
                PlayerData.position = json.decode(PlayerData.position)
                PlayerData.metadata = json.decode(PlayerData.metadata)
                PlayerData.charinfo = json.decode(PlayerData.charinfo)
                if PlayerData.gang then
                    PlayerData.gang = json.decode(PlayerData.gang)
                else
                    PlayerData.gang = {}
                end
                CheckPlayerData(source, PlayerData)
            else
                DropPlayer(source, 'You Have Been Kicked For Exploitation')
                TriggerEvent('qbr-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Joining Exploit', false)
            end
        else
            CheckPlayerData(source, newData)
        end
        return true
    else
        ShowError(GetCurrentResourceName(), 'ERROR PLAYER LOGIN - NO SOURCE GIVEN!')
        return false
    end
end)

exports('Logout', function(source)
    TriggerClientEvent('QBCore:Client:OnPlayerUnload', source)
    TriggerClientEvent('QBCore:Player:UpdatePlayerData', source)
    Wait(200)
    QBCore.Players[source] = nil
end)

-- Delete character

local playertables = { -- Add tables as needed
    { table = 'players' },
    { table = 'bank_accounts' },
    { table = 'playerskins' },
    { table = 'player_outfits' },
    { table = 'player_vehicles' }
}

exports('DeleteCharacter', function(source, citizenid)
    local license = GetIdentifier(source, 'license')
    local result = MySQL.Sync.fetchScalar('SELECT license FROM players where citizenid = ?', { citizenid })
    if license == result then
        local query = "DELETE FROM %s WHERE citizenid = ?"
		local tableCount = #playertables
		local queries = table.create(tableCount, 0)

		for i=1, tableCount do
			local v = playertables[i]
			queries[i] = {query = query:format(v.table), values = { citizenid }}
		end

        MySQL.Async.transaction(queries, function(result)
			if result then
				TriggerEvent('qbr-log:server:CreateLog', 'joinleave', 'Character Deleted', 'red', '**' .. GetPlayerName(source) .. '** ' .. license .. ' deleted **' .. citizenid .. '**..')
            end
		end)
    else
        DropPlayer(source, 'You Have Been Kicked For Exploitation')
        TriggerEvent('qbr-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Deletion Exploit', false)
    end
end)

-- Paycheck

local function PaycheckLoop()
    local Players = QBCore.Players
    for _, Player in pairs(Players) do
        local payment = Player.PlayerData.job.payment
        if Player.PlayerData.job and payment > 0 and (QBShared.Jobs[Player.PlayerData.job.name].offDutyPay or Player.PlayerData.job.onduty) then
            if QBConfig.Money.PayCheckSociety then
                local account = exports['qb-bossmenu']:GetAccount(Player.PlayerData.job.name)
                if account ~= 0 then -- Checks if player is employed by a society
                    if account < payment then -- Checks if company has enough money to pay society
                        TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('error.company_too_poor'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
                    else
                        Player.Functions.AddMoney('bank', payment)
                        TriggerEvent('qb-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name, payment)
                        TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                    end
                else
                    Player.Functions.AddMoney('bank', payment)
                    TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                end
            else
                Player.Functions.AddMoney('bank', payment)
                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
            end
        end
    end
    SetTimeout(QBConfig.Money.PayCheckTimeOut * (60 * 1000), PaycheckLoop)
end

PaycheckLoop() -- This just starts the paycheck system