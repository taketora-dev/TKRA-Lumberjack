-- ox_inventory bridge
local Inventory = {}

function Inventory.GetItemCount(source, item)
    local ox_inventory = exports.ox_inventory
    if not ox_inventory then return 0 end
    return ox_inventory:Search(source, 'count', item) or 0
end

function Inventory.AddItem(source, item, count, metadata)
    local ox_inventory = exports.ox_inventory
    if not ox_inventory then return false end
    return ox_inventory:AddItem(source, item, count, metadata)
end

function Inventory.RemoveItem(source, item, count, metadata)
    local ox_inventory = exports.ox_inventory
    if not ox_inventory then return false end
    return ox_inventory:RemoveItem(source, item, count, metadata)
end

return Inventory
