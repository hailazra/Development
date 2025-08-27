-- WindUI Library
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

--========== STATE & SAFE FUNCS ==========
local prev = rawget(getgenv(), "logicdevui")
local Controls  = (prev and prev.Controls)  or {}

local Funcs = (prev and prev.Functions) or {}
local function ensure(fn) return (type(fn) == "function") and fn or function() end end

-- bind no-op agar sesuai WindUI call flow (tidak error walau kosong)
Funcs.SetDelayCast       = ensure(Funcs.SetDelayCast)
Funcs.StartAutoCast      = ensure(Funcs.StartAutoCast)
Funcs.StopAutoCast       = ensure(Funcs.StopAutoCast)
Funcs.StartAutoReel      = ensure(Funcs.StartAutoReel)
Funcs.StopAutoReel       = ensure(Funcs.StopAutoReel)
Funcs.StartAutoFishing   = ensure(Funcs.StartAutoFishing)
Funcs.StopAutoFishing    = ensure(Funcs.StopAutoFishing)
Funcs.BuyRod             = ensure(Funcs.BuyRod)
Funcs.BuyItem            = ensure(Funcs.BuyItem)
Funcs.BuyWeather         = ensure(Funcs.BuyWeather)
Funcs.TeleportToLocation = ensure(Funcs.TeleportToLocation)
Funcs.EnableWalkOnWater  = ensure(Funcs.EnableWalkOnWater)
Funcs.DisableWalkOnWater = ensure(Funcs.DisableWalkOnWater)
Funcs.EnableAntiOxygen   = ensure(Funcs.EnableAntiOxygen)
Funcs.DisableAntiOxygen  = ensure(Funcs.DisableAntiOxygen)
Funcs.SetWebhookURL      = ensure(Funcs.SetWebhookURL)
Funcs.EnableWebhook      = ensure(Funcs.EnableWebhook)
Funcs.DisableWebhook     = ensure(Funcs.DisableWebhook)

-- helper ambil value kontrol yg compatible
local function getValue(ctrl)
    if ctrl == nil then return nil end
    if type(ctrl.GetValue) == "function" then
        local ok, v = pcall(ctrl.GetValue, ctrl)
        if ok then return v end
    end
    -- fallback properti umum
    return rawget(ctrl, "Value")
end

--========== TABS ==========
local TabHome     = Window:Tab({ Title = "Home",     Icon = "house" })
local TabMain     = Window:Tab({ Title = "Main",     Icon = "gamepad" })
local TabShop     = Window:Tab({ Title = "Shop",     Icon = "shopping-cart" })
local TabTeleport = Window:Tab({ Title = "Teleport", Icon = "map" })
local TabMisc     = Window:Tab({ Title = "Misc",     Icon = "cog" })

--========== HOME ==========
do
    TabHome:Section({ Title = ".devlogic", TextXAlignment = "Left", TextSize = 17 })
    -- tambahin changelog/discord nanti di sini
end

--========== MAIN → FISHING ==========
local SecFishing = TabMain:Section({ Title = "Fishing", Icon = "fish", Opened = true })

do
    SecFishing:Input({
        Title = "Auto Cast Delay",
        Placeholder = "Delay Cast (s)",
        Value = tostring(Controls.DelayCast or 500),
        Description = "Delay before casting the fishing rod.",
        NumbersOnly = true,
        Callback = function(value)
            local num = tonumber(value) or 500
            Controls.DelayCast = num
            Funcs.SetDelayCast(num)
        end
    })

    SecFishing:Toggle({
        Title = "Auto Cast",
        State = Controls.AutoCast or false,
        Description = "Automatically casts your fishing rod.",
        Callback = function(state)
            Controls.AutoCast = state
            if state then Funcs.StartAutoCast() else Funcs.StopAutoCast() end
        end
    })

    SecFishing:Toggle({
        Title = "Auto Reel",
        State = Controls.AutoReel or false,
        Description = "Automatically reels in your fishing rod.",
        Callback = function(state)
            Controls.AutoReel = state
            if state then Funcs.StartAutoReel() else Funcs.StopAutoReel() end
        end
    })

    SecFishing:Toggle({
        Title = "Auto Fishing",
        State = Controls.AutoFishing or false,
        Description = "Automatically fishes for you.",
        Callback = function(state)
            Controls.AutoFishing = state
            if state then Funcs.StartAutoFishing() else Funcs.StopAutoFishing() end
        end
    })
end

--========== SHOP → ITEM & WEATHER ==========
-- Catatan: ganti icon "cloud-sun" → "cloud" (lebih aman di Lucide)
local SecShopItem    = TabShop:Section({ Title = "Item",    Icon = "wrench", Opened = true })
local SecShopWeather = TabShop:Section({ Title = "Weather", Icon = "cloud",  Opened = false })

do -- Item
    local RodDropdown = SecShopItem:Dropdown({
        Title  = "Select Rod",
        Values = { "Ares", "Astral", "Luck" },
        Value  = "Ares",
        Callback = function(_) end
    })

    SecShopItem:Button({
        Title = "Buy Rod",
        Description = "Purchase the selected fishing rod.",
        Callback = function()
            local selected = getValue(RodDropdown)
            Funcs.BuyRod(selected)
        end
    })

    local ItemDropdown = SecShopItem:Dropdown({
        Title  = "Select Item",
        Values = { "Bait", "Lure", "Fish Finder" },
        Value  = "Bait",
        Callback = function(_) end
    })

    local QtyBox = SecShopItem:Input({
        Title = "Item Quantity",
        Placeholder = "Enter quantity",
        Value = tostring(Controls.BuyItemQuantity or 1),
        NumbersOnly = true,
        Callback = function(v)
            Controls.BuyItemQuantity = tonumber(v) or 1
        end
    })

    SecShopItem:Button({
        Title = "Buy Item",
        Description = "Purchase the selected item in the specified quantity.",
        Callback = function()
            local item  = getValue(ItemDropdown)
            local qty   = Controls.BuyItemQuantity or 1
            Funcs.BuyItem(item, qty)
        end
    })
end

do -- Weather
    local WeatherDropdown = SecShopWeather:Dropdown({
        Title  = "Select Weather",
        Values = { "Sunny", "Rainy", "Stormy" },
        Value  = "Sunny",
        Callback = function(_) end
    })

    SecShopWeather:Button({
        Title = "Buy Weather",
        Description = "Purchase the selected weather condition.",
        Callback = function()
            local weather = getValue(WeatherDropdown)
            Funcs.BuyWeather(weather)
        end
    })
end

--========== TELEPORT ==========
local SecLocations = TabTeleport:Section({ Title = "Locations", Icon = "map-pin", Opened = true })

do
    local LocationDropdown = SecLocations:Dropdown({
        Title  = "Select Location",
        Values = { "Spawn", "Fishing Area", "Shop", "Event Area" },
        Value  = "Spawn",
        Callback = function(_) end
    })

    SecLocations:Button({
        Title = "Teleport",
        Description = "Teleport to the selected location.",
        Callback = function()
            local loc = getValue(LocationDropdown)
            Funcs.TeleportToLocation(loc)
        end
    })
end

--========== MISC ==========
local SecPlayer  = TabMisc:Section({ Title = "Player",  Icon = "user", Opened = true })
local SecWebhook = TabMisc:Section({ Title = "Webhook", Icon = "link", Opened = false })

do -- Player
    SecPlayer:Toggle({
        Title = "Walk On Water",
        State = Controls.WalkOnWater or false,
        Description = "Enable or disable walking on water.",
        Callback = function(state)
            Controls.WalkOnWater = state
            if state then Funcs.EnableWalkOnWater() else Funcs.DisableWalkOnWater() end
        end
    })

    SecPlayer:Toggle({
        Title = "Anti-Oxygen",
        State = Controls.AntiOxygen or false,
        Description = "Prevent oxygen depletion while underwater.",
        Callback = function(state)
            Controls.AntiOxygen = state
            if state then Funcs.EnableAntiOxygen() else Funcs.DisableAntiOxygen() end
        end
    })
end

do -- Webhook
    SecWebhook:Input({
        Title = "Webhook URL",
        Placeholder = "Enter your webhook URL",
        Value = Controls.WebhookURL or "",
        Description = "Set the webhook URL for notifications.",
        Callback = function(value)
            Controls.WebhookURL = value
            Funcs.SetWebhookURL(value)
        end
    })

    SecWebhook:Toggle({
        Title = "Enable Webhook",
        State = Controls.EnableWebhook or false,
        Description = "Enable or disable webhook notifications.",
        Callback = function(state)
            Controls.EnableWebhook = state
            if state then Funcs.EnableWebhook() else Funcs.DisableWebhook() end
        end
    })
end

--========== EXPOSE ==========
getgenv().logicdevui = {
    Window   = Window,
    Tabs     = { Home = TabHome, Main = TabMain, Shop = TabShop, Teleport = TabTeleport, Misc = TabMisc },
    Sections = {
        Fishing = SecFishing,
        ShopItem = SecShopItem,
        ShopWeather = SecShopWeather,
        Locations = SecLocations,
        Player = SecPlayer,
        Webhook = SecWebhook,
    },
    Controls  = Controls,
    Functions = Funcs,
}

--========== LIFECYCLE ==========
if type(Window.OnClose) == "function" then
    Window:OnClose(function()
        print("Window closed")
        if typeof(ConfigManager) == "table" and configFile and typeof(configFile.Set) == "function" and typeof(configFile.Save) == "function" then
            local MyPlayerData = rawget(getgenv(), "MyPlayerData")
            configFile:Set("playerData", MyPlayerData)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            configFile:Save()
            print("Config auto-saved on close")
        end
    end)
end

if type(Window.OnDestroy) == "function" then
    Window:OnDestroy(function()
        print("Window destroyed")
    end)
end
