local ox_inventory = exports.ox_inventory

local treeStates = {}

local function initStates()
    for i = 1, #Config.Trees do
        treeStates[i] = true -- available
    end
end

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    initStates()
end)

RegisterNetEvent('lumberjack:server:requestStates', function()
    local src = source
    TriggerClientEvent('lumberjack:client:syncStates', src, treeStates)
end)

local function withinDistance(vecA, vecB, max)
    if not vecA or not vecB then return false end
    local dx = vecA.x - vecB.x
    local dy = vecA.y - vecB.y
    local dz = vecA.z - vecB.z
    return (dx*dx + dy*dy + dz*dz) <= (max*max)
end

RegisterNetEvent('lumberjack:server:chopTree', function(idx)
    local src = source
    if type(idx) ~= 'number' or not Config.Trees[idx] then return end

    -- Validate server-side: available and near the tree
    if treeStates[idx] == false then
        TriggerClientEvent('lumberjack:client:notify', src, 'Pohon ini belum respawn.', 'error')
        return
    end

    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    if not withinDistance(coords, Config.Trees[idx], Config.ServerValidateDistance or 5.0) then
        TriggerClientEvent('lumberjack:client:notify', src, 'Terlalu jauh dari pohon.', 'error')
        return
    end

    -- Require axe item
    local axeItem = Config.AxeItem or 'kampak'
    local axeCount = ox_inventory:Search(src, 'count', axeItem) or 0
    if axeCount <= 0 then
        TriggerClientEvent('lumberjack:client:notify', src, ('Butuh item %s untuk menebang.'):format(axeItem), 'error')
        -- re-enable the tree locally since client already locked it when starting
        TriggerClientEvent('lumberjack:client:treeRespawn', src, idx)
        return
    end

    -- Mark chopped
    treeStates[idx] = false
    TriggerClientEvent('lumberjack:client:treeChopped', -1, idx)

    -- Reward logs
    local amount = math.random(Config.LogReward.min, Config.LogReward.max)
    local added = ox_inventory:AddItem(src, Config.LogItem, amount)

    if not added then
        -- If add failed, revert availability to avoid punishing player
        treeStates[idx] = true
        TriggerClientEvent('lumberjack:client:treeRespawn', -1, idx)
        TriggerClientEvent('lumberjack:client:notify', src, 'Gagal menambahkan item ke inventori.', 'error')
        return
    else
        TriggerClientEvent('lumberjack:client:notify', src, ('Kamu mendapat %sx Batang Kayu.'):format(amount), 'success')
    end

    -- Respawn timer
    local delay = (Config.TreeRespawnMinutes or 10) * 60000
    SetTimeout(delay, function()
        treeStates[idx] = true
        TriggerClientEvent('lumberjack:client:treeRespawn', -1, idx)
    end)
end)

RegisterNetEvent('lumberjack:server:processLogs', function()
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)

    if not withinDistance(coords, Config.ProcessLocation, Config.ServerValidateDistance or 5.0) then
        TriggerClientEvent('lumberjack:client:notify', src, 'Harus berada di tempat pengolahan.', 'error')
        return
    end

    local logItem = Config.LogItem
    local sawItem = Config.SawdustItem

    local count = ox_inventory:Search(src, 'count', logItem) or 0
    if count <= 0 then
        TriggerClientEvent('lumberjack:client:notify', src, 'Tidak ada Batang Kayu di inventory.', 'error')
        return
    end

    -- Remove all logs and add sawdust yield
    local removed = ox_inventory:RemoveItem(src, logItem, count)
    if not removed then
        TriggerClientEvent('lumberjack:client:notify', src, 'Gagal memproses. Coba lagi.', 'error')
        return
    end

    local yield = (Config.ProcessYield or 2) * count
    local added = ox_inventory:AddItem(src, sawItem, yield)
    if not added then
        -- try to refund logs if add failed
        ox_inventory:AddItem(src, logItem, count)
        TriggerClientEvent('lumberjack:client:notify', src, 'Gagal memberi Bubuk Kayu. Item dikembalikan.', 'error')
        return
    end

    TriggerClientEvent('lumberjack:client:notify', src, ('Berhasil memproses: %sx Bubuk Kayu.'):format(yield), 'success')
end)
