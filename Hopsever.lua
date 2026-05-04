--[[
    VANGUARD TITAN: POSITION CHRONICLE (V16.0)
    - Feature: Dual-Position Memory (Lưu & Teleport)
    - Interaction: Instant E Trigger (Ép tương tác 0s)
    - Keybind: K (Open/Close Menu)
    - Theme: Deep Space Nebula
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LPlr = Services.Players.LocalPlayer
local RunService = Services.RunService
local UIS = Services.UserInputService

local Titan = {
    Pos1 = nil,
    Pos2 = nil,
    FastE = true,
    Visible = true,
    Accent = Color3.fromRGB(0, 255, 255)
}

-- 1. GUI CONSTRUCTION (CELESTIAL DESIGN)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
ScreenGui.Name = "TitanChronicle"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 380)
Main.Position = UDim2.new(0.5, -175, 0.4, -190)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "TITAN • CHRONICLE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(0.9, 0, 0.8, 0)
Container.Position = UDim2.new(0.05, 0, 0.18, 0)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.2, 0)
Container.ScrollBarThickness = 0
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

-- 2. UI UTILS
local function CreateButton(text, color, callback)
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, 0, 0, 45)
    Btn.BackgroundColor3 = color
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- 3. CHỨC NĂNG LƯU & TELEPORT
CreateButton("📍 LƯU VỊ TRÍ 1 (BASE)", Color3.fromRGB(30, 30, 50), function()
    local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        Titan.Pos1 = hrp.CFrame
        print("🌌 Đã lưu vị trí 1")
    end
end)

CreateButton("🚀 BAY ĐẾN VỊ TRÍ 1", Color3.fromRGB(0, 100, 200), function()
    local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
    if hrp and Titan.Pos1 then
        hrp.CFrame = Titan.Pos1
    end
end)

Instance.new("Frame", Container).Size = UDim2.new(1, 0, 0, 2).BackgroundColor3 = Color3.new(1,1,1)

CreateButton("📍 LƯU VỊ TRÍ 2 (PET)", Color3.fromRGB(30, 30, 50), function()
    local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        Titan.Pos2 = hrp.CFrame
        print("🌌 Đã lưu vị trí 2")
    end
end)

CreateButton("🚀 BAY ĐẾN VỊ TRÍ 2", Color3.fromRGB(0, 150, 100), function()
    local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
    if hrp and Titan.Pos2 then
        hrp.CFrame = Titan.Pos2
    end
end)

local EToggle = CreateButton("⚡ AUTO FAST E: ON", Color3.fromRGB(40, 40, 60), function() end)
EToggle.MouseButton1Click:Connect(function()
    Titan.FastE = not Titan.FastE
    EToggle.Text = "⚡ AUTO FAST E: " .. (Titan.FastE and "ON" or "OFF")
    EToggle.TextColor3 = Titan.FastE and Titan.Accent or Color3.new(0.5, 0.5, 0.5)
end)

-- 4. CORE ENGINE (FAST INTERACT & TOGGLE)

-- Ép E nhanh nhất có thể
RunService.Stepped:Connect(function()
    if Titan.FastE then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0 -- Không cần đợi
                v.MaxActivationDistance = 20 -- Tăng tầm với
                -- Ép kích hoạt nếu ở gần
                if LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LPlr.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                    if dist <= v.MaxActivationDistance then
                        fireproximityprompt(v) -- Lệnh ép nổ E của các Executor xịn
                    end
                end
            end
        end
    end
end)

-- Đóng mở Menu phím K
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then
        Titan.Visible = not Titan.Visible
        Main.Visible = Titan.Visible
    end
end)

-- Draggable
local dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragStart = nil end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("🌌 TITAN CHRONICLE V16.0 LOADED. Phím K để đóng/mở.")
