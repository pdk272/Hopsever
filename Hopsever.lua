--[[
    SOLARA X - CHRONICLE ULTIMATE (V17.1)
    - Theme: Solara Executor (Dựa trên ảnh của ông)
    - Tech: Flat UI / Purple-Cyan Gradient
    - Keybind: K (Open/Close Menu)
]]

-- 1. KHỞI TẠO BẢO MẬT (CHỐNG LỖI NIL TUYỆT ĐỐI)
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LPlr = Players.LocalPlayer or Players.PlayerAdded:Wait()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Titan = {
    Pos1 = nil, Pos2 = nil,
    Visible = true, FastE = true
}

-- 2. HÀM TẠO GUI (CHÍNH CHỦ PHONG CÁCH SOLARA)
local function CreateUI()
    local PlayerGui = LPlr:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("SolaraDupe") then PlayerGui.SolaraDupe:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "SolaraDupe"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 480, 0, 360)
    Main.Position = UDim2.new(0.5, -240, 0.4, -180)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15) -- Nền đen Solara
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 5) -- Bo góc nhẹ

    -- Thanh tiêu đề Gradient (Mấu chốt của ảnh)
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BorderSizePixel = 0
    local Gradient = Instance.new("UIGradient", TopBar)
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)), -- Purple
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255)) -- Cyan
    })
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 5)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Text = "SOLARA" -- Tên theo Executor
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Menu dọc bên trái (Simulate Solara Icons)
    local LeftMenu = Instance.new("Frame", Main)
    LeftMenu.Size = UDim2.new(0, 50, 1, -35)
    LeftMenu.Position = UDim2.new(0, 0, 0, 35)
    LeftMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    LeftMenu.BorderSizePixel = 0
    local MenuList = Instance.new("UIListLayout", LeftMenu)
    MenuList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    MenuList.Padding = UDim.new(0, 10)

    -- Hàm tạo Icon giả
    local function NewIcon(text)
        local l = Instance.new("TextLabel", LeftMenu)
        l.Size = UDim2.new(1, 0, 0, 40)
        l.Text = text
        l.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 20
        l.BackgroundTransparency = 1
    end
    Instance.new("Frame", LeftMenu).Size = UDim2.new(0,0,0,5) -- Spacer
    NewIcon("H") -- Home
    local Sci = Instance.new("TextLabel", LeftMenu) -- Icon Active (Tím)
    Sci.Size = UDim2.new(1, 0, 0, 40) Sci.Text = "S" Sci.TextSize = 20 Sci.Font = Enum.Font.GothamBold
    Sci.TextColor3 = Color3.fromRGB(150, 0, 255) Sci.BackgroundTransparency = 1
    NewIcon("C") -- Console
    NewIcon("⚙️") -- Settings

    -- Thư mục chứa các chức năng (Chronicle)
    local Container = Instance.new("ScrollingFrame", Main)
    Container.Size = UDim2.new(1, -60, 1, -45)
    Container.Position = UDim2.new(0, 60, 0, 45)
    Container.BackgroundTransparency = 1
    Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    Container.ScrollBarThickness = 0
    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 12)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left -- Nút dạt về trái

    local function NewBtn(text, order, color, callback)
        local b = Instance.new("TextButton", Container)
        b.Size = UDim2.new(0.9, 0, 0, 40)
        b.BackgroundColor3 = color or Color3.fromRGB(25, 25, 30) -- Dark Solara Btn
        b.Text = text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamSemibold
        b.TextSize = 14
        b.LayoutOrder = order
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- ĐÚNG Ý ÔNG: 4 NÚT CHIẾN THUẬT
    NewBtn("1. LƯU VỊ TRÍ 1 (BASE)", 1, Color3.fromRGB(35, 35, 45), function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then Titan.Pos1 = hrp.CFrame print("Lưu P1") end
    end)

    NewBtn("2. BAY VỀ VỊ TRÍ 1", 2, Color3.fromRGB(100, 0, 200), function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Titan.Pos1 then hrp.CFrame = Titan.Pos1 end
    end)

    NewBtn("3. LƯU VỊ TRÍ 2 (PET)", 3, Color3.fromRGB(35, 35, 45), function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then Titan.Pos2 = hrp.CFrame print("Lưu P2") end
    end)

    NewBtn("4. BAY VỀ VỊ TRÍ 2", 4, Color3.fromRGB(0, 200, 150), function()
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Titan.Pos2 then hrp.CFrame = Titan.Pos2 end
    end)

    local EBtn = NewBtn("⚡ ÉP NHẤN E (0S WAIT): ON", 5, Color3.fromRGB(200, 50, 50), function()
        Titan.FastE = not Titan.FastE
    end)

    -- 3. LOGIC HỆ THỐNG
    
    -- Ép E và Noclip (Sử dụng nhịp Stepped)
    RunService.Stepped:Connect(function()
        EBtn.Text = "⚡ ÉP NHẤN E: " .. (Titan.FastE and "ON" or "OFF")
        EBtn.BackgroundColor3 = Titan.FastE and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 50, 50)
        
        if Titan.FastE then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0 -- Ép 0 giây chờ
                    if LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LPlr.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                        if dist <= v.MaxActivationDistance then
                            -- Phương thức ép nổ
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

    -- TOGGLE PHÍM K
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.K then
            Titan.Visible = not Titan.Visible
            Main.Visible = Titan.Visible
        end
    end)
end

-- Khởi tạo an toàn (task.spawn tránh nil)
task.spawn(function()
    local ok, err = pcall(CreateUI)
    if not ok then warn("Solara Update Error: " .. tostring(err)) end
end)
