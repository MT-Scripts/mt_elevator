lib.versionCheck('MT-Scripts/mt_elevator')

RegisterNetEvent('mt_elevator:teleportPlayers', function(playerIds, coords)
    for _, playerId in pairs(playerIds) do
        TriggerClientEvent('mt_elevator:teleportPlayer', playerId, coords)
    end
end)
