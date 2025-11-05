# Simple Lumberjack (standalone, no-job)

Fitur:
- Standalone (tidak bergantung framework seperti qb-core)
- Butuh item kampak untuk menebang
- Target ke titik pohon (ox_target atau qb-target)
- Tebang pohon -> dapat item Batang Kayu (ox_inventory)
- Proses Batang Kayu menjadi Bubuk Kayu di lokasi pengolahan

## Instalasi

1) Taruh folder ini di `resources/[standalone]/lumberjack`
2) Tambahkan ke `server.cfg` setelah `ox_inventory`, dan target (salah satu). `ox_lib` opsional untuk progress bar/notify yang lebih bagus:

```
ensure ox_inventory
ensure ox_target # atau
ensure qb-target # pilih salah satu target yang kamu pakai
# opsional (untuk progress bar/notify):
# ensure ox_lib
ensure lumberjack
```

3) Tambahkan item ke `ox_inventory` (file: `ox_inventory/data/items.lua`). Contoh:

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

4) Atur koordinat di `config.lua` sesuai kebutuhan:
- `Config.Trees` = daftar titik pohon
- `Config.ProcessLocation` = lokasi pengolahan
- `Config.TreeRespawnMinutes`, `Config.ChopTime`, `Config.ProcessTime` dll.
- `Config.AxeItem` = nama item kampak yang dibutuhkan (default: `kampak`)

5) Icon item (opsional):
- Taruh gambar di `ox_inventory/web/images/wood_log.png` dan `sawdust.png`.
- Tambahkan `kampak.png` jika mau.

## Pemakaian
- Datang ke titik pohon, gunakan target untuk "Tebang Pohon".
- Jika punya item Kampak, proses tebang berlangsung.
- Setelah selesai, Batang Kayu akan otomatis masuk ke inventory (ox_inventory).
- Bawa ke lokasi pengolahan, gunakan target untuk memproses jadi Bubuk Kayu.

## Catatan
- Script akan otomatis mendeteksi `ox_target` atau `qb-target`. Minimal salah satu harus aktif.
- Server-side melakukan validasi jarak untuk mencegah trigger dari jauh.
- Wajib item `kampak` untuk menebang. Nama item bisa diubah di `Config.AxeItem`.
- Jika `ox_lib` aktif, progress bar/notify akan menggunakan ox_lib. Jika tidak, fallback sederhana akan dipakai.
