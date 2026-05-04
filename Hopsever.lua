--[[
    VANGUARD TITAN V17.0 - CHRONICLE ULTIMATE
    - Tư duy: Chống lỗi nil, ép tương tác cấp độ cao.
    - 4 Nút: Save 1, TP 1, Save 2, TP 2.
    - Phím K: Đóng/Mở.
]]

-- 1. ĐỢI GAME LOAD (CHỐNG LỖI NIL)
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LPlr = Players.LocalPlayer or Players.PlayerAdded:Wait()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Titan = {
    Pos1 = nil,
    Pos2 = nil,
    Visible = true,
    FastE = true
}

-- 2. HÀM TẠO GUI AN TOÀN
local function CreateUI()
    local PlayerGui = LPlr:WaitForChild("PlayerGui")
    
    -- Xóa bản cũ nếu có
    if PlayerGui:FindFirstChild("TitanUltimate") then 
        PlayerGui.TitanUltimate:Destroy() 
    end

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "TitanUltimate"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 300, 0, 350)
    Main.Position = UDim2.new(0.5, -150, 0.4, -175)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "TITAN • ULTIMATE"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1

    local List = Instance.new("UIListLayout", Main)
    List.Padding = UDim.new(0, 10)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center
    List.SortOrder = Enum.SortOrder.LayoutOrder

    local Padding = Instance.new("UIPadding", Main)
    Padding.PaddingTop = UDim.new(0, 60)

    -- Hàm tạo nút "Đẳng cấp"
    local function NewBtn(text, color, order, callback)
        local b = Instance.new("TextButton", Main)
        b.Size = UDim2.new(0.9, 0, 0, 45)
        b.BackgroundColor3 = color
        b.Text = text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamSemibold
        b.TextSize = 14
        b.LayoutOrder = order
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- 4 NÚT CHIẾN THUẬT
    NewBtn("1. LƯU VỊ TRÍ 1", Color3.fromRGB(40, 40, 60), 1, function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then Titan.Pos1 = hrp.CFrame print("Đã lưu P1") end
    end)

    NewBtn("2. BAY VỀ VỊ TRÍ 1", Color3.fromRGB(0, 120, 255), 2, function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Titan.Pos1 then hrp.CFrame = Titan.Pos1 end
    end)

    NewBtn("3. LƯU VỊ TRÍ 2", Color3.fromRGB(40, 40, 60), 3, function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then Titan.Pos2 = hrp.CFrame print("Đã lưu P2") end
    end)

    NewBtn("4. BAY VỀ VỊ TRÍ 2", Color3.fromRGB(0, 180, 100), 4, function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Titan.Pos2 then hrp.CFrame = Titan.Pos2 end
    end)

    local EBtn = NewBtn("⚡ ÉP NHẤN E: ON", Color3.fromRGB(200, 50, 50), 5, function()
        Titan.FastE = not Titan.FastE
    end)

    -- 3. LOGIC HỆ THỐNG
    
    -- Ép nhấn E cực nhanh (Interaction Engine)
    RunService.Stepped:Connect(function()
        EBtn.Text = "⚡ ÉP NHẤN E: " .. (Titan.FastE and "ON" or "OFF")
        EBtn.BackgroundColor3 = Titan.FastE and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(60, 60, 60)
        
        if Titan.FastE then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    if LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LPlr.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                        if dist <= v.MaxActivationDistance then
                            -- Sử dụng phương thức ép nổ của Executor
                            if fireproximityprompt then
                                fireproximityprompt(v)
                            else
                                v:InputHoldBegin()
                                task.wait()
                                v:InputHoldEnd()
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Phím K để đóng/mở
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.K then
            Titan.Visible = not Titan.Visible
            Main.Visible = Titan.Visible
        end
    end)
end

-- Chạy khởi tạo bảo mật
task.spawn(function()
    local ok, err = pcall(CreateUI)
    if not ok then warn("Titan Error: " .. tostring(err)) end
end)
