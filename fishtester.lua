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


-- ====== 1) Matikan OpenButton bawaan WindUI biar gak dobel ======
pcall(function()
    Window:EditOpenButton({ Enabled = false })
end)

-- ====== 2) Buat tombol logo mengambang (minimize/restore) ======
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LOGO_ASSET_ID = 73063950477508 -- <-- GANTI ke Image ID logo kamu (rbxassetid://ID)

-- container
local MiniGui = Instance.new("ScreenGui")
MiniGui.Name = "DevlogicMini"
MiniGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MiniGui.ResetOnSpawn = false
MiniGui.Parent = CoreGui

-- tombol
local MiniBtn = Instance.new("ImageButton")
MiniBtn.Name = "MiniButton"
MiniBtn.BackgroundTransparency = 1
MiniBtn.AutoButtonColor = true
MiniBtn.Size = UDim2.fromOffset(56, 56)          -- ukuran icon (mobile-friendly 50–64)
MiniBtn.Position = UDim2.fromOffset(20, 200)     -- posisi awal (ubah sesuka hati)
MiniBtn.Draggable = true                          -- drag & drop sederhana
MiniBtn.Image = ("rbxassetid://%d"):format(LOGO_ASSET_ID)
MiniBtn.Parent = MiniGui

-- sudut bulat & ring tipis biar keliatan tombol
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = MiniBtn

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Transparency = 0.25
stroke.Parent = MiniBtn

-- jaga aspek (biar gak gepeng saat di-resize)
local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1
aspect.DominantAxis = Enum.DominantAxis.Width
aspect.Parent = MiniBtn

-- padding kecil biar gambar gak nempel pinggir
local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 6)
pad.PaddingBottom = UDim.new(0, 6)
pad.PaddingLeft = UDim.new(0, 6)
pad.PaddingRight = UDim.new(0, 6)
pad.Parent = MiniBtn

-- ====== 3) Toggle langsung lewat API WindUI ======
local minimized = false  -- start: window visible

-- helper anim
local function bump(btn)
    local t = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(btn, t, { Size = UDim2.fromOffset(60, 60) }):Play()
    task.delay(0.08, function()
        TweenService:Create(btn, t, { Size = UDim2.fromOffset(56, 56) }):Play()
    end)
end

-- fungsi show/hide window
local function SetWindowVisible(visible: boolean)
    minimized = not visible
    -- WindUI expose SetVisible / Toggle pada window; kalau tidak ada, fallback ke Enabled
    local ok = pcall(function() Window:SetVisible(visible) end)
    if not ok then
        -- fallback: cari ScreenGui utama WindUI (heuristik aman)
        local gui = MiniGui.Parent:FindFirstChildWhichIsA("ScreenGui")
        if gui then gui.Enabled = visible end
    end
end

MiniBtn.MouseButton1Click:Connect(function()
    bump(MiniBtn)
    SetWindowVisible(minimized)  -- kebalikan: kalau lagi minimized, buka; kalau buka, minimize
end)

-- ====== 4) (Opsional) auto-hide logo saat window terbuka penuh ======
-- kalau kamu mau logo hanya muncul saat di-minimize, aktifkan block ini
do
    local function syncLogo()
        MiniBtn.Visible = minimized
    end
    -- coba hook event bawaan WindUI jika ada
    local ok, ev = pcall(function() return Window.VisibilityChanged end)
    if ok and typeof(ev) == "RBXScriptSignal" then
        ev:Connect(function(isVisible)
            minimized = not isVisible
            syncLogo()
        end)
    end
    -- inisialisasi
    syncLogo()
end

-- ====== 5) (Opsional) simpan posisi tombol antar re-execute ======
-- pakai getgenv untuk simple persistence di sesi eksekusi
getgenv().DevlogicMiniPos = getgenv().DevlogicMiniPos or MiniBtn.Position
MiniBtn.Position = getgenv().DevlogicMiniPos
MiniBtn:GetPropertyChangedSignal("Position"):Connect(function()
    getgenv().DevlogicMiniPos = MiniBtn.Position
end)


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
local TabShop     = Window:Tab({ Title = "Shop",     Icon = "shopping-cart" })
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

--========== SHOP → ITEM & WEATHER ==========
local SecShopItem    = TabShop:Section({ Title = "Item",    Icon = "wrench", Opened = true })
local SecShopWeather = TabShop:Section({ Title = "Weather", Icon = "cloud",  Opened = true })

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
            print("[GUI] Buy Rod:", toListText(selected))
        end
    })

    local ItemDropdown = SecShopItem:Dropdown({
        Title  = "Select Item",
        Values = { "Bait", "Lure", "Fish Finder" },
        Value  = "Bait",
        Multi  =  true,
        Callback = function(_) end
    })

    local qty = 1
    SecShopItem:Input({
        Title = "Item Quantity",
        Placeholder = "Enter quantity",
        Value = tostring(qty),
        NumbersOnly = true,
        Callback = function(v)
            qty = tonumber(v) or 1
            print("[GUI] Set Item Quantity:", qty)
        end
    })

    SecShopItem:Button({
        Title = "Buy Item",
        Description = "Purchase the selected item in the specified quantity.",
        Callback = function()
            local item = getValue(ItemDropdown)
            print(string.format("[GUI] Buy Item: %s x%d", toListText(item), qty))
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
            print("[GUI] Buy Weather:", toListText(weather))
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
            print("[GUI] Teleport to:", toListText(loc))
        end
    })
end

--========== MISC ==========
local SecPlayer  = TabMisc:Section({ Title = "Player",  Icon = "user", Opened = true })
local SecWebhook = TabMisc:Section({ Title = "Webhook", Icon = "link", Opened = false })

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

    SecWebhook:Toggle({
        Title = "Enable Webhook",
        State = false,
        Description = "Enable or disable webhook notifications.",
        Callback = function(state)
            print("[GUI] Webhook Enabled =", state, "URL:", webhookURL)
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


