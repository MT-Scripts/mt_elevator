local Config = lib.load('config')

createSphereZoneTarget = function(coords, radius, options, distance, name)
    if Config.target == 'ox_target' then
        return exports.ox_target:addSphereZone({ debug = Config.debug, coords = coords, radius = radius, options = options })
    elseif Config.target == 'interact' then
        return exports.interact:AddInteraction({ coords = vec3(coords.x, coords.y, coords.z), distance = 1.0, interactDst = 1.0, id = name, name = name, options = options })
    else
        -- Here we use Box Zone cause qb-target Sphere Zone does not exists and the Circle Zone is the big shit ever made
        return exports[Config.target]:AddBoxZone(name, coords, radius, radius, { debugPoly = Config.debug, name = name, minZ = coords.z-radius, maxZ = coords.z+radius }, { options = options, distance = distance })
    end
end

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
            createSphereZoneTarget(b.target.coords, b.target.radius, {
                {
                    label = "Use elevator",
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
            }, 2.5, 'elevaotor_'..k..a)
        end
    end
end)
