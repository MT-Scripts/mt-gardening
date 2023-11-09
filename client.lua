local ped = {}
local blip = {}
local target = {}
local marker = {}
local inJob = false
local paymentAmount = 0
local locations = 0
local locationsDone = 0

local time = 1000
function loadModel(model) 
    if not HasModelLoaded(model) then
        while not HasModelLoaded(model) do
            if time > 0 then time = time - 1 RequestModel(model) else time = 1000 break end Wait(10)
        end
    end
end

CreateThread(function()
    for k, v in pairs(Config.locations) do
        loadModel(v.ped.model)
        ped[k] =  CreatePed(4, GetHashKey(v.ped.model), v.ped.coords.x, v.ped.coords.y, v.ped.coords.z, v.ped.coords.w, false, true)
        SetEntityHeading(ped[k], v.ped.coords.w)
        FreezeEntityPosition(ped[k], true)
        SetEntityInvincible(ped[k], true)
        SetBlockingOfNonTemporaryEvents(ped[k], true)
        TaskStartScenarioInPlace(ped[k], v.ped.scenario, 0, true)

        if v.blip.show then
            blip[k] = AddBlipForCoord(v.ped.coords)
            SetBlipSprite(blip[k], v.blip.sprite)
            SetBlipDisplay(blip[k], v.blip.display)
            SetBlipAsShortRange(blip[k], true)
            SetBlipScale(blip[k], v.blip.scale)
            SetBlipColour(blip[k], v.blip.color)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.blip.label)
            EndTextCommandSetBlipName(blip[k])
        end

        exports.ox_target:addLocalEntity(ped[k], {
            {
                distance = 2.0,
                label = v.ped.text,
                icon = 'fas fa-scissors',
                onSelect = function()
                    startJob(v)
                end,
                canInteract = function()
                    if not inJob then return true end
                end
            },
            {
                distance = 2.0,
                label = 'Receber pagamento',
                icon = 'fas fa-dollar-sign',
                onSelect = function()
                    finishJob()
                end,
                canInteract = function()
                    if inJob then return true end
                end
            },
        })
    end
end)

function startJob(garden)
    lib.callback('mt-gardening:server:checkCanStartJob', false, function(canStart)
        if canStart then
            inJob = true
            lib.notify({ title = 'Começou serviço!', description = 'Começas-te o serviço, vai para os canteiros de flores da escola e trata das plantas!', type = 'success' })
            for k, v in pairs(garden.locations) do
                locations += 1
                marker[k] = true
                CreateThread(function()
                    while true do
                        if marker[k] then
                            local pedCoords = GetEntityCoords(cache.ped)
                            if GetDistanceBetweenCoords(pedCoords, v) <= 5.0 then
                                DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 255, 255, 50, false, true, 2, false, false, false, false)
                            end
                        else break end
                        Wait(1)
                    end
                end)
                target[k] = exports.ox_target:addSphereZone({
                    coords = v,
                    radius = 1.0,
                    debug = false,
                    drawSprite = true,
                    options = {
                        {
                            distance = 2.0,
                            label = 'Cortar',
                            icon = 'fas fa-scissors',
                            onSelect = function()
                                TaskTurnPedToFaceCoord(cache.ped, v.x, v.y, v.z, 500)
                                Wait(500)
                                if lib.progressCircle({ duration = 5000, useWhileDead = false, canCancel = true, anim = { scenario = 'CODE_HUMAN_MEDIC_KNEEL' } }) then
                                    ClearPedTasksImmediately(cache.ped)
                                    exports.ox_target:removeZone(target[k])
                                    target[k] = nil
                                    marker[k] = false
                                    paymentAmount += Config.pricerPerLocation
                                    locationsDone += 1
                                    lib.notify({ title = 'Planta tratada!', description = 'Trastas-te '..locationsDone..'/'..locations..' plantas. \nValor: '..paymentAmount..'$', type = 'success' })
                                else ClearPedTasksImmediately(cache.ped) end
                            end,
                            caInteract = function()
                                if inJob then return true end
                            end
                        },
                    }
                })
            end
        else
            lib.notify({ title = 'Descansa pah!', description = 'Já fizes-te o máximo de trabalhos por hoje, vai descansar!', type = 'error' })
        end
    end)
end

function finishJob()
    lib.callback('mt-gardening:server:givePayment', false, function()
        inJob = false
        if target ~= nil and #target > 0 then
            for i = 1, #target do if target[i] ~= nil then marker[i] = false exports.ox_target:removeZone(target[i]) target[i] = nil end end
        end
        locationsDone = 0
        locations = 0
        paymentAmount = 0
    end, paymentAmount)
end