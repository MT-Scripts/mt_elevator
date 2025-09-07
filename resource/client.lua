local config = require "config"

local function loadAudioFile()
    if not RequestScriptAudioBank('audiodirectory/custom_sounds', false) then
        while not RequestScriptAudioBank('audiodirectory/custom_sounds', false) do
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
    for _, level in pairs(config[data.currentElevator]) do
        if level.level == data.level then
            levelData = level
            break
        end
    end
    if not levelData then
        cb(false)
        return
    end
    local coords = levelData.ped
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
    cb(true)
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
                    label = "Use elevator",
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
