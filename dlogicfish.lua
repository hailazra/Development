


-- WindUI LIbrary as Main Library
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()


-- Window
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


-- Tab Home
local TabHome = Window:Tab({ Title = "Home", Icon = "house" })

-- Main
local SecMain = Window:Section({ Title = "Main", Icon = "gamepad", Opened = false })
local TabMain_Fishing     = SecMain:Tab({ Title = "Fishing", Icon = "fish" })

-- Shop
local SecShop =  Window:Section({ Title = "Shop", Icon = "shopping-cart", Opened = false})
local TabShop_Item     = SecShop:Tab({ Title = "Fishing", Icon ="wrench", Opened = false })
local TabShop_Weather = SecShop:Tab({ Title = "Weather", Icon ="cloud-sun", Opened = false })

-- Teleport
local SecTeleport =  Window:Section({ Title = "Teleport", Icon = "map", Opened = false})
local TabTeleport = SecTeleport:Tab({ Title = "Locations", Icon = "location", Opened = false })

-- Misc
local SecMisc         =  Window:Section({ Title = "Misc", Icon = "cog", Opened = false})
local TabMisc_Player  =  Window:Section({ Title = "Player", Icon = "user", Opened = false})
local TabMisc_Webhook =  Window:Section({ Title = "Webhook", Icon = "link", Opened = false})

-- Save Refrence Controls
 local _oldUI = rawget(getgenv(), "logicdevui")
local _controls = _oldUI and _oldUI.Controls or {}
getgenv().logicdevui = {
    Window = Window,
    Tabs = {
        Home            = TabHome,
        -- Main
        Main_Fishing    = TabMain_Fishing,
        -- Shop
        Shop_Item       = TabShop_Item,
        Shop_Weather    = TabShop_Weather,
        -- Teleport
        Teleport        = TabTeleport,
        -- Misc
        MiscPlayer            = TabMisc_Player,
        MiscWebhook           = TabMisc_Webhook,
    },
    Sections = {
        Main      = SecMain,
        Shop      = SecShop,
        Teleport  = SecTeleport,
        Misc  = SecMisc,
    },
    Controls = _controls,
    Events   = UI_NS.Events,
}

-- Tab Home fill

-- Main Sections
local TabFishing     = UI.Tabs.Main_Fishing 

TabFishing:Section({ Title = "Fishing", TextXAlignment = "Left", TextSize = 17 })

local DelayCast = TabFishing:Input({
    Title = "Auto Cast Delay",
    Placeholder = "Delay Cast (s)",
    Value = _controls.DelayCast or "500",
    Description = "Delay before casting the fishing rod.",
    NumbersOnly = true,
    Callback = function(value)
        local numValue = tonumber(value) or 500
        _controls.DelayCast = numValue
        UI_NS.Functions.SetDelayCast(numValue)
    end
local AutoCast = TabFishing:Toggle({
    Title = "Auto Cast",
    State = _controls.AutoCast or false,
    Description = "Automatically casts your fishing rod.",
    Callback = function(state)
        _controls.AutoCast = state
        if state then
            UI_NS.Functions.StartAutoCast()
        else
            UI_NS.Functions.StopAutoCast()
        end
    end
})

local AutoReel = TabFishing:Toggle({
    Title = "Auto Reel",
    State = _controls.AutoReel or false,
    Description = "Automatically reels in your fishing rod.",
    Callback = function(state)
        _controls.AutoReel = state
        if state then
            UI_NS.Functions.StartAutoReel()
        else
            UI_NS.Functions.StopAutoReel()
        end
    end
})

local AutoFishing = TabFishing:Toggle({
    Title = "Auto Fishing",
    State = _controls.AutoFishing or false,
    Description = "Automatically fishes for you.",
    Callback = function(state)
        _controls.AutoFishing = state
        if state then
            UI_NS.Functions.StartAutoFishing()
        else
            UI_NS.Functions.StopAutoFishing()
        end
    end
})

-- Shop Sections
local TabShopItem     = UI.Tabs.Shop_Item
local TabShopWeather  = UI.Tabs.Shop_Weather

-- Shop Item
TabShopItem:Section({ Title = "Item", TextXAlignment = "Left", TextSize = 17 })

local RodShop = TabShopItem:Dropdown({
    Title = "Select Rod",
    Values = { "Ares", "Astral", "Luck" },
    Value = "Ares",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local BuyRod = TabShopItem:Button({
    Title = "Buy Rod",
    Description = "Purchase the selected fishing rod.",
    Callback = function()
        local selectedRod = RodShop.Value
        UI_NS.Functions.BuyRod(selectedRod)
    end
})

local ItemShop = TabShopItem:Dropdown({
    Title = "Select Item",
    Values = { "Bait", "Lure", "Fish Finder" },
    Value = "Bait",
    Multi = true,
    AllowNone = true
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local BuyItemQuantity = TabShopItem:Input({
    Title = "Item Quantity",
    Placeholder = "Enter quantity",
    Value = _controls.BuyItemQuantity or "1",
    NumbersOnly = true,
    Callback = function(value)
        local numValue = tonumber(value) or 1
        _controls.BuyItemQuantity = numValue
        print("Item quantity set to: " .. numValue)
    end
})

local BuyItem = TabShopItem:Button({
    Title = "Buy Item",
    Description = "Purchase the selected item in the specified quantity.",
    Callback = function()
        local selectedItem = ItemShop.Value
        local quantity = _controls.BuyItemQuantity or 1
        UI_NS.Functions.BuyItem(selectedItem, quantity)
    end
})

-- Shop Weather
TabShopWeather:Section({ Title = "Weather", TextXAlignment = "Left", TextSize = 17 })

local WeatherShop = TabShopWeather:Dropdown({
    Title = "Select Weather",
    Values = { "Sunny", "Rainy", "Stormy" },
    Value = "Sunny",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local BuyWeather = TabShopWeather:Button({
    Title = "Buy Weather",
    Description = "Purchase the selected weather condition.",
    Callback = function()
        local selectedWeather = WeatherShop.Value
        UI_NS.Functions.BuyWeather(selectedWeather)
    end
})

-- Teleport Section
local TabTeleportLocations = UI.Tabs.Teleport

TabTeleportLocations:Section({ Title = "Locations", TextXAlignment = "Left", TextSize = 17 })

local LocationTeleport = TabTeleportLocations:Dropdown({
    Title = "Select Location",
    Values = { "Spawn", "Fishing Area", "Shop", "Event Area" },
    Value = "Spawn",
    Callback = function(option) 
        print("Location selected: " .. option) 
    end
})

local TeleportButton = TabTeleportLocations:Button({
    Title = "Teleport",
    Description = "Teleport to the selected location.",
    Callback = function()
        local selectedLocation = LocationTeleport.Value
        UI_NS.Functions.TeleportToLocation(selectedLocation)
    end
})

-- Misc Section
local TabMiscPlayer = UI.Tabs.TabMisc_Player
local TabMiscWebhook = UI.Tabs.TabMisc_Webhook

-- Player
local TabMiscPlayer:Section({ Title = "Player", TextXAlignment = "Left", TextSize = 17 })

local WalkOnWater = TabMiscPlayer:Toggle({
    Title = "Walk On Water",
    State = _controls.WalkOnWater or false,
    Description = "Enable or disable walking on water.",
    Callback = function(state)
        _controls.WalkOnWater = state
        if state then
            UI_NS.Functions.EnableWalkOnWater()
        else
            UI_NS.Functions.DisableWalkOnWater()
        end
    end
})
local AntiOxygen = TabMiscPlayer:Toggle({
    Title = "Anti-Oxygen",
    State = _controls.WalkOnWater or false,
    Description = "Prevent oxygen depletion while underwater.",
    Callback = function(state)
        _controls.AntiOxygen = state
        if state then
            UI_NS.Functions.EnableAntiOxygen()
        else
            UI_NS.Functions.DisableAntiOxygen()
        end
    end
})

-- Webhook
local TabMiscWebhook:Section({ Title = "Webhook", TextXAlignment = "Left", TextSize = 17 })

local TabMiscWebhook:Input({
    Title = "Webhook URL",
    Placeholder = "Enter your webhook URL",
    Value = _controls.WebhookURL or "",
    Description = "Set the webhook URL for notifications.",
    Callback = function(value)
        _controls.WebhookURL = value
        UI_NS.Functions.SetWebhookURL(value)
    end
})

local TabMiscWebhook:Toggle({
    Title = "Enable Webhook",
    State = _controls.EnableWebhook or false,
    Description = "Enable or disable webhook notifications.",
    Callback = function(state)
        _controls.EnableWebhook = state
        if state then
            UI_NS.Functions.EnableWebhook()
        else
            UI_NS.Functions.DisableWebhook()
        end
    end
})

Window:OnClose(function()
    print("Window closed")
    
    if ConfigManager and configFile then
        configFile:Set("playerData", MyPlayerData)
        configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
        configFile:Save()
        print("Config auto-saved on close")
    end
end)

Window:OnDestroy(function()
    print("Window destroyed")

end)
cvfgsggsd
klklhkk

>>>>>>> 4ddbac5ad2356c98ae2484ced64b824d8d0f3042