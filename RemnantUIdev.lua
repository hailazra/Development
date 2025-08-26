--======================================================
-- Remnant Hub — WindUI (Docs-Compliant) + Lucide Icons
--======================================================

-- ======================
-- Globals for all features
-- ======================
local Players    = game:GetService("Players")
local RS         = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace  = game:GetService("Workspace")

local LP         = Players.LocalPlayer
local Backpack   = LP:WaitForChild("Backpack")
local Character  = LP.Character or LP.CharacterAdded:Wait()
local Humanoid   = Character:WaitForChild("Humanoid")
local Camera     = Workspace.CurrentCamera

-- Export biar bisa dipakai semua loadstring
getgenv().RemnantGlobals = {
    Players    = Players,
    RS         = RS,
    RunService = RunService,
    Workspace  = Workspace,
    LP         = LP,
    Backpack   = Backpack,
    Character  = Character,
    Humanoid   = Humanoid,
    Camera     = Camera,
}

-- Update Character & Humanoid when the player respawns
LP.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    getgenv().RemnantGlobals.Character = Character
    getgenv().RemnantGlobals.Humanoid = Humanoid
end)

--=== RemnantUI Controls registry (wajib agar elemen bisa diakses modul) ===
getgenv().RemnantUI = getgenv().RemnantUI or {}
getgenv().RemnantUI.Controls = getgenv().RemnantUI.Controls or {}

-- Event global agar modul eksternal bisa stop saat GUI ditutup
getgenv().RemnantUI.StopAllEvent = getgenv().RemnantUI.StopAllEvent or Instance.new("BindableEvent")


-- 1) Load WindUI (docs: Load latest)
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- 2) Create Window (docs: Window:CreateWindow)
local Window = WindUI:CreateWindow({
    Title         = ".devlogic",
    Icon          = "brain-circuit",              -- lucide
    Author        = "hailazra",
    Folder        = "RemnantHub",
    Size          = UDim2.fromOffset(250, 250),
    Theme         = "Dark",
    Resizable     = false,
    SideBarWidth  = 120,
    HideSearchBar = true,
})

-- 3) Tag (docs: Window:Tag)
if Color3 and Color3.fromHex then
    Window:Tag({ Title = "In Development", Color = Color3.fromHex("#315dff") })
else
    Window:Tag({ Title = "In Development", Color = Color3.fromRGB(49,93,255) })
end

--======================================================
-- Struktur GUI (Tab & Tab Section)
--======================================================

-- A. Main = Tab
local TabHome = Window:Tab({ Title = "Home", Icon = "house" })

-- B. Farm = Tab Section (COLLAPSIBLE)
local SecFarm = Window:Section({ Title = "Farm", Icon = "wheat", Opened = true })
local TabFarm_Plants     = SecFarm:Tab({ Title = "Plants & Fruits", Icon = "sprout" })
local TabFarm_Sprinkler  = SecFarm:Tab({ Title = "Sprinkler",       Icon = "droplets" })
local TabFarm_Shovel     = SecFarm:Tab({ Title = "Shovel",          Icon = "shovel" })

-- C. Pet & Egg = Tab Section (COLLAPSIBLE)
local SecPetEgg = Window:Section({ Title = "Pet & Egg", Icon = "egg", Opened = false })
local TabLoadout = SecPetEgg:Tab({ Title = "Loadout", Icon = "users" })
local TabPet     = SecPetEgg:Tab({ Title = "Pet",     Icon = "paw-print" })
local TabEgg     = SecPetEgg:Tab({ Title = "Egg",     Icon = "egg" })

-- D. Shop = Tab Section (COLLAPSIBLE)
local SecShopCraft = Window:Section({ Title = "Shop", Icon = "shopping-bag", Opened = false })
local TabShopCraft_Shop   = SecShopCraft:Tab({ Title = "Shop",   Icon = "shopping-cart" })
local TabShopCraft_Craft  = SecShopCraft:Tab({ Title = "Craft",  Icon = "settings" })

-- E. Event = Tab Section (COLLAPSIBLE)
local SecEvent = Window:Section({ Title = "Event", Icon = "calendar-days", Opened = false })
local TabEvent = SecEvent:Tab({ Title = "Auto Event & Collect", Icon = "zap" })

-- F. Misc = Tab Section (COLLAPSIBLE)
local SecMisc = Window:Section({ Title = "Misc", Icon = "settings-2", Opened = false })
local TabMisc_AUE = SecMisc:Tab({ Title = "AUE", Icon = "refresh-ccw" })
local TabMisc_ESP = SecMisc:Tab({ Title = "ESP", Icon = "eye" })

--======================================================
-- Save references
--======================================================
--======================================================
-- Save references (preserve Controls registry)
--======================================================
local _oldUI = rawget(getgenv(), "RemnantUI")
local _controls = _oldUI and _oldUI.Controls or {}

getgenv().RemnantUI = {
    Window = Window,
    Tabs = {
        Home            = TabHome,
        -- Farm
        Farm_Plants     = TabFarm_Plants,
        Farm_Sprinkler  = TabFarm_Sprinkler,
        Farm_Shovel     = TabFarm_Shovel,
        -- Pet & Egg
        Loadout         = TabLoadout,
        TeamSwitch      = TabLoadout, -- alias lama supaya kompatibel
        Pet             = TabPet,
        Egg             = TabEgg,
        -- Shop & Craft
        Shop_Shop       = TabShopCraft_Shop,
        Shop_Craft      = TabShopCraft_Craft,
        -- Event
        Event           = TabEvent,
        -- Misc
        Misc_AUE        = TabMisc_AUE,
        Misc_ESP        = TabMisc_ESP,
    },
    Sections = { Farm = SecFarm, PetEgg = SecPetEgg, Shop = SecShopCraft, Event = SecEvent, Misc = SecMisc },
    Controls = _controls, -- <== penting: bawa balik registry
}

--======================================================
-- Global State
--======================================================
getgenv().RemnantState = getgenv().RemnantState or {}
local State = getgenv().RemnantState

-- Plants
State.Plants = State.Plants or {
    SeedsSelected       = {},
    PositionsSelected   = {},     -- multi: Player/Random/Custom
    AutoPlant           = false,

    FruitsSelected      = {},
    WhiteMutation       = {},
    BlackMutation       = {},
    WeightThreshold     = nil,
    AutoCollect         = false,

    MovePlantSelected   = nil,    -- single
    MovePositions       = {},     -- multi: Player/Random
    AutoMove            = false,
}

-- Sprinkler
State.Sprinkler = State.Sprinkler or {
    SprinklersSelected  = {},
    PositionSelected    = nil,    -- "Player" | "Nearest Plant"
    AutoPlace           = false,  -- explicit toggle kept in UI below
}

-- Shovel
State.Shovel = State.Shovel or {
    FruitsSelected      = {},
    MutationsSelected   = {},     -- whitelist
    BlacklistMutations  = {},     -- blacklist
    WeightThreshold     = nil,
    AutoShovelFruit     = false,

    SprinklersSelected  = {},
    AutoShovelSprinkler = false,

    PlantsSelected      = {},
    AutoShovelPlant     = false,
}

-- Home (Changelog, Server tools, Hop Server)
State.Home = State.Home or {
    ChangelogText  = "-",
    JobID          = "",
    AutoRejoin     = false,
    HopServerCount = nil,   -- angka
    AutoHopServer  = false,
}

-- Webhook (dipindah ke Tab Home)
State.Webhook = State.Webhook or {
    URL              = "",
    Message          = "",
    WhitelistPet     = {},  -- multi select (pet dari hatch egg)
    WeightThreshold  = nil,
    Delay            = nil,
    Enable           = false,
    DisconnectNotify = false,
}


-- Loadout / Pet / Egg
State.Loadout = State.Loadout or { Selected = nil }

State.Pet = State.Pet or {
    PetsForBoost        = {},     BoostsSelected = {},   AutoBoost  = false,
    PetsForFav          = {},     FavWeightThresh = nil, FavAgeThresh = nil, AutoFavorite = false,
    PetsForSell         = {},     SellBlacklistMutation = {}, SellWeightThresh = nil, SellAgeThresh = nil, AutoSell = false,
}

State.Egg = State.Egg or {
    EggsToPlace = {}, SlotEgg = nil, AutoPlaceEgg = false,
    EggsToHatch = {}, HatchDelay = nil, AutoHatchEgg = false,
}

-- Shop: Buy
State.Shop = State.Shop or {
    Seed = { Selected = {}, Auto = false },
    Gear = { Selected = {}, Auto = false },
    Egg  = { Selected = {}, Auto = false },
    Merchant = { Merchants = {}, Items = {}, Auto = false },
    Cosmetic = { Selected = {}, Auto = false },
    Event = { Items = {}, Auto = false },
}

-- Craft
State.Craft = State.Craft or {
    Gear  = { Selected = {}, Auto = false },
    Seed  = { Selected = {}, Auto = false },
    Event = { Selected = {}, Auto = false },
}

-- Event (Submit & Collect)
State.Event = State.Event or {
    FruitsSelected    = {},
    WhiteMutation     = {},
    BlackMutation     = {},
    AutoSubmit        = false,
    AutoCollectReward = false,
}

-- ESP (Misc)
State.ESP = State.ESP or {
    FruitsSelected   = {},
    MutationsSelected= {},
    WeightThreshold  = nil,
    ESPFruit         = false,
    ESPEgg           = false,
    ESPCrate         = false,
    ESPPet           = false,
}

-- ===== Feature registry (URL modul eksternal) =====
getgenv().RemnantFeatures = getgenv().RemnantFeatures or {}
getgenv().RemnantFeatures.AutoCollectFruit = "https://raw.githubusercontent.com/hailazra/Development/refs/heads/main/Features/AutoCollect.lua"  -- ganti ke raw URL kamu

-- ===== API helper utk isi dropdown dari modul =====
do
  local UI  = getgenv().RemnantUI
  local C   = UI.Controls
  local function setValues(ctrl, values)
    if ctrl and ctrl.SetValues and type(values) == "table" then
      ctrl:SetValues(values)
    end
  end

-- ===== Handler: Auto Collect Fruit =====
local function buildFruitCFGFromState()
  local S = getgenv().RemnantState
  local P = S.Plants
  return {
    Run               = true,
    ScanInterval      = 0.10,
    RateLimitPerFruit = 1.25,
    MaxConcurrent     = 3,
    UseOwnerFilter    = true,
    SelectedFruits    = P.FruitsSelected or {},
    WeightMin         = tonumber(P.WeightThreshold) or 0.0,  -- dari 1 input => pakai sbg Min
    WeightMax         = math.huge,                           -- Max dibebaskan
    MutationWhitelist = P.WhiteMutation or {},
    MutationBlacklist = P.BlackMutation or {},
    Debug             = true,
  }
end

local function startAutoCollectFruit()
  local G = getgenv()
  G.FruitCollectCFG = buildFruitCFGFromState()

  local url = (G.RemnantFeatures and G.RemnantFeatures.AutoCollectFruit)
              or "https://raw.githubusercontent.com/hailazra/Development/refs/heads/main/Features/AutoCollect.lua"
  local ok, err = pcall(function()
    loadstring(game:HttpGet(url))()
  end)
  if not ok then warn("[AutoCollectFruit] load error:", err) return end

  -- Setelah modul load, sinkronisasi list dropdown dari modul (jika modul expose)
  local FC = rawget(G, "FruitCollector")
  if FC and FC.Lists then
    local lists = FC.Lists
    if lists.FruitNames then getgenv().RemnantUI.API.Farm.SetFruitList(lists.FruitNames) end
    if lists.Mutations  then getgenv().RemnantUI.API.Farm.SetMutationLists(lists.Mutations) end
  end

  -- Stop otomatis kalau GUI ditutup
  local ui = rawget(G, "RemnantUI")
  if ui and ui.StopAllEvent then
    -- modulmu sudah mendengar StopAllEvent; tidak perlu apa-apa di sini
  end
end

local function stopAutoCollectFruit()
  local G = getgenv()
  if G.FruitCollector and G.FruitCollector.Kill then
    G.FruitCollector.Kill()
  end
end

--======================================================
-- ====================== HOME =========================
--======================================================
local UI = getgenv().RemnantUI
local TabHomeRef = UI.Tabs.Home

-- Changelog
TabHomeRef:Section({ Title = "Changelog", TextXAlignment = "Left", TextSize = 17 })

local CH_Paragraph
if TabHomeRef.Paragraph then
    CH_Paragraph = TabHomeRef:Paragraph({
        Title   = "Changes",
        Content = State.Home.ChangelogText
    })
else
    -- fallback kalau Paragraph belum ada di loader kamu
    CH_Paragraph = TabHomeRef:Label({
        Title   = "Changes",
        Content = State.Home.ChangelogText
    })
end

TabHomeRef:Button({
    Title = ".devlogic Discord",
    Icon  = "message-circle",
    Callback = function()
    setclipboard("https://discord.gg/TqXwyyxtR3") -- ganti ke invite kamu
end
})

-- Server
TabHomeRef:Section({ Title = "Server", TextXAlignment = "Left", TextSize = 17 })

local IN_Server_JobID = TabHomeRef:Input({
    Title = "JobID Server",
    Placeholder = "e.g. 00000000-0000-0000-0000-000000000000",
    Callback = function(text)
        State.Home.JobID = tostring(text or "")
    end
})

TabHomeRef:Button({
    Title = "Join Server",
    Icon  = "log-in",
    Callback = function()
    local TeleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local jobId = tostring(State.Home.JobID or "")
    if jobId ~= "" then
        TeleportService:TeleportToPlaceInstance(placeId, jobId)
    end
end
})

TabHomeRef:Button({
    Title = "Rejoin This Server",
    Icon  = "rotate-ccw",
   Callback = function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end
})

TabHomeRef:Button({
    Title = "Auto Rejoin This Server",
    Icon  = "refresh-ccw",
    Callback = function()
    State.Home.AutoRejoin = not State.Home.AutoRejoin
    if State.Home.AutoRejoin then
        if C and C.__AutoRejoin_Task and task.cancel then
            task.cancel(C.__AutoRejoin_Task)
        end
        C.__AutoRejoin_Task = task.spawn(function()
            while State.Home.AutoRejoin do
                task.wait(60) -- cek tiap 60s; atur sesuai butuh
                -- contoh kondisi: kalau player sendirian / latency tinggi, dll
                -- di sini kita simple rejoin paksa:
                local TeleportService = game:GetService("TeleportService")
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
                break
            end
        end)
    else
        if C and C.__AutoRejoin_Task and task.cancel then
            task.cancel(C.__AutoRejoin_Task)
            C.__AutoRejoin_Task = nil
        end
    end
end
})

-- Copy JobID
TabHomeRef:Button({
    Title = "Copy JobID",
    Icon  = "clipboard",
    Callback = function()
    State.Home.JobID = game.JobId
    setclipboard(State.Home.JobID)
end
})

-- Hop Server
TabHomeRef:Section({ Title = "Hop Server", TextXAlignment = "Left", TextSize = 17 })

local IN_Hop_Count = TabHomeRef:Input({
    Title = "Server",
    Placeholder = "e.g. 1 (jumlah hop)",
    Numeric = true,
    Callback = function(v)
        State.Home.HopServerCount = tonumber(v)
    end
})

local TG_AutoHop = TabHomeRef:Toggle({
    Title = "Auto Hop Server",
    Default = false,
    Callback = function(on)
        State.Home.AutoHopServer = on
        -- TODO: mulai/stop auto hop
    end
})

-- Webhook (dipindah ke Home)
TabHomeRef:Section({ Title = "Webhook", TextXAlignment = "Left", TextSize = 17 })

local IN_Webhook_URL = TabHomeRef:Input({
    Title = "Webhook URL",
    Placeholder = "https://...",
    Callback = function(text)
        State.Webhook.URL = tostring(text or "")
    end
})

local IN_Webhook_Message = TabHomeRef:Input({
    Title = "Message",
    Placeholder = "Template pesan",
    Callback = function(text)
        State.Webhook.Message = tostring(text or "")
    end
})

local DD_Webhook_WhitelistPet = TabHomeRef:Dropdown({
    Title = "Whitelist Pet",
    Desc  = "Pet yang dipilih di sini berasal dari hasil hatch egg.",
    Multi = true,
    Values = {},
    Default = {},
    Placeholder = "Choose pets...",
    Callback = function(list)
        State.Webhook.WhitelistPet = list
    end
})

local IN_Webhook_Weight = TabHomeRef:Input({
    Title = "Weight Threshold",
    Placeholder = "e.g. 3 (kg)",
    Numeric = true,
    Callback = function(v)
        State.Webhook.WeightThreshold = tonumber(v)
    end
})

local IN_Webhook_Delay = TabHomeRef:Input({
    Title = "Delay",
    Placeholder = "e.g. 5 (seconds)",
    Numeric = true,
    Callback = function(v)
        State.Webhook.Delay = tonumber(v)
    end
})

local TG_Webhook_Enable = TabHomeRef:Toggle({
    Title = "Enable Webhook",
    Default = false,
    Callback = function(on)
        State.Webhook.Enable = on
        -- TODO: start/stop proses kirim webhook
    end
})

local TG_Webhook_DC = TabHomeRef:Toggle({
    Title = "Disconnection Webhook",
    Default = false,
    Callback = function(on)
        State.Webhook.DisconnectNotify = on
        -- TODO: handler disconnect -> kirim webhook
    end
})

--======================================================
-- ==============  FARM: Plants & Fruits  ==============
--======================================================
local TabPlants     = UI.Tabs.Farm_Plants
local TabSprinkler  = UI.Tabs.Farm_Sprinkler
local TabShovel     = UI.Tabs.Farm_Shovel

-- "Plant"
TabPlants:Section({ Title = "Plant", TextXAlignment = "Left", TextSize = 17 })
local DD_Plant_Seed = TabPlants:Dropdown({
    Title = "Select Seed", Multi = true, Values = {}, Default = {}, Placeholder = "Choose seeds...",
    Callback = function(list) State.Plants.SeedsSelected = list end
})
local DD_Plant_Pos = TabPlants:Dropdown({
    Title = "Position", Multi = false, Values = { "Player", "Random" }, Default = { "Player" },
    Callback = function(list) State.Plants.PositionsSelected = list end
})
local TG_AutoPlant = TabPlants:Toggle({
    Title = "Auto Plant", Default = false,
    Callback = function(on) State.Plants.AutoPlant = on end
})

-- "Harvest"
TabPlants:Section({ Title = "Harvest", TextXAlignment = "Left", TextSize = 17 })
local DD_Harvest_Fruit = TabPlants:Dropdown({
    Title = "Select Fruit", Multi = true, Values = {}, Default = {}, Placeholder = "Choose fruits...",
   Callback = function(list)
  State.Plants.FruitsSelected = list
  if getgenv().FruitCollectCFG then getgenv().FruitCollectCFG.SelectedFruits = list end
end
})
local DD_Harvest_White = TabPlants:Dropdown({
    Title = "Whitelist Mutation", Multi = true, Values = {}, Default = {}, Placeholder = "Whitelist mutations...",
    Callback = function(list)
  State.Plants.WhiteMutation = list
  if getgenv().FruitCollectCFG then getgenv().FruitCollectCFG.MutationWhitelist = list end
end
})
local DD_Harvest_Black = TabPlants:Dropdown({
    Title = "Blacklist Mutation", Multi = true, Values = {}, Default = {}, Placeholder = "Blacklist mutations...",
    Callback = function(list)
  State.Plants.BlackMutation = list
  if getgenv().FruitCollectCFG then getgenv().FruitCollectCFG.MutationBlacklist = list end
end
})
local IN_Harvest_Weight = TabPlants:Input({
    Title = "Weight Threshold", Placeholder = "e.g. 3 (kg)", Numeric = true,
    Callback = function(v)
  State.Plants.WeightThreshold = tonumber(v)
  if getgenv().FruitCollectCFG then getgenv().FruitCollectCFG.WeightMin = tonumber(v) or 0.0 end
end
})
local TG_AutoCollect = TabPlants:Toggle({
  Title = "Auto Collect", Default = false,
  Callback = function(on)
    State.Plants.AutoCollect = on
    if on then
      startAutoCollectFruit()
    else
      stopAutoCollectFruit()
    end
  end
})


-- "Move Plant"
TabPlants:Section({ Title = "Move Plant", TextXAlignment = "Left", TextSize = 17 })
local DD_Move_Select = TabPlants:Dropdown({
    Title = "Select Plant", Multi = false, Values = {}, Default = nil, Placeholder = "Choose a plant...",
    Callback = function(v) State.Plants.MovePlantSelected = v end
})
local DD_Move_Pos = TabPlants:Dropdown({
    Title = "Position", Multi = true, Values = { "Player", "Random" }, Default = { "Player" },
    Callback = function(list) State.Plants.MovePositions = list end
})
local TG_AutoMove = TabPlants:Toggle({
    Title = "Auto Move", Default = false,
    Callback = function(on) State.Plants.AutoMove = on end
})

--======================================================
-- ==============  FARM: Sprinkler  ====================
--======================================================
TabSprinkler:Section({ Title = "Auto Place", TextXAlignment = "Left", TextSize = 17 })
local DD_Sprinkler_Select = TabSprinkler:Dropdown({
    Title = "Select Sprinkler",
    Multi = true,
    Values = {},
    Default = {},
    Placeholder = "Choose sprinkler types...",
    Callback = function(list)
        State.Sprinkler.SprinklersSelected = list
    end
})
local DD_Sprinkler_Pos = TabSprinkler:Dropdown({
    Title = "Position",
    Multi = false,
    Values = { "Player", "Nearest Plant" },
    Default = "Nearest Plant",
    Callback = function(v)
        State.Sprinkler.PositionSelected = v
    end
})
local TG_Sprinkler_AutoPlace = TabSprinkler:Toggle({
    Title   = "Auto Place Sprinkler",
    Desc    = "Letakkan sprinkler otomatis di plot (default OFF).",
    Default = false,
    Callback = function(on)
        State.Sprinkler.AutoPlace = on
    end
})

--======================================================
-- ==============  FARM: Shovel  =======================
--======================================================
TabShovel:Section({ Title = "Fruit", TextXAlignment = "Left", TextSize = 17 })
local DD_Shovel_Fruit = TabShovel:Dropdown({
    Title = "Select Fruit", Multi = true, Values = {}, Default = {}, Placeholder = "Choose fruits...",
    Callback = function(list) State.Shovel.FruitsSelected = list end
})
local DD_Shovel_WhiteMut = TabShovel:Dropdown({
    Title = "Select Mutation", Multi = true, Values = {}, Default = {}, Placeholder = "Whitelist mutations...",
    Callback = function(list) State.Shovel.MutationsSelected = list end
})
local DD_Shovel_BlackMut = TabShovel:Dropdown({
    Title = "Blacklist Mutation", Multi = true, Values = {}, Default = {}, Placeholder = "Blacklist mutations...",
    Callback = function(list) State.Shovel.BlacklistMutations = list end
})
local IN_Shovel_Weight = TabShovel:Input({
    Title = "Weight Threshold", Placeholder = "e.g. 3 (kg)", Numeric = true,
    Callback = function(v) State.Shovel.WeightThreshold = tonumber(v) end
})
local TG_Shovel_Fruit = TabShovel:Toggle({
    Title = "Shovel Fruit", Default = false,
    Callback = function(on) State.Shovel.AutoShovelFruit = on end
})

TabShovel:Section({ Title = "Sprinkler", TextXAlignment = "Left", TextSize = 17 })
local DD_Shovel_Sprinkler = TabShovel:Dropdown({
    Title = "Select Sprinkler", Multi = true, Values = {}, Default = {}, Placeholder = "Choose sprinklers...",
    Callback = function(list) State.Shovel.SprinklersSelected = list end
})
local TG_Shovel_Sprinkler = TabShovel:Toggle({
    Title = "Shovel Sprinkler", Default = false,
    Callback = function(on) State.Shovel.AutoShovelSprinkler = on end
})

TabShovel:Section({ Title = "Plant", TextXAlignment = "Left", TextSize = 17 })
local DD_Shovel_Plant = TabShovel:Dropdown({
    Title = "Select Plant", Multi = true, Values = {}, Default = {}, Placeholder = "Choose plants...",
    Callback = function(list) State.Shovel.PlantsSelected = list end
})
local TG_Shovel_Plant = TabShovel:Toggle({
    Title = "Shovel Plant", Default = false,
    Callback = function(on) State.Shovel.AutoShovelPlant = on end
})

--======================================================
-- ==============  PET & EGG: Loadout  =================
--======================================================
local TabLoadoutRef = UI.Tabs.Loadout
TabLoadoutRef:Section({ Title = "Loadout", TextXAlignment = "Left", TextSize = 17 })
local DD_Loadout_Select = TabLoadoutRef:Dropdown({
    Title = "Select Loadout", Multi = false, Values = {}, Default = nil, Placeholder = "Choose a loadout...",
    Callback = function(v) State.Loadout.Selected = v end
})
TabLoadoutRef:Button({
    Title = "Switch Loadout", Icon = "swap-horizontal",
    Callback = function()
        -- TODO: panggil remote swap berdasarkan State.Loadout.Selected
    end
})

--======================================================
-- ==============  PET & EGG: Pet  =====================
--======================================================
local TabPetRef = UI.Tabs.Pet

TabPetRef:Section({ Title = "Boost Pet", TextXAlignment = "Left", TextSize = 17 })
local DD_Pet_SelectBoost = TabPetRef:Dropdown({
    Title = "Select Pet", Multi = true, Values = {}, Default = {}, Placeholder = "Choose pets...",
    Callback = function(list) State.Pet.PetsForBoost = list end
})
local DD_Pet_Boost = TabPetRef:Dropdown({
    Title = "Select Boost", Multi = true, Values = {}, Default = {}, Placeholder = "Choose boosts...",
    Callback = function(list) State.Pet.BoostsSelected = list end
})
local TG_Pet_AutoBoost = TabPetRef:Toggle({
    Title = "Auto Boost Pet", Default = false,
    Callback = function(on) State.Pet.AutoBoost = on end
})

TabPetRef:Section({ Title = "Favorite Pet", TextXAlignment = "Left", TextSize = 17 })
local DD_Pet_SelectFav = TabPetRef:Dropdown({
    Title = "Select Pet", Multi = true, Values = {}, Default = {}, Placeholder = "Choose pets...",
    Callback = function(list) State.Pet.PetsForFav = list end
})
local IN_Pet_FavWeight = TabPetRef:Input({
    Title = "Weight Threshold", Placeholder = "e.g. 3 (kg)", Numeric = true,
    Callback = function(v) State.Pet.FavWeightThresh = tonumber(v) end
})
local IN_Pet_FavAge = TabPetRef:Input({
    Title = "Age Threshold", Placeholder = "e.g. 2 (age)", Numeric = true,
    Callback = function(v) State.Pet.FavAgeThresh = tonumber(v) end
})
local TG_Pet_AutoFav = TabPetRef:Toggle({
    Title = "Auto Favorite Pet", Default = false,
    Callback = function(on) State.Pet.AutoFavorite = on end
})

TabPetRef:Section({ Title = "Sell Pet", TextXAlignment = "Left", TextSize = 17 })
local DD_Pet_SelectSell = TabPetRef:Dropdown({
    Title = "Select Pet", Multi = true, Values = {}, Default = {}, Placeholder = "Choose pets...",
    Callback = function(list) State.Pet.PetsForSell = list end
})
local DD_Pet_Blacklist = TabPetRef:Dropdown({
    Title = "Blacklist Pet Mutation", Multi = true, Values = {}, Default = {}, Placeholder = "Blacklist mutations...",
    Callback = function(list) State.Pet.SellBlacklistMutation = list end
})
local IN_Pet_SellWeight = TabPetRef:Input({
    Title = "Weight Threshold", Placeholder = "e.g. 3 (kg)", Numeric = true,
    Callback = function(v) State.Pet.SellWeightThresh = tonumber(v) end
})
local IN_Pet_SellAge = TabPetRef:Input({
    Title = "Age Threshold", Placeholder = "e.g. 2 (age)", Numeric = true,
    Callback = function(v) State.Pet.SellAgeThresh = tonumber(v) end
})
local TG_Pet_AutoSell = TabPetRef:Toggle({
    Title = "Auto Sell Pet", Default = false,
    Callback = function(on) State.Pet.AutoSell = on end
})

--======================================================
-- ==============  PET & EGG: Egg  =====================
--======================================================
local TabEggRef = UI.Tabs.Egg

TabEggRef:Section({ Title = "Place Egg", TextXAlignment = "Left", TextSize = 17 })
local DD_Egg_SelectPlace = TabEggRef:Dropdown({
    Title = "Select Egg", Multi = true, Values = {}, Default = {}, Placeholder = "Choose eggs...",
    Callback = function(list) State.Egg.EggsToPlace = list end
})
local IN_Egg_Slot = TabEggRef:Input({
    Title = "Slot Egg", Placeholder = "e.g. 8", Numeric = true,
    Callback = function(v) State.Egg.SlotEgg = tonumber(v) end
})
TabEggRef:Button({
    Title = "Refresh Egg", Icon = "refresh-ccw",
    Callback = function()
        -- TODO: refresh daftar egg (inventory)
    end
})
local TG_Egg_AutoPlace = TabEggRef:Toggle({
    Title = "Auto Place Egg", Default = false,
    Callback = function(on) State.Egg.AutoPlaceEgg = on end
})

TabEggRef:Section({ Title = "Hatch Egg", TextXAlignment = "Left", TextSize = 17 })
local DD_Egg_SelectHatch = TabEggRef:Dropdown({
    Title = "Select Egg", Multi = true, Values = {}, Default = {}, Placeholder = "Choose eggs...",
    Callback = function(list) State.Egg.EggsToHatch = list end
})
local IN_Egg_HatchDelay = TabEggRef:Input({
    Title = "Hatch Delay", Placeholder = "e.g. 5 (seconds)", Numeric = true,
    Callback = function(v) State.Egg.HatchDelay = tonumber(v) end
})
local TG_Egg_AutoHatch = TabEggRef:Toggle({
    Title = "Auto Hatch Egg", Default = false,
    Callback = function(on) State.Egg.AutoHatchEgg = on end
})

--======================================================
-- ================= SHOP: BUY  ========================
--======================================================
local TabShopRef = UI.Tabs.Shop_Shop

-- Seed
TabShopRef:Section({ Title = "Seed", TextXAlignment = "Left", TextSize = 17 })
local DD_Shop_Seed = TabShopRef:Dropdown({
    Title = "Select Seed", Multi = true, Values = {}, Default = {}, Placeholder = "Choose seeds...",
    Callback = function(list) State.Shop.Seed.Selected = list end
})
local TG_Shop_AutoSeed = TabShopRef:Toggle({
    Title = "Auto Buy Seed", Default = false,
    Callback = function(on) State.Shop.Seed.Auto = on end
})

-- Gear
TabShopRef:Section({ Title = "Gear", TextXAlignment = "Left", TextSize = 17 })
local DD_Shop_Gear = TabShopRef:Dropdown({
    Title = "Select Gear", Multi = true, Values = {}, Default = {}, Placeholder = "Choose gear...",
    Callback = function(list) State.Shop.Gear.Selected = list end
})
local TG_Shop_AutoGear = TabShopRef:Toggle({
    Title = "Auto Buy Gear", Default = false,
    Callback = function(on) State.Shop.Gear.Auto = on end
})

-- Egg
TabShopRef:Section({ Title = "Egg", TextXAlignment = "Left", TextSize = 17 })
local DD_Shop_Egg = TabShopRef:Dropdown({
    Title = "Select Egg", Multi = true, Values = {}, Default = {}, Placeholder = "Choose eggs...",
    Callback = function(list) State.Shop.Egg.Selected = list end
})
local TG_Shop_AutoEgg = TabShopRef:Toggle({
    Title = "Auto Buy Egg", Default = false,
    Callback = function(on) State.Shop.Egg.Auto = on end
})

-- Merchant
TabShopRef:Section({ Title = "Merchant", TextXAlignment = "Left", TextSize = 17 })
local DD_Shop_Merchant = TabShopRef:Dropdown({
    Title = "Select Merchant", Multi = true, Values = {}, Default = {}, Placeholder = "Choose merchants...",
    Callback = function(list) State.Shop.Merchant.Merchants = list end
})
local DD_Shop_MerchantItem = TabShopRef:Dropdown({
    Title = "Select Item", Multi = true, Values = {}, Default = {}, Placeholder = "Choose items...",
    Callback = function(list) State.Shop.Merchant.Items = list end
})
local TG_Shop_AutoMerchant = TabShopRef:Toggle({
    Title = "Auto Buy Merchant Item", Default = false,
    Callback = function(on) State.Shop.Merchant.Auto = on end
})

-- Cosmetic
TabShopRef:Section({ Title = "Cosmetic", TextXAlignment = "Left", TextSize = 17 })
local DD_Shop_Cosmetic = TabShopRef:Dropdown({
    Title = "Select Cosmetic", Multi = true, Values = {}, Default = {}, Placeholder = "Choose cosmetics...",
    Callback = function(list) State.Shop.Cosmetic.Selected = list end
})
local TG_Shop_AutoCosmetic = TabShopRef:Toggle({
    Title = "Auto Buy Cosmetic", Default = false,
    Callback = function(on) State.Shop.Cosmetic.Auto = on end
})

-- Event
TabShopRef:Section({ Title = "Event", TextXAlignment = "Left", TextSize = 17 })
local DD_Shop_EventItem = TabShopRef:Dropdown({
    Title = "Select Item", Multi = true, Values = {}, Default = {}, Placeholder = "Choose event items...",
    Callback = function(list) State.Shop.Event.Items = list end
})
local TG_Shop_AutoEvent = TabShopRef:Toggle({
    Title = "Auto Buy Event Item", Default = false,
    Callback = function(on) State.Shop.Event.Auto = on end
})

--======================================================
-- ================= CRAFT: MAKE  ======================
--======================================================
local TabCraftRef = UI.Tabs.Shop_Craft

-- Gear
TabCraftRef:Section({ Title = "Gear", TextXAlignment = "Left", TextSize = 17 })
local DD_Craft_Gear = TabCraftRef:Dropdown({
    Title = "Select Gear", Multi = true, Values = {}, Default = {}, Placeholder = "Choose craftable gear...",
    Callback = function(list) State.Craft.Gear.Selected = list end
})
local TG_Craft_AutoGear = TabCraftRef:Toggle({
    Title = "Auto Craft Gear", Default = false,
    Callback = function(on) State.Craft.Gear.Auto = on end
})

-- Seed
TabCraftRef:Section({ Title = "Seed", TextXAlignment = "Left", TextSize = 17 })
local DD_Craft_Seed = TabCraftRef:Dropdown({
    Title = "Select Seed", Multi = true, Values = {}, Default = {}, Placeholder = "Choose craftable seeds...",
    Callback = function(list) State.Craft.Seed.Selected = list end
})
local TG_Craft_AutoSeed = TabCraftRef:Toggle({
    Title = "Auto Craft Seed", Default = false,
    Callback = function(on) State.Craft.Seed.Auto = on end
})

-- Event
TabCraftRef:Section({ Title = "Event", TextXAlignment = "Left", TextSize = 17 })
local DD_Craft_Event = TabCraftRef:Dropdown({
    Title = "Select Craftable", Multi = true, Values = {}, Default = {}, Placeholder = "Choose craftables...",
    Callback = function(list) State.Craft.Event.Selected = list end
})
local TG_Craft_AutoEvent = TabCraftRef:Toggle({
    Title = "Auto Craft Event", Default = false,
    Callback = function(on) State.Craft.Event.Auto = on end
})

--======================================================
-- ================= EVENT: Auto Event & Collect =======
--======================================================
local TabEventRef = UI.Tabs.Event

TabEventRef:Section({ Title = "Auto Submit", TextXAlignment = "Left", TextSize = 17 })

local DD_Event_Fruit = TabEventRef:Dropdown({
    Title = "Select Fruit",
    Multi = true,
    Values = {},
    Default = {},
    Placeholder = "Choose fruits...",
    Callback = function(list)
        State.Event.FruitsSelected = list
    end
})

local DD_Event_White = TabEventRef:Dropdown({
    Title = "Whitelist Mutation",
    Multi = true,
    Values = {},
    Default = {},
    Placeholder = "Whitelist mutations...",
    Callback = function(list)
        State.Event.WhiteMutation = list
    end
})

local DD_Event_Black = TabEventRef:Dropdown({
    Title = "Blacklist Mutation",
    Multi = true,
    Values = {},
    Default = {},
    Placeholder = "Blacklist mutations...",
    Callback = function(list)
        State.Event.BlackMutation = list
    end
})

local TG_Event_AutoSubmit = TabEventRef:Toggle({
    Title = "Auto Submit",
    Default = false,
    Callback = function(on)
        State.Event.AutoSubmit = on
    end
})

local TG_Event_AutoCollect = TabEventRef:Toggle({
    Title = "Auto Collect Reward",
    Default = false,
    Callback = function(on)
        State.Event.AutoCollectReward = on
    end
})

-- ======================================================
-- ==============  MISC : ESP  ==========================
-- ======================================================
local TabESPRef = UI.Tabs.Misc_ESP

-- "Fruit" section
TabESPRef:Section({ Title = "Fruit", TextXAlignment = "Left", TextSize = 17 })

local DD_ESP_Fruit = TabESPRef:Dropdown({
  Title = "Select Fruit",
  Multi = true,
  Values = {},
  Default  = {},        -- was Default = {}
  Placeholder = "Choose fruits...",
  Callback = function(list) State.ESP.FruitsSelected = list end
})

local DD_ESP_Mutation = TabESPRef:Dropdown({
  Title = "Select Mutation",
  Multi = true,
  Values = {},
  Default  = {},
  Callback = function(list) State.ESP.MutationsSelected = list end
})

local IN_ESP_Weight = TabESPRef:Input({
  Title = "Weight Threshold (kg)",
  Value = "",  -- string; parse nanti
  Callback = function(v) State.ESP.WeightThreshold = tonumber(v) end
})

local TG_ESP_Fruit = TabESPRef:Toggle({
  Title = "ESP: Fruit",
  Value = false, -- was Default
  Callback = function(on) State.ESP.ESPFruit = on end
})

-- "Egg & Crate" section
TabESPRef:Section({ Title = "Egg & Crate", TextXAlignment = "Left", TextSize = 17 })

local TG_ESP_Egg = TabESPRef:Toggle({
    Title = "ESP Egg",
    Default = false,
    Callback = function(on)
        State.ESP.ESPEgg = on
    end
})

local TG_ESP_Crate = TabESPRef:Toggle({
    Title = "ESP Crate",
    Default = false,
    Callback = function(on)
        State.ESP.ESPCrate = on
    end
})

-- "Pet" section
TabESPRef:Section({ Title = "Pet", TextXAlignment = "Left", TextSize = 17 })

local TG_ESP_Pet = TabESPRef:Toggle({
    Title = "ESP Pet",
    Default = false,
    Callback = function(on)
        State.ESP.ESPPet = on
    end
})

--======================================================
-- Register Controls (agar modul luar bisa akses elemen UI)
--======================================================
local UIRef = getgenv().RemnantUI
local C = UIRef.Controls

-- Plants & Fruits
C.DD_Plant_Seed       = DD_Plant_Seed
C.DD_Harvest_Fruit    = DD_Harvest_Fruit
C.DD_Harvest_White    = DD_Harvest_White
C.DD_Harvest_Black    = DD_Harvest_Black
C.DD_Move_Select      = DD_Move_Select
C.TG_AutoPlant        = TG_AutoPlant
C.TG_AutoCollect      = TG_AutoCollect
C.TG_AutoMove         = TG_AutoMove

-- Sprinkler
C.DD_Sprinkler_Select = DD_Sprinkler_Select
C.DD_Sprinkler_Pos    = DD_Sprinkler_Pos
C.TG_Sprinkler_AutoPlace = TG_Sprinkler_AutoPlace

-- Shovel
C.DD_Shovel_Fruit     = DD_Shovel_Fruit
C.DD_Shovel_WhiteMut  = DD_Shovel_WhiteMut
C.DD_Shovel_BlackMut  = DD_Shovel_BlackMut
C.DD_Shovel_Sprinkler = DD_Shovel_Sprinkler
C.DD_Shovel_Plant     = DD_Shovel_Plant
C.TG_Shovel_Fruit     = TG_Shovel_Fruit
C.TG_Shovel_Sprinkler = TG_Shovel_Sprinkler
C.TG_Shovel_Plant     = TG_Shovel_Plant

-- Loadout
C.DD_Loadout_Select   = DD_Loadout_Select

-- Pet
C.DD_Pet_SelectBoost  = DD_Pet_SelectBoost
C.DD_Pet_Boost        = DD_Pet_Boost
C.DD_Pet_SelectFav    = DD_Pet_SelectFav
C.DD_Pet_SelectSell   = DD_Pet_SelectSell
C.DD_Pet_Blacklist    = DD_Pet_Blacklist
C.TG_Pet_AutoBoost    = TG_Pet_AutoBoost
C.TG_Pet_AutoFav      = TG_Pet_AutoFav
C.TG_Pet_AutoSell     = TG_Pet_AutoSell

-- Egg
C.DD_Egg_SelectPlace  = DD_Egg_SelectPlace
C.DD_Egg_SelectHatch  = DD_Egg_SelectHatch
C.TG_Egg_AutoPlace    = TG_Egg_AutoPlace
C.TG_Egg_AutoHatch    = TG_Egg_AutoHatch

-- Shop
C.DD_Shop_Seed        = DD_Shop_Seed
C.DD_Shop_Gear        = DD_Shop_Gear
C.DD_Shop_Egg         = DD_Shop_Egg
C.DD_Shop_Merchant    = DD_Shop_Merchant
C.DD_Shop_MerchantItem= DD_Shop_MerchantItem
C.DD_Shop_Cosmetic    = DD_Shop_Cosmetic
C.DD_Shop_EventItem   = DD_Shop_EventItem
C.TG_Shop_AutoSeed    = TG_Shop_AutoSeed
C.TG_Shop_AutoGear    = TG_Shop_AutoGear
C.TG_Shop_AutoEgg     = TG_Shop_AutoEgg
C.TG_Shop_AutoMerchant= TG_Shop_AutoMerchant
C.TG_Shop_AutoCosmetic= TG_Shop_AutoCosmetic
C.TG_Shop_AutoEvent   = TG_Shop_AutoEvent

-- Craft
C.DD_Craft_Gear       = DD_Craft_Gear
C.DD_Craft_Seed       = DD_Craft_Seed
C.DD_Craft_Event      = DD_Craft_Event
C.TG_Craft_AutoGear   = TG_Craft_AutoGear
C.TG_Craft_AutoSeed   = TG_Craft_AutoSeed
C.TG_Craft_AutoEvent  = TG_Craft_AutoEvent

-- Event
C.DD_Event_Fruit      = DD_Event_Fruit
C.DD_Event_White      = DD_Event_White
C.DD_Event_Black      = DD_Event_Black
C.TG_Event_AutoSubmit = TG_Event_AutoSubmit
C.TG_Event_AutoCollect= TG_Event_AutoCollect

-- ESP
C.DD_ESP_Fruit        = DD_ESP_Fruit
C.DD_ESP_Mutation     = DD_ESP_Mutation
C.IN_ESP_Weight       = IN_ESP_Weight
C.TG_ESP_Fruit        = TG_ESP_Fruit
C.TG_ESP_Egg          = TG_ESP_Egg
C.TG_ESP_Crate        = TG_ESP_Crate
C.TG_ESP_Pet          = TG_ESP_Pet


--======================================================
-- API: update isi dropdown dari luar (dinamis)
--======================================================
getgenv().RemnantUI.API       = getgenv().RemnantUI.API or {}
getgenv().RemnantUI.API.Farm  = getgenv().RemnantUI.API.Farm or {}
getgenv().RemnantUI.API.Pet   = getgenv().RemnantUI.API.Pet or {}
getgenv().RemnantUI.API.Egg   = getgenv().RemnantUI.API.Egg or {}
getgenv().RemnantUI.API.Team  = getgenv().RemnantUI.API.Team or {}
getgenv().RemnantUI.API.Shop  = getgenv().RemnantUI.API.Shop or {}
getgenv().RemnantUI.API.Craft = getgenv().RemnantUI.API.Craft or {}
getgenv().RemnantUI.API.Event = getgenv().RemnantUI.API.Event or {}
getgenv().RemnantUI.API.ESP = getgenv().RemnantUI.API.ESP or {}
getgenv().RemnantUI.API.Home    = getgenv().RemnantUI.API.Home or {}
getgenv().RemnantUI.API.Webhook = getgenv().RemnantUI.API.Webhook or {}

local FarmAPI = getgenv().RemnantUI.API.Farm
local PetAPI  = getgenv().RemnantUI.API.Pet
local EggAPI  = getgenv().RemnantUI.API.Egg
local TeamAPI = getgenv().RemnantUI.API.Team
local ShopAPI = getgenv().RemnantUI.API.Shop
local CraftAPI = getgenv().RemnantUI.API.Craft
local EventAPI = getgenv().RemnantUI.API.Event
local ESPAPI = getgenv().RemnantUI.API.ESP
local HomeAPI    = getgenv().RemnantUI.API.Home
local WebhookAPI = getgenv().RemnantUI.API.Webhook
end

-- Home
HomeAPI.SetChangelog = function(text) State.Home.ChangelogText = tostring(text or "-") if CH_Paragraph and CH_Paragraph.SetContent then CH_Paragraph:SetContent(State.Home.ChangelogText)
    end
end
WebhookAPI.SetWhitelistPetList = function(list) if DD_Webhook_WhitelistPet and DD_Webhook_WhitelistPet.SetValues then DD_Webhook_WhitelistPet:SetValues(list or {})
    end
end

-- Farm: Plants
FarmAPI.SetSeedList           = function(list) setValues(DD_Plant_Seed, list) end
FarmAPI.SetFruitList = function(list)
    setValues(DD_Harvest_Fruit, list)
    setValues(DD_Shovel_Fruit,  list)
    setValues(DD_Event_Fruit,   list)
end
FarmAPI.SetMutationLists = function(list)
    setValues(DD_Harvest_White,   list)
    setValues(DD_Harvest_Black,   list)
    setValues(DD_Shovel_WhiteMut, list)
    setValues(DD_Shovel_BlackMut, list)
    setValues(DD_ESP_Mutation,    list)
    setValues(DD_Event_White,     list)
    setValues(DD_Event_Black,     list)
end
FarmAPI.SetWhiteMutationList  = function(list) setValues(DD_Harvest_White, list) end
FarmAPI.SetBlackMutationList  = function(list) setValues(DD_Harvest_Black, list) end
FarmAPI.SetPlantList          = function(list) setValues(DD_Move_Select, list) end

-- Farm: Sprinkler
FarmAPI.SetSprinklerList      = function(list) setValues(DD_Sprinkler_Select, list) end
-- Farm: Shovel
FarmAPI.SetShovelFruitList     = function(list) setValues(DD_Shovel_Fruit, list) end
FarmAPI.SetShovelMutationList  = function(list) setValues(DD_Shovel_WhiteMut, list) end
FarmAPI.SetShovelBlacklistList = function(list) setValues(DD_Shovel_BlackMut, list) end
FarmAPI.SetShovelSprinklerList = function(list) setValues(DD_Shovel_Sprinkler, list) end
FarmAPI.SetShovelPlantList     = function(list) setValues(DD_Shovel_Plant, list) end

-- Team / Loadout
TeamAPI.SetLoadoutList = function(list) setValues(DD_Loadout_Select, list) end

-- Pet
PetAPI.SetPetListForBoost   = function(list) setValues(DD_Pet_SelectBoost, list) end
PetAPI.SetBoostList         = function(list) setValues(DD_Pet_Boost, list) end
PetAPI.SetPetListForFav     = function(list) setValues(DD_Pet_SelectFav, list) end
PetAPI.SetPetListForSell    = function(list) setValues(DD_Pet_SelectSell, list) end
PetAPI.SetSellBlacklistList = function(list) setValues(DD_Pet_Blacklist, list) end

-- Egg
EggAPI.SetEggListForPlace   = function(list) setValues(DD_Egg_SelectPlace, list) end
EggAPI.SetEggListForHatch   = function(list) setValues(DD_Egg_SelectHatch, list) end

-- Shop (Buy)
ShopAPI.SetSeedList         = function(list) setValues(DD_Shop_Seed, list) end
ShopAPI.SetGearList         = function(list) setValues(DD_Shop_Gear, list) end
ShopAPI.SetEggList          = function(list) setValues(DD_Shop_Egg, list) end
ShopAPI.SetMerchantList     = function(list) setValues(DD_Shop_Merchant, list) end
ShopAPI.SetMerchantItemList = function(list) setValues(DD_Shop_MerchantItem, list) end
ShopAPI.SetCosmeticList     = function(list) setValues(DD_Shop_Cosmetic, list) end
ShopAPI.SetEventItemList    = function(list) setValues(DD_Shop_EventItem, list) end

-- Craft
CraftAPI.SetCraftGearList   = function(list) setValues(DD_Craft_Gear, list) end
CraftAPI.SetCraftSeedList   = function(list) setValues(DD_Craft_Seed, list) end
CraftAPI.SetCraftEventList  = function(list) setValues(DD_Craft_Event, list) end

-- Event
EventAPI.SetFruitList          = function(list) if DD_Event_Fruit and DD_Event_Fruit.SetValues then DD_Event_Fruit:SetValues(list) end end
EventAPI.SetWhiteMutationList  = function(list) if DD_Event_White and DD_Event_White.SetValues then DD_Event_White:SetValues(list) end end
EventAPI.SetBlackMutationList  = function(list) if DD_Event_Black and DD_Event_Black.SetValues then DD_Event_Black:SetValues(list) end end

-- ESP
ESPAPI.SetFruitList    = function(list) if DD_ESP_Fruit and DD_ESP_Fruit.SetValues then DD_ESP_Fruit:SetValues(list) end end
ESPAPI.SetMutationList = function(list) if DD_ESP_Mutation and DD_ESP_Mutation.SetValues then DD_ESP_Mutation:SetValues(list) end end

--======================================================
-- Task Manager (start/stop loop per fitur)
--======================================================
getgenv().RemnantTasks = getgenv().RemnantTasks or {}
local Tasks = getgenv().RemnantTasks

function Tasks.Start(name, runnerFn) -- runnerFn harus return stopperFn (optional)
    Tasks.Stop(name)
    local alive = true
    local stopper
    local th = task.spawn(function()
        stopper = runnerFn(function() return alive end) -- pass isAlive checker
    end)
    Tasks[name] = {
        alive   = function() return alive end,
        stop    = function()
            alive = false
            if stopper then pcall(stopper) end
        end
    }
end

function Tasks.Stop(name)
    local t = Tasks[name]
    if t and t.stop then pcall(t.stop) end
    Tasks[name] = nil
end

function Tasks.StopAll()
    for k in pairs(Tasks) do Tasks.Stop(k) end
end

--======================================================
-- Loader modul via loadstring (mendukung 2 gaya return)
--   Gaya A: return function(ctx) -> {Start=fn, Stop=fn} / table {Start,Stop}
--   Gaya B: return nil, pakai getgenv() CFG & Run flag (fallback)
--======================================================
getgenv().RemnantLoader = getgenv().RemnantLoader or { Mounted = {} }
local Loader = getgenv().RemnantLoader

local function _ctx()
    return {
        Globals = getgenv().RemnantGlobals,
        UI      = getgenv().RemnantUI,
        State   = getgenv().RemnantState,
        Tasks   = Tasks,
    }
end

function Loader.Load(name, url)
    local m = Loader.Mounted[name]
    if m then return m end
    local ok, ret = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    local handle = { Start=nil, Stop=nil, _raw=ret }

    if ok and type(ret) == "function" then
        local t = ret(_ctx())  -- normalize
        handle.Start = t.Start or t.Run or t.start
        handle.Stop  = t.Stop  or t.Kill or t.stop
    elseif ok and type(ret) == "table" then
        handle.Start = ret.Start or ret.Run or ret.start
        handle.Stop  = ret.Stop  or ret.Kill or ret.stop
    else
        -- Fallback: modul gaya B, kendali via getgenv().<Cfg>.Run
        handle.Start = function() end
        handle.Stop  = function() end
    end

    Loader.Mounted[name] = handle
    return handle
end

function Loader.Start(name, url, ...)
    local h = Loader.Load(name, url)
    if h and h.Start then pcall(h.Start, _ctx(), ...) end
end

function Loader.Stop(name)
    local h = Loader.Mounted[name]
    if h and h.Stop then pcall(h.Stop) end
    Tasks.Stop(name)
end

function Loader.Unload(name)
    Loader.Stop(name)
    Loader.Mounted[name] = nil
end

function Loader.StopAll()
    for n in pairs(Loader.Mounted) do Loader.Stop(n) end
    Tasks.StopAll()
end

function Loader.UnloadAll()
    Loader.StopAll()
    Loader.Mounted = {}
end

Window:OnClose(function()
  local s = State
  -- Set semua flag auto ke false
  s.Plants.AutoPlant = false
  s.Plants.AutoCollect = false
  s.Plants.AutoMove = false

  s.Sprinkler.AutoPlace = false

  s.Shovel.AutoShovelFruit = false
  s.Shovel.AutoShovelSprinkler = false
  s.Shovel.AutoShovelPlant = false

  s.Home.AutoRejoin = false
  s.Home.AutoHopServer = false

  s.Webhook.Enable = false
  s.Webhook.DisconnectNotify = false

  s.Pet.AutoBoost = false
  s.Pet.AutoFavorite = false
  s.Pet.AutoSell = false

  s.Egg.AutoPlaceEgg = false
  s.Egg.AutoHatchEgg = false

  s.Shop.Seed.Auto = false
  s.Shop.Gear.Auto = false
  s.Shop.Egg.Auto = false
  s.Shop.Merchant.Auto = false
  s.Shop.Cosmetic.Auto = false
  s.Shop.Event.Auto = false

  s.Craft.Gear.Auto = false
  s.Craft.Seed.Auto = false
  s.Craft.Event.Auto = false

  s.Event.AutoSubmit = false
  s.Event.AutoCollectReward = false

  s.ESP.ESPFruit = false
  s.ESP.ESPEgg = false
  s.ESP.ESPCrate = false
  s.ESP.ESPPet = false

-- hentikan semua runner & unload modul
if getgenv().RemnantLoader then
    getgenv().RemnantLoader.UnloadAll()
end
if getgenv().RemnantTasks then
    getgenv().RemnantTasks.StopAll()
end


  -- kalau kamu simpan handle Toggle di RemnantUI.Controls, bisa juga panggil :Set(false)
  -- misal: if C.TG_AutoPlant and C.TG_AutoPlant.Set then C.TG_AutoPlant:Set(false) end
end)

-- setelah mematikan semua flag:
if getgenv().RemnantUI and getgenv().RemnantUI.Controls then
    for k, ctrl in pairs(getgenv().RemnantUI.Controls) do
        if type(ctrl) == "table" and ctrl.Set then
            pcall(function() ctrl:Set(false) end)
        end
    end
    -- matikan task internal (contoh AutoRejoin task di atas)
    if getgenv().RemnantUI.Controls.__AutoRejoin_Task and task.cancel then
        task.cancel(getgenv().RemnantUI.Controls.__AutoRejoin_Task)
        getgenv().RemnantUI.Controls.__AutoRejoin_Task = nil
    end
end


--======================================================
-- Pilih tab default
--======================================================
Window:SelectTab(1)

return getgenv().RemnantUI
