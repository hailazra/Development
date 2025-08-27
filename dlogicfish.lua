
-- WindUI Library as Main Library
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--========== WINDOW ==========
local Window = WindUI:CreateWindow({
    Title         = ".devlogic",
    Icon          = "brain-circuit",
    Author        = "hailazra",
    Folder        = ".devlogichub",
    Size          = UDim2.fromOffset(250, 250),
    Theme         = "Dark",
    Resizable     = false,
    SideBarWidth  = 120,
    HideSearchBar = true,
})

--========== GUARD + STATE ==========
-- keep old controls if exist
local _oldUI     = rawget(getgenv(), "logicdevui")
local _controls  = (_oldUI and _oldUI.Controls) or {}

-- safe function table (no-op wrappers) -> tidak bikin error kalau belum kamu isi
local _funcs = (_oldUI and _oldUI.Functions) or {}
local function _safe(fn) return (type(fn) == "function") and fn or function() end end

-- placeholder/no-op agar gak error saat dipanggil
_funcs.SetDelayCast       = _funcs.SetDelayCast       or function(_) end
_funcs.StartAutoCast      = _funcs.StartAutoCast      or function() end
_funcs.StopAutoCast       = _funcs.StopAutoCast       or function() end
_funcs.StartAutoReel      = _funcs.StartAutoReel      or function() end
_funcs.StopAutoReel       = _funcs.StopAutoReel       or function() end
_funcs.StartAutoFishing   = _funcs.StartAutoFishing   or function() end
_funcs.StopAutoFishing    = _funcs.StopAutoFishing    or function() end
_funcs.BuyRod             = _funcs.BuyRod             or function(_) end
_funcs.BuyItem            = _funcs.BuyItem            or function(_, _) end
_funcs.BuyWeather         = _funcs.BuyWeather         or function(_) end
_funcs.TeleportToLocation = _funcs.TeleportToLocation or function(_) end
_funcs.EnableWalkOnWater  = _funcs.EnableWalkOnWater  or function() end
_funcs.DisableWalkOnWater = _funcs.DisableWalkOnWater or function() end
_funcs.EnableAntiOxygen   = _funcs.EnableAntiOxygen   or function() end
_funcs.DisableAntiOxygen  = _funcs.DisableAntiOxygen  or function() end
_funcs.SetWebhookURL      = _funcs.SetWebhookURL      or function(_) end
_funcs.EnableWebhook      = _funcs.EnableWebhook      or function() end
_funcs.DisableWebhook     = _funcs.DisableWebhook     or function() end

--========== TABS (SIDEBAR) ==========
local TabHome     = Window:Tab({ Title = "Home",     Icon = "house" })
local TabMain     = Window:Tab({ Title = "Main",     Icon = "gamepad" })
local TabShop     = Window:Tab({ Title = "Shop",     Icon = "shopping-cart" })
local TabTeleport = Window:Tab({ Title = "Teleport", Icon = "map" })
local TabMisc     = Window:Tab({ Title = "Misc",     Icon = "cog" })

--========== HOME ==========
do
    TabHome:Section({ Title = ".devlogic", TextXAlignment = "Left", TextSize = 17 })
    -- isi Home sesuai kebutuhan kamu (changelog, discord, dsb.)
end

--========== MAIN → FISHING SECTION ==========
local SecFishing = TabMain:Section({ Title = "Fishing", Icon = "fish", Opened = true })

do
    local DelayCast = SecFishing:Input({
        Title = "Auto Cast Delay",
        Placeholder = "Delay Cast (s)",
        Value = tostring(_controls.DelayCast or 500),
        Description = "Delay before casting the fishing rod.",
        NumbersOnly = true,
        Callback = function(value)
            local numValue = tonumber(value) or 500
            _controls.DelayCast = numValue
            _funcs.SetDelayCast(numValue)
        end
    })

    local AutoCast = SecFishing:Toggle({
        Title = "Auto Cast",
        State = _controls.AutoCast or false,
        Description = "Automatically casts your fishing rod.",
        Callback = function(state)
            _controls.AutoCast = state
            if state then _funcs.StartAutoCast() else _funcs.StopAutoCast() end
        end
    })

    local AutoReel = SecFishing:Toggle({
        Title = "Auto Reel",
        State = _controls.AutoReel or false,
        Description = "Automatically reels in your fishing rod.",
        Callback = function(state)
            _controls.AutoReel = state
            if state then _funcs.StartAutoReel() else _funcs.StopAutoReel() end
        end
    })

    local AutoFishing = SecFishing:Toggle({
        Title = "Auto Fishing",
        State = _controls.AutoFishing or false,
        Description = "Automatically fishes for you.",
        Callback = function(state)
            _controls.AutoFishing = state
            if state then _funcs.StartAutoFishing() else _funcs.StopAutoFishing() end
        end
    })
end

--========== SHOP → ITEM & WEATHER ==========
local SecShopItem    = TabShop:Section({ Title = "Item",    Icon = "wrench",    Opened = true })
local SecShopWeather = TabShop:Section({ Title = "Weather", Icon = "cloud-sun", Opened = true })

do -- Item
    local RodShop = SecShopItem:Dropdown({
        Title = "Select Rod",
        Values = { "Ares", "Astral", "Luck" },
        Value  = "Ares",
        Callback = function(option)
            -- print("Rod selected: " .. tostring(option))
        end
    })

    SecShopItem:Button({
        Title = "Buy Rod",
        Description = "Purchase the selected fishing rod.",
        Callback = function()
            local selectedRod = RodShop.Value
            _funcs.BuyRod(selectedRod)
        end
    })

    local ItemShop = SecShopItem:Dropdown({
        Title = "Select Item",
        Values = { "Bait", "Lure", "Fish Finder" },
        Value  = "Bait",
        Multi  = true,
        AllowNone = true,
        Callback = function(option)
            -- print("Item selected: " .. tostring(option))
        end
    })

    SecShopItem:Input({
        Title = "Item Quantity",
        Placeholder = "Enter quantity",
        Value = tostring(_controls.BuyItemQuantity or 1),
        NumbersOnly = true,
        Callback = function(value)
            local numValue = tonumber(value) or 1
            _controls.BuyItemQuantity = numValue
        end
    })

    SecShopItem:Button({
        Title = "Buy Item",
        Description = "Purchase the selected item in the specified quantity.",
        Callback = function()
            local selectedItem = ItemShop.Value
            local quantity     = _controls.BuyItemQuantity or 1
            _funcs.BuyItem(selectedItem, quantity)
        end
    })
end

do -- Weather
    local WeatherShop = SecShopWeather:Dropdown({
        Title = "Select Weather",
        Values = { "Sunny", "Rainy", "Stormy" },
        Value  = "Sunny",
        Callback = function(option)
            -- print("Weather selected: " .. tostring(option))
        end
    })

    SecShopWeather:Button({
        Title = "Buy Weather",
        Description = "Purchase the selected weather condition.",
        Callback = function()
            local selectedWeather = WeatherShop.Value
            _funcs.BuyWeather(selectedWeather)
        end
    })
end

--========== TELEPORT → LOCATIONS ==========
local SecLocations = TabTeleport:Section({ Title = "Locations", Icon = "map-pin", Opened = true })

do
    local LocationTeleport = SecLocations:Dropdown({
        Title  = "Select Location",
        Values = { "Spawn", "Fishing Area", "Shop", "Event Area" },
        Value  = "Spawn",
        Callback = function(option)
            -- print("Location selected: " .. tostring(option))
        end
    })

    SecLocations:Button({
        Title = "Teleport",
        Description = "Teleport to the selected location.",
        Callback = function()
            local selectedLocation = LocationTeleport.Value
            _funcs.TeleportToLocation(selectedLocation)
        end
    })
end

--========== MISC → PLAYER & WEBHOOK ==========
local SecPlayer  = TabMisc:Section({ Title = "Player",  Icon = "user", Opened = true })
local SecWebhook = TabMisc:Section({ Title = "Webhook", Icon = "link", Opened = false })

do -- Player
    SecPlayer:Toggle({
        Title = "Walk On Water",
        State = _controls.WalkOnWater or false,
        Description = "Enable or disable walking on water.",
        Callback = function(state)
            _controls.WalkOnWater = state
            if state then _funcs.EnableWalkOnWater() else _funcs.DisableWalkOnWater() end
        end
    })

    SecPlayer:Toggle({
        Title = "Anti-Oxygen",
        State = _controls.AntiOxygen or false,
        Description = "Prevent oxygen depletion while underwater.",
        Callback = function(state)
            _controls.AntiOxygen = state
            if state then _funcs.EnableAntiOxygen() else _funcs.DisableAntiOxygen() end
        end
    })
end

do -- Webhook
    SecWebhook:Input({
        Title = "Webhook URL",
        Placeholder = "Enter your webhook URL",
        Value = _controls.WebhookURL or "",
        Description = "Set the webhook URL for notifications.",
        Callback = function(value)
            _controls.WebhookURL = value
            _funcs.SetWebhookURL(value)
        end
    })

    SecWebhook:Toggle({
        Title = "Enable Webhook",
        State = _controls.EnableWebhook or false,
        Description = "Enable or disable webhook notifications.",
        Callback = function(state)
            _controls.EnableWebhook = state
            if state then _funcs.EnableWebhook() else _funcs.DisableWebhook() end
        end
    })
end

--========== EXPOSE (GLOBAL REF) ==========
getgenv().logicdevui = {
    Window   = Window,
    Tabs     = {
        Home     = TabHome,
        Main     = TabMain,
        Shop     = TabShop,
        Teleport = TabTeleport,
        Misc     = TabMisc,
    },
    Sections = {
        Fishing   = SecFishing,
        ShopItem  = SecShopItem,
        ShopWeath = SecShopWeather,
        Locations = SecLocations,
        Player    = SecPlayer,
        Webhook   = SecWebhook,
    },
    Controls  = _controls,
    Functions = _funcs, -- biar kamu bisa inject implementasi aslinya dari luar
}

--========== WINDOW LIFECYCLE ==========
Window:OnClose(function()
    print("Window closed")
    -- amanin variabel opsional
    if typeof(ConfigManager) == "table" and configFile and typeof(configFile.Set) == "function" and typeof(configFile.Save) == "function" then
        local MyPlayerData = rawget(getgenv(), "MyPlayerData")
        configFile:Set("playerData", MyPlayerData)
        configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
        configFile:Save()
        print("Config auto-saved on close")
    end
end)

Window:OnDestroy(function()
    print("Window destroyed")
end)
