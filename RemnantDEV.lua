--======================================================
-- RemnantDEV.lua — WindUI (Patched for External Features)
--======================================================

-- ======================
-- Globals for all features
-- ======================
local Players    = game:GetService("Players")
local RS         = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace  = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

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
    getgenv().RemnantGlobals.Humanoid  = Humanoid
end)

--=== RemnantUI Namespace (Controls registry + events) ===
getgenv().RemnantUI = getgenv().RemnantUI or {}
local UI_NS = getgenv().RemnantUI
UI_NS.Controls = UI_NS.Controls or {}
UI_NS.Events = UI_NS.Events or {}
UI_NS.Events.StopAllEvent = UI_NS.Events.StopAllEvent or Instance.new("BindableEvent")

-- Helper global-scope untuk SetValues dropdown (dipakai oleh API setter)
local function _setDD(ctrl, values)
    if ctrl and ctrl.SetValues and type(values) == "table" then
        ctrl:SetValues(values)
    end
end

--======================================================
-- 1) Load WindUI (docs: latest)
--======================================================
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

local UI_NS = { Events = {} }


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
    Sections = {
        Farm  = SecFarm,
        PetEgg= SecPetEgg,
        Shop  = SecShopCraft,
        Event = SecEvent,
        Misc  = SecMisc,
    },
    Controls = _controls, -- penting: bawa balik registry
    Events   = UI_NS.Events,
}

--======================================================
-- Global State (Semua fitur OFF default)
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

    MaxConcurrent       = 3,
    ScanInterval        = 0.10,
    MaxDistance         = 15,
    OwnerFilter         = true,
}

-- Sprinkler
State.Sprinkler = State.Sprinkler or {
    SprinklersSelected  = {},
    PositionSelected    = nil,    -- "Player" | "Nearest Plant"
    AutoPlace           = false,
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
    WhitelistPet     = {},  -- multi (pet dari hatch)
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
    EggsToPlace       = {},
    SlotEgg           = 1,
    AutoPlaceEgg      = false,

    EggsToHatch       = {},
    HatchDelay        = nil,
    AutoHatchEgg      = false,

    OwnerFilter       = true,
    SelectedEggName   = "",
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

--======================================================
-- 2) Feature registry (URL modul eksternal)
--======================================================
getgenv().RemnantFeatures = getgenv().RemnantFeatures or {}
local F = getgenv().RemnantFeatures
F.AutoCollectFruit     = F.AutoCollectFruit     or "https://raw.githubusercontent.com/hailazra/Development/refs/heads/main/Features/AutoCollect.lua"       -- ganti ke raw URL kamu
F.AutoPlaceSelectedEGG = F.AutoPlaceSelectedEGG or "https://raw.githubusercontent.com/hailazra/Development/refs/heads/main/Features/AutoPlaceEgg.lua"

--======================================================
-- 3) Tasks manager (opsional; dipakai loader fungsi)
--======================================================
getgenv().RemnantTasks = getgenv().RemnantTasks or {}
local Tasks = getgenv().RemnantTasks

function Tasks.Stop(name)
    local t = Tasks[name]
    -- Hanya stop jika entri task adalah table (bukan fungsi method)
    if type(t) == "table" and t.stop then
        pcall(t.stop)
    end
    -- Jangan menghapus field method ("Start","Stop","StopAll")
    if type(Tasks[name]) == "table" then
        Tasks[name] = nil
    end
end

function Tasks.StopAll()
    -- Loop aman: hanya iterasi entri task yang bertipe table
    for k, v in pairs(Tasks) do
        if type(v) == "table" and v.stop then
            pcall(v.stop)
            Tasks[k] = nil
        end
    end
end

--======================================================
-- 4) RemnantLoader (Start/Stop/Unload satu pintu)
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

local function _load_and_exec(url)
    local src = game:HttpGet(url)
    local fn  = loadstring or load
    local chunk = fn and fn(src)
    if not chunk then error("Executor tidak mendukung loadstring/load") end
    return chunk()
end

function Loader.Load(name, url)
    local m = Loader.Mounted[name]
    if m then return m end

    local ok, ret = pcall(_load_and_exec, url)
    local handle = { Start=nil, Stop=nil, _raw=ret }

    if ok and type(ret) == "function" then
        local t = ret(_ctx())      -- normalize
        handle.Start = t.Start or t.Run or t.start
        handle.Stop  = t.Stop  or t.Kill or t.stop
    elseif ok and type(ret) == "table" then
        handle.Start = ret.Start or ret.Run or ret.start
        handle.Stop  = ret.Stop  or ret.Kill or ret.stop
    else
        -- Fallback: modul gaya 'mentahan' yang kendali via getgenv().<CFG>.Run
        handle.Start = function() end
        handle.Stop  = function()
            -- Coba panggil Kill konvensi umum
            local K = rawget(getgenv(), "FruitCollectorKILL") or rawget(getgenv(), "PlaceEggKILL")
            if type(K) == "function" then pcall(K) end
        end
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

--======================================================
-- 5) Bridge State -> CFG untuk modul mentahan
--======================================================
local function buildFruitCFGFromState()
    local P = State.Plants
    getgenv().FruitCollectCFG = {
        Run               = P.AutoCollect,
        ScanInterval      = P.ScanInterval or 0.10,
        RateLimitPerFruit = 1.25,
        MaxConcurrent     = P.MaxConcurrent or 3,
        UseOwnerFilter    = P.OwnerFilter ~= false,
        SelectedFruits    = P.FruitsSelected or {},
        WeightMin         = tonumber(P.WeightThreshold) or 0.0,
        WeightMax         = math.huge,
        MutationWhitelist = P.WhiteMutation or {},
        MutationBlacklist = P.BlackMutation or {},
        MaxDistance       = P.MaxDistance or 15,
        Debug             = true,
    }
    return getgenv().FruitCollectCFG
end

local function buildPlaceEggCFGFromState()
    local E = State.Egg
    getgenv().PlaceEggCFG = {
        SelectedEggName = E.SelectedEggName or "",
        MaxSlots        = tonumber(E.SlotEgg) or 1,
        MinEggGap       = 3.0,
        GridStep        = 1.0,
        OwnerFilter     = E.OwnerFilter ~= false,
        Run             = E.AutoPlaceEgg,
    }
    return getgenv().PlaceEggCFG
end

-- ===== Handler: Auto Place Selected Egg =====
local function buildPlaceEggCFGFromState()
  local S = getgenv().RemnantState
  local E = S.Egg
  local selectedName = ""
  if type(E.EggsToPlace) == "table" and #E.EggsToPlace > 0 then
    selectedName = tostring(E.EggsToPlace[1]) -- ambil item pertama dari multi-select
  end

  return {
    SelectedEggName = selectedName,
    MaxSlots        = tonumber(E.SlotEgg) or 1,
    MinEggGap       = 3.0,      -- default aman (tidak ada UI khusus di RemnantDEV)
    GridStep        = 1.0,      -- default
    OwnerFilter     = true,     -- default: hanya milik sendiri
    Run             = true,
  }
end

local function startAutoPlaceSelectedEgg()
  local G = getgenv()
  G.PlaceEggCFG = buildPlaceEggCFGFromState()

  local url = (G.RemnantFeatures and G.RemnantFeatures.AutoPlaceSelectedEgg)
              or "https://raw.githubusercontent.com/hailazra/Development/refs/heads/main/Features/AutoPlaceEgg.lua"

  -- Gunakan RemnantLoader supaya modul dapat ctx (Globals/UI/State/Tasks)
  pcall(function()
    getgenv().RemnantLoader.Start("auto_place_selected_egg", url)
  end)
end

local function stopAutoPlaceSelectedEgg()
  local G = getgenv()
  -- Modul expose Stop lewat Loader, plus konvensi _G.PlaceEggKILL
  pcall(function() getgenv().RemnantLoader.Stop("auto_place_selected_egg") end)
  if rawget(G, "PlaceEggKILL") then pcall(G.PlaceEggKILL) end
end


--======================================================
-- 6) HOME
--======================================================
local UI = getgenv().RemnantUI
local C  = UI.Controls
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
        if setclipboard then
            setclipboard("https://discord.gg/TqXwyyxtR3") -- ganti invite kamu
        end
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
        local jobId = tostring(State.Home.JobID or "")
        if jobId ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId)
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
    Title = "Copy JobID",
    Icon  = "clipboard",
    Callback = function()
        State.Home.JobID = game.JobId
        if setclipboard then setclipboard(State.Home.JobID) end
    end
})

-- (Opsional) Toast helper
local function toast(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title="Remnant", Text=tostring(msg), Duration=3
        })
    end)
end

--======================================================
-- 7) FARM: Plants & Fruits
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
local IN_Harvest_MaxDist = TabPlants:Input({
    Title = "Max Distance", Placeholder = "e.g. 15", Numeric = true,
    Callback = function(v)
        State.Plants.MaxDistance = tonumber(v) or 15
        if getgenv().FruitCollectCFG then getgenv().FruitCollectCFG.MaxDistance = tonumber(v) or 15 end
    end
})
local TG_AutoCollect = TabPlants:Toggle({
    Title = "Auto Collect", Default = false,
    Callback = function(on)
        State.Plants.AutoCollect = on
        local url = F.AutoCollectFruit
        if on then
            buildFruitCFGFromState()
            Loader.Start("auto_collect_fruit", url)
            toast("Auto Collect: ON")
        else
            Loader.Stop("auto_collect_fruit")
            toast("Auto Collect: OFF")
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
-- 8) FARM: Sprinkler
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
-- 9) FARM: Shovel
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
-- 10) PET & EGG: Loadout
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
-- 11) PET & EGG: Pet
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
-- 12) PET & EGG: Egg
--======================================================
local TabEggRef = UI.Tabs.Egg

TabEggRef:Section({ Title = "Place Egg", TextXAlignment = "Left", TextSize = 17 })
local DD_Egg_SelectPlace = TabEggRef:Dropdown({
    Title = "Select Egg", Multi = true, Values = {}, Default = {}, Placeholder = "Choose eggs...",
    Callback = function(list)
  State.Egg.EggsToPlace = list
  if getgenv().PlaceEggCFG then
    getgenv().PlaceEggCFG.SelectedEggName = (type(list)=="table" and list[1]) or ""
  end
end

})
local IN_Egg_Slot = TabEggRef:Input({
    Title = "Slot Egg", Placeholder = "e.g. 1", Numeric = true,
   Callback = function(v)
  local n = tonumber(v)
  State.Egg.SlotEgg = n
  if getgenv().PlaceEggCFG then getgenv().PlaceEggCFG.MaxSlots = n or 1 end
end
})
TabEggRef:Button({
    Title = "Refresh Egg", Icon = "refresh-ccw",
    Callback = function()
  -- Minta modul untuk re-push list (kalau sudah aktif)
  local uiAPI = getgenv().RemnantUI and getgenv().RemnantUI.API and getgenv().RemnantUI.API.Egg
  if uiAPI and uiAPI.SetEggListForPlace and uiAPI.SetEggListForHatch then
    -- Kalau modul aktif, dia juga auto-sync via Backpack events.
    -- Di sini cukup trigger ulang start supaya pushEggListToUI() jalan.
    if getgenv().RemnantState.Egg.AutoPlaceEgg then
      stopAutoPlaceSelectedEgg()
      task.wait(0.1)
      startAutoPlaceSelectedEgg()
    end
  end
end
})
local TG_Egg_AutoPlace = TabEggRef:Toggle({
    Title = "Auto Place Egg", Default = false,
   Callback = function(on)
  State.Egg.AutoPlaceEgg = on
  if on then
    startAutoPlaceSelectedEgg()
  else
    stopAutoPlaceSelectedEgg()
  end
end
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
-- 13) SHOP: BUY
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
-- 14) CRAFT: MAKE
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
-- 15) EVENT: Auto Event & Collect
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

--======================================================
-- 16) MISC: ESP
--======================================================
local TabESPRef = UI.Tabs.Misc_ESP

-- "Fruit" section
TabESPRef:Section({ Title = "Fruit", TextXAlignment = "Left", TextSize = 17 })

local DD_ESP_Fruit = TabESPRef:Dropdown({
  Title = "Select Fruit",
  Multi = true,
  Values = {},
  Default  = {},
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
  Value = "",
  Callback = function(v) State.ESP.WeightThreshold = tonumber(v) end
})

local TG_ESP_Fruit = TabESPRef:Toggle({
  Title = "ESP: Fruit",
  Default = false,
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
-- 17) Register Controls (agar modul luar bisa akses elemen UI)
--======================================================
do
    local C = getgenv().RemnantUI.Controls

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
end

--======================================================
-- 18) API setter: update isi dropdown dari modul
--======================================================
getgenv().RemnantUI.API       = getgenv().RemnantUI.API or {}
getgenv().RemnantUI.API.Farm  = getgenv().RemnantUI.API.Farm or {}
getgenv().RemnantUI.API.Pet   = getgenv().RemnantUI.API.Pet or {}
getgenv().RemnantUI.API.Egg   = getgenv().RemnantUI.API.Egg or {}
getgenv().RemnantUI.API.Team  = getgenv().RemnantUI.API.Team or {}
getgenv().RemnantUI.API.Shop  = getgenv().RemnantUI.API.Shop or {}
getgenv().RemnantUI.API.Craft = getgenv().RemnantUI.API.Craft or {}
getgenv().RemnantUI.API.Event = getgenv().RemnantUI.API.Event or {}
getgenv().RemnantUI.API.ESP   = getgenv().RemnantUI.API.ESP or {}
getgenv().RemnantUI.API.Home  = getgenv().RemnantUI.API.Home or {}
getgenv().RemnantUI.API.Webhook = getgenv().RemnantUI.API.Webhook or {}

local FarmAPI   = getgenv().RemnantUI.API.Farm
local PetAPI    = getgenv().RemnantUI.API.Pet
local EggAPI    = getgenv().RemnantUI.API.Egg
local TeamAPI   = getgenv().RemnantUI.API.Team
local ShopAPI   = getgenv().RemnantUI.API.Shop
local CraftAPI  = getgenv().RemnantUI.API.Craft
local EventAPI  = getgenv().RemnantUI.API.Event
local ESPAPI    = getgenv().RemnantUI.API.ESP
local HomeAPI   = getgenv().RemnantUI.API.Home
local WebhookAPI= getgenv().RemnantUI.API.Webhook

-- Home
HomeAPI.SetChangelog = function(text)
    State.Home.ChangelogText = tostring(text or "-")
    if CH_Paragraph and CH_Paragraph.SetContent then CH_Paragraph:SetContent(State.Home.ChangelogText) end
end
WebhookAPI.SetWhitelistPetList = function(list)
    if DD_Webhook_WhitelistPet and DD_Webhook_WhitelistPet.SetValues then DD_Webhook_WhitelistPet:SetValues(list or {}) end
end

-- Farm: Plants
FarmAPI.SetSeedList = function(list) _setDD(DD_Plant_Seed, list) end
FarmAPI.SetFruitList = function(list)
    _setDD(DD_Harvest_Fruit, list)
    _setDD(DD_Shovel_Fruit,  list)
    _setDD(DD_Event_Fruit,   list)
end
FarmAPI.SetMutationLists = function(list)
    _setDD(DD_Harvest_White,   list)
    _setDD(DD_Harvest_Black,   list)
    _setDD(DD_Shovel_WhiteMut, list)
    _setDD(DD_Shovel_BlackMut, list)
    _setDD(DD_ESP_Mutation,    list)
    _setDD(DD_Event_White,     list)
    _setDD(DD_Event_Black,     list)
end
FarmAPI.SetWhiteMutationList  = function(list) _setDD(DD_Harvest_White, list) end
FarmAPI.SetBlackMutationList  = function(list) _setDD(DD_Harvest_Black, list) end
FarmAPI.SetPlantList          = function(list) _setDD(DD_Move_Select, list) end

-- Farm: Sprinkler
FarmAPI.SetSprinklerList      = function(list) _setDD(DD_Sprinkler_Select, list) end
-- Farm: Shovel
FarmAPI.SetShovelFruitList     = function(list) _setDD(DD_Shovel_Fruit, list) end
FarmAPI.SetShovelMutationList  = function(list) _setDD(DD_Shovel_WhiteMut, list) end
FarmAPI.SetShovelBlacklistList = function(list) _setDD(DD_Shovel_BlackMut, list) end
FarmAPI.SetShovelSprinklerList = function(list) _setDD(DD_Shovel_Sprinkler, list) end
FarmAPI.SetShovelPlantList     = function(list) _setDD(DD_Shovel_Plant, list) end

-- Team / Loadout
TeamAPI.SetLoadoutList = function(list) _setDD(DD_Loadout_Select, list) end

-- Pet
PetAPI.SetPetListForBoost   = function(list) _setDD(DD_Pet_SelectBoost, list) end
PetAPI.SetBoostList         = function(list) _setDD(DD_Pet_Boost, list) end
PetAPI.SetPetListForFav     = function(list) _setDD(DD_Pet_SelectFav, list) end
PetAPI.SetPetListForSell    = function(list) _setDD(DD_Pet_SelectSell, list) end
PetAPI.SetSellBlacklistList = function(list) _setDD(DD_Pet_Blacklist, list) end

-- Egg
EggAPI.SetEggListForPlace   = function(list) _setDD(DD_Egg_SelectPlace, list) end
EggAPI.SetEggListForHatch   = function(list) _setDD(DD_Egg_SelectHatch, list) end

-- Shop (Buy)
ShopAPI.SetSeedList         = function(list) _setDD(DD_Shop_Seed, list) end
ShopAPI.SetGearList         = function(list) _setDD(DD_Shop_Gear, list) end
ShopAPI.SetEggList          = function(list) _setDD(DD_Shop_Egg, list) end
ShopAPI.SetMerchantList     = function(list) _setDD(DD_Shop_Merchant, list) end
ShopAPI.SetMerchantItemList = function(list) _setDD(DD_Shop_MerchantItem, list) end
ShopAPI.SetCosmeticList     = function(list) _setDD(DD_Shop_Cosmetic, list) end
ShopAPI.SetEventItemList    = function(list) _setDD(DD_Shop_EventItem, list) end

-- Craft
CraftAPI.SetCraftGearList   = function(list) _setDD(DD_Craft_Gear, list) end
CraftAPI.SetCraftSeedList   = function(list) _setDD(DD_Craft_Seed, list) end
CraftAPI.SetCraftEventList  = function(list) _setDD(DD_Craft_Event, list) end

-- Event
EventAPI.SetFruitList          = function(list) _setDD(DD_Event_Fruit, list) end
EventAPI.SetWhiteMutationList  = function(list) _setDD(DD_Event_White, list) end
EventAPI.SetBlackMutationList  = function(list) _setDD(DD_Event_Black, list) end

-- ESP
ESPAPI.SetFruitList    = function(list) _setDD(DD_ESP_Fruit, list) end
ESPAPI.SetMutationList = function(list) _setDD(DD_ESP_Mutation, list) end

--======================================================
-- 19) Window close → StopAllEvent + UnloadAll
--======================================================
local function _onWindowClose()
    -- Set semua flag auto ke false (supaya modul mentahan yang pantau *.Run ikut stop)
    State.Plants.AutoPlant = false
    State.Plants.AutoCollect = false
    State.Plants.AutoMove = false

    State.Sprinkler.AutoPlace = false

    State.Shovel.AutoShovelFruit = false
    State.Shovel.AutoShovelSprinkler = false
    State.Shovel.AutoShovelPlant = false

    State.Home.AutoRejoin = false
    State.Home.AutoHopServer = false

    State.Webhook.Enable = false
    State.Webhook.DisconnectNotify = false

    State.Pet.AutoBoost = false
    State.Pet.AutoFavorite = false
    State.Pet.AutoSell = false

    State.Egg.AutoPlaceEgg = false
    State.Egg.AutoHatchEgg = false

    State.Shop.Seed.Auto = false
    State.Shop.Gear.Auto = false
    State.Shop.Egg.Auto = false
    State.Shop.Merchant.Auto = false
    State.Shop.Cosmetic.Auto = false
    State.Shop.Event.Auto = false

    State.Craft.Gear.Auto = false
    State.Craft.Seed.Auto = false
    State.Craft.Event.Auto = false

    State.Event.AutoSubmit = false
    State.Event.AutoCollectReward = false

    State.ESP.ESPFruit = false
    State.ESP.ESPEgg   = false
    State.ESP.ESPCrate = false
    State.ESP.ESPPet   = false

    -- Broadcast ke modul yang listen
    pcall(function() UI_NS.Events.StopAllEvent:Fire() end)

    -- hentikan semua runner & unload modul
    if getgenv().RemnantLoader then
        getgenv().RemnantLoader.UnloadAll()
    end
    if getgenv().RemnantTasks then
        getgenv().RemnantTasks.StopAll()
    end

    -- Matikan semua toggle UI (kalau ada API Set)
    if getgenv().RemnantUI and getgenv().RemnantUI.Controls then
        for _, ctrl in pairs(getgenv().RemnantUI.Controls) do
            if type(ctrl) == "table" and ctrl.Set then
                pcall(function() ctrl:Set(false) end)
            end
        end
        if getgenv().RemnantUI.Controls.__AutoRejoin_Task and task.cancel then
            task.cancel(getgenv().RemnantUI.Controls.__AutoRejoin_Task)
            getgenv().RemnantUI.Controls.__AutoRejoin_Task = nil
        end
    end
end

-- Hanya pasang handler untuk close/destroy, BUKAN minimize
if Window.OnClose then
    Window:OnClose(_onWindowClose)
elseif Window.OnDestroy then
    Window:OnDestroy(_onWindowClose)
else
    local oldDestroy = Window.Destroy
    Window.Destroy = function(self, ...)
        _onWindowClose()
        return oldDestroy(self, ...)
    end
end

-- Jika WindUI punya event minimize, jangan matikan fitur di sana
if Window.OnMinimize then
    Window:OnMinimize(function()
        -- Jangan matikan fitur apapun di sini!
        -- Bisa tambahkan logika lain jika perlu
    end)
end

--======================================================
-- Pilih tab default
--======================================================
Window:SelectTab(1)

return getgenv().RemnantUI
