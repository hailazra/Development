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

-- === Module Loader Registry (tempel SEKALI) ===
getgenv().Modules = getgenv().Modules or {}

local function ensureModule(key, url)
    if not getgenv().Modules[key] then
        local ok, mod = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        if not ok then
            warn(("[GUI] Load module '%s' failed: %s"):format(key, tostring(mod)))
            return nil
        end
        getgenv().Modules[key] = mod
    end
    return getgenv().Modules[key]
end

local function killModule(key)
    local M = getgenv().Modules[key]
    if M and type(M.Kill) == "function" then
        local ok, err = pcall(M.Kill)
        if not ok then warn("[GUI] Kill error:", err) end
    end
end

local function reloadModule(key, url, onReady)
    killModule(key)
    getgenv().Modules[key] = nil
    local M = ensureModule(key, url)
    if M and onReady then onReady(M) end
end

-- === Raw URLs modul fitur ===
local URLS = {
    FISH = "https://raw.githubusercontent.com/hailazra/Development/refs/heads/main/fishitfeatures.lua",
    -- Nanti tambah: PLACE=..., SELL=..., dst
}


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
 TabBackpack = Window:Tab({ Title = "Backpack", Icon = "bag" })
 TabShop     = Window:Tab({ Title = "Shop",     Icon = "shopping-bag" })
 TabTeleport = Window:Tab({ Title = "Teleport", Icon = "map" })
 TabMisc     = Window:Tab({ Title = "Misc",     Icon = "cog" })

--- === Home === ---
local DLsec = TabHome:Section({ 
    Title = ".devlogic",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local AboutUs = TabHome:Paragraph({
    Title = "About Us",
    Desc = "This script still under development, please report any bugs or issues in our discord server.",
    Color = "Red",
    ImageSize = 30,})

local DiscordBtn = TabHome:Button({
    Title = ".devlogic Discord",
    Icon  = "message-circle",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/3AzvRJFT3M") -- ganti invite kamu
        end
    end
})

--- === Main === ---
--- Auto Fish
local autofish_sec = TabMain:Section({ 
    Title = "Fishing",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local autofishmode_dd = TabMain:Dropdown({
    Title = "Fishing Mode",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
   Callback = function(option)
    -- simpan mode ke config global (boleh bikin simpel dulu)
    getgenv().LogicCFG = getgenv().LogicCFG or { Fishing = { Mode = "Category A", Auto = false } }
    getgenv().LogicCFG.Fishing.Mode = option

    -- kalau modul sudah diload & punya SetMode, update langsung
    local M = getgenv().Modules and getgenv().Modules.Fish
    if M and type(M.SetMode) == "function" then
        M.SetMode(option)
    end
end
})
    
local autofish_tgl = TabMain:Toggle({
    Title = "Auto Fishing",
    Default = false,
    Callback = function(state)
    -- pastikan ada config global
    getgenv().LogicCFG = getgenv().LogicCFG or { Fishing = { Mode = "Category A", Auto = false } }
    getgenv().LogicCFG.Fishing.Auto = state

    -- fungsi bantu: start modul dengan mode terbaru
    local function startFish(M)
        if type(M.SetMode) == "function" then
            M.SetMode(getgenv().LogicCFG.Fishing.Mode)
        end
        if type(M.Start) == "function" then
            M.Start(getgenv().LogicCFG.Fishing)
        else
            warn("[GUI] Fish module missing Start()")
        end
    end

    if state then
        -- load modul dari GitHub kalau belum ada
        local M = ensureModule("Fish", URLS.FISH)
        if not M then
            -- kalau gagal load, balikin toggle OFF biar sinkron
            if autofish_tgl and autofish_tgl.SetValue then
                autofish_tgl:SetValue(false)
            end
            getgenv().LogicCFG.Fishing.Auto = false
            return
        end
        startFish(M)
    else
        -- matikan modul saat toggle OFF
        killModule("Fish")
    end
end
})

--- Event Teleport
local eventtele_sec = TabMain:Section({ 
    Title = "Event Teleport",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local eventtele_tgl = TabMain:Toggle({
    Title = "Auto Event Teleport",
    Desc  = "Auto Teleport to Event when available",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

--- === Backpack === ---
--- Favorite Fish
local favfish_sec = TabBackpack:Section({ 
    Title = "Favorite Fish",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local favfish_ddm = TabBackpack:Dropdown({
    Title = "Select Fish",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " ..game:GetService("HttpService"):JSONEncode(option)) 
    end
})

local favfish_tgl = TabBackpack:Toggle({
    Title = "Auto Favorite Fish",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

--- Sell Fish
local sellfish_sec = TabBackpack:Section({ 
    Title = "Sell Fish",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local sellfish_ddm = TabBackpack:Dropdown({
    Title = "Select Fish",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " ..game:GetService("HttpService"):JSONEncode(option)) 
    end
})

local sellfish_in = TabBackpack:Input({
    Title = "Sell Limit",
    Placeholder = "e.g 3",
    Value = "",
    Numeric = true,
    Callback = function(value) 
        print("Input: " .. tostring(value)) 
    end
})

local sellfish_tgl = TabBackpack:Toggle({
    Title = "Auto Sell",
    Desc = "Auto Sell when reach limit",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

--- Gift Fish
local autogift_sec = TabBackpack:Section({ 
    Title = "Auto Gift",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local autogiftplayer_dd = TabBackpack:Dropdown({
    Title = "Select Player",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local autogift_tgl = TabBackpack:Toggle({
    Title = "Auto Gift Fish",
    Desc  = "Auto Gift held Fish/Item",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

--- === Shop === --- 
--- Item
local shopitem_sec = TabShop:Section({ 
    Title = "Rod & Item",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local shopitemrod_ddm = TabShop:Dropdown({
    Title = "Select Rod",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " ..game:GetService("HttpService"):JSONEncode(option)) 
    end
})

local shopitemrod_tgl = TabShop:Button({
    Title = "Buy Rod",
    Desc = "",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

local shopitemitem_ddm = TabShop:Dropdown({
    Title = "Select Item",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " ..game:GetService("HttpService"):JSONEncode(option)) 
    end
})

local shopitemitem_in = TabShop:Input({
    Title = "Quantity",
    Desc = "Item Quantity",
    Value = "",
    Placeholder = "Enter quantity",
    Type = "Input", 
    Callback = function(input) 
        print("delay entered: " .. input)
    end
})

local shopitemitem_btn = TabShop:Button({
    Title = "Buy Item",
    Desc = "",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

--- Weather
local shopweather_sec = TabShop:Section({ 
    Title = "Weather",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local shopweather_ddm = TabShop:Dropdown({
    Title = "Select Weather",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " ..game:GetService("HttpService"):JSONEncode(option)) 
    end
})

local shopweather_tgl = TabShop:Toggle({
    Title = "Auto Buy Weather",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

--- === Teleport === ---
local teleisland_sec = TabTeleport:Section({ 
    Title = "Islands",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local teleisland_dd = TabTeleport:Dropdown({
    Title = "Select Island",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local teleisland_btn = TabTeleport:Button({
    Title = "Teleport To Island",
    Desc = "",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

local teleplayer_sec = TabTeleport:Section({ 
    Title = "Players",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local teleplayer_dd = TabTeleport:Dropdown({
    Title = "Select Player",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local teleplayer_btn = TabTeleport:Button({
    Title = "Teleport To Player",
    Desc = "",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

--- === Misc === ---
--- Server
local servutils_sec = TabMisc:Section({ 
    Title = "Join Server",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local servjoin_in = TabMisc:Input({
    Title = "Job Id",
    Desc = "Input Server Job Id",
    Value = "",
    Placeholder = "000-000-000",
    Type = "Input", 
    Callback = function(input) 
        print("delay entered: " .. input)
    end
})

local servjoin_btn = TabMisc:Button({
    Title = "Join Server",
    Desc = "",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

local servcopy_btn = TabMisc:Button({
    Title = "Copy Server ID",
    Desc = "Copy Current Server Job ID",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

--- Server Hop
local servhop_sec = TabMisc:Section({ 
    Title = "Hop Server",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local servhop_dd = TabMisc:Dropdown({
    Title = "Select Server Luck",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local servhop_tgl = TabMisc:Toggle({
    Title = "Auto Hop Server",
    Desc  = "Auto Hop until found desired Server",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})


--- Webhook
local webhookfish_sec = TabMisc:Section({ 
    Title = "Webhook",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local webhookfish_in = TabMisc:Input({
    Title = "Webhook URL",
    Desc = "Input Webhook URL",
    Value = "",
    Placeholder = "discord.gg//",
    Type = "Input", 
    Callback = function(input) 
        print("delay entered: " .. input)
    end
})

local webhookfish_dd = TabMisc:Dropdown({
    Title = "Select Fish",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " ..game:GetService("HttpService"):JSONEncode(option)) 
    end
})

local webhookfish_tgl = TabMisc:Toggle({
    Title = "Webhook",
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