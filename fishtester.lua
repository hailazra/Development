--========================================================
-- .devlogic — Auto Fishing (Single File, WindUI fail-safe)
--========================================================

-- ===== Config =====
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
local function dprint(...) if CFG.DebugPrint then print("[AutoFishing]", ...) end end

-- ===== Services & Remotes =====
local RS          = game:GetService("ReplicatedStorage")
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LP          = Players.LocalPlayer

local function req(path, name)
    local node = path:WaitForChild(name)
    if not node then error("Missing: "..name) end
    return node
end

local NetRoot = req(req(req(req(RS, "Packages"), "_Index"), "sleitnick_net@0.2.0"), "net")
local RF_Charge  = req(NetRoot, "RF/ChargeFishingRod")
local RF_StartMG = req(NetRoot, "RF/RequestFishingMinigameStarted")
local RE_Done    = req(NetRoot, "RE/FishingCompleted")

-- ===== Utils =====
local function randf(a,b) return a + (b-a)*math.random() end
local function Humanoid()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function EquipRodIfNeeded()
    if not CFG.AutoEquipRod then return true end
    local hum = Humanoid()
    local char = LP.Character
    if not hum or not char then return false end
    if char:FindFirstChildOfClass("Tool") then return true end
    local bp = LP:FindFirstChildOfClass("Backpack"); if not bp then return false end
    for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("rod") or n:find("fish") then
                hum:EquipTool(tool); dprint("Equip rod:", tool.Name); return true
            end
        end
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

local function OneCast()
    if not EquipRodIfNeeded() then dprint("Rod not found/equipped"); return end
    SafeInvoke(RF_Charge, os.clock() + math.random())
    SafeInvoke(RF_StartMG, randf(CFG.AimMin, CFG.AimMax), randf(CFG.PowerMin, CFG.PowerMax))
    task.wait(randf(0.6, 1.2))
    SafeFire(RE_Done)
end

-- ===== Runner =====
local AutoFishing = getgenv().LogicDev_AutoFishing or {}
AutoFishing._running = AutoFishing._running or false
AutoFishing._looping = AutoFishing._looping or false
function AutoFishing:SetRun(v) self._running = v and true or false end
function AutoFishing:Kill() self._running = false self._looping = false end
function AutoFishing:Start()
    if self._looping then return end
    self._looping = true
    task.spawn(function()
        while self._looping do
            if self._running then
                local hum = Humanoid()
                if hum and hum.Health > 0 then
                    OneCast()
                    task.wait(randf(CFG.CastDelayMin, CFG.CastDelayMax))
                else
                    task.wait(1)
                end
            else
                RunService.Heartbeat:Wait()
            end
        end
    end)
end
getgenv().LogicDev_AutoFishing = AutoFishing

-- ===== WindUI (robust loader + API fallback) =====
-- Coba release dist dulu (lebih stabil). Jika gagal, fallback ke releases/latest.
local WindUI
do
    local ok, lib = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end)
    if not ok or type(lib) ~= "table" or type(lib.CreateWindow) ~= "function" then
        warn("[WindUI] dist loader gagal, coba releases/latest")
        ok, lib = pcall(function()
            return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        end)
    end
    assert(type(lib)=="table" and type(lib.CreateWindow)=="function", "[WindUI] CreateWindow tidak tersedia")
    WindUI = lib
end

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

-- Beberapa versi WindUI ada yang: Window:Section():Tab()
-- Versi lain langsung: Window:Tab() tanpa Section.
local SecMain
if type(Window.Section) == "function" then
    SecMain = Window:Section({ Title = "Main", Icon = "gamepad", Opened = true })
else
    SecMain = Window -- fallback: pakai Window langsung
end

local TabFishing
if type(SecMain.Tab) == "function" then
    TabFishing = SecMain:Tab({ Title = "Fishing", Icon = "fish" })
elseif type(Window.Tab) == "function" then
    TabFishing = Window:Tab({ Title = "Fishing", Icon = "fish" })
else
    error("[WindUI] Tidak menemukan method :Tab() pada Window/Section")
end
assert(TabFishing, "[WindUI] Gagal membuat Tab")

-- Toggle API juga kadang beda: pastikan field dan setter aman.
local function toggle_create(scope, opts)
    assert(type(scope.Toggle) == "function", "[WindUI] Method :Toggle() tidak ada")
    return scope:Toggle(opts)
end

local function toggle_set(tgl, v)
    if tgl and type(tgl.Set) == "function" then
        tgl:Set(v)
    elseif tgl and type(tgl.SetValue) == "function" then
        tgl:SetValue(v)
    else
        -- tidak ada setter? abaikan sinkronisasi
    end
end

local Tgl_AutoFish = toggle_create(TabFishing, {
    Title   = "Auto Fishing",
    Desc    = "Cast → Minigame → Complete",
    -- WindUI variasi: "Value" / "Default" — kita set keduanya supaya aman
    Value   = CFG.Run,
    Default = CFG.Run,
    Callback = function(state)
        CFG.Run = state
        AutoFishing:SetRun(state)
        if state then AutoFishing:Start() end
    end
})

-- Sinkronisasi UI jika nilai berubah dari luar
task.spawn(function()
    while task.wait(1) do
        toggle_set(Tgl_AutoFish, CFG.Run)
    end
end)

print("[.devlogic] Auto Fishing loaded OK")
