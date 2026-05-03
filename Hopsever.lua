-- Tạo Folder chứa GUI để tránh bị xóa khi Reset nhân vật
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedBtn = Instance.new("TextButton")
local FastPickBtn = Instance.new("TextButton")
local HopBtn = Instance.new("TextButton")

-- Cấu hình ScreenGui
ScreenGui.Name = "BrainrotCustom"
ScreenGui.Parent = game.CoreGui -- Đưa vào CoreGui để bảo mật hơn
ScreenGui.ResetOnSpawn = false

-- Cấu hình Khung Menu (MainFrame)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true -- Bạn có thể kéo menu đi khắp màn hình

-- Tiêu đề
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BRAINROT PRO V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

-- Biến điều khiển
local SpeedActive = false
local FastPickActive = false

-- Nút Speed (Bật/Tắt Speed 30)
SpeedBtn.Name = "SpeedBtn"
SpeedBtn.Parent = MainFrame
SpeedBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
SpeedBtn.Size = UDim2.new(0.9, 0, 0, 40)
SpeedBtn.Text = "Speed: OFF"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedActive = not SpeedActive
    if SpeedActive then
        SpeedBtn.Text = "Speed: ON (30)"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        SpeedBtn.Text = "Speed: OFF"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Vòng lặp Speed
game:GetService("RunService").RenderStepped:Connect(function()
    if SpeedActive then
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 30
        end)
    end
end)

-- Nút Fast Pick (Giữ E 0s)
FastPickBtn.Name = "FastPickBtn"
FastPickBtn.Parent = MainFrame
FastPickBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
FastPickBtn.Size = UDim2.new(0.9, 0, 0, 40)
FastPickBtn.Text = "Fast Pick: OFF"
FastPickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

FastPickBtn.MouseButton1Click:Connect(function()
    FastPickActive = not FastPickActive
    if FastPickActive then
        FastPickBtn.Text = "Fast Pick: ON"
        FastPickBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        FastPickBtn.Text = "Fast Pick: OFF"
        FastPickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- Vòng lặp Fast Pick (Quét ProximityPrompt)
spawn(function()
    while true do
        if FastPickActive then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                end
            end
        end
        task.wait(1)
    end
end)

-- Nút Server Hop
HopBtn.Name = "HopBtn"
HopBtn.Parent = MainFrame
HopBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
HopBtn.Size = UDim2.new(0.9, 0, 0, 40)
HopBtn.Text = "Server Hop"
HopBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

HopBtn.MouseButton1Click:Connect(function()
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

print("GUI của con ba đã sẵn sàng!")
