--// ZEN DEV PANEL (FOR YOUR OWN GAME ONLY)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LPlr = Players.LocalPlayer

-- CONFIG
local Config = {
    Speed = 16,
    Noclip = false
}

local Saved = {
    Base = nil,
    Pet = nil
}

-- GUI
local gui = Instance.new("ScreenGui", LPlr.PlayerGui)
gui.Name = "ZenPanel"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 420)
main.Position = UDim2.new(0.5, -160, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0,255,200)
stroke.Transparency = 0.4

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "ZEN DEV PANEL"
title.TextColor3 = Color3.fromRGB(0,255,200)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

-- BUTTON FUNCTION
local function Btn(text, color, y, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- SAVE / TP
Btn("SAVE BASE", Color3.fromRGB(0,120,255), 60, function()
    local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then Saved.Base = hrp.CFrame end
end)

Btn("TP BASE", Color3.fromRGB(0,200,255), 110, function()
    if Saved.Base and LPlr.Character then
        LPlr.Character.HumanoidRootPart.CFrame = Saved.Base
    end
end)

Btn("SAVE PET", Color3.fromRGB(0,150,100), 160, function()
    local hrp = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then Saved.Pet = hrp.CFrame end
end)

Btn("TP PET", Color3.fromRGB(0,255,150), 210, function()
    if Saved.Pet and LPlr.Character then
        LPlr.Character.HumanoidRootPart.CFrame = Saved.Pet
    end
end)

-- NOCLIP
local noclipBtn = Btn("NOCLIP: OFF", Color3.fromRGB(80,80,80), 260, function()
    Config.Noclip = not Config.Noclip
end)

RunService.Stepped:Connect(function()
    if Config.Noclip and LPlr.Character then
        for _, v in pairs(LPlr.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- SPEED SLIDER
local slider = Instance.new("Frame", main)
slider.Size = UDim2.new(0.9,0,0,40)
slider.Position = UDim2.new(0.05,0,0,320)
slider.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", slider)

local bar = Instance.new("Frame", slider)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,255,200)
Instance.new("UICorner", bar)

local dragging = false

slider.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

slider.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(i)
    if dragging then
        local x = math.clamp((i.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        bar.Size = UDim2.new(x,0,1,0)
        Config.Speed = math.floor(1 + (49 * x)) -- 1 → 50
    end
end)

-- APPLY SPEED
RunService.RenderStepped:Connect(function()
    local hum = LPlr.Character and LPlr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = Config.Speed
    end
    
    noclipBtn.Text = Config.Noclip and "NOCLIP: ON" or "NOCLIP: OFF"
end)
