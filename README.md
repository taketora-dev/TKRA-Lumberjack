# Simple Lumberjack (standalone)

Fitur:
- **Multi-inventory support**: ox_inventory, qb-inventory, qs-inventory, codem-inventory
- Butuh item kampak untuk menebang
- Target ke titik pohon (ox_target atau qb-target)
- Tebang pohon -> dapat item Batang Kayu
- Proses Batang Kayu menjadi Bubuk Kayu di lokasi pengolahan

## Instalasi

1) Taruh folder ini di `resources`
2) ensure `lumberjack`


3) Inventory - OX

```lua
['wood_log'] = {
    label = 'Batang Kayu',
    weight = 500,
    stack = true,
    close = false,
    description = 'Batang kayu hasil tebangan'
},
['sawdust'] = {
    label = 'Bubuk Kayu',
    weight = 100,
    stack = true,
    close = false,
    description = 'Bubuk kayu hasil pengolahan'
},
['kampak'] = {
    label = 'Kampak',
    weight = 1000,
    stack = false,
    close = false,
    description = 'Alat untuk menebang pohon'
},
```



