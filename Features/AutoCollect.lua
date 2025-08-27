--========================================================
-- Remnant — Auto Collect Fruit (MyFarm-first) v1.2 (patched)
-- • Kompatibel RemnantDEV patched (UI.Events.StopAllEvent, RemnantLoader)
-- • Loop hidup permanen (cek CFG.Run di dalam loop)
-- • Opsi UseOwnerFilter (true = MyFarm-only, false = semua farm)
-- • CFG.MaxDistance (batasi jarak dari player), fallback panen aman
-- • Alias Kill: getgenv().FruitCollectorKILL
--========================================================

local G  = getgenv()
local RG = assert(G.RemnantGlobals, "[AutoCollect] RemnantGlobals not found")
local RUI = rawget(G, "RemnantUI")

local Players    = RG.Players
local RunService = RG.RunService
local Workspace  = RG.Workspace
local LP         = Players.LocalPlayer

----------------------------------------------------------------
-- Konfigurasi (diisi oleh RemnantDEV sebelum Start via bridge)
----------------------------------------------------------------
local CFG = {
  Run               = false,     -- default OFF; dikendalikan GUI
  ScanInterval      = 0.10,      -- detik
  RateLimitPerFruit = 1.25,      -- detik cooldown per prompt instance
  MaxConcurrent     = 3,         -- batas panen per siklus
  UseOwnerFilter    = true,      -- true: scan MyFarm saja; false: semua farm
  SelectedFruits    = {},        -- {"Apple","Orange"} ; kosong = ambil semua
  WeightMin         = 0.0,       -- jika game simpan berat (abaikan jika tidak ada)
  WeightMax         = math.huge,
  MutationWhitelist = {},        -- jika tersedia
  MutationBlacklist = {},        -- jika tersedia
  MaxDistance       = 15,        -- batas jarak dari player
  Debug             = false,
}

-- Merge dari FruitCollectCFG (dibuat RemnantDEV)
do
  local U = rawget(G, "FruitCollectCFG")
  if type(U) == "table" then
    for k,v in pairs(U) do CFG[k] = v end
  end
end

------------------------------------------------
-- Helper logging
------------------------------------------------
local function dprint(...)
  if CFG.Debug then
    print("[AutoCollect]", ...)
  end
end

------------------------------------------------
-- Util: check in-list
------------------------------------------------
local function inList(value, list)
  for _,v in ipairs(list or {}) do
    if tostring(v) == tostring(value) then return true end
  end
  return false
end

------------------------------------------------
-- Farm roots
-- Struktur umum:
--   Workspace.Farm -> <FarmX> -> Important -> Data.Owner (StringValue)
--                                \-> Plants_Physical | PlantsPhysical
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
    table.insert(roots, {
      Farm = farm,
      Important = Important,
      OwnerName = Owner and Owner.Value or nil,
      PlantsPhysical = PlantsPhysical
    })
  end
  return roots
end

local function getMyFarmRoot()
  local roots = getFarmRoots()
  for _, r in ipairs(roots) do
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
-- Extractors & Filters
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
  -- fallback pakai model.Name kalau atribut tidak tersedia
  local istring = model:FindFirstChild("Item_String", true)
  local pname   = model:FindFirstChild("Plant_Name",  true)
  if istring and tostring(istring.Value) ~= "" then return tostring(istring.Value) end
  if pname   and tostring(pname.Value)   ~= "" then return tostring(pname.Value)   end
  return model.Name
end

local function passesNameFilter(name)
  local list = CFG.SelectedFruits
  if not list or #list == 0 then return true end -- kosong = ambil semua
  return inList(name, list)
end

local function passesMutationFilter(model)
  local variant = getVariant(model)
  if variant == nil then return true end                -- jika game tak punya variant, jangan blokir
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
        -- Distance guard
        if pos and not ignoreDistance then
          local ok, cf = pcall(child.GetPivot, child)
          if ok and cf then
            if (pos - cf.Position).Magnitude > (CFG.MaxDistance or 15) then
              goto continue
            end
          end
        end

        local name = getFruitName(child)
        if not passesNameFilter(name)    then goto continue end
        if not passesMutationFilter(child) then goto continue end
        if not passesWeightFilter(child) then goto continue end

        table.insert(results, { model = child, prompt = prompt, name = name })
      end
    end
    ::continue::
  end
  return results
end

-- Kumpulkan harvestable sesuai UseOwnerFilter
local function collectHarvestable(ignoreDistance)
  if CFG.UseOwnerFilter ~= false then
    -- MyFarm only
    if not ensurePlantsRoot() then
      dprint("PlantsPhysical root not found")
      return {}
    end
    return collectFromRoot(MyFarmRoot.PlantsPhysical, ignoreDistance)
  else
    -- Scan semua farm
    local results = {}
    for _, r in ipairs(getFarmRoots()) do
      local batch = collectFromRoot(r.PlantsPhysical, ignoreDistance)
      if #batch > 0 then
        for i = 1, #batch do
          results[#results+1] = batch[i]
        end
      end
    end
    return results
  end
end

------------------------------------------------
-- Rate limit per ProximityPrompt instance
------------------------------------------------
local lastHit = setmetatable({}, {__mode = "k"}) -- weak keys by instance
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

  -- cara cepat
  local ok = pcall(function() fireproximityprompt(prompt) end)
  if ok then return true end

  -- fallback (beberapa executor/game memperlukan begin/end hold)
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

task.spawn(runner)

------------------------------------------------
-- Stop saat RemnantDEV menutup GUI (StopAllEvent)
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
-- Ekspos API untuk Loader
------------------------------------------------
G.FruitCollector = {
  Kill = function()
    alive = false
  end,
  Lists = {
    FruitNames = {},   -- (opsional) bisa diisi untuk sync dropdown
    Mutations  = {},   -- (opsional)
  }
}
-- Alias Kill agar kompatibel dengan berbagai loader
G.FruitCollectorKILL = G.FruitCollector.Kill

-- Modul mentahan: tidak perlu return apapun (loader akan cari KILL)
return nil
