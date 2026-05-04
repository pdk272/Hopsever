--[[ 
    VANGUARD TITAN V4.0 - THE FINAL REBUILD
    - Big UI: Nút to, chữ rõ, thanh kéo có hiển thị số.
    - Stable Speed: Kết hợp WalkSpeed và CFrame để không bị game ghi đè.
    - Ghost Fix: Quantum + Change (Né Reset bằng cách delay hợp lý).
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LPlr = Services.Players.LocalPlayer
local RunService = Services.RunService
local Config = {
    Speed = 16,
    SpeedEnabled = false,
    Accent = Color3.fromRGB(170, 0, 255)
}

-- 1. GUI THIẾT KẾ LẠI (TO VÀ RÕ)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
ScreenGui.Name = "TitanV4"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 420) -- Phóng to khung
Main.Position = UDim2.new(0.5, -160, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
Main.Active = true
Main.Draggable = true

-- Hiệu ứng Bong bóng bay trên Menu (Giữ nguyên cho đẹp)
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
            b:Destroy()
        end)
        task.wait(0.5)
    end
end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "VANGUARD TITAN V4"
Title.TextSize = 22 -- Chữ to
Title.TextColor3 = Config.Accent
Title.Font = Enum.Font.GothamBold
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Title)

-- 2. THANH KÉO SPEED (CÓ HIỆN SỐ TO)
local SpeedToggle = Instance.new("TextButton", Main)
SpeedToggle.Size = UDim2.new(0.9, 0, 0, 50)
SpeedToggle.Position = UDim2.new(0.05, 0, 0, 65)
SpeedToggle.Text = "BẬT SPEED: OFF"
SpeedToggle.TextSize = 18
SpeedToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SpeedToggle)

local SpeedLabel = Instance.new("TextLabel", Main)
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 120)
SpeedLabel.Text = "TỐC ĐỘ HIỆN TẠI: 16"
SpeedLabel.TextSize = 20 -- Số to rõ
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1

local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(0.8, 0, 0, 10)
Bar.Position = UDim2.new(0.1, 0, 0, 160)
Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local Knob = Instance.new("TextButton", Bar)
Knob.Size = UDim2.new(0, 25, 0, 25)
Knob.Position = UDim2.new(0, -12, 0.5, -12)
Knob.Text = ""
Knob.BackgroundColor3 = Config.Accent
Instance.new("UICorner", Knob)

-- Logic Speed & Slider
SpeedToggle.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    SpeedToggle.Text = Config.SpeedEnabled and "BẬT SPEED: ON" or "BẬT SPEED: OFF"
    SpeedToggle.TextColor3 = Config.SpeedEnabled and Config.Accent or Color3.new(1, 1, 1)
end)

local dragging = false
Knob.MouseButton1Down:Connect(function() dragging = true end)
Services.UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
Services.UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Knob.Position = UDim2.new(pos, -12, 0.5, -12)
        Config.Speed = 16 + (pos * 134)
        SpeedLabel.Text = "TỐC ĐỘ HIỆN TẠI: " .. math.floor(Config.Speed)
    end
end)

-- Vòng lặp ép Speed (Cực mạnh)
RunService.Heartbeat:Connect(function()
    local hum = LPlr.Character and LPlr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = Config.SpeedEnabled and Config.Speed or 16
    end
end)

-- 3. GHOST COMBO (FIX RESET)
local GhostBtn = Instance.new("TextButton", Main)
GhostBtn.Size = UDim2.new(0.9, 0, 0, 60)
GhostBtn.Position = UDim2.new(0.05, 0, 0, 190)
GhostBtn.Text = "GHOST: QUANTUM + CHANGE"
GhostBtn.TextSize = 18
GhostBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GhostBtn.TextColor3 = Config.Accent
Instance.new("UICorner", GhostBtn)

local function UseGear(name)
    local bp = LPlr:FindFirstChild("Backpack")
    local char = LPlr.Character
    local tool = nil
    for _, v in pairs(bp:GetChildren()) do if v.Name:lower():find(name:lower()) then tool = v break end end
    if not tool then for _, v in pairs(char:GetChildren()) do if v.Name:lower():find(name:lower()) then tool = v break end end end
    
    if tool and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid"):EquipTool(tool)
        task.wait(0.15) -- Delay để server nhận diện
        tool:Activate()
        return true
    end
    return false
end

GhostBtn.MouseButton1Click:Connect(function()
    local q = UseGear("Quantum")
    if q then
        task.wait(0.5) -- Tăng delay để tránh bị reset do teleport quá nhanh
        UseGear("Change")
        task.wait(0.2)
        if LPlr.Character:FindFirstChildOfClass("Humanoid") then
            LPlr.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
        end
    end
end)

-- 4. SERVER HOP (FAST)
local HopBtn = Instance.new("TextButton", Main)
HopBtn.Size = UDim2.new(0.9, 0, 0, 50)
HopBtn.Position = UDim2.new(0.05, 0, 0, 260)
HopBtn.Text = "ĐỔI SERVER NHANH"
HopBtn.TextSize = 18
HopBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HopBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", HopBtn)

HopBtn.MouseButton1Click:Connect(function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local data = Services.HttpService:JSONDecode(game:HttpGet(url)).data
    Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, data[math.random(1, #data)].id)
end)

-- 5. NÚT ĐÓNG
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0.9, 0, 0, 40)
Close.Position = UDim2.new(0.05, 0, 0, 360)
Close.Text = "TẮT MENU"
Close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

print("🔥 VANGUARD TITAN V4.0 LOADED. Speed Fixed, UI Big, Ghost Stable.")
