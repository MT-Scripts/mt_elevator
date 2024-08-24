local Config = lib.load('config')

RegisterNuiCallback('hideFrame', function(data, cb)
    SendNUIMessage({ action = 'setVisibleElevator', data = false })
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNuiCallback('useElevator', function(data, cb)
    SendNUIMessage({ action = 'setVisibleElevator', data = false })
    SetNuiFocus(false, false)
    local coords = Config.elevators[data.currentElevator].levels[data.id].ped
    DoScreenFadeOut(500)
    Wait(1000)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, true, false, false, false)
    SetEntityHeading(cache.ped, coords.w)
    Wait(1000)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "mt_elevator", 0.5)
    DoScreenFadeIn(500)
    cb(true)
end)

CreateThread(function()
    for k, v in pairs(Config.elevators) do
        for a, b in pairs(v.levels) do b.id = a end
        for a, b in pairs(v.levels) do
            exports.ox_target:addSphereZone({
                coords = b.target.coords,
                radius = b.target.radius,
                debug = false,
                options = {
                    {
                        label = "Usar elevador",
                        icon = 'fas fa-angle-up',
                        onSelect = function()
                            SendNUIMessage({
                                action = 'updateElevator',
                                data = {
                                    currentElevator = k,
                                    elevatorLabel = v.label,
                                    elevatorLevels = v.levels,
                                    currentLevel = a
                                }
                            })
                            SendNUIMessage({ action = 'setVisibleElevator', data = true })
                            SetNuiFocus(true, true)
                        end
                    }
                }
            })
        end
    end
end)