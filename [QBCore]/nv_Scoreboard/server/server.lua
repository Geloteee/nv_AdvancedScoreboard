local srv_limit = GetConvarInt('sv_maxclients', 32) -- Auto Player Limit Detector

QBCore = exports['qb-core']:GetCoreObject()

local PLAYERS = {}

local BusinessActives = {}
local RobberiesActives = {}

function GetTableNumberOfKeys(table)
    local numItems = 0
    for k,v in pairs(table) do
        numItems = numItems + 1
    end
    return numItems;
end

local events = json.decode(LoadResourceFile('nv_Scoreboard', './data/events.json'))

RegisterServerEvent('nv_Scoreboard:PlayerJoined')
AddEventHandler('nv_Scoreboard:PlayerJoined', function(fullname)
    local _source = source

    for k, v in pairs(events) do
        TriggerClientEvent('nv_Scoreboard:sendEventImgToPlayers', _source, v, k)
    end
    
    if Config.RPNames then
        PLAYERS[_source] = { id = _source, name = fullname }
    else
        PLAYERS[_source] = { id = _source, name = GetPlayerName(_source) }
    end

    TriggerClientEvent('nv_Scoreboard:sendPlayerList', _source, PLAYERS, GetTableNumberOfKeys(PLAYERS), srv_limit, QBCore.Functions.HasPermission(_source, 'admin'))
    for k, v in pairs(GetPlayers()) do
        local id = tonumber(v)
        if id ~= _source then
            TriggerClientEvent('nv_Scoreboard:playerJoining', id, PLAYERS[_source], GetTableNumberOfKeys(PLAYERS))
        end
    end
end)

AddEventHandler('playerDropped', function()
    local _source = source

    local actualBusiness = 'none'

    for k, v in pairs(BusinessActives) do
        if v.PlayerList[_source] then
            actualBusiness = k
        end
    end

    if actualBusiness ~= 'none' then
        if BusinessActives[actualBusiness].PlayerList[_source] == 'offduty' then
            BusinessActives[actualBusiness].PlayerList[_source] = nil
        else
            BusinessActives[actualBusiness].Count = BusinessActives[actualBusiness].Count - 1
            BusinessActives[actualBusiness].PlayerList[_source] = nil
        end

        for k, v in pairs(RobberiesActives) do
            if RobberiesActives[k] then
                if BusinessActives[actualBusiness].Job == RobberiesActives[k].Job then
                    if BusinessActives[actualBusiness].Count >= RobberiesActives[k].Min then
                        TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, true)
                        RobberiesActives[k].Available = true
                    else
                        TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, false)
                        RobberiesActives[k].Available = false
                    end
                end
            end
        end

        PLAYERS[_source] = nil
        TriggerClientEvent('nv_Scoreboard:playerDropped', -1, _source, GetTableNumberOfKeys(PLAYERS), BusinessActives[actualBusiness].Count)
    else
        PLAYERS[_source] = nil
        TriggerClientEvent('nv_Scoreboard:playerDropped', -1, _source, GetTableNumberOfKeys(PLAYERS), 'none')
    end
end)

local colors = json.decode(LoadResourceFile('nv_Scoreboard', './data/colors.json'))

function GetIdentifier(playerId)
	for k, v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, "license:") then
			local identifier = string.gsub(v, "license:", "")
			return identifier;
		end
	end
end

RegisterServerEvent('nv_Scoreboard:playerLoad')
AddEventHandler('nv_Scoreboard:playerLoad', function()
    local _source = source
    
    local xPlayer = QBCore.Functions.GetPlayer(_source)

    local job = xPlayer.PlayerData.job.name

    local actualBusiness = 'none'

    for k, v in pairs(BusinessActives) do
        if v.Job == job then
            actualBusiness = k
        end
    end

    local current_color = colors[GetIdentifier(_source)]

    if current_color then
        TriggerClientEvent('nv_Scoreboard:getColor', _source, current_color)
    end

    if actualBusiness ~= 'none' then
        BusinessActives[actualBusiness].Count = BusinessActives[actualBusiness].Count + 1
        BusinessActives[actualBusiness].PlayerList[_source] = ''

        for k, v in pairs(RobberiesActives) do
            if RobberiesActives[k] then
                if BusinessActives[actualBusiness].Job == RobberiesActives[k].Job then
                    if BusinessActives[actualBusiness].Count >= RobberiesActives[k].Min then
                        TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, true)
                        RobberiesActives[k].Available = true
                    else
                        TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, false)
                        RobberiesActives[k].Available = false
                    end
                end
            end
        end

        for k, v in pairs(GetPlayers()) do
            local id = tonumber(v)
            if id ~= _source then
                TriggerClientEvent('nv_Scoreboard:joiningBusinessActives', id, actualBusiness, BusinessActives[actualBusiness].Count)
            end
        end

        TriggerClientEvent('nv_Scoreboard:sendBusinessActives', _source, BusinessActives, actualBusiness, BusinessActives[actualBusiness].CurrentStatus)
        TriggerClientEvent('nv_Scoreboard:loadRobberies', _source, RobberiesActives)
    else
        TriggerClientEvent('nv_Scoreboard:loadRobberies', _source, RobberiesActives)
        TriggerClientEvent('nv_Scoreboard:sendBusinessActives', _source, BusinessActives, actualBusiness, {})
    end
end)

local duty_job = {}

RegisterServerEvent('nv_Scoreboard:setJob')
AddEventHandler('nv_Scoreboard:setJob', function(p_job)
    local _source = source
    
    local xPlayer = QBCore.Functions.GetPlayer(_source)

    local job = xPlayer.PlayerData.job.name

    if duty_job[_source] == nil then
        duty_job[_source] = nil
	if job == p_job then
        local actualBusiness = 'none'

        for k, v in pairs(BusinessActives) do
            if v.PlayerList[_source] then
                actualBusiness = k
            end
        end
    
        local actualBusiness2 = 'none'

        for k, v in pairs(BusinessActives) do
            if v.Job == job then
                actualBusiness2 = k
            end
        end

        if actualBusiness ~= 'none' then
            if BusinessActives[actualBusiness].PlayerList[_source] == 'offduty' then
                BusinessActives[actualBusiness].PlayerList[_source] = nil
            else
                BusinessActives[actualBusiness].Count = BusinessActives[actualBusiness].Count - 1
                BusinessActives[actualBusiness].PlayerList[_source] = nil
            end

            for k, v in pairs(RobberiesActives) do
                if RobberiesActives[k] then
                    if BusinessActives[actualBusiness].Job == RobberiesActives[k].Job then
                        if BusinessActives[actualBusiness].Count >= RobberiesActives[k].Min then
                            TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, true)
                            RobberiesActives[k].Available = true
                        else
                            TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, false)
                            RobberiesActives[k].Available = false
                        end
                    end
                end
            end

            if actualBusiness2 ~= 'none' then
                BusinessActives[actualBusiness2].Count = BusinessActives[actualBusiness2].Count + 1
                BusinessActives[actualBusiness2].PlayerList[_source] = ''

                for k, v in pairs(RobberiesActives) do
                    if RobberiesActives[k] then
                        if BusinessActives[actualBusiness2].Job == RobberiesActives[k].Job then
                            if BusinessActives[actualBusiness2].Count >= RobberiesActives[k].Min then
                                TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, true)
                                RobberiesActives[k].Available = true
                            else
                                TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, false)
                                RobberiesActives[k].Available = false
                            end
                        end
                    end
                end

                TriggerClientEvent('nv_Scoreboard:getStatus', _source, BusinessActives[actualBusiness2].Status)
                TriggerClientEvent('nv_Scoreboard:joiningBusinessActives', -1, actualBusiness, BusinessActives[actualBusiness].Count)
                TriggerClientEvent('nv_Scoreboard:joiningBusinessActives', -1, actualBusiness2, BusinessActives[actualBusiness2].Count)
            else
                TriggerClientEvent('nv_Scoreboard:joiningBusinessActives', -1, actualBusiness, BusinessActives[actualBusiness].Count)
                TriggerClientEvent('nv_Scoreboard:noneJob', _source)
            end
        else
            if actualBusiness2 ~= 'none' then
                BusinessActives[actualBusiness2].Count = BusinessActives[actualBusiness2].Count + 1
                BusinessActives[actualBusiness2].PlayerList[_source] = ''

                for k, v in pairs(RobberiesActives) do
                    if RobberiesActives[k] then
                        if BusinessActives[actualBusiness2].Job == RobberiesActives[k].Job then
                            if BusinessActives[actualBusiness2].Count >= RobberiesActives[k].Min then
                                TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, true)
                                RobberiesActives[k].Available = true
                            else
                                TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, false)
                                RobberiesActives[k].Available = false
                            end
                        end
                    end
                end

                TriggerClientEvent('nv_Scoreboard:getStatus', _source, BusinessActives[actualBusiness2].Status)
                TriggerClientEvent('nv_Scoreboard:joiningBusinessActives', -1, actualBusiness2, BusinessActives[actualBusiness2].Count)
            else
                TriggerClientEvent('nv_Scoreboard:noneJob', _source)
            end
        end
    end
    end
end)

RegisterNetEvent('QBCore:ToggleDuty', function()
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)

    local job = xPlayer.PlayerData.job.name

    local actualBusiness = 'none'

    duty_job[_source] = true
		
    for k, v in pairs(BusinessActives) do
        if v.PlayerList[_source] then
            actualBusiness = k
        end
    end

    if actualBusiness ~= 'none' then
        local onduty = not (xPlayer.PlayerData.job.onduty)

        if onduty then
            BusinessActives[actualBusiness].Count = BusinessActives[actualBusiness].Count + 1
            BusinessActives[actualBusiness].PlayerList[_source] = ''
        else
            BusinessActives[actualBusiness].Count = BusinessActives[actualBusiness].Count - 1
            BusinessActives[actualBusiness].PlayerList[_source] = 'offduty'
        end

        for k, v in pairs(RobberiesActives) do
            if RobberiesActives[k] then
                if BusinessActives[actualBusiness].Job == RobberiesActives[k].Job then
                    if BusinessActives[actualBusiness].Count >= RobberiesActives[k].Min then
                        TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, true)
                        RobberiesActives[k].Available = true
                    else
                        TriggerClientEvent('nv_Scoreboard:updateRobberies', -1, k, false)
                        RobberiesActives[k].Available = false
                    end
                end
            end
        end

        TriggerClientEvent('nv_Scoreboard:getStatus', _source, BusinessActives[actualBusiness].Status)
        TriggerClientEvent('nv_Scoreboard:joiningBusinessActives', -1, actualBusiness, BusinessActives[actualBusiness].Count)
    else
        TriggerClientEvent('nv_Scoreboard:noneJob', _source)
    end
end)

RegisterServerEvent('nv_Scoreboard:changeJobStatus')
AddEventHandler('nv_Scoreboard:changeJobStatus', function(data)
    local _source = source
    
    local xPlayer = QBCore.Functions.GetPlayer(_source)

    local job = xPlayer.PlayerData.job.name

    local actualBusiness = 'none'

    for k, v in pairs(BusinessActives) do
        if v.PlayerList[_source] then
            actualBusiness = k
        end
    end

    if actualBusiness ~= 'none' then
        if BusinessActives[actualBusiness].CurrentStatus[data.identifier] then
            BusinessActives[actualBusiness].CurrentStatus[data.identifier] = data.status
        else
            BusinessActives[actualBusiness].CurrentStatus[data.identifier] = ''
            BusinessActives[actualBusiness].CurrentStatus[data.identifier] = data.status
        end

        TriggerClientEvent('nv_Scoreboard:getChangedJobStatus', -1, data.status, data.identifier, actualBusiness)
    end
end)

RegisterServerEvent('nv_Scoreboard:saveColorTable')
AddEventHandler('nv_Scoreboard:saveColorTable', function(data)
    local _source = source
    
    local current_color = json.decode(data)

    local identifier = GetIdentifier(_source)

    colors[identifier] = {}

    for k, v in pairs(current_color) do
        colors[identifier][k..'-color'] = v
    end

    SaveResourceFile('nv_Scoreboard', './data/colors.json', json.encode(colors), -1)

    local current_color = colors[identifier]

    if current_color then
        TriggerClientEvent('nv_Scoreboard:getColor', _source, current_color)
    end

    TriggerClientEvent('nv_Scoreboard:notify', _source, 'saved_custom')
end)

RegisterServerEvent('nv_Scoreboard:DefaultColor')
AddEventHandler('nv_Scoreboard:DefaultColor', function()
    local _source = source
    
    local current_color = json.decode(data)

    local identifier = GetIdentifier(_source)

    colors[identifier] = nil

    SaveResourceFile('nv_Scoreboard', './data/colors.json', json.encode(colors), -1)

    TriggerClientEvent('nv_Scoreboard:notify', _source, 'updated_default')
end)

RegisterCommand('nv_events_upload', function(source, args)
    if QBCore.Functions.HasPermission(source, 'admin') then
        if args[1] then
            TriggerClientEvent('nv_Scoreboard:sendEventImgToPlayers', -1, args[1], args[2])
    
            events[args[2]] = args[1]
    
            SaveResourceFile('nv_Scoreboard', './data/events.json', json.encode(events), -1)
            TriggerClientEvent('nv_Scoreboard:notify', source, 'event_uploaded')
        end
    else
        TriggerClientEvent('nv_Scoreboard:notify', source, 'no_perms')
    end
end)

RegisterCommand('nv_events_remove', function(source, args)
    if QBCore.Functions.HasPermission(source, 'admin') then
        if args[1] then
            TriggerClientEvent('nv_Scoreboard:removeEventImgToPlayers', -1, args[1])
            events[args[1]] = nil
            SaveResourceFile('nv_Scoreboard', './data/events.json', json.encode(events), -1)
        end
        TriggerClientEvent('nv_Scoreboard:notify', source, 'event_removed')
    else
        TriggerClientEvent('nv_Scoreboard:notify', source, 'no_perms')
    end
end)

RegisterCommand('nv_events_list', function(source, args)
    if QBCore.Functions.HasPermission(source, 'admin') then
        local identifier = GetIdentifier(source)
        local current_color = colors[identifier]
        TriggerClientEvent('chatMessage', source, '^1Image List')
        for k, v in pairs(events) do
            TriggerClientEvent('chatMessage', source, '^2- ^3'..k)
        end
    else
        TriggerClientEvent('nv_Scoreboard:notify', source, 'no_perms')
    end
end)

for k, v in pairs(Config.Business) do
    BusinessActives[k] = {
        Description = v.Description,
        Job = v.Job,
        Status = v.Status,
        CurrentStatus = {},
        PlayerList = {},
        Count = 0,
    }
    for k2, v2 in pairs(BusinessActives[k].Status) do
        BusinessActives[k].CurrentStatus[k2] = v2[1]
    end
end

for k, v in pairs(Config.Robberies) do
    RobberiesActives[k] = {
        Description = v.Description,
        Job = v.Job,
        Min = v.Min,
        Available = false,
    }
end
