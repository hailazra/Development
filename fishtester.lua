--========================================================
-- .devlogic / dlogicfish.lua — Auto Fishing (Custom GUI)
--========================================================
-- Tanpa WindUI. Single-file: GUI + logic.
-- GUI: ScreenGui kecil di pojok kanan atas, bisa drag.
--========================================================

--====================== Konfigurasi ======================
getgenv().AutoFishCFG = getgenv().AutoFishCFG or {
    Run          = false,
    AutoEquipRod = true,
    DebugPrint   = false,

    AimMin       = -0.25,
    AimMax       =  0.25,
    PowerMin     =  0.88,
    PowerMax     =  0.98,

    CastDelayMin = 1.6,
    CastDelayMax = 2.8,
}
local CFG = getgenv().AutoFishCFG
local casts, completes = 0, 0

--====================== Services & Remotes ==============
local RS          = game:GetService("ReplicatedStorage")
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UserInput   = game:GetService("UserInputService")
local LP          = Players.LocalPlayer

local function req(parent, child, t)
    t = t or 10
    local ok, obj = pcall(function() return parent:WaitForChild(child, t) end)
    assert(ok and obj, ("[dlogicfish] Missing node: %s"):format(child))
    return obj
end

-- Path dari data yang kamu share (sleitnick_net@0.2.0)
local NetRoot     = req(req(req(req(RS, "Packages"), "_Index"), "sleitnick_net@0.2.0"), "net")
local RF_Charge   = req(NetRoot, "RF/ChargeFishingRod")
local RF_StartMG  = req(NetRoot, "RF/RequestFishingMinigameStarted")
local RE_Done     = req(NetRoot, "RE/FishingCompleted")

--====================== Util ============================
local function dprint(...) if CFG.DebugPrint then print("[AutoFishing]", ...) end end
local function clamp(x,a,b) if x<a then return a elseif x>b then return b else return x end end
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

-- Kalau suatu saat minigame butuh tick RPC tambahan, isi di sini
local function MinigameTickStub()
    -- placeholder
end

local function OneCast()
    if not EquipRodIfNeeded() then
        dprint("Rod not found/equipped")
        return
    end

    SafeInvoke(RF_Charge, os.clock() + math.random())

    local aimMin, aimMax       = math.min(CFG.AimMin, CFG.AimMax), math.max(CFG.AimMin, CFG.AimMax)
    local powerMin, powerMax   = math.min(CFG.PowerMin, CFG.PowerMax), math.max(CFG.PowerMin, CFG.PowerMax)
    local aim                  = randf(aimMin, aimMax)
    local power                = randf(powerMin, powerMax)
    SafeInvoke(RF_StartMG, aim, power)

    MinigameTickStub()
    task.wait(randf(0.6, 1.2))

    SafeFire(RE_Done)

    casts += 1
    completes += 1
end

--====================== Runner ==========================
local AutoFishing = rawget(getgenv(), "LogicDev_AutoFishing") or {}
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
    end)
end
getgenv().LogicDev_AutoFishing = AutoFishing

--====================== GUI Buatan Sendiri ==============
-- target parent GUI
local function getGuiParent()
    local ok, gethuiFn = pcall(function() return gethui end)
    if ok and typeof(gethuiFn) == "function" then
        local s, ui = pcall(gethuiFn)
        if s and ui then return ui end
    end
    local CoreGui = game:GetService("CoreGui")
    if CoreGui then return CoreGui end
    return LP:WaitForChild("PlayerGui")
end

-- bersihkan GUI lama
local GUI_NAME = "dlogicfish_gui"
do
    local parent = getGuiParent()
    local old = parent:FindFirstChild(GUI_NAME)
    if old then old:Destroy() end
end

-- buat gui
local parent = getGuiParent()
local sg = Instance.new("ScreenGui")
sg.Name = GUI_NAME
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = parent

-- frame utama
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.fromOffset(270, 260)
frame.Position = UDim2.new(1, -280, 0, 80) -- kanan atas
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Parent = sg

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 28)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(240,240,240)
title.Text = ".devlogic — Fishing"
title.Parent = frame

-- drag area
local dragBtn = Instance.new("TextButton")
dragBtn.BackgroundTransparency = 1
dragBtn.Size = UDim2.new(1, 0, 0, 40)
dragBtn.Position = UDim2.new(0, 0, 0, 0)
dragBtn.Text = ""
dragBtn.Parent = frame

do
    local dragging, dragStart, startPos
    dragBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInput.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- pembatas
local line = Instance.new("Frame")
line.Size = UDim2.new(1, -20, 0, 1)
line.Position = UDim2.new(0, 10, 0, 42)
line.BackgroundColor3 = Color3.fromRGB(60,60,60)
line.BorderSizePixel = 0
line.Parent = frame

-- helper UI
local function mkLabel(text, x, y, w)
    local lb = Instance.new("TextLabel")
    lb.BackgroundTransparency = 1
    lb.Font = Enum.Font.Gotham
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.Text = text
    lb.TextColor3 = Color3.fromRGB(220,220,220)
    lb.TextSize = 12
    lb.Size = UDim2.fromOffset(w or 120, 18)
    lb.Position = UDim2.new(0, x, 0, y)
    lb.Parent = frame
    return lb
end

local function mkBox(placeholder, default, x, y, w)
    local tb = Instance.new("TextBox")
    tb.Font = Enum.Font.Gotham
    tb.TextSize = 12
    tb.PlaceholderText = placeholder
    tb.Text = tostring(default)
    tb.TextColor3 = Color3.fromRGB(240,240,240)
    tb.BackgroundColor3 = Color3.fromRGB(35,35,35)
    tb.BorderSizePixel = 0
    tb.Size = UDim2.fromOffset(w or 60, 20)
    tb.Position = UDim2.new(0, x, 0, y)
    tb.ClearTextOnFocus = false
    tb.Parent = frame
    local u = Instance.new("UICorner", tb) u.CornerRadius = UDim.new(0,6)
    return tb
end

local function mkButton(text, x, y, w, h)
    local b = Instance.new("TextButton")
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    b.TextColor3 = Color3.fromRGB(240,240,240)
    b.Text = text
    b.AutoButtonColor = true
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.BorderSizePixel = 0
    b.Size = UDim2.fromOffset(w or 90, h or 24)
    b.Position = UDim2.new(0, x, 0, y)
    b.Parent = frame
    local u = Instance.new("UICorner", b) u.CornerRadius = UDim.new(0,8)
    return b
end

local function colorizeToggle(btn, on)
    btn.Text = on and "ON" or "OFF"
    btn.BackgroundColor3 = on and Color3.fromRGB(40,120,60) or Color3.fromRGB(90,40,40)
end

-- Toggle Run
mkLabel("Auto Fishing", 10, 52)
local btnRun = mkButton("", 110, 50, 50, 22)
colorizeToggle(btnRun, CFG.Run)
btnRun.MouseButton1Click:Connect(function()
    CFG.Run = not CFG.Run
    colorizeToggle(btnRun, CFG.Run)
    AutoFishing:SetRun(CFG.Run)
    if CFG.Run then AutoFishing:Start() end
end)

-- Toggle AutoEquip
mkLabel("Auto-Equip Rod", 10, 80)
local btnAE = mkButton("", 110, 78, 50, 22)
colorizeToggle(btnAE, CFG.AutoEquipRod)
btnAE.MouseButton1Click:Connect(function()
    CFG.AutoEquipRod = not CFG.AutoEquipRod
    colorizeToggle(btnAE, CFG.AutoEquipRod)
end)

-- Debug
mkLabel("Debug Print", 170, 80)
local btnDbg = mkButton("", 250, 78, 50, 22)
colorizeToggle(btnDbg, CFG.DebugPrint)
btnDbg.MouseButton1Click:Connect(function()
    CFG.DebugPrint = not CFG.DebugPrint
    colorizeToggle(btnDbg, CFG.DebugPrint)
end)

-- Inputs Aim / Power
mkLabel("Aim (min/max)", 10, 112)
local boxAimMin = mkBox("-1..1", CFG.AimMin, 110, 110, 60)
local boxAimMax = mkBox("-1..1", CFG.AimMax, 175, 110, 60)

mkLabel("Power (min/max)", 10, 138)
local boxPowMin = mkBox("0..1", CFG.PowerMin, 110, 136, 60)
local boxPowMax = mkBox("0..1", CFG.PowerMax, 175, 136, 60)

-- Inputs Delay
mkLabel("Delay (min/max s)", 10, 164)
local boxDelMin = mkBox("sec", CFG.CastDelayMin, 110, 162, 60)
local boxDelMax = mkBox("sec", CFG.CastDelayMax, 175, 162, 60)

-- Apply
local btnApply = mkButton("Apply", 240, 134, 20, 50)
btnApply.MouseButton1Click:Connect(function()
    local function tonum(tb, def) local v = tonumber(tb.Text) return v or def end
    local aMin, aMax = tonum(boxAimMin, CFG.AimMin), tonum(boxAimMax, CFG.AimMax)
    CFG.AimMin = clamp(aMin, -1, 1)
    CFG.AimMax = clamp(aMax, -1, 1)

    local pMin, pMax = tonum(boxPowMin, CFG.PowerMin), tonum(boxPowMax, CFG.PowerMax)
    CFG.PowerMin = clamp(pMin, 0, 1)
    CFG.PowerMax = clamp(pMax, 0, 1)

    local dMin, dMax = tonum(boxDelMin, CFG.CastDelayMin), tonum(boxDelMax, CFG.CastDelayMax)
    CFG.CastDelayMin = clamp(dMin, 0, 10)
    CFG.CastDelayMax = clamp(dMax, 0, 10)
end)

-- Status
local status = mkLabel("Status: Casts 0 | Completes 0", 10, 194, 240)

-- Kill
local btnKill = mkButton("Kill / Close", 10, 218, 250, 28)
btnKill.BackgroundColor3 = Color3.fromRGB(120,50,50)
btnKill.MouseButton1Click:Connect(function()
    CFG.Run = false
    AutoFishing:Kill()
    sg:Destroy()
end)

-- refresher status
task.spawn(function()
    while sg.Parent do
        status.Text = ("Status: Casts %d | Completes %d"):format(casts, completes)
        task.wait(0.5)
    end
end)

-- auto-start jika CFG.Run true (sinkron)
if CFG.Run then
    AutoFishing:SetRun(true)
    AutoFishing:Start()
    colorizeToggle(btnRun, true)
end
print("[.devlogic] dlogicfish (custom GUI) loaded")


