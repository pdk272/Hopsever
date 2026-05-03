--[[ 
    BRAINROT V21 - STEALTH HUNTER
    - Anti-Death Speed: Tốc độ lag (Bypass Server Check).
    - Auto-Pickup: Nhặt đồ tự động (Cơ chế dự phòng).
    - Infinite Server Hop: Nhảy liên tục, không treo máy.
    - No-Teleport Policy: An toàn tuyệt đối khi cầm Pet.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local TargetPets = {
    ["La Secret Combinasion"] = true, ["Lavadorito Spinito"] = true, ["Garama and Madundung"] = true,
    ["Ketchuru and Musturu"] = true, ["Ketupat Kepat"] = true, ["Tang Tang Keletang"] = true,
    ["Tictac Sahur"] = true, ["Money Money Puggy"] = true, ["Cerberus"] = true,
    ["Money Money Reindeer"] = true, ["Pretzo Robo"] = true, ["Popcuru and Fizzuru"] = true,
    ["Burguro and Fryuro"] = true, ["La Casa Boo"] = true
}

_G.FoundPet = false

-- --- 1. GIAO DIỆN PLAYER GUI ---
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("Stealth_V21") then PlayerGui.Stealth_V21:Destroy() end
local ScreenGui = Instance.new("ScreenGui", PlayerGui); ScreenGui.Name = "Stealth_V21"; ScreenGui.ResetOnSpawn = false
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 250, 0, 80); Main.Position = UDim2.new(0.5, -125, 0, 20); Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Draggable = true; Main.Active = true
local Status = Instance.new("TextLabel", Main); Status.Size = UDim2.new(1, 0, 1, 0); Status.TextColor3 = Color3.fromRGB(255, 255, 255); Status.BackgroundTransparency = 1; Status.Font = Enum.Font.Code; Status.TextSize = 13; Status.TextWrapped = true

-- --- 2. ANTI-DEATH SPEED (30 FPS BYPASS) ---
local speedCounter = 0
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        
        if hum.MoveDirection.Magnitude > 0 then
            speedCounter = speedCounter + 1
            -- Chỉ đẩy nhân vật mỗi 2 khung hình để đánh lừa Anti-cheat
            if speedCounter % 2 == 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * 0.22)
            end
        end
        -- Luôn giữ pet nhẹ như bông
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.Massless = true end
        end
    end)
end)

-- --- 3. AUTO-PICKUP (FAST STEAL) ---
task.spawn(function()
    while task.wait(0.2) do
        if not _G.FoundPet then
            pcall(function()
                local root = LocalPlayer.Character.HumanoidRootPart
                for _, prompt in pairs(ProximityPromptService:GetProximityPrompts()) do
                    local part = prompt.Parent
                    if part and (part.Position - root.Position).Magnitude < 22 then
                        prompt.HoldDuration = 0
                        if fireproximityprompt then fireproximityprompt(prompt) end
                        prompt:InputBegan()
                        task.wait()
                        prompt:InputEnded()
                    end
                end
            end)
        end
    end
end)

-- --- 4. INFINITE SERVER HOP (CHỐNG TREO) ---
local function ServerHop()
    if _G.FoundPet then return end
    Status.Text = "📡 Đang dò tìm server trống (Vòng lặp vĩnh viễn)..."
    
    local PlaceId = game.PlaceId
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    
    if success and result and result.data then
        -- Lấy ngẫu nhiên một server trong danh sách để không bị trùng
        local randomServer = result.data[math.random(1, #result.data)]
        
        if randomServer and randomServer.playing < (randomServer.maxPlayers - 2) and randomServer.id ~= game.JobId then
            Status.Text = "🚀 Đang nhảy tới: " .. randomServer.id
            pcall(function()
                TeleportService:TeleportToPlaceInstance(PlaceId, randomServer.id)
            end)
        end
    end
    
    -- Nếu sau 8 giây vẫn chưa nhảy được, tự động gọi lại chính mình
    task.wait(8)
    ServerHop()
end

-- --- 5. QUÉT PET VIP ---
local function StartScan()
    local target = nil
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then target = v; break end
    end
    
    if target then
        _G.FoundPet = true
        Status.Text = "💎 ĐÃ THẤY: " .. target.Name .. "\nĐÃ DỪNG NHẢY SERVER!"
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        local hl = Instance.new("Highlight", target); hl.FillColor = Color3.fromRGB(255, 0, 0)
        local s = Instance.new("Sound", game.Workspace); s.SoundId = "rbxassetid://138090596"; s:Play()
    else
        task.wait(2.5) -- Đợi map load xong mới nhảy
        ServerHop()
    end
end

task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(3)
    StartScan()
end)

print(bản vip nè)
