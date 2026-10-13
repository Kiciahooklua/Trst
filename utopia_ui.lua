--// Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local LoadingTick = os.clock()

--// Load Library
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/Zoophack/Library.lua"
))()

--// Window
local Window = Library:Window({
    Name = "U T O P I A",
    GradientTitle = {
        Enabled = false,
        Start  = Color3.fromRGB(255, 255, 255),
        Middle = Color3.fromRGB(0, 251, 255),
        End    = Color3.fromRGB(50, 135, 168),
        Speed  = 1
    }
})

local Watermark = Library:Watermark(
    "U T O P I A",
    { "77974153657891", Color3.fromRGB(149, 255, 139) }
)
local KeybindList = Library:KeybindList()

--// Responsive UI
do
    local MainFrame = Window.Items["Outline"]
    if MainFrame and MainFrame.Instance then
        local Frame = MainFrame.Instance
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position    = UDim2.new(0.5, 0, 0.5, 0)
        Frame.Size        = UDim2.new(0, 700, 0, 420)
        local ex = Frame:FindFirstChild("ResponsiveScale")
        if ex then ex:Destroy() end
        local Scale = Instance.new("UIScale")
        Scale.Name   = "ResponsiveScale"
        Scale.Parent = Frame
        local BW, BH = 700, 420
        local function UpdateScale()
            local cam = workspace.CurrentCamera
            if not cam then return end
            local vp = cam.ViewportSize
            if vp.X <= 0 or vp.Y <= 0 then return end
            Scale.Scale = math.clamp(math.min(vp.X/BW, vp.Y/BH)*0.90, 0.55, 1.25)
        end
        UpdateScale()
        local cam = workspace.CurrentCamera
        if cam then cam:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale) end
        workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            local nc = workspace.CurrentCamera
            if nc then nc:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale); UpdateScale() end
        end)
    end
end

--// Mobile toggle
do
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local GetHui  = gethui or function() return CoreGui end
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "UtopiaToggle"; ToggleGui.ResetOnSpawn = false
    ToggleGui.IgnoreGuiInset = true; ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ToggleGui.Parent = GetHui()
    local TB = Instance.new("TextButton")
    TB.Name = "Toggle"; TB.Parent = ToggleGui
    TB.AnchorPoint = Vector2.new(0, 0.5); TB.Position = UDim2.new(0,15,0.5,50)
    TB.Size = UDim2.new(0,70,0,32); TB.BackgroundColor3 = Color3.fromRGB(25,25,25)
    TB.BorderSizePixel = 1; TB.BorderColor3 = Color3.fromRGB(68,68,68)
    TB.AutoButtonColor = false; TB.Text = "OPEN"
    TB.TextColor3 = Color3.fromRGB(255,255,255); TB.TextSize = 12
    TB.Font = Enum.Font.Gotham; TB.ZIndex = 100
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,5); c.Parent = TB
    local s = Instance.new("UIScale"); s.Name = "ResponsiveScale"; s.Scale = 0.90; s.Parent = TB
    local TouchStart, TouchMoved = nil, false
    local DT = 18
    TB.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then TouchStart = i.Position; TouchMoved = false
        elseif i.UserInputType == Enum.UserInputType.MouseButton1 then
            Window:SetOpen(not Window.IsOpen); TB.Text = Window.IsOpen and "CLOSE" or "OPEN" end
    end)
    local function cd(i)
        if i.UserInputType ~= Enum.UserInputType.Touch or not TouchStart then return end
        if (i.Position - TouchStart).Magnitude >= DT then TouchMoved = true end
    end
    TB.InputChanged:Connect(cd); UserInputService.InputChanged:Connect(cd)
    TB.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            if TouchStart and not TouchMoved then Window:SetOpen(not Window.IsOpen); TB.Text = Window.IsOpen and "CLOSE" or "OPEN" end
            TouchStart, TouchMoved = nil, false end
    end)
    LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); if ToggleGui.Parent == nil then ToggleGui.Parent = GetHui() end end)
end

--// Pages
local CombatTab   = Window:Page({ Name = "Combat",   Columns = 2 })
local RagebotTab  = Window:Page({ Name = "Ragebot",  Columns = 2 })
local MiscTab     = Window:Page({ Name = "Misc",      Columns = 2 })
local VisualsTab  = Window:Page({ Name = "Visuals",   Columns = 2 })
local WorldTab    = Window:Page({ Name = "World",     Columns = 2 })
local PlayersTab  = Window:Page({ Name = "Players",   Columns = 1 })
local SettingsTab = Window:Page({ Name = "Settings",  Columns = 2 })

-- ============================================================
--// COMBAT TAB  (Aimbot | SilentAim + Triggerbot)
-- ============================================================
local AimbotSec   = CombatTab:Section({ Name = "Aimbot",              Side = 1 })
local SilentSec   = CombatTab:Section({ Name = "Silent Aim / Trigger", Side = 2 })

-- Aimbot
local AimbotToggle = AimbotSec:Toggle({
    Name = "Aimbot", Default = false, Flag = "Aimbot", Risky = true,
    Tooltip = "Locks onto enemies",
    Callback = function(v) print("Aimbot:", v) end
})
AimbotToggle:Colorpicker({ Name = "Aimbot Color", Flag = "AimbotColor",
    Default = Color3.fromRGB(255,0,0), Callback = function(v,a) end })

AimbotSec:Dropdown({ Name = "Aim Mode", Flag = "Aimbot_Mode",
    Items = { "Silent", "Camera", "Mouse" }, Default = "Silent", Multi = false,
    Callback = function(v) print("Aim Mode:", v) end })

AimbotSec:Dropdown({ Name = "Aim Point", Flag = "Aimbot_AimPoint",
    Items = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm" },
    Default = "Head", Multi = false,
    Callback = function(v) print("Aim Point:", v) end })

AimbotSec:Slider({ Name = "AI Speed", Flag = "Aimbot_Speed",
    Min = 0, Max = 5, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Aim Speed:", v) end })

AimbotSec:Slider({ Name = "Reaction Delay (s)", Flag = "Aimbot_ReactionTime",
    Min = 0, Max = 1, Default = 0, Decimals = 0.01,
    Callback = function(v) print("Reaction:", v) end })

AimbotSec:Slider({ Name = "Switch Delay (s)", Flag = "Aimbot_SwitchDelay",
    Min = 0, Max = 2, Default = 0, Decimals = 0.01,
    Callback = function(v) print("Switch Delay:", v) end })

AimbotSec:Toggle({ Name = "Target Lock", Default = false, Flag = "Aimbot_TargetLock",
    Callback = function(v) print("Target Lock:", v) end })

AimbotSec:Dropdown({ Name = "Lock Mode", Flag = "Aimbot_LockMode",
    Items = { "Closest", "Lowest HP", "Highest HP", "Random" }, Default = "Closest", Multi = false,
    Callback = function(v) print("Lock Mode:", v) end })

AimbotSec:Dropdown({ Name = "Activation Rules", Flag = "Aimbot_ActivationConditions",
    Items = { "Always", "On Key", "When ADS", "On Sprint" }, Default = "Always", Multi = true,
    Callback = function(v) print("Activation:", v) end })

AimbotSec:Toggle({ Name = "Show Targeting Circle", Default = false, Flag = "Aimbot_ShowCircle",
    Callback = function(v) print("Show Circle:", v) end })

AimbotSec:Label("Aim Keybind", "Left"):Keybind({ Name = "Aim Key", Flag = "AimKey",
    Default = Enum.KeyCode.Unknown, Mode = "Hold",
    Callback = function(v) print("Aim Key:", v) end })

-- Silent Aim + Triggerbot
SilentSec:Toggle({ Name = "Silent Aim", Default = false, Flag = "SilentAim", Risky = true,
    Callback = function(v) print("Silent Aim:", v) end })

SilentSec:Slider({ Name = "Activation Chance (%)", Flag = "SilentAim_Chance",
    Min = 0, Max = 100, Default = 100, Suffix = "%", Decimals = 1,
    Callback = function(v) print("SA Chance:", v) end })

SilentSec:Slider({ Name = "Reaction Delay (s)", Flag = "SilentAim_Reaction",
    Min = 0, Max = 1, Default = 0, Decimals = 0.01,
    Callback = function(v) print("SA Reaction:", v) end })

SilentSec:Slider({ Name = "Switch Delay (s)", Flag = "SilentAim_SwitchDelay",
    Min = 0, Max = 2, Default = 0, Decimals = 0.01,
    Callback = function(v) print("SA Switch:", v) end })

SilentSec:Dropdown({ Name = "Activation Rules", Flag = "SilentAim_Conditions",
    Items = { "Always", "On Key", "When ADS", "On Sprint" }, Default = "Always", Multi = true,
    Callback = function(v) print("SA Conditions:", v) end })

SilentSec:Toggle({ Name = "Triggerbot", Default = false, Flag = "Triggerbot", Risky = true,
    Callback = function(v) print("Triggerbot:", v) end })

SilentSec:Slider({ Name = "Shot Delay (ms)", Flag = "Triggerbot_ReactionTime",
    Min = 0, Max = 500, Default = 50, Decimals = 1,
    Callback = function(v) print("TB Delay:", v) end })

SilentSec:Slider({ Name = "Release Delay (s)", Flag = "Triggerbot_ReleaseTime",
    Min = 0, Max = 1, Default = 0, Decimals = 0.01,
    Callback = function(v) print("TB Release:", v) end })

SilentSec:Dropdown({ Name = "Target Filters", Flag = "Triggerbot_TargetConditions",
    Items = { "Enemies Only", "Team Check", "All" }, Default = "Enemies Only", Multi = false,
    Callback = function(v) print("TB Filters:", v) end })

SilentSec:Label("Trigger Keybind", "Left"):Keybind({ Name = "Trigger Key", Flag = "TriggerKey",
    Default = Enum.KeyCode.Unknown, Mode = "Hold",
    Callback = function(v) print("Trigger Key:", v) end })

-- ============================================================
--// RAGEBOT TAB  (Ragebot | Hitbox)
-- ============================================================
local RageSec    = RagebotTab:Section({ Name = "Ragebot",     Side = 1 })
local HitboxSec  = RagebotTab:Section({ Name = "Hitbox / Evasion", Side = 2 })

RageSec:Toggle({ Name = "Ragebot", Default = false, Flag = "Ragebot", Risky = true,
    Callback = function(v) print("Ragebot:", v) end })

RageSec:Toggle({ Name = "Prioritize Hackers", Default = false, Flag = "Ragebot_PrioritizeHackers",
    Callback = function(v) print("Prio Hackers:", v) end })

RageSec:Toggle({ Name = "Utilize Health Lead", Default = false, Flag = "Ragebot_HealthLead",
    Callback = function(v) print("Health Lead:", v) end })

RageSec:Slider({ Name = "Shoot Frames", Flag = "Ragebot_ShootFrames",
    Min = 1, Max = 10, Default = 1, Decimals = 1,
    Callback = function(v) print("Shoot Frames:", v) end })

RageSec:Slider({ Name = "Stability", Flag = "Ragebot_Stability",
    Min = 0, Max = 1, Default = 0.5, Decimals = 0.01,
    Callback = function(v) print("Stability:", v) end })

RageSec:Dropdown({ Name = "Weapon Priority", Flag = "Ragebot_WeaponPriority",
    Items = { "Katana", "Bow", "Pistol", "Shuriken", "Shotgun", "Rifle" },
    Default = nil, Multi = true,
    Callback = function(v) print("Weapon Priority:", v) end })

RageSec:Dropdown({ Name = "On Empty", Flag = "Ragebot_OnEmpty",
    Items = { "Skip", "Any", "Melee" }, Default = "Skip", Multi = false,
    Callback = function(v) print("On Empty:", v) end })

HitboxSec:Dropdown({ Name = "Hitbox Selection", Flag = "Ragebot_HitboxType",
    Items = { "Head", "Body", "Nearest", "Random" }, Default = "Head", Multi = false,
    Callback = function(v) print("Hitbox:", v) end })

HitboxSec:Slider({ Name = "Surface Reduction (%)", Flag = "Ragebot_SurfaceReduction",
    Min = 0, Max = 100, Default = 0, Suffix = "%", Decimals = 1,
    Callback = function(v) print("Surface Reduction:", v) end })

HitboxSec:Toggle({ Name = "Preserve Depth", Default = false, Flag = "Ragebot_PreserveDepth",
    Callback = function(v) print("Preserve Depth:", v) end })

HitboxSec:Dropdown({ Name = "Evasion Mode", Flag = "Ragebot_EvasionMode",
    Items = { "Disabled", "Random", "Translocate", "ProjectileBreaker" }, Default = "Disabled", Multi = false,
    Callback = function(v) print("Evasion Mode:", v) end })

HitboxSec:Slider({ Name = "Base Radius", Flag = "Ragebot_BaseRadius",
    Min = 0, Max = 50, Default = 10, Decimals = 0.1,
    Callback = function(v) print("Base Radius:", v) end })

HitboxSec:Slider({ Name = "Random Factor", Flag = "Ragebot_RandomFactor",
    Min = 0, Max = 10, Default = 0, Decimals = 0.1,
    Callback = function(v) print("Random Factor:", v) end })

HitboxSec:Slider({ Name = "Reposition Interval (s)", Flag = "Ragebot_RepoInterval",
    Min = 0.1, Max = 5, Default = 0.5, Decimals = 0.1,
    Callback = function(v) print("Reposition:", v) end })

HitboxSec:Slider({ Name = "Forward Depth", Flag = "Ragebot_DepthForward",
    Min = -10, Max = 10, Default = 0, Decimals = 0.1,
    Callback = function(v) print("Fwd Depth:", v) end })

HitboxSec:Slider({ Name = "Upward Depth", Flag = "Ragebot_DepthUp",
    Min = -10, Max = 10, Default = 0, Decimals = 0.1,
    Callback = function(v) print("Up Depth:", v) end })

HitboxSec:Slider({ Name = "Forward Frequency", Flag = "Ragebot_DepthFwdFreq",
    Min = 0, Max = 10, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Fwd Freq:", v) end })

HitboxSec:Slider({ Name = "Upward Frequency", Flag = "Ragebot_DepthUpFreq",
    Min = 0, Max = 10, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Up Freq:", v) end })

-- ============================================================
--// MISC TAB  (Item Modifiers | Automation + Movement)
-- ============================================================
local ItemModSec  = MiscTab:Section({ Name = "Item Modifiers", Side = 1 })
local AutoSec     = MiscTab:Section({ Name = "Automation",     Side = 2 })

-- Item Modifiers
ItemModSec:Toggle({ Name = "Fast Shoot", Default = false, Flag = "IM_FastShoot", Risky = true,
    Callback = function(v) print("Fast Shoot:", v) end })

ItemModSec:Toggle({ Name = "Full Auto", Default = false, Flag = "IM_FullAuto", Risky = true,
    Callback = function(v) print("Full Auto:", v) end })

ItemModSec:Toggle({ Name = "Fire Rate Override", Default = false, Flag = "IM_FireRate",
    Callback = function(v) print("Fire Rate:", v) end })

ItemModSec:Slider({ Name = "Fire Rate (%)", Flag = "IM_FireRatePct",
    Min = 1, Max = 500, Default = 100, Suffix = "%", Decimals = 1,
    Callback = function(v) print("Fire Rate%:", v) end })

ItemModSec:Toggle({ Name = "Fast Projectile", Default = false, Flag = "IM_FastProjectile", Risky = true,
    Callback = function(v) print("Fast Projectile:", v) end })

ItemModSec:Toggle({ Name = "Remove Spread", Default = false, Flag = "IM_NoSpread",
    Callback = function(v) print("No Spread:", v) end })

ItemModSec:Toggle({ Name = "Extend Melee Range", Default = false, Flag = "IM_ExtendMelee",
    Callback = function(v) print("Extend Melee:", v) end })

ItemModSec:Slider({ Name = "Melee Range", Flag = "IM_MeleeRange",
    Min = 0, Max = 50, Default = 5, Decimals = 0.1,
    Callback = function(v) print("Melee Range:", v) end })

ItemModSec:Toggle({ Name = "Always Backstab", Default = false, Flag = "IM_AlwaysBackstab", Risky = true,
    Callback = function(v) print("Backstab:", v) end })

ItemModSec:Toggle({ Name = "Remove Fuse", Default = false, Flag = "IM_RemoveFuse",
    Callback = function(v) print("Remove Fuse:", v) end })

ItemModSec:Dropdown({ Name = "Explode On", Flag = "IM_ExplodeOn",
    Items = { "Impact", "Timer", "Proximity" }, Default = "Impact", Multi = false,
    Callback = function(v) print("Explode On:", v) end })

ItemModSec:Toggle({ Name = "Infinite Double Jumps", Default = false, Flag = "IM_InfDoubleJump",
    Callback = function(v) print("Inf Jump:", v) end })

ItemModSec:Toggle({ Name = "Remove Camera Shake", Default = false, Flag = "IM_NoCameraShake",
    Callback = function(v) print("No Shake:", v) end })

ItemModSec:Toggle({ Name = "Remove Camera Sway", Default = false, Flag = "IM_NoCameraSway",
    Callback = function(v) print("No Sway:", v) end })

ItemModSec:Toggle({ Name = "Hide Equip Animation", Default = false, Flag = "IM_NoEquipAnim",
    Callback = function(v) print("No Equip Anim:", v) end })

ItemModSec:Toggle({ Name = "Hide Reload Animation", Default = false, Flag = "IM_NoReloadAnim",
    Callback = function(v) print("No Reload Anim:", v) end })

ItemModSec:Toggle({ Name = "Hide Shoot Animation", Default = false, Flag = "IM_NoShootAnim",
    Callback = function(v) print("No Shoot Anim:", v) end })

ItemModSec:Toggle({ Name = "Hide Sprint Animation", Default = false, Flag = "IM_NoSprintAnim",
    Callback = function(v) print("No Sprint Anim:", v) end })

ItemModSec:Toggle({ Name = "Remove Weapon Motion", Default = false, Flag = "IM_NoMotion",
    Callback = function(v) print("No Motion:", v) end })

-- Automation
AutoSec:Toggle({ Name = "Auto Respawn", Default = false, Flag = "AutoRespawn",
    Callback = function(v) print("Auto Respawn:", v) end })

AutoSec:Toggle({ Name = "Auto Queue", Default = false, Flag = "AutoQueue",
    Callback = function(v) print("Auto Queue:", v) end })

AutoSec:Dropdown({ Name = "Queue", Flag = "AutoQueue_Mode",
    Items = { "Casual", "Ranked", "Last Mode" }, Default = "Casual", Multi = false,
    Callback = function(v) print("Queue Mode:", v) end })

AutoSec:Toggle({ Name = "Auto Vote", Default = false, Flag = "AutoVote",
    Callback = function(v) print("Auto Vote:", v) end })

AutoSec:Dropdown({ Name = "Maps to Vote For", Flag = "AutoVote_Maps",
    Items = { "Any", "Highrise", "Lotus", "Temple", "Snowpeak" }, Default = "Any", Multi = true,
    Callback = function(v) print("Vote Maps:", v) end })

AutoSec:Toggle({ Name = "Auto Loadout", Default = false, Flag = "AutoLoadout",
    Callback = function(v) print("Auto Loadout:", v) end })

AutoSec:Toggle({ Name = "Use Custom Loadout", Default = false, Flag = "AutoLoadout_Custom",
    Callback = function(v) print("Custom Loadout:", v) end })

AutoSec:Toggle({ Name = "Use Map-Specific Loadouts", Default = false, Flag = "AutoLoadout_PerMap",
    Callback = function(v) print("Per Map Loadout:", v) end })

AutoSec:Toggle({ Name = "Auto Pickup Drops", Default = false, Flag = "AutoPickup",
    Callback = function(v) print("Auto Pickup:", v) end })

AutoSec:Dropdown({ Name = "Pickup Types", Flag = "AutoPickup_Types",
    Items = { "Weapons", "Health", "Ammo", "All" }, Default = "All", Multi = true,
    Callback = function(v) print("Pickup Types:", v) end })

AutoSec:Toggle({ Name = "Auto Ban", Default = false, Flag = "AutoBan", Risky = true,
    Callback = function(v) print("Auto Ban:", v) end })

AutoSec:Dropdown({ Name = "First Ban Choices", Flag = "AutoBan_FirstWeapons",
    Items = { "Katana", "Bow", "Pistol", "Shuriken", "Shotgun" }, Default = nil, Multi = true,
    Callback = function(v) print("First Ban:", v) end })

AutoSec:Dropdown({ Name = "Second Ban Choices", Flag = "AutoBan_SecondWeapons",
    Items = { "Katana", "Bow", "Pistol", "Shuriken", "Shotgun" }, Default = nil, Multi = true,
    Callback = function(v) print("Second Ban:", v) end })

AutoSec:Toggle({ Name = "Subspace Tripmines Auto Trigger", Default = false, Flag = "Tripmines_AutoTrigger",
    Callback = function(v) print("Tripmines Auto:", v) end })

AutoSec:Toggle({ Name = "Team Trigger", Default = false, Flag = "Tripmines_TeamTrigger",
    Callback = function(v) print("Team Trigger:", v) end })

-- ============================================================
--// VISUALS TAB  (ESP + Chams | Hit/Elim Feedback)
-- ============================================================
local ESPSec      = VisualsTab:Section({ Name = "Player ESP",        Side = 1 })
local FeedbackSec = VisualsTab:Section({ Name = "Hit / Elim Feedback", Side = 2 })

-- Player ESP
local ESPToggle = ESPSec:Toggle({ Name = "Player ESP", Default = false, Flag = "PlayerESP",
    Callback = function(v) print("Player ESP:", v) end })
ESPToggle:Colorpicker({ Name = "ESP Color", Flag = "ESPColor",
    Default = Color3.fromRGB(255,255,255), Callback = function(v,a) end })
ESPToggle:Colorpicker({ Name = "Teammate Color", Flag = "ESPTeamColor",
    Default = Color3.fromRGB(0,255,100), Callback = function(v,a) end })

ESPSec:Toggle({ Name = "Box ESP", Default = false, Flag = "BoxESP",
    Callback = function(v) print("Box ESP:", v) end })
ESPSec:Toggle({ Name = "Name ESP", Default = false, Flag = "NameESP",
    Callback = function(v) print("Name ESP:", v) end })
ESPSec:Toggle({ Name = "Distance", Default = false, Flag = "DistESP",
    Callback = function(v) print("Dist ESP:", v) end })
ESPSec:Toggle({ Name = "Health Bar", Default = false, Flag = "HealthBar",
    Callback = function(v) print("Health Bar:", v) end })
ESPSec:Toggle({ Name = "Tracers", Default = false, Flag = "Tracers",
    Callback = function(v) print("Tracers:", v) end })
ESPSec:Toggle({ Name = "Rank", Default = false, Flag = "RankESP",
    Callback = function(v) print("Rank ESP:", v) end })
ESPSec:Toggle({ Name = "Winstreak", Default = false, Flag = "WinstreakESP",
    Callback = function(v) print("Winstreak ESP:", v) end })
ESPSec:Toggle({ Name = "Held Weapon", Default = false, Flag = "WeaponESP",
    Callback = function(v) print("Weapon ESP:", v) end })
ESPSec:Toggle({ Name = "Deflecting", Default = false, Flag = "DeflectESP",
    Callback = function(v) print("Deflect ESP:", v) end })
ESPSec:Toggle({ Name = "Team Check", Default = true, Flag = "ESPTeamCheck",
    Callback = function(v) print("Team Check:", v) end })
ESPSec:Slider({ Name = "Max Distance", Flag = "ESPMaxDist",
    Min = 0, Max = 5000, Default = 1000, Suffix = " studs", Decimals = 1,
    Callback = function(v) print("ESP Dist:", v) end })

-- Character Chams
ESPSec:Toggle({ Name = "Enable Character Chams", Default = false, Flag = "Chams_Char",
    Callback = function(v) print("Char Chams:", v) end })
ESPSec:Dropdown({ Name = "Character Chams Material", Flag = "Chams_CharMat",
    Items = { "Flat", "Shiny", "Glass", "Neon", "ForceField" }, Default = "Flat", Multi = false,
    Callback = function(v) print("Chams Mat:", v) end })
local ChamsLabel = ESPSec:Label("Chams Color", "Left")
ChamsLabel:Colorpicker({ Name = "Chams Visible", Flag = "ChamsVisColor",
    Default = Color3.fromRGB(255,100,0), Callback = function(v,a) end })
ChamsLabel:Colorpicker({ Name = "Chams Hidden", Flag = "ChamsHidColor",
    Default = Color3.fromRGB(255,0,0), Callback = function(v,a) end })
ESPSec:Toggle({ Name = "Strip Character Chams Textures", Default = false, Flag = "Chams_StripTex",
    Callback = function(v) print("Strip Tex:", v) end })

-- Sound ESP
ESPSec:Toggle({ Name = "Enable Sound ESP", Default = false, Flag = "SoundESP",
    Callback = function(v) print("Sound ESP:", v) end })
ESPSec:Dropdown({ Name = "Sound Types", Flag = "SoundESP_Types",
    Items = { "Footsteps", "Attacks", "Abilities", "All" }, Default = "All", Multi = true,
    Callback = function(v) print("Sound Types:", v) end })
ESPSec:Slider({ Name = "Minimum Volume", Flag = "SoundESP_MinVol",
    Min = 0, Max = 1, Default = 0.1, Decimals = 0.01,
    Callback = function(v) print("Min Vol:", v) end })

-- Hit Feedback
FeedbackSec:Toggle({ Name = "Enable Hit Feedback", Default = false, Flag = "HitFeedback",
    Callback = function(v) print("Hit Feedback:", v) end })

FeedbackSec:Toggle({ Name = "Play Hit Sound", Default = false, Flag = "HitSound_Enabled",
    Callback = function(v) print("Hit Sound:", v) end })
FeedbackSec:Dropdown({ Name = "Body Hit Sound", Flag = "HitSound_BodyName",
    Items = { "Default", "Minecraft", "CS:GO", "Custom" }, Default = "Default", Multi = false,
    Callback = function(v) print("Body Sound:", v) end })
FeedbackSec:Slider({ Name = "Body Hit Volume", Flag = "HitSound_BodyVol",
    Min = 0, Max = 10, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Body Vol:", v) end })
FeedbackSec:Slider({ Name = "Body Hit Pitch", Flag = "HitSound_BodyPitch",
    Min = 0.1, Max = 3, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Body Pitch:", v) end })
FeedbackSec:Dropdown({ Name = "Headshot Sound", Flag = "HitSound_HeadName",
    Items = { "Default", "Minecraft", "CS:GO", "Custom" }, Default = "Default", Multi = false,
    Callback = function(v) print("Head Sound:", v) end })
FeedbackSec:Slider({ Name = "Headshot Volume", Flag = "HitSound_HeadVol",
    Min = 0, Max = 10, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Head Vol:", v) end })
FeedbackSec:Slider({ Name = "Headshot Pitch", Flag = "HitSound_HeadPitch",
    Min = 0.1, Max = 3, Default = 1.5, Decimals = 0.1,
    Callback = function(v) print("Head Pitch:", v) end })
FeedbackSec:Toggle({ Name = "Mute Game Hit Sound", Default = false, Flag = "HitSound_Mute",
    Callback = function(v) print("Mute Hit Sound:", v) end })

FeedbackSec:Toggle({ Name = "Enable Hit Chams", Default = false, Flag = "HitChams",
    Callback = function(v) print("Hit Chams:", v) end })
FeedbackSec:Slider({ Name = "Hit Chams Duration", Flag = "HitChams_Dur",
    Min = 0.1, Max = 3, Default = 0.3, Decimals = 0.1,
    Callback = function(v) print("Hit Chams Dur:", v) end })
FeedbackSec:Dropdown({ Name = "Hit Chams Material", Flag = "HitChams_Mat",
    Items = { "Flat", "Neon", "Shiny" }, Default = "Neon", Multi = false,
    Callback = function(v) print("Hit Chams Mat:", v) end })
local HitChamsColor = FeedbackSec:Label("Hit Chams Color", "Left")
HitChamsColor:Colorpicker({ Name = "Hit Chams Color", Flag = "HitChams_Color",
    Default = Color3.fromRGB(255,165,0), Callback = function(v,a) end })

FeedbackSec:Toggle({ Name = "Enable Hit Flash", Default = false, Flag = "HitFlash",
    Callback = function(v) print("Hit Flash:", v) end })
FeedbackSec:Slider({ Name = "Hit Flash Duration", Flag = "HitFlash_Dur",
    Min = 0.1, Max = 3, Default = 0.2, Decimals = 0.1,
    Callback = function(v) print("Hit Flash Dur:", v) end })
local HitFlashColor = FeedbackSec:Label("Hit Flash Color", "Left")
HitFlashColor:Colorpicker({ Name = "Hit Flash Color", Flag = "HitFlash_Color",
    Default = Color3.fromRGB(255,255,255), Callback = function(v,a) end })

FeedbackSec:Toggle({ Name = "Enable Hit Notification", Default = false, Flag = "HitNotif",
    Callback = function(v) print("Hit Notif:", v) end })
FeedbackSec:Textbox({ Name = "Hit Notification Text", Flag = "HitNotif_Text",
    Default = "Hit!", Placeholder = "Text...",
    Callback = function(v) print("Hit Text:", v) end })

-- Elimination Feedback
FeedbackSec:Toggle({ Name = "Enable Elimination Feedback", Default = false, Flag = "ElimFeedback",
    Callback = function(v) print("Elim Feedback:", v) end })
FeedbackSec:Toggle({ Name = "Play Elimination Sound", Default = false, Flag = "ElimSound",
    Callback = function(v) print("Elim Sound:", v) end })
FeedbackSec:Slider({ Name = "Elimination Volume", Flag = "ElimSound_Vol",
    Min = 0.1, Max = 10, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Elim Vol:", v) end })
FeedbackSec:Slider({ Name = "Elimination Pitch", Flag = "ElimSound_Pitch",
    Min = 0.1, Max = 3, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Elim Pitch:", v) end })
FeedbackSec:Toggle({ Name = "Enable Elimination Chams", Default = false, Flag = "ElimChams",
    Callback = function(v) print("Elim Chams:", v) end })
FeedbackSec:Slider({ Name = "Elimination Chams Duration", Flag = "ElimChams_Dur",
    Min = 0.1, Max = 3, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Elim Chams Dur:", v) end })
FeedbackSec:Dropdown({ Name = "Elimination Chams Material", Flag = "ElimChams_Mat",
    Items = { "Flat", "Neon", "Shiny" }, Default = "Neon", Multi = false,
    Callback = function(v) print("Elim Chams Mat:", v) end })
local ElimChamsColor = FeedbackSec:Label("Elim Chams Color", "Left")
ElimChamsColor:Colorpicker({ Name = "Elim Chams Color", Flag = "ElimChams_Color",
    Default = Color3.fromRGB(255,0,0), Callback = function(v,a) end })
FeedbackSec:Toggle({ Name = "Enable Elimination Flash", Default = false, Flag = "ElimFlash",
    Callback = function(v) print("Elim Flash:", v) end })
FeedbackSec:Slider({ Name = "Elimination Flash Duration", Flag = "ElimFlash_Dur",
    Min = 0.1, Max = 3, Default = 0.5, Decimals = 0.1,
    Callback = function(v) print("Elim Flash Dur:", v) end })
local ElimFlashColor = FeedbackSec:Label("Elim Flash Color", "Left")
ElimFlashColor:Colorpicker({ Name = "Elim Flash Color", Flag = "ElimFlash_Color",
    Default = Color3.fromRGB(255,80,0), Callback = function(v,a) end })
FeedbackSec:Toggle({ Name = "Enable Elimination Notification", Default = false, Flag = "ElimNotif",
    Callback = function(v) print("Elim Notif:", v) end })
FeedbackSec:Textbox({ Name = "Elimination Notification Text", Flag = "ElimNotif_Text",
    Default = "Eliminated!", Placeholder = "Text...",
    Callback = function(v) print("Elim Text:", v) end })

-- ============================================================
--// WORLD TAB  (Lighting/Visuals | Crosshair + Weapon Visuals)
-- ============================================================
local LightingSec  = WorldTab:Section({ Name = "Lighting & FX",     Side = 1 })
local CrosshairSec = WorldTab:Section({ Name = "Crosshair & Weapon", Side = 2 })

-- Lighting
LightingSec:Toggle({ Name = "Enable Lighting Override", Default = false, Flag = "Lighting",
    Callback = function(v) print("Lighting:", v) end })
LightingSec:Toggle({ Name = "Disable Global Shadows", Default = false, Flag = "Lighting_NoShadows",
    Callback = function(v) Lighting.GlobalShadows = not v end })
LightingSec:Toggle({ Name = "Prioritize Lighting Quality", Default = false, Flag = "Lighting_PriQuality",
    Callback = function(v) print("Prio Quality:", v) end })
LightingSec:Slider({ Name = "Clock Time", Flag = "Lighting_ClockTime",
    Min = 0, Max = 24, Default = 14, Decimals = 0.1,
    Callback = function(v) Lighting.ClockTime = v end })
LightingSec:Slider({ Name = "Brightness", Flag = "Lighting_Brightness",
    Min = 0, Max = 10, Default = 1, Decimals = 0.1,
    Callback = function(v) Lighting.Brightness = v end })
LightingSec:Slider({ Name = "Exposure Compensation", Flag = "Lighting_Exposure",
    Min = -5, Max = 5, Default = 0, Decimals = 0.1,
    Callback = function(v) Lighting.ExposureCompensation = v end })
LightingSec:Slider({ Name = "Environment Diffuse Scale", Flag = "Lighting_EnvDiff",
    Min = 0, Max = 1, Default = 1, Decimals = 0.01,
    Callback = function(v) Lighting.EnvironmentDiffuseScale = v end })
LightingSec:Slider({ Name = "Environment Specular Scale", Flag = "Lighting_EnvSpec",
    Min = 0, Max = 1, Default = 1, Decimals = 0.01,
    Callback = function(v) Lighting.EnvironmentSpecularScale = v end })
LightingSec:Slider({ Name = "Geographic Latitude", Flag = "Lighting_GeoLat",
    Min = -90, Max = 90, Default = 41, Decimals = 0.1,
    Callback = function(v) Lighting.GeographicLatitude = v end })
LightingSec:Slider({ Name = "Shadow Softness", Flag = "Lighting_ShadowSoft",
    Min = 0, Max = 1, Default = 0.2, Decimals = 0.01,
    Callback = function(v) Lighting.ShadowSoftness = v end })
local ShadowColorLabel = LightingSec:Label("Shadow Color", "Left")
ShadowColorLabel:Colorpicker({ Name = "Shadow Color", Flag = "Lighting_ShadowColor",
    Default = Color3.fromRGB(0,0,0), Callback = function(v,a) Lighting.ShadowColor = v end })
local AmbientLabel = LightingSec:Label("Ambient Colors", "Left")
AmbientLabel:Colorpicker({ Name = "Outdoor Ambient", Flag = "Lighting_AmbientOut",
    Default = Color3.fromRGB(128,128,128), Callback = function(v,a) Lighting.Ambient = v end })
AmbientLabel:Colorpicker({ Name = "Indoor Ambient", Flag = "Lighting_AmbientIn",
    Default = Color3.fromRGB(75,75,75), Callback = function(v,a) Lighting.ColorShift_Bottom = v end })
LightingSec:Dropdown({ Name = "Lighting Style", Flag = "Lighting_Style",
    Items = { "Compatibility", "ShadowMap", "Future", "Voxel" }, Default = "ShadowMap", Multi = false,
    Callback = function(v) Lighting.Technology = Enum.Technology[v] end })

-- Color Correction
LightingSec:Toggle({ Name = "Color Correction", Default = false, Flag = "ColorCorrection",
    Callback = function(v) print("CC:", v) end })
LightingSec:Slider({ Name = "Brightness", Flag = "CC_Brightness",
    Min = -1, Max = 1, Default = 0, Decimals = 0.01,
    Callback = function(v) print("CC Brightness:", v) end })
LightingSec:Slider({ Name = "Contrast", Flag = "CC_Contrast",
    Min = -1, Max = 1, Default = 0, Decimals = 0.01,
    Callback = function(v) print("CC Contrast:", v) end })
LightingSec:Slider({ Name = "Saturation", Flag = "CC_Saturation",
    Min = -1, Max = 1, Default = 0, Decimals = 0.01,
    Callback = function(v) print("CC Saturation:", v) end })

-- Bloom
LightingSec:Toggle({ Name = "Bloom", Default = false, Flag = "Bloom",
    Callback = function(v) print("Bloom:", v) end })
LightingSec:Slider({ Name = "Bloom Intensity", Flag = "Bloom_Intensity",
    Min = 0, Max = 1, Default = 0.35, Decimals = 0.01,
    Callback = function(v) print("Bloom Int:", v) end })
LightingSec:Slider({ Name = "Bloom Size", Flag = "Bloom_Size",
    Min = 0, Max = 56, Default = 24, Decimals = 0.1,
    Callback = function(v) print("Bloom Size:", v) end })
LightingSec:Slider({ Name = "Bloom Threshold", Flag = "Bloom_Threshold",
    Min = 0, Max = 2, Default = 1, Decimals = 0.01,
    Callback = function(v) print("Bloom Thresh:", v) end })

-- Sun Rays
LightingSec:Toggle({ Name = "Sun Rays", Default = false, Flag = "SunRays",
    Callback = function(v) print("Sun Rays:", v) end })
LightingSec:Slider({ Name = "Sun Rays Intensity", Flag = "SunRays_Intensity",
    Min = 0, Max = 1, Default = 0.25, Decimals = 0.01,
    Callback = function(v) print("Sun Intensity:", v) end })
LightingSec:Slider({ Name = "Sun Rays Spread", Flag = "SunRays_Spread",
    Min = 0, Max = 1, Default = 0.5, Decimals = 0.01,
    Callback = function(v) print("Sun Spread:", v) end })

-- Motion Blur
LightingSec:Toggle({ Name = "Motion Blur", Default = false, Flag = "MotionBlur",
    Callback = function(v) print("Motion Blur:", v) end })
LightingSec:Slider({ Name = "Motion Blur Intensity", Flag = "MotionBlur_Intensity",
    Min = 0, Max = 1, Default = 0.3, Decimals = 0.01,
    Callback = function(v) print("MB Intensity:", v) end })
LightingSec:Slider({ Name = "Motion Blur Sensitivity", Flag = "MotionBlur_Sensitivity",
    Min = 0, Max = 1, Default = 0.5, Decimals = 0.01,
    Callback = function(v) print("MB Sensitivity:", v) end })

-- Atmosphere
LightingSec:Toggle({ Name = "Atmosphere", Default = false, Flag = "Atmosphere",
    Callback = function(v) print("Atmosphere:", v) end })
LightingSec:Slider({ Name = "Density", Flag = "Atmo_Density",
    Min = 0, Max = 1, Default = 0.35, Decimals = 0.01,
    Callback = function(v) print("Atmo Density:", v) end })
LightingSec:Slider({ Name = "Haze", Flag = "Atmo_Haze",
    Min = 0, Max = 10, Default = 0, Decimals = 0.1,
    Callback = function(v) print("Haze:", v) end })
LightingSec:Slider({ Name = "Glare", Flag = "Atmo_Glare",
    Min = 0, Max = 1, Default = 0, Decimals = 0.01,
    Callback = function(v) print("Glare:", v) end })
LightingSec:Slider({ Name = "Offset", Flag = "Atmo_Offset",
    Min = 0, Max = 1, Default = 0, Decimals = 0.01,
    Callback = function(v) print("Atmo Offset:", v) end })

-- Fog
LightingSec:Toggle({ Name = "Fog", Default = false, Flag = "Fog",
    Callback = function(v) print("Fog:", v) end })
LightingSec:Slider({ Name = "Fog Start", Flag = "Fog_Start",
    Min = 0, Max = 1000, Default = 0, Decimals = 1,
    Callback = function(v) Lighting.FogStart = v end })
LightingSec:Slider({ Name = "Fog End", Flag = "Fog_End",
    Min = 0, Max = 100000, Default = 100000, Decimals = 1,
    Callback = function(v) Lighting.FogEnd = v end })

-- Weather
LightingSec:Toggle({ Name = "Enable Weather", Default = false, Flag = "Weather",
    Callback = function(v) print("Weather:", v) end })
LightingSec:Dropdown({ Name = "Weather Preset", Flag = "Weather_Preset",
    Items = { "Rain", "Snow", "Leaves", "Custom" }, Default = "Rain", Multi = false,
    Callback = function(v) print("Weather Preset:", v) end })
LightingSec:Slider({ Name = "Wind Angle", Flag = "Weather_WindAngle",
    Min = 0, Max = 360, Default = 0, Decimals = 1,
    Callback = function(v) print("Wind Angle:", v) end })
LightingSec:Slider({ Name = "Wind Strength", Flag = "Weather_WindStr",
    Min = 0, Max = 10, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Wind Str:", v) end })
LightingSec:Slider({ Name = "Rate", Flag = "Weather_Rate",
    Min = 0, Max = 100, Default = 20, Decimals = 1,
    Callback = function(v) print("Weather Rate:", v) end })

-- Skybox
LightingSec:Toggle({ Name = "Enable Skybox", Default = false, Flag = "Skybox",
    Callback = function(v) print("Skybox:", v) end })
LightingSec:Dropdown({ Name = "Skybox Preset", Flag = "Skybox_Preset",
    Items = { "Default", "Night", "Sunset", "Custom" }, Default = "Default", Multi = false,
    Callback = function(v) print("Skybox Preset:", v) end })

-- Removables
LightingSec:Toggle({ Name = "Hide Game Tracers", Default = false, Flag = "Rem_NoTracers",
    Callback = function(v) print("No Game Tracers:", v) end })
LightingSec:Toggle({ Name = "Hide Hitmarker", Default = false, Flag = "Rem_NoHitmarker",
    Callback = function(v) print("No Hitmarker:", v) end })
LightingSec:Toggle({ Name = "Hide Muzzle Flash", Default = false, Flag = "Rem_NoMuzzle",
    Callback = function(v) print("No Muzzle Flash:", v) end })
LightingSec:Toggle({ Name = "Hide Scope Overlay", Default = false, Flag = "Rem_NoScopeOverlay",
    Callback = function(v) print("No Scope Overlay:", v) end })
LightingSec:Toggle({ Name = "Hide Scope Reticle", Default = false, Flag = "Rem_NoScopeReticle",
    Callback = function(v) print("No Scope Reticle:", v) end })
LightingSec:Toggle({ Name = "Hide ADS Vignette", Default = false, Flag = "Rem_NoVignette",
    Callback = function(v) print("No Vignette:", v) end })
LightingSec:Toggle({ Name = "Hide Burn Effect", Default = false, Flag = "Rem_NoBurn",
    Callback = function(v) print("No Burn:", v) end })
LightingSec:Toggle({ Name = "Hide Flashbang Effect", Default = false, Flag = "Rem_NoFlash",
    Callback = function(v) print("No Flashbang:", v) end })

-- Crosshair
CrosshairSec:Toggle({ Name = "Enable Crosshair", Default = false, Flag = "Crosshair",
    Callback = function(v) print("Crosshair:", v) end })
CrosshairSec:Dropdown({ Name = "Crosshair Style", Flag = "Crosshair_Style",
    Items = { "Plus", "Circle", "Dot", "X", "T", "Image" }, Default = "Plus", Multi = false,
    Callback = function(v) print("Crosshair Style:", v) end })
CrosshairSec:Slider({ Name = "Line Length", Flag = "Crosshair_Length",
    Min = 0, Max = 20, Default = 5, Decimals = 0.5,
    Callback = function(v) print("Line Length:", v) end })
CrosshairSec:Slider({ Name = "Line Gap", Flag = "Crosshair_Gap",
    Min = 0, Max = 20, Default = 3, Decimals = 0.5,
    Callback = function(v) print("Line Gap:", v) end })
CrosshairSec:Slider({ Name = "Line Thickness", Flag = "Crosshair_Thickness",
    Min = 1, Max = 10, Default = 1, Decimals = 0.5,
    Callback = function(v) print("Thickness:", v) end })
local CrosshairColorLabel = CrosshairSec:Label("Crosshair Color", "Left")
CrosshairColorLabel:Colorpicker({ Name = "Crosshair Color", Flag = "Crosshair_Color",
    Default = Color3.fromRGB(255,255,255), Callback = function(v,a) end })
CrosshairSec:Toggle({ Name = "Crosshair Outline", Default = false, Flag = "Crosshair_Outline",
    Callback = function(v) print("Crosshair Outline:", v) end })
CrosshairSec:Slider({ Name = "Crosshair Outline Thickness", Flag = "Crosshair_OutlineThick",
    Min = 1, Max = 5, Default = 1, Decimals = 0.5,
    Callback = function(v) print("Outline Thick:", v) end })
CrosshairSec:Toggle({ Name = "Rotate Crosshair", Default = false, Flag = "Crosshair_Rotate",
    Callback = function(v) print("Rotate:", v) end })
CrosshairSec:Slider({ Name = "Crosshair Rotation Speed", Flag = "Crosshair_RotSpeed",
    Min = 0, Max = 360, Default = 60, Decimals = 1,
    Callback = function(v) print("Rot Speed:", v) end })
CrosshairSec:Toggle({ Name = "Crosshair Spread", Default = false, Flag = "Crosshair_Spread",
    Callback = function(v) print("Spread:", v) end })
CrosshairSec:Slider({ Name = "Crosshair Spread Range", Flag = "Crosshair_SpreadRange",
    Min = 0, Max = 30, Default = 5, Decimals = 0.5,
    Callback = function(v) print("Spread Range:", v) end })
CrosshairSec:Slider({ Name = "Crosshair Spread Speed", Flag = "Crosshair_SpreadSpeed",
    Min = 0.1, Max = 5, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Spread Speed:", v) end })
CrosshairSec:Toggle({ Name = "Follow Target", Default = false, Flag = "Crosshair_Follow",
    Callback = function(v) print("Follow Target:", v) end })
CrosshairSec:Dropdown({ Name = "Follow Target Mode", Flag = "Crosshair_FollowMode",
    Items = { "Nearest", "Locked", "Mouse" }, Default = "Nearest", Multi = false,
    Callback = function(v) print("Follow Mode:", v) end })
CrosshairSec:Slider({ Name = "Snap Distance", Flag = "Crosshair_SnapDist",
    Min = 0, Max = 500, Default = 100, Decimals = 1,
    Callback = function(v) print("Snap Dist:", v) end })
CrosshairSec:Slider({ Name = "Follow Speed", Flag = "Crosshair_FollowSpeed",
    Min = 0.1, Max = 10, Default = 5, Decimals = 0.1,
    Callback = function(v) print("Follow Speed:", v) end })
CrosshairSec:Slider({ Name = "Follow Damper", Flag = "Crosshair_FollowDamper",
    Min = 0, Max = 1, Default = 0.5, Decimals = 0.01,
    Callback = function(v) print("Follow Damper:", v) end })
CrosshairSec:Toggle({ Name = "Enable Crosshair Text", Default = false, Flag = "Crosshair_Text",
    Callback = function(v) print("Crosshair Text:", v) end })
CrosshairSec:Textbox({ Name = "Crosshair Text Content", Flag = "Crosshair_TextContent",
    Default = "", Placeholder = "Text...",
    Callback = function(v) print("Text Content:", v) end })
CrosshairSec:Slider({ Name = "Crosshair Text Size", Flag = "Crosshair_TextSize",
    Min = 8, Max = 72, Default = 14, Decimals = 1,
    Callback = function(v) print("Text Size:", v) end })
CrosshairSec:Slider({ Name = "Crosshair Text Offset", Flag = "Crosshair_TextOffset",
    Min = -50, Max = 50, Default = 0, Decimals = 1,
    Callback = function(v) print("Text Offset:", v) end })

-- Bullet Tracers
CrosshairSec:Toggle({ Name = "Enable Bullet Tracers", Default = false, Flag = "BulletTracers",
    Callback = function(v) print("Bullet Tracers:", v) end })
CrosshairSec:Dropdown({ Name = "Tracer Style", Flag = "BT_Style",
    Items = { "Line", "Beam", "Laser" }, Default = "Line", Multi = false,
    Callback = function(v) print("Tracer Style:", v) end })
CrosshairSec:Slider({ Name = "Tracer Width", Flag = "BT_Width",
    Min = 0.1, Max = 5, Default = 0.5, Decimals = 0.1,
    Callback = function(v) print("Tracer Width:", v) end })
CrosshairSec:Slider({ Name = "Tracer Lifetime", Flag = "BT_Lifetime",
    Min = 0.1, Max = 5, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Tracer Lifetime:", v) end })
CrosshairSec:Slider({ Name = "Texture Length", Flag = "BT_TexLength",
    Min = 0.1, Max = 10, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Tex Length:", v) end })
CrosshairSec:Slider({ Name = "Texture Speed", Flag = "BT_TexSpeed",
    Min = 0, Max = 10, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Tex Speed:", v) end })
local TracerColorLabel = CrosshairSec:Label("Tracer Color", "Left")
TracerColorLabel:Colorpicker({ Name = "Tracer Color", Flag = "BT_Color",
    Default = Color3.fromRGB(255,255,255), Callback = function(v,a) end })
CrosshairSec:Toggle({ Name = "Expand Tracers", Default = false, Flag = "BT_Expand",
    Callback = function(v) print("Expand Tracers:", v) end })
CrosshairSec:Slider({ Name = "Expand Speed", Flag = "BT_ExpandSpeed",
    Min = 0.1, Max = 10, Default = 1, Decimals = 0.1,
    Callback = function(v) print("Expand Speed:", v) end })
CrosshairSec:Slider({ Name = "Expand Damper", Flag = "BT_ExpandDamper",
    Min = 0, Max = 1, Default = 0.5, Decimals = 0.01,
    Callback = function(v) print("Expand Damper:", v) end })
CrosshairSec:Slider({ Name = "Fade Time", Flag = "BT_FadeTime",
    Min = 0, Max = 5, Default = 0.5, Decimals = 0.1,
    Callback = function(v) print("Fade Time:", v) end })

-- Camera & Screen
CrosshairSec:Toggle({ Name = "Enable Camera FOV", Default = false, Flag = "CameraFOV",
    Callback = function(v) print("Camera FOV:", v) end })
CrosshairSec:Slider({ Name = "Field of View", Flag = "CameraFOV_Val",
    Min = 1, Max = 120, Default = 70, Suffix = "°", Decimals = 1,
    Callback = function(v) workspace.CurrentCamera.FieldOfView = v end })

CrosshairSec:Toggle({ Name = "Enable Stretched Resolution", Default = false, Flag = "StretchRes",
    Callback = function(v) print("Stretch Res:", v) end })
CrosshairSec:Slider({ Name = "X Scale", Flag = "StretchRes_X",
    Min = 0.5, Max = 2, Default = 1, Decimals = 0.01,
    Callback = function(v) print("X Scale:", v) end })
CrosshairSec:Slider({ Name = "Y Scale", Flag = "StretchRes_Y",
    Min = 0.5, Max = 2, Default = 1, Decimals = 0.01,
    Callback = function(v) print("Y Scale:", v) end })

-- Viewmodel
CrosshairSec:Toggle({ Name = "Enable Viewmodel Position", Default = false, Flag = "ViewmodelOffset",
    Callback = function(v) print("Viewmodel Offset:", v) end })
CrosshairSec:Slider({ Name = "X Offset", Flag = "VM_X",
    Min = -5, Max = 5, Default = 0, Decimals = 0.1,
    Callback = function(v) print("VM X:", v) end })
CrosshairSec:Slider({ Name = "Y Offset", Flag = "VM_Y",
    Min = -5, Max = 5, Default = 0, Decimals = 0.1,
    Callback = function(v) print("VM Y:", v) end })
CrosshairSec:Slider({ Name = "Z Offset", Flag = "VM_Z",
    Min = -5, Max = 5, Default = 0, Decimals = 0.1,
    Callback = function(v) print("VM Z:", v) end })
CrosshairSec:Slider({ Name = "Pitch", Flag = "VM_Pitch",
    Min = -180, Max = 180, Default = 0, Decimals = 1,
    Callback = function(v) print("VM Pitch:", v) end })
CrosshairSec:Slider({ Name = "Yaw", Flag = "VM_Yaw",
    Min = -180, Max = 180, Default = 0, Decimals = 1,
    Callback = function(v) print("VM Yaw:", v) end })
CrosshairSec:Slider({ Name = "Roll", Flag = "VM_Roll",
    Min = -180, Max = 180, Default = 0, Decimals = 1,
    Callback = function(v) print("VM Roll:", v) end })

-- Third Person
CrosshairSec:Toggle({ Name = "Third Person", Default = false, Flag = "ThirdPerson",
    Callback = function(v) print("Third Person:", v) end })
CrosshairSec:Slider({ Name = "X Offset", Flag = "TP_X",
    Min = -10, Max = 10, Default = 2, Decimals = 0.1,
    Callback = function(v) print("TP X:", v) end })
CrosshairSec:Slider({ Name = "Y Offset", Flag = "TP_Y",
    Min = -10, Max = 10, Default = 0, Decimals = 0.1,
    Callback = function(v) print("TP Y:", v) end })
CrosshairSec:Slider({ Name = "Z Offset", Flag = "TP_Z",
    Min = -10, Max = 10, Default = 5, Decimals = 0.1,
    Callback = function(v) print("TP Z:", v) end })
CrosshairSec:Toggle({ Name = "Show Replica", Default = false, Flag = "TP_ShowReplica",
    Callback = function(v) print("Show Replica:", v) end })
CrosshairSec:Toggle({ Name = "Ray Check", Default = true, Flag = "TP_RayCheck",
    Callback = function(v) print("Ray Check:", v) end })

-- ============================================================
--// PLAYERS TAB
-- ============================================================
PlayersTab:PlayerList({ Name = "Playerlist", Flag = "Playerlist",
    Callback = function(p) print(p) end })

-- ============================================================
--// SETTINGS TAB  (Themes | Configs)
-- ============================================================
local ThemesSection  = SettingsTab:Section({ Name = "Themes",  Side = 1 })
local ConfigsSection = SettingsTab:Section({ Name = "Configs", Side = 2 })

do
    for Index, Value in Library.Theme do
        Library.ThemeColorpickers[Index] = ThemesSection:Label(Index, "Left"):Colorpicker({
            Name = Index, Flag = "Theme" .. Index, Default = Value,
            Callback = function(Value)
                Library.Theme[Index] = Value
                Library:ChangeTheme(Index, Value)
            end
        })
    end
    ThemesSection:Dropdown({ Name = "Themes List",
        Items = { "Default", "Bitchbot", "Onetap", "Aqua" }, Default = "Default",
        Callback = function(Value)
            local ThemeData = Library.Themes[Value]
            if not ThemeData then return end
            for Index, Val in Library.Theme do
                Library.Theme[Index] = ThemeData[Index]
                Library:ChangeTheme(Index, ThemeData[Index])
                Library.ThemeColorpickers[Index]:Set(ThemeData[Index])
            end
            task.wait(0.3)
            Library:Thread(function()
                for Index, Val in Library.Theme do
                    Library.Theme[Index] = Library.Flags["Theme" .. Index].Color
                    Library:ChangeTheme(Index, Library.Flags["Theme" .. Index].Color)
                end
            end)
        end
    })
    local ThemeName, SelectedTheme
    local ThemesListbox = ThemesSection:Listbox({ Name = "Themes List", Flag = "Themes List",
        Items = {}, Multi = false, Default = nil,
        Callback = function(v) SelectedTheme = v end })
    ThemesSection:Textbox({ Name = "Name", Flag = "Theme Name", Default = "", Placeholder = ". . .",
        Callback = function(v) ThemeName = v end })
    ThemesSection:Button({ Name = "Save Theme",
        Callback = function()
            if ThemeName == "" then return end
            local Path = Library.Folders.Themes .. "/" .. ThemeName .. ".json"
            if not isfile(Path) then writefile(Path, Library:GetTheme()); Library:RefreshThemeList(ThemesListbox)
            else Library:Notification("Theme '" .. ThemeName .. ".json' already exists", 3, Color3.fromRGB(255,0,0)) end
        end
    }):SubButton({ Name = "Load Theme",
        Callback = function()
            if SelectedTheme then Library:LoadTheme(readfile(Library.Folders.Themes .. "/" .. SelectedTheme)) end
        end })
    ThemesSection:Button({ Name = "Refresh Themes",
        Callback = function() Library:RefreshThemeList(ThemesListbox) end })
    Library:RefreshThemeList(ThemesListbox)
end

do
    local ConfigName, SelectedConfig
    local ConfigsListbox = ConfigsSection:Listbox({ Name = "Configs List", Flag = "Configs List",
        Items = {}, Multi = false, Default = nil,
        Callback = function(v) SelectedConfig = v end })
    ConfigsSection:Textbox({ Name = "Name", Flag = "Config Name", Default = "", Placeholder = ". . .",
        Callback = function(v) ConfigName = v end })
    ConfigsSection:Button({ Name = "Load Config",
        Callback = function()
            if SelectedConfig then Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. SelectedConfig)) end
            Library:Thread(function()
                task.wait(0.1)
                for Index, Val in Library.Theme do
                    Library.Theme[Index] = Library.Flags["Theme" .. Index].Color
                    Library:ChangeTheme(Index, Library.Flags["Theme" .. Index].Color)
                end
            end)
        end
    }):SubButton({ Name = "Save Config",
        Callback = function()
            if SelectedConfig then Library:SaveConfig(SelectedConfig) end
        end })
    ConfigsSection:Button({ Name = "Create Config",
        Callback = function()
            if ConfigName == "" then return end
            local Path = Library.Folders.Configs .. "/" .. ConfigName .. ".json"
            if not isfile(Path) then writefile(Path, Library:GetConfig()); Library:RefreshConfigsList(ConfigsListbox)
            else Library:Notification("Config '" .. ConfigName .. ".json' already exists", 3, Color3.fromRGB(255,0,0)) end
        end
    }):SubButton({ Name = "Delete Config",
        Callback = function()
            if SelectedConfig then Library:DeleteConfig(SelectedConfig); Library:RefreshConfigsList(ConfigsListbox) end
        end })
    ConfigsSection:Button({ Name = "Refresh Configs",
        Callback = function() Library:RefreshConfigsList(ConfigsListbox) end })
    Library:RefreshConfigsList(ConfigsListbox)
    ConfigsSection:Label("Menu Keybind", "Left"):Keybind({ Name = "Menu Keybind", Flag = "Menu Keybind",
        Default = Enum.KeyCode.RightControl, Mode = "Toggle",
        Callback = function(v) Library.MenuKeybind = Library.Flags["Menu Keybind"].Key end })
    ConfigsSection:Toggle({ Name = "Watermark", Flag = "Watermark", Default = false,
        Callback = function(v) Watermark:SetVisibility(v) end })
    ConfigsSection:Toggle({ Name = "Keybind List", Flag = "Keybind List", Default = false,
        Callback = function(v) KeybindList:SetVisibility(v) end })
    ConfigsSection:Dropdown({ Name = "Style", Flag = "Tweening Style", Default = "Exponential",
        Items = { "Linear","Sine","Quad","Cubic","Quart","Quint","Exponential","Circular","Back","Elastic","Bounce" },
        Callback = function(v) Library.Tween.Style = Enum.EasingStyle[v] end })
    ConfigsSection:Dropdown({ Name = "Direction", Flag = "Tweening Direction", Default = "Out",
        Items = { "In", "Out", "InOut" },
        Callback = function(v) Library.Tween.Direction = Enum.EasingDirection[v] end })
    ConfigsSection:Slider({ Name = "Tweening Time", Flag = "Tweening Time",
        Min = 0, Max = 5, Default = 0.25, Decimals = 0.01,
        Callback = function(v) Library.Tween.Time = v end })
    ConfigsSection:Button({ Name = "Notification Test",
        Callback = function()
            Library:Notification("This is a notification", 5,
                Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)))
        end })
    ConfigsSection:Button({ Name = "Unload Library",
        Callback = function() Library:Unload() end })
end

--// Loaded notification
Library:Notification(
    "Loaded in " .. string.format("%.4f", os.clock() - LoadingTick) .. "s",
    5, Color3.fromRGB(0, 255, 0),
    { "135757045959142", Color3.fromRGB(149, 255, 139) }
)
