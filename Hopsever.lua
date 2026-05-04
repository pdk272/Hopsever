--[[ 
    GHOST LAG V1 - DESYNC ATTACK
    - Tạo ra sự mất đồng bộ vị trí liên tục.
    - Người chơi khác nhìn thấy ông sẽ bị giật khung hình (FPS Drop).
]]

local RunService = game:GetService("RunService")
local char = game.Players.LocalPlayer.Character
local root = char:FindFirstChild("HumanoidRootPart")

local active = false
local angle = 0

-- Tạo nút bấm
local sg = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 100, 0, 50)
btn.Position = UDim2.new(0, 50, 0, 200)
btn.Text = "DESYNC LAG"

btn.MouseButton1Click:Connect(function()
    active = not active
    btn.BackgroundColor3 = active and Color3.new(0,1,0) or Color3.new(1,0,0)
end)

-- Vòng lặp bẻ cong vị trí (Làm người khác lag khi nhìn mình)
RunService.Stepped:Connect(function()
    if active and root then
        angle = angle + 0.5
        -- Đưa vị trí thật ra xa rồi kéo về trong 1 frame
        local oldPos = root.CFrame
        root.CFrame = oldPos * CFrame.new(math.sin(angle) * 50, 0, 0)
        RunService.RenderStepped:Wait()
        root.CFrame = oldPos
    end
end)
