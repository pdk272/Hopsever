--[[ 
    BRAINROT V19 - TRẢM ĐỊNH (XENO PC AUTOEXEC)
    - Tự chạy 100%, không cần bấm nút.
    - Khóa chết hàm Server Hop khi thấy Pet (An toàn tuyệt đối).
    - Phá giới hạn Speed khi cầm Pet.
    - Fast Steal: Bấm E là lấy ngay lập tức.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local TargetPets = {
    ["La Secret Combinasion"] = true, ["Lavadorito Spinito"] = true, ["Garama and Madundung"] = true,
    ["Ketchuru and Musturu"] = true, ["Ketupat Kepat"] = true, ["Tang Tang Keletang"] = true,
    ["Tictac Sahur"] = true, ["Money Money Puggy"] = true, ["Cerberus"] = true,
    ["Money Money Reindeer"] = true, ["Pretzo Robo"] = true, ["Popcuru and Fizzuru"] = true,
    ["Burguro and Fryuro"] = true, ["La Casa Boo"] = true
}

-- BIẾN KHÓA AN TOÀN (Cực kỳ quan trọng)
_G.PetFound = false

-- KHỞI TẠO GUI (Vào PlayerGui)
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("Brainrot_V19") then PlayerGui.Brainrot_V19:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "Brainrot_V19"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 120)
Main.Position = UDim2.new(0.5, -130, 0, 20) -- Đưa lên mép trên cho gọn
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.Active = true
Main.Draggable = true

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 1, 0)
Status.Text = "Đang tải bản đồ..."
Status.TextColor3 = Color3.fromRGB(0, 255, 255)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.GothamBold
Status.TextSize = 15
Status.TextWrapped = true

-- --- 1. TỐC ĐỘ BẤT CHẤP (Không bị chậm khi cầm Pet) ---
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        -- Chỉ đẩy tới khi bạn bấm phím di chuyển
        if hum.MoveDirection.Magnitude > 0 then
            -- Hệ số 0.25 bù vào tốc độ gốc, tương đương Speed ~35. Không quan tâm game ép đi chậm cỡ nào.
            root.CFrame = root.CFrame + (hum.MoveDirection * 0.25)
        end
    end)
end)

-- --- 2. FAST STEAL (Ép phím E từ bàn phím) ---
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.KeyCode == Enum.KeyCode.E then
        pcall(function()
            local root = LocalPlayer.Character.HumanoidRootPart
            for _, prompt in pairs(ProximityPromptService:GetProximityPrompts()) do
                -- Nếu đứng cách vật phẩm dưới 25 studs, ép nhặt ngay
                if prompt.Parent and (prompt.Parent.Position - root.Position).Magnitude < 25 then
                    if fireproximityprompt then
                        fireproximityprompt(prompt, 1, true)
                    end
                    -- Giả lập kịch bản dự phòng nếu fireproximityprompt bị trễ
                    prompt:InputBegan()
                    task.wait(0.05)
                    prompt:InputEnded()
                end
            end
        end)
    end
end)

-- --- 3. AUTO HOP & FINDER (Khóa chết khi có Pet) ---
local function ServerHop()
    -- CHỐT AN TOÀN: Nếu đã thấy Pet, DỪNG NGAY LẬP TỨC toàn bộ lệnh nhảy
    if _G.PetFound then return end 

    Status.Text = "Phòng trống.\nĐang nhảy Server..."
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local PlaceId = game.PlaceId
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    
    if success and result and result.data then
        for _, s in pairs(result.data) do
            -- Vào server trống ít nhất 3 chỗ
            if s.playing < (s.maxPlayers - 3) and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, s.id)
                task.wait(5)
                ServerHop() -- Gọi lại nếu bị kẹt
                return
            end
        end
    end
    task.wait(2)
    ServerHop()
end

local function AutoScan()
    local foundPet = nil
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if TargetPets[v.Name] then
            foundPet = v
            break 
        end
    end
    
    if foundPet then
        -- KÍCH HOẠT CHỐT AN TOÀN
        _G.PetFound = true 
        
        Main.BorderColor3 = Color3.fromRGB(0, 255, 0)
        Status.Text = "🔥🔥 THẤY PET VIP 🔥🔥\n" .. foundPet.Name .. "\nĐÃ KHÓA SERVER HOP!"
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        local hl = Instance.new("Highlight", foundPet)
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        
        -- Hú chuông 5 lần
        for i = 1, 5 do
            local s = Instance.new("Sound", game.Workspace)
            s.SoundId = "rbxassetid://138090596"
            s.Volume = 3
            s:Play()
            task.wait(0.5)
        end
    else
        -- Không thấy mới cho nhảy
        task.wait(1.5)
        ServerHop()
    end
end

-- Tự động chạy ngay sau khi load map (Dành cho Autoexec)
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    Status.Text = "Chuẩn bị quét sau 3 giây..."
    task.wait(3) -- Chờ 3 giây để mọi vật phẩm rơi xuống map đầy đủ
    AutoScan()
end)

print("V19 - Đã sẵn sàng chiến đấu!")
