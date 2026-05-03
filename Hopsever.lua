--[[ 
    CONSOLE REMOTE SPY (NO GUI - CHỐNG LỖI COREGUI)
    - In trực tiếp mọi mật mã game gửi lên Server vào bảng F9.
]]

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    -- Bắt quả tang mọi hành động gửi dữ liệu lên Server
    if method == "FireServer" or method == "InvokeServer" then
        print("========================================")
        print("🚀 [PHÁT HIỆN LỆNH]: " .. tostring(self.Name))
        print("📁 [ĐƯỜNG DẪN]: " .. tostring(self:GetFullName()))
        
        -- In ra các thông số đi kèm (Tên Pet, ID...)
        local args = {...}
        for i, v in pairs(args) do
            print("   -> Thông số " .. i .. ": " .. tostring(v))
        end
        print("========================================")
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

print("✅ Console Spy đã kích hoạt! Hãy bấm F9 để xem mật mã game.")
