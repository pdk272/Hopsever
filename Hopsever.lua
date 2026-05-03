-- CẤU HÌNH GIAO DIỆN SIÊU AN TOÀN
local CoreGui = pcall(function() return gethui() end) and gethui() or game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Brainrot_V6_Bypass"

-- Thử đưa GUI vào CoreGui (An toàn nhất), nếu lỗi thì đưa vào PlayerGui
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

-- TẠO MENU CHÍNH
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 180)
Main.Position = UDim2.new(0.5, -110, 0.4, -90)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 0, 255)
Title.Text = "V6 - CFRAME BYPASS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.Parent = Main

-- BIẾN HỆ THỐNG
local SpeedMultiplier = 0
local SmartPick = false

-- NÚT SPEED (CFrame)
local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Size = UDim2.new(0, 200, 0, 45)
SpeedToggle.Position = UDim2.new(0, 10, 0, 45)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
SpeedToggle.Text = "CFrame Speed: TẮT"
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggle.Font = Enum.Font.SourceSansBold
SpeedToggle.TextSize = 18
SpeedToggle.Parent = Main

SpeedToggle.MouseButton1Click:Connect(function()
    if SpeedMultiplier == 0 then
        SpeedMultiplier = 0.5 -- Độ phóng tới trước (Chỉnh số này nếu muốn nhanh hơn, ví dụ 1.0)
        SpeedToggle.Text = "CFrame Speed: BẬT"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
    else
        SpeedMultiplier = 0
        SpeedToggle.Text = "CFrame Speed: TẮT"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
    end
end)

-- VÒNG LẶP ÉP CFRAME SPEED (Chống mọi Anti-cheat)
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

RunService.RenderStepped:Connect(function()
    if SpeedMultiplier > 0 then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        -- Nếu nhân vật đang sống và đang di chuyển (bấm W, A, S, D)
        if char and hum and root and hum.Health > 0 and hum.MoveDirection.Magnitude > 0 then
            -- Liên tục đẩy nhân vật tới trước dựa trên hướng di chuyển
            root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMultiplier)
        end
    end
end)

-- NÚT SMART PICK E
local PickToggle = Instance.new("TextButton")
PickToggle.Size = UDim2.new(0, 200, 0, 45)
PickToggle.Position = UDim2.new(0, 10, 0, 105)
PickToggle.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
PickToggle.Text = "Auto Pick E: TẮT"
PickToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
PickToggle.Font = Enum.Font.SourceSansBold
PickToggle.TextSize = 18
PickToggle.Parent = Main

PickToggle.MouseButton1Click:Connect(function()
    SmartPick = not SmartPick
    if SmartPick then
        PickToggle.Text = "Auto Pick E: BẬT"
        PickToggle.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
    else
        PickToggle.Text = "Auto Pick E: TẮT"
        PickToggle.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
    end
end)

-- VÒNG LẶP PICK E (Dùng lệnh fireproximityprompt cao cấp)
task.spawn(function()
    while task.wait(0.1) do
        if SmartPick then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, prompt in pairs(game:GetService("ProximityPromptService"):GetProximityPrompts()) do
                        local part = prompt.Parent
                        if part and part:IsA("BasePart") then
                            -- Chỉ nhặt những vật cách 20 mét
                            if (part.Position - root.Position).Magnitude <= 20 then
                                -- Dùng lệnh Exploit để ép kích hoạt ngay lập tức
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

print("V6 CFrame Bypass đã chạy!")
