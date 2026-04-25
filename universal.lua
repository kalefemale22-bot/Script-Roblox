-- ============================================================
-- KxK Script Hub | Universal Loader
-- Dibuat oleh: KxK Script
-- ============================================================

local PLATOBOOST_ID = "MASUKKAN_ID_PLATOBOOST_ANDA" -- Ganti dengan ID Project Platoboost Anda

-- ============================================================
-- GITHUB BASE URL (Jangan diubah)
-- ============================================================
local BASE_URL = "https://raw.githubusercontent.com/kalefemale22-bot/Script-Roblox/main/"

-- ============================================================
-- DAFTAR GAME YANG DIDUKUNG
-- Format: [PlaceId] = "NamaFolder/namafile.lua"
-- ============================================================
local SUPPORTED_GAMES = {
    -- Oil Empire
    [2534724072] = "Oil Empire/main.lua",
    
    -- Tambahkan game lain di sini nanti:
    -- [PLACE_ID_GAME_BARU] = "Nama Folder Game/main.lua",
}

-- ============================================================
-- SISTEM KEY (PLATOBOOST)
-- ============================================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Cek apakah key sudah disimpan sebelumnya
local savedKey = ""
pcall(function()
    savedKey = readfile("KxKScriptKey.txt")
end)

local function checkKey(key)
    local success, result = pcall(function()
        local response = HttpService:GetAsync(
            "https://api.platoboost.com/v1/authenticate?whitelist=" .. PLATOBOOST_ID .. "&key=" .. key
        )
        local data = HttpService:JSONDecode(response)
        return data.valid == true
    end)
    if success then
        return result
    end
    return false
end

local function showKeyUI()
    -- Buat UI input key yang sederhana dan rapi
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KxKKeySystem"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")

    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blur.BackgroundTransparency = 0.5
    blur.BorderSizePixel = 0
    blur.Parent = screenGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 280)
    frame.Position = UDim2.new(0.5, -210, 0.5, -140)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    -- Garis atas berwarna
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 4)
    topBar.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    topBar.BorderSizePixel = 0
    topBar.Parent = frame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🔑 KxK Script | Key System"
    title.TextColor3 = Color3.fromRGB(255, 170, 0)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 30)
    subtitle.Position = UDim2.new(0, 20, 0, 55)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Dapatkan Key gratis di link di bawah ini:"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = frame

    local linkLabel = Instance.new("TextLabel")
    linkLabel.Size = UDim2.new(1, -40, 0, 25)
    linkLabel.Position = UDim2.new(0, 20, 0, 85)
    linkLabel.BackgroundTransparency = 1
    linkLabel.Text = "🔗 platoboost.com/whitelist/" .. PLATOBOOST_ID
    linkLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
    linkLabel.TextSize = 13
    linkLabel.Font = Enum.Font.Gotham
    linkLabel.TextXAlignment = Enum.TextXAlignment.Left
    linkLabel.Parent = frame

    local inputBg = Instance.new("Frame")
    inputBg.Size = UDim2.new(1, -40, 0, 45)
    inputBg.Position = UDim2.new(0, 20, 0, 130)
    inputBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    inputBg.BorderSizePixel = 0
    inputBg.Parent = frame
    Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 8)

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 1, 0)
    input.Position = UDim2.new(0, 10, 0, 0)
    input.BackgroundTransparency = 1
    input.PlaceholderText = "Masukkan Key di sini..."
    input.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    input.Text = savedKey or ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 14
    input.Font = Enum.Font.Gotham
    input.ClearTextOnFocus = false
    input.Parent = inputBg

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -40, 0, 25)
    status.Position = UDim2.new(0, 20, 0, 185)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(255, 80, 80)
    status.TextSize = 13
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = frame

    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(1, -40, 0, 42)
    submitBtn.Position = UDim2.new(0, 20, 0, 220)
    submitBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    submitBtn.BorderSizePixel = 0
    submitBtn.Text = "✅  Submit Key"
    submitBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
    submitBtn.TextSize = 15
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.Parent = frame
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 8)

    local valid = false
    local event = Instance.new("BindableEvent")

    submitBtn.MouseButton1Click:Connect(function()
        local key = input.Text
        if key == "" then
            status.Text = "❌ Key tidak boleh kosong!"
            status.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end
        
        status.Text = "⏳ Memeriksa key..."
        status.TextColor3 = Color3.fromRGB(255, 200, 0)
        submitBtn.Active = false
        submitBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 0)
        
        task.spawn(function()
            local isValid = checkKey(key)
            if isValid then
                pcall(function() writefile("KxKScriptKey.txt", key) end)
                status.Text = "✅ Key valid! Memuat script..."
                status.TextColor3 = Color3.fromRGB(0, 255, 100)
                task.wait(1)
                valid = true
                event:Fire()
                screenGui:Destroy()
            else
                status.Text = "❌ Key tidak valid atau sudah expired!"
                status.TextColor3 = Color3.fromRGB(255, 80, 80)
                submitBtn.Active = true
                submitBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
            end
        end)
    end)

    event.Event:Wait()
    event:Destroy()
    return valid
end

-- ============================================================
-- ALUR UTAMA: CEK KEY LALU MUAT SCRIPT GAME
-- ============================================================
local isKeyValid = false

-- Cek apakah ada key tersimpan yang masih valid
if savedKey and savedKey ~= "" then
    print("[KxK] Memeriksa key tersimpan...")
    isKeyValid = checkKey(savedKey)
end

-- Jika key tidak valid, tampilkan UI key
if not isKeyValid then
    isKeyValid = showKeyUI()
end

-- Jika key valid, muat script sesuai game
if isKeyValid then
    local placeId = game.PlaceId
    local scriptPath = SUPPORTED_GAMES[placeId]
    
    if scriptPath then
        print("[KxK] ✅ Key valid! Memuat script untuk PlaceId: " .. placeId)
        local url = BASE_URL .. scriptPath
        local success, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not success then
            warn("[KxK] ❌ Gagal memuat script: " .. tostring(err))
        end
    else
        -- Tampilkan notifikasi game belum didukung
        warn("[KxK] Game ini (PlaceId: " .. placeId .. ") belum didukung. Hubungi developer untuk request game!")
    end
end
