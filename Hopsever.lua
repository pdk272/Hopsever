--[[ 
    SIMPLE REMOTE LOGGER (MÁY NGHE LÉN LỆNH)
    - Theo dõi mọi tín hiệu gửi lên Server.
    - Tìm lệnh liên quan đến việc đặt Pet (Place, Spawn, Drop...).
]]

local Log = function(remote, args)
    print("📡 PHÁT HIỆN LỆNH: " .. remote:GetFullName())
    if #args > 0 then
        for i, v in pairs(args) do
            print("   └─ Tham số [" .. i .. "]:", v)
        end
    end
end

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" or method == "InvokeServer" then
        -- Chỉ in những lệnh liên quan đến đồ đạc để đỡ rối mắt
        local name = self.Name:lower()
        if name:find("place") or name:find("item") or name:find("pet") or name:find("base") then
            Log(self, args)
        end
    end
    return old(self, ...)
end)

setreadonly(mt, true)
print("✅ Đang nghe lén... Giờ hãy cầm Pet và giữ E đặt vào Base đi!")
