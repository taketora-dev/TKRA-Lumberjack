-- qs-inventory bridge
local Inventory = {}

function Inventory.GetItemCount(source, item)
    local count = exports['qs-inventory']:GetItemTotalAmount(source, item)
    return count or 0
end

function Inventory.AddItem(source, item, count, metadata)
    local success = exports['qs-inventory']:AddItem(source, item, count, nil, metadata)
    return success
end

function Inventory.RemoveItem(source, item, count, metadata)
    local success = exports['qs-inventory']:RemoveItem(source, item, count, nil, metadata)
    return success
end

return Inventory
