--[[ 
    BRAINROT CUSTOM V5 - OPTIMIZED
    Khắc phục lỗi F9 và Tối ưu Speed/Pick E
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Tạo GUI trực tiếp vào PlayerGui để tránh lỗi quyền truy cập CoreGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Brainrot_V5"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Khung Menu
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 230, 0, 200)
Main.Position = UDim2.new(0.5, -115, 0.4, -100)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "BRAINROT ULTIMATE V5"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Main

-- BIẾN HỆ THỐNG
local TargetSpeed = 16
local SmartPickEnabled = false
local PickRange = 30 

-- PHẦN SPEED (THANH KÉO)
local SpeedText = Instance.new("TextLabel")
SpeedText.Size = UDim2.new(1, 0, 0, 25)
SpeedText.Position = UDim2.new(0, 0, 0, 40)
SpeedText.Text = "Tốc độ: 16"
SpeedText.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedText.BackgroundTransparency = 1
SpeedText.Parent = Main

local SliderBack = Instance.new("Frame")
SliderBack.Size = UDim2.new(0, 180, 0, 10)
SliderBack.Position = UDim2.new(0.5, -90, 0, 70)
SliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderBack.Parent = Main

local SliderBtn = Instance.new("TextButton")
SliderBtn.Size = UDim2.new(0, 15, 0, 20)
SliderBtn.Position = UDim2.new(0, 0, 0.5, -10)
SliderBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
SliderBtn.Text = ""
SliderBtn.Parent = SliderBack

-- Logic Slider
local dragging = false
SliderBtn.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp(input.Position.X - SliderBack.AbsolutePosition.X, 0, SliderBack.AbsoluteSize.X)
        local percent = relativeX / SliderBack.AbsoluteSize.X
        SliderBtn.Position = UDim2.new(percent, -7, 0.5, -10)
        TargetSpeed = math.floor(16 + (percent * 134)) -- Max 150
        SpeedText.Text = "Tốc độ: " .. TargetSpeed
    end
end)

-- Ép Speed (Dùng Stepped để bypass chống hack cơ bản)
RunService.Stepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = TargetSpeed
        end
    end)
end)

-- PHẦN SMART PICK E
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 180, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -90, 0, 110)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ToggleBtn.Text = "Smart Pick E: TẮT"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = Main

ToggleBtn.MouseButton1Click:Connect(function()
    SmartPickEnabled = not SmartPickEnabled
    ToggleBtn.Text = SmartPickEnabled and "Smart Pick E: BẬT" or "Smart Pick E: TẮT"
    ToggleBtn.BackgroundColor3 = SmartPickEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
end)

-- Logic Pick E tối ưu (Dùng ProximityPromptService)
task.spawn(function()
    while true do
        if SmartPickEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Quét tất cả Prompt đang có trong game (Rất nhẹ)
                    for _, prompt in pairs(ProximityPromptService:GetProximityPrompts()) do
                        local parentPart = prompt.Parent
                        if parentPart and parentPart:IsA("BasePart") then
                            local distance = (parentPart.Position - root.Position).Magnitude
                            if distance <= PickRange then
                                prompt.HoldDuration = 0 -- Nhặt ngay lập tức
                            else
                                -- Nếu ở xa thì trả lại mặc định để tránh lỗi game
                                prompt.HoldDuration = 2 
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.5) -- Quét mỗi 0.5 giây để không lag
    end
end)

print("Brainrot Custom V5 đã tải thành công!")
