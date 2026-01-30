-- Тестовый скрипт для проверки loader.lua

print("=== BLOOD.C TEST SCRIPT ===")
print("Testing loader...")

-- Проверяем PlaceId
print("Current PlaceId:", game.PlaceId)
print("Game Name:", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)

-- Пробуем загрузить
print("\nAttempting to load blood.c...")
print("Command: loadstring(game:HttpGet('https://raw.githubusercontent.com/zxc38324-eng/blood.c/main/blood_modular/loader.lua'))()")

local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/zxc38324-eng/blood.c/main/blood_modular/loader.lua"))()
end)

if success then
    print("\n✅ SUCCESS! Script loaded!")
else
    warn("\n❌ ERROR:", err)
end

print("\n=== TEST COMPLETE ===")
