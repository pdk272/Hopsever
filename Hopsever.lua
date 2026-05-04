--[[ 
    VANGUARD TITAN V4.2 - BYPASS BRAINROT
    - Speed: Dùng Velocity (Vận tốc vật lý) để né bị Dead/Kick.
    - Ghost: Quantum + Change (Tối ưu delay né Reset).
    - UI: Chữ siêu to, thanh kéo hiện số rõ ràng.
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LPlr = Services.Players.LocalPlayer
local RunService = Services.RunService
local Config = {
    SpeedValue = 16,
    Enabled = false,
    Accent = Color3.fromRGB(170, 0, 255)
}

-- 1. GUI (CHỮ TO, DỄ NHÌN)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
ScreenGui.Name = "TitanV42"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 420)
Main.Position = UDim2.new(0.5, -160, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
Main.Active = true
Main.Draggable = true

-- Hiệu ứng Bong bóng (Visuals)
task.spawn(function()
    while Main do
        local b = Instance.new("Frame", Main)
        b.Size = UDim2.new(0, 8, 0, 8)
        b.Position = UDim2.new(math.random(0, 100)/100, 0, 1, 0)
        b.BackgroundColor3 = Config.Accent
        b.BackgroundTransparency = 0.5
        Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
        task.spawn(function()
            for i = 1, 100 do
                if not b.Parent then break end
                b.Position = b.Position - UDim2.new(0,0,0.01,0)
                b.BackgroundTransparency = b.BackgroundTransparency + 0.01
                task.wait(0.02)
            end
            if b then b:Destroy() end
        end)
        task.wait(0.5)
    end
end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "VANGUARD TITAN V4.2"
Title.TextSize = 22
Title.TextColor3 = Config.Accent
Title.Font = Enum.Font.GothamBold
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Title)

-- 2. SPEED SYSTEM (BYPASS DEAD)
local SpeedToggle = Instance.new("TextButton", Main)
SpeedToggle.Size = UDim2.new(0.9, 0, 0, 50)
SpeedToggle.Position = UDim2.new(0.05, 0, 0, 65)
SpeedToggle.Text = "SPEED: OFF"
SpeedToggle.TextSize = 20
SpeedToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SpeedToggle)

local SpeedLabel = Instance.new("TextLabel", Main)
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 120)
SpeedLabel.Text = "TỐC ĐỘ: 16"
SpeedLabel.TextSize = 22
SpeedLabel.TextColor3 = Config.Accent
SpeedLabel.BackgroundTransparency = 1

local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(0.8, 0, 0, 12)
Bar.Position = UDim2.new(0.1, 0, 0, 160)
Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", Bar)

local Knob = Instance.new("TextButton", Bar)
Knob.Size = UDim2.new(0, 28, 0, 28)
Knob.Position = UDim2.new(0, -14, 0.5, -14)
Knob.Text = ""
Knob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Knob)

-- LOGIC SPEED VELOCITY (ANTI-DEAD)
SpeedToggle.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    SpeedToggle.Text = Config.Enabled and "SPEED: ON" or "SPEED: OFF"
    SpeedToggle.TextColor3 = Config.Enabled and Config.Accent or Color3.new(1, 1, 1)
end)

local dragging = false
Knob.MouseButton1Down:Connect(function() dragging = true end)
Services.UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
Services.UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Knob.Position = UDim2.new(pos, -14, 0.5, -14)
        Config.SpeedValue = 16 + (pos * 134) -- Lên tới 150
        SpeedLabel.Text = "TỐC ĐỘ: " .. math.floor(Config.SpeedValue)
    end
end)

-- ÉP VẬN TỐC (Để server ko check ra hack tọa độ)
RunService.PostSimulation:Connect(function()
    if Config.Enabled and LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LPlr.Character.HumanoidRootPart
        local hum = LPlr.Character:FindFirstChildOfClass("Humanoid")
        
        if hum.MoveDirection.Magnitude > 0 then
            -- Chỉ ép vận tốc theo chiều ngang (X, Z), giữ nguyên chiều dọc (Y) để ko bị bay lên trời
            hrp.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * Config.SpeedValue, hrp.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * Config.SpeedValue)
        end
    end
end)

-- 3. GHOST COMBO (FIX RESET/DEAD)
local GhostBtn = Instance.new("TextButton", Main)
GhostBtn.Size = UDim2.new(0.9, 0, 0, 60)
GhostBtn.Position = UDim2.new(0.05, 0, 0, 200)
GhostBtn.Text = "GHOST: QUANTUM + CHANGE"
GhostBtn.TextSize = 18
GhostBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GhostBtn.TextColor3 = Config.Accent
Instance.new("UICorner", GhostBtn)

local function UseGear(namePart)
    local bp = LPlr:FindFirstChild("Backpack")
    local char = LPlr.Character
    local tool = nil
    for _, v in pairs(bp:GetChildren()) do if v.Name:lower():find(namePart:lower()) then tool = v break end end
    if not tool then for _, v in pairs(char:GetChildren()) do if v.Name:lower():find(namePart:lower()) then tool = v break end end end
    
    if tool and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid"):EquipTool(tool)
        task.wait(0.2)
        tool:Activate()
        return true
    end
    return false
end

GhostBtn.MouseButton1Click:Connect(function()
    if UseGear("Quantum") then
        task.wait(0.7) -- Tăng delay cho server load bóng
        UseGear("Change")
        task.wait(0.3)
        if LPlr.Character and LPlr.Character:FindFirstChildOfClass("Humanoid") then
            LPlr.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
        end
    end
end)

-- 4. SERVER HOP & ĐÓNG
local function QuickBtn(text, pos, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.Position = pos
    b.Text = text
    b.TextSize = 18
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    return b
end

QuickBtn("SERVER HOP (FAST)", UDim2.new(0.05, 0, 0, 270), function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local data = Services.HttpService:JSONDecode(game:HttpGet(url)).data
    Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, data[math.random(1, #data)].id)
end)

QuickBtn("TẮT MENU", UDim2.new(0.05, 0, 0, 360), function() ScreenGui:Destroy() end).BackgroundColor3 = Color3.fromRGB(120, 0, 0)

print("🚀 VANGUARD TITAN V4.2 BYPASS LOADED. Speed & Ghost Optimized.")
