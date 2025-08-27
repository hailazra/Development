--========================================================
-- Remnant — Auto Collect Fruit (MyFarm-first) v1.3
-- • Integrasi langsung ReplicatedStorage.Data.SeedData (fruit list)
--   & ReplicatedStorage.Modules.MutationHandler (mutation list)
-- • Push otomatis ke dropdown RemnantDEV (Harvest/Shovel/Event/ESP/Seed)
-- • Loop hidup permanen, UseOwnerFilter, MaxDistance, StopAllEvent, Kill alias
--========================================================

local G   = getgenv()
local RG  = assert(G.RemnantGlobals, "[AutoCollect] RemnantGlobals not found")
local RUI = rawget(G, "RemnantUI")

local Players    = RG.Players
local RunService = RG.RunService
local Workspace  = RG.Workspace
local RS         = RG.RS
local LP         = Players.LocalPlayer

----------------------------------------------------------------
-- Konfigurasi (diisi RemnantDEV lewat FruitCollectCFG)
----------------------------------------------------------------
local CFG = {
  Run               = false,     -- dikendalikan GUI
  ScanInterval      = 0.10,
  RateLimitPerFruit = 1.25,
  MaxConcurrent     = 3,
  UseOwnerFilter    = true,      -- true: MyFarm saja
  SelectedFruits    = {},        -- kosong = ambil semua
  WeightMin         = 0.0,
  WeightMax         = math.huge,
  MutationWhitelist = {},
  MutationBlacklist = {},
  MaxDistance       = 15,
  Debug             = false,
}
do
  local U = rawget(G, "FruitCollectCFG")
  if type(U) == "table" then for k,v in pairs(U) do CFG[k] = v end end
end

------------------------------------------------
-- Logging
------------------------------------------------
local function dprint(...)
  if CFG.Debug then print("[AutoCollect]", ...) end
end

------------------------------------------------
-- Helpers: unique lists & robust extractor
------------------------------------------------
local Catalog = { FruitNames = {}, Mutations = {} }
local _fruitSet, _mutSet = {}, {}

local function _addUnique(tset, list, v)
  if not v or v == "" then return false end
  v = tostring(v)
  if tset[v] then return false end
  tset[v] = true
  list[#list+1] = v
  return true
end

-- Ambil nama-nama dari berbagai bentuk module (array/objek/kv)
local function extractNamesFromAny(node)
  local out, seen = {}, {}
  local function add(x) _addUnique(seen, out, x) end
  if type(node) ~= "table" then return out end

  local function fromTable(t, preferKey)
    -- Kalau array
    if rawget(t, 1) ~= nil then
      for _,v in ipairs(t) do
        if type(v) == "string" then add(v)
        elseif type(v) == "table" then
          add(v.Name or v.name or v.DisplayName or v.Id or v.id)
        end
      end
    else
      -- dictionary
      for k,v in pairs(t) do
        if type(v) == "string" then add(v) end
        if preferKey and type(k) == "string" then add(k) end
        if type(v) == "table" then
          add(v.Name or v.name or v.DisplayName or (not preferKey and k))
        end
      end
    end
  end

  fromTable(node, false)

  -- Heuristik: kalau punya field umum, gali lagi
  for _, key in ipairs({"List","Lists","All","Data","Seeds","Seed","Mutations"}) do
    local sub = rawget(node, key)
    if type(sub) == "table" then fromTable(sub, key ~= "Data") end
  end

  return out
end

------------------------------------------------
-- Push hasil ke semua dropdown terkait di RemnantDEV
------------------------------------------------
local function pushFruitListToGUI(fruits)
  local API = RUI and RUI.API
  if not API then return end
  pcall(function() API.Farm   and API.Farm.SetFruitList          and API.Farm.SetFruitList(fruits) end)
  pcall(function() API.Farm   and API.Farm.SetShovelFruitList    and API.Farm.SetShovelFruitList(fruits) end)
  pcall(function() API.Event  and API.Event.SetFruitList         and API.Event.SetFruitList(fruits) end)
  pcall(function() API.ESP    and API.ESP.SetFruitList           and API.ESP.SetFruitList(fruits) end)
  pcall(function() API.Farm   and API.Farm.SetSeedList           and API.Farm.SetSeedList(fruits) end) -- sekalian seed list
end

local function pushMutationListToGUI(muts)
  local API = RUI and RUI.API
  if not API then return end
  -- Harvest / Plants
  pcall(function() API.Farm and API.Farm.SetWhiteMutationList    and API.Farm.SetWhiteMutationList(muts) end)
  pcall(function() API.Farm and API.Farm.SetBlackMutationList    and API.Farm.SetBlackMutationList(muts) end)
  -- Shovel
  pcall(function() API.Farm and API.Farm.SetShovelMutationList   and API.Farm.SetShovelMutationList(muts) end)
  pcall(function() API.Farm and API.Farm.SetShovelBlacklistList  and API.Farm.SetShovelBlacklistList(muts) end)
  -- Event
  pcall(function() API.Event and API.Event.SetWhiteMutationList  and API.Event.SetWhiteMutationList(muts) end)
  pcall(function() API.Event and API.Event.SetBlackMutationList  and API.Event.SetBlackMutationList(muts) end)
  -- ESP
  pcall(function() API.ESP and API.ESP.SetMutationList           and API.ESP.SetMutationList(muts) end)
end

------------------------------------------------
-- Seed dari ModuleScripts:
--   RS.Data.SeedData           -> daftar buah/seed
--   RS.Modules.MutationHandler -> daftar mutation
------------------------------------------------
local function safeRequire(inst)
  if not inst then return nil end
  local ok, ret = pcall(require, inst)
  if ok then return ret end
  return nil
end

local function seedFromModuleScripts()
  local seedDataMod = RS:FindFirstChild("Data") and RS.Data:FindFirstChild("SeedData")
  local mutMod      = RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("MutationHandler")

  local fruits, muts = {}, {}

  -- Fruit/Seed list
  do
    local data = safeRequire(seedDataMod)
    if type(data) == "table" then
      fruits = extractNamesFromAny(data)
    end
  end

  -- Mutation list (dipakai utk whitelist+blacklist)
  do
    local data = safeRequire(mutMod)
    if type(data) == "table" then
      -- Coba beberapa field umum dulu
      local src = data.Mutations or data.List or data.Lists or data.All or data.Data or data
      if type(src) == "function" then
        local ok, res = pcall(src, data)
        if ok and type(res) == "table" then src = res end
      end
      muts = extractNamesFromAny(src)
      -- Kalau masih kosong, ekstrak langsung dari module utamanya
      if #muts == 0 then muts = extractNamesFromAny(data) end
    end
  end

  -- Simpan ke katalog lokal (buat dedup update berikutnya)
  for _,n in ipairs(fruits) do _addUnique(_fruitSet, Catalog.FruitNames, n) end
  for _,m in ipairs(muts)   do _addUnique(_mutSet,   Catalog.Mutations, m) end

  -- Dorong ke GUI
  if #Catalog.FruitNames > 0 then pushFruitListToGUI(Catalog.FruitNames) end
  if #Catalog.Mutations  > 0 then pushMutationListToGUI(Catalog.Mutations) end
end

------------------------------------------------
-- Farm roots (struktur umum Farm -> Important -> Plants_Physical)
------------------------------------------------
local function getFarmRoots()
  local roots = {}
  local root = Workspace:FindFirstChild("Farm")
  if not root then return roots end
  for _, farm in ipairs(root:GetChildren()) do
    local Important = farm:FindFirstChild("Important")
    local Data = Important and Important:FindFirstChild("Data")
    local Owner = Data and Data:FindFirstChild("Owner")
    local PlantsPhysical = Important and (Important:FindFirstChild("Plants_Physical") or Important:FindFirstChild("PlantsPhysical"))
    roots[#roots+1] = {
      Farm = farm,
      Important = Important,
      OwnerName = Owner and Owner.Value or nil,
      PlantsPhysical = PlantsPhysical
    }
  end
  return roots
end

local function getMyFarmRoot()
  for _, r in ipairs(getFarmRoots()) do
    if r.OwnerName == LP.Name then return r end
  end
end

-- cache ringan
local MyFarmRoot = getMyFarmRoot()
local function ensurePlantsRoot()
  if MyFarmRoot and MyFarmRoot.PlantsPhysical and MyFarmRoot.PlantsPhysical.Parent then
    return true
  end
  MyFarmRoot = getMyFarmRoot()
  return MyFarmRoot and MyFarmRoot.PlantsPhysical ~= nil
end

------------------------------------------------
-- Filters & getters
------------------------------------------------
local function hasPromptEnabled(model)
  local prompt = model:FindFirstChild("ProximityPrompt", true)
  return (prompt and prompt.Enabled) and true or false, prompt
end

local function getVariant(model)
  local v = model:FindFirstChild("Variant", true)
  return v and v.Value or nil
end

local function getFruitName(model)
  local istring = model:FindFirstChild("Item_String", true)
  local pname   = model:FindFirstChild("Plant_Name",  true)
  if istring and tostring(istring.Value) ~= "" then return tostring(istring.Value) end
  if pname   and tostring(pname.Value)   ~= "" then return tostring(pname.Value)   end
  return model.Name
end

local function inList(value, list)
  for _,v in ipairs(list or {}) do
    if tostring(v) == tostring(value) then return true end
  end
  return false
end

local function passesNameFilter(name)
  local list = CFG.SelectedFruits
  if not list or #list == 0 then return true end
  return inList(name, list)
end

local function passesMutationFilter(model)
  local variant = getVariant(model)
  if variant == nil then return true end
  if #CFG.MutationBlacklist > 0 and inList(variant, CFG.MutationBlacklist) then return false end
  if #CFG.MutationWhitelist > 0 then
    return inList(variant, CFG.MutationWhitelist)
  end
  return true
end

local function getWeight(model)
  local w = model:FindFirstChild("Weight", true)
  if w then
    local num = tonumber(w.Value)
    if num then return num end
  end
  return nil
end

local function passesWeightFilter(model)
  local w = getWeight(model)
  if not w then return true end
  return (w >= (CFG.WeightMin or 0.0)) and (w <= (CFG.WeightMax or math.huge))
end

------------------------------------------------
-- Scanner dari satu PlantsPhysical root
------------------------------------------------
local function collectFromRoot(PlantsPhysical, ignoreDistance)
  local results = {}
  if not PlantsPhysical then return results end

  local pos = LP.Character and LP.Character:GetPivot().Position or nil
  for _, child in ipairs(PlantsPhysical:GetDescendants()) do
    if child:IsA("Model") then
      local okPrompt, prompt = hasPromptEnabled(child)
      if okPrompt and prompt then
        if pos and not ignoreDistance then
          local ok, cf = pcall(child.GetPivot, child)
          if ok and cf and (pos - cf.Position).Magnitude > (CFG.MaxDistance or 15) then
            goto continue
          end
        end

        local name = getFruitName(child)
        if not passesNameFilter(name)      then goto continue end
        if not passesMutationFilter(child) then goto continue end
        if not passesWeightFilter(child)   then goto continue end

        -- Belajar nama/mutasi yang belum ada (opsional, tambahan dari dunia)
        if _addUnique(_fruitSet, Catalog.FruitNames, name) then
          pushFruitListToGUI(Catalog.FruitNames)
        end
        local mut = getVariant(child)
        if _addUnique(_mutSet, Catalog.Mutations, mut) then
          pushMutationListToGUI(Catalog.Mutations)
        end

        results[#results+1] = { model = child, prompt = prompt, name = name }
      end
    end
    ::continue::
  end
  return results
end

-- Kumpulkan harvestable sesuai UseOwnerFilter
local function collectHarvestable(ignoreDistance)
  if CFG.UseOwnerFilter ~= false then
    if not ensurePlantsRoot() then
      dprint("PlantsPhysical root not found")
      return {}
    end
    return collectFromRoot(MyFarmRoot.PlantsPhysical, ignoreDistance)
  else
    local results = {}
    for _, r in ipairs(getFarmRoots()) do
      local batch = collectFromRoot(r.PlantsPhysical, ignoreDistance)
      for i = 1, #batch do results[#results+1] = batch[i] end
    end
    return results
  end
end

------------------------------------------------
-- Rate limit per ProximityPrompt instance
------------------------------------------------
local lastHit = setmetatable({}, {__mode = "k"})
local function canHit(instance)
  local t = os.clock()
  local last = lastHit[instance] or 0
  if (t - last) >= (CFG.RateLimitPerFruit or 1.25) then
    lastHit[instance] = t
    return true
  end
  return false
end

------------------------------------------------
-- Worker: panen satu item (dengan fallback)
------------------------------------------------
local function harvestOne(item)
  local prompt = item and item.prompt
  if not prompt or not canHit(prompt) then return false end

  local ok = pcall(function() fireproximityprompt(prompt) end)
  if ok then return true end

  local ok2 = pcall(function()
    if prompt.InputHoldBegin then prompt:InputHoldBegin() end
    task.wait(0.05)
    if prompt.InputHoldEnd   then prompt:InputHoldEnd()   end
  end)
  return ok2
end

------------------------------------------------
-- Runner loop
------------------------------------------------
local alive = true

local function runner()
  dprint("AutoCollect started")
  while alive do
    if CFG.Run then
      local batch = collectHarvestable(false)
      local done = 0
      for _, item in ipairs(batch) do
        if harvestOne(item) then
          done += 1
          if done >= (CFG.MaxConcurrent or 3) then break end
        end
      end
    end
    task.wait(CFG.ScanInterval or 0.10)
  end
  dprint("AutoCollect stopped")
end

------------------------------------------------
-- Hook StopAllEvent dari RemnantDEV
------------------------------------------------
do
  local ev = RUI and RUI.Events and RUI.Events.StopAllEvent and RUI.Events.StopAllEvent.Event
  if ev and ev.Connect then
    ev:Connect(function()
      alive = false
    end)
  end
end

------------------------------------------------
-- Inisialisasi data dropdown dari ModuleScripts lalu jalan
------------------------------------------------
seedFromModuleScripts()
task.spawn(runner)

------------------------------------------------
-- Ekspos API untuk Loader
------------------------------------------------
G.FruitCollector = {
  Kill = function() alive = false end,
  Lists = { FruitNames = Catalog.FruitNames, Mutations = Catalog.Mutations }
}
G.FruitCollectorKILL = G.FruitCollector.Kill

return nil
