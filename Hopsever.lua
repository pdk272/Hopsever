--[[ 
    BRAINROT V8 - FINAL POLISH (XENO PC)
    - Fix Speed 30 chuẩn (không bị chết)
    - Fix Pick E 0s (ép server nhận lệnh ngay)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer

-- Xóa GUI cũ
if LocalPlayer.PlayerGui:FindFirstChild("Brainrot_V8") then
    LocalPlayer.PlayerGui.Brainrot_V8:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Brainrot_V8"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 240, 0, 200)
Main.Position = UDim2.new(0.5, -120, 0.4, -100)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Draggable = true
Main.Active = true
Main.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "BRAINROT V8 - CHUẨN 30"
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Main

-- --- LOGIC SPEED 30 (Dịch chuyển bù trừ) ---
local CurrentSpeed = 16
local SpeedDisplay = Instance.new("TextLabel")
SpeedDisplay.Size = UDim2.new(1, 0, 0, 30)
SpeedDisplay.Position = UDim2.new(0, 0, 0, 40)
SpeedDisplay.Text = "Tốc độ hiện tại: 16"
SpeedDisplay.TextColor3 = Color3.fromRGB(255, 255, 0)
SpeedDisplay.BackgroundTransparency = 1
SpeedDisplay.Parent = Main

-- Thanh kéo Speed
local Slider = Instance.new("TextButton")
Slider.Size = UDim2.new(0, 200, 0, 10)
Slider.Position = UDim2.new(0.5, -100, 0, 75)
Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Slider.Text = ""
Slider.Parent = Main

local Fill = Instance.new("Frame")
Fill.Size = UDim2.new(0.1, 0, 1, 0)
Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
Fill.Parent = Slider

Slider.MouseButton1Down:Connect(function()
    local connection
    connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            CurrentSpeed = math.floor(16 + (percent * 84)) -- Range từ 16 đến 100
            SpeedDisplay.Text = "Tốc độ hiện tại: " .. CurrentSpeed
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then connection:Disconnect() end
    end)
end)

-- Vòng lặp Speed mượt (Cân chỉnh để không bị Anti-cheat giết)
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            -- Công thức tính toán: Chỉ bù trừ phần tốc độ dư ra so với 16
            local extraSpeed = (CurrentSpeed - 16) / 50 
            root.CFrame = root.CFrame + (hum.MoveDirection * extraSpeed)
        end
    end)
end)

-- --- LOGIC PICK E SIÊU TỐC (0 GIÂY) ---
local AutoPick = false
local PickBtn = Instance.new("TextButton")
PickBtn.Size = UDim2.new(0, 200, 0, 50)
PickBtn.Position = UDim2.new(0.5, -100, 0, 110)
PickBtn.Text = "Smart Pick E: TẮT"
PickBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
PickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PickBtn.Parent = Main

PickBtn.MouseButton1Click:Connect(function()
    AutoPick = not AutoPick
    PickBtn.Text = AutoPick and "Smart Pick E: BẬT" or "Smart Pick E: TẮT"
    PickBtn.BackgroundColor3 = AutoPick and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- Ép HoldDuration về 0 liên tục (Fix lỗi game hồi phục lại 2s)
RunService.Heartbeat:Connect(function()
    if AutoPick then
        for _, prompt in pairs(ProximityPromptService:GetProximityPrompts()) do
            local dist = (prompt.Parent:IsA("BasePart") and (prompt.Parent.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 100
            if dist < 20 then
                prompt.HoldDuration = 0
                -- Thử kích hoạt ngay nếu Xeno hỗ trợ lệnh fire
                if fireproximityprompt then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end)

print("V8 đã tối ưu cho Xeno PC. Hãy thử kéo Speed lên mức 30!")
