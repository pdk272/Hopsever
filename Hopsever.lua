--[[ 
    PET ID SCANNER (BẢN QUÉT BALO)
    - Quét giao diện túi đồ để tìm mã ID ẩn của Pet.
]]

local player = game.Players.LocalPlayer
local inventoryFrame = player.PlayerGui:FindFirstChild("Inventory", true) -- Tên có thể là 'Inventory' hoặc 'Backpack'

if inventoryFrame then
    print("🔍 ĐANG QUÉT BALO CỦA ÔNG...")
    for _, v in pairs(inventoryFrame:GetDescendants()) do
        -- Tìm các ô chứa Pet, thường có chứa thuộc tính ID hoặc tên mã
        if v:IsA("StringValue") and (v.Name:lower():find("id") or v.Name:lower():find("uuid")) then
            print("🎯 TÌM THẤY ID PET: " .. v.Value .. " (Tên ô: " .. v.Parent.Name .. ")")
        end
    end
else
    print("❌ Không tìm thấy giao diện Balo. Ông hãy mở Balo lên rồi chạy lại script này!")
end
