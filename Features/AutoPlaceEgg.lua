--========================================================
-- Auto Place Selected Egg (No GUI) — v9
-- Dependensi: getgenv().RemnantGlobals + (opsional) RemnantUI.Events.StopAllEvent
-- Dipanggil via RemnantLoader.Start("auto_place_selected_egg", URL) dari RemnantDEV
--========================================================
local function ModuleEntry(ctx)
    --==============================
    -- Shortcuts & Globals
    --==============================
    local G = (ctx and ctx.Globals) or rawget(getgenv(), "RemnantGlobals") or {}
    local UI = (ctx and ctx.UI)      or rawget(getgenv(), "RemnantUI")     or {}
    local State = (ctx and ctx.State) or rawget(getgenv(), "RemnantState") or {}

    local Players    = G.Players    or game:GetService("Players")
    local RS         = G.RS         or game:GetService("ReplicatedStorage")
    local RunService = G.RunService or game:GetService("RunService")
    local Workspace  = G.Workspace  or game:GetService("Workspace")

    local LP         = G.LP or Players.LocalPlayer
    local Backpack   = G.Backpack or LP:WaitForChild("Backpack")
    local Character  = G.Character or LP.Character or LP.CharacterAdded:Wait()

    local StopAllEvent = (UI.Events and UI.Events.StopAllEvent)  -- BindableEvent (opsional)

    -- CFG bridge (dibangun oleh RemnantDEV.buildPlaceEggCFGFromState)
    local function CFG()
        return rawget(getgenv(), "PlaceEggCFG") or {
            SelectedEggName = "",
            MaxSlots        = 1,
            MinEggGap       = 3.0,
            GridStep        = 1.0,
            OwnerFilter     = true,
            Run             = false,
        }
    end

    --==============================
    -- Utils
    --==============================
    local dead = false
    local cons = {}

    local function bind(con)
        if con then table.insert(cons, con) end
        return con
    end

    local function cleanup()
        for _,c in ipairs(cons) do pcall(function() c:Disconnect() end) end
        cons = {}
    end

    local function myHRP()
        local ch = LP.Character or LP.CharacterAdded:Wait()
        return ch:FindFirstChild("HumanoidRootPart")
    end

    local function v3(x,y,z) return Vector3.new(x,y,z) end

    local function isPetEgg(inst)
        if not inst or not inst:IsA("Model") then return false end
        local n = inst.Name:lower()
        if n:find("petegg") or n:find("egg") then return true end
        return false
    end

    -- Cari root folder world PetEgg (default dari info user)
    local PetEggRoot = nil
    local function resolvePetEggRoot()
        if PetEggRoot and PetEggRoot.Parent then return PetEggRoot end
        local ok,root = pcall(function()
            local farm  = Workspace:FindFirstChild("Farm")
            if not farm then
                for _,d in ipairs(Workspace:GetDescendants()) do
                    if d.Name == "Farm" then farm = d break end
                end
            end
            if not farm then return nil end
            local imp = farm:FindFirstChild("Important")
            if not imp then
                for _,d in ipairs(farm:GetDescendants()) do
                    if d.Name == "Important" then imp = d break end
                end
            end
            if not imp then return nil end
            local phys = imp:FindFirstChild("Objects_Physical")
            if not phys then
                for _,d in ipairs(imp:GetDescendants()) do
                    if d.Name == "Objects_Physical" then phys = d break end
                end
            end
            if not phys then return nil end
            local eggFolder = phys:FindFirstChild("PetEgg")
            if not eggFolder then
                for _,d in ipairs(phys:GetDescendants()) do
                    if d.Name == "PetEgg" then eggFolder = d break end
                end
            end
            return eggFolder
        end)
        if ok then PetEggRoot = root end
        return PetEggRoot
    end

    local function getAllWorldEggs()
        local root = resolvePetEggRoot()
        if not root then return {} end
        local t = {}
        for _,m in ipairs(root:GetChildren()) do
            if isPetEgg(m) then table.insert(t, m) end
        end
        return t
    end

    -- Cek owner (best-effort). Jika gagal deteksi owner → fallback true bila OwnerFilter=false.
    local function isOwnedByMe(model)
        local cfg = CFG()
        if cfg.OwnerFilter == false then return true end
        if not model then return false end
        -- Heuristik umum: Attribute "Owner" = userId/name; atau StringValue / IntValue child
        local ownerAttr = model:GetAttribute("Owner") or model:GetAttribute("owner") or model:GetAttribute("Player")
        if ownerAttr then
            if typeof(ownerAttr) == "number" then return ownerAttr == LP.UserId end
            if typeof(ownerAttr) == "string" then return ownerAttr == LP.Name end
        end
        -- Cari ValueObject
        for _,v in ipairs(model:GetChildren()) do
            if v:IsA("StringValue") or v:IsA("IntValue") or v:IsA("ObjectValue") then
                local name = v.Name:lower()
                if name == "owner" or name == "player" then
                    if v:IsA("IntValue") then return v.Value == LP.UserId end
                    if v:IsA("StringValue") then return v.Value == LP.Name end
                    if v:IsA("ObjectValue") and v.Value and v.Value == LP then return true end
                end
            end
        end
        -- Jika tidak ketemu penanda kepemilikan, anggap "mungkin bukan milik kita"
        return false
    end

    local function countMyEggs()
        local n = 0
        for _,m in ipairs(getAllWorldEggs()) do
            if isOwnedByMe(m) then n += 1 end
        end
        return n
    end

    local function nearestDistanceToEgg(pos)
        local dmin = math.huge
        for _,m in ipairs(getAllWorldEggs()) do
            local p = m:FindFirstChild("PrimaryPart") and m.PrimaryPart.Position
            if not p then
                local hrp = m:FindFirstChildWhichIsA("BasePart")
                if hrp then p = hrp.Position end
            end
            if p then
                local d = (p - pos).Magnitude
                if d < dmin then dmin = d end
            end
        end
        return dmin
    end

    --==============================
    -- Backpack Egg Listing & Tool
    --==============================
    local function listBackpackEggNames()
        local names = {}
        for _,desc in ipairs(Backpack:GetDescendants()) do
            if desc:IsA("Tool") or desc:IsA("Folder") then
                -- pakai heuristik nama item yang mengandung 'Egg'
                local n = desc.Name
                if n and n:lower():find("egg") then
                    names[n] = true
                end
            end
        end
        local arr = {}
        for n in pairs(names) do table.insert(arr, n) end
        table.sort(arr)
        return arr
    end

    local function findEggToolByName(name)
        if not name or name == "" then return nil end
        for _,desc in ipairs(Backpack:GetDescendants()) do
            if (desc:IsA("Tool") or desc:IsA("Folder")) and desc.Name == name then
                return desc
            end
        end
        return nil
    end

    -- Push list egg ke UI dropdown (kalau API tersedia)
    local function pushEggListToUI()
        local API = UI.API and UI.API.Egg
        if API and API.SetEggListForPlace then
            pcall(API.SetEggListForPlace, listBackpackEggNames())
        end
        if API and API.SetEggListForHatch then
            pcall(API.SetEggListForHatch, listBackpackEggNames())
        end
    end

    --==============================
    -- Remote Discovery: CreateEgg
    --==============================
    local CreateEggRemote = nil

    local function looksLikeCreateEgg(inst)
        if not inst then return false end
        if not (inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction")) then return false end
        local n = inst.Name:lower()
        if n == "createegg" then return true end
        if n:find("create") and n:find("egg") then return true end
        if n:find("place")  and n:find("egg") then return true end
        if n:find("egg") and (n:find("spawn") or n:find("make") or n:find("build")) then return true end
        -- kadang disimpan di "PetEggService" dengan child CreateEgg
        local p = inst.Parent
        if p and p.Name:lower():find("petegg") and (n:find("create") or n:find("place")) then return true end
        return false
    end

    local function resolveCreateEggRemote()
        if CreateEggRemote and CreateEggRemote.Parent then return CreateEggRemote end
        -- cari di RS dan subfolder "GameEvents"
        local candidates = {}
        for _,d in ipairs(RS:GetDescendants()) do
            if looksLikeCreateEgg(d) then table.insert(candidates, d) end
        end
        -- Prioritas: yang persis "CreateEgg"
        table.sort(candidates, function(a,b)
            local A = a.Name:lower() == "createegg" and 1 or 0
            local B = b.Name:lower() == "createegg" and 1 or 0
            if A ~= B then return A > B end
            return a:GetFullName() < b:GetFullName()
        end)
        CreateEggRemote = candidates[1]
        return CreateEggRemote
    end

    local function tryFireCreateEgg(pos)
        local r = resolveCreateEggRemote()
        if not r then return false, "CreateEgg remote not found" end
        local ok, err
        if r:IsA("RemoteEvent") then
            -- Coba beberapa signature umum
            ok = pcall(function() r:FireServer("CreateEgg", pos) end)
            if not ok then ok = pcall(function() r:FireServer(pos) end) end
            if not ok then ok = pcall(function() r:FireServer({Position=pos}) end) end
            if not ok then ok = pcall(function() r:FireServer("PlaceEgg", pos) end) end
            return ok, ok and nil or "FireServer variants failed"
        else
            ok, err = pcall(function() r:InvokeServer("CreateEgg", pos) end)
            if not ok then ok, err = pcall(function() return r:InvokeServer(pos) end) end
            if not ok then ok, err = pcall(function() return r:InvokeServer({Position=pos}) end) end
            return ok, err
        end
    end

    -- Fallback: equip tool + Activate (jika game butuh equip lalu klik)
    local function equipAndActivate(eggName)
        local tool = findEggToolByName(eggName)
        if not tool then return false, "Tool not found" end
        local ch = LP.Character or LP.CharacterAdded:Wait()
        local beforeParent = tool.Parent
        tool.Parent = ch
        task.wait(0.05)
        local ok,err = pcall(function() if tool.Activate then tool:Activate() end end)
        task.delay(0.25, function()
            -- kembalikan ke backpack bila masih di character
            if tool.Parent == ch then tool.Parent = Backpack end
        end)
        return ok, err
    end

    --==============================
    -- Grid Placement
    --==============================
    local function nextGridPosAround(basePos, maxTries)
        local cfg = CFG()
        local step   = tonumber(cfg.GridStep) or 1.0
        local gapMin = tonumber(cfg.MinEggGap) or 3.0
        maxTries = maxTries or 128

        local x0, z0 = basePos.X, basePos.Z
        local y = basePos.Y
        local ring = 0
        local tries = 0
        while tries < maxTries do
            ring += 1
            local side = math.max(1, ring)
            for dx = -side, side do
                for dz = -side, side do
                    if math.abs(dx) == side or math.abs(dz) == side then
                        local pos = v3(x0 + dx*step, y, z0 + dz*step)
                        local d = nearestDistanceToEgg(pos)
                        if d >= gapMin then
                            return pos
                        end
                        tries += 1
                        if tries >= maxTries then break end
                    end
                end
                if tries >= maxTries then break end
            end
        end
        return nil
    end

    --==============================
    -- Core Runner
    --==============================
    local function canPlaceMore()
        local cfg = CFG()
        local myCount = countMyEggs()
        return myCount < (tonumber(cfg.MaxSlots) or 1)
    end

    local function selectedEggAvailable()
        local name = tostring(CFG().SelectedEggName or "")
        if name == "" then return false end
        return findEggToolByName(name) ~= nil
    end

    local function getBasePos()
        local hrp = myHRP()
        if not hrp then return nil end
        return hrp.Position
    end

    local COOLDOWN = 0.40 -- anti spam
    local lastTry  = 0

    local function runner(aliveFn)
        -- Auto-refresh dropdown egg ketika modul aktif
        pushEggListToUI()
        bind(Backpack.ChildAdded:Connect(pushEggListToUI))
        bind(Backpack.ChildRemoved:Connect(pushEggListToUI))

        while not dead and aliveFn() do
            local cfg = CFG()
            if not cfg.Run then
                task.wait(0.25)
            else
                if tick() - lastTry < COOLDOWN then
                    task.wait(0.05)
                else
                    lastTry = tick()
                    -- 1) cek kuota slot
                    if not canPlaceMore() then
                        task.wait(0.25)
                    else
                        -- 2) cek stok egg terpilih
                        if not selectedEggAvailable() then
                            -- diem (tidak ganti egg lain)
                            task.wait(0.50)
                        else
                            -- 3) cari posisi aman
                            local base = getBasePos()
                            if not base then
                                task.wait(0.25)
                            else
                                local pos = nextGridPosAround(base, 196)
                                if not pos then
                                    -- tidak menemukan slot cukup jarak → tunggu
                                    task.wait(0.35)
                                else
                                    -- 4) coba lewat Remote
                                    local ok,err = tryFireCreateEgg(pos)
                                    if not ok then
                                        -- 5) fallback: equip+activate
                                        ok,err = equipAndActivate(cfg.SelectedEggName)
                                    end
                                    -- sedikit jeda agar server sempat spawn instance
                                    task.wait(0.15)
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end

    --==============================
    -- Public API: Start / Stop
    --==============================
    local started = false
    local stopHook = nil

    local function Start()
        if started then return end
        started = true
        dead = false

        -- If provided, let RemnantTasks manage the lifetime (nice with RemnantDEV)
        local Tasks = ctx and ctx.Tasks
        if Tasks and Tasks.Start then
            Tasks.Start("auto_place_selected_egg", function(aliveFn)
                local alive = true
                local function _alive() return alive and not dead and aliveFn() end
                task.spawn(function() runner(_alive) end)
                return function() alive = false end
            end)
        else
            -- standalone
            task.spawn(function() runner(function() return not dead end) end)
        end

        -- Listen StopAllEvent (GUI close)
        if StopAllEvent then
            stopHook = bind(StopAllEvent.Event:Connect(function()
                pcall(function() PlaceEggKILL() end)
            end))
        end
    end

    local function Stop()
        if not started then return end
        started = false
        dead = true
        cleanup()
        -- clear global KILL conn if any
    end

    --==============================
    -- Global KILL (konvensi)
    --==============================
    function _G.PlaceEggKILL()
        Stop()
    end
    rawset(getgenv(), "PlaceEggKILL", _G.PlaceEggKILL)

    -- Auto-start jika CFG.Run = true (nyaman saat toggle ON di GUI)
    task.defer(function()
        local ok = pcall(function()
            if CFG().Run then Start() end
        end)
        if not ok then -- noop
        end
    end)

    return { Start = Start, Stop = Stop }
end

return ModuleEntry
