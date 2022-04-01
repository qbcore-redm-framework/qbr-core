-- Single add job function which should only be used if you planning on adding a single job
exports('AddJob', function(jobName, job)
    if type(jobName) ~= "string" then
        return false, "invalid_job_name"
    end

    if QBCore.Shared.Jobs[jobName] then
        return false, "job_exists"
    end

    QBCore.Shared.Jobs[jobName] = job
    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1,'Jobs', jobName, job)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end)

-- Multiple Add Jobs
exports('AddJobs', function(jobs)
    local shouldContinue = true
    local message = "success"
    local errorItem = nil
    for key, value in pairs(jobs) do
        if type(key) ~= "string" then
            message = 'invalid_job_name'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        if QBCore.Shared.Jobs[key] then
            message = 'job_exists'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        QBCore.Shared.Jobs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('QBCore:Client:OnSharedUpdateMultiple', -1, 'Jobs', jobs)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, message, nil
end)

-- Single add item
exports('AddItem', function(itemName, item)
    if type(itemName) ~= "string" then
        return false, "invalid_item_name"
    end

    if QBCore.Shared.Items[itemName] then
        return false, "item_exists"
    end

    QBCore.Shared.Items[itemName] = item
    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end)

-- Multiple Add Items
exports('AddItems', function(items)
    local shouldContinue = true
    local message = "success"
    local errorItem = nil
    for key, value in pairs(items) do
        if type(key) ~= "string" then
            message = "invalid_item_name"
            shouldContinue = false
            errorItem = items[key]
            break
        end

        if QBCore.Shared.Items[key] then
            message = "item_exists"
            shouldContinue = false
            errorItem = items[key]
            break
        end

        QBCore.Shared.Items[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('QBCore:Client:OnSharedUpdateMultiple', -1, 'Items', items)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, message, nil
end)

-- Single Add Gang
exports('AddGang', function(gangName, gang)
    if type(gangName) ~= "string" then
        return false, "invalid_gang_name"
    end
    if QBCore.Shared.Gangs[gangName] then
        return false, "gang_exists"
    end

    QBCore.Shared.Gangs[gangName] = gang
    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end)

-- Multiple Add Gangs
exports('AddGangs', function(gangs)
    local shouldContinue = true
    local message = "success"
    local errorItem = nil
    for key, value in pairs(gangs) do
        if type(key) ~= "string" then
            message = "invalid_gang_name"
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        if QBCore.Shared.Gangs[key] then
            message = "gang_exists"
            shouldContinue = false
            errorItem = gangs[key]
            break
        end
        QBCore.Shared.Gangs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('QBCore:Client:OnSharedUpdateMultiple', -1, 'Gangs', gangs)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, message, nil
end)