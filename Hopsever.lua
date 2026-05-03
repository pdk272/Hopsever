local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local savedLocation = nil

-- TẠO GUI GỌN NHẸ NHẤT
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("ChiMotScriptTele") then 
    PlayerGui.ChiMotScriptTele:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "ChiMotScriptTele"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 95)
Main.Position = UDim2.new(0.5, -90, 0, 20)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Draggable = true
Main.Active = true

local SaveBtn = Instance.new("TextButton", Main)
SaveBtn.Size = UDim2.new(1, -10, 0, 40)
SaveBtn.Position = UDim2.new(0, 5, 0, 5)
SaveBtn.Text = "1. LƯU BASE"
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamBold

local TeleBtn = Instance.new("TextButton", Main)
TeleBtn.Size = UDim2.new(1, -10, 0, 40)
TeleBtn.Position = UDim2.new(0, 5, 0, 50)
TeleBtn.Text = "2. TELE VỀ"
TeleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleBtn.Font = Enum.Font.GothamBold

-- CHỨC NĂNG LƯU
SaveBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedLocation = char.HumanoidRootPart.CFrame
        SaveBtn.Text = "ĐÃ LƯU!"
        task.wait(1)
        SaveBtn.Text = "1. LƯU BASE"
    end
end)

-- CHỨC NĂNG TELE (CHỐNG GIẬT LẠI CHỖ CŨ)
TeleBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and savedLocation then
        local root = char.HumanoidRootPart
        
        -- Bước 1: Triệt tiêu mọi lực vật lý đang tác động
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        
        -- Bước 2: Đóng băng nhân vật
        root.Anchored = true 
        
        -- Bước 3: Di chuyển cả cụm nhân vật (an toàn hơn CFrame thường)
        char:PivotTo(savedLocation)
        
        -- Bước 4: Đợi một nhịp cực nhỏ để ép Server chốt vị trí mới, sau đó mở băng
        task.wait(0.1)
        root.Anchored = false
    end
end)
