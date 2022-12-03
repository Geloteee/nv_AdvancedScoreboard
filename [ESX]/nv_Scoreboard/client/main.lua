--[[

    GLOBAL
    Credits to Geloteee#2901
    
]]

function GetTableNumberOfKeys(table)
    local numItems = 0
    for k,v in pairs(table) do
        numItems = numItems + 1
    end
    return numItems;
end

local ready = false
local display = false

RegisterNUICallback('NuiReady', function()
    ready = true
end)

--[[

    PLAYERS

]]

RegisterCommand('scoreboard', function()
    display = not display
    SetNuiFocus(display, display)
    SendNUIMessage({
        type = 'display',
        status = display
    })
end)

RegisterKeyMapping('scoreboard', 'Display/Hide scoreboard', 'keyboard', 'f10')

RegisterNUICallback('exit', function(data)
    display = not display
    SetNuiFocus(display, display)
    SendNUIMessage({
        type = 'display',
        status = display
    })
end)

local srv_limit = 32

RegisterNetEvent('nv_Scoreboard:sendPlayerList')
AddEventHandler('nv_Scoreboard:sendPlayerList', function(PLAYERS, playerCount, playerLimit, isAdmin)
    while not ready do
        Citizen.Wait(100)
    end

    orderedTable = {}

    for k, v in pairs(PLAYERS) do
        table.insert(orderedTable, v)
    end

    srv_limit = playerLimit
    
    SendNUIMessage({
        type = 'players',
        data = json.encode(orderedTable),
        playerNumber = playerCount,
        limit = srv_limit,
        admin = isAdmin
    })
end)

RegisterNetEvent('nv_Scoreboard:playerJoining')
AddEventHandler('nv_Scoreboard:playerJoining', function(table, playerCount)
    while not ready do
        Citizen.Wait(100)
    end

    SendNUIMessage({
        type = 'players-join',
        data = json.encode(table),
        playerNumber = playerCount
    })
end)

RegisterNetEvent('nv_Scoreboard:playerDropped')
AddEventHandler('nv_Scoreboard:playerDropped', function(id, playerCount, BusinessActives)
    while not ready do
        Citizen.Wait(100)
    end

    SendNUIMessage({
        type = 'players-left',
        data = id,
        playerNumber = playerCount
    })
end)

--[[

    BUSINESS

]]

RegisterNetEvent('nv_Scoreboard:sendBusinessActives')
AddEventHandler('nv_Scoreboard:sendBusinessActives', function(BusinessActives, ActualBusiness, CurrentStatus)
    while not ready do
        Citizen.Wait(100)
    end

    SendNUIMessage({
        type = 'business-firstJoin',
        data = json.encode(BusinessActives),
        Actual = ActualBusiness,
        Status = CurrentStatus
    })
end)

RegisterNetEvent('nv_Scoreboard:noneJob')
AddEventHandler('nv_Scoreboard:noneJob', function()
    while not ready do
        Citizen.Wait(100)
    end

    SendNUIMessage({
        type = 'no-job',
    })
end)

RegisterNetEvent('nv_Scoreboard:joiningBusinessActives')
AddEventHandler('nv_Scoreboard:joiningBusinessActives', function(Business, Count)
    while not ready do
        Citizen.Wait(100)
    end

    SendNUIMessage({
        type = 'business-playerJoin',
        business = Business,
        playerCount = Count
    })
end)

RegisterNetEvent('nv_Scoreboard:sendEventImgToPlayers')
AddEventHandler('nv_Scoreboard:sendEventImgToPlayers', function(url, name)
    while not ready do
        Citizen.Wait(100)
    end

    SendNUIMessage({
        type = 'event-upload',
        img = url,
        id = name,
    })
end)

RegisterNetEvent('nv_Scoreboard:removeEventImgToPlayers')
AddEventHandler('nv_Scoreboard:removeEventImgToPlayers', function(name)
    while not ready do
        Citizen.Wait(100)
    end

    SendNUIMessage({
        type = 'event-remove',
        id = name,
    })
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(data)
    TriggerServerEvent('nv_Scoreboard:setJob', data.name)
end)

RegisterNUICallback('ChangeStatus', function(data)
    TriggerServerEvent('nv_Scoreboard:changeJobStatus', data)
end)

RegisterNUICallback('UploadImage', function(data)
    ExecuteCommand('nv_events_upload '..data.url..' '..data.name)
end)

RegisterNUICallback('RemoveImage', function(data)
    ExecuteCommand('nv_events_remove '..data.name)
end)

RegisterNUICallback('SaveColor', function(data)
    TriggerServerEvent('nv_Scoreboard:saveColorTable', data.colors)
end)

RegisterNUICallback('DefaultColor', function(data)
    TriggerServerEvent('nv_Scoreboard:DefaultColor')
end)

RegisterNetEvent('nv_Scoreboard:getColor')
AddEventHandler('nv_Scoreboard:getColor', function(colors)
    while not ready do
        Citizen.Wait(100)
    end
    
    SendNUIMessage({
        type = 'getColor',
        current_colors = json.encode(colors)
    })
end)

RegisterNetEvent('nv_Scoreboard:getChangedJobStatus')
AddEventHandler('nv_Scoreboard:getChangedJobStatus', function(status, identifier, currentBusiness)
    while not ready do
        Citizen.Wait(100)
    end
    
    SendNUIMessage({
        type = 'getChangedJobStatus',
        current_status = status,
        id = identifier,
        business = currentBusiness
    })
end)

RegisterNetEvent('nv_Scoreboard:getStatus')
AddEventHandler('nv_Scoreboard:getStatus', function(status)
    while not ready do
        Citizen.Wait(100)
    end

    SendNUIMessage({
        type = 'getStatus',
        Status = status,
    })
end)

RegisterNetEvent('nv_Scoreboard:loadRobberies')
AddEventHandler('nv_Scoreboard:loadRobberies', function(robberies)
    while not ready do
        Citizen.Wait(100)
    end
    
    SendNUIMessage({
        type = 'loadRobberies',
        data = robberies,
    })
end)

RegisterNetEvent('nv_Scoreboard:updateRobberies')
AddEventHandler('nv_Scoreboard:updateRobberies', function(robbery, status)
    while not ready do
        Citizen.Wait(100)
    end
    
    SendNUIMessage({
        type = 'updateRobberies',
        name = robbery,
        color = status
    })
end)






RegisterNetEvent('nv_Scoreboard:notify')
AddEventHandler('nv_Scoreboard:notify', function(action)
    Config.Notification(action)
end)

TriggerEvent('chat:addSuggestion', '/nv_events_remove', 'Remove an existing image event with his name', {
    { name="NAME", help="The name of the image that you want to remove from the events menu" },
})

TriggerEvent('chat:addSuggestion', '/nv_events_upload', 'Add an image to the events menu', {
    { name="URL", help="The URL of the image" },
    { name="NAME", help="The name that you want the image to have (IMPORTANT)" },
})

TriggerEvent('chat:addSuggestion', '/nv_events_list', 'Shows a list with the existing name of the images', {})