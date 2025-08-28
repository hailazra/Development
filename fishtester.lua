
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
            Controls.AutoFishing = state
            if state then Funcs.StartAutoFishing() else Funcs.StopAutoFishing() end
        end
    })
end


--========== LIFECYCLE ==========
-- Tidak melakukan cleanup di OnClose (agar minimize → icon tidak memicu unload)
if type(Window.OnClose) == "function" then
    Window:OnClose(function()
        print("Window closed")
        -- Simpan konfigurasi (opsional); tidak unload feature di sini
        if typeof(ConfigManager) == "table" and configFile and typeof(configFile.Set) == "function" and typeof(configFile.Save) == "function" then
            local MyPlayerData = rawget(getgenv(), "MyPlayerData")
            configFile:Set("playerData", MyPlayerData)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            configFile:Save()
            print("Config auto-saved on close")
        end
    end)
end

-- Cleanup hanya saat benar-benar destroy
if type(Window.OnDestroy) == "function" then
    Window:OnDestroy(function()
        print("Window destroyed")
        if type(featureDestruct) == "function" then
            local ok, err = pcall(featureDestruct)
            if not ok then warn("[Feature.destroy@OnDestroy] error:", err) end
            featureDestruct = nil
        end
    end)
end