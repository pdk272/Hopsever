--[[ 
    BRAINROT V13 - ALL IN ONE TESTER
    - Velocity Speed (An Toàn)
    - Fast Steal (Ép 0s)
    - Smart Finder (Dừng ngay khi thấy, báo tên)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer

-- DANH SÁCH PET VIP CỦA BẠN
local TargetPets = {
    ["La Secret Combinasion"] = true,
    ["Lavadorito Spinito"] = true,
    ["Garama and Madundung"] = true,
    ["Ketchuru and Musturu"] = true,
    ["Ketupat Kepat"] = true,
    ["Tang Tang Keletang"] = true,
    ["Tictac Sahur"] = true,
    ["Money Money Puggy"] = true,
    ["Cerberus"] = true,
    ["Money Money Reindeer"] = true,
    ["Pretzo Robo"] = true,
    ["Popcuru and Fizzuru"] = true,
    ["Burguro and Fryuro"] = true,
    ["La Casa Boo"] = true
}

-- XÓA GUI CŨ & TẠO GUI MỚI KHÔNG MẤT KHI CHẾT
if LocalPlayer.PlayerGui:FindFirstChild("Brainrot_V13") then
    LocalPlayer.PlayerGui.Brainrot_V13:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Brainrot_V13"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 260)
Main.Position = UDim2.new(0.5, -130, 0.4, -130)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "BRAINROT V13 - FINDER"
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

-- BẢNG THÔNG BÁO TÌM PET
local LogLabel = Instance.new("TextLabel")
LogLabel.Size = UDim2.new(1, -20, 0, 50)
LogLabel.Position = UDim2.new(0, 10, 0, 40)
LogLabel.Text = "Chưa quét..."
LogLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
LogLabel.BackgroundTransparency = 1
LogLabel.TextWrapped = true
LogLabel.Font = Enum.Font.SourceSansBold
LogLabel.TextSize = 18
LogLabel.Parent = Main

-- --- CHỨC NĂNG TÌM KIẾM (SMART FINDER) ---
local function ScanTarget()
    LogLabel.Text = "Đang quét server..."
    LogLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    task.wait(0.1) -- Tạo độ trễ xíu để UI cập nhật chữ
    
    local foundPetName = nil
    
    -- Quét toàn bộ map
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then
            foundPetName = v.Name
            
            -- Sáng đèn con pet đó
            local hl = v:FindFirstChild("HunterHighlight") or Instance.new("Highlight", v)
            hl.Name = "HunterHighlight"
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            
            -- DỪNG NGAY QUÁ TRÌNH QUÉT (break thoát khỏi vòng lặp)
            break 
        end
    end
    
    if foundPetName then
        LogLabel.Text = "ĐÃ TÌM THẤY:\n" .. foundPetName
        LogLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        -- Tiếng báo động
        local s = Instance.new("Sound", game.Workspace)
        s.SoundId = "rbxassetid://138090596"
        s.Volume = 2
        s:Play()
    else
        LogLabel.Text = "Không có Pet VIP nào ở server này."
        LogLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0, 200, 0, 40)
ScanBtn.Position = UDim2.new(0.5, -100, 0, 95)
ScanBtn.Text = "BẤM ĐỂ QUÉT PET"
ScanBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.Parent = Main
ScanBtn.MouseButton1Click:Connect(ScanTarget)

-- --- CHỨC NĂNG SPEED VÀ FAST STEAL ---
local SpeedValue = 16
local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Size = UDim2.new(0, 200, 0, 30)
SpeedSlider.Position = UDim2.new(0.5, -100, 0, 145)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedSlider.Text = "Speed: 16 (Kéo để tăng)"
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.Parent = Main

local Fill = Instance.new("Frame")
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
Fill.Parent = SpeedSlider

SpeedSlider.MouseButton1Down:Connect(function()
    local move = game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - SpeedSlider.AbsolutePosition.X) / SpeedSlider.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            SpeedValue = 16 + (percent * 34)
            SpeedSlider.Text = "Speed: " .. math.floor(SpeedValue)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end)
end)

-- Vòng lặp Velocity Speed an toàn
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            root.Velocity = Vector3.new(hum.MoveDirection.X * SpeedValue, root.Velocity.Y, hum.MoveDirection.Z * SpeedValue)
        end
    end)
end)

local FastStealBtn = Instance.new("TextButton")
FastStealBtn.Size = UDim2.new(0, 200, 0, 40)
FastStealBtn.Position = UDim2.new(0.5, -100, 0, 185)
FastStealBtn.Text = "Fast Steal: BẬT (Auto)"
FastStealBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
FastStealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FastStealBtn.Font = Enum.Font.GothamBold
FastStealBtn.Parent = Main

-- Fast Steal chạy ngầm và ép lệnh ngay khi chạm nút E
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        prompt.HoldDuration = 0
        prompt:InputBegan()
    end
end)

-- Tự động quét 1 lần ngay khi bật script
task.spawn(function()
    task.wait(1)
    ScanTarget()
end)
