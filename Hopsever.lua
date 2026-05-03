--[[ 
    BRAINROT V12 - XENO STABLE EDITION
    - Safe Velocity Speed (Không bị chết ở 15-17)
    - Ultra Fast Steal (Ép 0s liên tục)
    - Auto-Reset UI Fix
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer

-- UI KHÔNG MẤT KHI CHẾT
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Brainrot_V12"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 240, 0, 180)
Main.Position = UDim2.new(0.5, -120, 0.4, -90)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "STABLE BYPASS V12"
Title.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Parent = Main

-- --- SAFE SPEED (DÙNG VELOCITY) ---
local SpeedValue = 16
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 40)
SpeedLabel.Text = "Speed: 16 (An Toàn)"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Parent = Main

local Slider = Instance.new("TextButton")
Slider.Size = UDim2.new(0, 200, 0, 10)
Slider.Position = UDim2.new(0.5, -100, 0, 75)
Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Slider.Text = ""
Slider.Parent = Main

local Fill = Instance.new("Frame")
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Fill.Parent = Slider

Slider.MouseButton1Down:Connect(function()
    local move = game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            SpeedValue = 16 + (percent * 34) -- Max 50, kéo lên 30 là vừa đẹp
            SpeedLabel.Text = "Speed: " .. math.floor(SpeedValue)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end)
end)

-- Vòng lặp vật lý để tăng tốc (Không gây "dead")
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            -- Thay vì cộng CFrame, ta cộng một lượng nhỏ Velocity vào hướng di chuyển
            root.Velocity = Vector3.new(hum.MoveDirection.X * SpeedValue, root.Velocity.Y, hum.MoveDirection.Z * SpeedValue)
        end
    end)
end)

-- --- FAST STEAL (ÉP 0 GIÂY LIÊN TỤC) ---
local FastStealActive = false
local StealBtn = Instance.new("TextButton")
StealBtn.Size = UDim2.new(0, 200, 0, 50)
StealBtn.Position = UDim2.new(0.5, -100, 0, 110)
StealBtn.Text = "Fast Steal: TẮT"
StealBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
StealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StealBtn.Parent = Main

StealBtn.MouseButton1Click:Connect(function()
    FastStealActive = not FastStealActive
    StealBtn.Text = FastStealActive and "Fast Steal: BẬT" or "Fast Steal: TẮT"
    StealBtn.BackgroundColor3 = FastStealActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- Quét và ép 0 giây liên tục mỗi khi có Prompt xuất hiện
task.spawn(function()
    while true do
        if FastStealActive then
            pcall(function()
                for _, prompt in pairs(game:GetService("ProximityPromptService"):GetProximityPrompts()) do
                    prompt.HoldDuration = 0
                end
            end)
        end
        task.wait(0.1) -- Quét cực nhanh 10 lần mỗi giây
    end
end)

-- Tự động kích hoạt khi bắt đầu giữ (Dành cho Xeno PC)
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if FastStealActive then
        fireproximityprompt(prompt)
    end
end)
