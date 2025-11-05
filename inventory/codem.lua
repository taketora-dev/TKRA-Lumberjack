-- codem-inventory bridge
local Inventory = {}

function Inventory.GetItemCount(source, item)
    local count = exports['codem-inventory']:GetItemsTotalAmount(source, item)
    return count or 0
end

function Inventory.AddItem(source, item, count, metadata)
    local success = exports['codem-inventory']:AddItem(source, item, count, metadata)
    return success
end

function Inventory.RemoveItem(source, item, count, metadata)
    local success = exports['codem-inventory']:RemoveItem(source, item, count, metadata)
    return success
end

return Inventory
