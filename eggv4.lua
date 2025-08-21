-- 🌀 Auto Unlimited Eggs + Team C Auto Sell (WindUI) — MULTI-PLAYER FARM FIX
-- Flow: Team A (place) → Team B (delay, hatch) → Team C (delay, sell) → Team A
-- Fix utama: resolve farm MILIK LOCALPLAYER (Important.Data.Owner == LP.Name)
--            sehingga PlaceEgg tetap jalan walau ada player lain di server.

--==============================
-- Load WindUI
--==============================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

--==============================
-- Services & Globals
--==============================
local Players    = game:GetService("Players")
local RS         = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace  = game:GetService("Workspace")

local LP        = Players.LocalPlayer
local Backpack  = LP:WaitForChild("Backpack")
local Character = LP.Character or LP.CharacterAdded:Wait()
local Humanoid  = Character:WaitForChild("Humanoid")
local Camera    = Workspace.CurrentCamera

-- Remotes
local GameEvents        = RS:WaitForChild("GameEvents")
local PetsService       = GameEvents:WaitForChild("PetsService")         -- :FireServer("SwapPetLoadout", index)
local PetEggService     = GameEvents:WaitForChild("PetEggService")       -- :FireServer("CreateEgg", Vector3)
local SellPet_RE        = GameEvents:WaitForChild("SellPet_RE")          -- :FireServer(tool)
local PetLoadoutApplied = GameEvents:FindFirstChild("PetLoadoutApplied") -- optional RemoteEvent confirm

--==============================
-- Farm Resolver (owner-aware)
--==============================
local FARM_ROOT, IMPORTANT, OBJ_ROOT, PLANT_LOC

local function resolveFarmForLocal()
    -- Cari folder "Farm" yang punya Important -> Data -> Owner == LP.Name
    local candidate = nil

    -- 1) Cari lewat jalur umum yang sering dipakai dev (berlapis)
    local rootFarmContainer = Workspace:FindFirstChild("Farm")
    if rootFarmContainer then
        -- Bisa jadi ada subfolder bernama "Farm" lagi (beberapa map begitu)
        -- Kita iter semua descendant: ambil folder yang bernama "Farm" dan punya Important/Data/Owner
        for _, node in ipairs(rootFarmContainer:GetDescendants()) do
            if node:IsA("Folder") and node.Name == "Farm" then
                local Important = node:FindFirstChild("Important")
                local Data      = Important and Important:FindFirstChild("Data")
                local OwnerVal  = Data and Data:FindFirstChild("Owner")
                if OwnerVal and tostring(OwnerVal.Value) == LP.Name then
                    candidate = node
                    break
                end
            end
        end
        -- Fallback: kalau ga ketemu spesifik owner, coba rootFarmContainer.Farm (single farm layout)
        if not candidate then
            local single = rootFarmContainer:FindFirstChild("Farm")
            if single and single:FindFirstChild("Important") then
                candidate = single
            end
        end
    end

    -- 2) Fallback keras: scan Workspace untuk folder "Farm" siap pakai
    if not candidate then
        for _, node in ipairs(Workspace:GetDescendants()) do
            if node:IsA("Folder") and node.Name == "Farm" then
                local Important = node:FindFirstChild("Important")
                local Data      = Important and Important:FindFirstChild("Data")
                local OwnerVal  = Data and Data:FindFirstChild("Owner")
                if OwnerVal and tostring(OwnerVal.Value) == LP.Name then
                    candidate = node
                    break
                end
            end
        end
    end

    -- Pasang pointer global
    if candidate then
        FARM_ROOT = candidate
        IMPORTANT = FARM_ROOT:FindFirstChild("Important") or FARM_ROOT:WaitForChild("Important")
        OBJ_ROOT  = IMPORTANT:FindFirstChild("Objects_Physical") or IMPORTANT:WaitForChild("Objects_Physical")
        PLANT_LOC = IMPORTANT:FindFirstChild("Plant_Locations") -- biarkan nil kalau belum kebentuk
        return true
    else
        -- Last resort: layout lama tunggal
        local fr = Workspace:FindFirstChild("Farm")
        fr = fr and fr:FindFirstChild("Farm") or fr
        if fr and fr:FindFirstChild("Important") then
            FARM_ROOT = fr
            IMPORTANT = fr:FindFirstChild("Important")
            OBJ_ROOT  = IMPORTANT:FindFirstChild("Objects_Physical") or IMPORTANT:WaitForChild("Objects_Physical")
            PLANT_LOC = IMPORTANT:FindFirstChild("Plant_Locations")
            return true
        end
    end
    return false
end

resolveFarmForLocal()

-- Auto-recheck farm (kalau teleported / re-instance)
task.spawn(function()
    while true do
        if not (FARM_ROOT and IMPORTANT and OBJ_ROOT) then
            resolveFarmForLocal()
        else
            -- Jika Owner pindah plot (server reassign), pointer bisa basi → per 5 detik validasi owner
            local ok = false
            local Data = IMPORTANT:FindFirstChild("Data")
            local OwnerVal = Data and Data:FindFirstChild("Owner")
            if OwnerVal and tostring(OwnerVal.Value) == LP.Name then ok = true end
            if not ok then resolveFarmForLocal() end
        end
        task.wait(5)
    end
end)

--==============================
-- Config & State
--==============================
local CFG = getgenv and (getgenv().AutoUE_CFG or {}) or {}
-- Teams
CFG.TeamAIndex     = CFG.TeamAIndex or 1
CFG.TeamBIndex     = CFG.TeamBIndex or 2
CFG.TeamCIndex     = CFG.TeamCIndex or 3         -- Team C untuk sell
-- Delays
CFG.SwitchDelayB   = CFG.SwitchDelayB or 6.0     -- detik sebelum hatch (Team B)
CFG.SwitchDelayC   = CFG.SwitchDelayC or 6.0     -- detik sebelum sell  (Team C)
CFG.SwitchPoll     = CFG.SwitchPoll or 0.6
-- Place
CFG.MaxSlots       = CFG.MaxSlots or 8
CFG.MinEggGap      = CFG.MinEggGap or 3.0
CFG.GridStep       = CFG.GridStep or 1.0
CFG.AutoPlace      = (CFG.AutoPlace ~= false)
-- Hatch
CFG.OwnerFilter    = (CFG.OwnerFilter ~= false)
CFG.HatchCooldown  = CFG.HatchCooldown or 1.2
CFG.TryTimeout     = CFG.TryTimeout or 2.0
CFG.MaxRetry       = CFG.MaxRetry or 2
CFG.CoolPerEgg     = CFG.CoolPerEgg or 3.0
-- Workflow
CFG.Run            = CFG.Run or false

if getgenv then getgenv().AutoUE_CFG = CFG end

-- Auto Sell rules (share)
local AutoSellCFG = getgenv().AutoSellPetCFG or {}
AutoSellCFG.Rules = AutoSellCFG.Rules or {}  -- { [basename] = {maxKg=number} }
getgenv().AutoSellPetCFG = AutoSellCFG

local Status = "Idle"
local function setStatus(s) Status = s end

--==============================
-- vector.create compat
--==============================
local vcreate
do
    local ok,g = pcall(function() return _G.vector or getfenv(0).vector end)
    if ok and g and typeof(g)=="table" and typeof(g.create)=="function" then
        vcreate = g.create
    else
        vcreate = function(x,y,z) return Vector3.new(x,y,z) end
    end
end

--==============================
-- Team Switcher (retry + optional confirm)
--==============================
local CurrentLoadout, Switching = nil, false
local function switchLoadout(index) -- boolean
    if Switching or CurrentLoadout == index then return CurrentLoadout == index end
    Switching = true
    setStatus(("Switching → %d"):format(index))
    local ok = false
    for i=1,3 do
        local fired = pcall(function() PetsService:FireServer("SwapPetLoadout", index) end)
        if fired then
            if PetLoadoutApplied and PetLoadoutApplied:IsA("RemoteEvent") then
                local got=false
                local conn; conn = PetLoadoutApplied.OnClientEvent:Connect(function(applied)
                    if typeof(applied)=="number" and applied==index then got=true; conn:Disconnect()
                    elseif typeof(applied)=="string" then got=true; conn:Disconnect() end
                end)
                local t0=time()
                repeat RunService.Heartbeat:Wait() until got or (time()-t0)>1.0
                ok = got
            else
                task.wait(0.20); ok = true
            end
        end
        if ok then
            CurrentLoadout = index
            setStatus(("Team = %d (ok, try %d)"):format(index,i))
            break
        else
            task.wait(0.15)
        end
    end
    if not ok then setStatus(("Switch fail → %d"):format(index)) end
    Switching=false
    return ok
end

--==============================
-- Egg utils (count, ready, prompts)
--==============================
local function uuidOf(m)
    return m:GetAttribute("OBJECT_UUID") or m:GetAttribute("UUID") or tostring(m)
end

local function isOurEggModel(m)
    if not (m and m:IsA("Model") and m.Name=="PetEgg") then return false end
    if not CFG.OwnerFilter then return true end
    local owner = m:GetAttribute("OWNER")
    return (owner == nil) or (owner == LP.Name)
end

local function findHatchPrompt(m)
    local p = m:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not p then return end
    local txt = ((p.ActionText or "").." "..(p.ObjectText or "")):lower()
    if txt:find("skip") then return end
    if txt:find("hatch") then return p end
end

local function isReady(m)
    if not isOurEggModel(m) then return false end
    local tth = m:GetAttribute("TimeToHatch")
    return (typeof(tth)=="number" and tth<=0)
end

local function countReadyEggs()
    if not OBJ_ROOT then return 0 end
    local n=0
    for _,d in ipairs(OBJ_ROOT:GetDescendants()) do
        if d:IsA("Model") and d.Name=="PetEgg" and isReady(d) then n = n + 1 end
    end
    return n
end

local function ourEggCount()
    if not OBJ_ROOT then return 0 end
    local n=0
    for _,d in ipairs(OBJ_ROOT:GetDescendants()) do
        if d:IsA("Model") and d.Name=="PetEgg" and isOurEggModel(d) then n = n + 1 end
    end
    return n
end

local function allEggsReady()
    if not OBJ_ROOT then return false,0,0 end
    local ready,total=0,0
    for _,d in ipairs(OBJ_ROOT:GetDescendants()) do
        if d:IsA("Model") and d.Name=="PetEgg" and isOurEggModel(d) then
            total = total + 1
            if isReady(d) then ready = ready + 1 end
        end
    end
    return (total>0) and (ready==total), ready, total
end

--==============================
-- Auto Hatch (prompt-only, multi-egg)
--==============================
local lastTryAt, inQ, Q = {}, {}, {}

local function firePrompt(prompt)
    if typeof(fireproximityprompt) ~= "function" then
        warn("[AutoUE] fireproximityprompt not available"); return false
    end
    local hold = math.max(0.1, prompt.HoldDuration or 1)
    return pcall(function() fireproximityprompt(prompt, hold) end)
end

local function hatchOne(model)
    local id = uuidOf(model); if not id then return false end
    if lastTryAt[id] and (time()-lastTryAt[id]) < CFG.CoolPerEgg then return false end
    local prompt = findHatchPrompt(model)
    if not (prompt and prompt.Enabled) then return false end

    for _=1,(1+CFG.MaxRetry) do
        lastTryAt[id]=time()
        local ok = firePrompt(prompt); if not ok then break end
        local t0=time()
        repeat task.wait(0.05) until (not model.Parent) or (not isReady(model)) or (time()-t0) > CFG.TryTimeout
        if (not model.Parent) or (not isReady(model)) then
            inQ[id]=nil
            return true
        end
    end
    return false
end

local HATCH_ENABLE=false
task.spawn(function()
    while true do
        if HATCH_ENABLE then
            local m = table.remove(Q,1)
            if m and m.Parent then
                hatchOne(m)
                task.wait(CFG.HatchCooldown)
            end
        end
        task.wait(0.05)
    end
end)

local function watchEgg(m)
    if not (m and m:IsA("Model")) then return end
    local function onChange()
        if isReady(m) then
            local id=uuidOf(m); if id and not inQ[id] then table.insert(Q,m); inQ[id]=true end
        end
    end
    onChange()
    m:GetAttributeChangedSignal("READY"):Connect(onChange)
    m:GetAttributeChangedSignal("TimeToHatch"):Connect(onChange)
    m:GetAttributeChangedSignal("OWNER"):Connect(onChange)
    local p = findHatchPrompt(m); if p then p:GetPropertyChangedSignal("Enabled"):Connect(onChange) end
    m.AncestryChanged:Connect(function(_,parent) if parent==nil then inQ[uuidOf(m)]=nil end end)
end

-- Hook ke farm milik kita
if OBJ_ROOT then
    for _,d in ipairs(OBJ_ROOT:GetDescendants()) do
        if d:IsA("Model") and d.Name=="PetEgg" then watchEgg(d) end
    end
    OBJ_ROOT.DescendantAdded:Connect(function(d)
        if d:IsA("Model") and d.Name=="PetEgg" then task.wait(0.05); watchEgg(d) end
    end)
end

--==============================
-- Place Eggs (grid + MaxSlots) – pakai Plant_Locations farm kita
--==============================
local Areas = {}

local function getRectFromPart(p)
    local sx,sz = p.Size.X/2, p.Size.Z/2
    local offs = {
        Vector3.new(-sx,0,-sz), Vector3.new(-sx,0, sz),
        Vector3.new( sx,0,-sz), Vector3.new( sx,0, sz),
    }
    local ySurf; local xMin,xMax,zMin,zMax
    for _,o in ipairs(offs) do
        local w = (p.CFrame * CFrame.new(o)).Position
        ySurf = ySurf or w.Y
        xMin = xMin and math.min(xMin,w.X) or w.X
        xMax = xMax and math.max(xMax,w.X) or w.X
        zMin = zMin and math.min(zMin,w.Z) or w.Z
        zMax = zMax and math.max(zMax,w.Z) or w.Z
    end
    return {part=p, y=ySurf or p.Position.Y, xMin=xMin, xMax=xMax, zMin=zMin, zMax=zMax}
end

local function rebuildAreas()
    Areas = {}
    if not PLANT_LOC then return end
    for _,ch in ipairs(PLANT_LOC:GetChildren()) do
        if ch:IsA("BasePart") then
            local a = getRectFromPart(ch)
            if a then table.insert(Areas, a) end
        end
    end
end

-- Rebuild areas otomatis kalau PLANT_LOC baru muncul (server streaming)
task.spawn(function()
    while true do
        if not PLANT_LOC or not PLANT_LOC.Parent then
            resolveFarmForLocal()
        end
        if #Areas == 0 and PLANT_LOC then
            rebuildAreas()
        end
        task.wait(2)
    end
end)

local grid, gi = {}, 1
local function rebuildGrid()
    grid, gi = {}, 1
    for _,A in ipairs(Areas) do
        for x=A.xMin, A.xMax, CFG.GridStep do
            for z=A.zMin, A.zMax, CFG.GridStep do
                table.insert(grid, Vector3.new(x, A.y, z))
            end
        end
    end
    gi = 1
end

local function nextPoint()
    if gi > #grid then gi = 1 end
    local p = grid[gi]; gi = gi + 1
    return p
end

local function isEggTool(x)
    if not x or not x:IsA("Tool") then return false end
    if x:GetAttribute("IsEgg")==true then return true end
    return string.find(string.lower(x.Name),"egg",1,true) ~= nil
end

local function listEggs()
    local t={}
    for _,c in ipairs(Backpack:GetChildren()) do
        if isEggTool(c) then table.insert(t,c) end
    end
    table.sort(t,function(a,b) return a.Name<b.Name end)
    return t
end

local SelectedEggTool = nil
local SelectedEggName = nil

local function resolveSelectedEgg()
    if SelectedEggTool and SelectedEggTool.Parent then return SelectedEggTool end
    if not SelectedEggName then return nil end
    for _,t in ipairs(listEggs()) do
        if t.Name == SelectedEggName then
            SelectedEggTool = t
            return t
        end
    end
    return nil
end

local function ensureEquipped(tool)
    if not tool then return false end
    if tool.Parent == Character then return true end
    local ok = pcall(function() Humanoid:EquipTool(tool) end)
    if not ok or tool.Parent ~= Character then tool.Parent = Character end
    RunService.Heartbeat:Wait()
    return tool.Parent == Character
end

local PlacedPoints = {}
local function tooClose(p)
    for _,q in ipairs(PlacedPoints) do
        local dx,dz = p.X-q.X, p.Z-q.Z
        if (dx*dx + dz*dz) < (CFG.MinEggGap*CFG.MinEggGap) then return true end
    end
    return false
end
local function remember(p) table.insert(PlacedPoints,p) end

local function placeAt(point)
    local tool = resolveSelectedEgg()
if not tool then
    return false, "Select egg"
end
if not ensureEquipped(tool) then
    return false, "Equip fail"
end
    if tooClose(point) then return false,"Too close" end
    local ok,err = pcall(function()
        PetEggService:FireServer("CreateEgg", vcreate(point.X, point.Y, point.Z))
    end)
    if not ok then return false, tostring(err) end
    remember(point)
    return true
end

-- Reset cache min-gap setiap ada egg BARU di farm kita saja
if OBJ_ROOT then
    OBJ_ROOT.DescendantAdded:Connect(function(d)
        if d:IsA("Model") and d.Name=="PetEgg" then PlacedPoints = {} end
    end)
end

--==============================
-- Auto Sell helpers (Team C)
--==============================
local function isPetTool(t)
    if not (t and t:IsA("Tool")) then return false end
    local it = t:GetAttribute("ItemType")
    if it and tostring(it):lower() == "pet" then return true end
    return not not t.Name:lower():match("%s*%[.-kg%]") -- fallback pola [x KG]
end

local function baseNameOf(toolName)
    return toolName:gsub("%s*%b[]", ""):gsub("%s+$","")
end

local function weightKgOf(toolName)
    local n = toolName:lower():match("%[(.-)%s*kg%]")
    if not n then return nil end
    n = n:gsub(",", ".")
    return tonumber(n)
end

local function isFavorite(tool)
    return tool:GetAttribute("d") == true
end

local function listBackpackPets()
    local out = {}
    for _,it in ipairs(Backpack:GetChildren()) do
        if isPetTool(it) then table.insert(out, it) end
    end
    table.sort(out, function(a,b) return a.Name < b.Name end)
    return out
end

local function ensureEquippedPet(tool)
    if tool.Parent == Character then return true end
    local ok = pcall(function() Humanoid:EquipTool(tool) end)
    if not ok or tool.Parent ~= Character then tool.Parent = Character end
    RunService.Heartbeat:Wait()
    return tool.Parent == Character
end

local function sellOne(tool)
    if not tool or not tool.Parent then return false,"tool missing" end
    if not ensureEquippedPet(tool) then return false,"equip fail" end
    local ok,err = pcall(function() SellPet_RE:FireServer(tool) end)
    if not ok then return false, tostring(err) end
    local t0=time()
    repeat
        if not tool.Parent then break end
        RunService.Heartbeat:Wait()
    until (time()-t0) > 2
    return true
end

local function sellAllMatchingOnce()
    local sold = 0
    for _,tool in ipairs(listBackpackPets()) do
        if not isFavorite(tool) then
            local bn = baseNameOf(tool.Name)
            local rule = AutoSellCFG.Rules and AutoSellCFG.Rules[bn]
            if rule and tonumber(rule.maxKg) then
                local kg = weightKgOf(tool.Name)
                if kg and kg < tonumber(rule.maxKg) then
                    local ok = select(1, sellOne(tool))
                    if ok then
                        sold += 1
                        setStatus(("Team C • Sold %s (%.2f KG)"):format(bn,kg))
                        task.wait(0.15)
                    end
                end
            end
        end
    end
    return sold
end

local function anyMatchRemaining()
    for _,tool in ipairs(listBackpackPets()) do
        if not isFavorite(tool) then
            local bn = baseNameOf(tool.Name)
            local rule = AutoSellCFG.Rules and AutoSellCFG.Rules[bn]
            if rule and tonumber(rule.maxKg) then
                local kg = weightKgOf(tool.Name)
                if kg and kg < tonumber(rule.maxKg) then
                    return true
                end
            end
        end
    end
    return false
end

--==============================
-- State Machine: A → B → C
--==============================
local MODE = "A"
local BDelayUntil = nil
local CDelayUntil = nil

task.spawn(function()
    task.wait(0.35)
    resolveFarmForLocal()
    rebuildAreas()
    rebuildGrid()

    -- Watchdog ringan
    task.spawn(function()
        while true do
            if (not PLANT_LOC) or (#Areas==0) then
                resolveFarmForLocal()
                rebuildAreas()
                rebuildGrid()
            end
            task.wait(2)
        end
    end)

    while true do
        if not CFG.Run then
            setStatus("Idle"); HATCH_ENABLE=false
        else
            if MODE=="A" then
                -- Team A: Place until max
                switchLoadout(CFG.TeamAIndex)

                -- Pastikan egg tool adaif not resolveSelectedEgg() then
    setStatus("Team A • Select an egg in Place tab")
    -- biarkan ga place sampai user pilih egg
end
                

                -- Pastikan grid siap
                if #grid == 0 then
                    rebuildAreas(); rebuildGrid()
                    if #grid == 0 then
                        setStatus("Team A • No Plant_Locations (your farm)")
                    end
                end

                if CFG.AutoPlace and CFG.MaxSlots>0 and #grid>0 and SelectedEggTool and OBJ_ROOT then
                    local cur = ourEggCount()
                    local tries=0
                    while cur < CFG.MaxSlots and tries < 18 do
                        local p = nextPoint()
                        if p and not tooClose(p) then
                            local ok = select(1, placeAt(p))
                            if ok then task.wait(0.15); cur = ourEggCount() end
                        end
                        tries += 1
                    end
                    local _,rdy,tot = allEggsReady()
                    setStatus(("Team A • areas=%d grid=%d eggs=%d • ready %d/%d")
                        :format(#Areas, #grid, (SelectedEggTool and 1 or 0), rdy, tot))
                else
                    local _,rdy,tot = allEggsReady()
                    setStatus(("Team A • waiting • ready %d/%d"):format(rdy, tot))
                end

                local allReady = select(1, allEggsReady())
                if allReady then
                    if switchLoadout(CFG.TeamBIndex) then
                        BDelayUntil = time() + (tonumber(CFG.SwitchDelayB) or 6)
                        HATCH_ENABLE = false
                        MODE = "B"
                    end
                end

            elseif MODE=="B" then
                -- Team B: Delay, then hatch
                switchLoadout(CFG.TeamBIndex)
                if BDelayUntil and time() < BDelayUntil then
                    local remain = math.max(0, math.floor(BDelayUntil - time()))
                    setStatus(("Team B • wait %ds before hatch"):format(remain))
                    HATCH_ENABLE = false
                else
                    HATCH_ENABLE = true
                    local r = countReadyEggs()
                    setStatus(("Team B • Hatching… Ready left: %d"):format(r))
                    if r == 0 then
                        HATCH_ENABLE = false
                        -- pindah ke Team C untuk jual
                        if switchLoadout(CFG.TeamCIndex) then
                            CDelayUntil = time() + (tonumber(CFG.SwitchDelayC) or 6)
                            MODE = "C"
                            setStatus("Team C • preparing to sell…")
                        end
                    end
                end

            else -- MODE == "C"
                -- Team C: Delay, lalu sell semua yang match rules < maxKg
                switchLoadout(CFG.TeamCIndex)
                if CDelayUntil and time() < CDelayUntil then
                    local remain = math.max(0, math.floor(CDelayUntil - time()))
                    setStatus(("Team C • wait %ds before sell"):format(remain))
                else
                    local sold = sellAllMatchingOnce()
                    if sold == 0 and not anyMatchRemaining() then
                        -- selesai jual → balik ke Team A
                        if switchLoadout(CFG.TeamAIndex) then
                            MODE, BDelayUntil, CDelayUntil = "A", nil, nil
                            setStatus("Done selling → Team A")
                        end
                    else
                        task.wait(0.25)
                    end
                end
            end
        end
        task.wait(0.25)
    end
end)

--==============================
-- WindUI: Window + Tabs + Controls (including Auto Sell UI)
--==============================
local Window = WindUI:CreateWindow({
    Title = "Auto Unlimited Eggs + Sell",
    Icon  = "egg",
    Author = "bro-bro squad",
    Folder = "AutoUE",
    Size = UDim2.fromOffset(250, 250),
    Theme = "Dark",
    SideBarWidth = 200,
})

local S = {
    Main     = Window:Section({ Title = "Main", Opened = true }),
    Teams    = Window:Section({ Title = "Teams", Opened = true }),
    Place    = Window:Section({ Title = "Place", Opened = false }),
    Hatch    = Window:Section({ Title = "Hatch", Opened = false }),
    Sell     = Window:Section({ Title = "Auto Sell Pet", Opened = true }),
}

local T = {
    Dashboard = S.Main:Tab({ Title = "Dashboard", Icon = "layout-dashboard" }),
    TeamTab   = S.Teams:Tab({ Title = "Teams", Icon = "users" }),
    PlaceTab  = S.Place:Tab({ Title = "Place Eggs", Icon = "circle-plus" }),
    HatchTab  = S.Hatch:Tab({ Title = "Hatch", Icon = "sparkles" }),
    SellFlow  = S.Sell:Tab({ Title = "Sell Flow", Icon = "hand-coins" }),
    SellRules = S.Sell:Tab({ Title = "Sell Rules", Icon = "settings" }),
}

-- Dashboard
local StatusLbl = T.Dashboard:Paragraph({
    Title = "Status", Desc = "Starting…", Image = "activity", ImageSize = 18, Color = "White"
})
task.spawn(function()
    while Window do
        StatusLbl:SetDesc(Status)
        task.wait(0.2)
    end
end)

local RunToggle = T.Dashboard:Toggle({
    Title = "Run Auto Unlimited Eggs + Sell", Value = CFG.Run,
    Callback = function(v) CFG.Run = v; setStatus(v and "Running…" or "Stopped") end
})

T.Dashboard:Paragraph({
    Title = "Flow",
    Desc = "Team A: place eggs → semua ready → Team B: delay lalu hatch → Team C: delay lalu auto sell (skip favorit) → balik Team A.",
    Image = "info", ImageSize=18, Color="White"
})

-- Teams
T.TeamTab:Input({
    Title = "Team A Index (1-3)", Value = tostring(CFG.TeamAIndex),
    Callback = function(v) local n=tonumber(v); if n then CFG.TeamAIndex = math.clamp(math.floor(n),1,3) end end
})
T.TeamTab:Input({
    Title = "Team B Index (1-3)", Value = tostring(CFG.TeamBIndex),
    Callback = function(v) local n=tonumber(v); if n then CFG.TeamBIndex = math.clamp(math.floor(n),1,3) end end
})
T.TeamTab:Input({
    Title = "Team C Index (1-3)", Value = tostring(CFG.TeamCIndex),
    Callback = function(v) local n=tonumber(v); if n then CFG.TeamCIndex = math.clamp(math.floor(n),1,3) end end
})
T.TeamTab:Slider({
    Title = "Delay mulai hatch (Team B, detik)",
    Value = {Min=5, Max=7, Default=CFG.SwitchDelayB},
    Step = 0.5,
    Callback = function(val) CFG.SwitchDelayB = tonumber(val) or CFG.SwitchDelayB end
})
T.TeamTab:Slider({
    Title = "Delay mulai sell (Team C, detik)",
    Value = {Min=5, Max=7, Default=CFG.SwitchDelayC},
    Step = 0.5,
    Callback = function(val) CFG.SwitchDelayC = tonumber(val) or CFG.SwitchDelayC end
})

-- Place settings
T.PlaceTab:Input({
    Title = "Max Slots (manual)", Value = tostring(CFG.MaxSlots),
    Callback = function(v) local n=tonumber(v); if n then CFG.MaxSlots = math.max(0, math.floor(n)) end end
})
T.PlaceTab:Slider({
    Title = "Min Egg Gap", Value = {Min=1, Max=6, Default=CFG.MinEggGap}, Step = 0.5,
    Callback = function(val) CFG.MinEggGap = tonumber(val) or CFG.MinEggGap end
})
T.PlaceTab:Slider({
    Title = "Grid Step", Value = {Min=0.5, Max=2.0, Default=CFG.GridStep}, Step = 0.1,
    Callback = function(val) CFG.GridStep = tonumber(val) or CFG.GridStep; rebuildGrid() end
})

-- Pilihan egg tool
local EggDropdown
local function listEggsNames()
    local names={}
    for _,t in ipairs(listEggs()) do table.insert(names,t.Name) end
    return (#names>0) and names or {"(No egg tool)"}
end
local function refreshEggDropdown()
    local names = listEggsNames()
    if EggDropdown then EggDropdown:Destroy() end
    EggDropdown = T.PlaceTab:Dropdown({
        Title = "Egg Tool", Values = names, Value = names[1],
        Callback = function(name)
    for _,t in ipairs(listEggs()) do
        if t.Name == name then
            SelectedEggTool = t
            SelectedEggName = name
            break
        end
    end
end
        
    })
    local first = listEggs()[1]
if first then
    SelectedEggTool = first
    SelectedEggName = first.Name
end
refreshEggDropdown()
T.PlaceTab:Button({ Title="Refresh Egg List", Icon="refresh-ccw", Callback = refreshEggDropdown })

-- Hatch settings
T.HatchTab:Toggle({
    Title = "Owner Filter (hanya egg kita)", Value = CFG.OwnerFilter,
    Callback = function(v) CFG.OwnerFilter = v end
})
T.HatchTab:Slider({
    Title = "Cooldown antar hatch (detik)",
    Value = {Min=0.5, Max=3, Default=CFG.HatchCooldown}, Step = 0.1,
    Callback = function(v) CFG.HatchCooldown = tonumber(v) or CFG.HatchCooldown end
})

-- ==========================
-- SELL FLOW (info ringkas)
-- ==========================
T.SellFlow:Paragraph({
    Title = "Cara Kerja Sell",
    Desc  = "Masuk Team C → tunggu delay → jual semua pet yang base name-nya ada di rules & berat < Max KG. Favorit (attr 'd') di-skip otomatis.",
    Image = "info", ImageSize = 18, Color = "White"
})

-- ==========================
-- SELL RULES UI (from Registry)
-- ==========================
local PetDropdown, MaxKgInput, RulesList

local function rulesAsText()
    local lines = {}
    for name, r in pairs(AutoSellCFG.Rules) do
        table.insert(lines, ("• %s  < %.2f KG"):format(name, r.maxKg))
    end
    table.sort(lines)
    return (#lines>0) and table.concat(lines, "\n") or "(no rules)"
end

local function refreshRulesList()
    if RulesList then
        RulesList:SetDesc(rulesAsText())
    else
        RulesList = T.SellRules:Paragraph({
            Title = "Active Rules",
            Desc  = rulesAsText(),
            Image = "list",
            ImageSize = 18,
            Color = "White"
        })
    end
end

local function getRegistryPetNames()
    local names = {}
    local function push(n)
        if typeof(n) == "string" and n ~= "" then names[#names+1] = n end
    end
    local Data = RS:FindFirstChild("Data")
    local Reg  = Data and Data:FindFirstChild("PetRegistry")
    local PetList = Reg and Reg:FindFirstChild("PetList")
    if PetList then
        if PetList:IsA("ModuleScript") then
            local ok, tbl = pcall(require, PetList)
            if ok and tbl then
                if #tbl > 0 then for _,v in ipairs(tbl) do push(v) end
                else for k,_ in pairs(tbl) do push(k) end end
            end
        elseif PetList:IsA("Folder") then
            for _,ch in ipairs(PetList:GetChildren()) do push(ch.Name) end
        elseif PetList:IsA("StringValue") then
            local s = PetList.Value or ""
            for token in string.gmatch(s, "([^,%s]+)") do push(token) end
        else
            for _,ch in ipairs(PetList:GetChildren()) do push(ch.Name) end
        end
    end
    table.sort(names)
    return names
end

local function refreshPetDropdown()
    local values = getRegistryPetNames()
    if #values == 0 then values = {"(No pet in registry)"} end
    if PetDropdown then PetDropdown:Destroy() end
    PetDropdown = T.SellRules:Dropdown({
        Title = "Choose Pet (from Registry)",
        Values = values,
        Value  = values[1],
        Callback = function(_) end
    })
end

refreshPetDropdown()

MaxKgInput = T.SellRules:Input({
    Title = "Max Weight (KG) — sell if below",
    Placeholder = "e.g. 3",
    Callback = function(_) end
})

T.SellRules:Button({
    Title = "Add / Update Rule",
    Icon  = "plus",
    Callback = function()
        local name = PetDropdown and PetDropdown.Value
        if not name or name == "(No pet in registry)" then
            setStatus("No pet selected")
            return
        end
        local kg = tonumber(MaxKgInput.Value or MaxKgInput.Text or MaxKgInput)
        if not kg then
            setStatus("Invalid KG")
            return
        end
        AutoSellCFG.Rules[name] = { maxKg = kg }
        setStatus(("Rule set: %s < %.2f KG"):format(name, kg))
        refreshRulesList()
    end
})

T.SellRules:Button({
    Title = "Remove Selected Rule",
    Icon  = "trash-2",
    Callback = function()
        local name = PetDropdown and PetDropdown.Value
        if name and AutoSellCFG.Rules[name] then
            AutoSellCFG.Rules[name] = nil
            setStatus(("Rule removed: %s"):format(name))
            refreshRulesList()
        end
    end
})

T.SellRules:Button({
    Title = "Refresh Registry List",
    Icon  = "refresh-ccw",
    Callback = function() refreshPetDropdown() end
})

refreshRulesList()

print(("[AutoUE+Sell+UI] Ready • Teams A/B/C = %d/%d/%d • DelayB=%.1f • DelayC=%.1f")
    :format(CFG.TeamAIndex, CFG.TeamBIndex, CFG.TeamCIndex, CFG.SwitchDelayB, CFG.SwitchDelayC))