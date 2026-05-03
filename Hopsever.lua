-- Kiểm tra nếu game đã tải xong
if not game:IsLoaded() then game.Loaded:Wait() end

-- Khai báo thư viện Orion Lib (Rất ổn định và đẹp)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tạo Menu Chính
local Window = OrionLib:MakeWindow({Name = "Brainrot Pro V2", HidePremium = false, SaveConfig = true, ConfigFolder = "BrainrotConfig"})

-- BIẾN ĐIỀU KHIỂN
local SpeedValue = 30
local FastPickEnabled = false

-- TAB TÍNH NĂNG
local MainTab = Window:MakeTab({
	Name = "Tính Năng",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- 1. TỐC ĐỘ (Speed 30)
MainTab:AddSlider({
	Name = "Tốc độ chạy",
	Min = 16,
	Max = 100,
	Default = 30,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		SpeedValue = Value
	end    
})

-- Vòng lặp duy trì tốc độ (Giúp không bị giật lùi)
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
        end
    end)
end)

-- 2. PICK E SIÊU NHANH
MainTab:AddToggle({
	Name = "Pick E Siêu Nhanh",
	Default = false,
	Callback = function(Value)
		FastPickEnabled = Value
        if Value then
            spawn(function()
                while FastPickEnabled do
                    for _, v in pairs(game:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then
                            v.HoldDuration = 0
                        end
                    end
                    task.wait(0.5) -- Quét nhanh hơn
                end
            end)
        end
	end    
})

-- TAB HỆ THỐNG (Server Hop)
local SettingsTab = Window:MakeTab({
	Name = "Hệ Thống",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

SettingsTab:AddButton({
	Name = "Server Hop (Tìm phòng mới)",
	Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in pairs(Servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, s.id)
                break
            end
        end
  	end    
})

OrionLib:Init() -- Kích hoạt Menu
