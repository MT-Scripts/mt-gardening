local QBCore = exports['qbx-core']:GetCoreObject()
local jobsDone = {}

lib.callback.register('mt-gardening:server:checkCanStartJob', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid

    if jobsDone[cid] == nil then 
        jobsDone[cid] = 1
        return true
    elseif jobsDone[cid] <= Config.timesPerRR then
        jobsDone[cid] += 1
        return true
    else return false end
end)

lib.callback.register('mt-gardening:server:givePayment', function(source, payment)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', payment, 'gardening-job-payment')
end)