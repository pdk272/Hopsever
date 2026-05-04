--[[ 
    VANGUARD TITAN V5.7 - STEAL & COMBO UNIFIED
    - Action: Nhấn E là vừa Steal Pet vừa nổ Combo ngay lập tức.
    - Speed: Stealth Mode (Giới hạn an toàn, cực mượt né Anti-cheat).
    - Gears: Bee -> Boogie -> Medusa -> Megaphone.
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LPlr = Services.Players.LocalPlayer
local RunService = Services.RunService
local UIS = Services.UserInputService

local Config = {
    SpeedValue = 16,
    Enabled = false,
    Accent = Color3.fromRGB(170, 0, 255),
    ComboKeywords = {"Bee", "Boogie", "Medusa", "Megaphone"}
}

-- 1. GUI (CHỮ TO, NÚT RÕ)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
ScreenGui.Name = "TitanV57"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 380)
Main.Position = UDim2.new(0.5, -160, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "TITAN V5.7 - STEAL COMBO"
Title.TextSize = 22
Title.TextColor3 = Config.Accent
Title.Font = Enum.Font.GothamBold
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Title)

-- 2. SPEED SYSTEM (FIXED ANTI-CHEAT)
local SpeedToggle = Instance.new("TextButton", Main)
SpeedToggle.Size = UDim2.new(0.9, 0, 0, 60)
SpeedToggle.Position = UDim2.new(0.05, 0, 0, 65)
SpeedToggle.Text = "STEALTH SPEED: OFF"
SpeedToggle.TextSize = 20
SpeedToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SpeedToggle)

local SpeedLabel = Instance.new("TextLabel", Main)
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 130)
SpeedLabel.Text = "TỐC ĐỘ: 16"
SpeedLabel.TextSize = 22
SpeedLabel.TextColor3 = Config.Accent
SpeedLabel.BackgroundTransparency = 1

local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(0.8, 0, 0, 12)
Bar.Position = UDim2.new(0.1, 0, 0, 170)
Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", Bar)

local Knob = Instance.new("TextButton", Bar)
Knob.Size = UDim2.new(0, 28, 0, 28)
Knob.Position = UDim2.new(0, -14, 0.5, -14)
Knob.Text = ""
Knob.BackgroundColor3 = Config.Accent
Instance.new("UICorner", Knob)

SpeedToggle.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    SpeedToggle.Text = Config.Enabled and "STEALTH SPEED: ON" or "STEALTH SPEED: OFF"
    SpeedToggle.TextColor3 = Config.Enabled and Config.Accent or Color3.new(1, 1, 1)
end)

local dragging = false
Knob.MouseButton1Down:Connect(function() dragging = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Knob.Position = UDim2.new(pos, -14, 0.5, -14)
        Config.SpeedValue = 16 + (pos * 54) -- Giới hạn 70 cực kỳ an toàn
        SpeedLabel.Text = "TỐC ĐỘ: " .. math.floor(Config.SpeedValue)
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if Config.Enabled and LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LPlr.Character.HumanoidRootPart
        local hum = LPlr.Character:FindFirstChildOfClass("Humanoid")
        if hum.MoveDirection.Magnitude > 0 then
            -- Bypass mượt 0.85
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.SpeedValue * dt * 0.85))
        end
    end
end)

-- 3. INSTANT STEAL & COMBO (NÃ NGAY KHI BẤM E)
local function ExecuteCombo()
    local bp = LPlr:FindFirstChild("Backpack")
    local char = LPlr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    for _, keyword in pairs(Config.ComboKeywords) do
        local tool = nil
        for _, v in pairs(bp:GetChildren()) do
            if v:IsA("Tool") and v.Name:lower():find(keyword:lower()) then tool = v break end
        end
        if not tool then
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("Tool") and v.Name:lower():find(keyword:lower()) then tool = v break end
            end
        end

        if tool then
            hum:EquipTool(tool)
            task.wait(0.07) -- Delay siêu ngắn để xả nhanh
            tool:Activate()
            local rem = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChild("Remote")
            if rem then rem:FireServer() end
            task.wait(0.05)
            hum:UnequipTools()
        end
    end
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    -- "gameProcessed" thường là khi bạn đang gõ chat, chúng ta bỏ qua chat.
    -- Nhưng khi bấm E vào Pet, gameProcessed sẽ là True. 
    -- Để can thiệp vào Steal Pet, chúng ta sẽ chạy lệnh Combo ngay cả khi gameProcessed là True.

    if input.KeyCode == Enum.KeyCode.E then
        task.spawn(ExecuteCombo) -- Chạy song song với hành động Steal của game
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

QuickBtn("SERVER HOP", UDim2.new(0.05, 0, 0, 220), function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local data = Services.HttpService:JSONDecode(game:HttpGet(url)).data
    Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, data[math.random(1, #data)].id)
end)

QuickBtn("TẮT MENU", UDim2.new(0.05, 0, 0, 320), function() ScreenGui:Destroy() end).BackgroundColor3 = Color3.fromRGB(120, 0, 0)

print("🔥 TITAN V5.7 LOADED. Instant Steal + Combo Active.")
