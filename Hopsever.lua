--[[ 
    VANGUARD TITAN - FINAL ASCENSION
    - Custom Slider Speed (Anti-Cheat Optimized)
    - Desync "Ghost" Mode
    - Optimized Bubble & Dark Aura Visuals
    - Secure Server Hop
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local LPlr = Services.Players.LocalPlayer
local RunService = Services.RunService
local HttpService = Services.HttpService

-- 1. CONFIGURATION
local Config = {
    Speed = 16,
    Desync = false,
    Visuals = false,
    Accent = Color3.fromRGB(170, 0, 255) -- Màu tím Dark Aura
}

-- 2. TẠO GUI ĐẲNG CẤP (TITAN UI)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 380)
Main.Position = UDim2.new(0.5, -140, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "VANGUARD TITAN"
Title.TextColor3 = Config.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Title)

-- 3. SPEED SLIDER (Thanh kéo đẳng cấp)
local SliderFrame = Instance.new("Frame", Main)
SliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
SliderFrame.Position = UDim2.new(0.05, 0, 0, 60)
SliderFrame.BackgroundTransparency = 1

local SpeedLabel = Instance.new("TextLabel", SliderFrame)
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Text = "Tốc độ: 16"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1

local Bar = Instance.new("Frame", SliderFrame)
Bar.Size = UDim2.new(1, 0, 0, 6)
Bar.Position = UDim2.new(0, 0, 0, 30)
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

-- Logic Slider
local dragging = false
Knob.MouseButton1Down:Connect(function() dragging = true end)
Services.UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

Services.UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -8, 0.5, -8)
        Config.Speed = 16 + (pos * 84) -- Range từ 16 đến 100
        SpeedLabel.Text = "Tốc độ: " .. math.floor(Config.Speed)
    end
end)

-- 4. DESYNC & VISUALS TOGGLES
local function CreateToggle(text, pos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local desyncBtn = CreateToggle("DESYNC: OFF", UDim2.new(0.05, 0, 0, 120), function()
    Config.Desync = not Config.Desync
end)

local visualBtn = CreateToggle("AURA & BUBBLES: OFF", UDim2.new(0.05, 0, 0, 170), function()
    Config.Visuals = not Config.Visuals
    if not Config.Visuals then
        local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then for _, v in pairs(hrp:GetChildren()) do if v.Name == "VanguardFX" then v:Destroy() end end end
    end
end)

-- 5. LOGIC DI CHUYỂN & DESYNC (Micro-Delta Sync)
RunService.PreSimulation:Connect(function(dt)
    local char = LPlr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if hrp and hum then
        -- Speed Logic
        if Config.Active and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.Speed * dt))
        end
        
        -- Desync Logic (Ghost Effect)
        if Config.Desync then
            local ghostPos = hrp.CFrame * CFrame.new(math.random(-2,2), 0, math.random(-2,2))
            -- Phân thân ảo để đánh lừa anti-cheat và người chơi
            if math.random(1, 5) == 1 then
                hrp.CFrame = ghostPos
                RunService.RenderStepped:Wait()
                hrp.CFrame = ghostPos:Inverse()
            end
        end
    end
end)

-- 6. HIỆU ỨNG AURA & BONG BÓNG (Tối ưu)
RunService.RenderStepped:Connect(function()
    if Config.Visuals and LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LPlr.Character.HumanoidRootPart
        if not hrp:FindFirstChild("VanguardFX") then
            -- Aura tối (Dark Aura)
            local aura = Instance.new("ParticleEmitter", hrp)
            aura.Name = "VanguardFX"
            aura.Texture = "rbxassetid://241499986" -- Khói mờ
            aura.Color = ColorSequence.new(Color3.fromRGB(0,0,0), Config.Accent)
            aura.Rate = 20
            aura.Speed = NumberRange.new(1)
            aura.Size = NumberSequence.new(3, 0)
            aura.Transparency = NumberSequence.new(0.5, 1)
            
            -- Bong bóng bay lên (Bubbles)
            local bubbles = Instance.new("ParticleEmitter", hrp)
            bubbles.Name = "VanguardFX"
            bubbles.Texture = "rbxassetid://6071575291" -- Bong bóng
            bubbles.Rate = 10
            bubbles.Speed = NumberRange.new(5, 10)
            bubbles.VelocityInheritance = 0.2
            bubbles.EmissionDirection = Enum.NormalId.Top
            bubbles.Size = NumberSequence.new(0.5, 1.5)
            bubbles.Lifetime = NumberRange.new(1, 2)
        end
    end
end)

-- 7. SERVER HOP & UI UPDATE
local hopBtn = CreateButton("SERVER HOP", UDim2.new(0.05, 0, 0, 220), function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local servers = HttpService:JSONDecode(game:HttpGet(url)).data
    local nextS = servers[math.random(1, #servers)]
    if nextS.id ~= game.JobId then Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, nextS.id) end
end)

RunService.RenderStepped:Connect(function()
    desyncBtn.Text = "DESYNC: " .. (Config.Desync and "ON" or "OFF")
    visualBtn.Text = "VISUALS: " .. (Config.Visuals and "ON" or "OFF")
    desyncBtn.TextColor3 = Config.Desync and Config.Accent or Color3.new(1,1,1)
    visualBtn.TextColor3 = Config.Visuals and Config.Accent or Color3.new(1,1,1)
end)

CreateButton("CLOSE", UDim2.new(0.05, 0, 0, 320), function() ScreenGui:Destroy() end)

print("⚡ VANGUARD TITAN LOADED. BAC-6153 Resolved.")
