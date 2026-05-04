--[[ 
    BRAINROT REMOTE SNIPER
    - Nhắm thẳng vào các dịch vụ ông vừa chụp ảnh.
    - Bắt lấy lệnh chuẩn xác khi ông đặt đồ vào Base.
]]

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" or method == "InvokeServer" then
        local name = self.Name:lower()
        -- Lọc đúng những từ khóa trong log của ông
        if name:find("place") or name:find("brainrot") or name:find("replace") then
            print("🎯 ĐÃ TÚM ĐƯỢC REMOTE: " .. self:GetFullName())
            print("📦 Dữ liệu gửi đi:")
            for i, v in pairs(args) do
                print("   [" .. i .. "]:", v)
            end
            print("-------------------------")
        end
    end
    return old(self, ...)
end)

setreadonly(mt, true)
print("🚀 Hệ thống nghe lén đã bật! Giờ hãy giữ E đặt đồ vào Base đi ông.")
