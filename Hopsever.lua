--[[ 
    MANUAL REMOTE FINDER (QUÉT THỦ CÔNG)
    - Tìm tất cả các lệnh liên quan đến việc đặt đồ.
]]

local function ScanRemotes()
    print("🔍 ĐANG QUÉT TÌM LỆNH ĐẶT ĐỒ...")
    local found = 0
    
    -- Quét trong ReplicatedStorage (Nơi chứa 99% các lệnh)
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()
            -- Lọc những cái tên khả nghi
            if name:find("place") or name:find("spawn") or name:find("drop") or name:find("item") or name:find("pet") then
                print("🎯 TÌM THẤY: " .. v:GetFullName())
                found = found + 1
            end
        end
    end
    
    if found == 0 then
        print("❌ Không tìm thấy lệnh nào khả nghi. Có thể tụi nó giấu tên rất kỹ.")
    else
        print("✅ Quét xong! Có " .. found .. " lệnh tiềm năng. Ông check trong F9 xem có cái nào tên giống 'Đặt đồ' không.")
    end
end

ScanRemotes()
