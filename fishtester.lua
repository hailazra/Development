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


-- =========================================================
--  .devlogic — Custom Minimize Button (Logo Only When Minimized)
--  Drop-in setelah kamu bikin `Window = WindUI:CreateWindow({...})`
-- =========================================================

-- 0) Konfigurasi
local LOGO_ASSET_ID = 73063950477508   -- <-- GANTI ke Image ID logo kamu (angka saja)
local BUTTON_SIZE   = 56           -- px (50–64 ramah mobile)
local BUTTON_PAD    = 6            -- px padding di dalam tombol
local START_POS     = UDim2.fromOffset(20, 200) -- posisi awal icon

-- 1) Matikan OpenButton bawaan WindUI (biar gak dobel)
pcall(function()
    Window:EditOpenButton({ Enabled = false })
end)

-- 2) Buat tombol logo mengambang
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local MiniGui = Instance.new("ScreenGui")
MiniGui.Name = "DevlogicMini"
MiniGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MiniGui.ResetOnSpawn = false
MiniGui.Parent = CoreGui

local MiniBtn = Instance.new("ImageButton")
MiniBtn.Name = "MiniButton"
MiniBtn.BackgroundTransparency = 1
MiniBtn.AutoButtonColor = true
MiniBtn.Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE)
MiniBtn.Position = START_POS
MiniBtn.Draggable = true
MiniBtn.Image = ("rbxassetid://%d"):format(LOGO_ASSET_ID)
MiniBtn.Visible = false -- default: tersembunyi saat window terbuka
MiniBtn.Parent = MiniGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = MiniBtn

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Transparency = 0.25
stroke.Parent = MiniBtn

local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1
aspect.DominantAxis = Enum.DominantAxis.Width
aspect.Parent = MiniBtn

local pad = Instance.new("UIPadding")
pad.PaddingTop    = UDim.new(0, BUTTON_PAD)
pad.PaddingBottom = UDim.new(0, BUTTON_PAD)
pad.PaddingLeft   = UDim.new(0, BUTTON_PAD)
pad.PaddingRight  = UDim.new(0, BUTTON_PAD)
pad.Parent = MiniBtn

-- 3) Toggle helper (API WindUI + fallback)
local minimized = false -- start: window visible, logo hidden

local function SafeSetVisible(visible: boolean)
    -- Coba API resmi WindUI
    local ok = pcall(function() Window:SetVisible(visible) end)
    if not ok then
        -- Fallback: enable/disable ScreenGui teratas yang kira-kira milik WindUI
        -- (aman karena OpenButton bawaan sudah kita nonaktifkan)
        local topGui
        for _, gui in ipairs(CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= MiniGui then
                -- heuristik: ambil yang punya frame besar
                local size = Vector2.new()
                pcall(function() size = gui.AbsoluteSize end)
                if size.X >= 200 and size.Y >= 150 then
                    topGui = gui
                    break
                end
            end
        end
        if topGui then topGui.Enabled = visible end
    end
end

local function SetWindowVisible(visible: boolean)
    minimized = not visible
    SafeSetVisible(visible)
    MiniBtn.Visible = minimized
end

-- 4) Animasi kecil pada click
local function bump(btn)
    local t = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(btn, t, { Size = UDim2.fromOffset(BUTTON_SIZE + 4, BUTTON_SIZE + 4) }):Play()
    task.delay(0.08, function()
        TweenService:Create(btn, t, { Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE) }):Play()
    end)
end

MiniBtn.MouseButton1Click:Connect(function()
    bump(MiniBtn)
    SetWindowVisible(minimized) -- kalau minimized → buka, kalau buka → minimize
end)

-- 5) Public API kecil (kalau kamu mau panggil dari tempat lain)
getgenv().Devlogic = getgenv().Devlogic or {}
function getgenv().Devlogic.Minimize() SetWindowVisible(false) end
function getgenv().Devlogic.Restore()  SetWindowVisible(true)  end
function getgenv().Devlogic.Toggle()   SetWindowVisible(minimized) end

-- 6) Simpan posisi tombol antar re-exec (opsional)
getgenv().DevlogicMiniPos = getgenv().DevlogicMiniPos or MiniBtn.Position
MiniBtn.Position = getgenv().DevlogicMiniPos
MiniBtn:GetPropertyChangedSignal("Position"):Connect(function()
    getgenv().DevlogicMiniPos = MiniBtn.Position
end)

-- 7) (Opsional) Edge-snap sederhana saat lepas drag (biar rapi di tepi layar)
local function edgeSnap()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local abs = MiniBtn.AbsolutePosition
    local size = MiniBtn.AbsoluteSize
    local leftDist  = abs.X
    local rightDist = vp.X - (abs.X + size.X)
    local targetX
    if leftDist <= rightDist then
        targetX = 10
    else
        targetX = vp.X - size.X - 10
    end
    local targetY = math.clamp(abs.Y, 10, vp.Y - size.Y - 10)
    MiniBtn:TweenPosition(UDim2.fromOffset(targetX, targetY), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
end

MiniBtn.MouseLeave:Connect(function()
    -- kalau habis drag biasanya mouse leave, coba snap
    task.delay(0.02, edgeSnap)
end)

-- 8) Inisialisasi: pastikan window tampil dulu (logo hidden)
SetWindowVisible(true)



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


