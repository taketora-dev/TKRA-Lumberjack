local targetType = nil
local treeZones = {}
local treeAvailable = {}
local oxZoneIds = {}
local processZone = nil

local function resourceStarted(name)
    return GetResourceState(name) == 'started'
end

local function Notify(msg, typ)
    -- Try ox_lib if available, otherwise native feed post
    if resourceStarted('ox_lib') then
        local ok = false
        if exports.ox_lib and exports.ox_lib.notify then
            ok = pcall(function()
                exports.ox_lib:notify({ title = 'Lumberjack', description = msg, type = typ or 'inform' })
            end)
        end
        if ok then return end
    end
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(tostring(msg))
    EndTextCommandThefeedPostTicker(false, false)
end

local function detectTarget()
    if resourceStarted('ox_target') then
        targetType = 'ox'
    elseif resourceStarted('qb-target') then
        targetType = 'qb'
    else
        targetType = nil
        print('[lumberjack] Peringatan: Tidak menemukan ox_target atau qb-target. Interaksi tidak akan aktif.')
        Notify('Target tidak ditemukan (ox_target/qb-target).', 'error')
    end
end

local function addBlip()
    if not Config.AddBlip or not Config.ProcessLocation then return end
    local blip = AddBlipForCoord(Config.ProcessLocation.x, Config.ProcessLocation.y, Config.ProcessLocation.z)
    SetBlipSprite(blip, 477)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 25)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Pengolahan Kayu')
    EndTextCommandSetBlipName(blip)
end

local function doChopAnim(duration, onDone, onCancel)
    local ped = PlayerPedId()
    -- Simple scenario hammering as previous behavior
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_HAMMERING', 0, true)
    if resourceStarted('ox_lib') and exports.ox_lib and exports.ox_lib.progressBar then
        local success = exports.ox_lib:progressBar({
            duration = duration,
            label = 'Menebang pohon...';
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, car = true, combat = true, mouse = false },
        })
        ClearPedTasks(ped)
        if success then if onDone then onDone() end else if onCancel then onCancel() end end
    else
        -- fallback no-cancel progress
        Wait(duration)
        ClearPedTasks(ped)
        if onDone then onDone() end
    end
end

local function doProcessAnim(duration, onDone, onCancel)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    if resourceStarted('ox_lib') and exports.ox_lib and exports.ox_lib.progressBar then
        local success = exports.ox_lib:progressBar({
            duration = duration,
            label = 'Memproses kayu...';
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, car = true, combat = true, mouse = false },
        })
        ClearPedTasks(ped)
        if success then if onDone then onDone() end else if onCancel then onCancel() end end
    else
        Wait(duration)
        ClearPedTasks(ped)
        if onDone then onDone() end
    end
end

local function ChopTree(idx)
    if not treeAvailable[idx] then
        Notify('Pohon ini baru saja ditebang. Tunggu respawn.', 'error')
        return
    end
    -- Mark locally to avoid double firing while progress runs
    treeAvailable[idx] = false
    doChopAnim(Config.ChopTime, function()
        TriggerServerEvent('lumberjack:server:chopTree', idx)
    end, function()
        -- If canceled, make it available again (since server not updated)
        treeAvailable[idx] = true
    end)
end

local function ProcessLogs()
    doProcessAnim(Config.ProcessTime, function()
        TriggerServerEvent('lumberjack:server:processLogs')
    end, function() end)
end

local function makeTreeZone(idx, coords)
    local name = ('lumber_tree_%s'):format(idx)
    if targetType == 'qb' then
        exports['qb-target']:AddBoxZone(name, coords, 2.0, 2.0, {
            name = name,
            heading = 0.0,
            debugPoly = false,
            minZ = coords.z - 1.0,
            maxZ = coords.z + 2.0
        }, {
            options = {
                {
                    icon = 'fa-solid fa-tree',
                    label = 'Tebang Pohon',
                    action = function()
                        ChopTree(idx)
                    end
                }
            },
            distance = 2.0
        })
        treeZones[idx] = name
    elseif targetType == 'ox' then
        local id = exports.ox_target:addSphereZone({
            coords = coords,
            radius = Config.TargetRadius or 1.8,
            debug = false,
            options = {
                {
                    name = 'lj_chop_' .. idx,
                    label = 'Tebang Pohon',
                    icon = 'fa-solid fa-tree',
                    onSelect = function()
                        ChopTree(idx)
                    end
                }
            }
        })
        oxZoneIds[idx] = id
    end
end

local function removeTreeZone(idx)
    if targetType == 'qb' and treeZones[idx] then
        exports['qb-target']:RemoveZone(treeZones[idx])
        treeZones[idx] = nil
    elseif targetType == 'ox' and oxZoneIds[idx] then
        exports.ox_target:removeZone(oxZoneIds[idx])
        oxZoneIds[idx] = nil
    end
end

local function createProcessZone()
    if not Config.ProcessLocation then return end
    if targetType == 'qb' then
        exports['qb-target']:AddBoxZone('lumber_process', Config.ProcessLocation, 2.4, 2.4, {
            name = 'lumber_process',
            heading = 0.0,
            debugPoly = false,
            minZ = Config.ProcessLocation.z - 1.0,
            maxZ = Config.ProcessLocation.z + 2.0
        }, {
            options = {
                {
                    icon = 'fa-solid fa-industry',
                    label = 'Proses Batang -> Bubuk Kayu',
                    action = function()
                        ProcessLogs()
                    end
                }
            },
            distance = 2.0
        })
        processZone = 'lumber_process'
    elseif targetType == 'ox' then
        processZone = exports.ox_target:addSphereZone({
            coords = Config.ProcessLocation,
            radius = Config.TargetRadius or 1.8,
            debug = false,
            options = {
                {
                    name = 'lj_process',
                    label = 'Proses Batang -> Bubuk Kayu',
                    icon = 'fa-solid fa-industry',
                    onSelect = function()
                        ProcessLogs()
                    end
                }
            }
        })
    end
end

local function setupAll()
    detectTarget()
    addBlip()
    -- mark all available by default until server sync
    for i = 1, #Config.Trees do
        treeAvailable[i] = true
        makeTreeZone(i, Config.Trees[i])
    end
    createProcessZone()
    -- request server states
    TriggerServerEvent('lumberjack:server:requestStates')
end

-- Events from server to sync states
RegisterNetEvent('lumberjack:client:syncStates', function(states)
    if type(states) ~= 'table' then return end
    for i = 1, #Config.Trees do
        local available = states[i] ~= false -- default true when nil
        treeAvailable[i] = available
        if not available then
            removeTreeZone(i)
        else
            -- ensure exists
            if (targetType == 'qb' and not treeZones[i]) or (targetType == 'ox' and not oxZoneIds[i]) then
                makeTreeZone(i, Config.Trees[i])
            end
        end
    end
end)

RegisterNetEvent('lumberjack:client:treeChopped', function(idx)
    treeAvailable[idx] = false
    removeTreeZone(idx)
end)

RegisterNetEvent('lumberjack:client:treeRespawn', function(idx)
    treeAvailable[idx] = true
    makeTreeZone(idx, Config.Trees[idx])
end)

-- Feedbacks from server
RegisterNetEvent('lumberjack:client:notify', function(msg, type)
    Notify(msg, type or 'inform')
end)

CreateThread(setupAll)
