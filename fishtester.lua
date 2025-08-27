--=== LogicDev: Auto Fishing (GUI) — WindUI Toggle Only ======================
-- dependensi: WindUI releases terbaru, modul logic (#2) bisa di-load via loadstring
-- aman di-reload: toggle akan nyalakan/matikan loop tanpa duplikasi

--[[
Struktur:
Window ".devlogic"
  Section "Main"
    Tab "Fishing"
      Toggle "Auto Fishing"
]]

-- WindUI Loader (gunakan loader resmi WindUI)
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- Window
local Window = WindUI:CreateWindow({
    Title         = ".devlogic",
    Icon          = "fish",
    Author        = "hailazra",
    Folder        = ".devlogichub",
    Size          = UDim2.fromOffset(250, 250),
    Theme         = "Dark",
    Resizable     = false,
    SideBarWidth  = 120,
    HideSearchBar = true,
})

-- Section & Tab
local SecMain       = Window:Section({ Title = "Main", Icon = "gamepad", Opened = true })
local TabFishing    = SecMain:Tab({ Title = "Fishing", Icon = "fish" })

-- Global CFG (opsional buat tuning dari luar)
getgenv().AutoFishCFG = getgenv().AutoFishCFG or {
    Run = false,
    CastDelayMin = 1.6,   -- jeda minimal antar cast (detik) — diakalin sedikit biar “human”
    CastDelayMax = 2.8,   -- jeda maksimal antar cast (detik)
    PowerMin     = 0.88,  -- kisaran power (kedua argumen minigame seringnya “power/akurasi”)
    PowerMax     = 0.98,
    AimMin       = -0.25, -- kisaran aim/offset (pertama argumen minigame, seringnya -1..1)
    AimMax       =  0.25,
    AutoEquipRod = true,  -- otomatis equip rod
    DebugPrint   = false,
}

-- Lazy-load modul logic (bagian #2) — ganti RAW_URL di bawah kalau sudah upload ke repo kamu
local function LoadFishingModule()
    if rawget(getgenv(), "LogicDev_AutoFishing") and type(getgenv().LogicDev_AutoFishing) == "table" then
        return getgenv().LogicDev_AutoFishing
    end
    -- sementara: langsung define inline (fallback) kalau kamu belum upload modulnya
    -- (modul lengkap ada di Bagian #2, aman dipisah file)
    loadstring([[
        https://raw.githubusercontent.com/hailazra/Development/refs/heads/main/fishitfeature.lua
        getgenv().LogicDev_AutoFishing = getgenv().LogicDev_AutoFishing or {
            _running = false,
            SetRun = function(self, v) self._running = v end,
            Kill = function(self) self._running = false end,
            Start = function(self) warn("[AutoFishing] Fallback module aktif. Upload modul logic (#2) ya.") end,
        }
    ]])()
    return getgenv().LogicDev_AutoFishing
end

local Mod = LoadFishingModule()

-- Toggle
local Tgl_AutoFish = TabFishing:Toggle({
    Title = "Auto Fishing",
    Icon  = "fish",
    Default = getgenv().AutoFishCFG.Run,
    Callback = function(state)
        getgenv().AutoFishCFG.Run = state
        if state then
            Mod:SetRun(true)
            Mod:Start()
        else
            Mod:SetRun(false)
        end
    end
})

-- Sinkronkan kalau diubah dari luar
task.spawn(function()
    while task.wait(1) do
        if Tgl_AutoFish and Tgl_AutoFish.Set then
            Tgl_AutoFish:Set(getgenv().AutoFishCFG.Run)
        end
    end
end)

-- Tombol Kill (optional, tak terlihat user—nyaman utk dev)
Window:Keybind({
    Title = "Kill Auto Fishing",
    Key = Enum.KeyCode.End,
    Callback = function()
        getgenv().AutoFishCFG.Run = false
        if Mod and Mod.Kill then Mod:Kill() end
        if getgenv().AutoFishCFG.DebugPrint then print("[AutoFishing] Killed") end
    end
})
