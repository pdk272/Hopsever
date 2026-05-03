--[[ 
    BRAINROT V7 - XENO PC EDITION
    - CFrame Speed (Bypass Anti-cheat PC)
    - Smart Pick E (Chỉ vật phẩm ở gần, không lag)
    - Slider giao diện mượt mà
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Kiểm tra và xóa GUI cũ nếu có
if LocalPlayer.PlayerGui:FindFirstChild("Brainrot_Xeno") then
    LocalPlayer.PlayerGui.Brainrot_Xeno:Destroy()
end

-- TẠO GIAO DIỆN
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Brainrot_Xeno"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 250, 0, 220)
Main.Position = UDim2.new(0.5, -125, 0.4, -110)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- Bo góc cho đẹp
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "BRAINROT XENO V7"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

-- --- PHẦN SPEED (THANH KÉO) ---
local SpeedValue = 0 -- 0 là tắt, > 0 là tốc độ thêm vào
local SpeedText = Instance.new("TextLabel")
SpeedText.Size = UDim2.new(1, 0, 0, 20)
SpeedText.Position = UDim2.new(0, 0, 0, 45)
SpeedText.Text = "Tốc độ cộng thêm: 0"
SpeedText.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedText.BackgroundTransparency = 1
SpeedText.Parent = Main

local SliderFrame = Instance.new("TextButton")
SliderFrame.Size = UDim2.new(0, 200, 0, 10)
SliderFrame.Position = UDim2.new(0.5, -100, 0, 75)
SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderFrame.Text = ""
SliderFrame.Parent = Main

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
SliderFill.Parent = SliderFrame

-- Logic Slider
local isDragging = false
SliderFrame.MouseButton1Down:Connect(function() isDragging = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation().X
        local framePos = SliderFrame.AbsolutePosition.X
        local frameSize = SliderFrame.AbsoluteSize.X
        local percent = math.clamp((mousePos - framePos) / frameSize, 0, 1)
        
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SpeedValue = percent * 2 -- Chỉnh độ nhạy Speed tại đây
        SpeedText.Text = "Tốc độ cộng thêm: " .. math.floor(percent * 100)
    end
end)

-- Vòng lặp CFrame Speed (Bypass chống hack PC)
RunService.RenderStepped:Connect(function()
    if SpeedValue > 0 then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * SpeedValue)
        end
    end
end)

-- --- PHẦN SMART PICK E (PHẠM VI GẦN) ---
local AutoPick = false
local PickBtn = Instance.new("TextButton")
PickBtn.Size = UDim2.new(0, 200, 0, 45)
PickBtn.Position = UDim2.new(0.5, -100, 0, 110)
PickBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
PickBtn.Text = "Smart Pick E: TẮT"
PickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PickBtn.Font = Enum.Font.GothamBold
PickBtn.Parent = Main

PickBtn.MouseButton1Click:Connect(function()
    AutoPick = not AutoPick
    PickBtn.Text = AutoPick and "Smart Pick E: BẬT" or "Smart Pick E: TẮT"
    PickBtn.BackgroundColor3 = AutoPick and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
end)

-- Vòng lặp nhặt đồ (Tối ưu cho Xeno)
task.spawn(function()
    while task.wait(0.1) do
        if AutoPick then
            pcall(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, prompt in pairs(ProximityPromptService:GetProximityPrompts()) do
                        local part = prompt.Parent
                        if part and part:IsA("BasePart") then
                            local dist = (part.Position - root.Position).Magnitude
                            if dist <= 25 then -- Chỉ nhặt trong bán kính 25m
                                -- Lệnh đặc biệt dành cho các Executor như Xeno
                                if fireproximityprompt then
                                    fireproximityprompt(prompt, 1, true)
                                else
                                    prompt.HoldDuration = 0
                                    prompt:InputBegan()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

print("V7 đã sẵn sàng trên Xeno PC!")
