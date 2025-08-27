


-- WindUI LIbrary as Main Library
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- Theme
WindUI:AddTheme({
    Name = "DB",
    Accent = "#000328",
    Dialog = "#000328",
    Outline = "#FFFFFF",
    Text = "#FFFFFF",
    Placeholder = "#999999",
    Background = "#000e39",
    Button = "#000328",
    Icon = "#a1a1aa",
})

-- Window
Create Window (docs: Window:CreateWindow)
local Window = WindUI:CreateWindow({
    Title         = ".devlogic",
    Icon          = "brain-circuit",
    Author        = "hailazra",
    Folder        = ".devlogichub",
    Size          = UDim2.fromOffset(250, 250),
    Theme         = "DB",
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
local SecMisc =  Window:Section({ Title = "Misc", Icon = "cog", Opened = false})
local TabMisc = Window:Section({ Title = "Webhook", Icon = "link", Opened = false})

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
        Misc            = TabMisc,
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
local Tab     = UI.Tabs.Main_Fishing 