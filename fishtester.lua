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
local DLsec = TabHome:Section({ 
    Title = ".devlogic",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local ParaBoutUS = TabMain:Paragraph({
    Title = "Paragraph with Image, Thumbnail, Buttons",
    Desc = "Test Paragraph",
    Color = "Red",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {
        {
            Icon = "bird",
            Title = "Button",
            Callback = function() print("1 Button") end,
        }
    }
})

--- Main
local FishSec = TabMain:Section({ 
    Title = "Fishing",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
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

local FavSec = TabMain:Section({ 
    Title = "Favorite Fish",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local DdFavFish = TabMain:Dropdown({
    Title = "Select Fish",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " ..game:GetService("HttpService"):JSONEncode(option)) 
    end
})

local FavFish = TabMain:Toggle({
    Title = "Auto Favorite Fish",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

local SellSec = TabMain:Section({ 
    Title = "Sell Fish",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local SliderSell = TabMain:Slider({
    Title = "Backpack Capacity",
    Step = 1,
    Desc = "CUstom backpack capacity to sell",
    Value = {
        Min = 1,
        Max = 5000,
        Default =1000,
    },
    Callback = function(value)
        print(value)
    end
})

local AutoSell = TabMain:Toggle({
    Title = "Auto Sell",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

local GiftSec = TabMain:Section({ 
    Title = "Gift Fish",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local DdGift = TabMain:Dropdown({
    Title = "Select Player",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local GiftFish = TabMain:Toggle({
    Title = "Auto Gift Fish",
    Desc  = "Auto Gift held Fish",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

--- Shop
local ShopSecItem = TabShop:Section({ 
    Title = "Rod & Item",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local DdBuyRod = TabShop:Dropdown({
    Title = "Select Rod",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " ..game:GetService("HttpService"):JSONEncode(option)) 
    end
})

local BuyRodBtn = TabShop:Button({
    Title = "Buy Rod",
    Desc = "",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

local DdBuyItem = TabShop:Dropdown({
    Title = "Select Item",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " ..game:GetService("HttpService"):JSONEncode(option)) 
    end
})

local InputItemQty = TabShop:Input({
    Title = "Quantity",
    Desc = "Item Quantity",
    Value = "",
    Placeholder = "Enter quantity",
    Type = "Input", 
    Callback = function(input) 
        print("delay entered: " .. input)
    end
})

local BuyItemBtn = TabShop:Button({
    Title = "Buy Item",
    Desc = "",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

local ShopSecWeather = TabShop:Section({ 
    Title = "Weather",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local DdWeather = TabShop:Dropdown({
    Title = "Select Weather",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local BuyWeatherTgl = TabShop:Toggle({
    Title = "Auto Buy Weather",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

--- Teleport
local TeleIslandSec = TabTeleport:Section({ 
    Title = "Islands",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local DdIsland = TabTeleport:Dropdown({
    Title = "Select Island",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local IslandBtn = TabTeleport:Button({
    Title = "Teleport To Island",
    Desc = "",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

local TelePlayerSec = TabTeleport:Section({ 
    Title = "Players",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local DdPlayer = TabTeleport:Dropdown({
    Title = "Select Player",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local PlayerBtn = TabTeleport:Button({
    Title = "Teleport To Player",
    Desc = "",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

<<<<<<< HEAD

--- Misc
local ServerSec = TabMisc:Section({ 
    Title = "Join Server",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local InputJobid = TabMisc:Input({
    Title = "Job Id",
    Desc = "Input Server Job Id",
    Value = "",
    Placeholder = "000-000-000",
    Type = "Input", 
    Callback = function(input) 
        print("delay entered: " .. input)
    end
})

local JoinJobid = TabMisc:Button({
    Title = "Join Server",
    Desc = "",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

local HopServerSec = TabMisc:Section({ 
    Title = "Hop Server",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local DdServerHop = TabMisc:Dropdown({
    Title = "Select Server Luck",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local HopServerTgl = TabShop:Toggle({
    Title = "Auto Hop Server",
    Desc  = "Auto Hop until found desired Server",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

local WebhookSec = TabMisc:Section({ 
    Title = "Webhook",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local WebhookUrl = TabMisc:Input({
    Title = "Webhook URL",
    Desc = "Input Webhook URL",
    Value = "",
    Placeholder = "discord.gg//",
    Type = "Input", 
    Callback = function(input) 
        print("delay entered: " .. input)
    end
})

local DdWebhook = TabMisc:Dropdown({
    Title = "Select Fish",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " ..game:GetService("HttpService"):JSONEncode(option)) 
    end
})

local WebhookTgl = TabMisc:Toggle({
    Title = "Webhook",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

>>>>>>> 79320a16b128931bf4fbbf53d2fbce5a3007796a
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