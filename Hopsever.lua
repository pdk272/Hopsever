--[[ 
    PRO VIP MENU - STEAL A BRAINROT EDITION
    - Speed Bypass (CFrame Method - No Delay)
    - Smart ESP (Find High Income Pets)
    - Ultra Fast Server Hop (0.001s Command)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- 1. TẠO GUI (Né CoreGui, dùng PlayerGui)
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "BRAINROT VIP PRO"
Title.TextColor3 = Color3.new(1, 0.8, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- 2. SPEED BYPASS (CFrame - Không đổi WalkSpeed để né Anti-Cheat)
local SpeedLabel = Instance.new("TextLabel", MainFrame)
SpeedLabel.Text = "Tốc độ: 16"
SpeedLabel.Position = UDim2.new(0, 10, 0, 40)
SpeedLabel.Size = UDim2.new(0, 100, 0, 30)
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1

local SpeedInput = Instance.new("TextBox", MainFrame)
SpeedInput.Size = UDim2.new(0, 80, 0, 30)
SpeedInput.Position = UDim2.new(0, 120, 0, 40)
SpeedInput.PlaceholderText = "Nhập speed..."
SpeedInput.Text = "30"
SpeedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedInput.TextColor3 = Color3.new(1, 1, 1)

local currentSpeed = 16
SpeedInput.FocusLost:Connect(function()
    currentSpeed = tonumber(SpeedInput.Text) or 16
end)

RunService.Stepped:Connect(function()
    if currentSpeed > 16 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum.MoveDirection.Magnitude > 0 then
            -- Di chuyển nhân vật bằng CFrame để qua mặt Anti-Cheat
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (currentSpeed / 50))
        end
    end
end)

-- 3. ESP PET NHIỀU TIỀN (Smart Scanner)
local ESPBtn = Instance.new("TextButton", MainFrame)
ESPBtn.Size = UDim2.new(0.9, 0, 0, 40)
ESPBtn.Position = UDim2.new(0.05, 0, 0, 80)
ESPBtn.Text = "BẬT ESP PET XỊN"
ESPBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ESPBtn.TextColor3 = Color3.new(1, 1, 1)

local espActive = false
ESPBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    ESPBtn.Text = espActive and "ĐANG QUÉT PET..." or "BẬT ESP PET XỊN"
    
    -- Xóa Highlight cũ
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Highlight") and v.Name == "PetESP" then v:Destroy() end
    end
end)

task.spawn(function()
    while true do
        if espActive then
            for _, v in pairs(workspace:GetDescendants()) do
                -- Tìm các Model Pet có chứa giá trị tiền (thường là BillBoardGui hoặc Value)
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    local isRich = false
                    -- Quét xem con pet này có nhiều tiền /s không (Giả định keyword là $/s hoặc Cash)
                    for _, info in pairs(v:GetDescendants()) do
                        if info:IsA("TextLabel") and (info.Text:find("/s") or info.Text:find("Q") or info.Text:find("ss")) then
                            isRich = true
                        end
                    end
                    
                    if isRich and not v:FindFirstChild("PetESP") then
                        local highlight = Instance.new("Highlight", v)
                        highlight.Name = "PetESP"
                        highlight.FillColor = Color3.new(1, 1, 0) -- Màu vàng cho pet xịn
                        highlight.OutlineColor = Color3.new(1, 1, 1)
                    end
                end
            end
        end
        task.wait(2) -- Quét mỗi 2 giây để ko lag
    end
end)

-- 4. HOP SERVER SIÊU TỐC (0.001s Command)
local HopBtn = Instance.new("TextButton", MainFrame)
HopBtn.Size = UDim2.new(0.9, 0, 0, 40)
HopBtn.Position = UDim2.new(0.05, 0, 0, 130)
HopBtn.Text = "ĐỔI SERVER NHANH"
HopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
HopBtn.TextColor3 = Color3.new(1, 1, 1)

HopBtn.MouseButton1Click:Connect(function()
    print("🚀 Đang nhảy server...")
    local Http = game:GetService("HttpService")
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local _List = Http:JSONDecode(game:HttpGet(Api))
    local _ID = _List.data[math.random(1, #_List.data)].id
    TeleportService:TeleportToPlaceInstance(game.PlaceId, _ID, LocalPlayer)
end)

-- 5. NÚT ĐÓNG MENU
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0.9, 0, 0, 30)
CloseBtn.Position = UDim2.new(0.05, 0, 0, 240)
CloseBtn.Text = "ĐÓNG MENU"
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

print("💎 VIP PRO MENU LOADED! Không lỗi Line 7, Speed Bypass sẵn sàng.")
