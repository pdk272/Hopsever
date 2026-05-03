--[[ 
    BRAINROT V9 - FAST STEAL EDITION
    - Menu không mất khi chết (ResetOnSpawn = false)
    - Fast Steal (Bỏ qua 2s giữ phím E)
    - Calibrated Speed 30 (Chuẩn, không giật, không chết)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer

-- HÀM TẠO GUI KHÔNG MẤT KHI CHẾT
local function CreateUI()
    if LocalPlayer.PlayerGui:FindFirstChild("Brainrot_V9") then
        LocalPlayer.PlayerGui.Brainrot_V9:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Brainrot_V9"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false -- Cực kỳ quan trọng: Menu sẽ không mất khi bạn chết

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 240, 0, 180)
    Main.Position = UDim2.new(0.5, -120, 0.4, -90)
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Text = "FAST STEAL - V9"
    Title.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Parent = Main

    -- --- LOGIC SPEED 30 (CALIBRATED) ---
    local SpeedValue = 16
    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
    SpeedLabel.Position = UDim2.new(0, 0, 0, 40)
    SpeedLabel.Text = "Speed: 16"
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
    Fill.Size = UDim2.new(0.1, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
    Fill.Parent = Slider

    Slider.MouseButton1Down:Connect(function()
        local move = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                SpeedValue = 16 + (percent * 40) -- Max là 56 để an toàn
                SpeedLabel.Text = "Speed: " .. math.floor(SpeedValue)
            end
        end)
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
        end)
    end)

    -- Vòng lặp Speed (Dùng công thức bù trừ cực nhẹ để không chết)
    RunService.Heartbeat:Connect(function()
        pcall(function()
            local root = LocalPlayer.Character.HumanoidRootPart
            local hum = LocalPlayer.Character.Humanoid
            if hum.MoveDirection.Magnitude > 0 then
                -- Công thức này giúp Speed 30 mượt như hack xịn
                root.CFrame = root.CFrame + (hum.MoveDirection * (SpeedValue - 16) * 0.015)
            end
        end)
    end)

    -- --- LOGIC FAST STEAL (PICK E NGAY LẬP TỨC) ---
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

    -- Cơ chế Fast Steal: Tự động hoàn thành HoldDuration
    ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        if FastStealActive then
            -- Khi bạn vừa chạm vào nút E, script sẽ ra lệnh cho game là "đã giữ đủ thời gian"
            fireproximityprompt(prompt) -- Lệnh tối thượng trên Xeno
            prompt:InputBegan()
            task.wait()
            prompt:InputEnded()
        end
    end)
end

CreateUI()
print("V9 Fast Steal đã sẵn sàng! Chết cũng không mất Menu.")
