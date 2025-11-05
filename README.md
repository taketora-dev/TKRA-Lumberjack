# Simple Lumberjack (standalone, no-job)

Fitur:
- Standalone (tidak bergantung framework seperti qb-core)
- **Multi-inventory support**: ox_inventory, qb-inventory, qs-inventory, codem-inventory
- Butuh item kampak untuk menebang
- Target ke titik pohon (ox_target atau qb-target)
- Tebang pohon -> dapat item Batang Kayu
- Proses Batang Kayu menjadi Bubuk Kayu di lokasi pengolahan

## Instalasi

1) Taruh folder ini di `resources/[standalone]/lumberjack`

2) **Pilih inventory system** di `config.lua`:
```lua
Config.Inventory = "ox"  -- Pilihan: "ox", "qb", "qs", "codem"
```

3) Tambahkan ke `server.cfg` sesuai inventory dan target yang kamu pakai:

**Untuk ox_inventory:**
```
ensure ox_inventory
ensure ox_target # atau qb-target
# opsional (untuk progress bar/notify):
# ensure ox_lib
ensure lumberjack
```

**Untuk qb-inventory:**
```
ensure qb-core
ensure qb-inventory
ensure qb-target # atau ox_target
ensure lumberjack
```

**Untuk qs-inventory:**
```
ensure qs-inventory
ensure ox_target # atau qb-target
ensure lumberjack
```

**Untuk codem-inventory:**
```
ensure codem-inventory
ensure ox_target # atau qb-target
ensure lumberjack
```

4) Tambahkan item ke inventory system kamu. Contoh untuk ox_inventory (file: `ox_inventory/data/items.lua`):

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

5) Atur koordinat di `config.lua` sesuai kebutuhan:
- `Config.Inventory` = pilih inventory system ("ox", "qb", "qs", "codem")
- `Config.Trees` = daftar titik pohon
- `Config.ProcessLocation` = lokasi pengolahan
- `Config.TreeRespawnMinutes`, `Config.ChopTime`, `Config.ProcessTime` dll.
- `Config.AxeItem` = nama item kampak yang dibutuhkan (default: `kampak`)

6) Icon item (opsional):
- Untuk ox_inventory: Taruh gambar di `ox_inventory/web/images/wood_log.png` dan `sawdust.png`
- Untuk inventory lain: Sesuaikan dengan dokumentasi masing-masing
- Tambahkan `kampak.png` jika mau

## Pemakaian
- Datang ke titik pohon, gunakan target untuk "Tebang Pohon".
- Jika punya item Kampak, proses tebang berlangsung.
- Setelah selesai, Batang Kayu akan otomatis masuk ke inventory.
- Bawa ke lokasi pengolahan, gunakan target untuk memproses jadi Bubuk Kayu.

## Catatan
- Script akan otomatis mendeteksi `ox_target` atau `qb-target`. Minimal salah satu harus aktif.
- **Mendukung 4 inventory system**: ox_inventory, qb-inventory, qs-inventory, codem-inventory
- Server-side melakukan validasi jarak untuk mencegah trigger dari jauh.
- Wajib item `kampak` untuk menebang. Nama item bisa diubah di `Config.AxeItem`.
- Jika `ox_lib` aktif, progress bar/notify akan menggunakan ox_lib. Jika tidak, fallback sederhana akan dipakai.

## Inventory Bridge System
Script menggunakan sistem bridge untuk mendukung berbagai inventory. Lihat `inventory/README.md` untuk detail teknis.

## Dokumentasi Inventory
- ox_inventory: https://coxdocs.dev/ox_inventory
- qb-inventory: https://docs.qbcore.org/qbcore-documentation/qbcore-resources/qb-inventory
- qs-inventory: https://docs.quasar-store.com/scripts/advanced-inventory/commands-and-exports
- codem-inventory: https://codem.gitbook.io/codem-documentation/m-series/essentials/minventory-remake

