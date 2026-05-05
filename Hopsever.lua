-- TITAN LITE (TP + SPEED SAFE)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LPlr = Players.LocalPlayer

local Config = {
    Speed = 16,
    Active = false
}

local Pos1, Pos2

-- GUI
local sg = Instance.new("ScreenGui", LPlr.PlayerGui)
sg.Name = "TitanLite"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 260)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local function btn(text, y, cb)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
    return b
end

-- SAVE / TP
btn("LƯU BASE", 20, function()
    local c = LPlr.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        Pos1 = c.HumanoidRootPart.CFrame
    end
end)

btn("TP BASE", 70, function()
    local c = LPlr.Character
    if Pos1 and c then
        c.HumanoidRootPart.CFrame = Pos1
    end
end)

btn("LƯU PET", 120, function()
    local c = LPlr.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        Pos2 = c.HumanoidRootPart.CFrame
    end
end)

btn("TP PET", 170, function()
    local c = LPlr.Character
    if Pos2 and c then
        c.HumanoidRootPart.CFrame = Pos2
    end
end)

-- SPEED
local speedBtn = btn("SPEED: OFF", 220, function()
    Config.Active = not Config.Active
end)

RunService.RenderStepped:Connect(function(dt)
    local c = LPlr.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildOfClass("Humanoid")

    if Config.Active and hrp and hum and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.Speed * dt))
    end

    speedBtn.Text = Config.Active and ("SPEED: "..Config.Speed) or "SPEED: OFF"
end)
