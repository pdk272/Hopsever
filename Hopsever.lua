--[[
    VANGUARD TITAN: OMNI-SOLARA V24.0
    - Theme: Solara Dark / Purple-Cyan Gradient
    - Layout: 3-Panel System (Left, Middle, Right)
    - Effects: Floating Bubbles / Smooth Animations
    - Keybind: K (Toggle All)
]]

-- 1. KHỞI TẠO HỆ THỐNG
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LPlr = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local Titan = {
    Visible = true,
    Speed = 16, SpeedEnabled = false,
    FlyEnabled = false, Noclip = false,
    ESP = false, Aimbot = false,
    PosBase = nil, PosPet = nil,
    TargetName = "",
    Accent = Color3.fromRGB(150, 0, 255),
    Secondary = Color3.fromRGB(0, 255, 255)
}

-- 2. TẠO GUI GỐC
local ScreenGui = Instance.new("ScreenGui", LPlr:WaitForChild("PlayerGui"))
ScreenGui.Name = "TitanOmniSolara"
ScreenGui.ResetOnSpawn = false

-- HÀM TẠO BONG BÓNG (BUBBLE EFFECT)
local function CreateBubbles(parent)
    task.spawn(function()
        while true do
            task.wait(math.random(1, 3))
            local bubble = Instance.new("Frame", parent)
            bubble.Size = UDim2.new(0, 0, 0, 0)
            bubble.Position = UDim2.new(math.random(), 0, 1, 0)
            bubble.BackgroundColor3 = Color3.new(1, 1, 1)
            bubble.BackgroundTransparency = 0.8
            Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)
            
            local size = math.random(5, 15)
            local goal = {
                Size = UDim2.new(0, size, 0, size),
                Position = UDim2.new(bubble.Position.X.Scale, 0, -0.1, 0),
                BackgroundTransparency = 1
            }
            local tween = TweenService:Create(bubble, TweenInfo.new(math.random(5, 8)), goal)
            tween:Play()
            tween.Completed:Connect(function() bubble:Destroy() end)
        end
    end)
end

-- 3. CẤU TRÚC 3 PANEL (TRÁI - GIỮA - PHẢI)

-- GUI CHÍNH (GIỮA)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 400, 0, 450)
Main.Position = UDim2.new(0.5, -200, 0.4, -225)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
CreateBubbles(Main)

-- Thanh Header Gradient
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.new(1, 1, 1)
local Grad = Instance.new("UIGradient", Header)
Grad.Color = ColorSequence.new(Titan.Accent, Titan.Secondary)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "TITAN OMNI • MAIN"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- GUI TRÁI (INFO)
local LeftFrame = Instance.new("Frame", ScreenGui)
LeftFrame.Size = UDim2.new(0, 200, 0, 300)
LeftFrame.Position = UDim2.new(0.5, -410, 0.4, -150)
LeftFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", LeftFrame)

local InfoTitle = Instance.new("TextLabel", LeftFrame)
InfoTitle.Size = UDim2.new(1, 0, 0, 40)
InfoTitle.Text = "INFO PLAYER"
InfoTitle.TextColor3 = Titan.Secondary
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.BackgroundTransparency = 1

local Avatar = Instance.new("ImageLabel", LeftFrame)
Avatar.Size = UDim2.new(0, 80, 0, 80)
Avatar.Position = UDim2.new(0.5, -40, 0.2, 0)
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..LPlr.UserId.."&w=150&h=150"
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

-- GUI PHẢI (UTILS)
local RightFrame = Instance.new("Frame", ScreenGui)
RightFrame.Size = UDim2.new(0, 220, 0, 400)
RightFrame.Position = UDim2.new(0.5, 210, 0.4, -200)
RightFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", RightFrame)

-- NÚT ĐIỀU KHIỂN GỌN GUI (TOGGLES)
local function CreateSideToggle(side, parentFrame, startText)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = startText
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    
    if side == "left" then
        btn.Position = UDim2.new(0, -35, 0, 5)
    else
        btn.Position = UDim2.new(1, 5, 0, 5)
    end
    
    btn.MouseButton1Click:Connect(function()
        parentFrame.Visible = not parentFrame.Visible
        if side == "left" then
            btn.Text = parentFrame.Visible and "<" or ">"
        else
            btn.Text = parentFrame.Visible and ">" or "<"
        end
    end)
end

CreateSideToggle("left", LeftFrame, "<")
CreateSideToggle("right", RightFrame, ">")

-- 4. CÁC NÚT CHỨC NĂNG (MIDDLE)
local MidContainer = Instance.new("ScrollingFrame", Main)
MidContainer.Size = UDim2.new(1, 0, 0.85, 0)
MidContainer.Position = UDim2.new(0, 0, 0.12, 0)
MidContainer.BackgroundTransparency = 1
MidContainer.ScrollBarThickness = 0
local MidList = Instance.new("UIListLayout", MidContainer)
MidList.Padding = UDim.new(0, 10)
MidList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function NewBtn(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.9, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- SPEED SLIDER
local SpeedLabel = Instance.new("TextLabel", MidContainer)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
SpeedLabel.Text = "SPEED: [16]"
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.BackgroundTransparency = 1

local SpeedBar = Instance.new("Frame", MidContainer)
SpeedBar.Size = UDim2.new(0.8, 0, 0, 8)
SpeedBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
local Fill = Instance.new("Frame", SpeedBar)
Fill.Size = UDim2.new(0.1, 0, 1, 0)
Fill.BackgroundColor3 = Color3.new(1, 1, 1) -- Thanh trắng theo ý ông

SpeedBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local pos = math.clamp((UIS:GetMouseLocation().X - SpeedBar.AbsolutePosition.X) / SpeedBar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            Titan.Speed = math.floor(16 + (pos * 184))
            SpeedLabel.Text = "SPEED: ["..Titan.Speed.."]"
            if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then conn:Disconnect() end
        end)
    end
end)

NewBtn(MidContainer, "SAVE BASE", function() Titan.PosBase = LPlr.Character.HumanoidRootPart.CFrame end)
NewBtn(MidContainer, "TP BASE", function() if Titan.PosBase then LPlr.Character.HumanoidRootPart.CFrame = Titan.PosBase end end)
NewBtn(MidContainer, "SAVE PET", function() Titan.PosPet = LPlr.Character.HumanoidRootPart.CFrame end)
NewBtn(MidContainer, "TP PET", function() if Titan.PosPet then LPlr.Character.HumanoidRootPart.CFrame = Titan.PosPet end end)

local FlyBtn = NewBtn(MidContainer, "FLY: OFF", function() Titan.FlyEnabled = not Titan.FlyEnabled end)
local NoclipBtn = NewBtn(MidContainer, "NOCLIP: OFF", function() Titan.Noclip = not Titan.Noclip end)
local EspBtn = NewBtn(MidContainer, "ESP: OFF", function() Titan.ESP = not Titan.ESP end)

-- 5. UTILS (RIGHT)
local RightList = Instance.new("UIListLayout", RightFrame)
RightList.Padding = UDim.new(0, 10)
RightList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TargetBox = Instance.new("TextBox", RightFrame)
TargetBox.Size = UDim2.new(0.9, 0, 0, 40)
TargetBox.PlaceholderText = "NAME PLAYER OR PET"
TargetBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TargetBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TargetBox)

NewBtn(RightFrame, "TELEPORT TO TARGET", function()
    local name = TargetBox.Text:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(name) and p.Character then
            LPlr.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
            break
        end
    end
end)

NewBtn(RightFrame, "SERVER HOP", function()
    local Http = game:GetService("HttpService")
    local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _, s in pairs(servers) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end)

local AimBtn = NewBtn(RightFrame, "AIMBOT: OFF", function() Titan.Aimbot = not Titan.Aimbot end)

-- NÚT KICK/ANNOY (LÀM KHÓ CHỊU)
NewBtn(RightFrame, "ANNOY PLAYER", function()
    local name = TargetBox.Text:lower()
    task.spawn(function()
        while task.wait() do
            for _, p in pairs(Players:GetPlayers()) do
                if p.Name:lower():find(name) and p.Character then
                    LPlr.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                end
            end
        end
    end)
end)

-- 6. INFO (LEFT)
NewBtn(LeftFrame, "FAST RESET", function() LPlr.Character:BreakJoints() end)

-- 7. CORE LOGIC (VẬN HÀNH)

-- Loop chính
RunService.Heartbeat:Connect(function(dt)
    local char = LPlr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Speed & Fly
    if Titan.FlyEnabled then
        local dir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.CFrame = hrp.CFrame + (dir * 100 * dt)
    elseif UIS.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (UIS.MoveDirection * (Titan.Speed * dt))
    end

    -- Update UI Texts
    FlyBtn.Text = "FLY: "..(Titan.FlyEnabled and "ON" or "OFF")
    NoclipBtn.Text = "NOCLIP: "..(Titan.Noclip and "ON" or "OFF")
    EspBtn.Text = "ESP: "..(Titan.ESP and "ON" or "OFF")
    AimBtn.Text = "AIMBOT: "..(Titan.Aimbot and "ON" or "OFF")
end)

-- ESP & Noclip Loop
RunService.Stepped:Connect(function()
    if Titan.Noclip and LPlr.Character then
        for _, v in pairs(LPlr.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    
    if Titan.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LPlr and p.Character then
                local highlight = p.Character:FindFirstChild("TitanESP") or Instance.new("Highlight", p.Character)
                highlight.Name = "TitanESP"
                highlight.FillColor = Titan.Secondary
                highlight.OutlineColor = Color3.new(1, 1, 1)
            end
        end
    end
end)

-- Aimbot Logic
RunService.RenderStepped:Connect(function()
    if Titan.Aimbot then
        local target = nil
        local dist = 1000
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LPlr and p.Character and p.Character:FindFirstChild("Head") then
                local headPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local mag = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if mag < dist then target = p.Character.Head dist = mag end
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

-- Phím K đóng mở
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        Titan.Visible = not Titan.Visible
        Main.Visible = Titan.Visible
        LeftFrame.Visible = Titan.Visible
        RightFrame.Visible = Titan.Visible
    end
end)

print("🌌 TITAN OMNI-SOLARA V24.0 LOADED. K to Toggle.")
