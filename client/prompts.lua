local Prompts = {}
local PromptGroups = {}

local function createPrompt(name, coords, key, text, options, marker)
    if (Prompts[name] == nil) then
        Prompts[name] = {}
        Prompts[name].name = name
        Prompts[name].coords = coords
        Prompts[name].key = key
        Prompts[name].text = text
        Prompts[name].options = options
        Prompts[name].active = false
        Prompts[name].marker = marker
        Prompts[name].prompt = nil
    else
        print('[qbr-core]  Prompt with name ' .. name .. ' already exists!')
    end
end

local function createPromptGroup(group, label, coords, prompts)
    if (PromptGroups[group] == nil) then
        PromptGroups[group] = {}
        PromptGroups[group].coords = coords
        PromptGroups[group].label = label
        PromptGroups[group].group = group
        PromptGroups[group].active = false
        PromptGroups[group].created = false
        PromptGroups[group].prompts = prompts
    else
        print('[qbr-core]  Prompt with name ' .. group .. ' already exists!')
    end
end

local function getPrompt()
    if Prompts then 
    return Prompts
    end
end

local function getPromptGroup()
    if PromptGroups then 
    return PromptGroups
    end
end

local function deletePrompt(name)
    if Prompts then
        PromptSetEnabled(Prompts[name].prompt, false)
        PromptSetVisible(Prompts[name].prompt, false)
        Prompts[name] = nil
    end
end

local function deletePromptGroup(name)
    if PromptGroups then
        PromptSetEnabled(PromptGroups[name].prompt, false)
        PromptSetVisible(PromptGroups[name].prompt, false)
        PromptGroups[name] = nil
    end
end

local function executeOptions(options)
    if (options.type == 'client') then
        if (options.args == nil) then
            TriggerEvent(options.event)
        else
            TriggerEvent(options.event, table.unpack(options.args))
        end
    elseif (options.type == 'callback') then
        if (options.args == nil) then
            return options.event()
        else
            return options.event(table.unpack(options.args))
        end
    else
        if (options.args == nil) then
            TriggerServerEvent(options.event)
        else
            TriggerServerEvent(options.event, table.unpack(options.args))
        end
    end
end

local function setupPrompt(prompt)
    local str = CreateVarString(10, 'LITERAL_STRING', prompt.text)
    prompt.prompt = PromptRegisterBegin()
    PromptSetControlAction(prompt.prompt, prompt.key)
    PromptSetText(prompt.prompt, str)
    PromptSetEnabled(prompt.prompt, false)
    PromptSetVisible(prompt.prompt, false)
    PromptSetHoldMode(prompt.prompt, true)
    PromptRegisterEnd(prompt.prompt)
end

local function setupPromptGroup(prompt)
    for k,v in pairs(prompt.prompts) do
        local str = CreateVarString(10, 'LITERAL_STRING', v.text)
        v.prompt = PromptRegisterBegin()
        PromptSetControlAction(v.prompt, v.key)
        PromptSetText(v.prompt, str)
        PromptSetEnabled(v.prompt, true)
        PromptSetVisible(v.prompt, true)
        PromptSetHoldMode(v.prompt, true)
        PromptSetGroup(v.prompt, prompt.group, 0)
        PromptRegisterEnd(v.prompt)
    end

    prompt.created = true
end

AddEventHandler('onResourceStop', function()
    for k,v in pairs(Prompts) do
        PromptSetEnabled(Prompts[k].prompt, false)
        PromptSetVisible(Prompts[k].prompt, false)
        Prompts[k].prompt = nil
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if (next(Prompts) ~= nil) then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped, true)
            for k,v in pairs(Prompts) do
                local distance = #(coords - v.coords)
                if (distance < 1.5) then
                    sleep = 1
                    if (Prompts[k].prompt == nil) then
                        setupPrompt(Prompts[k])
                    end
                    if (not Prompts[k].active) then
                        PromptSetEnabled(Prompts[k].prompt, true)
                        PromptSetVisible(Prompts[k].prompt, true)
                        Prompts[k].active = true
                    end
                    if PromptHasHoldModeCompleted(Prompts[k].prompt) then
                        executeOptions(Prompts[k].options)
                        PromptSetEnabled(Prompts[k].prompt, false)
                        PromptSetVisible(Prompts[k].prompt, false)
                        Prompts[k].prompt = nil
                        Prompts[k].active = false
                    end
                else
                    if (Prompts[k].active) then
                        PromptSetEnabled(Prompts[k].prompt, false)
                        PromptSetVisible(Prompts[k].prompt, false)
                        Prompts[k].prompt = nil
                        Prompts[k].active = false
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if (next(PromptGroups) ~= nil) then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped, true)
            for k,v in pairs(PromptGroups) do
                local distance = #(coords - v.coords)
                local promptGroup = PromptGroups[k].group
                if (distance < 1.5) then
                    sleep = 3
                    if (PromptGroups[k].created == false) then
                        setupPromptGroup(PromptGroups[k])
                    end

                    Citizen.InvokeNative(0xC65A45D4453C2627, promptGroup, CreateVarString(10, 'LITERAL_STRING', PromptGroups[k].label), 1)

                    for i,j in pairs(PromptGroups[k].prompts) do
                        if PromptHasHoldModeCompleted(j.prompt) then
                            executeOptions(j)
                            for _, n in pairs(PromptGroups[k].prompts) do
                                PromptSetEnabled(n.prompt, false)
                                PromptSetVisible(n.prompt, false)
                                n.prompt = nil
                            end
                            PromptGroups[k].created = false
                            break
                        end

                    end
                else
                    if (PromptGroups[k].created) then
                        for i,j in pairs(PromptGroups[k].prompts) do
                            PromptSetEnabled(j.prompt, false)
                            PromptSetVisible(j.prompt, false)
                            j.prompt = nil
                        end
                        PromptGroups[k].created = false
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

-- https://github.com/femga/rdr3_discoveries/tree/master/graphics/HUD/prompts/prompt_types
CreateThread(function()
    while true do
        Wait(1)
        PromptDisablePromptTypeThisFrame(1)
        PromptDisablePromptTypeThisFrame(2)
        --PromptDisablePromptTypeThisFrame(3)
    end
end)

exports('createPrompt', createPrompt)
exports('createPromptGroup', createPromptGroup)
exports('getPrompt', getPrompt)
exports('getPromptGroup',getPromptGroup)
exports('deletePrompt', deletePrompt)
exports('deletePromptGroup',deletePromptGroup)
