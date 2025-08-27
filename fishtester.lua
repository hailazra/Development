--========================================================
-- .devlogic — Auto Fishing (Single File: GUI + Logic)
--========================================================
-- Fitur:
--  - WindUI GUI: 1 Tab "Fishing" berisi Toggle "Auto Fishing"
--  - Auto-equip rod (heuristik nama mengandung "rod"/"fishing")
--  - Humanized timing & parameter (aim/power) biar gak terlalu bot-ish
--  - Kill/Unload via Key: END
-- Catatan:
--  - Sesuaikan range AIM/POWER & delay jika perlu.
--  - Jika game menambah step minigame, tambahkan RPC di bagian TAP-TAP.

--====================== Konfigurasi ======================
getgenv().AutoFishCFG = getgenv().AutoFishCFG or {
    Run = false,
    CastDelayMin = 1.6,   -- jeda minimal antar cast (detik)
    CastDelayMax = 2.8,   -- jeda maksimal antar cast
    PowerMin     = 0.88,  -- 0..1
    PowerMax     = 0.98,  -- 0..1
    AimMin       = -0.25, -- -1..1 (kiri/kanan)
    AimMax       =  0.25, -- -1..1 (kiri/kanan)
    AutoEquipRod = true,
    DebugPrint   = false,
}
local CFG = getgenv().AutoFishCFG

--====================== Services & Remotes ==============
local RS            = game:GetService("ReplicatedStorage")
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local LocalPlayer   = Players.LocalPlayer

-- Path dari rspy kamu
local NetRoot       = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local RF_Charge     = NetRoot:WaitForChild("RF/ChargeFishingRod")
local RF_StartMG    = NetRoot:WaitForChild("RF/RequestFishingMinigameStarted")
local RE_Completed  = NetRoot:WaitForChild("RE/FishingCompleted")

--====================== Utils ===========================
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
    local hum = Humanoid()
    if not char or not hum then return false end

    -- Sudah pegang tool?
    if char:FindFirstChildOfClass("Tool") then
        return true
    end

    -- Cari rod di Backpack
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not backpack then return false end
    local target = nil
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("rod") or n:find("fish") then
                target = tool
                break
            end
        end
    end
    if target then
        hum:EquipTool(target)
        dprint("Equip rod:", target.Name)
        return true
    end
    return false
end

local function SafeInvoke(rf, ...)
    local ok, res = pcall(function()
        return rf:InvokeServer(...)
    end)
    if not ok then dprint("Invoke error:", res) end
    return ok, res
end

local function SafeFire(re, ...)
    local ok, err = pcall(function()
        re:FireServer(...)
    end)
    if not ok then dprint("Fire error:", err) end
    return ok
end

-- Satu siklus mancing
local function OneCast()
    -- 1) Pastikan rod siap
    if not EquipRodIfNeeded() then
        dprint("Rod not found / not equipped")
        return
    end

    -- 2) Charge rod — pakai timestamp-ish float (mirip behavior asli)
    local ts = os.clock() + math.random()
    SafeInvoke(RF_Charge, ts)

    -- 3) Start minigame — (aim, power)
    local aim   = randf(CFG.AimMin,   CFG.AimMax)
    local power = randf(CFG.PowerMin, CFG.PowerMax)
    SafeInvoke(RF_StartMG, aim, power)

    -- 4) “Tap-tap” minigame: kalau suatu saat butuh RPC tambahan, tambah di sini
    task.wait(randf(0.6, 1.2))

    -- 5) Complete
    SafeFire(RE_Completed)
end

--====================== Runner State =====================
local AutoFishing = getgenv().LogicDev_AutoFishing or {}
AutoFishing._running = AutoFishing._running or false
AutoFishing._looping = AutoFishing._looping or false

function AutoFishing:SetRun(v)
    self._running = v and true or false
end

function AutoFishing:Kill()
    self._running = false
    self._looping = false
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

getgenv().LogicDev_AutoFishing = AutoFishing

--====================== GUI (WindUI) =====================
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

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

local SecMain    = Window:Section({ Title = "Main", Icon = "gamepad", Opened = true })
local TabFishing = SecMain:Tab({ Title = "Fishing", Icon = "fish" })

local Tgl_AutoFish = TabFishing:Toggle({
    Title   = "Auto Fishing",
    Icon    = "fish",
    Default = CFG.Run,
    Callback = function(state)
        CFG.Run = state
        AutoFishing:SetRun(state)
        if state then
            AutoFishing:Start()
        end
    end
})

-- Sinkronisasi (kalau CFG.Run diubah dari luar)
task.spawn(function()
    while task.wait(1) do
        if Tgl_AutoFish and Tgl_AutoFish.Set then
            Tgl_AutoFish:Set(CFG.Run)
        end
    end
end)

-- Kill/Unload cepat
Window:Keybind({
    Title = "Kill Auto Fishing",
    Key = Enum.KeyCode.End,
    Callback = function()
        CFG.Run = false
        AutoFishing:Kill()
        if CFG.DebugPrint then print("[AutoFishing] Killed") end
    end
})
