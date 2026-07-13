local locations = {
    {
        coords = vector3(1734.3718, 2605.3018, 45.5380),
        mafinText = "MAFIN DEVELOPMENT",
        discordText = "discord.gg/mafin",
        range = 235.0 -- Specific range for this location
    },
}


local displayText = true
local inGreenZone = true
local playerPed = nil

Citizen.CreateThread(function()
    for _, location in ipairs(locations) do
        local radiusBlip = AddBlipForRadius(location.coords.x, location.coords.y, location.coords.z, location.range)
        SetBlipColour(radiusBlip, 2)
        SetBlipAlpha(radiusBlip, 90)
        SetBlipHighDetail(radiusBlip, true)
    end
end)

function RemoveText()
    displayText = true
    SendNUIMessage({ type = "displayText", display = false })
end

function SetPlayerPvP(enabled)
    local player = PlayerId()
    NetworkSetFriendlyFireOption(enabled)
    SetCanAttackFriendly(playerPed, enabled, enabled)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local nearestLocation = nil
        local nearestDistance = nil

        for _, location in ipairs(locations) do
            local distance = #(playerCoords - location.coords)
            if (not nearestDistance or distance < nearestDistance) and distance <= location.range then
                nearestDistance = distance
                nearestLocation = location
            end
        end

        if nearestLocation then
            displayText = true
            inGreenZone = true
            SetPlayerPvP(false)
        
            local message = {
                type = "displayText",
                display = true,
                mafinText = nearestLocation.mafinText,
                discordText = nearestLocation.discordText,
            }
            SendNUIMessage(message)
        else
            if inGreenZone then
                inGreenZone = false
                SetPlayerPvP(true)
            end
            RemoveText()
        end

    end 
end)
