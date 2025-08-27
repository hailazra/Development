--========================================================
-- .devlogic — Auto Fishing (Single File, WindUI-correct)
--========================================================

-- Config
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

-- Services & Remotes
local RS          = game:GetService("ReplicatedStorage")
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LP          = Players.LocalPlayer

local NetRoot     = RS:WaitForChild("Packages"):WaitForChild("_Index")
                     :WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local RF_Charge   = NetRoot:WaitForChild("RF/ChargeFishingRod")
local RF_StartMG  = NetRoot:WaitForChild("RF/RequestFishingMinigameStarted")
local RE_Done     = NetRoot:WaitForChild("RE/FishingCompleted")

-- Utils
local function dprint(...) if CFG.DebugPrint then print("[AutoFishing]", ...) end end
local function randf(a,b) return a + (b-a) * math.random() end
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

    local bp = LP:FindFirstChildOfClass("Backpack")
    if not bp then return false end
    for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("rod") or n:find("fish") then
                hum:EquipTool(tool)
                dprint("Equip rod:", tool.Name)
                return true
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

-- Runner
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

--====================== WindUI (loader & GUI) ======================
-- Use the same loader pattern as the official example:
local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
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
    Desc    = "Cast → Minigame → Complete",
    Value   = CFG.Run,                 -- ✅ WindUI expects 'Value', not 'Default'
    Callback = function(state)
        CFG.Run = state
        AutoFishing:SetRun(state)
        if state then AutoFishing:Start() end
    end
})

-- Keep UI state in sync if changed elsewhere
task.spawn(function()
    while task.wait(1) do
        if Tgl_AutoFish and Tgl_AutoFish.Set then
            Tgl_AutoFish:Set(CFG.Run) -- ✅ WindUI Toggle exposes :Set(...)
        end
    end
end)
