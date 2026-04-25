-- Memuat Library Orion (Tampilan UI)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Global Configuration Variables
_G.AutoCollect = false
_G.CollectDelay = 0.5

_G.AutoSteal = false
_G.MinStealAmount = 200

_G.AutoSell = false
_G.MinSellPrice = 12

-- ==========================================
-- PEMBUATAN MENU GUI
-- ==========================================
local Window = OrionLib:MakeWindow({Name = "KxK Script | Oil Empire", HidePremium = false, SaveConfig = true, ConfigFolder = "KxKOilEmpire"})

-- TAB 1: AUTO COLLECT
local MainTab = Window:MakeTab({Name = "Auto Collect", Icon = "rbxassetid://4483345998", PremiumOnly = false})
MainTab:AddToggle({
    Name = "Aktifkan Auto Collect (Markas Sendiri)",
    Default = false,
    Callback = function(Value)
        _G.AutoCollect = Value
    end    
})
MainTab:AddSlider({
    Name = "Interval Pengambilan (Detik)",
    Min = 0.1,
    Max = 10,
    Default = 0.5,
    Color = Color3.fromRGB(0,255,0),
    Increment = 0.1,
    ValueName = " detik",
    Callback = function(Value)
        _G.CollectDelay = Value
    end    
})

-- TAB 2: AUTO STEAL
local StealTab = Window:MakeTab({Name = "Auto Steal", Icon = "rbxassetid://4483345998", PremiumOnly = false})
StealTab:AddToggle({
    Name = "Aktifkan Auto Steal (Curi Musuh)",
    Default = false,
    Callback = function(Value)
        _G.AutoSteal = Value
    end    
})
StealTab:AddSlider({
    Name = "Minimal Isi Refinery Dicuri",
    Min = 10,
    Max = 20000,
    Default = 200,
    Color = Color3.fromRGB(255,0,0),
    Increment = 10,
    ValueName = " Minyak",
    Callback = function(Value)
        _G.MinStealAmount = Value
    end    
})

-- TAB 3: AUTO SELL
local SellTab = Window:MakeTab({Name = "Auto Sell", Icon = "rbxassetid://4483345998", PremiumOnly = false})
SellTab:AddToggle({
    Name = "Aktifkan Smart Auto Sell",
    Default = false,
    Callback = function(Value)
        _G.AutoSell = Value
    end    
})
SellTab:AddSlider({
    Name = "Jual Mulai Harga Berapa?",
    Min = 1,
    Max = 15,
    Default = 12,
    Color = Color3.fromRGB(255,255,0),
    Increment = 1,
    ValueName = " $",
    Callback = function(Value)
        _G.MinSellPrice = Value
    end    
})

OrionLib:Init() -- Menyelesaikan loading UI

-- ==========================================
-- LOGIC SCRIPT INTI
-- ==========================================
local Plots = workspace:WaitForChild("Plots", 10)
local myPlot = nil

if Plots then
    for _, plot in pairs(Plots:GetChildren()) do
        local config = plot:FindFirstChild("Configuration")
        if config then
            local playerVal = config:FindFirstChild("Player")
            if playerVal and playerVal.Value == LocalPlayer then
                myPlot = plot
                break
            end
        end
    end
end

if not myPlot then 
    OrionLib:MakeNotification({Name = "Error", Content = "Plot tidak ditemukan! Silakan claim markas.", Image = "rbxassetid://4483345998", Time = 5})
    return 
end

local rep = game:GetService("ReplicatedStorage")
local sellRemote = rep:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("BaseService"):WaitForChild("RE"):WaitForChild("SellGas")

local sellPrompt = nil
for _, desc in pairs(workspace:GetDescendants()) do
    if desc:IsA("ProximityPrompt") and string.find(string.lower(desc.ActionText .. " " .. desc.ObjectText), "gasoline") then
        sellPrompt = desc
        break
    end
end

local isTeleporting = false

local function teleportSafe(targetCFrame)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.CFrame = targetCFrame
        task.wait(1.5) 
    end
end

-- 🔄 THREAD 1: AUTO COLLECT
task.spawn(function()
    while true do
        task.wait(_G.CollectDelay)
        if not _G.AutoCollect then continue end
        
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local hrp = char.HumanoidRootPart
        
        local myBuildings = myPlot:FindFirstChild("Buildings")
        if myBuildings then
            for _, bldg in pairs(myBuildings:GetChildren()) do
                for _, desc in pairs(bldg:GetDescendants()) do
                    if desc:IsA("TouchTransmitter") and firetouchinterest then
                        firetouchinterest(hrp, desc.Parent, 0)
                        task.wait(0.01)
                        firetouchinterest(hrp, desc.Parent, 1)
                    end
                end
            end
        end
    end
end)

-- 🥷 THREAD 2: AUTO STEAL
task.spawn(function()
    while true do
        task.wait(2) 
        if not _G.AutoSteal then continue end
        if isTeleporting then continue end 
        
        for _, plot in pairs(Plots:GetChildren()) do
            if plot == myPlot then continue end 
            if isTeleporting or not _G.AutoSteal then break end
            
            local buildings = plot:FindFirstChild("Buildings")
            if not buildings then continue end
            
            for _, bldg in pairs(buildings:GetChildren()) do
                if isTeleporting or not _G.AutoSteal then break end
                
                local prompt = nil
                for _, desc in pairs(bldg:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") and desc.Enabled then
                        local text = string.lower(desc.ActionText .. " " .. desc.ObjectText)
                        if string.find(text, "steal") then
                            prompt = desc
                            break
                        end
                    end
                end
                
                if prompt then
                    -- BACA ANGKA JUMLAH MINYAK DARI TEKS ("Steal (20000 gasoline)")
                    local amountStr = string.match(prompt.ActionText, "%d+") or string.match(prompt.ObjectText, "%d+")
                    local stealAmount = tonumber(amountStr) or 0
                    
                    -- HANYA CURI JIKA JUMLAH MINYAK MEMENUHI TARGET (Slider Minimal)
                    if stealAmount >= _G.MinStealAmount then
                        local promptPart = prompt.Parent
                        if promptPart:IsA("Attachment") then promptPart = promptPart.Parent end
                        
                        if promptPart and promptPart:IsA("BasePart") then
                            isTeleporting = true
                            teleportSafe(promptPart.CFrame * CFrame.new(0, 3, 0))
                            
                            if fireproximityprompt then
                                fireproximityprompt(prompt, 1, true)
                                task.wait(3) 
                                
                                local placeArea = myPlot:FindFirstChild("PlaceArea")
                                if placeArea then
                                    teleportSafe(placeArea.CFrame * CFrame.new(0, 3, 0))
                                    task.wait(2) 
                                end
                            end
                            isTeleporting = false
                        end
                    end
                end
            end
        end
    end
end)

-- 💰 THREAD 3: AUTO SELL
task.spawn(function()
    local lastSellTime = 0
    
    while true do
        task.wait(1)
        if not _G.AutoSell then continue end
        
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then continue end
        local sellGasUI = playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("SellGas")
        if not sellGasUI then continue end
        
        local currentPriceLabel = sellGasUI:FindFirstChild("CurrentPrice")
        if not currentPriceLabel then continue end
        
        local priceValueStr = string.match(currentPriceLabel.Text, "%$(%d+)")
        if not priceValueStr then continue end
        
        local currentPrice = tonumber(priceValueStr)
        
        -- JUAL HANYA JIKA HARGA MENCAPAI TARGET GUI
        if currentPrice >= _G.MinSellPrice and (tick() - lastSellTime > 15) then
            while isTeleporting do task.wait(0.5) end
            
            if sellRemote and sellPrompt and sellPrompt.Parent then
                isTeleporting = true
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local originalPos = hrp and hrp.CFrame
                
                if hrp then
                    teleportSafe(sellPrompt.Parent.CFrame * CFrame.new(0, 3, 0))
                    task.wait(0.5) 
                    
                    sellRemote:FireServer()
                    lastSellTime = tick()
                    
                    if originalPos then
                        teleportSafe(originalPos)
                    end
                end
                isTeleporting = false
            end
        end
    end
end)

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
