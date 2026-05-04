--[[ 
    VOID V8 - THE ARCHITECT (ENGINE OPTIMIZED)
    - True CollectionService Integration
    - Context-Aware Physics Handling
    - Professional Code Architecture
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local RunService, CollectionService, Players = Services.RunService, Services.CollectionService, Services.Players
local LPlr = Players.LocalPlayer

-- 1. ARCHITECTURE SETTINGS
local Settings = {
    SpeedValue = 35,
    Active = false,
    SafeRadius = 25,
    TargetTags = {"Pet", "DroppedItem", "Brainrot"} -- Các Tag tiềm năng của game
}

-- 2. TRUE COLLECTION SERVICE ESP (Tối ưu tài nguyên tuyệt đối)
local function ApplyHighlight(inst)
    if not inst:IsA("Model") or inst:FindFirstChild("ArchitectESP") then return end
    local hl = Instance.new("Highlight", inst)
    hl.Name = "ArchitectESP"
    hl.FillColor = Color3.fromRGB(0, 255, 255)
    hl.OutlineColor = Color3.new(1, 1, 1)
end

-- Chỉ quét những thứ đã được Tag (Đúng chuẩn CollectionService)
for _, tag in pairs(Settings.TargetTags) do
    CollectionService:GetInstanceAddedSignal(tag):Connect(ApplyHighlight)
    for _, inst in pairs(CollectionService:GetTagged(tag)) do
        ApplyHighlight(inst)
    end
end

-- 3. ADVANCED MOVEMENT SYNC (Dùng cho mượt, không phải để "lừa" server)
local function GetCharacterData()
    local char = LPlr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return char, hrp, hum
end

RunService.PreSimulation:Connect(function(dt)
    local char, hrp, hum = GetCharacterData()
    if not (Settings.Active and hrp and hum) then return end

    if hum.MoveDirection.Magnitude > 0 then
        -- RaycastParams tối ưu: Tránh quét rác
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}
        
        -- Kiểm tra va chạm phía trước (Bản pro dùng khoảng cách cực ngắn)
        local cast = workspace:Raycast(hrp.Position, hum.MoveDirection * 1.5, params)
        
        if not cast then
            -- Tối ưu vị trí bằng Delta Time để triệt tiêu Jittering
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Settings.SpeedValue * dt))
        end
    end
end)

-- 4. SERVER HOP FIX (Đã khai báo HttpService chuẩn)
local function SafeHop()
    local HttpService = Services.HttpService
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
    end)
    
    if success and servers then
        for _, s in pairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end
end

print("🏗️ VOID V8 ARCHITECT LOADED. Technical debt cleared.")
