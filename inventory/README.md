# Inventory Bridge System

This folder contains inventory bridge modules that provide a unified API for different inventory systems.

## Supported Inventory Systems

1. **ox_inventory** - ox.lua
2. **qb-inventory** - qb.lua  
3. **qs-inventory** - qs.lua
4. **codem-inventory** - codem.lua

## Configuration

Set your inventory system in `config.lua`:

```lua
Config.Inventory = "ox"  -- Options: "ox", "qb", "qs", "codem"
```

## Bridge API

Each bridge module exports the following functions:

### GetItemCount(source, item)
Returns the count of a specific item in the player's inventory.

**Parameters:**
- `source` (number): Player server ID
- `item` (string): Item name

**Returns:** (number) Item count

### AddItem(source, item, count, metadata)
Adds an item to the player's inventory.

**Parameters:**
- `source` (number): Player server ID
- `item` (string): Item name
- `count` (number): Amount to add
- `metadata` (table, optional): Item metadata

**Returns:** (boolean) Success status

### RemoveItem(source, item, count, metadata)
Removes an item from the player's inventory.

**Parameters:**
- `source` (number): Player server ID
- `item` (string): Item name
- `count` (number): Amount to remove
- `metadata` (table, optional): Item metadata

**Returns:** (boolean) Success status

## Documentation References

- **ox_inventory**: https://coxdocs.dev/ox_inventory
- **qb-inventory**: https://docs.qbcore.org/qbcore-documentation/qbcore-resources/qb-inventory
- **qs-inventory**: https://docs.quasar-store.com/scripts/advanced-inventory/commands-and-exports
- **codem-inventory**: https://codem.gitbook.io/codem-documentation/m-series/essentials/minventory-remake/exports-and-commands/server-exports

## How It Works

The server script loads the appropriate bridge module based on `Config.Inventory`:

```lua
local inventoryType = Config.Inventory or "ox"
local Inventory = require(('inventory/%s'):format(inventoryType))
```

Then uses the unified API:

```lua
-- Get item count
local count = Inventory.GetItemCount(source, 'wood_log')

-- Add item
local success = Inventory.AddItem(source, 'wood_log', 5)

-- Remove item
local success = Inventory.RemoveItem(source, 'wood_log', 2)
```

## Adding New Inventory Systems

To add support for a new inventory system:

1. Create a new `.lua` file in this folder (e.g., `newinv.lua`)
2. Implement the three required functions: `GetItemCount`, `AddItem`, `RemoveItem`
3. Return the Inventory table at the end
4. Add the new option to `Config.Inventory` in config.lua
5. Update the dependencies section in fxmanifest.lua

Example template:

```lua
-- newinv.lua bridge
local Inventory = {}

function Inventory.GetItemCount(source, item)
    -- Implementation here
    return count or 0
end

function Inventory.AddItem(source, item, count, metadata)
    -- Implementation here
    return success
end

function Inventory.RemoveItem(source, item, count, metadata)
    -- Implementation here
    return success
end

return Inventory
```
