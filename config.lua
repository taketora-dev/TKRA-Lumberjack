Config = {}

-- Pilih inventory system: ox, qb, qs, codem
-- ox = ox_inventory
-- qb = qb-inventory
-- qs = qs-inventory
-- codem = codem-inventory
Config.Inventory = "ox"

-- Pilih target: otomatis deteksi ox_target atau qb-target
-- Tidak perlu ubah jika keduanya/ salah satu sudah terpasang
Config.TreeRespawnMinutes = 10            -- Waktu respawn pohon setelah ditebang
Config.ChopTime = 7000                    -- ms untuk anim/progress menebang
Config.ProcessTime = 5000                 -- ms untuk proses di tempat pengolahan
Config.LogItem = 'wood_log'               -- nama item batang kayu (ox_inventory)
Config.SawdustItem = 'sawdust'            -- nama item bubuk kayu (ox_inventory)
Config.AxeItem = 'kampak'                 -- item yang dibutuhkan untuk menebang
Config.LogReward = {min = 1, max = 3}     -- jumlah batang kayu tiap tebang
Config.ProcessYield = 2                   -- hasil bubuk kayu per 1 batang kayu
Config.AddBlip = true                     -- tambahkan blip pengolahan di map

-- Lokasi-lokasi pohon (ubah sesuai map server kamu)
-- Tips: gunakan /coords atau script koordinat untuk menambahkan titik baru
Config.Trees = {
    vector3(-553.0, 5371.9, 70.5),
    vector3(-584.0, 5326.2, 70.5),
    vector3(-631.1, 5309.9, 70.5),
    vector3(-615.5, 5426.2, 52.6),
    vector3(-672.3, 5453.8, 50.6)
}

-- Lokasi pengolahan (Sawmill/Tempat Gilingan)
-- Contoh: area sawmill Paleto
Config.ProcessLocation = vector3(-514.8, 5282.8, 80.6)

-- Radius interaksi target zona
Config.TargetRadius = 1.8

-- Jarak validasi server saat chop/proses (anti abuse)
Config.ServerValidateDistance = 5.0
