--[[ 
    VANGUARD ULTIMATE EDITION
    - Professional UI Design (Gradient & Stroke)
    - Anti-Duplicate Fast Server Hop
    - Smooth Delta-Sync Speed (Safe Mode)
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LPlr = Services.Players.LocalPlayer
local HttpService = Services.HttpService
local RunService = Services.RunService
local TeleportService = Services.TeleportService

-- 1. CONFIGURATION
local Config = {
    Speed = 30,
    Active = false,
    ESP = true,
    AccentColor = Color3.fromRGB(0, 255, 200)
}

-- 2. TẠO GUI ĐẲNG CẤP (Custom UI Design)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
ScreenGui.Name = "VanguardUI"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 320)
Main.Position = UDim2.new(0.5, -130, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Bo góc & Đổ bóng viền
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Config.AccentColor
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

-- Header với Gradient
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Grad = Instance.new("UIGradient", Header)
Grad.Color = ColorSequence.new(Color3.fromRGB(20, 20, 20), Color3.fromRGB(40, 40, 40))

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "VANGUARD ULTIMATE"
Title.TextColor3 = Config.AccentColor
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- 3. HÀM TẠO NÚT BẤM (Giao diện chuyên nghiệp)
local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.new(1, 1, 1)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.8
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 4. SPEED LOGIC (Delta-Sync & Raycast)
local speedBtn = CreateButton("SPEED: OFF", UDim2.new(0.05, 0, 0, 60), function()
    Config.Active = not Config.Active
end)

RunService.PreSimulation:Connect(function(dt)
    if not Config.Active then return end
    local char = LPlr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if hrp and hum and hum.MoveDirection.Magnitude > 0 then
        local p = RaycastParams.new()
        p.FilterDescendantsInstances = {char}
        if not workspace:Raycast(hrp.Position, hum.MoveDirection * 1.5, p) then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.Speed * dt))
        end
    end
end)

-- 5. ESP LOGIC (Smart Scanning)
local espBtn = CreateButton("ESP: ON", UDim2.new(0.05, 0, 0, 110), function()
    Config.ESP = not Config.ESP
end)

task.spawn(function()
    while task.wait(3) do
        if Config.ESP then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TextLabel") and (v.Text:find("ss") or v.Text:find("Q")) then
                    local m = v:FindFirstAncestorOfClass("Model")
                    if m and not m:FindFirstChild("VanguardESP") then
                        local h = Instance.new("Highlight", m)
                        h.Name = "VanguardESP"
                        h.FillColor = Config.AccentColor
                        h.OutlineColor = Color3.new(1, 1, 1)
                    end
                end
            end
        end
    end
end)

-- 6. SERVER HOP SIÊU TỐC (Không trùng Server cũ)
CreateButton("SERVER HOP (UNIQUE)", UDim2.new(0.05, 0, 0, 160), function()
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and result and result.data then
        local possibleServers = {}
        for _, s in pairs(result.data) do
            -- Lọc bỏ server hiện tại (JobId) và server đầy
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                table.insert(possibleServers, s.id)
            end
        end
        
        if #possibleServers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, possibleServers[math.random(1, #possibleServers)])
        else
            print("❌ Không tìm thấy server mới!")
        end
    end
end)

-- 7. ANTI-AFK
local VirtualUser = Services.VirtualUser
LPlr.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

-- 8. UI UPDATER & CLOSE
RunService.RenderStepped:Connect(function()
    speedBtn.Text = Config.Active and "SPEED: ON" or "SPEED: OFF"
    speedBtn.TextColor3 = Config.Active and Config.AccentColor or Color3.new(1, 1, 1)
    espBtn.Text = Config.ESP and "ESP: ON" or "ESP: OFF"
    espBtn.TextColor3 = Config.ESP and Config.AccentColor or Color3.new(1, 1, 1)
end)

CreateButton("CLOSE MENU", UDim2.new(0.05, 0, 0, 260), function() ScreenGui:Destroy() end)

print("✨ VANGUARD ULTIMATE LOADED. Have a safe flight!")
