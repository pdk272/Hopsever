--[[ 
    VANGUARD TITAN V3.1 - SPEED FIX & GHOST COMBO
    - Fix Speed Slider: Real-time velocity update
    - Ghost Combo: Quantum Cloner + Change with Clone
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LPlr = Services.Players.LocalPlayer
local RunService = Services.RunService
local HttpService = Services.HttpService
local UserInputService = Services.UserInputService

local Config = {
    Speed = 16,
    SpeedEnabled = false,
    Accent = Color3.fromRGB(170, 0, 255)
}

-- 1. TẠO GUI (Giữ nguyên Visuals đẹp)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 380)
Main.Position = UDim2.new(0.5, -140, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Hiệu ứng Bong bóng & Aura (Giữ nguyên phong cách)
local AuraStroke = Instance.new("UIStroke", Main)
AuraStroke.Color = Config.Accent
AuraStroke.Thickness = 2.5
AuraStroke.Transparency = 0.3

task.spawn(function()
    while Main do
        local bubble = Instance.new("Frame", Main)
        bubble.Size = UDim2.new(0, math.random(4, 10), 0, math.random(4, 10))
        bubble.Position = UDim2.new(math.random(0, 100) / 100, 0, 1, 0)
        bubble.BackgroundColor3 = Config.Accent
        bubble.BackgroundTransparency = 0.6
        Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)
        task.spawn(function()
            for i = 1, 100 do
                if not bubble or not bubble.Parent then break end
                bubble.Position = bubble.Position - UDim2.new(0, 0, 0.01, 0)
                bubble.BackgroundTransparency = bubble.BackgroundTransparency + 0.01
                task.wait(0.02)
            end
            if bubble then bubble:Destroy() end
        end)
        task.wait(0.6)
    end
end)

-- 2. SPEED SYSTEM (Cải tiến Logic Speed)
local SliderFrame = Instance.new("Frame", Main)
SliderFrame.Size = UDim2.new(0.9, 0, 0, 80)
SliderFrame.Position = UDim2.new(0.05, 0, 0, 60)
SliderFrame.BackgroundTransparency = 1

local SpeedToggleBtn = Instance.new("TextButton", SliderFrame)
SpeedToggleBtn.Size = UDim2.new(1, 0, 0, 30)
SpeedToggleBtn.Text = "SPEED SYSTEM: OFF"
SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedToggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SpeedToggleBtn)

SpeedToggleBtn.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    SpeedToggleBtn.Text = Config.SpeedEnabled and "SPEED SYSTEM: ON" or "SPEED SYSTEM: OFF"
    SpeedToggleBtn.TextColor3 = Config.SpeedEnabled and Config.Accent or Color3.new(1,1,1)
end)

local SpeedLabel = Instance.new("TextLabel", SliderFrame)
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 40)
SpeedLabel.Text = "Tốc độ: 16"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1

local Bar = Instance.new("Frame", SliderFrame)
Bar.Size = UDim2.new(1, 0, 0, 6)
Bar.Position = UDim2.new(0, 0, 0, 65)
Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local Fill = Instance.new("Frame", Bar)
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.BackgroundColor3 = Config.Accent

local Knob = Instance.new("TextButton", Bar)
Knob.Size = UDim2.new(0, 16, 0, 16)
Knob.Position = UDim2.new(0, -8, 0.5, -8)
Knob.BackgroundColor3 = Color3.new(1, 1, 1)
Knob.Text = ""
Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

local dragging = false
Knob.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -8, 0.5, -8)
        Config.Speed = 16 + (pos * 134) -- Tăng giới hạn lên 150 cho máu lửa
        SpeedLabel.Text = "Tốc độ: " .. math.floor(Config.Speed)
    end
end)

-- 3. GHOST COMBO (Quantum Cloner + Change with Clone)
local desyncBtn = Instance.new("TextButton", Main)
desyncBtn.Size = UDim2.new(0.9, 0, 0, 45)
desyncBtn.Position = UDim2.new(0.05, 0, 0, 165)
desyncBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
desyncBtn.Text = "GHOST COMBO (QUANTUM)"
desyncBtn.TextColor3 = Config.Accent
desyncBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", desyncBtn)

desyncBtn.MouseButton1Click:Connect(function()
    local bp = LPlr:FindFirstChild("Backpack")
    local char = LPlr.Character
    if bp and char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        -- BƯỚC 1: Dùng Quantum Cloner
        local tool1 = bp:FindFirstChild("Quantum Cloner") or char:FindFirstChild("Quantum Cloner")
        if tool1 then
            hum:EquipTool(tool1)
            task.wait(0.1)
            tool1:Activate()
            task.wait(0.2)
        end
        
        -- BƯỚC 2: Dùng Change with Clone
        local tool2 = bp:FindFirstChild("Change with Clone") or char:FindFirstChild("Change with Clone")
        if tool2 then
            hum:EquipTool(tool2)
            task.wait(0.1)
            tool2:Activate()
            task.wait(0.2)
        end
        
        hum:UnequipTools()
        print("👻 Quantum Combo Executed!")
    end
end)

-- 4. SPEED LOGIC (SỬA LỖI TỐC ĐỘ GIỐNG NHAU)
RunService.Stepped:Connect(function(_, dt)
    if Config.SpeedEnabled and LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LPlr.Character.HumanoidRootPart
        local hum = LPlr.Character:FindFirstChildOfClass("Humanoid")
        
        if hum.MoveDirection.Magnitude > 0 then
            -- Sử dụng công thức cộng bù vận tốc để thực sự thay đổi speed
            local velocity = hum.MoveDirection * (Config.Speed - 16) -- 16 là speed mặc định
            hrp.CFrame = hrp.CFrame + (velocity * dt)
        end
    end
end)

-- 5. SERVER HOP & CLOSE
local function CreateBtn(text, pos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

CreateBtn("SERVER HOP (FAST)", UDim2.new(0.05, 0, 0, 220), function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local data = HttpService:JSONDecode(game:HttpGet(url)).data
    if data then
        local nextS = data[math.random(1, #data)]
        Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, nextS.id)
    end
end)

CreateBtn("ĐÓNG MENU", UDim2.new(0.05, 0, 0, 310), function() ScreenGui:Destroy() end)

print("🌌 VANGUARD TITAN V3.1 LOADED. Combo Ready.")
