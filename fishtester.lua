--- WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

--- Safety: Color3.fromHex fallback
local function hexToColor3(hex)
    local fn = Color3 and Color3.fromHex
    if typeof(fn) == "function" then
        return fn(hex)
    end
    hex = tostring(hex or ""):gsub("#","")
    if #hex ~= 6 then
        -- default fallback hitam
        return Color3.new(0, 0, 0)
    end
    local r = tonumber(hex:sub(1,2), 16) or 0
    local g = tonumber(hex:sub(3,4), 16) or 0
    local b = tonumber(hex:sub(5,6), 16) or 0
    return Color3.fromRGB(r, g, b)
end

--- State minimal agar Toggle tidak error
local Controls = rawget(getgenv(), "logicdevui") and getgenv().logicdevui.Controls or {}
if type(Controls) ~= "table" then Controls = {} end

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
    Color = hexToColor3("#30ff6a")
})
Window:Tag({
    Title = "Development",
    Color = hexToColor3("#315dff")
})
local TimeTag = Window:Tag({
    Title = "00:00",
    Color = hexToColor3("#000000")
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

-- Optional open button; guard jika API tidak ada di WindUI
if type(Window.EditOpenButton) == "function" then
    Window:EditOpenButton({
        Title = "",
        Icon = "rbxassetid://90524549712661",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 2,
        Color = ColorSequence.new(
            hexToColor3("#FF0F7B"),
            hexToColor3("#F89B29")
        ),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true,
    })
else
    -- Jika perlu, Anda bisa tampilkan notify atau abaikan saja
    -- WindUI:Notify({ Title = "Info", Content = "EditOpenButton tidak tersedia di versi ini", Icon = "info" })
end

--- Tabs
local TabHome     = Window:Tab({ Title = "Home",     Icon = "house" })
local TabMain     = Window:Tab({ Title = "Main",     Icon = "gamepad" })
local TabShop     = Window:Tab({ Title = "Shop",     Icon = "shopping-cart" })
local TabTeleport = Window:Tab({ Title = "Teleport", Icon = "map" })
local TabMisc     = Window:Tab({ Title = "Misc",     Icon = "cog" })

--- Home
TabHome:Section({ Title = ".devlogic", TextXAlignment = "Left",  TextSize = 17 })

--- Fishing
local SecFishing = TabMain:Section({ Title = "Fishing", Icon = "fish", Opened = true })

SecFishing:Toggle({
    Title = "Auto Fishing",
    State = Controls.AutoFishing or false,
    Description = "Automatically fishes for you.",
    Callback = function(state)
        Controls.AutoFishing = state
        print("Toggle Activated " .. tostring(state))
    end
})

-- Guard event API agar tidak call nil method
if type(Window.OnClose) == "function" then
    Window:OnClose(function()
        print("Window closed")
        -- Jangan lakukan cleanup feature di OnClose jika hanya minimize → icon
        if ConfigManager and configFile then
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
        -- Cleanup feature boleh di sini jika diperlukan
    end)
end


