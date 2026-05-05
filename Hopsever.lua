--[[
    VANGUARD TITAN: QUANTUM SYNC (V21.0)
    - Logic: Metatable Hooking (Móc gói tin).
    - Phân tích: Tự động "kẹp" lệnh Gift vào gói tin Trade.
    - Keybind: K (Menu), 4 nút Teleport vẫn giữ nguyên.
]]

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LPlr = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Titan = {
    Pos1 = nil, Pos2 = nil,
    Visible = true, FastE = true,
    SyncMode = true -- Luôn bật chế độ đồng bộ
}

-- 1. GUI (4 NÚT CHIẾN THUẬT THEO YÊU CẦU)
local ScreenGui = Instance.new("ScreenGui", LPlr.PlayerGui)
ScreenGui.Name = "TitanQuantum"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 380)
Main.Position = UDim2.new(0.5, -150, 0.4, -190)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local List = Instance.new("UIListLayout", Main)
List.Padding = UDim.new(0, 10)
List.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Main).PaddingTop = UDim.new(0, 50)

local function NewBtn(text, color, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
end

NewBtn("1. LƯU VỊ TRÍ 1", Color3.fromRGB(40, 40, 60), function() Titan.Pos1 = LPlr.Character.HumanoidRootPart.CFrame end)
NewBtn("2. TELE VỊ TRÍ 1", Color3.fromRGB(0, 100, 200), function() if Titan.Pos1 then LPlr.Character.HumanoidRootPart.CFrame = Titan.Pos1 end end)
NewBtn("3. LƯU VỊ TRÍ 2", Color3.fromRGB(40, 40, 60), function() Titan.Pos2 = LPlr.Character.HumanoidRootPart.CFrame end)
NewBtn("4. TELE VỊ TRÍ 2", Color3.fromRGB(0, 150, 100), function() if Titan.Pos2 then LPlr.Character.HumanoidRootPart.CFrame = Titan.Pos2 end end)

-- 2. HỆ THỐNG "ĐÁNH BẠI" SERVER (QUANTUM HOOK)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Khi ông nhấn Confirm Trade trong game
    if method == "FireServer" and tostring(self) == "TradeConfirm" and Titan.SyncMode then
        -- Gói tin Trade vừa bay ra, ta "kẹp" ngay lệnh Gift vào
        task.spawn(function()
            for i = 1, 5 do -- Nã 5 phát Gift liên tục để ép Race Condition
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        -- Giả lập nhấn E ngay lập tức
                        if fireproximityprompt then fireproximityprompt(v) end
                    end
                end
            end
        end)
        print("⚡ QUANTUM SYNC: Đã kẹp lệnh Gift vào gói tin Trade!")
    end

    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- 3. CƠ CHẾ FAST E THÔNG THƯỜNG
RunService.Heartbeat:Connect(function()
    if Titan.FastE then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                if (LPlr.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude <= v.MaxActivationDistance then
                    if fireproximityprompt then fireproximityprompt(v) end
                end
            end
        end
    end
end)

-- TOGGLE K
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then
        Titan.Visible = not Titan.Visible
        Main.Visible = Titan.Visible
    end
end)

print("🌌 TITAN QUANTUM V21.0 - Đã sẵn sàng đánh bại Logic Server.")
