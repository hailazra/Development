--========================================================
-- Auto Collect Fruit (No GUI) — v1b (patch path + lists)
--========================================================

local G  = getgenv()
local RG = (G.RemnantGlobals or {})
local Players    = RG.Players    or game:GetService("Players")
local RS         = RG.RS         or game:GetService("ReplicatedStorage")
local RunService = RG.RunService or game:GetService("RunService")
local Workspace  = RG.Workspace  or game:GetService("Workspace")
local LP         = RG.LP or Players.LocalPlayer

-- Single-instance guard
if G.FruitCollector and G.FruitCollector.Kill then G.FruitCollector.Kill() end

--================
-- Config (same)
--================
local CFG = rawget(G, "FruitCollectCFG") or {}
CFG.Run               = (CFG.Run               ~= nil) and CFG.Run               or false
CFG.ScanInterval      = tonumber(CFG.ScanInterval)      or 0.10
CFG.RateLimitPerFruit = tonumber(CFG.RateLimitPerFruit) or 1.25
CFG.MaxConcurrent     = tonumber(CFG.MaxConcurrent)     or 3
CFG.UseOwnerFilter    = (CFG.UseOwnerFilter ~= nil) and CFG.UseOwnerFilter or true
CFG.SelectedFruits    = CFG.SelectedFruits or {}
CFG.WeightMin         = tonumber(CFG.WeightMin) or 0.0
CFG.WeightMax         = (CFG.WeightMax ~= nil) and tonumber(CFG.WeightMax) or math.huge
CFG.MutationWhitelist = CFG.MutationWhitelist or {}
CFG.MutationBlacklist = CFG.MutationBlacklist or {}
CFG.Debug             = (CFG.Debug ~= nil) and CFG.Debug or true
CFG.PromptHoldSeconds = CFG.PromptHoldSeconds -- optional

local function dprint(...) if CFG.Debug then print("[FruitAuto]", ...) end end

--========================
-- Lists for GUI dropdown
--========================
local Lists = { FruitNames = {}, Mutations = {} }

-- Small utils
local function uniq_sorted(arr)
    local u,t={},{}
    for _,v in ipairs(arr) do if v and v~="" then u[v]=true end end
    for k in pairs(u) do t[#t+1]=k end
    table.sort(t); return t
end

-- Try to build Fruit list from RS.Data.SeedData (Folder or ModuleScript)
local function buildFruitList()
    local Data = RS:FindFirstChild("Data")
    local seed = Data and Data:FindFirstChild("SeedData")
    local out  = {}

    if seed then
        if seed:IsA("Folder") then
            for _,ch in ipairs(seed:GetChildren()) do out[#out+1]=ch.Name end
        elseif seed:IsA("ModuleScript") then
            local ok, tbl = pcall(require, seed)
            if ok and type(tbl)=="table" then
                -- ambil keys utama (nama buah)
                for k,_ in pairs(tbl) do out[#out+1]=tostring(k) end
            end
        end
    end

    if #out==0 then
        dprint("WARN: SeedData tidak terbaca (Folder/ModuleScript). Dropdown buah bisa kosong sementara.")
    else
        dprint("SeedData ->", #out, "items")
    end
    Lists.FruitNames = uniq_sorted(out)
end

-- Try to build mutation list from RS.Modules.MutationHandler (Folder/ModuleScript)
local function buildMutationList()
    local Mods = RS:FindFirstChild("Modules")
    local mh   = Mods and Mods:FindFirstChild("MutationHandler")
    local out  = {}

    if mh then
        if mh:IsA("Folder") then
            for _,ch in ipairs(mh:GetChildren()) do out[#out+1] = ch.Name end
        elseif mh:IsA("ModuleScript") then
            local ok, tbl = pcall(require, mh)
            if ok and type(tbl)=="table" then
                for k,_ in pairs(tbl) do out[#out+1]=tostring(k) end
            end
        end
        -- attributes on the module (rare, but try)
        for _,an in ipairs(mh:GetAttributes()) do out[#out+1]=an end
    end

    if #out==0 then
        dprint("INFO: MutationHandler belum kebaca; akan di-augment saat scanning dari Attributes buah.")
    else
        dprint("MutationHandler ->", #out, "items")
    end
    Lists.Mutations = uniq_sorted(out)
end

buildFruitList()
buildMutationList()

--==================================
-- Pathing: find PlantsPhysical root
--==================================
-- PRIORITAS:
-- 1) RG.Paths.PlantsPhysicalRoot (instance langsung dari GUI kamu)
-- 2) Hard path umum: Workspace.Farm.Farm.Important.PlantsPhysical
-- 3) Hard path varian: Workspace.Farm.Important.PlantsPhysical
-- 4) Hard path lain (mirip place egg kadang pakai "Objects_Physical"): Workspace.Farm.Farm.Important.PlantsPhysical
-- 5) Deep search by name "PlantsPhysical" yang punya child "Fruits" di bawah Model pohon
local function path_chain(root, names)
    local n = root
    for _,nm in ipairs(names) do
        n = n and n:FindFirstChild(nm) or nil
    end
    return n
end

local function deep_find_plantsphysical()
    -- Cari Folder bernama "PlantsPhysical" yang di bawahnya ada children yang punya Folder "Fruits"
    local cand = {}
    for _,desc in ipairs(Workspace:GetDescendants()) do
        if desc.Name=="PlantsPhysical" and desc:IsA("Folder") then
            table.insert(cand, desc)
        end
    end
    for _,pf in ipairs(cand) do
        for _,tree in ipairs(pf:GetChildren()) do
            if tree:FindFirstChild("Fruits") then
                return pf
            end
        end
    end
    return nil
end

local function getPlantsRoot()
    -- 1) from RemnantGlobals
    if RG.Paths and RG.Paths.PlantsPhysicalRoot and typeof(RG.Paths.PlantsPhysicalRoot)=="Instance" then
        return RG.Paths.PlantsPhysicalRoot
    end

    -- 2) Common strict path
    local p1 = path_chain(Workspace, {"Farm","Farm","Important","PlantsPhysical"})
    if p1 then return p1 end

    -- 3) Variant
    local p2 = path_chain(Workspace, {"Farm","Important","PlantsPhysical"})
    if p2 then return p2 end

    -- 4) (jaga2 typo “Worpkspace” di input user) — autonorm sudah pakai Workspace

    -- 5) Deep search
    local p3 = deep_find_plantsphysical()
    if p3 then return p3 end

    -- no root
    return nil
end

--=====================
-- Fruit info helpers
--=====================
local function findEnabledPrompt(fruitModel)
    local best
    for _,desc in ipairs(fruitModel:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            if desc.Enabled then return desc else best = best or desc end
        end
    end
    return best
end

local function getFruitWeight(fruitModel)
    local w = fruitModel:FindFirstChild("Weight")
    if w and w.Value then
        local num = tonumber(w.Value)
        if num then return num end
    end
    return nil
end

-- Keep growing mutation list dynamically from fruit attributes encountered
local function augmentMutationListFromFruit(fruitModel)
    local found = {}
    for _,attrName in ipairs(fruitModel:GetAttributes()) do
        local val = fruitModel:GetAttribute(attrName)
        if val == true then found[#found+1] = attrName end
    end
    if #found>0 then
        local all = {}
        for _,v in ipairs(Lists.Mutations) do all[#all+1]=v end
        for _,v in ipairs(found) do all[#all+1]=v end
        Lists.Mutations = uniq_sorted(all)
    end
end

local function hasMutationAllowed(fruitModel)
    local wl, bl = CFG.MutationWhitelist, CFG.MutationBlacklist
    local hasWL  = (#wl>0)

    local function hasTrue(name)
        local ok, val = pcall(function() return fruitModel:GetAttribute(name) end)
        return ok and (val == true)
    end

    if hasWL then
        local pass = false
        for _,m in ipairs(wl) do if hasTrue(m) then pass=true break end end
        if not pass then return false, "no_whitelist_mutation" end
    end
    for _,m in ipairs(bl) do if hasTrue(m) then return false, "blacklisted:"..m end end

    return true
end

local function isFruitNameSelected(fruitModel)
    if #CFG.SelectedFruits==0 then return true end
    local name = fruitModel.Name
    for _,sel in ipairs(CFG.SelectedFruits) do if sel==name then return true end end
    return false
end

local function isOwnedByLocal(fruitModel)
    if not CFG.UseOwnerFilter then return true end

    local tree = fruitModel
    if tree and tree.Parent and tree.Parent.Name=="Fruits" then
        tree = tree.Parent.Parent
    end

    local candidates = {fruitModel, tree}
    for _,inst in ipairs(candidates) do
        if inst then
            local ownerName = inst:GetAttribute("OwnerName")
            if ownerName and tostring(ownerName)==LP.Name then return true end
            local ownerId = inst:GetAttribute("OwnerUserId")
            if ownerId and tonumber(ownerId)==LP.UserId then return true end
        end
    end

    -- kamu bilang seluruh area farm = punya local → OK
    return true
end

--========================
-- Action: collect prompt
--========================
local hasFirePrompt = (type(G.fireproximityprompt)=="function" and G.fireproximityprompt)
                   or (typeof(fireproximityprompt)=="function" and fireproximityprompt)

local Active = { LastTryAt = {}, InFlight=0, Stopped=false, ConnStop=nil }

local function inventoryIsFull()
    local invAPI = RG.InventoryAPI
    if invAPI and typeof(invAPI)=="table" and typeof(invAPI.IsFruitFull)=="function" then
        local ok, full = pcall(invAPI.IsFruitFull)
        if ok and full==true then return true end
    end
    return false
end

local function canTryFruit(f)
    local last = Active.LastTryAt[f]
    return not (last and (os.clock()-last) < CFG.RateLimitPerFruit)
end

local function tryCollectFruit(fruitModel, prompt)
    if Active.Stopped then return end
    if Active.InFlight >= CFG.MaxConcurrent then return end
    Active.LastTryAt[fruitModel] = os.clock()

    -- Weight
    local weight = getFruitWeight(fruitModel)
    if not weight then dprint("Skip(no weight)", fruitModel:GetFullName()); return end
    if weight < CFG.WeightMin or weight > CFG.WeightMax then
        dprint(("Skip(weight %.3f out of %.3f..%.3f)"):format(weight, CFG.WeightMin, CFG.WeightMax)); return
    end

    -- Mutations
    augmentMutationListFromFruit(fruitModel)
    local okMut, why = hasMutationAllowed(fruitModel)
    if not okMut then dprint("Skip(mut)", why or ""); return end

    -- Name
    if not isFruitNameSelected(fruitModel) then dprint("Skip(name)", fruitModel.Name); return end

    -- Owner
    if not isOwnedByLocal(fruitModel) then dprint("Skip(owner)"); return end

    if not (prompt and prompt.Enabled) then dprint("Skip(prompt off)"); return end

    if inventoryIsFull() then
        dprint("Inventory FULL → stop.")
        Active.Stopped = true
        return
    end

    if not hasFirePrompt then
        dprint("WARN: fireproximityprompt unavailable (no teleport mode).")
        return
    end

    Active.InFlight += 1
    task.defer(function()
        local ok,err = pcall(function()
            local hold = (CFG.PromptHoldSeconds and CFG.PromptHoldSeconds>0) and CFG.PromptHoldSeconds
                      or (prompt.HoldDuration and prompt.HoldDuration>0 and prompt.HoldDuration) or 0.1
            dprint(("Collect %s (w=%.3f, hold=%.2fs)"):format(fruitModel.Name, weight, hold))
            hasFirePrompt(prompt, hold)
        end)
        if not ok then dprint("ERROR collect:", tostring(err)) end
        Active.InFlight -= 1
    end)
end

--================
-- Scanning loop
--================
local function scanOnce()
    if Active.Stopped or not CFG.Run then return end

    local root = getPlantsRoot()
    if not root then
        dprint("PlantsPhysical root not found. Coba set RG.Paths.PlantsPhysicalRoot atau cek path sesuai place-egg.")
        -- hint debug: list kandidat "PlantsPhysical" ditemukan di workspace
        local hits={}
        for _,d in ipairs(Workspace:GetDescendants()) do
            if d.Name=="PlantsPhysical" then hits[#hits+1]=d:GetFullName() end
            if #hits>=5 then break end
        end
        if #hits>0 then dprint("Candidates:", table.concat(hits," | ")) end
        return
    end

    local batch=0
    for _,tree in ipairs(root:GetChildren()) do
        local fruitsFolder = tree:FindFirstChild("Fruits")
        if fruitsFolder then
            for _,fruit in ipairs(fruitsFolder:GetChildren()) do
                if Active.Stopped then return end
                if not fruit:IsA("Model") then continue end
                local prompt = findEnabledPrompt(fruit)
                if prompt and prompt.Enabled and canTryFruit(fruit) then
                    tryCollectFruit(fruit, prompt)
                    batch += 1
                    if batch >= (CFG.MaxConcurrent*2) then task.wait(0.02); batch=0 end
                end
            end
        end
    end
end

local Loop
local function start()
    if Loop then return end
    Active.Stopped=false
    dprint("Auto Collect Fruit START @", CFG.ScanInterval, "s")

    Loop = task.spawn(function()
        while not Active.Stopped do
            local t0=os.clock()
            local ok,err=pcall(scanOnce)
            if not ok then dprint("ERROR scanOnce:", tostring(err)) end
            local sl = math.max(0.01, (CFG.ScanInterval or 0.1) - (os.clock()-t0))
            task.wait(sl)
        end
        dprint("Loop stopped.")
    end)
end

local function stop()
    Active.Stopped=true
end

local function kill()
    stop()
    if Active.ConnStop then Active.ConnStop:Disconnect(); Active.ConnStop=nil end
    Loop=nil
    G.FruitCollector=nil
    dprint("KILLED.")
end

-- Hook Stop-on-GUI-close
do
    local ui = rawget(G,"RemnantUI")
    local stopEvent = (ui and ui.StopAllEvent) or RG.StopAllBindable
    if stopEvent and stopEvent.Connect then
        Active.ConnStop = stopEvent:Connect(function() dprint("StopAllEvent"); stop() end)
    end
end

-- Export
G.FruitCollector = {
    Start = start, Stop = stop, Kill = kill, Lists = Lists,
    RefreshLists = function() buildFruitList(); buildMutationList(); dprint("Lists refreshed.") end
}

-- Autostart?
if CFG.Run then start() else dprint("Loaded. CFG.Run=false") end
