--========================================================
-- Remnant — Auto Collect Fruit (MyFarm-only) v1
-- Gaya modul: expose getgenv().FruitCollector + optional Lists
-- Kompatibel dengan RemnantDEV Loader/startAutoCollectFruit (no GUI)
--========================================================
local G  = getgenv()
local RG = assert(G.RemnantGlobals, "[AutoCollect] RemnantGlobals not found")
local UI = rawget(G, "RemnantUI")

local Players    = RG.Players
local RunService = RG.RunService
local Workspace  = RG.Workspace

local LP         = Players.LocalPlayer

-------------------------------
-- Konfigurasi (diisi oleh RemnantDEV)
-------------------------------
local CFG = {
  Run               = true,
  ScanInterval      = 0.10,
  RateLimitPerFruit = 1.25,
  MaxConcurrent     = 3,
  UseOwnerFilter    = true,
  SelectedFruits    = {},         -- e.g. {"Apple","Orange"} ; kosong = ambil semua
  WeightMin         = 0.0,        -- optional, jika game menyimpan berat; abaikan jika tak ada
  WeightMax         = math.huge,
  MutationWhitelist = {},         -- optional
  MutationBlacklist = {},         -- optional
  Debug             = false,
}

-- Merge dari FruitCollectCFG jika ada
do
  local U = rawget(G, "FruitCollectCFG")
  if type(U) == "table" then
    for k,v in pairs(U) do
      CFG[k] = v
    end
  end
end

-------------------------------
-- Helper: logging
-------------------------------
local function dprint(...)
  if CFG.Debug then
    print("[AutoCollect]", ...)
  end
end

-------------------------------
-- Cari MyFarm
-- Struktur rujukan: workspace.Farm -> each Farm -> Important.Data.Owner
-- dan buah ada di: Important.Plants_Physical
-------------------------------
local function getMyFarm()
  local root = Workspace:FindFirstChild("Farm")
  if not root then return end
  for _,farm in ipairs(root:GetChildren()) do
    local Important = farm:FindFirstChild("Important")
    local Data = Important and Important:FindFirstChild("Data")
    local Owner = Data and Data:FindFirstChild("Owner")
    if typeof(Owner) == "Instance" and Owner.Value == LP.Name then
      return farm, Important
    end
  end
end

local MyFarm, MyImportant = getMyFarm()
local PlantsPhysical = MyImportant and (MyImportant:FindFirstChild("Plants_Physical")
                        or MyImportant:FindFirstChild("PlantsPhysical"))

-------------------------------
-- Filter & ekstraksi info
-------------------------------
local function hasPromptEnabled(model)
  local prompt = model:FindFirstChild("ProximityPrompt", true)
  return prompt and prompt.Enabled, prompt
end

local function getVariant(model)
  local v = model:FindFirstChild("Variant", true)
  return v and v.Value or nil
end

local function getFruitName(model)
  -- fallback: pakai Name model; kalau game punya child "Item_String" / "Plant_Name" ambil itu
  local istring = model:FindFirstChild("Item_String", true)
  local pname   = model:FindFirstChild("Plant_Name", true)
  if istring and istring.Value ~= "" then return istring.Value end
  if pname   and pname.Value   ~= "" then return pname.Value   end
  return model.Name
end

local function passesNameFilter(name)
  local list = CFG.SelectedFruits
  if not list or #list == 0 then return true end -- kosong = ambil semua
  for _,n in ipairs(list) do
    if tostring(n) == tostring(name) then
      return true
    end
  end
  return false
end

local function inList(value, list)
  for _,v in ipairs(list or {}) do
    if v == value then return true end
  end
  return false
end

local function passesMutationFilter(model)
  local variant = getVariant(model)
  if variant == nil then return true end -- kalau game tidak punya variant, jangan blokir
  if CFG.MutationBlacklist and inList(variant, CFG.MutationBlacklist) then return false end
  if CFG.MutationWhitelist and #CFG.MutationWhitelist > 0 then
    return inList(variant, CFG.MutationWhitelist)
  end
  return true
end

-- optional: berat; jika tidak ada, abaikan
local function getWeight(model)
  local w = model:FindFirstChild("Weight", true)
  if w and tonumber(w.Value) then return tonumber(w.Value) end
  return nil
end

local function passesWeightFilter(model)
  local w = getWeight(model)
  if not w then return true end
  return (w >= CFG.WeightMin) and (w <= CFG.WeightMax)
end

-------------------------------
-- Scanner: kumpulkan buah siap panen (Prompt.Enabled)
-------------------------------
local function collectHarvestable(ignoreDistance)
  local results = {}
  if not PlantsPhysical then return results end

  local pos = LP.Character and LP.Character:GetPivot().Position or nil
  for _, child in ipairs(PlantsPhysical:GetDescendants()) do
    -- Ambil Model saja agar GetPivot aman
    if child:IsA("Model") then
      local okPrompt, prompt = hasPromptEnabled(child)
      if okPrompt then
        -- Distance check (batas default 15 stud; kalau ignoreDistance, lewati)
        if pos and not ignoreDistance then
          local ok, cf = pcall(child.GetPivot, child)
          if ok and cf then
            if (pos - cf.Position).Magnitude > 15 then
              goto continue
            end
          end
        end

        -- Nama & filter
        local name = getFruitName(child)
        if not passesNameFilter(name) then goto continue end
        if not passesMutationFilter(child) then goto continue end
        if not passesWeightFilter(child) then goto continue end

        table.insert(results, {model = child, prompt = prompt, name = name})
      end
    end
    ::continue::
  end
  return results
end

-------------------------------
-- Rate limit per instance
-------------------------------
local lastHit = setmetatable({}, {__mode = "k"}) -- weak keys by instance
local function canHit(instance)
  local t = os.clock()
  local last = lastHit[instance] or 0
  if (t - last) >= CFG.RateLimitPerFruit then
    lastHit[instance] = t
    return true
  end
  return false
end

-------------------------------
-- Worker: fire prompt
-------------------------------
local function harvestOne(item)
  local prompt = item.prompt
  if prompt and canHit(prompt) then
    fireproximityprompt(prompt)
    return true
  end
  return false
end

-------------------------------
-- Runner loop
-------------------------------
local alive = true
local thread

local function runner()
  dprint("AutoCollect started")
  while alive and CFG.Run do
    -- kalau during StopAllEvent, biar modul berhenti juga
    -- (RemnantDEV sudah men-set flags & StopAll loader saat Window:OnClose)
    local batch = collectHarvestable(false)
    local done = 0
    for _, item in ipairs(batch) do
      if harvestOne(item) then
        done += 1
        if done >= (CFG.MaxConcurrent or 3) then break end
      end
    end
    task.wait(CFG.ScanInterval or 0.10)
  end
  dprint("AutoCollect stopped")
end

-- Start segera (RemnantDEV memanggil loadstring() langsung)
thread = task.spawn(runner)

-- Stop ketika GUI memicu event global (opsional; RemnantDEV juga akan matikan flags)
if UI and UI.StopAllEvent and UI.StopAllEvent.Event then
  UI.StopAllEvent.Event:Connect(function()
    alive = false
  end)
end

-------------------------------
-- Ekspos API untuk RemnantDEV
-------------------------------
G.FruitCollector = {
  Kill = function()
    alive = false
  end,
  -- Optional: isi daftar untuk dropdown (kalau kamu mau sinkronkan list)
  -- Kosongkan dulu; bisa kamu isi dari registry game kalau sudah ada sumber data.
  Lists = {
    FruitNames = {},   -- e.g. {"Apple","Orange",...}
    Mutations  = {},   -- e.g. {"Normal","Gold","Rainbow"}
  }
}

return nil
