--[[ 
    BRAINROT V17 - ULTIMATE HUNTER (XENO PC)
    - Tất cả trong 1 GUI
    - Auto Hop liên tục (Continuous Hopping)
    - Fast Steal < 1s (Dưới 1 giây)
    - Speed 30 Chuẩn
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- DANH SÁCH 14 PET VIP
local TargetPets = {
    ["La Secret Combinasion"] = true, ["Lavadorito Spinito"] = true, ["Garama and Madundung"] = true,
    ["Ketchuru and Musturu"] = true, ["Ketupat Kepat"] = true, ["Tang Tang Keletang"] = true,
    ["Tictac Sahur"] = true, ["Money Money Puggy"] = true, ["Cerberus"] = true,
    ["Money Money Reindeer"] = true, ["Pretzo Robo"] = true, ["Popcuru and Fizzuru"] = true,
    ["Burguro and Fryuro"] = true, ["La Casa Boo"] = true
}

-- KHỞI TẠO GUI (ResetOnSpawn = false)
if LocalPlayer.PlayerGui:FindFirstChild("Brainrot_V17") then LocalPlayer.PlayerGui.Brainrot_V17:Destroy() end
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "Brainrot_V17"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 240)
Main.Position = UDim2.new(0.5, -130, 0.4, -120)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "BRAINROT ULTIMATE V17"
Title.BackgroundColor3 = Color3.fromRGB(85, 0, 255)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -20, 0, 60)
Status.Position = UDim2.new(0, 10, 0, 40)
Status.Text = "Đang khởi động..."
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.BackgroundTransparency = 1
Status.TextWrapped = true

-- --- TÍNH NĂNG 1: SPEED 30 ---
local SpeedActive = true
RunService.Heartbeat:Connect(function()
    if SpeedActive then
        pcall(function()
            local char = LocalPlayer.Character
            local root = char.HumanoidRootPart
            local hum = char.Humanoid
            if hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * (30 - 16) * 0.015)
            end
        end)
    end
end)

-- --- TÍNH NĂNG 2: FAST STEAL < 1S (0.1 GIÂY) ---
local FastStealActive = true
task.spawn(function()
    while true do
        if FastStealActive then
            pcall(function()
                for _, prompt in pairs(ProximityPromptService:GetProximityPrompts()) do
                    -- Chỉnh về 0.1s thay vì 0 để server dễ chấp nhận hơn
                    prompt.HoldDuration = 0.1
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- Tự động kích hoạt khi nhấn E
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if FastStealActive then
        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            prompt:InputBegan()
            task.wait(0.1)
            prompt:InputEnded()
        end
    end
end)

-- --- TÍNH NĂNG 3 & 4: FINDER & CONTINUOUS HOP ---
local function ServerHop()
    Status.Text = "Không có Pet.\nĐang nhảy Server liên tục..."
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local PlaceId = game.PlaceId
    -- Sử dụng API lọc server trống (tránh server full)
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    
    if success and result and result.data then
        for _, s in pairs(result.data) do
            -- Chỉ nhảy vào server còn trống ít nhất 3 chỗ
            if s.playing < (s.maxPlayers - 3) and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, s.id)
                -- Đợi 5 giây, nếu vẫn ở server cũ (tele thất bại) thì sẽ gọi lại hàm nhảy
                task.wait(5)
                ServerHop()
                return
            end
        end
    end
    task.wait(2)
    ServerHop()
end

local function ScanAndHop()
    local found = nil
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then
            found = v
            break 
        end
    end
    
    if found then
        Status.Text = "!!! THẤY PET VIP !!!\n" .. found.Name .. "\nĐÃ DỪNG NHẢY SERVER."
        Status.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        local hl = Instance.new("Highlight", found)
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        
        -- Chuông báo động
        for i = 1, 5 do
            local s = Instance.new("Sound", game.Workspace)
            s.SoundId = "rbxassetid://138090596"
            s.Volume = 3
            s:Play()
            task.wait(0.5)
        end
    else
        task.wait(2) -- Đợi 2 giây để chắc chắn map đã load xong pet
        ServerHop()
    end
end

-- --- NÚT BẬT/TẮT TỔNG HỢP ---
local HopToggle = Instance.new("TextButton", Main)
HopToggle.Size = UDim2.new(0, 200, 0, 40)
HopToggle.Position = UDim2.new(0.5, -100, 0, 110)
HopToggle.Text = "BẮT ĐẦU SĂN (AUTO)"
HopToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HopToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
HopToggle.Font = Enum.Font.GothamBold

HopToggle.MouseButton1Click:Connect(function()
    HopToggle.Text = "ĐANG CHẠY..."
    HopToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    ScanAndHop()
end)

local ManualScan = Instance.new("TextButton", Main)
ManualScan.Size = UDim2.new(0, 200, 0, 40)
ManualScan.Position = UDim2.new(0.5, -100, 0, 160)
ManualScan.Text = "QUÉT THỦ CÔNG"
ManualScan.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ManualScan.TextColor3 = Color3.fromRGB(255, 255, 255)
ManualScan.Font = Enum.Font.GothamBold

ManualScan.MouseButton1Click:Connect(function()
    local found = false
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then found = true break end
    end
    Status.Text = found and "Có Pet VIP trong map!" or "Map này không có gì cả."
end)

-- Tự động chạy khi load vào (nếu để trong autoexec)
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(2)
    -- Bạn có thể bỏ chú thích dòng dưới để nó tự săn ngay khi vào game
    -- ScanAndHop() 
end)
print(hopsever cực xịn)
