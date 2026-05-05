--[[
    SOLARA OMNI-FIX (V27.0)
    - Fix 1: Super Spin Kick (Fling) - Quay cực nhanh để ép văng mục tiêu.
    - Fix 2: Custom Drag - Di chuyển mượt mà cả 3 Panel.
    - Fix 3: Teleport Pet/Player - Quét Model và BasePart chính xác.
]]

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LPlr = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local Mouse = LPlr:GetMouse()

local Titan = {
    Visible = true,
    Speed = 16, SpeedEnabled = false,
    FlyEnabled = false, Noclip = false,
    ESP = false, Aimbot = false,
    PosBase = nil, PosPet = nil,
    Accent = Color3.fromRGB(150, 0, 255),
    Secondary = Color3.fromRGB(0, 255, 255),
    AnnoyTarget = nil
}

-- 1. HÀM KÉO THẢ MƯỢT (CUSTOM DRAG)
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- 2. TẠO BONG BÓNG
local function CreateBubbles(parent)
    task.spawn(function()
        while true do
            task.wait(math.random(2, 4))
            local b = Instance.new("Frame", parent)
            b.Size = UDim2.new(0, 0, 0, 0)
            b.Position = UDim2.new(math.random(), 0, 1, 0)
            b.BackgroundColor3 = Color3.new(1, 1, 1)
            b.BackgroundTransparency = 0.8
            Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
            local s = math.random(8, 18)
            TweenService:Create(b, TweenInfo.new(math.random(4, 7)), {
                Size = UDim2.new(0, s, 0, s),
                Position = UDim2.new(b.Position.X.Scale, 0, -0.2, 0),
                BackgroundTransparency = 1
            }):Play()
            task.delay(7, function() b:Destroy() end)
        end
    end)
end

-- 3. KHỞI TẠO GUI (3 PANEL)
local ScreenGui = Instance.new("ScreenGui", LPlr:WaitForChild("PlayerGui"))
ScreenGui.Name = "TitanV27"
ScreenGui.ResetOnSpawn = false

local function NewBtn(parent, text, color, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.BackgroundColor3 = color or Color3.fromRGB(30, 30, 40)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

-- PANEL GIỮA (MAIN)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 480)
Main.Position = UDim2.new(0.5, -190, 0.4, -240)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main)
CreateBubbles(Main)
MakeDraggable(Main) -- Áp dụng kéo thả

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.new(1, 1, 1)
local Grad = Instance.new("UIGradient", Header)
Grad.Color = ColorSequence.new(Titan.Accent, Titan.Secondary)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "TITAN MAIN • SOLARA"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

local MidScroll = Instance.new("ScrollingFrame", Main)
MidScroll.Size = UDim2.new(1, 0, 0.88, 0)
MidScroll.Position = UDim2.new(0, 0, 0.12, 0)
MidScroll.BackgroundTransparency = 1
MidScroll.ScrollBarThickness = 0
local MidList = Instance.new("UIListLayout", MidScroll)
MidList.Padding = UDim.new(0, 12)
MidList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- PANEL TRÁI (INFO)
local LeftFrame = Instance.new("Frame", ScreenGui)
LeftFrame.Size = UDim2.new(0, 200, 0, 350)
LeftFrame.Position = UDim2.new(0.5, -400, 0.4, -175)
LeftFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", LeftFrame)
MakeDraggable(LeftFrame) -- Áp dụng kéo thả

local Avatar = Instance.new("ImageLabel", LeftFrame)
Avatar.Size = UDim2.new(0, 100, 0, 100)
Avatar.Position = UDim2.new(0.5, -50, 0.1, 0)
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..LPlr.UserId.."&w=150&h=150"
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

-- PANEL PHẢI (UTILS)
local RightFrame = Instance.new("Frame", ScreenGui)
RightFrame.Size = UDim2.new(0, 240, 0, 450)
RightFrame.Position = UDim2.new(0.5, 200, 0.4, -225)
RightFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", RightFrame)
MakeDraggable(RightFrame) -- Áp dụng kéo thả
local RightList = Instance.new("UIListLayout", RightFrame)
RightList.Padding = UDim.new(0, 12)
RightList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function SetToggle(side, btnText, frame)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 35, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.Text = btnText
    b.TextSize = 20
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.Position = (side == "L") and UDim2.new(0, -40, 0, 0) or UDim2.new(1, 5, 0, 0)
    
    b.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
        if side == "L" then b.Text = frame.Visible and "<" or ">" else b.Text = frame.Visible and ">" or "<" end
    end)
end
SetToggle("L", "<", LeftFrame)
SetToggle("R", ">", RightFrame)

-- 4. CHỨC NĂNG SỬA LỖI VÀ NÂNG CẤP

-- SPEED SLIDER
local SpeedLabel = Instance.new("TextLabel", MidScroll)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 30)
SpeedLabel.Text = "SPEED: [16]"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.TextSize = 18
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.BackgroundTransparency = 1

local SpeedBar = Instance.new("Frame", MidScroll)
SpeedBar.Size = UDim2.new(0.85, 0, 0, 10)
SpeedBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", SpeedBar)
local Fill = Instance.new("Frame", SpeedBar)
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Fill)

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

-- MAIN BTNS
NewBtn(MidScroll, "SAVE BASE", Color3.fromRGB(40, 40, 60), function() Titan.PosBase = LPlr.Character.HumanoidRootPart.CFrame end)
NewBtn(MidScroll, "TP BASE", Color3.fromRGB(0, 120, 255), function() if Titan.PosBase then LPlr.Character.HumanoidRootPart.CFrame = Titan.PosBase end end)
NewBtn(MidScroll, "SAVE PET", Color3.fromRGB(40, 40, 60), function() Titan.PosPet = LPlr.Character.HumanoidRootPart.CFrame end)
NewBtn(MidScroll, "TP PET", Color3.fromRGB(0, 180, 120), function() if Titan.PosPet then LPlr.Character.HumanoidRootPart.CFrame = Titan.PosPet end end)

NewBtn(MidScroll, "NOCLIP: OFF", nil, function(b) 
    Titan.Noclip = not Titan.Noclip 
    b.Text = "NOCLIP: "..(Titan.Noclip and "ON" or "OFF")
    b.TextColor3 = Titan.Noclip and Titan.Secondary or Color3.new(1, 1, 1)
end)

NewBtn(MidScroll, "FLY: OFF", nil, function(b) 
    Titan.FlyEnabled = not Titan.FlyEnabled 
    b.Text = "FLY: "..(Titan.FlyEnabled and "ON" or "OFF")
    b.TextColor3 = Titan.FlyEnabled and Titan.Secondary or Color3.new(1, 1, 1)
end)

-- RIGHT BTNS (UTILS)
local TargetBox = Instance.new("TextBox", RightFrame)
TargetBox.Size = UDim2.new(0.9, 0, 0, 45)
TargetBox.PlaceholderText = "NAME PLAYER OR PET"
TargetBox.TextSize = 14
TargetBox.Font = Enum.Font.GothamBold
TargetBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TargetBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TargetBox)

-- FIX 3: TELEPORT CẢ PLAYER LẪN PET (MODEL & PART)
NewBtn(RightFrame, "TELEPORT", Color3.fromRGB(0, 150, 255), function()
    local t = TargetBox.Text:lower()
    if t == "" then return end
    
    -- Ưu tiên tìm Player
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(t) or p.DisplayName:lower():find(t) then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LPlr.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                return
            end
        end
    end
    
    -- Sau đó tìm Pet (Hỗ trợ Model và BasePart)
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find(t) then
            if v:IsA("Model") and v.PrimaryPart then
                LPlr.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
                return
            elseif v:IsA("BasePart") then
                LPlr.Character.HumanoidRootPart.CFrame = v.CFrame
                return
            end
        end
    end
end)

NewBtn(RightFrame, "HOPSERVER", Color3.fromRGB(100, 0, 200), function()
    local s = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100")).data
    for _, v in pairs(s) do if v.playing < v.maxPlayers and v.id ~= game.JobId then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id) break end end
end)

NewBtn(RightFrame, "AIMBOT: OFF", nil, function(b) 
    Titan.Aimbot = not Titan.Aimbot 
    b.Text = "AIMBOT: "..(Titan.Aimbot and "ON" or "OFF")
    b.TextColor3 = Titan.Aimbot and Titan.Secondary or Color3.new(1, 1, 1)
end)

-- FIX 1: KICK / ANNOY PLAYER (SUPER SPIN FLING)
local KickBtn = NewBtn(RightFrame, "KICK/ANNOY: OFF", Color3.fromRGB(200, 0, 0), function(b)
    if Titan.AnnoyTarget then
        Titan.AnnoyTarget = nil
        b.Text = "KICK/ANNOY: OFF"
        -- Dừng xoay
        local myHrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
        if myHrp then myHrp.RotVelocity = Vector3.new(0, 0, 0) end
    else
        local t = TargetBox.Text:lower()
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():find(t) or p.DisplayName:lower():find(t) then
                Titan.AnnoyTarget = p.Name
                b.Text = "FLINGING: " .. p.Name
                break
            end
        end
    end
end)

-- LEFT BTNS (INFO)
NewBtn(LeftFrame, "RESET ĐỒ (FAST)", Color3.fromRGB(150, 0, 0), function() LPlr.Character:BreakJoints() end)
NewBtn(LeftFrame, "ESP: OFF", nil, function(b) 
    Titan.ESP = not Titan.ESP 
    b.Text = "ESP BOX/NAME: "..(Titan.ESP and "ON" or "OFF")
    b.TextColor3 = Titan.ESP and Titan.Secondary or Color3.new(1, 1, 1)
end)

-- 5. CORE ENGINE (CÁC VÒNG LẶP HỆ THỐNG)

-- ESP Box & Name
RunService.RenderStepped:Connect(function()
    if Titan.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LPlr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local tag = hrp:FindFirstChild("TitanESPBox")
                
                if not tag then
                    tag = Instance.new("BillboardGui", hrp)
                    tag.Name = "TitanESPBox"
                    tag.Size = UDim2.new(4, 0, 5, 0) 
                    tag.AlwaysOnTop = true
                    
                    local box = Instance.new("Frame", tag)
                    box.Size = UDim2.new(1, 0, 1, 0)
                    box.BackgroundTransparency = 1
                    local stroke = Instance.new("UIStroke", box)
                    stroke.Color = Titan.Secondary
                    stroke.Thickness = 2
                    
                    local nameLbl = Instance.new("TextLabel", box)
                    nameLbl.Size = UDim2.new(1, 0, 0, 20)
                    nameLbl.Position = UDim2.new(0, 0, -0.2, 0)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.Text = p.Name
                    nameLbl.TextColor3 = Color3.new(1,1,1)
                    nameLbl.Font = Enum.Font.GothamBold
                    nameLbl.TextStrokeTransparency = 0
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tag = p.Character.HumanoidRootPart:FindFirstChild("TitanESPBox")
                if tag then tag:Destroy() end
            end
        end
    end
end)

-- Aimbot (Mượt và theo chuột)
RunService.RenderStepped:Connect(function()
    if Titan.Aimbot then
        local target = nil
        local shortestDistance = math.huge
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LPlr and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local mag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if mag < shortestDistance then
                        target = head
                        shortestDistance = mag
                    end
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

-- Fix 1: Super Spin Fling (Kick Player)
RunService.Stepped:Connect(function()
    if Titan.AnnoyTarget then
        local targetPlayer = Players:FindFirstChild(Titan.AnnoyTarget)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myHrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
            if myHrp then
                -- Ép nhân vật quay cực nhanh
                myHrp.RotVelocity = Vector3.new(0, 50000, 0)
                -- Dịch chuyển đè lên đối phương
                myHrp.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Speed & Noclip & Fly
RunService.Heartbeat:Connect(function(dt)
    local char = LPlr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if Titan.FlyEnabled then
        local d = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + Camera.CFrame.RightVector end
        hrp.Velocity = Vector3.zero
        hrp.CFrame = hrp.CFrame + (d * 100 * dt)
    else
        if Titan.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * ((Titan.Speed - 16) * dt))
        end
    end
end)

RunService.Stepped:Connect(function()
    if Titan.Noclip and LPlr.Character then
        for _, v in pairs(LPlr.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then
        Titan.Visible = not Titan.Visible
        Main.Visible = Titan.Visible
        LeftFrame.Visible = Titan.Visible
        RightFrame.Visible = Titan.Visible
    end
end)

print("🌌 TITAN V27.0 - ULTIMATE FLING & DRAG READY!")
