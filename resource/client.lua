local config = require "config"

local function loadAudioFile()
    if not RequestScriptAudioBank('audiodirectory/elevator_sounds', false) then
        while not RequestScriptAudioBank('audiodirectory/elevator_sounds', false) do
            Wait(0)
        end
    end
    return true
end

RegisterNUICallback('hideFrame', function(data, cb)
    SendNUIMessage({ action = 'setVisible', data = false })
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNUICallback('goToLevel', function(data, cb)
    local levelData
    local currentLevelData
    for _, level in pairs(config[data.currentElevator]) do
        if level.level == data.level then
            levelData = level
        end
        if level.level == data.currentLevel then
            currentLevelData = level
        end
    end
    
    if not levelData or not currentLevelData then
        cb(false)
        return
    end
    
    local elevatorCenter = currentLevelData.target.coords
    local elevatorRadius = 3.0
    local playersInElevator = {}
    
    local localServerId = GetPlayerServerId(PlayerId())
    table.insert(playersInElevator, localServerId)
    
    local players = GetActivePlayers()
    for _, player in pairs(players) do
        local playerPed = GetPlayerPed(player)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - vector3(elevatorCenter.x, elevatorCenter.y, elevatorCenter.z))
        
        if distance <= elevatorRadius then
            local serverId = GetPlayerServerId(player)
            if serverId ~= localServerId then
                table.insert(playersInElevator, serverId)
            end
        end
    end

    SendNUIMessage({ action = 'setVisible', data = false })
    SetNuiFocus(false, false)
    
    TriggerServerEvent('mt_elevator:teleportPlayers', playersInElevator, levelData.ped)
    
    cb(true)
end)

RegisterNetEvent('mt_elevator:teleportPlayer', function(coords)
    DoScreenFadeOut(500)
    Wait(1000)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, true, false, false, false)
    SetEntityHeading(cache.ped, coords.w)
    Wait(1000)
    DoScreenFadeIn(500)
    if loadAudioFile() then
        local soundId = GetSoundId()
        PlaySoundFromEntity(soundId, 'elevator', PlayerPedId(), 'elevator_soundset', false, 0)
        while not HasSoundFinished(soundId) do
            Wait(0)
        end
        ReleaseSoundId(soundId)
    end
end)

for k, v in pairs(config) do
    for _, elevator in pairs(v) do
        exports.ox_target:addSphereZone({
            coords = elevator.target.coords,
            radius = elevator.target.radius,
            options = {
                {
                    distance = 2.0,
                    name = "elevator_menu",
                    icon = "fa-solid fa-elevator",
                    label = "Usar elevador",
                    onSelect = function()
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            action = "updateElevator",
                            data = {
                                currentElevator = k,
                                elevatorLevels = (function()
                                    local levels = {}
                                    for _, level in pairs(v) do
                                        table.insert(levels, level.level)
                                    end
                                    table.sort(levels, function(a, b) return a > b end)
                                    return levels
                                end)(),
                                currentLevel = elevator.level
                            }
                        })
                        SendNUIMessage({
                            action = "setVisible",
                            data = true
                        })
                    end
                }
            }
        })
    end
end
