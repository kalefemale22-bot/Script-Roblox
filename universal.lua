-- ============================================================
-- KxK Script Hub | Universal Loader
-- Key System: Platoboost + Linkvertise (24 Jam Expiry)
-- ============================================================

local PLATOBOOST_ID = "24519" -- ID Platoboost Anda
local KEY_DURATION_HOURS = 24 -- Durasi key (jam)

-- ============================================================
-- GITHUB BASE URL
-- ============================================================
local BASE_URL = "https://raw.githubusercontent.com/kalefemale22-bot/Script-Roblox/main/"

-- ============================================================
-- DAFTAR GAME YANG DIDUKUNG
-- Format: [PlaceId] = "NamaFolder/namafile.lua"
-- ============================================================
local SUPPORTED_GAMES = {
    [107095834793267] = "Oil Empire/main.lua",
    -- Tambahkan game lain di sini:
    -- [PLACE_ID] = "Nama Folder/main.lua",
}

-- ============================================================
-- SISTEM PENYIMPANAN KEY + TIMESTAMP (24 JAM)
-- ============================================================
local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")
local LocalPlayer  = Players.LocalPlayer
local KEY_FILE     = "KxKScriptKey.json"

local function loadSavedData()
    local ok, raw = pcall(readfile, KEY_FILE)
    if not ok or not raw or raw == "" then return nil end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if ok2 and data then return data end
    return nil
end

local function saveKeyData(key)
    local data = {key = key, savedAt = os.time()}
    pcall(writefile, KEY_FILE, HttpService:JSONEncode(data))
end

local function isKeyExpired(data)
    if not data or not data.savedAt then return true end
    local elapsed = os.time() - data.savedAt
    return elapsed >= (KEY_DURATION_HOURS * 3600)
end

local function getTimeLeft(data)
    if not data or not data.savedAt then return "0j 0m" end
    local elapsed   = os.time() - data.savedAt
    local remaining = math.max(0, (KEY_DURATION_HOURS * 3600) - elapsed)
    local hours     = math.floor(remaining / 3600)
    local mins      = math.floor((remaining % 3600) / 60)
    return hours .. "j " .. mins .. "m"
end

-- ============================================================
-- CEK KEY KE SERVER PLATOBOOST
-- ============================================================
local function checkKey(key)
    local ok, result = pcall(function()
        local url = "https://api.platoboost.com/v1/authenticate?whitelist=" .. PLATOBOOST_ID .. "&key=" .. key
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)
        return data.valid == true
    end)
    return ok and result
end

-- ============================================================
-- UI KEY SYSTEM
-- ============================================================
local function showKeyUI(savedData)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KxKKeySystem"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")

    -- Overlay gelap
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui

    -- Kartu utama
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 440, 0, 310)
    card.Position = UDim2.new(0.5, -220, 0.5, -155)
    card.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
    card.BorderSizePixel = 0
    card.Parent = screenGui
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

    -- Garis atas (aksen warna)
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(1, 0, 0, 4)
    accent.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    accent.BorderSizePixel = 0
    accent.ZIndex = 2
    accent.Parent = card
    Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 14)

    -- Judul
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.Position = UDim2.new(0, 0, 0, 14)
    title.BackgroundTransparency = 1
    title.Text = "🔑  KxK Script — Key System"
    title.TextColor3 = Color3.fromRGB(255, 165, 0)
    title.TextSize = 19
    title.Font = Enum.Font.GothamBold
    title.Parent = card

    -- Badge 24 jam
    local badge = Instance.new("TextLabel")
    badge.Size = UDim2.new(0, 90, 0, 22)
    badge.Position = UDim2.new(0.5, -45, 0, 58)
    badge.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    badge.BackgroundTransparency = 0.75
    badge.Text = "⏱  24 Jam / Key"
    badge.TextColor3 = Color3.fromRGB(255, 200, 100)
    badge.TextSize = 12
    badge.Font = Enum.Font.GothamBold
    badge.Parent = card
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)

    -- Instruksi
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -40, 0, 20)
    info.Position = UDim2.new(0, 20, 0, 90)
    info.BackgroundTransparency = 1
    info.Text = "Dapatkan Key gratis (berlaku 24 jam) di:"
    info.TextColor3 = Color3.fromRGB(170, 170, 170)
    info.TextSize = 13
    info.Font = Enum.Font.Gotham
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.Parent = card

    -- Link Platoboost
    local link = Instance.new("TextLabel")
    link.Size = UDim2.new(1, -40, 0, 22)
    link.Position = UDim2.new(0, 20, 0, 112)
    link.BackgroundTransparency = 1
    link.Text = "🔗  platoboost.com/whitelist/" .. PLATOBOOST_ID
    link.TextColor3 = Color3.fromRGB(90, 170, 255)
    link.TextSize = 13
    link.Font = Enum.Font.Gotham
    link.TextXAlignment = Enum.TextXAlignment.Left
    link.Parent = card

    -- Kotak input key
    local inputBg = Instance.new("Frame")
    inputBg.Size = UDim2.new(1, -40, 0, 44)
    inputBg.Position = UDim2.new(0, 20, 0, 148)
    inputBg.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    inputBg.BorderSizePixel = 0
    inputBg.Parent = card
    Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 8)

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 1, 0)
    input.Position = UDim2.new(0, 10, 0, 0)
    input.BackgroundTransparency = 1
    input.PlaceholderText = "Paste key di sini..."
    input.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
    input.Text = (savedData and savedData.key) or ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 14
    input.Font = Enum.Font.Gotham
    input.ClearTextOnFocus = false
    input.Parent = inputBg

    -- Label status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -40, 0, 22)
    status.Position = UDim2.new(0, 20, 0, 200)
    status.BackgroundTransparency = 1
    status.Text = savedData and ("Key lama expired. Silakan generate key baru.") or ""
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = card

    -- Tombol Submit
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 42)
    btn.Position = UDim2.new(0, 20, 0, 252)
    btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    btn.BorderSizePixel = 0
    btn.Text = "✅   Submit Key"
    btn.TextColor3 = Color3.fromRGB(10, 10, 10)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local done = Instance.new("BindableEvent")
    local resultValid = false

    btn.MouseButton1Click:Connect(function()
        local key = input.Text
        if key == "" then
            status.Text = "❌ Key tidak boleh kosong!"
            status.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end

        btn.Active = false
        btn.BackgroundColor3 = Color3.fromRGB(120, 80, 0)
        btn.Text = "⏳   Memeriksa key..."
        status.Text = ""

        task.spawn(function()
            local valid = checkKey(key)
            if valid then
                saveKeyData(key)
                status.Text = "✅ Key valid! Memuat script..."
                status.TextColor3 = Color3.fromRGB(0, 220, 100)
                task.wait(0.8)
                resultValid = true
                done:Fire()
                screenGui:Destroy()
            else
                status.Text = "❌ Key tidak valid atau sudah expired!"
                status.TextColor3 = Color3.fromRGB(255, 80, 80)
                btn.Active = true
                btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
                btn.Text = "✅   Submit Key"
            end
        end)
    end)

    done.Event:Wait()
    done:Destroy()
    return resultValid
end

-- ============================================================
-- ALUR UTAMA
-- ============================================================
local savedData  = loadSavedData()
local isValid    = false

if savedData and not isKeyExpired(savedData) then
    -- Key masih berlaku, cek ke server sekali lagi untuk keamanan
    print("[KxK] Key ditemukan, sisa waktu: " .. getTimeLeft(savedData))
    isValid = checkKey(savedData.key)
    if not isValid then
        print("[KxK] Key ditolak server, meminta key baru...")
    end
end

if not isValid then
    isValid = showKeyUI(savedData)
end

if isValid then
    local placeId    = game.PlaceId
    local scriptPath = SUPPORTED_GAMES[placeId]

    if scriptPath then
        print("[KxK] ✅ Memuat script untuk PlaceId: " .. tostring(placeId))
        local ok, err = pcall(function()
            loadstring(game:HttpGet(BASE_URL .. scriptPath))()
        end)
        if not ok then
            warn("[KxK] ❌ Gagal memuat script: " .. tostring(err))
        end
    else
        warn("[KxK] Game ini (PlaceId: " .. tostring(placeId) .. ") belum didukung!")
    end
end
