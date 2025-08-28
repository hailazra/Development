
--- WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

--- Window
local Window = WindUI:CreateWindow({
    Title         = ".devlogic",
    Icon          = "brain-circuit",
    Author        = "Fish It",
    Folder        = ".devlogic",
    Size          = UDim2.fromOffset(250, 250),
    Theme         = "Dark",
    Resizable     = false,
    SideBarWidth  = 120,
    HideSearchBar = true,
})

Window:Tag({
    Title = "v0.0.0",
    Color = Color3.fromHex("#30ff6a")
})
Window:Tag({
    Title = "Development",
    Color = Color3.fromHex("#315dff")
})
local TimeTag = Window:Tag({
    Title = "00:00",
    Color = Color3.fromHex("#000000")
})

-- === Topbar Changelog (simple) ===
local CHANGELOG = table.concat({
    "[+] GUI",
}, "\n")

local function ShowChangelog()
    Window:Dialog({
        Title   = "Changelog",
        Content = CHANGELOG,
        Buttons = {
            {
                Title   = "Copy",
                Icon    = "copy",
                Variant = "Secondary",
                Callback = function()
                    if typeof(setclipboard) == "function" then
                        setclipboard(CHANGELOG)
                        WindUI:Notify({ Title = "Copied", Content = "Changelog copied", Icon = "check", Duration = 2 })
                    else
                        WindUI:Notify({ Title = "Info", Content = "Clipboard not available", Icon = "info", Duration = 3 })
                    end
                end
            },
            { Title = "Close", Variant = "Primary" }
        }
    })
end

-- name, icon, callback, order
Window:CreateTopbarButton("changelog", "newspaper", ShowChangelog, 995)

Window:EditOpenButton({
    Title = "",
    Icon = "rbxassetid://90524549712661",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--- Tabs
TabHome     = Window:Tab({ Title = "Home",     Icon = "house" })
TabMain     = Window:Tab({ Title = "Main",     Icon = "gamepad" })
TabShop     = Window:Tab({ Title = "Shop",     Icon = "shopping-cart" })
TabTeleport = Window:Tab({ Title = "Teleport", Icon = "map" })
TabMisc     = Window:Tab({ Title = "Misc",     Icon = "cog" })

--- Home
TabHome:Section({ Title = ".devlogic", TextXAlignment = "Left",  TextSize = 17 })

--- Fishing
SecFishing = TabMain:Section({ Title = "Fishing", Icon = "fish", Opened = true })

SecFishing:Toggle({
        Title = "Auto Fishing",
        State = Controls.AutoFishing or false,
        Description = "Automatically fishes for you.",
         Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
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


