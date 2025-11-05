-- qb-inventory bridge
local Inventory = {}

local QBCore = exports['qb-core']:GetCoreObject()

function Inventory.GetItemCount(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return 0 end
    local itemData = Player.Functions.GetItemByName(item)
    if not itemData then return 0 end
    return itemData.amount or 0
end

function Inventory.AddItem(source, item, count, metadata)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    return Player.Functions.AddItem(item, count, nil, metadata)
end

function Inventory.RemoveItem(source, item, count, metadata)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    return Player.Functions.RemoveItem(item, count, nil, metadata)
end

return Inventory
