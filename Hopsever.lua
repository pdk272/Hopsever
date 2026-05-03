-- Khoi tao GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedLabel = Instance.new("TextLabel")
local SpeedSlider = Instance.new("TextButton")
local SpeedIndicator = Instance.new("Frame")
local PickToggle = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Khung chinh
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "BRAINROT CUSTOM V4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- BIEN DIEU KHIEN
local TargetSpeed = 16
local PickNearest = false
local PickRange = 25 -- Khoang cach de pick E (met)

-- SPEED SLIDER (Thanh keo)
SpeedLabel.Parent = MainFrame
SpeedLabel.Position = UDim2.new(0, 10, 0, 45)
SpeedLabel.Size = UDim2.new(0, 200, 0, 20)
SpeedLabel.Text = "Speed: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundTransparency = 1

SpeedSlider.Parent = MainFrame
SpeedSlider.Position = UDim2.new(0, 10, 0, 70)
SpeedSlider.Size = UDim2.new(0, 200, 0, 10)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedSlider.Text = ""

SpeedIndicator.Parent = SpeedSlider
SpeedIndicator.Size = UDim2.new(0, 5, 1.5, 0)
SpeedIndicator.Position = UDim2.new(0, 0, -0.25, 0)
SpeedIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 100)

-- Logic keo thanh Speed
local UIS = game:GetService("UserInputService")
local dragging = false

SpeedSlider.MouseButton1Down:Connect(function() dragging = true end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - SpeedSlider.AbsolutePosition.X) / SpeedSlider.AbsoluteSize.X, 0, 1)
        SpeedIndicator.Position = UDim2.new(pos, -2, -0.25, 0)
        TargetSpeed = math.floor(16 + (pos * 134)) -- Min 16, Max 150
        SpeedLabel.Text = "Speed: " .. tostring(TargetSpeed)
    end
end)

-- Duy tri Speed
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = TargetSpeed
        end
    end)
end)

-- PICK E GAN TOI
PickToggle.Parent = MainFrame
PickToggle.Position = UDim2.new(0, 10, 0, 100)
PickToggle.Size = UDim2.new(0, 200, 0, 40)
PickToggle.Text = "Smart Pick E: OFF"
PickToggle.BackgroundColor3 = Color3.fromRGB(150, 50, 50)

PickToggle.MouseButton1Click:Connect(function()
    PickNearest = not PickNearest
    PickToggle.Text = PickNearest and "Smart Pick E: ON" or "Smart Pick E: OFF"
    PickToggle.BackgroundColor3 = PickNearest and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
end)

-- Vong lap quet E o gan
spawn(function()
    while task.wait(0.2) do
        if PickNearest then
            pcall(function()
                local myPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        local dist = (v.Parent:IsA("BasePart") and (v.Parent.Position - myPos).Magnitude) or 100
                        if dist <= PickRange then
                            v.HoldDuration = 0
                        else
                            -- Tra lai thoi gian goc neu o xa de do lag
                            v.HoldDuration = 2 
                        end
                    end
                end
            end)
        end
    end
end)

print("Da kich hoat Smart Script V4")
