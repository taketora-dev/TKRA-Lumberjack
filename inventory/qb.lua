-- qb-inventory bridge
local Inventory = {}

-- Lazy load QBCore when needed
local QBCore = nil
local function GetQBCore()
    if not QBCore then
        local success, core = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if success then
            QBCore = core
        end
    end
    return QBCore
end

function Inventory.GetItemCount(source, item)
    local Core = GetQBCore()
    if not Core then return 0 end
    local Player = Core.Functions.GetPlayer(source)
    if not Player then return 0 end
    local itemData = Player.Functions.GetItemByName(item)
    if not itemData then return 0 end
    return itemData.amount or 0
end

function Inventory.AddItem(source, item, count, metadata)
    local Core = GetQBCore()
    if not Core then return false end
    local Player = Core.Functions.GetPlayer(source)
    if not Player then return false end
    return Player.Functions.AddItem(item, count, nil, metadata)
end

function Inventory.RemoveItem(source, item, count, metadata)
    local Core = GetQBCore()
    if not Core then return false end
    local Player = Core.Functions.GetPlayer(source)
    if not Player then return false end
    return Player.Functions.RemoveItem(item, count, nil, metadata)
end

return Inventory
