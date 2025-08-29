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

WindUI:SetFont("rbxasset://12187366657")

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
 TabHome     = Window:Tab({ Title = "Home",     Icon = "house" })
 TabMain     = Window:Tab({ Title = "Main",     Icon = "gamepad" })
 TabShop     = Window:Tab({ Title = "Shop",     Icon = "shopping-bag" })
 TabTeleport = Window:Tab({ Title = "Teleport", Icon = "map" })
 TabMisc     = Window:Tab({ Title = "Misc",     Icon = "cog" })

--- Home
TabHome:Section({ Title = ".devlogic", TextXAlignment = "Left", TextSize = 17 })

--- Main
local FishSec = TabMain:Section({ 
    Title = "Fishing",
    TextXAlignment = "Left",
    TextSize = 15, -- Default Size
})

local InputDelay = TabMain:Input({
    Title = "Cast Delay",
    Desc = "Delay to Cast",
    Value = "",
    Placeholder = "Enter delay",
    Type = "Input", 
    Callback = function(input) 
        print("delay entered: " .. input)
    end
})

local ToggleCast = TabMain:Toggle({
    Title = "Auto Cast",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})
    
local AutoFish = TabMain:Toggle({
    Title = "Auto Fishing",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

local InstantFish = TabMain:Toggle({
    Title = "Instant Fish",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})


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