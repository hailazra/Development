--========================================================
-- Auto Collect Fruit (No GUI) — v2
-- Dependensi:
--   getgenv().RemnantGlobals  (disiapkan GUI kamu)
--   Optional: getgenv().RemnantUI.Events.StopAllEvent (buat auto-stop)
--
-- Cara pakai singkat:
--   getgenv().FruitCollectCFG = {
--     Run               = true,
--     ScanInterval      = 0.10,   -- detik
--     RateLimitPerFruit = 1.25,   -- detik cooldown per instance buah
--     MaxConcurrent     = 3,      -- batasi jumlah collect simultan
--     UseOwnerFilter    = true,   -- hanya farm milik LocalPlayer (disarankan true)
--     SelectedFruits    = nil,    -- { "Apple","Orange" } ; kalau nil -> auto ambil dari SeedData
--     MutationWhitelist = nil,    -- opsional: { "Shiny","Heavy" }
--     MutationBlacklist = nil,    -- opsional: { "Rotten" }
--   }
--   loadstring(game:HttpGet("RAW_URL/AutoCollect.lua"))()
--
-- Kill / Matikan:
--   if getgenv().FruitCollectKILL then getgenv().FruitCollectKILL() end
--========================================================

local G = rawget(getgenv(), "RemnantGlobals") or {}
local UI = rawget(getgenv(), "RemnantUI")     or {}

local Players    = G.Players    or game:GetService("Players")
local RS         = G.RS         or game:GetService("ReplicatedStorage")
local RunService = G.RunService or game:GetService("RunService")
local Workspace  = G.Workspace  or game:GetService("Workspace")

local LP         = G.LP         or Players.LocalPlayer

--========================================================
-- Konfigurasi
--========================================================
getgenv().FruitCollectCFG = getgenv().FruitCollectCFG or {}
local CFG = getgenv().FruitCollectCFG
CFG.Run               = (CFG.Run               ~= nil) and CFG.Run               or true
CFG.ScanInterval      = tonumber(CFG.ScanInterval)      or 0.10
CFG.RateLimitPerFruit = tonumber(CFG.RateLimitPerFruit) or 1.25
CFG.MaxConcurrent     = tonumber(CFG.MaxConcurrent)     or 3
CFG.UseOwnerFilter    = (CFG.UseOwnerFilter ~= nil) and CFG.UseOwnerFilter or true
-- SelectedFruits, MutationWhitelist, MutationBlacklist -> boleh nil (auto)

--========================================================
-- Farm Resolver (owner-aware) → khusus AutoCollect pakai Plants_Physical
--========================================================
local FARM_ROOT, IMPORTANT, PLANT_ROOT, PLANT_LOC

local function findPlantsRoot(importantFolder)
    -- Utama: "Plants_Physical", Fallback: "PlantsPhysical"
    local a = importantFolder:FindFirstChild("Plants_Physical")
    if a then return a end
    local b = importantFolder:FindFirstChild("PlantsPhysical")
    if b then return b end
    return nil
end

local function resolveFarmForLocal()
    local candidate = nil

    -- 1) Cari di Workspace.Farm (berlapis)
    local rootFarmContainer = Workspace:FindFirstChild("Farm")
    if rootFarmContainer then
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
        if not candidate then
            local single = rootFarmContainer:FindFirstChild("Farm")
            if single and single:FindFirstChild("Important") then
                candidate = single
            end
        end
    end

    -- 2) Fallback: scan seluruh Workspace
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

    -- 3) Pasang pointer
    if candidate then
        FARM_ROOT  = candidate
        IMPORTANT  = FARM_ROOT:FindFirstChild("Important") or FARM_ROOT:WaitForChild("Important")
        PLANT_ROOT = findPlantsRoot(IMPORTANT)
        PLANT_LOC  = IMPORTANT:FindFirstChild("Plant_Locations") -- opsional
        return true
    else
        -- Layout lama tunggal
        local fr = Workspace:FindFirstChild("Farm")
        fr = fr and fr:FindFirstChild("Farm") or fr
        if fr and fr:FindFirstChild("Important") then
            FARM_ROOT  = fr
            IMPORTANT  = fr:FindFirstChild("Important")
            PLANT_ROOT = findPlantsRoot(IMPORTANT)
            PLANT_LOC  = IMPORTANT:FindFirstChild("Plant_Locations")
            return true
        end
    end
    return false
end

-- Resolusi awal + auto re-check tiap 5 detik
resolveFarmForLocal()
task.spawn(function()
    while true do
        if not (FARM_ROOT and IMPORTANT and PLANT_ROOT) then
            resolveFarmForLocal()
        else
            -- Validasi owner agar pointer nggak basi kalau plot berganti
            local ok = false
            local Data = IMPORTANT:FindFirstChild("Data")
            local OwnerVal = Data and Data:FindFirstChild("Owner")
            if not CFG.UseOwnerFilter then
                ok = true
            else
                if OwnerVal and tostring(OwnerVal.Value) == LP.Name then ok = true end
            end
            if not ok then resolveFarmForLocal() end
        end
        task.wait(5)
    end
end)

--========================================================
-- Helper: SeedData & MutationHandler (untuk auto isi daftar buah)
--========================================================
local function safeRequire(mod)
    local ok, res = pcall(require, mod)
    if ok then return res end
    return nil
end

local function getAllFruitNamesFromSeedData()
    local list = {}
    local seen = {}
    local dataFolder = RS:FindFirstChild("Data")
    local seedModule = dataFolder and dataFolder:FindFirstChild("SeedData")
    if seedModule and seedModule:IsA("ModuleScript") then
        local t = safeRequire(seedModule)
        -- Harapan: t adalah table daftar benih/buah. Kita kumpulkan kunci / Name
        if typeof(t) == "table" then
            for k, v in pairs(t) do
                local name = (typeof(v) == "table" and (v.Name or v.DisplayName)) or tostring(k)
                if name and not seen[name] then
                    seen[name] = true
                    table.insert(list, name)
                end
            end
        end
    end
    return list
end

local function buildSelectedFruits()
    if type(CFG.SelectedFruits) == "table" and #CFG.SelectedFruits > 0 then
        return CFG.SelectedFruits
    end
    local auto = getAllFruitNamesFromSeedData()
    if #auto == 0 and PLANT_ROOT then
        -- Fallback: kumpulkan dari nama folder Fruits di farm saat ini
        local seen = {}
        for _, desc in ipairs(PLANT_ROOT:GetDescendants()) do
            if desc:IsA("Folder") and desc.Name == "Fruits" then
                for _, fruitFolder in ipairs(desc:GetChildren()) do
                    if fruitFolder:IsA("Folder") then
                        local nm = fruitFolder.Name
                        if nm and not seen[nm] then
                            seen[nm] = true
                            table.insert(auto, nm)
                        end
                    end
                end
            end
        end
    end
    return auto
end

local SELECTED_FRUITS = buildSelectedFruits()
local WHITELIST = (type(CFG.MutationWhitelist) == "table") and CFG.MutationWhitelist or nil
local BLACKLIST = (type(CFG.MutationBlacklist) == "table") and CFG.MutationBlacklist or nil

local function isFruitAllowedByName(name)
    if not name then return false end
    if not SELECTED_FRUITS or #SELECTED_FRUITS == 0 then return true end
    for _, n in ipairs(SELECTED_FRUITS) do
        if n == name then return true end
    end
    return false
end

local function isFruitAllowedByMutation(fruitInstance)
    -- Coba baca atribut "Mutation" (umum dipakai dev)
    if (not WHITELIST) and (not BLACKLIST) then return true end
    local mut = nil
    if fruitInstance and fruitInstance.GetAttribute then
        mut = fruitInstance:GetAttribute("Mutation")
    end
    if WHITELIST and mut then
        local pass = false
        for _, m in ipairs(WHITELIST) do if m == mut then pass = true break end end
        if not pass then return false end
    end
    if BLACKLIST and mut then
        for _, m in ipairs(BLACKLIST) do if m == mut then return false end end
    end
    return true
end

--========================================================
-- Core Collect Logic
--========================================================
local running = true
local inFlight = 0
local lastHit = setmetatable({}, { __mode = "k" }) -- weak keys untuk instance

-- Global kill
getgenv().FruitCollectKILL = function()
    running = false
    print("[FruitAuto] Kill requested.")
end

-- Stop kalau GUI kirim sinyal StopAllEvent
do
    local ok, ev = pcall(function() return UI and UI.Events and UI.Events.StopAllEvent end)
    if ok and typeof(ev) == "Instance" and ev.IsA and ev:IsA("BindableEvent") then
        ev.Event:Connect(function()
            if running then
                print("[FruitAuto] StopAllEvent received → stopping.")
                getgenv().FruitCollectKILL()
            end
        end)
    end
end

-- Util: trigger ProximityPrompt
local function triggerPrompt(prompt)
    if not prompt or not prompt.Enabled then return false end
    -- Prefer fireproximityprompt jika tersedia (eksploit environment), fallback manual
    local ok = false
    if typeof(fireproximityprompt) == "function" then
        local dur = prompt.HoldDuration or 0
        pcall(function()
            fireproximityprompt(prompt, dur and math.max(dur, 0) or 0)
            ok = true
        end)
    else
        -- Fallback sederhana: coba enable/disable (kadang memicu), tapi tidak selalu work
        -- Tetap dianggap best-effort
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration or 0)
            prompt:InputHoldEnd()
            ok = true
        end)
    end
    return ok
end

-- Dapatkan daftar prompt siap collect dari PLANT_ROOT:
-- Struktur umum yang diobservasi:
--   Plants_Physical
--     └─ [Tree/Pohon]
--         └─ Fruits
--            └─ [BuahNama]
--                └─ [index number/anything]
--                    └─ ProximityPrompt (Enabled = true if ready)
local function scanReadyPrompts()
    local results = {}
    if not PLANT_ROOT then return results end

    for _, tree in ipairs(PLANT_ROOT:GetChildren()) do
        if tree:IsA("Folder") or tree:IsA("Model") then
            local fruitsFolder = tree:FindFirstChild("Fruits")
            if fruitsFolder then
                for _, fruitGroup in ipairs(fruitsFolder:GetChildren()) do
                    if fruitGroup:IsA("Folder") then
                        local fruitName = fruitGroup.Name
                        if isFruitAllowedByName(fruitName) then
                            for _, node in ipairs(fruitGroup:GetDescendants()) do
                                if node:IsA("ProximityPrompt") and node.Enabled then
                                    local prompt = node
                                    local instanceForMutation = prompt.Parent or fruitGroup
                                    if isFruitAllowedByMutation(instanceForMutation) then
                                        table.insert(results, { name = fruitName, prompt = prompt })
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return results
end

-- Worker: konsumsi prompt dengan batasan concurrency & rate-limit per instance
local function processPrompts(list)
    for _, item in ipairs(list) do
        if not running then break end
        local prompt = item.prompt
        local lh = lastHit[prompt] or 0
        if (tick() - lh) >= CFG.RateLimitPerFruit then
            if inFlight < CFG.MaxConcurrent then
                inFlight += 1
                lastHit[prompt] = tick()
                task.spawn(function()
                    local ok = triggerPrompt(prompt)
                    if ok then
                        -- print(string.format("[FruitAuto] Collected: %s", tostring(item.name)))
                    end
                    task.wait(0.05)
                    inFlight -= 1
                end)
            end
        end
    end
end

--========================================================
-- Main Loop
--========================================================
task.spawn(function()
    print("[FruitAuto] Started. Waiting for farm & plants root...")
    while running do
        if not CFG.Run then
            task.wait(0.25)
        else
            if not PLANT_ROOT then
                -- info user jika belum ketemu plants root
                warn("[FruitAuto] Plants_Physical root not found. Waiting...")
                task.wait(0.5)
            else
                local prompts = scanReadyPrompts()
                if #prompts > 0 then
                    processPrompts(prompts)
                end
                task.wait(CFG.ScanInterval)
            end
        end
    end
    print("[FruitAuto] Stopped.")
end)
