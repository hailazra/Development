--========================================================
-- .devlogic / dlogicfish.lua — Auto Fishing (Single File)
--========================================================
-- GUI: WindUI (1 tab)  |  Logic: Charge -> StartMinigame -> Complete
-- Tambahan:
--  - Auto-equip rod (heuristik nama berisi "rod"/"fish")
--  - Slider Aim/Power/Delay
--  - Status counter (casts/completes) + tombol Kill
--  - Robust terhadap variasi API WindUI (fallback Section/Tab/Toggle/Set)
--========================================================

--====================== Konfigurasi ======================
getgenv().AutoFishCFG = getgenv().AutoFishCFG or {
    Run          = false,
    AutoEquipRod = true,
    DebugPrint   = false,

    -- Range parameter minigame
    AimMin       = -0.25,   -- -1..1
    AimMax       =  0.25,   -- -1..1
    PowerMin     =  0.88,   -- 0..1
    PowerMax     =  0.98,   -- 0..1

    -- Jeda “manusiawi” antar cast (detik)
    CastDelayMin = 1.6,
    CastDelayMax = 2.8,
}
local CFG = getgenv().AutoFishCFG

--====================== Services & Remotes ==============
local RS          = game:GetService("ReplicatedStorage")
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LP          = Players.LocalPlayer

local function req(parent, child)
    local ok, obj = pcall(function() return parent:WaitForChild(child, 10) end)
    assert(ok and obj, ("[dlogicfish] Missing node: %s"):format(child))
    return obj
end

-- Path dari data kamu (Sleitnick Net)
local NetRoot     = req(req(req(req(RS, "Packages"), "_Index"), "sleitnick_net@0.2.0"), "net")
local RF_Charge   = req(NetRoot, "RF/ChargeFishingRod")
local RF_StartMG  = req(NetRoot, "RF/RequestFishingMinigameStarted")
local RE_Done     = req(NetRoot, "RE/FishingCompleted")

--====================== Util ============================
local casts, completes = 0, 0

local function dprint(...)
    if CFG.DebugPrint then print("[AutoFishing]", ...) end
end

local function clamp(x, a, b) if x < a then return a elseif x > b then return b else return x end end
local function randf(a, b) return a + (b - a) * math.random() end

local function Humanoid()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function EquipRodIfNeeded()
    if not CFG.AutoEquipRod then return true end
    local hum = Humanoid()
    local char = LP.Character
    if not hum or not char then return false end

    -- Sudah pegang tool?
    if char:FindFirstChildOfClass("Tool") then return true end

    -- Cari rod di Backpack (heuristik nama)
    local bp = LP:FindFirstChildOfClass("Backpack")
    if not bp then return false end
    local target
    for _, tool in ipairs(bp:GetChildren()) do
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
    local ok, res = pcall(function() return rf:InvokeServer(...) end)
    if not ok then dprint("Invoke error:", res) end
    return ok, res
end

local function SafeFire(re, ...)
    local ok, err = pcall(function() re:FireServer(...) end)
    if not ok then dprint("Fire error:", err) end
    return ok
end

-- Jika nanti terdeteksi minigame perlu “ticks”, tambahkan di sini
local function MinigameTickStub()
    -- contoh: kirim RPC progress tiap ~0.1s kalau game update suatu saat.
    -- sekarang belum ada remotnya, jadi dibiarkan stub.
end

local function OneCast()
    if not EquipRodIfNeeded() then
        dprint("Rod not found/equipped")
        return
    end

    -- Charge (pakai timestamp-ish agar mirip perilaku asli)
    local ts = os.clock() + math.random()
    SafeInvoke(RF_Charge, ts)

    -- Start minigame: aim & power
    local aimMin, aimMax       = math.min(CFG.AimMin, CFG.AimMax), math.max(CFG.AimMin, CFG.AimMax)
    local powerMin, powerMax   = math.min(CFG.PowerMin, CFG.PowerMax), math.max(CFG.PowerMin, CFG.PowerMax)
    local aim                  = randf(aimMin, aimMax)
    local power                = randf(powerMin, powerMax)
    SafeInvoke(RF_StartMG, aim, power)

    -- Optional tick (jaga-jaga)
    MinigameTickStub()

    -- Tunggu sedikit (durasi minigame)
    task.wait(randf(0.6, 1.2))

    -- Complete
    SafeFire(RE_Done)

    -- Stats
    casts += 1
    completes += 1
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
    dprint("Loop start")
    task.spawn(function()
        while self._looping do
            if self._running then
                local hum = Humanoid()
                if hum and hum.Health > 0 then
                    local dMin = math.min(CFG.CastDelayMin, CFG.CastDelayMax)
                    local dMax = math.max(CFG.CastDelayMin, CFG.CastDelayMax)
                    OneCast()
                    task.wait(randf(dMin, dMax))
                else
                    task.wait(1)
                end
            else
                RunService.Heartbeat:Wait()
            end
        end
        dprint("Loop end")
    end)
end

getgenv().LogicDev_AutoFishing = AutoFishing

--====================== WindUI Loader (robust) ==========
local WindUI
do
    local ok, lib = pcall(function()
        -- prefer dist stable
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end)
    if not ok or type(lib) ~= "table" or type(lib.CreateWindow) ~= "function" then
        warn("[dlogicfish] WindUI dist gagal, fallback releases/latest")
        ok, lib = pcall(function()
            return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        end)
        assert(ok and type(lib) == "table" and type(lib.CreateWindow) == "function",
               "[dlogicfish] WindUI CreateWindow tidak tersedia")
    end
    WindUI = lib
end

--====================== GUI (1 Tab) ======================
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

-- beberapa versi WindUI punya Section(); kita fallback bila tidak ada
local SecMain = (type(Window.Section) == "function")
    and Window:Section({ Title = "Main", Icon = "gamepad", Opened = true })
    or Window

-- tab bikin lewat Section atau Window, tergantung yang ada
local TabFishing = (type(SecMain.Tab) == "function")
    and SecMain:Tab({ Title = "Fishing", Icon = "fish" })
    or (type(Window.Tab) == "function" and Window:Tab({ Title = "Fishing", Icon = "fish" }))

assert(TabFishing, "[dlogicfish] Gagal membuat Tab Fishing — method :Tab() tidak ditemukan")

-- Helper agar aman dengan variasi API Toggle
local function toggle_create(scope, opts)
    assert(type(scope.Toggle) == "function", "[dlogicfish] Method :Toggle() tidak ada")
    return scope:Toggle(opts)
end
local function toggle_set(tgl, v)
    if tgl and type(tgl.Set) == "function" then
        tgl:Set(v)
    elseif tgl and type(tgl.SetValue) == "function" then
        tgl:SetValue(v)
    end
end

--=========== UI Controls ===========
-- Status kecil
local StatusLabel = TabFishing:Label({
    Title = ("Status: Casts %d | Completes %d"):format(casts, completes)
})

-- Toggle utama
local Tgl_Run = toggle_create(TabFishing, {
    Title    = "Auto Fishing",
    Desc     = "Cast \226\134\146 Minigame \226\134\146 Complete",
    Value    = CFG.Run,     -- pakai Value (umum di WindUI)
    Default  = CFG.Run,     -- sekaligus set Default (untuk variasi)
    Callback = function(state)
        CFG.Run = state
        AutoFishing:SetRun(state)
        if state then AutoFishing:Start() end
    end
})

-- Toggle auto-equip
local Tgl_AutoEquip = toggle_create(TabFishing, {
    Title    = "Auto-Equip Rod",
    Desc     = "Cari & equip tool yang namanya mengandung 'rod'/'fish'",
    Value    = CFG.AutoEquipRod,
    Default  = CFG.AutoEquipRod,
    Callback = function(state)
        CFG.AutoEquipRod = state
    end
})

-- Toggle debug
local Tgl_Debug = toggle_create(TabFishing, {
    Title    = "Debug Print",
    Value    = CFG.DebugPrint,
    Default  = CFG.DebugPrint,
    Callback = function(state)
        CFG.DebugPrint = state
    end
})

-- Slider helper (jaga perbedaan API)
local function add_slider(scope, params)
    assert(type(scope.Slider) == "function", "[dlogicfish] Method :Slider() tidak ada")
    return scope:Slider(params)
end

-- Delay sliders
local S_CDelayMin = add_slider(TabFishing, {
    Title = "Cast Delay Min (s)",
    Min = 0.5, Max = 5.0, Value = CFG.CastDelayMin, Rounding = 2,
    Callback = function(v) CFG.CastDelayMin = clamp(v, 0.0, 10.0) end
})
local S_CDelayMax = add_slider(TabFishing, {
    Title = "Cast Delay Max (s)",
    Min = 0.6, Max = 6.0, Value = CFG.CastDelayMax, Rounding = 2,
    Callback = function(v) CFG.CastDelayMax = clamp(v, 0.0, 10.0) end
})

-- Aim/Power sliders
local S_AimMin = add_slider(TabFishing, {
    Title = "Aim Min",
    Min = -1.0, Max = 1.0, Value = CFG.AimMin, Rounding = 2,
    Callback = function(v) CFG.AimMin = clamp(v, -1.0, 1.0) end
})
local S_AimMax = add_slider(TabFishing, {
    Title = "Aim Max",
    Min = -1.0, Max = 1.0, Value = CFG.AimMax, Rounding = 2,
    Callback = function(v) CFG.AimMax = clamp(v, -1.0, 1.0) end
})
local S_PowerMin = add_slider(TabFishing, {
    Title = "Power Min",
    Min = 0.0, Max = 1.0, Value = CFG.PowerMin, Rounding = 2,
    Callback = function(v) CFG.PowerMin = clamp(v, 0.0, 1.0) end
})
local S_PowerMax = add_slider(TabFishing, {
    Title = "Power Max",
    Min = 0.0, Max = 1.0, Value = CFG.PowerMax, Rounding = 2,
    Callback = function(v) CFG.PowerMax = clamp(v, 0.0, 1.0) end
})

-- Tombol Kill
local Btn_Kill = TabFishing:Button({
    Title = "Kill / Unload",
    Icon  = "skull",
    Callback = function()
        CFG.Run = false
        AutoFishing:Kill()
        toggle_set(Tgl_Run, false)
        dprint("Killed")
    end
})

-- UI refresher
task.spawn(function()
    while task.wait(0.5) do
        -- sync toggle utama bila berubah dari luar
        toggle_set(Tgl_Run, CFG.Run)
        -- update status
        if StatusLabel and type(StatusLabel.SetTitle) == "function" then
            StatusLabel:SetTitle(("Status: Casts %d | Completes %d"):format(casts, completes))
        end
    end
end)

print("[.devlogic] dlogicfish.lua loaded")

