-- ============================================================
-- KxK Script Hub | Universal Loader
-- ✅ File ini AMAN untuk dibaca publik (tidak ada info sensitif)
-- Untuk menambah game baru, edit bagian SUPPORTED_GAMES saja!
-- ============================================================

local BASE_URL = "https://raw.githubusercontent.com/kalefemale22-bot/Script-Roblox/main/"

-- ============================================================
-- 📋 DAFTAR GAME YANG DIDUKUNG
-- Cara tambah game baru:
--   1. Cari PlaceId game di URL roblox.com/games/XXXXX/...
--   2. Tambahkan baris baru: [PLACEID] = "Nama Folder/main.lua"
--   3. Buat folder & file scriptnya di GitHub
--   4. Push! Selesai.
-- ============================================================
local SUPPORTED_GAMES = {
    [107095834793267] = "Oil Empire/main.lua",

    -- Tambah game baru di sini:
    -- [12345678] = "Blox Fruits/main.lua",
    -- [98765432] = "Pet Simulator/main.lua",
}

-- ============================================================
-- MUAT CORE (Key System) — core.lua yang sudah di-obfuscate
-- ============================================================
local authenticate = loadstring(game:HttpGet(BASE_URL .. "core.lua"))()

-- ============================================================
-- ALUR UTAMA
-- ============================================================
if not authenticate then
    return warn("[KxK] Gagal memuat sistem autentikasi!")
end

local isValid = authenticate()

if isValid then
    local placeId    = game.PlaceId
    local scriptPath = SUPPORTED_GAMES[placeId]

    if scriptPath then
        print("[KxK] ✅ Memuat script: " .. scriptPath)
        local ok, err = pcall(function()
            loadstring(game:HttpGet(BASE_URL .. scriptPath))()
        end)
        if not ok then
            warn("[KxK] ❌ Error: " .. tostring(err))
        end
    else
        warn("[KxK] Game ini (PlaceId: " .. tostring(placeId) .. ") belum didukung oleh KxK Script!")
    end
end
