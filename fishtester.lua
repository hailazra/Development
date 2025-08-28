-- WindUI Library
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--========== WINDOW ==========
local Window = WindUI:CreateWindow({
    Title         = ".devlogic",
    Icon          = "rbxassetid://73063950477508",
    Author        = "Fish It",
    Folder        = ".devlogichub",
    Size          = UDim2.fromOffset(250, 250),
    Theme         = "Dark",
    Resizable     = false,
    SideBarWidth  = 120,
    HideSearchBar = true,
})


Window:EditOpenButton({
    Title = "",
    Icon = "rbxassetid://73063950477508",
    CornerRadius = UDim.new(0,1),
    StrokeThickness = 1,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("000000"), 
        Color3.fromHex("000000")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

Window:Tag({
    Title = "v0.0.0",
    Color = Color3.fromHex("#000000")
})

Window:Tag({
    Title = "Dev Version",
    Color = Color3.fromHex("#000000")
})

-- === Topbar Changelog (simple) ===
local CHANGELOG = table.concat({
    "[+] Optimization GUI",
}, "\n")
local DISCORD = table.concat({
    "https://discord.gg/3AzvRJFT3M",
}, "\n")
    
local function ShowChangelog()
    Window:Dialog({
        Title   = "Changelog",
        Content = CHANGELOG,
        Buttons = {
            {
                Title   = "Discord",
                Icon    = "copy",
                Variant = "Secondary",
                Callback = function()
                    if typeof(setclipboard) == "function" then
                        setclipboard(DISCORD)
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

-- helper ambil value kontrol yg compatible (tanpa integrasi apapun)
local function getValue(ctrl)
    if ctrl == nil then return nil end
    if type(ctrl.GetValue) == "function" then
        local ok, v = pcall(ctrl.GetValue, ctrl)
        if ok then return v end
    end
    return rawget(ctrl, "Value")
end

local function toListText(v)
    if typeof(v) == "table" then
        local buf = {}
        for _, item in ipairs(v) do table.insert(buf, tostring(item)) end
        return table.concat(buf, ", ")
    end
    return tostring(v)
end

--========== TABS ==========
local TabHome     = Window:Tab({ Title = "Home",     Icon = "house" })
local TabMain     = Window:Tab({ Title = "Main",     Icon = "gamepad" })
local TabTeleport = Window:Tab({ Title = "Teleport", Icon = "map" })
local TabMisc     = Window:Tab({ Title = "Misc",     Icon = "cog" })

--========== HOME ==========
do
    TabHome:Section({ Title = ".devlogic", TextXAlignment = "Left", TextSize = 17 })
end

--========== MAIN → FISHING ==========
local SecFishing = TabMain:Section({ Title = "Fishing", Icon = "fish", Opened = true })

do
    local castDelay = 500

    SecFishing:Input({
        Title = "Auto Cast Delay",
        Placeholder = "Delay Cast (ms)",
        Value = tostring(castDelay),
        Description = "Delay before casting the fishing rod.",
        NumbersOnly = true,
        Callback = function(value)
            castDelay = tonumber(value) or 500
            print("[GUI] Set Auto Cast Delay:", castDelay)
        end
    })

    SecFishing:Toggle({
        Title = "Auto Cast",
        State = false,
        Description = "Automatically casts your fishing rod.",
        Callback = function(state)
            print("[GUI] Auto Cast =", state)
        end
    })

    SecFishing:Toggle({
        Title = "Auto Reel",
        State = false,
        Description = "Automatically reels in your fishing rod.",
        Callback = function(state)
            print("[GUI] Auto Reel =", state)
        end
    })

    SecFishing:Toggle({
        Title = "Auto Fishing",
        State = false,
        Description = "Automatically fishes for you.",
        Callback = function(state)
            print("[GUI] Auto Fishing =", state)
        end
    })
end


--========== TELEPORT ==========
local SecLocations = TabTeleport:Section({ Title = "Island", Icon = "map-pin", Opened = true })
local SecPlayers   = TabTeleport:Section({ Title = "Player", Icon = "user",    Opened = false })
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
            print("[GUI] Teleport to:", toListText(loc))
        end
    })
end

do
    local PlayerDropdown = SecPlayers:Dropdown({
        Title  = "Select Player",
        Values = { "Player1", "Player2", "Player3" }, -- Dummy values
        Value  = "Player1",
        Callback = function(_) end
    })

    SecPlayers:Button({
        Title = "Teleport",
        Description = "Teleport to the selected player.",
        Callback = function()
            local ply = getValue(PlayerDropdown)
            print("[GUI] Teleport to player:", toListText(ply))
        end
    })
end

--========== MISC ==========
local SecPlayer  = TabMisc:Section({ Title = "Player",  Icon = "user", Opened = true })
local SecWebhook = TabMisc:Section({ Title = "Webhook", Icon = "link", Opened = false })
local SecServer  = TabMisc:Section({ Title = "Server",  Icon = "server", Opened = false })

do -- Player
    SecPlayer:Toggle({
        Title = "Walk On Water",
        State = false,
        Description = "Enable or disable walking on water.",
        Callback = function(state)
            print("[GUI] Walk On Water =", state)
        end
    })

    SecPlayer:Toggle({
        Title = "Anti-Oxygen",
        State = false,
        Description = "Prevent oxygen depletion while underwater.",
        Callback = function(state)
            print("[GUI] Anti-Oxygen =", state)
        end
    })
end

do -- Webhook
    local webhookURL = ""

    SecWebhook:Input({
        Title = "Webhook URL",
        Placeholder = "Enter your webhook URL",
        Value = webhookURL,
        Description = "Set the webhook URL for notifications.",
        Callback = function(value)
            webhookURL = value or ""
            print("[GUI] Webhook URL set")
        end
    })
    local Webhook = SecWebhook:Dropdown({
        Title  = "Select Fish",
        Values = { "Fish Caught", "Level Up", "Rare Fish" },
        Value  = "Fish Caught",
        Multi  = true,
        AllowNone = true,
        Callback = function(value)
            print("[GUI] Webhook Event selected:", toListText(value))
        end
    })

    SecWebhook:Toggle({
        Title = "Enable Webhook",
        State = false,
        Description = "Enable or disable webhook notifications.",
        Callback = function(state)
            print("[GUI] Webhook Enabled =", state, "URL:", webhookURL)
        end
    })
end

do -- Server
    local InputJobid = SecServer:Input({
    Title = "Job ID",
    Desc = "Enter the Job ID of the server to join.",
    Value = "000-0000-0000",
    Type = "Textarea", -- or "Textarea"
    Placeholder = "Enter Job ID...",
    Callback = function(input) 
        print("text entered: " .. input)
    end
})

    SecServer:Button({
        Title = "Join Server",
        Description = "Join the server with the specified Job ID.",
        Callback = function()
            print("[GUI] Hopping to a different server...")
        end
    })
    
    SecServer:Toggle({
        Title = "Server Hop",
        State = false,
        Description = "Automatically hop to Server Luck",
        Callback = function(state)
            print("[GUI] Auto Rejoin =", state)
        end
    })
end

--========== LIFECYCLE (tanpa cleanup integrasi) ==========
if type(Window.OnClose) == "function" then
    Window:OnClose(function()
        print("[GUI] Window closed")
        -- Tidak ada cleanup integrasi fitur di sini
    end)
end

if type(Window.OnDestroy) == "function" then
    Window:OnDestroy(function()
        print("[GUI] Window destroyed")
        -- Tidak ada cleanup integrasi fitur di sini
    end)
end