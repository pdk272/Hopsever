--[[
    VANGUARD TITAN: VOID SYNC (V23.0)
    - Game: Steal a Brainrot / Pet Steal Edition
    - Logic: Packet Collision (Va chạm gói tin 0ms)
    - 4 Nút: Save 1, TP 1, Save 2, TP 2
    - Interaction: Instant E (0s Hold) + K-Toggle
]]

-- 1. BỘ KHỞI TẠO BẢO MẬT (CHỐNG LỖI NIL)
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LPlr = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Titan = {
    Pos1 = nil, Pos2 = nil,
    Visible = true, FastE = true
}

-- 2. HÀM TẠO GUI (CELESTIAL DESIGN)
local function CreateUI()
    local PlayerGui = LPlr:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("TitanVoid") then PlayerGui.TitanVoid:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "TitanVoid"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 320, 0, 420)
    Main.Position = UDim2.new(0.5, -160, 0.4, -210)
    Main.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "TITAN • VOID SYNC V23"
    Title.TextColor3 = Color3.new(0, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.BackgroundTransparency = 1

    local List = Instance.new("UIListLayout", Main)
    List.Padding = UDim.new(0, 10)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", Main).PaddingTop = UDim.new(0, 60)

    local function NewBtn(text, color, callback)
        local b = Instance.new("TextButton", Main)
        b.Size = UDim2.new(0.9, 0, 0, 45)
        b.BackgroundColor3 = color
        b.Text = text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(callback)
    end

    -- 4 NÚT QUẢN LÝ VỊ TRÍ THEO YÊU CẦU
    NewBtn("1. LƯU VỊ TRÍ 1 (BASE)", Color3.fromRGB(30, 30, 45), function()
        if LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
            Titan.Pos1 = LPlr.Character.HumanoidRootPart.CFrame
        end
    end)

    NewBtn("2. BAY VỀ VỊ TRÍ 1", Color3.fromRGB(0, 100, 200), function()
        if Titan.Pos1 and LPlr.Character then LPlr.Character.HumanoidRootPart.CFrame = Titan.Pos1 end
    end)

    NewBtn("3. LƯU VỊ TRÍ 2 (PET)", Color3.fromRGB(30, 30, 45), function()
        if LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
            Titan.Pos2 = LPlr.Character.HumanoidRootPart.CFrame
        end
    end)

    NewBtn("4. BAY VỀ VỊ TRÍ 2", Color3.fromRGB(0, 150, 100), function()
        if Titan.Pos2 and LPlr.Character then LPlr.Character.HumanoidRootPart.CFrame = Titan.Pos2 end
    end)

    -- NÚT DUPE "TƯ DUY CAO" - VOID SYNC
    NewBtn("🌀 VOID SYNC (DUPE NOW)", Color3.fromRGB(150, 0, 255), function()
        local confirm = RS:FindFirstChild("TradeConfirm") or (RS:FindFirstChild("Events") and RS.Events:FindFirstChild("TradeConfirm"))
        local update = RS:FindFirstChild("TradeUpdate") or (RS:FindFirstChild("Events") and RS.Events:FindFirstChild("TradeUpdate"))
        
        -- THỰC THI 3 LỆNH TRONG CÙNG 1 MICRO-GIÂY
        task.spawn(function()
            if confirm then confirm:FireServer(true) end
            if update then update:FireServer(true) end
            
            -- Ép lệnh Gift (E) ngay lập tức
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and (LPlr.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude <= 25 then
                    if fireproximityprompt then fireproximityprompt(v) end
                end
            end
        end)
        print("⚡ VOID SYNC EXECUTED!")
    end)

    -- 3. LOGIC FAST E (0S HOLD)
    RunService.Heartbeat:Connect(function()
        if Titan.FastE then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0 -- Triệt tiêu 1 giây chờ
                    if LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LPlr.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                        if dist <= v.MaxActivationDistance then
                            if fireproximityprompt then fireproximityprompt(v) end
                        end
                    end
                end
            end
        end
    end)

    -- PHÍM K ĐÓNG MỞ
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.K then
            Titan.Visible = not Titan.Visible
            Main.Visible = Titan.Visible
        end
    end)
end

-- Khởi động an toàn với pcall
task.spawn(function()
    local ok, err = pcall(CreateUI)
    if not ok then warn("Titan V23 Error: " .. tostring(err)) end
end)
