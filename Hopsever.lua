--[[
    Script: Steal a Brainrot Custom
    Author: [Tientaidabanh06]
    Tính năng: Speed, Fast Pick, Server Hop, GUI Đẹp
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-up-editor/main/mopped-hub"))() -- Load một thư viện GUI mẫu đẹp
local Window = Library:CreateWindow("Brainrot Pro")

-- BIẾN CẤU HÌNH
local SpeedValue = 30
local FastPickEnabled = false

-- TAB CHÍNH
local Main = Window:CreateTab("Tính Năng")

-- 1. TỐC ĐỘ (Speed 30 không bị Tele)
Main:CreateSlider("WalkSpeed", 16, 100, 30, function(v)
    SpeedValue = v
end)

game:GetService("RunService").Stepped:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
    end
end)

-- 2. PICK E SIÊU NHANH (Fast Interaction)
Main:CreateToggle("Pick E Nhanh", function(state)
    FastPickEnabled = state
    if state then
        -- Vòng lặp quét tất cả các nút E trong game
        spawn(function()
            while FastPickEnabled do
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        v.HoldDuration = 0 -- Chỉnh thời gian giữ từ 2s về 0s
                    end
                end
                wait(1)
            end
        end)
    end
end)

-- 3. SERVER HOP (Chuyển Server nhanh)
local ServerTab = Window:CreateTab("Hệ Thống")
ServerTab:CreateButton("Server Hop (Nhanh)", function()
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
end)

-- THÔNG BÁO
print("Script đã sẵn sàng! Chúc bạn chơi game vui vẻ.")
