--[[ 
    VANGUARD TITAN V2 - CUSTOM UI VISUALS
    - Desync: Single-use Gear Logic
    - Speed: Slider + Toggle Fix
    - UI: Integrated Bubbles & Aura Effects
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LPlr = Services.Players.LocalPlayer
local RunService = Services.RunService
local HttpService = Services.HttpService
local UserInputService = Services.UserInputService

-- 1. CONFIGURATION
local Config = {
    Speed = 16,
    SpeedEnabled = false,
    Accent = Color3.fromRGB(170, 0, 255)
}

-- 2. TẠO GUI ĐẲNG CẤP (TITAN UI V2)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
ScreenGui.Name = "TitanV2"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 360)
Main.Position = UDim2.new(0.5, -140, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true -- Để bong bóng ko bay ra ngoài menu
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- [HIỆU ỨNG UI: AURA TÍM]
local AuraStroke = Instance.new("UIStroke", Main)
AuraStroke.Color = Config.Accent
AuraStroke.Thickness = 2
AuraStroke.Transparency = 0.4

-- [HIỆU ỨNG UI: BONG BÓNG BAY TRÊN MENU]
task.spawn(function()
    while true do
        local bubble = Instance.new("Frame", Main)
        bubble.Size = UDim2.new(0, math.random(5, 15), 0, math.random(5, 15))
        bubble.Position = UDim2.new(math.random(0, 100) / 100, 0, 1, 0)
        bubble.BackgroundColor3 = Config.Accent
        bubble.BackgroundTransparency = 0.7
        Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)
        
        -- Bong bóng bay lên
        local speed = math.random(2, 5)
        task.spawn(function()
            for i = 1, 100 do
                bubble.Position = bubble.Position - UDim2.new(0, 0, 0.01 * speed, 0)
                bubble.BackgroundTransparency = bubble.BackgroundTransparency + 0.005
                task.wait(0.03)
            end
            bubble:Destroy()
        end)
        task.wait(0.5) -- Cứ 0.5s tạo 1 bong bóng
    end
end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "VANGUARD TITAN V2"
Title.TextColor3 = Config.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Title)

-- 3. SPEED SLIDER & TOGGLE
local SliderFrame = Instance.new("Frame", Main)
SliderFrame.Size = UDim2.new(0.9, 0, 0, 80)
SliderFrame.Position = UDim2.new(0.05, 0, 0, 60)
SliderFrame.BackgroundTransparency = 1

local SpeedToggleBtn = Instance.new("TextButton", SliderFrame)
SpeedToggleBtn.Size = UDim2.new(1, 0, 0, 30)
SpeedToggleBtn.Text = "BẬT SPEED: OFF"
SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedToggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SpeedToggleBtn)

SpeedToggleBtn.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    SpeedToggleBtn.Text = Config.SpeedEnabled and "BẬT SPEED: ON" or "BẬT SPEED: OFF"
    SpeedToggleBtn.TextColor3 = Config.SpeedEnabled and Config.Accent or Color3.new(1,1,1)
end)

local SpeedLabel = Instance.new("TextLabel", SliderFrame)
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 40)
SpeedLabel.Text = "Vận tốc: 16"
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

-- Logic Slider mượt
local dragging = false
Knob.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -8, 0.5, -8)
        Config.Speed = 16 + (pos * 84)
        SpeedLabel.Text = "Vận tốc: " .. math.floor(Config.Speed)
    end
end)

-- 4. DESYNC GEAR (Dùng 1 lần rồi cất)
local desyncBtn = Instance.new("TextButton", Main)
desyncBtn.Size = UDim2.new(0.9, 0, 0, 40)
desyncBtn.Position = UDim2.new(0.05, 0, 0, 160)
desyncBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
desyncBtn.Text = "KÍCH HOẠT DESYNC (1 LẦN)"
desyncBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", desyncBtn)

desyncBtn.MouseButton1Click:Connect(function()
    local backpack = LPlr:FindFirstChild("Backpack")
    local char = LPlr.Character
    if backpack and char then
        local tool = backpack:FindFirstChild("Desync") or char:FindFirstChild("Desync")
        if tool and tool:IsA("Tool") then
            tool.Parent = char
            task.wait(0.1)
            tool:Activate()
            task.wait(0.2)
            tool.Parent = backpack
            print("✅ Đã dùng Desync!")
        else
            print("❌ Không thấy Gear Desync trong túi!")
        end
    end
end)

-- 5. SPEED & PHYSICS LOGIC
RunService.PreSimulation:Connect(function(dt)
    if Config.SpeedEnabled and LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LPlr.Character.HumanoidRootPart
        local hum = LPlr.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.Speed * dt))
        end
    end
end)

-- 6. SERVER HOP & CLOSE
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

CreateBtn("SERVER HOP (FAST)", UDim2.new(0.05, 0, 0, 210), function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local servers = HttpService:JSONDecode(game:HttpGet(url)).data
    local nextS = servers[math.random(1, #servers)]
    if nextS.id ~= game.JobId then Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, nextS.id) end
end)

CreateBtn("TẮT MENU", UDim2.new(0.05, 0, 0, 310), function() ScreenGui:Destroy() end)

print("💎 VANGUARD TITAN V2 LOADED. UI Effects & Speed Fixed.")
