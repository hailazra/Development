--=== LogicDev: Auto Fishing (Module) =======================================
-- Cara pakai:
--   getgenv().AutoFishCFG = getgenv().AutoFishCFG or { ... }  -- (opsional, jika belum dibuat GUI)
--   loadstring(game:HttpGet("RAW_URL/AutoFishing_Module.lua"))()
--   LogicDev_AutoFishing:SetRun(true)
--   LogicDev_AutoFishing:Start()

-- Konfigurasi default (dipakai kalau GUI belum set)
getgenv().AutoFishCFG = getgenv().AutoFishCFG or {
    Run = false,
    CastDelayMin = 1.6,
    CastDelayMax = 2.8,
    PowerMin     = 0.88,
    PowerMax     = 0.98,
    AimMin       = -0.25,
    AimMax       =  0.25,
    AutoEquipRod = true,
    DebugPrint   = false,
}

local CFG = getgenv().AutoFishCFG

-- Services
local RS            = game:GetService("ReplicatedStorage")
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local LocalPlayer   = Players.LocalPlayer

-- Remote paths (sesuai yang kamu temukan)
local NetRoot       = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local RF_Charge     = NetRoot:WaitForChild("RF/ChargeFishingRod")
local RF_StartMG    = NetRoot:WaitForChild("RF/RequestFishingMinigameStarted")
local RE_Completed  = NetRoot:WaitForChild("RE/FishingCompleted")

-- Utils kecil
local function dprint(...)
    if CFG.DebugPrint then
        print("[AutoFishing]", ...)
    end
end

local function randf(a, b)
    return a + (b - a) * math.random()
end

local function Humanoid()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function EquipRodIfNeeded()
    if not CFG.AutoEquipRod then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    local humanoid = Humanoid()
    if not humanoid then return false end

    -- sudah pegang tool?
    if char:FindFirstChildOfClass("Tool") then
        return true
    end

    -- cari rod di backpack (heuristik: nama mengandung "Rod")
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not backpack then return false end
    local target = nil
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("rod") or tool.Name:lower():find("fishing")) then
            target = tool
            break
        end
    end
    if target then
        humanoid:EquipTool(target)
        dprint("Equip rod:", target.Name)
        return true
    end
    return false
end

local function SafeInvoke(rf, ...)
    local ok, res = pcall(function()
        return rf:InvokeServer(...)
    end)
    if not ok then
        dprint("Invoke error:", res)
    else
        dprint("Invoke ok")
    end
    return ok, res
end

local function SafeFire(re, ...)
    local ok, err = pcall(function()
        re:FireServer(...)
    end)
    if not ok then
        dprint("Fire error:", err)
    else
        dprint("Fire ok")
    end
    return ok
end

-- Inti satu siklus mancing:
local function OneCast()
    -- 1) pastikan rod ke-equip
    if not EquipRodIfNeeded() then
        dprint("Rod not found / not equipped")
        return
    end

    -- 2) Charge (pakai timestamp-ish float; os.clock() terasa natural)
    local ts = os.clock() + math.random()
    SafeInvoke(RF_Charge, ts)

    -- 3) Start minigame (aim, power) — humanized random dalam kisaran aman
    local aim   = randf(CFG.AimMin,   CFG.AimMax)     -- seringnya -1..1
    local power = randf(CFG.PowerMin, CFG.PowerMax)   -- seringnya 0..1
    SafeInvoke(RF_StartMG, aim, power)

    -- 4) “Tap-tap” minigame:
    --    Kamu hanya share RE/FishingCompleted; diasumsikan server terima completion setelah jeda singkat.
    --    Jika ternyata perlu step lain (mis. klik progress), tambahkan di sini berdasarkan spy berikutnya.
    task.wait(randf(0.6, 1.2)) -- kecilkan/naikkan sesuai “durasi minigame” agar tak terlalu bot-ish

    -- 5) Complete
    SafeFire(RE_Completed)
end

-- Loop runner
local AutoFishing = getgenv().LogicDev_AutoFishing or {}
AutoFishing._running = AutoFishing._running or false
AutoFishing._looping = AutoFishing._looping or false

function AutoFishing:SetRun(v)
    self._running = v and true or false
end

function AutoFishing:Kill()
    self._running = false
end

function AutoFishing:Start()
    if self._looping then return end
    self._looping = true
    dprint("Start loop")

    task.spawn(function()
        while self._looping do
            if not self._running then
                RunService.Heartbeat:Wait()
            else
                -- guard: humanoid mati/respawn bisa bikin error; tunggu sehat
                local hum = Humanoid()
                if hum and hum.Health > 0 then
                    OneCast()
                    task.wait(randf(CFG.CastDelayMin, CFG.CastDelayMax))
                else
                    task.wait(1)
                end
            end
        end
        dprint("Loop ended")
    end)
end

-- expose
getgenv().LogicDev_AutoFishing = AutoFishing
return AutoFishing
