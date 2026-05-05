--[[
    VANGUARD TITAN: THE DUPE PROTOCOL (V19.0)
    - Logic: Race Condition / Remote Overload.
    - Chức năng: Dual-Position, Fast E, Experimental Dupe.
    - Phím K: Đóng/Mở menu.
]]

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LPlr = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Titan = {
    Pos1 = nil, Pos2 = nil,
    FastE = true, Visible = true,
    DupeMode = false
}

-- 1. HÀM TẠO GUI (CHỐNG LỖI NIL TUYỆT ĐỐI)
local function CreateUI()
    local PlayerGui = LPlr:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("TitanDupe") then PlayerGui.TitanDupe:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "TitanDupe"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 320, 0, 450)
    Main.Position = UDim2.new(0.5, -160, 0.4, -225)
    Main.BackgroundColor3 = Color3.fromRGB(10, 5, 15)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Text = "TITAN • DUPE PROTOCOL"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 20
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
        b.TextSize = 14
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- 4 NÚT TELEPORT CƠ BẢN
    NewBtn("📍 LƯU VỊ TRÍ 1", Color3.fromRGB(40, 40, 60), function()
        Titan.Pos1 = LPlr.Character.HumanoidRootPart.CFrame
    end)
    NewBtn("🚀 TELE VỊ TRÍ 1", Color3.fromRGB(0, 100, 200), function()
        if Titan.Pos1 then LPlr.Character.HumanoidRootPart.CFrame = Titan.Pos1 end
    end)
    NewBtn("📍 LƯU VỊ TRÍ 2", Color3.fromRGB(40, 40, 60), function()
        Titan.Pos2 = LPlr.Character.HumanoidRootPart.CFrame
    end)
    NewBtn("🚀 TELE VỊ TRÍ 2", Color3.fromRGB(0, 150, 100), function()
        if Titan.Pos2 then LPlr.Character.HumanoidRootPart.CFrame = Titan.Pos2 end
    end)

    -- NÚT DUPE (EXPERIMENTAL)
    local DupeBtn = NewBtn("🔥 EXPERIMENTAL DUPE: OFF", Color3.fromRGB(150, 0, 0), function()
        Titan.DupeMode = not Titan.DupeMode
    end)

    -- 2. LOGIC ÉP LỆNH (DUPE ENGINE)
    RunService.Heartbeat:Connect(function()
        DupeBtn.Text = "🔥 EXPERIMENTAL DUPE: " .. (Titan.DupeMode and "ON" or "OFF")
        
        -- FAST E
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

        -- DUPE ATTEMPT (Sử dụng Remote của ông)
        if Titan.DupeMode then
            local confirm = RS:FindFirstChild("TradeConfirm") or (RS:FindFirstChild("Events") and RS.Events:FindFirstChild("TradeConfirm"))
            local update = RS:FindFirstChild("TradeUpdate") or (RS:FindFirstChild("Events") and RS.Events:FindFirstChild("TradeUpdate"))
            
            if confirm and update then
                -- Nã đồng thời Confirm và Update để làm loạn Logic Server
                confirm:FireServer(true)
                update:FireServer(false) -- Gửi lệnh cập nhật sai lệch
                -- Thử tự hủy nhân vật để ngắt kết nối vật lý nhưng giữ kết nối Remote
                -- LPlr.Character:BreakJoints() 
            end
        end
    end)

    -- PHÍM K TOGGLE
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.K then
            Titan.Visible = not Titan.Visible
            Main.Visible = Titan.Visible
        end
    end)
end

task.spawn(function() pcall(CreateUI) end)
