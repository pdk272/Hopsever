--[[
    VANGUARD TITAN: THE DESYNC ARCHITECT (V20.0)
    - Logic: Simultaneous Execution (Thực thi đồng thời).
    - Mục tiêu: Khắc chế ServerScript bằng Race Condition.
    - Chức năng: Dual-Position, Fast E, Sync Trade-Gift.
]]

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LPlr = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Titan = {
    Pos1 = nil, Pos2 = nil,
    Visible = true, FastE = false,
}

-- 1. GUI (THIẾT KẾ TỐI GIẢN - TẬP TRUNG HIỆU NĂNG)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
ScreenGui.Name = "TitanDesync"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 420)
Main.Position = UDim2.new(0.5, -160, 0.4, -210)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "TITAN • DESYNC ARCHITECT"
Title.TextColor3 = Color3.new(0, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(0.9, 0, 0.8, 0)
Container.Position = UDim2.new(0.05, 0, 0.15, 0)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 0
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 8)

local function NewBtn(text, color, callback)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 42)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- QUẢN LÝ VỊ TRÍ
NewBtn("📍 LƯU VỊ TRÍ 1", Color3.fromRGB(40, 40, 50), function() Titan.Pos1 = LPlr.Character.HumanoidRootPart.CFrame end)
NewBtn("🚀 TELE VỊ TRÍ 1", Color3.fromRGB(0, 120, 255), function() if Titan.Pos1 then LPlr.Character.HumanoidRootPart.CFrame = Titan.Pos1 end end)
NewBtn("📍 LƯU VỊ TRÍ 2", Color3.fromRGB(40, 40, 50), function() Titan.Pos2 = LPlr.Character.HumanoidRootPart.CFrame end)
NewBtn("🚀 TELE VỊ TRÍ 2", Color3.fromRGB(0, 180, 100), function() if Titan.Pos2 then LPlr.Character.HumanoidRootPart.CFrame = Titan.Pos2 end end)

-- NÚT DUPE "TƯ DUY CAO"
NewBtn("🌀 SYNC TRADE-GIFT (DUPE)", Color3.fromRGB(150, 0, 255), function()
    local confirm = RS:FindFirstChild("TradeConfirm") or (RS:FindFirstChild("Events") and RS.Events:FindFirstChild("TradeConfirm"))
    
    -- Thực hiện đồng thời: Confirm Trade + Ép nhấn E để Gift
    if confirm then
        -- Bước 1: Confirm Trade
        confirm:FireServer(true)
        
        -- Bước 2: Quét và nã E ngay lập tức (Gift)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and (LPlr.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude <= 20 then
                if fireproximityprompt then fireproximityprompt(v) end
            end
        end
        print("⚡ Đã nã đồng thời Trade và Gift!")
    end
end)

local EBtn = NewBtn("⚡ FAST E: OFF", Color3.fromRGB(60, 60, 60), function() Titan.FastE = not Titan.FastE end)

-- 2. CORE ENGINE
RunService.Heartbeat:Connect(function()
    EBtn.Text = "⚡ FAST E: " .. (Titan.FastE and "ON" or "OFF")
    EBtn.BackgroundColor3 = Titan.FastE and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(60, 60, 60)
    
    if Titan.FastE then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                if (LPlr.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude <= v.MaxActivationDistance then
                    fireproximityprompt(v)
                end
            end
        end
    end
end)

-- TOGGLE K
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then
        Titan.Visible = not Titan.Visible
        Main.Visible = Titan.Visible
    end
end)

task.spawn(function() pcall(CreateUI) end)
