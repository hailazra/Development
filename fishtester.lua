-- WindUI Library
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--========== WINDOW ==========
local Window = WindUI:CreateWindow({
    Title         = ".devlogic",
    Icon          = "brain-circuit",
    Author        = "Fish It",
    Folder        = ".devlogichub",
    Size          = UDim2.fromOffset(250, 250),
    Theme         = "Dark",
    Resizable     = false,
    SideBarWidth  = 120,
    HideSearchBar = true,
})


-- ========== KONFIG OPEN BUTTON (biar bulat & kosong) ==========
Window:EditOpenButton({
  Title            = "",             -- kosongin label
  Icon             = "",             -- jangan pakai icon lucide
  CornerRadius     = UDim.new(1, 0), -- bulat penuh
  StrokeThickness  = 0,
  OnlyMobile       = false,
  Enabled          = true,
  Draggable        = true,
})

-- ========== INJECT LOGO KAMU KE DALAM OPEN BUTTON ==========
local LOGO_ASSET_ID = 90524549712661 -- <-- GANTI dengan ID logo kamu
local CoreGui = game:GetService("CoreGui")

-- helper: cari tombol open WindUI secara defensif
local function findWindUIOpenButton()
  -- cari candidate tombol kecil yang muncul ketika minimize
  local best
  for _, gui in ipairs(CoreGui:GetDescendants()) do
    if gui:IsA("ImageButton") or gui:IsA("TextButton") then
      local name = (gui.Name or ""):lower()
      -- heuristik: biasanya ada "open" / atau tombol kecil mengambang
      if name:find("open") or (gui.AbsoluteSize.X <= 120 and gui.AbsoluteSize.Y <= 120) then
        -- punya UICorner (WindUI pakai ini), draggable look & feels
        if gui:FindFirstChildOfClass("UICorner") then
          best = gui
          break
        end
      end
    end
  end
  return best
end

-- pasang logo ketika tombol sudah dibuat oleh WindUI
task.spawn(function()
  local btn
  for _ = 1, 100 do
    btn = findWindUIOpenButton()
    if btn then break end
    task.wait(0.05)
  end
  if not btn then
    warn("[.devlogic] Gagal menemukan OpenButton WindUI.")
    return
  end

  -- pastikan bentuk bulat
  local corner = btn:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
  corner.CornerRadius = UDim.new(1, 0)
  corner.Parent = btn

  -- bersihkan child default (kecuali dekor)
  for _, c in ipairs(btn:GetChildren()) do
    if not c:IsA("UICorner") and not c:IsA("UIStroke") and not c:IsA("UIGradient") then
      c:Destroy()
    end
  end

  -- jadikan tombol benar-benar kotak/bulat mungil (opsional, sesuaikan)
  -- kalau kamu mau ukuran spesifik, set di sini:
  -- btn.Size = UDim2.fromOffset(56, 56)

  -- tempel logo kamu full-bleed, tapi input transparan agar klik tetap ke tombol
  local logo = Instance.new("ImageLabel")
  logo.Name = "DevlogicLogo"
  logo.BackgroundTransparency = 1
  logo.Image = ("rbxassetid://%d"):format(LOGO_ASSET_ID)
  logo.ScaleType = Enum.ScaleType.Fit
  logo.Size = UDim2.fromScale(1, 1)
  logo.Position = UDim2.fromScale(0, 0)
  logo.InputTransparent = true   -- << penting: biar klik tetap kena tombol
  logo.ZIndex = (btn.ZIndex or 1) + 1
  logo.Parent = btn

  -- jaga rasio logo supaya tidak gepeng
  local aspect = Instance.new("UIAspectRatioConstraint")
  aspect.AspectRatio = 1
  aspect.DominantAxis = Enum.DominantAxis.Width
  aspect.Parent = logo

  -- padding kecil biar ada napas (opsional)
  local pad = Instance.new("UIPadding")
  pad.PaddingTop    = UDim.new(0, 6)
  pad.PaddingBottom = UDim.new(0, 6)
  pad.PaddingLeft   = UDim.new(0, 6)
  pad.PaddingRight  = UDim.new(0, 6)
  pad.Parent = logo

  -- (opsional) ring halus biar keliatan tombol
  local stroke = btn:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
  stroke.Thickness = 1
  stroke.Transparency = 0.2
  stroke.Parent = btn

  -- (opsional) anim tipis saat hover
  local TweenService = game:GetService("TweenService")
  local info = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
  btn.MouseEnter:Connect(function()
    TweenService:Create(logo, info, { ImageTransparency = 0 }):Play()
    TweenService:Create(stroke, info, { Transparency = 0.05 }):Play()
  end)
  btn.MouseLeave:Connect(function()
    TweenService:Create(logo, info, { ImageTransparency = 0 }):Play()
    TweenService:Create(stroke, info, { Transparency = 0.2 }):Play()
  end)
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


