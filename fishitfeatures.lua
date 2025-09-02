-- dlogicfish.lua
-- Auto Fishing Module (template) — .devlogic
-- Rancang untuk dipanggil via: local Fish = loadstring(game:HttpGet(URL))()

local Fish = {}
Fish.__index = Fish

-- ======= Services & Shortcuts =======
local Players      = game:GetService("Players")
local Replicated   = game:GetService("ReplicatedStorage")
local RunService   = game:GetService("RunService")

local LP           = Players.LocalPlayer

-- ======= Private State =======
local _running     = false
local _mainThread  = nil
local _connections = {}
local _mode        = "Category A"     -- default
local _cfgRef      = nil              -- referensi ke cfg yang kamu kirim dari GUI (getgenv().LogicCFG.Fishing)

-- ======= Remote Placeholders (SESUIKAN DENGAN GAME KAMU) =======
-- Ganti nama path ini dengan yang benar sesuai hasil rspy kamu:
local RF = {
    Charge = Replicated:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
                  :WaitForChild("net"):WaitForChild("RF/ChargeFishingRod"),
    MiniGame = Replicated:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
                  :WaitForChild("net"):WaitForChild("RF/RequestFishingMinigame"), -- contoh nama
}
local RE = {
   Rod = Replicated:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
                  :WaitForChild("net"):WaitForChild("RE/EquipToolFromHotbar"), 
   FishingCompleted  = Replicated:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
                  :WaitForChild("net"):WaitForChild("RE/FishingCompleted"), -- tambahkan kalau perlu event, mis. "FishingResult"
}

-- ======= Utilities =======
local function safe(f, ...)
    local ok, res = pcall(f, ...)
    if not ok then warn("[Fish] Error:", res) end
    return ok, res
end

local function connect(sig, cb)
    local c = sig:Connect(cb)
    table.insert(_connections, c)
    return c
end

local function disconnectAll()
    for i = #_connections, 1, -1 do
        local c = _connections[i]
        _connections[i] = nil
        safe(function() c:Disconnect() end)
    end
end

local function closeThread()
    if _mainThread and coroutine.status(_mainThread) ~= "dead" then
        -- NB: coroutine.close hanya ada di eksekutor tertentu; fallback ke flag _running
        -- safe(function() coroutine.close(_mainThread) end)
    end
    _mainThread = nil
end

local function heartbeat(dt)
    RunService.Heartbeat:Wait()
end

-- ======= Game Helpers (SESUIKAN DENGAN GAME KAMU) =======
local function EquipRod()
    if RE.Rod then
        local ok = safe(function()
            -- NOTE: argumen (1) = slot hotbar. Ubah kalau game kamu pakai format lain.
            RE.Rod:FireServer(1)
        end)
        return ok
    else
        warn(TAG, "RE/EquipToolFromHotbar tidak ditemukan. Cek path/net.")
    end
    return false
end

local function DoCharge()
    if RF.Charge then
        local ok = safe(function()
            -- Banyak game minta timestamp/float; sesuaikan kalau perlu.
            RF.Charge:InvokeServer(tick())
        end)
        return ok
    else
        warn(TAG, "RF/ChargeFishingRod tidak ditemukan. Cek path/net.")
    end
    return false
end

local function DoMinigame()
    if RF.MiniGame then
        local ok = safe(function()
            RF.MiniGame:InvokeServer() -- SESUAIKAN argumen jika perlu
        end)
        return ok
    else
        warn(TAG, "RF/RequestFishingMin(igame) tidak ditemukan. Cek path/net.")
    end
    return false
end


local function StrategyStep(mode)
    -- Mapping strategi per mode (kamu bisa pecah per fungsi)
    if mode == "Category A" then
        -- cepat/aman
        DoCharge()
        DoMinigame()
    elseif mode == "Category B" then
        -- timing berbeda
        DoCharge()
        heartbeat()
        DoMinigame()
    else -- "Category C" atau lain
        DoCharge()
        heartbeat()
        heartbeat()
        DoMinigame()
    end
end

-- ======= Public API =======
function Fish.Start(cfg)
    if _running then
        warn("[Fish] Already running")
        return
    end
    _running = true
    _cfgRef  = cfg or { Mode = _mode, Auto = true, AutoEventTeleport = false }
    _mode    = _cfgRef.Mode or _mode

    -- Optional: reaksi otomatis terhadap perubahan CFG via listener global
    if getgenv and getgenv().LogicCFG_AddListener and not Fish._isBound then
        Fish._isBound = true
        getgenv().LogicCFG_AddListener(function(topic, fullcfg)
            if not _running then return end
            local fcfg = fullcfg and fullcfg.Fishing
            if not fcfg then return end

            if topic == "Fishing.Mode" then
                _mode = tostring(fcfg.Mode or _mode)
            elseif topic == "Fishing.Auto" then
                if fcfg.Auto == false then
                    Fish.Kill()
                end
            elseif topic == "Fishing.AutoEventTeleport" then
                -- kamu bisa trigger teleport event di sini
            end
        end)
    end

    -- Main Loop
    _mainThread = coroutine.create(function()
        -- Persiapan
        EquipRod()

        while _running do
            -- Cek guard dari cfg (kalau toggle dimatikan saat jalan)
            if _cfgRef and _cfgRef.Auto == false then
                break
            end

            -- 1) Optionally cek event & teleport (kalau AutoEventTeleport)
            -- 2) Jalankan 1 siklus strategi
            StrategyStep(_mode)

            -- 3) Jedanya jangan terlalu pendek biar gak spam
            for i = 1, 10 do
                if not _running then break end
                heartbeat()
            end
        end
    end)

    local ok, err = coroutine.resume(_mainThread)
    if not ok then
        warn("[Fish] Failed to start:", err)
        Fish.Kill()
    end
end

function Fish.Kill()
    if not _running then return end
    _running = false
    disconnectAll()
    closeThread()
    -- Matikan/bersihkan state lain jika ada
    -- Contoh: lepas tool, hentikan tween, dsb.
end

function Fish.IsRunning()
    return _running
end

function Fish.SetMode(mode)
    _mode = tostring(mode or _mode)
end

return Fish
