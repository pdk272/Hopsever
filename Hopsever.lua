--[[ 
    BRAINROT V20 - GHOST HUNTER (XENO PC)
    - Auto-Pickup: Đứng gần là tự nhặt (Không cần bấm phím).
    - Turbo Server Hop: Nhảy liên tục, bỏ qua server full, chống treo.
    - Massless Speed 30: Tự động xóa trọng lượng Pet để đi nhanh hơn.
    - Anti-Hop Safety: Khóa nhảy server ngay khi phát hiện Pet VIP.
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

_G.StopHop = false -- Chốt an toàn để dừng nhảy server

-- --- 1. GIAO DIỆN CHUẨN ---
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("Ghost_V20") then PlayerGui.Ghost_V20:Destroy() end
local ScreenGui = Instance.new("ScreenGui", PlayerGui); ScreenGui.Name = "Ghost_V20"; ScreenGui.ResetOnSpawn = false
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 260, 0, 100); Main.Position = UDim2.new(0.5, -130, 0, 10); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Draggable = true; Main.Active = true
local Status = Instance.new("TextLabel", Main); Status.Size = UDim2.new(1, 0, 1, 0); Status.TextColor3 = Color3.fromRGB(255, 255, 255); Status.BackgroundTransparency = 1; Status.Font = Enum.Font.GothamBold; Status.TextSize = 14; Status.TextWrapped = true

-- --- 2. AUTO-PICKUP (FAST STEAL THẬT SỰ) ---
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local root = LocalPlayer.Character.HumanoidRootPart
            for _, prompt in pairs(ProximityPromptService:GetProximityPrompts()) do
                local part = prompt.Parent
                if part and part:IsA("BasePart") then
                    local dist = (part.Position - root.Position).Magnitude
                    if dist < 20 then -- Khoảng cách nhặt đồ
                        -- Tự động kích hoạt không cần bấm phím
                        fireproximityprompt(prompt, 1, true)
                        prompt:InputBegan()
                        task.wait()
                        prompt:InputEnded()
                    end
                end
            end
        end)
    end
end)

-- --- 3. MASSLESS SPEED 30 (CHỐNG CHẬM KHI CẦM PET) ---
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        
        -- Xóa trọng lượng tất cả vật phẩm đang cầm
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.Massless = true end
        end
        
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (30 - 16) * 0.015)
        end
    end)
end)

-- --- 4. TURBO SERVER HOP (CHỐNG TREO) ---
local function ServerHop()
    if _G.StopHop then return end
    Status.Text = "🔍 Đang tìm server trống mới..."
    
    local PlaceId = game.PlaceId
    -- Lấy 100 server mới nhất, sắp xếp ngẫu nhiên để tránh trùng
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    
    if success and result and result.data then
        for _, s in pairs(result.data) do
            -- Chỉ vào server còn ít nhất 3 chỗ trống
            if s.playing < (s.maxPlayers - 3) and s.id ~= game.JobId then
                Status.Text = "🚀 Đang nhảy tới Server: " .. s.id
                local tpSuccess, tpError = pcall(function()
                    TeleportService:TeleportToPlaceInstance(PlaceId, s.id)
                end)
                task.wait(4) -- Đợi 4 giây, nếu không nhảy được thì tiếp tục tìm server khác
            end
        end
    end
    task.wait(1)
    ServerHop() -- Vòng lặp liên tục nếu bị lỗi
end

-- --- 5. SMART FINDER ---
local function StartHunting()
    local found = nil
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then found = v; break end
    end
    
    if found then
        _G.StopHop = true -- DỪNG NHẢY NGAY LẬP TỨC
        Status.Text = "🔥🔥 THẤY PET VIP: " .. found.Name .. " 🔥🔥"
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        local hl = Instance.new("Highlight", found); hl.FillColor = Color3.fromRGB(255, 0, 0)
        for i = 1, 3 do local s = Instance.new("Sound", game.Workspace); s.SoundId = "rbxassetid://138090596"; s:Play(); task.wait(0.5) end
    else
        task.wait(2) -- Đợi load map
        ServerHop()
    end
end

-- Tự động chạy
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(3)
    StartHunting()
end)
