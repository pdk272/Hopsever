--[[
    VANGUARD TITAN: CHRONICLE V16.1 (FIXED)
    - Fix: Lỗi "a nil value" khi khởi động.
    - Feature: Save/TP Position 1 & 2.
    - Interaction: Instant E (FireProximityPrompt).
    - Keybind: K (Toggle Menu).
]]

local function Initialize()
    local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
    local LPlr = Services.Players.LocalPlayer
    local PlayerGui = LPlr:WaitForChild("PlayerGui")
    local RunService = Services.RunService
    local UIS = Services.UserInputService

    local Titan = {
        Pos1 = nil,
        Pos2 = nil,
        FastE = true,
        Visible = true,
        Accent = Color3.fromRGB(0, 255, 255)
    }

    -- 1. TẠO GUI (BỌC TRONG PCALL ĐỂ TRÁNH NIL)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TitanChronicleFixed"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 350, 0, 380)
    Main.Position = UDim2.new(0.5, -175, 0.4, -190)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
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
    Container.CanvasSize = UDim2.new(0, 0, 1.3, 0)
    Container.ScrollBarThickness = 0
    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 10)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- 2. UTILS
    local function CreateBtn(txt, color, callback)
        local b = Instance.new("TextButton", Container)
        b.Size = UDim2.new(0.9, 0, 0, 45)
        b.BackgroundColor3 = color
        b.Text = txt
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamSemibold
        b.TextSize = 14
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- 3. CHỨC NĂNG
    CreateBtn("📍 LƯU VỊ TRÍ 1 (BASE)", Color3.fromRGB(30, 30, 50), function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then Titan.Pos1 = hrp.CFrame print("Lưu P1") end
    end)

    CreateBtn("🚀 BAY ĐẾN VỊ TRÍ 1", Color3.fromRGB(0, 100, 200), function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Titan.Pos1 then hrp.CFrame = Titan.Pos1 end
    end)

    local Sep = Instance.new("Frame", Container)
    Sep.Size = UDim2.new(0.9, 0, 0, 2)
    Sep.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Sep.BorderSizePixel = 0

    CreateBtn("📍 LƯU VỊ TRÍ 2 (PET)", Color3.fromRGB(30, 30, 50), function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then Titan.Pos2 = hrp.CFrame print("Lưu P2") end
    end)

    CreateBtn("🚀 BAY ĐẾN VỊ TRÍ 2", Color3.fromRGB(0, 150, 100), function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Titan.Pos2 then hrp.CFrame = Titan.Pos2 end
    end)

    local EToggle = CreateBtn("⚡ AUTO FAST E: ON", Color3.fromRGB(40, 40, 60), function()
        Titan.FastE = not Titan.FastE
    end)

    -- 4. LOGIC ENGINE
    RunService.Heartbeat:Connect(function()
        EToggle.Text = "⚡ AUTO FAST E: " .. (Titan.FastE and "ON" or "OFF")
        EToggle.TextColor3 = Titan.FastE and Titan.Accent or Color3.new(0.5,0.5,0.5)

        if Titan.FastE then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    if LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LPlr.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                        if dist <= v.MaxActivationDistance then
                            -- Ép tương tác
                            if fireproximityprompt then fireproximityprompt(v) else
                                v:InputHoldBegin() task.wait() v:InputHoldEnd()
                            end
                        end
                    end
                end
            end
        end
    end)

    -- TOGGLE PHÍM K
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.K then
            Titan.Visible = not Titan.Visible
            Main.Visible = Titan.Visible
        end
    end)

    -- DRAGGABLE
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- Chạy script với pcall bảo vệ
local success, err = pcall(Initialize)
if not success then
    warn("Titan Chronicle Error: " .. tostring(err))
end
