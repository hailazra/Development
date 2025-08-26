--========================================================
-- Auto Collect Fruit (No GUI) — v1 MENTAHAN
-- Dependensi:
--   getgenv().RemnantGlobals  (sudah kamu siapkan di RemnantUIv2_Updated)
--   Optional: getgenv().RemnantUI (untuk Stop-on-GUI-close via BindableEvent)
--
-- Cara pakai singkat:
--   getgenv().FruitCollectCFG = {
--     Run               = true,
--     ScanInterval      = 0.10,    -- detik
--     RateLimitPerFruit = 1.25,    -- detik cooldown per instance buah
--     MaxConcurrent     = 3,       -- batasi jumlah collect simultan
--     UseOwnerFilter    = true,    -- hanya milik LocalPlayer
--     SelectedFruits    = {"Apple","Orange"},  -- nama dari SeedData
--     WeightMin         = 0.0,     -- kg
--     WeightMax         = math.huge,
--     MutationWhitelist = {},      -- contoh: {"Windstruck","Giant"}
--     MutationBlacklist = {},      -- contoh: {"Rotten"}
--     Debug             = true,
--   }
--   loadstring(game:HttpGet("RAW_URL/AutoCollectFruit_v1.lua"))()
--
-- Matikan & bersihkan:
--   if getgenv().FruitCollector and getgenv().FruitCollector.Kill then getgenv().FruitCollector.Kill() end
--========================================================

-- ==========
-- Safeties
-- ==========
local G = getgenv()
local RG = (G.RemnantGlobals or {}) -- diisi dari GUI kamu
local Players    = RG.Players    or game:GetService("Players")
local RS         = RG.RS         or game:GetService("ReplicatedStorage")
local RunService = RG.RunService or game:GetService("RunService")
local Workspace  = RG.Workspace  or game:GetService("Workspace")

local LP = RG.LP or Players.LocalPlayer

-- Single instance guard
if G.FruitCollector and G.FruitCollector.Kill then
    G.FruitCollector.Kill()
end

-- ==========
-- Config
-- ==========
local CFG = rawget(G, "FruitCollectCFG") or {}
CFG.Run               = (CFG.Run               ~= nil) and CFG.Run               or false
CFG.ScanInterval      = tonumber(CFG.ScanInterval)      or 0.10
CFG.RateLimitPerFruit = tonumber(CFG.RateLimitPerFruit) or 1.25
CFG.MaxConcurrent     = tonumber(CFG.MaxConcurrent)     or 3
CFG.UseOwnerFilter    = (CFG.UseOwnerFilter ~= nil) and CFG.UseOwnerFilter or true
CFG.SelectedFruits    = CFG.SelectedFruits or {}              -- array of string (nama buah)
CFG.WeightMin         = tonumber(CFG.WeightMin) or 0.0
CFG.WeightMax         = (CFG.WeightMax ~= nil) and tonumber(CFG.WeightMax) or math.huge
CFG.MutationWhitelist = CFG.MutationWhitelist or {}           -- array of string (nama attribute = true)
CFG.MutationBlacklist = CFG.MutationBlacklist or {}
CFG.Debug             = (CFG.Debug ~= nil) and CFG.Debug or true

-- helper debug
local function dprint(...)
    if CFG.Debug then
        print("[FruitAuto]", ...)
    end
end

-- =================================
-- Discovery helpers (dropdown data)
-- =================================
local Lists = {
    FruitNames   = {}, -- diambil dari RS.Data.SeedData
    Mutations    = {}, -- diambil dari RS.Modules.MutationHandler
}

local function buildFruitList()
    -- Struktur diasumsikan: ReplicatedStorage.Data.SeedData
    local ok, seedData = pcall(function()
        local Data = RS:FindFirstChild("Data")
        return Data and Data:FindFirstChild("SeedData")
    end)
    if ok and seedData then
        local set = {}
        for _, itm in ipairs(seedData:GetChildren()) do
            set[itm.Name] = true
        end
        local arr = {}
        for name in pairs(set) do arr[#arr+1] = name end
        table.sort(arr)
        Lists.FruitNames = arr
        dprint("SeedData -> Fruit list found:", #arr, "items")
    else
        dprint("WARN: RS.Data.SeedData tidak ditemukan.")
    end
end

local function buildMutationList()
    -- Struktur diasumsikan: ReplicatedStorage.Modules.MutationHandler
    local ok, mut = pcall(function()
        local Mods = RS:FindFirstChild("Modules")
        return Mods and Mods:FindFirstChild("MutationHandler")
    end)
    if ok and mut then
        -- Banyak game menaruh table di ModuleScript ini.
        -- Kita tidak require module (sering obfuscated), tapi minimal kumpulkan child/attributes jika ada.
        local names = {}
        -- Coba dari attributes (kalau ada)
        for _, attrib in ipairs(mut:GetAttributes()) do
            names[#names+1] = attrib
        end
        -- Coba dari anak-anak
        for _, ch in ipairs(mut:GetChildren()) do
            names[#names+1] = ch.Name
        end
        -- Unique + sort
        local uniq = {}
        for _, n in ipairs(names) do uniq[n] = true end
        local arr = {}
        for n in pairs(uniq) do arr[#arr+1] = n end
        table.sort(arr)
        Lists.Mutations = arr
        dprint("MutationHandler -> Mutation list approx:", #arr, "items")
    else
        dprint("WARN: RS.Modules.MutationHandler tidak ditemukan.")
    end
end

buildFruitList()
buildMutationList()

-- =========================
-- Selectors & path helpers
-- =========================
local PlantsRootPath = {"Farm","Farm","Important","PlantsPhysical"}
local function getPlantsRoot()
    -- Workspace.Farm.Farm.Important.PlantsPhysical
    local node = Workspace
    for _, name in ipairs(PlantsRootPath) do
        node = node:FindFirstChild(name)
        if not node then return nil end
    end
    return node
end

local function isNumberedFolder(inst)
    -- Sesuai info: buah memiliki child bernama "1" yang berisi ProximityPrompt
    -- Kita tidak bergantung penuh, tapi ini membantu.
    if not inst then return false end
    return tonumber(inst.Name) ~= nil
end

local function findEnabledPrompt(fruitModel)
    -- Cari ProximityPrompt pada descendant, prefer yang Enabled = true
    if not fruitModel then return nil end
    local best = nil
    for _, desc in ipairs(fruitModel:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            if desc.Enabled then
                best = desc
                break
            else
                best = best or desc
            end
        end
    end
    return best
end

local function getFruitWeight(fruitModel)
    -- Path: ...Fruits.[Buah].Weight (NumberValue / ValueBase)
    local w = fruitModel:FindFirstChild("Weight")
    if w and w.Value then
        local num = tonumber(w.Value)
        if num then return num end
    end
    return nil
end

local function hasMutationAllowed(fruitModel)
    -- Mutasi ada di Attributes model buah: e.g. Windstruck = true
    -- Filter:
    --  - Whitelist (jika tidak kosong) -> harus match salah satu
    --  - Blacklist -> tidak boleh ada yg match
    local hasAnyWhitelist = (#CFG.MutationWhitelist > 0)

    local function hasAttrTrue(name)
        local ok, val = pcall(function() return fruitModel:GetAttribute(name) end)
        return ok and (val == true)
    end

    if hasAnyWhitelist then
        local okWL = false
        for _, m in ipairs(CFG.MutationWhitelist) do
            if hasAttrTrue(m) then okWL = true; break end
        end
        if not okWL then
            return false, "no_whitelist_mutation"
        end
    end

    for _, m in ipairs(CFG.MutationBlacklist) do
        if hasAttrTrue(m) then
            return false, "blacklisted_mutation:"..m
        end
    end

    return true
end

local function isFruitNameSelected(fruitModel)
    -- Nama buah diambil dari model name pada folder Fruits, atau meta lain jika ada.
    -- Kita gunakan fruitModel.Name dan cocokin dengan SelectedFruits (exact match).
    if #CFG.SelectedFruits == 0 then return true end -- kalau kosong, artinya ambil semua
    local name = fruitModel.Name
    for _, sel in ipairs(CFG.SelectedFruits) do
        if sel == name then
            return true
        end
    end
    return false
end

-- ==============
-- Owner filters
-- ==============
local function isOwnedByLocal(fruitModel)
    if not CFG.UseOwnerFilter then return true end

    -- Heuristik 1: Attribute OwnerName / OwnerUserId pada Tree/Fruit
    local container = fruitModel
    -- naik sampai pohon
    local tree = fruitModel:FindFirstAncestorWhichIsA("Model")
    if tree and tree.Parent and tree.Parent.Name == "Fruits" then
        tree = tree.Parent.Parent  -- [Tree]/Fruits/[Buah] -> [Tree]
    end

    local candidates = {fruitModel, tree}
    for _, inst in ipairs(candidates) do
        if inst then
            local ownerName = inst:GetAttribute("OwnerName")
            if ownerName and tostring(ownerName) == LP.Name then return true end

            local ownerId = inst:GetAttribute("OwnerUserId")
            if ownerId and tonumber(ownerId) == LP.UserId then return true end
        end
    end

    -- Heuristik 2: Farm kamu 1 map tersendiri ⇒ izinkan
    -- (Kamu bilang seluruh area farm = milik LocalPlayer, maka return true)
    return true
end

-- ==================
-- Collecting action
-- ==================
local hasFirePrompt = (type(getgenv().fireproximityprompt) == "function") and getgenv().fireproximityprompt
                     or (typeof(fireproximityprompt) == "function" and fireproximityprompt)
local Active = {
    LastTryAt = {}, -- [fruitModel] = os.clock() timestamp
    InFlight  = 0,
    Stopped   = false,
    ConnStop  = nil,
}

local function inventoryIsFull()
    -- Optional hook kalau kamu punya API sendiri:
    -- return getgenv().RemnantGlobals.InventoryAPI.IsFruitFull()
    local invAPI = RG.InventoryAPI
    if invAPI and typeof(invAPI) == "table" and typeof(invAPI.IsFruitFull) == "function" then
        local ok, full = pcall(invAPI.IsFruitFull)
        if ok and full == true then return true end
    end
    return false
end

local function canTryFruit(fruit)
    local last = Active.LastTryAt[fruit]
    if last and (os.clock() - last) < CFG.RateLimitPerFruit then
        return false
    end
    return true
end

local function tryCollectFruit(fruitModel, prompt)
    if Active.Stopped then return end
    if Active.InFlight >= CFG.MaxConcurrent then return end
    Active.LastTryAt[fruitModel] = os.clock()

    -- Weight check
    local weight = getFruitWeight(fruitModel)
    if weight == nil then
        dprint("Skip (no weight)", fruitModel:GetFullName())
        return
    end
    if weight < CFG.WeightMin or weight > CFG.WeightMax then
        dprint(("Skip (weight %.3f out of range %.3f..%.3f)"):format(weight, CFG.WeightMin, CFG.WeightMax))
        return
    end

    -- Mutation filter
    local okMut, reasonMut = hasMutationAllowed(fruitModel)
    if not okMut then
        dprint("Skip (mutation filter):", reasonMut or "no_reason")
        return
    end

    -- Selected name
    if not isFruitNameSelected(fruitModel) then
        dprint("Skip (not in SelectedFruits):", fruitModel.Name)
        return
    end

    -- Owner filter
    if not isOwnedByLocal(fruitModel) then
        dprint("Skip (not owned by local):", fruitModel:GetFullName())
        return
    end

    -- Prompt must be Enabled
    if not (prompt and prompt.Enabled) then
        dprint("Skip (prompt not enabled):", fruitModel.Name)
        return
    end

    -- Inventory full?
    if inventoryIsFull() then
        dprint("Inventory FULL detected. Stopping Auto Collect.")
        Active.Stopped = true
        return
    end

    -- Collect using fireproximityprompt (no teleport)
    if not hasFirePrompt then
        dprint("WARN: 'fireproximityprompt' tidak tersedia. Tidak bisa collect dari jauh.")
        return
    end

    Active.InFlight += 1
    task.defer(function()
        local ok, err = pcall(function()
            local holdSeconds = (prompt.HoldDuration ~= nil and prompt.HoldDuration > 0)
                                and prompt.HoldDuration or 0.1
            -- override hold pakai CFG jika mau
            if CFG.PromptHoldSeconds and CFG.PromptHoldSeconds > 0 then
                holdSeconds = CFG.PromptHoldSeconds
            end

            dprint(("Collect %s (weight=%.3f, hold=%.2fs)"):format(fruitModel.Name, weight, holdSeconds))
            hasFirePrompt(prompt, holdSeconds)
        end)
        if not ok then
            dprint("ERROR collect:", tostring(err))
        end
        Active.InFlight -= 1
    end)
end

-- ==================
-- Scanning pipeline
-- ==================
local function scanOnce()
    if Active.Stopped or not CFG.Run then return end

    local root = getPlantsRoot()
    if not root then
        dprint("PlantsPhysical root not found.")
        return
    end

    local batch = 0
    -- Struktur: PlantsPhysical.[Tree].Fruits.[Buah]
    for _, tree in ipairs(root:GetChildren()) do
        local fruitsFolder = tree:FindFirstChild("Fruits")
        if fruitsFolder then
            for _, fruit in ipairs(fruitsFolder:GetChildren()) do
                if Active.Stopped then return end
                if not fruit:IsA("Model") then continue end
                -- Cari prompt "enabled"
                local prompt = findEnabledPrompt(fruit)
                if prompt and prompt.Enabled and canTryFruit(fruit) then
                    tryCollectFruit(fruit, prompt)
                    batch += 1
                    if batch >= (CFG.MaxConcurrent * 2) then
                        -- throttle ringan biar nggak nge-spam
                        task.wait(0.02)
                        batch = 0
                    end
                end
            end
        end
    end
end

local Loop = nil
local function start()
    if Loop then return end
    Active.Stopped = false
    dprint("Auto Collect Fruit START. Interval:", CFG.ScanInterval)

    Loop = task.spawn(function()
        while not Active.Stopped do
            local t0 = os.clock()
            local ok, err = pcall(scanOnce)
            if not ok then
                dprint("ERROR scanOnce:", tostring(err))
            end
            local elapsed = os.clock() - t0
            local sleep = math.max(0.01, (CFG.ScanInterval or 0.1) - elapsed)
            task.wait(sleep)
        end
        dprint("Auto Collect Fruit loop stopped.")
    end)
end

local function stop()
    Active.Stopped = true
end

local function kill()
    stop()
    if Active.ConnStop then
        Active.ConnStop:Disconnect()
        Active.ConnStop = nil
    end
    Loop = nil
    G.FruitCollector = nil
    dprint("Auto Collect Fruit KILLED.")
end

-- Hook Stop-on-GUI-close (optional)
do
    -- Kalau RemnantUIdev kamu expose BindableEvent global, contoh:
    -- getgenv().RemnantUI.StopAllEvent:Fire()
    local ui = rawget(G, "RemnantUI")
    local stopEvent =
        (ui and ui.StopAllEvent) or
        (RG.StopAllBindable)    or
        nil
    if stopEvent and stopEvent.Connect then
        Active.ConnStop = stopEvent:Connect(function()
            dprint("StopAllEvent received. Stopping Auto Collect.")
            stop()
        end)
    end
end

-- Export API
G.FruitCollector = {
    Start = start,
    Stop  = stop,
    Kill  = kill,
    Lists = Lists,   -- buat isi dropdown di GUI
}

-- Auto-start kalau Run = true
if CFG.Run then
    start()
else
    dprint("Auto Collect Fruit loaded. CFG.Run = false (standby).")
end


