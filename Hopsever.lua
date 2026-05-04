--[[ 
    VANGUARD TITAN V3.2 - FINAL FIX
    - Force Speed: Ép tốc độ trực tiếp vào Humanoid
    - Smart Gear Search: Tự tìm Quantum Cloner và Change with Clone
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LPlr = Services.Players.LocalPlayer
local RunService = Services.RunService
local Config = {
    Speed = 16,
    SpeedEnabled = false,
    Accent = Color3.fromRGB(170, 0, 255)
}

-- 1. GUI (Giữ nguyên giao diện đẹp)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 380)
Main.Position = UDim2.new(0.5, -140, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Main)
Main.Active = true
Main.Draggable = true

-- 2. SMART SPEED LOGIC (FIX LỖI TỐC ĐỘ)
local function UpdateSpeed()
    local char = LPlr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if Config.SpeedEnabled then
            hum.WalkSpeed = Config.Speed
        else
            hum.WalkSpeed = 16
        end
    end
end

-- Vòng lặp ép tốc độ (Tránh bị game tự động reset về 16)
RunService.Heartbeat:Connect(function()
    UpdateSpeed()
end)

-- 3. SPEED SLIDER & TOGGLE
local SliderFrame = Instance.new("Frame", Main)
SliderFrame.Size = UDim2.new(0.9, 0, 0, 80)
SliderFrame.Position = UDim2.new(0.05, 0, 0, 60)
SliderFrame.BackgroundTransparency = 1

local SpeedToggleBtn = Instance.new("TextButton", SliderFrame)
SpeedToggleBtn.Size = UDim2.new(1, 0, 0, 30)
SpeedToggleBtn.Text = "FORCE SPEED: OFF"
SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedToggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SpeedToggleBtn)

SpeedToggleBtn.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    SpeedToggleBtn.Text = Config.SpeedEnabled and "FORCE SPEED: ON" or "FORCE SPEED: OFF"
    SpeedToggleBtn.TextColor3 = Config.SpeedEnabled and Config.Accent or Color3.new(1,1,1)
end)

local Bar = Instance.new("Frame", SliderFrame)
Bar.Size = UDim2.new(1, 0, 0, 6)
Bar.Position = UDim2.new(0, 0, 0, 65)
Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local Knob = Instance.new("TextButton", Bar)
Knob.Size = UDim2.new(0, 16, 0, 16)
Knob.Position = UDim2.new(0, -8, 0.5, -8)
Knob.Text = ""
Instance.new("UICorner", Knob)

-- Logic Slider
local dragging = false
Knob.MouseButton1Down:Connect(function() dragging = true end)
Services.UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
Services.UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Knob.Position = UDim2.new(pos, -8, 0.5, -8)
        Config.Speed = 16 + (pos * 134) -- Lên tới 150
    end
end)

-- 4. SMART GHOST COMBO (FIX LỖI KHÔNG PHÂN THÂN)
local desyncBtn = Instance.new("TextButton", Main)
desyncBtn.Size = UDim2.new(0.9, 0, 0, 45)
desyncBtn.Position = UDim2.new(0.05, 0, 0, 165)
desyncBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
desyncBtn.Text = "ULTIMATE GHOST COMBO"
desyncBtn.TextColor3 = Config.Accent
desyncBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", desyncBtn)

local function UseGear(namePart)
    local bp = LPlr:FindFirstChild("Backpack")
    local char = LPlr.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    local tool = nil
    -- Tìm trong túi đồ
    for _, v in pairs(bp:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find(namePart:lower()) then
            tool = v break
        end
    end
    -- Tìm trên tay
    if not tool then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") and v.Name:lower():find(namePart:lower()) then
                tool = v break
            end
        end
    end

    if tool and hum then
        hum:EquipTool(tool)
        task.wait(0.1)
        tool:Activate()
        task.wait(0.2)
        return true
    end
    return false
end

desyncBtn.MouseButton1Click:Connect(function()
    print("🚀 Đang kích hoạt Combo...")
    -- Bước 1: Quantum
    local q = UseGear("Quantum")
    if q then 
        task.wait(0.3)
        -- Bước 2: Change
        UseGear("Change")
    end
    
    if LPlr.Character then
        local hum = LPlr.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:UnequipTools() end
    end
end)

-- 5. NÚT ĐÓNG
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0.9, 0, 0, 40)
Close.Position = UDim2.new(0.05, 0, 0, 310)
Close.Text = "ĐÓNG MENU"
Close.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

print("✅ VANGUARD TITAN V3.2 LOADED. Speed & Combo Fixed.")
