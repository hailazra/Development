--[[ =========================
BLOCK 001: L1–L500 (Window shell, Tab List, Modal Dropdown, TopBar)
Notes:
- Parenting logic: protect_gui/gethui/CoreGui fallback → PlayerGui
- Struktur & properti 1:1; hanya penamaan variabel diperjelas
- Lucide Icons: disiapkan Library:GetIcon(name) persis Obsidian (lihat di akhir block)
========================= ]]

-- ====== Parent ScreenGui (1:1) ======
local Gui = {}
local ScreenGui = Instance.new("ScreenGui")
Gui.ScreenGui = ScreenGui
ScreenGui.Name = "NatHub"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local _cloneref = cloneref or function(x) return x end
do
    if protect_gui then
        protect_gui(ScreenGui)
    elseif gethui then
        ScreenGui.Parent = gethui()
    elseif pcall(function() game.CoreGui:GetChildren() end) then
        ScreenGui.Parent = _cloneref(game:GetService("CoreGui"))
    else
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- ====== Main Window ======
local Window = Instance.new("Frame", ScreenGui)
Gui.Window = Window
Window.Name = "Window"
Window.ZIndex = 0
Window.BorderSizePixel = 2
Window.BorderColor3 = Color3.fromRGB(61, 61, 75)
Window.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.Position = UDim2.new(0.5278, 0, 0.5, 0)
Window.Size = UDim2.new(0, 528, 0, 334)

local WindowCorner = Instance.new("UICorner", Window)
WindowCorner.CornerRadius = UDim.new(0, 10)

-- Outline
local WindowStroke = Instance.new("UIStroke", Window)
WindowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
WindowStroke.Transparency = 0.5
WindowStroke.Color = Color3.fromRGB(95, 95, 117)

-- ====== Modal: DropdownSelection ======
local Modal = Instance.new("Frame", Window)
Gui.DropdownSelection = Modal
Modal.Name = "DropdownSelection"
Modal.Visible = false
Modal.ZIndex = 4
Modal.ClipsDescendants = true
Modal.BorderSizePixel = 0
Modal.BorderColor3 = Color3.fromRGB(61, 61, 75)
Modal.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
Modal.AnchorPoint = Vector2.new(0.5, 0.5)
Modal.Position = UDim2.new(0.5, 0, 0.5, 0)
Modal.Size = UDim2.new(0.7281, 0, 0.68367, 0)

local ModalCorner = Instance.new("UICorner", Modal)
ModalCorner.CornerRadius = UDim.new(0, 6)

local ModalStroke = Instance.new("UIStroke", Modal)
ModalStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ModalStroke.Thickness = 1.5
ModalStroke.Color = Color3.fromRGB(61, 61, 75)

-- TopBar dalam Modal
local ModalTop = Instance.new("Frame", Modal)
ModalTop.Name = "TopBar"
ModalTop.BackgroundTransparency = 1
ModalTop.BorderSizePixel = 0
ModalTop.BorderColor3 = Color3.fromRGB(0, 0, 0)
ModalTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ModalTop.Position = UDim2.new(0, 0, 0, 0)
ModalTop.Size = UDim2.new(1, 0, 0, 50)

-- Shadow di kanan (hiasan)
local ModalTopBox = Instance.new("Frame", ModalTop)
ModalTopBox.Name = "BoxFrame"
ModalTopBox.BackgroundTransparency = 1
ModalTopBox.BorderSizePixel = 0
ModalTopBox.AnchorPoint = Vector2.new(1, 0.5)
ModalTopBox.Position = UDim2.new(1, -50, 0.5, 0)
ModalTopBox.Size = UDim2.new(0, 120, 0, 25)

local ModalDropShadow = Instance.new("ImageLabel", ModalTopBox)
ModalDropShadow.Name = "DropShadow"
ModalDropShadow.BackgroundTransparency = 1
ModalDropShadow.BorderSizePixel = 0
ModalDropShadow.Image = "rbxassetid://6014261993"
ModalDropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
ModalDropShadow.ImageTransparency = 0.75
ModalDropShadow.ScaleType = Enum.ScaleType.Slice
ModalDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
ModalDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
ModalDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
ModalDropShadow.Size = UDim2.new(1, 30, 1, 30)
ModalDropShadow.ZIndex = 0

-- Search box (Frame + TextBox + Icon)
local SearchBox = Instance.new("Frame", ModalTopBox)
SearchBox.BorderSizePixel = 0
SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
SearchBox.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
SearchBox.AutomaticSize = Enum.AutomaticSize.Y
SearchBox.Size = UDim2.new(1, 0, 1, 0)

local SearchCorner = Instance.new("UICorner", SearchBox)
SearchCorner.CornerRadius = UDim.new(0, 5)

local SearchStroke = Instance.new("UIStroke", SearchBox)
SearchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SearchStroke.Thickness = 1.5
SearchStroke.Color = Color3.fromRGB(61, 61, 75)

local SearchInput = Instance.new("TextBox", SearchBox)
SearchInput.BackgroundTransparency = 1
SearchInput.BorderSizePixel = 0
SearchInput.Size = UDim2.new(1, -25, 1, 0)
SearchInput.Text = ""
SearchInput.PlaceholderText = "Input here..."
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.TextWrapped = true
SearchInput.TextTruncate = Enum.TextTruncate.AtEnd
SearchInput.TextSize = 14
SearchInput.TextColor3 = Color3.fromRGB(197, 204, 219)
SearchInput.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
SearchInput.ClipsDescendants = true

local SearchPadding = Instance.new("UIPadding", SearchInput)
SearchPadding.PaddingTop    = UDim.new(0, 10)
SearchPadding.PaddingBottom = UDim.new(0, 10)
SearchPadding.PaddingLeft   = UDim.new(0, 10)
SearchPadding.PaddingRight  = UDim.new(0, 10)

local SearchBtn = Instance.new("ImageButton", SearchBox)
SearchBtn.Name = "Search"
SearchBtn.BackgroundTransparency = 1
SearchBtn.BorderSizePixel = 0
SearchBtn.Position = UDim2.new(1, -5, 0.5, 0)
SearchBtn.AnchorPoint = Vector2.new(1, 0.5)
SearchBtn.Size = UDim2.new(0, 15, 0, 15)
SearchBtn.Image = "rbxassetid://86928976705683"
SearchBtn.ImageColor3 = Color3.fromRGB(197, 204, 219)

-- Tombol Close (kanan atas modal)
local ModalClose = Instance.new("ImageButton", ModalTop)
ModalClose.Name = "Close"
ModalClose.BackgroundTransparency = 1
ModalClose.BorderSizePixel = 0
ModalClose.ZIndex = 0
ModalClose.AnchorPoint = Vector2.new(1, 0.5)
ModalClose.Position = UDim2.new(1, -12, 0.5, 0)
ModalClose.Size = UDim2.new(0, 25, 0, 25)
ModalClose.Image = "rbxassetid://132453323679056"
ModalClose.ImageColor3 = Color3.fromRGB(197, 204, 219)

-- Judul modal
local ModalTitle = Instance.new("TextLabel", ModalTop)
ModalTitle.Name = "Title"
ModalTitle.BackgroundTransparency = 1
ModalTitle.BorderSizePixel = 0
ModalTitle.AnchorPoint = Vector2.new(0, 0.5)
ModalTitle.Position = UDim2.new(0, 12, 0.5, 0)
ModalTitle.Size = UDim2.new(0.5, 0, 0, 18)
ModalTitle.Text = "Dropdown"
ModalTitle.TextWrapped = true
ModalTitle.TextScaled = true
ModalTitle.TextSize = 18
ModalTitle.TextXAlignment = Enum.TextXAlignment.Left
ModalTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
ModalTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
ModalTitle.ZIndex = 0

-- Container untuk isi dropdown
local ModalDropdowns = Instance.new("Folder", Modal)
ModalDropdowns.Name = "Dropdowns"

-- ====== Sidebar: TabButtons ======
local TabsSide = Instance.new("Frame", Window)
Gui.TabButtons = TabsSide
TabsSide.Name = "TabButtons"
TabsSide.ClipsDescendants = true
TabsSide.BorderSizePixel = 0
TabsSide.BorderColor3 = Color3.fromRGB(61, 61, 75)
TabsSide.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
TabsSide.Size = UDim2.new(0, 165, 1, -35)
TabsSide.Position = UDim2.new(0, 0, 0, 35)
TabsSide.SelectionGroup = true

local TabsScroll = Instance.new("ScrollingFrame", TabsSide)
TabsScroll.Name = "Lists"
TabsScroll.Active = true
TabsScroll.Selectable = false
TabsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
TabsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabsScroll.ElasticBehavior = Enum.ElasticBehavior.Never
TabsScroll.ScrollBarThickness = 4
TabsScroll.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
TabsScroll.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
TabsScroll.BackgroundTransparency = 1
TabsScroll.BorderSizePixel = 0
TabsScroll.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
TabsScroll.Size = UDim2.new(1, 0, 1, 0)
TabsScroll.BorderColor3 = Color3.fromRGB(61, 61, 75)

local TabsListLayout = Instance.new("UIListLayout", TabsScroll)
TabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Template: TabButton (hidden)
local TabTemplate = Instance.new("Frame", TabsScroll)
TabTemplate.Name = "TabButton"
TabTemplate.Visible = false
TabTemplate.BackgroundTransparency = 1
TabTemplate.BorderSizePixel = 0
TabTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabTemplate.Size = UDim2.new(1, 0, 0, 36)
TabTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)

local TabBar = Instance.new("Frame", TabTemplate)
TabBar.Name = "Bar"
TabBar.BorderSizePixel = 0
TabBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(197, 204, 219)
TabBar.AnchorPoint = Vector2.new(0, 0.5)
TabBar.Position = UDim2.new(0, 8, 0, 18)
TabBar.Size = UDim2.new(0, 5, 0, 25)

local TabBarGrad = Instance.new("UIGradient", TabBar)
TabBarGrad.Enabled = false
TabBarGrad.Rotation = 90
TabBarGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(110, 212, 255)),
    ColorSequenceKeypoint.new(0.978, Color3.fromRGB(0, 124, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 218, 255)),
}
local TabBarCorner = Instance.new("UICorner", TabBar)
TabBarCorner.CornerRadius = UDim.new(0, 100)

local TabIcon = Instance.new("ImageButton", TabTemplate)
TabIcon.BackgroundTransparency = 1
TabIcon.BorderSizePixel = 0
TabIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
TabIcon.AnchorPoint = Vector2.new(0, 0.5)
TabIcon.Position = UDim2.new(0, 21, 0, 18)
TabIcon.Size = UDim2.new(0, 31, 0, 30)
TabIcon.Image = "rbxassetid://113216930555884"
local TabIconAspect = Instance.new("UIAspectRatioConstraint", TabIcon)

local TabTitle = Instance.new("TextLabel", TabTemplate)
TabTitle.BackgroundTransparency = 1
TabTitle.BorderSizePixel = 0
TabTitle.AnchorPoint = Vector2.new(0, 0.5)
TabTitle.Position = UDim2.new(0, 57, 0.5, 0)
TabTitle.Size = UDim2.new(0, 88, 0, 16)
TabTitle.Text = "NatHub"
TabTitle.TextWrapped = true
TabTitle.TextScaled = true
TabTitle.TextSize = 14
TabTitle.TextXAlignment = Enum.TextXAlignment.Left
TabTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
TabTitle.TextColor3 = Color3.fromRGB(197, 204, 219)

local TabsPadding = Instance.new("UIPadding", TabsScroll)
TabsPadding.PaddingTop = UDim.new(0, 8)

-- Divider Template
local Divider = Instance.new("Frame", TabsScroll)
Divider.Name = "Divider"
Divider.Visible = false
Divider.BorderSizePixel = 0
Divider.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
Divider.BorderColor3 = Color3.fromRGB(61, 61, 75)
Divider.Size = UDim2.new(1, 0, 0, 1)

-- Actual TabButton (default style; hidden)
local TabBtn = Instance.new("ImageButton", TabsScroll)
TabBtn.Name = "TabButton"
TabBtn.Visible = false
TabBtn.AutoButtonColor = false
TabBtn.Active = false
TabBtn.Selectable = false
TabBtn.BackgroundTransparency = 1
TabBtn.BorderSizePixel = 0
TabBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabBtn.Size = UDim2.new(1, 0, 0, 36)

local TabBtnIcon = Instance.new("ImageButton", TabBtn)
TabBtnIcon.BackgroundTransparency = 1
TabBtnIcon.BorderSizePixel = 0
TabBtnIcon.Image = "rbxassetid://113216930555884"
TabBtnIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
TabBtnIcon.ImageTransparency = 0.5
TabBtnIcon.AnchorPoint = Vector2.new(0, 0.5)
TabBtnIcon.Position = UDim2.new(0, 6, 0, 18)
TabBtnIcon.Size = UDim2.new(0, 31, 0, 30)
local TabBtnIconAspect = Instance.new("UIAspectRatioConstraint", TabBtnIcon)

local TabBtnTitle = Instance.new("TextLabel", TabBtn)
TabBtnTitle.BackgroundTransparency = 1
TabBtnTitle.BorderSizePixel = 0
TabBtnTitle.AnchorPoint = Vector2.new(0, 0.5)
TabBtnTitle.Position = UDim2.new(0, 42, 0.5, 0)
TabBtnTitle.Size = UDim2.new(0, 103, 0, 16)
TabBtnTitle.Text = "NatHub"
TabBtnTitle.TextWrapped = true
TabBtnTitle.TextScaled = true
TabBtnTitle.TextSize = 14
TabBtnTitle.TextXAlignment = Enum.TextXAlignment.Left
TabBtnTitle.TextTransparency = 0.5
TabBtnTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TabBtnTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local TabBtnBar = Instance.new("Frame", TabBtn)
TabBtnBar.Name = "Bar"
TabBtnBar.BackgroundTransparency = 1
TabBtnBar.BorderSizePixel = 0
TabBtnBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabBtnBar.BackgroundColor3 = Color3.fromRGB(197, 204, 219)
TabBtnBar.AnchorPoint = Vector2.new(0, 0.5)
TabBtnBar.Position = UDim2.new(0, 8, 0, 18)
TabBtnBar.Size = UDim2.new(0, 5, 0, 0)
local TabBtnBarCorner = Instance.new("UICorner", TabBtnBar)
TabBtnBarCorner.CornerRadius = UDim.new(0, 100)

local TabsSideCorner = Instance.new("UICorner", TabsSide)
TabsSideCorner.CornerRadius = UDim.new(0, 6)

local TabsAntiCornerTop = Instance.new("Frame", TabsSide)
TabsAntiCornerTop.Name = "AntiCornerTop"
TabsAntiCornerTop.BorderSizePixel = 0
TabsAntiCornerTop.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
TabsAntiCornerTop.Size = UDim2.new(1, 0, 0, 5)

local TabsAntiCornerRight = Instance.new("Frame", TabsSide)
TabsAntiCornerRight.Name = "AntiCornerRight"
TabsAntiCornerRight.BorderSizePixel = 0
TabsAntiCornerRight.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
TabsAntiCornerRight.AnchorPoint = Vector2.new(0.5, 0)
TabsAntiCornerRight.Position = UDim2.new(1, 1, 0, 0)
TabsAntiCornerRight.Size = UDim2.new(0, 2, 1, 0)

local TabsBorder = Instance.new("Frame", TabsSide)
TabsBorder.Name = "Border"
TabsBorder.ZIndex = 2
TabsBorder.BorderSizePixel = 0
TabsBorder.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
TabsBorder.AnchorPoint = Vector2.new(1, 0)
TabsBorder.Position = UDim2.new(1, 0, 0, 0)
TabsBorder.Size = UDim2.new(0, 2, 1, 0)

-- ====== TopFrame (titlebar) ======
local TopFrame = Instance.new("Frame", Window)
TopFrame.Name = "TopFrame"
TopFrame.BorderSizePixel = 0
TopFrame.BorderColor3 = Color3.fromRGB(61, 61, 75)
TopFrame.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
TopFrame.Size = UDim2.new(1, 0, 0, 35)

local TopIcon = Instance.new("ImageButton", TopFrame)
TopIcon.Name = "Icon"
TopIcon.Active = false
TopIcon.Interactable = false
TopIcon.BackgroundTransparency = 1
TopIcon.BorderSizePixel = 0
TopIcon.AnchorPoint = Vector2.new(0, 0.5)
TopIcon.Position = UDim2.new(0, 10, 0.5, 0)
TopIcon.Size = UDim2.new(0, 25, 0, 25)
TopIcon.Image = "rbxassetid://113216930555884"
local TopIconAspect = Instance.new("UIAspectRatioConstraint", TopIcon)

local TopTitle = Instance.new("TextLabel", TopFrame)
TopTitle.Interactable = false
TopTitle.BackgroundTransparency = 1
TopTitle.BorderSizePixel = 0
TopTitle.AnchorPoint = Vector2.new(0.5, 0.5)
TopTitle.Position = UDim2.new(0.5, 0, 0.5, -1)
TopTitle.Size = UDim2.new(1, 0, 0, 16)
TopTitle.Text = "NatHub - v1.2.3"
TopTitle.TextWrapped = true
TopTitle.TextScaled = true
TopTitle.TextSize = 14
TopTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TopTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

local TopClose = Instance.new("ImageButton", TopFrame)
TopClose.Name = "Close"
TopClose.BackgroundTransparency = 1
TopClose.BorderSizePixel = 0
TopClose.AnchorPoint = Vector2.new(1, 0.5)
TopClose.Position = UDim2.new(1, -15, 0.5, 0)
TopClose.Size = UDim2.new(0, 20, 0, 20)
TopClose.Image = "rbxassetid://132453323679056"
TopClose.ImageColor3 = Color3.fromRGB(197, 204, 219)

local TopMaximize = Instance.new("ImageButton", TopFrame)
TopMaximize.Name = "Maximize"
TopMaximize.BackgroundTransparency = 1
TopMaximize.BorderSizePixel = 0
TopMaximize.AnchorPoint = Vector2.new(1, 0.5)
TopMaximize.Position = UDim2.new(1, -55, 0.5, 0)
TopMaximize.Size = UDim2.new(0, 15, 0, 15)
TopMaximize.Image = "rbxassetid://108285848026510"
TopMaximize.ImageColor3 = Color3.fromRGB(197, 204, 219)

local TopHide = Instance.new("ImageButton", TopFrame)
TopHide.Name = "Hide"
TopHide.BackgroundTransparency = 1
TopHide.BorderSizePixel = 0
TopHide.AnchorPoint = Vector2.new(1, 0.5)
TopHide.Position = UDim2.new(1, -90, 0.5, 0)
TopHide.Size = UDim2.new(0, 20, 0, 20)
TopHide.Image = "rbxassetid://128209591224511"
TopHide.ImageColor3 = Color3.fromRGB(197, 204, 219)

local TopCorner = Instance.new("UICorner", TopFrame)
TopCorner.CornerRadius = UDim.new(0, 6)

local TopBorder = Instance.new("Frame", TopFrame)
TopBorder.Name = "Border"
TopBorder.ZIndex = 2
TopBorder.BorderSizePixel = 0
TopBorder.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
TopBorder.AnchorPoint = Vector2.new(0, 0.5)
TopBorder.Position = UDim2.new(0, 0, 1, 0)
TopBorder.Size = UDim2.new(1, 0, 0, 2)

-- ====== Tabs Container (content area) ======
local Tabs = Instance.new("Frame", Window)
Gui.Tabs = Tabs
Tabs.Name = "Tabs"
Tabs.BorderSizePixel = 0
Tabs.BorderColor3 = Color3.fromRGB(61, 61, 75)
Tabs.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
Tabs.Position = UDim2.new(0, 165, 0, 35)
Tabs.Size = UDim2.new(1, -165, 1, -35)

local TabsCorner = Instance.new("UICorner", Tabs)
TabsCorner.CornerRadius = UDim.new(0, 6)

local TabsAntiLeft = Instance.new("Frame", Tabs)
TabsAntiLeft.Name = "AntiCornerLeft"
TabsAntiLeft.Visible = false
TabsAntiLeft.BorderSizePixel = 0
TabsAntiLeft.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
TabsAntiLeft.Size = UDim2.new(0, 5, 1, 0)

local TabsAntiTop = Instance.new("Frame", Tabs)
TabsAntiTop.Name = "AntiCornerTop"
TabsAntiTop.BorderSizePixel = 0
TabsAntiTop.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
TabsAntiTop.Size = UDim2.new(1, 0, 0, 5)

local EmptyText = Instance.new("TextLabel", Tabs)
EmptyText.Name = "NoObjectFoundText"
EmptyText.Visible = false
EmptyText.Interactable = false
EmptyText.BackgroundTransparency = 1
EmptyText.BorderSizePixel = 0
EmptyText.AnchorPoint = Vector2.new(0.5, 0.5)
EmptyText.Position = UDim2.new(0.5, 0, 0.45, 0)
EmptyText.Size = UDim2.new(1, 0, 0, 16)
EmptyText.Text = "This tab is empty :("
EmptyText.TextWrapped = true
EmptyText.TextScaled = true
EmptyText.TextSize = 14
EmptyText.TextColor3 = Color3.fromRGB(135, 140, 150)
EmptyText.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

-- ====== Overlay & Notifications ======
local NotificationFrame = Instance.new("Frame", Window)
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.ClipsDescendants = true
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Size = UDim2.new(1, 0, 1, 0)

local NotificationList = Instance.new("Frame", NotificationFrame)
NotificationList.Name = "NotificationList"
NotificationList.ZIndex = 5
NotificationList.BackgroundTransparency = 1
NotificationList.ClipsDescendants = true
NotificationList.BorderSizePixel = 0
NotificationList.AnchorPoint = Vector2.new(0.5, 0)
NotificationList.Position = UDim2.new(1, 0, 0, 35)
NotificationList.Size = UDim2.new(0, 630, 1, -35)

local NotifLayout = Instance.new("UIListLayout", NotificationList)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding   = UDim.new(0, 12)

local NotifPadding = Instance.new("UIPadding", NotificationList)
NotifPadding.PaddingTop    = UDim.new(0, 10)
NotifPadding.PaddingLeft   = UDim.new(0, 40)
NotifPadding.PaddingRight  = UDim.new(0, 40)

local DarkOverlay = Instance.new("Frame", Window)
DarkOverlay.Name = "DarkOverlay"
DarkOverlay.Visible = false
DarkOverlay.BackgroundTransparency = 0.6
DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DarkOverlay.BorderSizePixel = 0
DarkOverlay.Size = UDim2.new(1, 0, 1, 0)

local DarkOverlayCorner = Instance.new("UICorner", DarkOverlay)
DarkOverlayCorner.CornerRadius = UDim.new(0, 10)

-- ====== Templates (folder) ======
local Templates = Instance.new("Folder", ScreenGui)
Templates.Name = "Templates"

local TemplateDivider = Instance.new("Frame", Templates)
TemplateDivider.Name = "Divider"
TemplateDivider.Visible = false
TemplateDivider.BorderSizePixel = 0
TemplateDivider.BorderColor3 = Color3.fromRGB(61, 61, 75)
TemplateDivider.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
TemplateDivider.Size = UDim2.new(1, 0, 0, 1)

local TemplateTab = Instance.new("ScrollingFrame", Templates)
TemplateTab.Name = "Tab"
TemplateTab.Visible = false
TemplateTab.Active = true
TemplateTab.Selectable = false
TemplateTab.ScrollingDirection = Enum.ScrollingDirection.Y
TemplateTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
TemplateTab.CanvasSize = UDim2.new(0, 0, 0, 0)
TemplateTab.ElasticBehavior = Enum.ElasticBehavior.Never
TemplateTab.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
TemplateTab.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
TemplateTab.BackgroundTransparency = 1
TemplateTab.BorderSizePixel = 0
TemplateTab.Size = UDim2.new(1, 0, 1, 0)
--[[ =========================
BLOCK 002: L501–L1000 (Templates: Tab, TabButton, Button, Paragraph, Toggle, Notification, Slider)]]
TemplateTab.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
TemplateTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateTab.ScrollBarThickness = 5
TemplateTab.BackgroundTransparency = 1

local TemplateTabList = Instance.new("UIListLayout", TemplateTab)
TemplateTabList.Padding = UDim.new(0, 15)
TemplateTabList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateTabPadding = Instance.new("UIPadding", TemplateTab)
TemplateTabPadding.PaddingTop    = UDim.new(0, 10)
TemplateTabPadding.PaddingRight  = UDim.new(0, 14)
TemplateTabPadding.PaddingLeft   = UDim.new(0, 10)
TemplateTabPadding.PaddingBottom = UDim.new(0, 10)

-- ====== Template: Sidebar TabButton (simple) ======
local TemplateSideTab = Instance.new("ImageButton", Templates)
TemplateSideTab.Name = "TabButton"
TemplateSideTab.Visible = false
TemplateSideTab.AutoButtonColor = false
TemplateSideTab.Selectable = false
TemplateSideTab.BackgroundTransparency = 1
TemplateSideTab.BorderSizePixel = 0
TemplateSideTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateSideTab.Size = UDim2.new(1, 0, 0, 36)

local TemplateSideTabIcon = Instance.new("ImageButton", TemplateSideTab)
TemplateSideTabIcon.BackgroundTransparency = 1
TemplateSideTabIcon.BorderSizePixel = 0
TemplateSideTabIcon.Image = "rbxassetid://113216930555884"
TemplateSideTabIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
TemplateSideTabIcon.ImageTransparency = 0.5
TemplateSideTabIcon.AnchorPoint = Vector2.new(0, 0.5)
TemplateSideTabIcon.Position = UDim2.new(0, 12, 0, 18)
TemplateSideTabIcon.Size = UDim2.new(0, 20, 0, 20)
local TemplateSideTabIconAspect = Instance.new("UIAspectRatioConstraint", TemplateSideTabIcon)

local TemplateSideTabText = Instance.new("TextLabel", TemplateSideTab)
TemplateSideTabText.BackgroundTransparency = 1
TemplateSideTabText.BorderSizePixel = 0
TemplateSideTabText.AnchorPoint = Vector2.new(0, 0.5)
TemplateSideTabText.Position = UDim2.new(0, 42, 0.5, 0)
TemplateSideTabText.Size = UDim2.new(0, 103, 0, 16)
TemplateSideTabText.Text = ""
TemplateSideTabText.TextWrapped = true
TemplateSideTabText.TextScaled = true
TemplateSideTabText.TextSize = 14
TemplateSideTabText.TextXAlignment = Enum.TextXAlignment.Left
TemplateSideTabText.TextTransparency = 0.5
TemplateSideTabText.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateSideTabText.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local TemplateSideTabBar = Instance.new("Frame", TemplateSideTab)
TemplateSideTabBar.Name = "Bar"
TemplateSideTabBar.BackgroundTransparency = 1
TemplateSideTabBar.BorderSizePixel = 0
TemplateSideTabBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateSideTabBar.BackgroundColor3 = Color3.fromRGB(197, 204, 219)
TemplateSideTabBar.AnchorPoint = Vector2.new(0, 0.5)
TemplateSideTabBar.Position = UDim2.new(0, 8, 0, 18)
TemplateSideTabBar.Size = UDim2.new(0, 5, 0, 0)
local TemplateSideTabBarCorner = Instance.new("UICorner", TemplateSideTabBar)
TemplateSideTabBarCorner.CornerRadius = UDim.new(0, 100)

-- ====== Template: Button ======
local TemplateButton = Instance.new("ImageButton", Templates)
TemplateButton.Name = "Button"
TemplateButton.Visible = false
TemplateButton.AutoButtonColor = false
TemplateButton.Selectable = false
TemplateButton.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateButton.BorderSizePixel = 0
TemplateButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateButton.Position = UDim2.new(0, 0, 0.384, 0)
TemplateButton.Size = UDim2.new(1, 0, 0, 35)
TemplateButton.AutomaticSize = Enum.AutomaticSize.Y

local TemplateButtonCorner = Instance.new("UICorner", TemplateButton)
TemplateButtonCorner.CornerRadius = UDim.new(0, 6)

local TemplateButtonBody = Instance.new("Frame", TemplateButton)
TemplateButtonBody.BackgroundTransparency = 1
TemplateButtonBody.BorderSizePixel = 0
TemplateButtonBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateButtonBody.Size = UDim2.new(1, 0, 0, 35)
TemplateButtonBody.AutomaticSize = Enum.AutomaticSize.Y

local TemplateButtonList = Instance.new("UIListLayout", TemplateButtonBody)
TemplateButtonList.Padding = UDim.new(0, 5)
TemplateButtonList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateButtonPadding = Instance.new("UIPadding", TemplateButtonBody)
TemplateButtonPadding.PaddingTop    = UDim.new(0, 10)
TemplateButtonPadding.PaddingRight  = UDim.new(0, 10)
TemplateButtonPadding.PaddingLeft   = UDim.new(0, 10)
TemplateButtonPadding.PaddingBottom = UDim.new(0, 10)

local TemplateButtonTitle = Instance.new("TextLabel", TemplateButtonBody)
TemplateButtonTitle.Name = "Title"
TemplateButtonTitle.Interactable = false
TemplateButtonTitle.BackgroundTransparency = 1
TemplateButtonTitle.BorderSizePixel = 0
TemplateButtonTitle.Size = UDim2.new(1, 0, 0, 15)
TemplateButtonTitle.Text = "Button"
TemplateButtonTitle.TextWrapped = true
TemplateButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
TemplateButtonTitle.TextSize = 16
TemplateButtonTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateButtonTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

local TemplateButtonClickIcon = Instance.new("ImageButton", TemplateButtonTitle)
TemplateButtonClickIcon.Name = "ClickIcon"
TemplateButtonClickIcon.BackgroundTransparency = 1
TemplateButtonClickIcon.BorderSizePixel = 0
TemplateButtonClickIcon.AnchorPoint = Vector2.new(1, 0.5)
TemplateButtonClickIcon.Position = UDim2.new(1, 0, 0.5, 0)
TemplateButtonClickIcon.Size = UDim2.new(0, 23, 0, 23)
TemplateButtonClickIcon.Image = "rbxassetid://91877599529856"
TemplateButtonClickIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
TemplateButtonClickIcon.AutoButtonColor = false

local TemplateButtonDesc = Instance.new("TextLabel", TemplateButtonBody)
TemplateButtonDesc.Name = "Description"
TemplateButtonDesc.LayoutOrder = 1
TemplateButtonDesc.Visible = false
TemplateButtonDesc.Interactable = false
TemplateButtonDesc.BackgroundTransparency = 1
TemplateButtonDesc.BorderSizePixel = 0
TemplateButtonDesc.AutomaticSize = Enum.AutomaticSize.Y
TemplateButtonDesc.Size = UDim2.new(1, 0, 0, 15)
TemplateButtonDesc.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
TemplateButtonDesc.TextWrapped = true
TemplateButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
TemplateButtonDesc.TextSize = 16
TemplateButtonDesc.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateButtonDesc.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

-- Gradients (disabled by default, warna disalin 1:1)
local TemplateBtnGrad1 = Instance.new("UIGradient", TemplateButtonBody)
TemplateBtnGrad1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}
local TemplateBtnGrad2 = Instance.new("UIGradient", TemplateButtonBody)
TemplateBtnGrad2.Enabled = false
TemplateBtnGrad2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}
local TemplateBtnGrad3 = Instance.new("UIGradient", TemplateButtonBody)
TemplateBtnGrad3.Enabled = false
TemplateBtnGrad3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}

local TemplateButtonBodyCorner = Instance.new("UICorner", TemplateButtonBody)
TemplateButtonBodyCorner.CornerRadius = UDim.new(0, 6)

local TemplateButtonStroke = Instance.new("UIStroke", TemplateButton)
TemplateButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateButtonStroke.Thickness = 1.5
TemplateButtonStroke.Color = Color3.fromRGB(61, 61, 75)

-- ====== Template: Paragraph ======
local TemplateParagraph = Instance.new("Frame", Templates)
TemplateParagraph.Name = "Paragraph"
TemplateParagraph.Visible = false
TemplateParagraph.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateParagraph.BorderSizePixel = 0
TemplateParagraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateParagraph.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
TemplateParagraph.Size = UDim2.new(1, 0, 0, 35)
TemplateParagraph.AutomaticSize = Enum.AutomaticSize.Y

local TemplateParagraphCorner = Instance.new("UICorner", TemplateParagraph)
TemplateParagraphCorner.CornerRadius = UDim.new(0, 6)

local TemplateParagraphStroke = Instance.new("UIStroke", TemplateParagraph)
TemplateParagraphStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateParagraphStroke.Thickness = 1.5
TemplateParagraphStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateParagraphTitle = Instance.new("TextLabel", TemplateParagraph)
TemplateParagraphTitle.Name = "Title"
TemplateParagraphTitle.Interactable = false
TemplateParagraphTitle.BackgroundTransparency = 1
TemplateParagraphTitle.BorderSizePixel = 0
TemplateParagraphTitle.AutomaticSize = Enum.AutomaticSize.Y
TemplateParagraphTitle.Size = UDim2.new(1, 0, 0, 15)
TemplateParagraphTitle.Text = "Title"
TemplateParagraphTitle.TextWrapped = true
TemplateParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
TemplateParagraphTitle.TextSize = 16
TemplateParagraphTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateParagraphTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local TemplateParagraphPadding = Instance.new("UIPadding", TemplateParagraph)
TemplateParagraphPadding.PaddingTop    = UDim.new(0, 10)
TemplateParagraphPadding.PaddingRight  = UDim.new(0, 10)
TemplateParagraphPadding.PaddingLeft   = UDim.new(0, 10)
TemplateParagraphPadding.PaddingBottom = UDim.new(0, 10)

local TemplateParagraphList = Instance.new("UIListLayout", TemplateParagraph)
TemplateParagraphList.Padding = UDim.new(0, 5)
TemplateParagraphList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateParagraphDesc = Instance.new("TextLabel", TemplateParagraph)
TemplateParagraphDesc.Name = "Description"
TemplateParagraphDesc.LayoutOrder = 1
TemplateParagraphDesc.Visible = false
TemplateParagraphDesc.Interactable = false
TemplateParagraphDesc.BackgroundTransparency = 1
TemplateParagraphDesc.BorderSizePixel = 0
TemplateParagraphDesc.AutomaticSize = Enum.AutomaticSize.Y
TemplateParagraphDesc.Size = UDim2.new(1, 0, 0, 15)
TemplateParagraphDesc.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
TemplateParagraphDesc.TextWrapped = true
TemplateParagraphDesc.TextXAlignment = Enum.TextXAlignment.Left
TemplateParagraphDesc.TextSize = 16
TemplateParagraphDesc.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateParagraphDesc.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

-- ====== Template: Toggle ======
local TemplateToggle = Instance.new("ImageButton", Templates)
TemplateToggle.Name = "Toggle"
TemplateToggle.Visible = false
TemplateToggle.AutoButtonColor = false
TemplateToggle.Selectable = false
TemplateToggle.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateToggle.BorderSizePixel = 0
TemplateToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateToggle.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
TemplateToggle.Size = UDim2.new(1, 0, 0, 35)
TemplateToggle.AutomaticSize = Enum.AutomaticSize.Y

local TemplateToggleCorner = Instance.new("UICorner", TemplateToggle)
TemplateToggleCorner.CornerRadius = UDim.new(0, 6)

local TemplateToggleStroke = Instance.new("UIStroke", TemplateToggle)
TemplateToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateToggleStroke.Thickness = 1.5
TemplateToggleStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateTogglePadding = Instance.new("UIPadding", TemplateToggle)
TemplateTogglePadding.PaddingTop    = UDim.new(0, 10)
TemplateTogglePadding.PaddingRight  = UDim.new(0, 10)
TemplateTogglePadding.PaddingLeft   = UDim.new(0, 10)
TemplateTogglePadding.PaddingBottom = UDim.new(0, 10)

local TemplateToggleList = Instance.new("UIListLayout", TemplateToggle)
TemplateToggleList.Padding = UDim.new(0, 5)
TemplateToggleList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateToggleDesc = Instance.new("TextLabel", TemplateToggle)
TemplateToggleDesc.Name = "Description"
TemplateToggleDesc.LayoutOrder = 1
TemplateToggleDesc.Visible = false
TemplateToggleDesc.Interactable = false
TemplateToggleDesc.BackgroundTransparency = 1
TemplateToggleDesc.BorderSizePixel = 0
TemplateToggleDesc.AutomaticSize = Enum.AutomaticSize.Y
TemplateToggleDesc.Size = UDim2.new(1, 0, 0, 15)
TemplateToggleDesc.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
TemplateToggleDesc.TextWrapped = true
TemplateToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
TemplateToggleDesc.TextSize = 16
TemplateToggleDesc.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateToggleDesc.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local TemplateToggleTitle = Instance.new("TextLabel", TemplateToggle)
TemplateToggleTitle.Name = "Title"
TemplateToggleTitle.BackgroundTransparency = 1
TemplateToggleTitle.BorderSizePixel = 0
TemplateToggleTitle.Size = UDim2.new(1, 0, 0, 15)
TemplateToggleTitle.Text = "Toggle"
TemplateToggleTitle.TextWrapped = true
TemplateToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
TemplateToggleTitle.TextSize = 16
TemplateToggleTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateToggleTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

local TemplateToggleFill = Instance.new("ImageButton", TemplateToggleTitle)
TemplateToggleFill.Name = "Fill"
TemplateToggleFill.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
TemplateToggleFill.BorderSizePixel = 0
TemplateToggleFill.AnchorPoint = Vector2.new(1, 0.5)
TemplateToggleFill.Position = UDim2.new(1, 0, 0.5, 0)
TemplateToggleFill.Size = UDim2.new(0, 45, 0, 25)
TemplateToggleFill.ImageColor3 = Color3.fromRGB(197, 204, 219)
TemplateToggleFill.AutoButtonColor = false
local TemplateToggleFillCorner = Instance.new("UICorner", TemplateToggleFill)
TemplateToggleFillCorner.CornerRadius = UDim.new(100, 0)

local TemplateToggleBall = Instance.new("ImageButton", TemplateToggleFill)
TemplateToggleBall.Name = "Ball"
TemplateToggleBall.Active = false
TemplateToggleBall.Interactable = false
TemplateToggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TemplateToggleBall.BorderSizePixel = 0
TemplateToggleBall.AnchorPoint = Vector2.new(0, 0.5)
TemplateToggleBall.Position = UDim2.new(0, 0, 0.5, 0)
TemplateToggleBall.Size = UDim2.new(0, 20, 0, 20)
TemplateToggleBall.ImageColor3 = Color3.fromRGB(197, 204, 219)
TemplateToggleBall.AutoButtonColor = false
local TemplateToggleBallCorner = Instance.new("UICorner", TemplateToggleBall)
TemplateToggleBallCorner.CornerRadius = UDim.new(100, 0)

local TemplateToggleBallIcon = Instance.new("ImageLabel", TemplateToggleBall)
TemplateToggleBallIcon.Name = "Icon"
TemplateToggleBallIcon.BackgroundTransparency = 1
TemplateToggleBallIcon.BorderSizePixel = 0
TemplateToggleBallIcon.AnchorPoint = Vector2.new(0.5, 0.5)
TemplateToggleBallIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
TemplateToggleBallIcon.Size = UDim2.new(1, -5, 1, -5)
TemplateToggleBallIcon.ImageColor3 = Color3.fromRGB(54, 57, 63)

local TemplateToggleFillPadding = Instance.new("UIPadding", TemplateToggleFill)
TemplateToggleFillPadding.PaddingTop    = UDim.new(0, 2)
TemplateToggleFillPadding.PaddingRight  = UDim.new(0, 2)
TemplateToggleFillPadding.PaddingLeft   = UDim.new(0, 2)
TemplateToggleFillPadding.PaddingBottom = UDim.new(0, 2)

-- ====== Template: Notification ======
local TemplateNotifRoot = Instance.new("Frame", Templates)
TemplateNotifRoot.Name = "Notification"
TemplateNotifRoot.Visible = false
TemplateNotifRoot.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
TemplateNotifRoot.BackgroundTransparency = 1
TemplateNotifRoot.BorderSizePixel = 0
TemplateNotifRoot.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateNotifRoot.AnchorPoint = Vector2.new(0.5, 0.5)
TemplateNotifRoot.Position = UDim2.new(0.8244, 0, 0.88221, 0)
TemplateNotifRoot.Size = UDim2.new(1, 0, 0, 65)
TemplateNotifRoot.AutomaticSize = Enum.AutomaticSize.Y

local TemplateNotifItems = Instance.new("CanvasGroup", TemplateNotifRoot)
TemplateNotifItems.Name = "Items"
TemplateNotifItems.ZIndex = 2
TemplateNotifItems.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
TemplateNotifItems.BorderSizePixel = 0
TemplateNotifItems.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateNotifItems.Size = UDim2.new(0, 265, 0, 70)
TemplateNotifItems.AutomaticSize = Enum.AutomaticSize.Y

local TemplateNotifBody = Instance.new("Frame", TemplateNotifItems)
TemplateNotifBody.BackgroundTransparency = 1
TemplateNotifBody.BorderSizePixel = 0
TemplateNotifBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateNotifBody.Size = UDim2.new(0, 265, 0, 70)
TemplateNotifBody.AutomaticSize = Enum.AutomaticSize.Y

local TemplateNotifList = Instance.new("UIListLayout", TemplateNotifBody)
TemplateNotifList.Padding = UDim.new(0, 5)
TemplateNotifList.VerticalAlignment = Enum.VerticalAlignment.Center
TemplateNotifList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateNotifPadding = Instance.new("UIPadding", TemplateNotifBody)
TemplateNotifPadding.PaddingTop    = UDim.new(0, 15)
TemplateNotifPadding.PaddingLeft   = UDim.new(0, 15)
TemplateNotifPadding.PaddingBottom = UDim.new(0, 15)

local TemplateNotifSub = Instance.new("TextLabel", TemplateNotifBody)
TemplateNotifSub.Name = "SubContent"
TemplateNotifSub.LayoutOrder = 1
TemplateNotifSub.Visible = false
TemplateNotifSub.BackgroundTransparency = 1
TemplateNotifSub.BorderSizePixel = 0
TemplateNotifSub.AnchorPoint = Vector2.new(0, 0.5)
TemplateNotifSub.Position = UDim2.new(0, 0, 0, 19)
TemplateNotifSub.Size = UDim2.new(0, 218, 0, 10)
TemplateNotifSub.Text = "This is a notification"
TemplateNotifSub.TextWrapped = true
TemplateNotifSub.TextXAlignment = Enum.TextXAlignment.Left
TemplateNotifSub.TextSize = 12
TemplateNotifSub.TextColor3 = Color3.fromRGB(181, 181, 181)
TemplateNotifSub.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local TemplateNotifSubGrad = Instance.new("UIGradient", TemplateNotifSub)
TemplateNotifSubGrad.Enabled = false
TemplateNotifSubGrad.Rotation = -90
TemplateNotifSubGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 226)),
}

local TemplateNotifTitle = Instance.new("TextLabel", TemplateNotifBody)
TemplateNotifTitle.Name = "Title"
TemplateNotifTitle.BackgroundTransparency = 1
TemplateNotifTitle.BorderSizePixel = 0
TemplateNotifTitle.AnchorPoint = Vector2.new(0, 0.5)
TemplateNotifTitle.Position = UDim2.new(0, 0, 0, 9)
TemplateNotifTitle.Size = UDim2.new(0, 235, 0, 18)
TemplateNotifTitle.Text = "Title"
TemplateNotifTitle.TextWrapped = true
TemplateNotifTitle.TextScaled = true
TemplateNotifTitle.TextSize = 16
TemplateNotifTitle.TextXAlignment = Enum.TextXAlignment.Left
TemplateNotifTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateNotifTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local TemplateNotifClose = Instance.new("ImageButton", TemplateNotifTitle)
TemplateNotifClose.Name = "Close"
TemplateNotifClose.BackgroundTransparency = 1
TemplateNotifClose.BorderSizePixel = 0
TemplateNotifClose.AnchorPoint = Vector2.new(0, 0.5)
TemplateNotifClose.Position = UDim2.new(0.92, 0, 0.5, 0)
TemplateNotifClose.Size = UDim2.new(0.09706, 0, 1.33333, 0)
TemplateNotifClose.Image = "rbxassetid://132453323679056"
TemplateNotifClose.ImageColor3 = Color3.fromRGB(197, 204, 219)
local TemplateNotifCloseAspect = Instance.new("UIAspectRatioConstraint", TemplateNotifClose)

local TemplateNotifTitlePad = Instance.new("UIPadding", TemplateNotifTitle)
TemplateNotifTitlePad.PaddingLeft = UDim.new(0, 30)

local TemplateNotifIcon = Instance.new("ImageButton", TemplateNotifTitle)
TemplateNotifIcon.Name = "Icon"
TemplateNotifIcon.BackgroundTransparency = 1
TemplateNotifIcon.BorderSizePixel = 0
TemplateNotifIcon.AnchorPoint = Vector2.new(0, 0.5)
TemplateNotifIcon.Position = UDim2.new(0, -30, 0.5, 0)
TemplateNotifIcon.Size = UDim2.new(0.09706, 0, 1.33333, 0)
TemplateNotifIcon.Image = "rbxassetid://92049322344253"
TemplateNotifIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
local TemplateNotifIconAspect = Instance.new("UIAspectRatioConstraint", TemplateNotifIcon)

local TemplateNotifContent = Instance.new("TextLabel", TemplateNotifBody)
TemplateNotifContent.Name = "Content"
TemplateNotifContent.LayoutOrder = 2
TemplateNotifContent.BackgroundTransparency = 1
TemplateNotifContent.BorderSizePixel = 0
TemplateNotifContent.AnchorPoint = Vector2.new(0, 0.5)
TemplateNotifContent.Position = UDim2.new(0, 0, 0, 19)
TemplateNotifContent.Size = UDim2.new(0, 218, 0, 10)
TemplateNotifContent.Text = "Content"
TemplateNotifContent.TextWrapped = true
TemplateNotifContent.TextXAlignment = Enum.TextXAlignment.Left
TemplateNotifContent.TextSize = 16
TemplateNotifContent.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateNotifContent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local TemplateNotifContentGrad = Instance.new("UIGradient", TemplateNotifContent)
TemplateNotifContentGrad.Enabled = false
TemplateNotifContentGrad.Rotation = -90
TemplateNotifContentGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 226)),
}

local TemplateNotifTimerFill = Instance.new("Frame", TemplateNotifItems)
TemplateNotifTimerFill.Name = "TimerBarFill"
TemplateNotifTimerFill.BackgroundTransparency = 0.7
TemplateNotifTimerFill.BorderSizePixel = 0
TemplateNotifTimerFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateNotifTimerFill.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
TemplateNotifTimerFill.AnchorPoint = Vector2.new(0, 1)
TemplateNotifTimerFill.Position = UDim2.new(0, 0, 1, 0)
TemplateNotifTimerFill.Size = UDim2.new(1, 0, 0, 5)
local TemplateNotifTimerFillCorner = Instance.new("UICorner", TemplateNotifTimerFill)

local TemplateNotifTimerBar = Instance.new("Frame", TemplateNotifTimerFill)
TemplateNotifTimerBar.Name = "Bar"
TemplateNotifTimerBar.BorderSizePixel = 0
TemplateNotifTimerBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateNotifTimerBar.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
TemplateNotifTimerBar.Size = UDim2.new(1, 0, 1, 0)
local TemplateNotifTimerBarCorner = Instance.new("UICorner", TemplateNotifTimerBar)

local TemplateNotifStroke = Instance.new("UIStroke", TemplateNotifItems)
TemplateNotifStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateNotifStroke.Thickness = 1.5
TemplateNotifStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateNotifItemsCorner = Instance.new("UICorner", TemplateNotifItems)

-- ====== Template: Slider ======
local TemplateSlider = Instance.new("Frame", Templates)
TemplateSlider.Name = "Slider"
TemplateSlider.Visible = false
TemplateSlider.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateSlider.BorderSizePixel = 0
TemplateSlider.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateSlider.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
TemplateSlider.Size = UDim2.new(1, 0, 0, 35)
TemplateSlider.AutomaticSize = Enum.AutomaticSize.Y

local TemplateSliderCorner = Instance.new("UICorner", TemplateSlider)
TemplateSliderCorner.CornerRadius = UDim.new(0, 6)

local TemplateSliderStroke = Instance.new("UIStroke", TemplateSlider)
TemplateSliderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateSliderStroke.Thickness = 1.5
TemplateSliderStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateSliderTitle = Instance.new("TextLabel", TemplateSlider)
TemplateSliderTitle.Name = "Title"
TemplateSliderTitle.Interactable = false
TemplateSliderTitle.BackgroundTransparency = 1
TemplateSliderTitle.BorderSizePixel = 0
TemplateSliderTitle.AutomaticSize = Enum.AutomaticSize.Y
TemplateSliderTitle.Size = UDim2.new(1, 0, 0, 15)
TemplateSliderTitle.Text = "Slider"
TemplateSliderTitle.TextWrapped = true
TemplateSliderTitle.TextXAlignment = Enum.TextXAlignment.Left
TemplateSliderTitle.TextSize = 16
TemplateSliderTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateSliderTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local TemplateSliderPadding = Instance.new("UIPadding", TemplateSlider)
TemplateSliderPadding.PaddingTop    = UDim.new(0, 10)
TemplateSliderPadding.PaddingRight  = UDim.new(0, 10)
TemplateSliderPadding.PaddingLeft   = UDim.new(0, 10)
TemplateSliderPadding.PaddingBottom = UDim.new(0, 10)
--[[ =========================
BLOCK 003: L1001–L1500
(Template Slider lanjutan, Template TextBox, Template Dropdown, DropdownList)
========================= ]]

-- ====== Template: Slider (lanjutan) ======
local TemplateSliderList = Instance.new("UIListLayout", TemplateSlider)
TemplateSliderList.Padding   = UDim.new(0, 5)
TemplateSliderList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateSliderDesc = Instance.new("TextLabel", TemplateSlider)
TemplateSliderDesc.Name = "Description"
TemplateSliderDesc.Visible = false
TemplateSliderDesc.Interactable = false
TemplateSliderDesc.BackgroundTransparency = 1
TemplateSliderDesc.BorderSizePixel = 0
TemplateSliderDesc.AutomaticSize = Enum.AutomaticSize.Y
TemplateSliderDesc.Size = UDim2.new(1, 0, 0, 15)
TemplateSliderDesc.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
TemplateSliderDesc.TextWrapped = true
TemplateSliderDesc.TextXAlignment = Enum.TextXAlignment.Left
TemplateSliderDesc.TextSize = 16
TemplateSliderDesc.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateSliderDesc.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TemplateSliderDesc.LayoutOrder = 1

local TemplateSliderFrame = Instance.new("Frame", TemplateSlider)
TemplateSliderFrame.Name = "SliderFrame"
TemplateSliderFrame.ZIndex = 0
TemplateSliderFrame.BackgroundTransparency = 1
TemplateSliderFrame.BorderSizePixel = 0
TemplateSliderFrame.Size = UDim2.new(1, 0, 0, 25)
TemplateSliderFrame.LayoutOrder = 2

local TemplateSliderInner = Instance.new("Frame", TemplateSliderFrame)
TemplateSliderInner.ZIndex = 0
TemplateSliderInner.BackgroundTransparency = 1
TemplateSliderInner.BorderSizePixel = 0
TemplateSliderInner.AnchorPoint = Vector2.new(0, 0.5)
TemplateSliderInner.Position = UDim2.new(0, 0, 0.5, 0)
TemplateSliderInner.Size = UDim2.new(1, 0, 0, 20)

local TemplateSliderShadow = Instance.new("ImageLabel", TemplateSliderInner)
TemplateSliderShadow.Name = "DropShadow"
TemplateSliderShadow.BackgroundTransparency = 1
TemplateSliderShadow.BorderSizePixel = 0
TemplateSliderShadow.Image = "rbxassetid://6014261993"
TemplateSliderShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
TemplateSliderShadow.ImageTransparency = 0.75
TemplateSliderShadow.ScaleType = Enum.ScaleType.Slice
TemplateSliderShadow.SliceCenter = Rect.new(49, 49, 450, 450)
TemplateSliderShadow.AnchorPoint = Vector2.new(0.5, 0.5)
TemplateSliderShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
TemplateSliderShadow.Size = UDim2.new(1, 25, 1, 25)
TemplateSliderShadow.ZIndex = 0

local TemplateSliderBar = Instance.new("CanvasGroup", TemplateSliderInner)
TemplateSliderBar.Name = "Slider"
TemplateSliderBar.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateSliderBar.BorderSizePixel = 0
TemplateSliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateSliderBar.Size = UDim2.new(1, 0, 1, 0)

local TemplateSliderBarCorner = Instance.new("UICorner", TemplateSliderBar)
TemplateSliderBarCorner.CornerRadius = UDim.new(0, 5)

local TemplateSliderBarStroke = Instance.new("UIStroke", TemplateSliderBar)
TemplateSliderBarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateSliderBarStroke.Thickness = 1.5
TemplateSliderBarStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateSliderBarPadding = Instance.new("UIPadding", TemplateSliderBar)
TemplateSliderBarPadding.PaddingTop    = UDim.new(0, 2)
TemplateSliderBarPadding.PaddingRight  = UDim.new(0, 2)
TemplateSliderBarPadding.PaddingLeft   = UDim.new(0, 2)
TemplateSliderBarPadding.PaddingBottom = UDim.new(0, 2)

local TemplateSliderTrigger = Instance.new("TextButton", TemplateSliderBar)
TemplateSliderTrigger.Name = "Trigger"
TemplateSliderTrigger.BackgroundTransparency = 1
TemplateSliderTrigger.BorderSizePixel = 0
TemplateSliderTrigger.Size = UDim2.new(1, 0, 1, 0)
TemplateSliderTrigger.Text = ""
TemplateSliderTrigger.TextSize = 14
TemplateSliderTrigger.TextColor3 = Color3.fromRGB(0, 0, 0)
TemplateSliderTrigger.AutoButtonColor = false
TemplateSliderTrigger.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local TemplateSliderFill = Instance.new("ImageButton", TemplateSliderBar)
TemplateSliderFill.Name = "Fill"
TemplateSliderFill.Active = false
TemplateSliderFill.Interactable = false
TemplateSliderFill.BackgroundTransparency = 1
TemplateSliderFill.BorderSizePixel = 0
TemplateSliderFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateSliderFill.Selectable = false
TemplateSliderFill.ClipsDescendants = true
TemplateSliderFill.AnchorPoint = Vector2.new(0, 0.5)
TemplateSliderFill.Position = UDim2.new(0, 0, 0.5, 0)
TemplateSliderFill.Size = UDim2.new(0, 0, 1, 0)

local TemplateSliderFillCorner = Instance.new("UICorner", TemplateSliderFill)
TemplateSliderFillCorner.CornerRadius = UDim.new(0, 4)

local TemplateSliderFillStroke = Instance.new("UIStroke", TemplateSliderFill)
TemplateSliderFillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateSliderFillStroke.Thickness = 1.5
TemplateSliderFillStroke.Color = Color3.fromRGB(11, 136, 214)

local TemplateSliderFillBg = Instance.new("ImageButton", TemplateSliderFill)
TemplateSliderFillBg.Name = "BackgroundGradient"
TemplateSliderFillBg.Active = false
TemplateSliderFillBg.Interactable = false
TemplateSliderFillBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TemplateSliderFillBg.BackgroundTransparency = 1
TemplateSliderFillBg.BorderSizePixel = 0
TemplateSliderFillBg.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateSliderFillBg.Selectable = false
TemplateSliderFillBg.AnchorPoint = Vector2.new(0, 0.5)
TemplateSliderFillBg.Position = UDim2.new(0, 0, 0.5, 0)
TemplateSliderFillBg.Size = UDim2.new(1, 0, 1, 0)

local TemplateSliderFillBgCorner = Instance.new("UICorner", TemplateSliderFillBg)
TemplateSliderFillBgCorner.CornerRadius = UDim.new(0, 4)

local TemplateSliderFillGrad2 = Instance.new("UIGradient", TemplateSliderFillBg)
TemplateSliderFillGrad2.Enabled = false
TemplateSliderFillGrad2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}
local TemplateSliderFillGrad3 = Instance.new("UIGradient", TemplateSliderFillBg)
TemplateSliderFillGrad3.Enabled = false
TemplateSliderFillGrad3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}
local TemplateSliderFillGrad1 = Instance.new("UIGradient", TemplateSliderFillBg)
TemplateSliderFillGrad1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}

local TemplateSliderValue = Instance.new("TextLabel", TemplateSliderInner)
TemplateSliderValue.Name = "ValueText"
TemplateSliderValue.ZIndex = 2
TemplateSliderValue.BackgroundTransparency = 1
TemplateSliderValue.BorderSizePixel = 0
TemplateSliderValue.AnchorPoint = Vector2.new(0.5, 0.5)
TemplateSliderValue.Position = UDim2.new(0.5, 0, 0.5, 0)
TemplateSliderValue.Size = UDim2.new(1, -15, 1, 0)
TemplateSliderValue.RichText = true
TemplateSliderValue.Text = "0"
TemplateSliderValue.TextWrapped = true
TemplateSliderValue.TextXAlignment = Enum.TextXAlignment.Left
TemplateSliderValue.TextSize = 14
TemplateSliderValue.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateSliderValue.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

-- ====== Template: TextBox ======
local TemplateTextBox = Instance.new("Frame", Templates)
TemplateTextBox.Name = "TextBox"
TemplateTextBox.Visible = false
TemplateTextBox.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateTextBox.BorderSizePixel = 0
TemplateTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateTextBox.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
TemplateTextBox.Size = UDim2.new(1, 0, 0, 35)
TemplateTextBox.AutomaticSize = Enum.AutomaticSize.Y

local TemplateTextBoxCorner = Instance.new("UICorner", TemplateTextBox)
TemplateTextBoxCorner.CornerRadius = UDim.new(0, 6)

local TemplateTextBoxStroke = Instance.new("UIStroke", TemplateTextBox)
TemplateTextBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateTextBoxStroke.Thickness = 1.5
TemplateTextBoxStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateTextBoxTitle = Instance.new("TextLabel", TemplateTextBox)
TemplateTextBoxTitle.Name = "Title"
TemplateTextBoxTitle.Interactable = false
TemplateTextBoxTitle.BackgroundTransparency = 1
TemplateTextBoxTitle.BorderSizePixel = 0
TemplateTextBoxTitle.AutomaticSize = Enum.AutomaticSize.Y
TemplateTextBoxTitle.Size = UDim2.new(1, 0, 0, 15)
TemplateTextBoxTitle.Text = "Input Textbox"
TemplateTextBoxTitle.TextWrapped = true
TemplateTextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left
TemplateTextBoxTitle.TextSize = 16
TemplateTextBoxTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateTextBoxTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local TemplateTextBoxPadding = Instance.new("UIPadding", TemplateTextBox)
TemplateTextBoxPadding.PaddingTop    = UDim.new(0, 10)
TemplateTextBoxPadding.PaddingRight  = UDim.new(0, 10)
TemplateTextBoxPadding.PaddingLeft   = UDim.new(0, 10)
TemplateTextBoxPadding.PaddingBottom = UDim.new(0, 10)

local TemplateTextBoxList = Instance.new("UIListLayout", TemplateTextBox)
TemplateTextBoxList.Padding   = UDim.new(0, 10)
TemplateTextBoxList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateTextBoxDesc = Instance.new("TextLabel", TemplateTextBox)
TemplateTextBoxDesc.Name = "Description"
TemplateTextBoxDesc.Visible = false
TemplateTextBoxDesc.Interactable = false
TemplateTextBoxDesc.BackgroundTransparency = 1
TemplateTextBoxDesc.BorderSizePixel = 0
TemplateTextBoxDesc.AutomaticSize = Enum.AutomaticSize.Y
TemplateTextBoxDesc.Size = UDim2.new(1, 0, 0, 15)
TemplateTextBoxDesc.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
TemplateTextBoxDesc.TextWrapped = true
TemplateTextBoxDesc.TextXAlignment = Enum.TextXAlignment.Left
TemplateTextBoxDesc.TextSize = 16
TemplateTextBoxDesc.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateTextBoxDesc.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TemplateTextBoxDesc.LayoutOrder = 1

local TemplateTextBoxBoxFrame = Instance.new("Frame", TemplateTextBox)
TemplateTextBoxBoxFrame.Name = "BoxFrame"
TemplateTextBoxBoxFrame.ZIndex = 0
TemplateTextBoxBoxFrame.BackgroundTransparency = 1
TemplateTextBoxBoxFrame.BorderSizePixel = 0
TemplateTextBoxBoxFrame.AutomaticSize = Enum.AutomaticSize.Y
TemplateTextBoxBoxFrame.Size = UDim2.new(1, 0, 0, 25)
TemplateTextBoxBoxFrame.LayoutOrder = 2

local TemplateTextBoxShadow = Instance.new("ImageLabel", TemplateTextBoxBoxFrame)
TemplateTextBoxShadow.Name = "DropShadow"
TemplateTextBoxShadow.BackgroundTransparency = 1
TemplateTextBoxShadow.BorderSizePixel = 0
TemplateTextBoxShadow.Image = "rbxassetid://6014261993"
TemplateTextBoxShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
TemplateTextBoxShadow.ImageTransparency = 0.75
TemplateTextBoxShadow.ScaleType = Enum.ScaleType.Slice
TemplateTextBoxShadow.SliceCenter = Rect.new(49, 49, 450, 450)
TemplateTextBoxShadow.AnchorPoint = Vector2.new(0.5, 0.5)
TemplateTextBoxShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
TemplateTextBoxShadow.Size = UDim2.new(1, 35, 1, 30)
TemplateTextBoxShadow.ZIndex = 0

local TemplateTextBoxField = Instance.new("Frame", TemplateTextBoxBoxFrame)
TemplateTextBoxField.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateTextBoxField.BorderSizePixel = 0
TemplateTextBoxField.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateTextBoxField.Size = UDim2.new(1, 0, 0, 25)
TemplateTextBoxField.AutomaticSize = Enum.AutomaticSize.Y

local TemplateTextBoxFieldCorner = Instance.new("UICorner", TemplateTextBoxField)
TemplateTextBoxFieldCorner.CornerRadius = UDim.new(0, 5)

local TemplateTextBoxFieldStroke = Instance.new("UIStroke", TemplateTextBoxField)
TemplateTextBoxFieldStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateTextBoxFieldStroke.Thickness = 1.5
TemplateTextBoxFieldStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateTextBoxFieldList = Instance.new("UIListLayout", TemplateTextBoxField)
TemplateTextBoxFieldList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TemplateTextBoxFieldList.VerticalAlignment   = Enum.VerticalAlignment.Center
TemplateTextBoxFieldList.Padding   = UDim.new(0, 5)
TemplateTextBoxFieldList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateTextInput = Instance.new("TextBox", TemplateTextBoxField)
TemplateTextInput.Text = ""
TemplateTextInput.PlaceholderText   = "Input here..."
TemplateTextInput.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
TemplateTextInput.TextXAlignment = Enum.TextXAlignment.Left
TemplateTextInput.TextWrapped = true
TemplateTextInput.TextTruncate = Enum.TextTruncate.AtEnd
TemplateTextInput.TextSize = 14
TemplateTextInput.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateTextInput.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TemplateTextInput.BackgroundTransparency = 1
TemplateTextInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TemplateTextInput.BorderSizePixel = 0
TemplateTextInput.Size = UDim2.new(1, 0, 0, 25)
TemplateTextInput.AutomaticSize = Enum.AutomaticSize.Y
TemplateTextInput.ClipsDescendants = true

local TemplateTextInputPadding = Instance.new("UIPadding", TemplateTextInput)
TemplateTextInputPadding.PaddingTop    = UDim.new(0, 5)
TemplateTextInputPadding.PaddingRight  = UDim.new(0, 10)
TemplateTextInputPadding.PaddingLeft   = UDim.new(0, 10)
TemplateTextInputPadding.PaddingBottom = UDim.new(0, 5)

-- ====== Template: Dropdown ======
local TemplateDropdown = Instance.new("ImageButton", Templates)
TemplateDropdown.Name = "Dropdown"
TemplateDropdown.Visible = false
TemplateDropdown.AutoButtonColor = false
TemplateDropdown.Selectable = false
TemplateDropdown.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateDropdown.BorderSizePixel = 0
TemplateDropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateDropdown.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
TemplateDropdown.Size = UDim2.new(1, 0, 0, 35)
TemplateDropdown.AutomaticSize = Enum.AutomaticSize.Y

local TemplateDropdownCorner = Instance.new("UICorner", TemplateDropdown)
TemplateDropdownCorner.CornerRadius = UDim.new(0, 6)

local TemplateDropdownStroke = Instance.new("UIStroke", TemplateDropdown)
TemplateDropdownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateDropdownStroke.Thickness = 1.5
TemplateDropdownStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateDropdownTitle = Instance.new("TextLabel", TemplateDropdown)
TemplateDropdownTitle.Name = "Title"
TemplateDropdownTitle.BackgroundTransparency = 1
TemplateDropdownTitle.BorderSizePixel = 0
TemplateDropdownTitle.AnchorPoint = Vector2.new(0, 0)
TemplateDropdownTitle.Position = UDim2.new(0.03135, 0, 0, 0)
TemplateDropdownTitle.Size = UDim2.new(1, 0, 0, 15)
TemplateDropdownTitle.Text = "Dropdown"
TemplateDropdownTitle.TextWrapped = true
TemplateDropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
TemplateDropdownTitle.TextSize = 16
TemplateDropdownTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateDropdownTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

local TemplateDropdownClickIcon = Instance.new("ImageButton", TemplateDropdownTitle)
TemplateDropdownClickIcon.Name = "ClickIcon"
TemplateDropdownClickIcon.BackgroundTransparency = 1
TemplateDropdownClickIcon.BorderSizePixel = 0
TemplateDropdownClickIcon.AnchorPoint = Vector2.new(1, 0.5)
TemplateDropdownClickIcon.Position = UDim2.new(1, 0, 0.5, 0)
TemplateDropdownClickIcon.Size = UDim2.new(0, 23, 0, 23)
TemplateDropdownClickIcon.Image = "rbxassetid://77563793724007"
TemplateDropdownClickIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
TemplateDropdownClickIcon.AutoButtonColor = false

local TemplateDropdownBoxFrame = Instance.new("ImageButton", TemplateDropdownTitle)
TemplateDropdownBoxFrame.Name = "BoxFrame"
TemplateDropdownBoxFrame.Active = false
TemplateDropdownBoxFrame.Selectable = false
TemplateDropdownBoxFrame.BackgroundTransparency = 1
TemplateDropdownBoxFrame.BorderSizePixel = 0
TemplateDropdownBoxFrame.ZIndex = 0
TemplateDropdownBoxFrame.AnchorPoint = Vector2.new(1, 0.5)
TemplateDropdownBoxFrame.Position = UDim2.new(1, -33, 0.5, 0)
TemplateDropdownBoxFrame.AutomaticSize = Enum.AutomaticSize.X
TemplateDropdownBoxFrame.Size = UDim2.new(0, 20, 0, 20)

local TemplateDropdownDropShadow = Instance.new("ImageLabel", TemplateDropdownBoxFrame)
TemplateDropdownDropShadow.Name = "DropShadow"
TemplateDropdownDropShadow.Interactable = false
TemplateDropdownDropShadow.Visible = false
TemplateDropdownDropShadow.BackgroundTransparency = 1
TemplateDropdownDropShadow.BorderSizePixel = 0
TemplateDropdownDropShadow.Image = "rbxassetid://6014261993"
TemplateDropdownDropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
TemplateDropdownDropShadow.ImageTransparency = 0.75
TemplateDropdownDropShadow.ScaleType = Enum.ScaleType.Slice
TemplateDropdownDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
TemplateDropdownDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
TemplateDropdownDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
TemplateDropdownDropShadow.AutomaticSize = Enum.AutomaticSize.X
TemplateDropdownDropShadow.Size = UDim2.new(1, 28, 1, 28)
TemplateDropdownDropShadow.ZIndex = 0

local TemplateDropdownTrigger = Instance.new("ImageButton", TemplateDropdownBoxFrame)
TemplateDropdownTrigger.Name = "Trigger"
TemplateDropdownTrigger.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateDropdownTrigger.BorderSizePixel = 0
TemplateDropdownTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateDropdownTrigger.AnchorPoint = Vector2.new(0.5, 0.5)
TemplateDropdownTrigger.Position = UDim2.new(0.5, 0, 0.5, 0)
TemplateDropdownTrigger.AutomaticSize = Enum.AutomaticSize.X
TemplateDropdownTrigger.Size = UDim2.new(0, 20, 0, 20)
TemplateDropdownTrigger.AutoButtonColor = false

local TemplateDropdownTriggerCorner = Instance.new("UICorner", TemplateDropdownTrigger)
TemplateDropdownTriggerCorner.CornerRadius = UDim.new(0, 5)

local TemplateDropdownTriggerStroke = Instance.new("UIStroke", TemplateDropdownTrigger)
TemplateDropdownTriggerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateDropdownTriggerStroke.Thickness = 1.5
TemplateDropdownTriggerStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateDropdownTriggerList = Instance.new("UIListLayout", TemplateDropdownTrigger)
TemplateDropdownTriggerList.Padding = UDim.new(0, 5)
TemplateDropdownTriggerList.VerticalAlignment = Enum.VerticalAlignment.Center
TemplateDropdownTriggerList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateDropdownTriggerTitle = Instance.new("TextLabel", TemplateDropdownTrigger)
TemplateDropdownTriggerTitle.Name = "Title"
TemplateDropdownTriggerTitle.Interactable = false
TemplateDropdownTriggerTitle.BackgroundTransparency = 1
TemplateDropdownTriggerTitle.BorderSizePixel = 0
TemplateDropdownTriggerTitle.AnchorPoint = Vector2.new(0, 0.5)
TemplateDropdownTriggerTitle.Position = UDim2.new(-0.00345, 0, 0.5, 0)
TemplateDropdownTriggerTitle.Size = UDim2.new(0, 15, 0, 14)
TemplateDropdownTriggerTitle.Text = ""
TemplateDropdownTriggerTitle.AutomaticSize = Enum.AutomaticSize.X
TemplateDropdownTriggerTitle.TextWrapped = true
TemplateDropdownTriggerTitle.TextScaled = true
TemplateDropdownTriggerTitle.TextSize = 16
TemplateDropdownTriggerTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateDropdownTriggerTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local TemplateDropdownTriggerPadding = Instance.new("UIPadding", TemplateDropdownTrigger)
TemplateDropdownTriggerPadding.PaddingLeft  = UDim.new(0, 5)
TemplateDropdownTriggerPadding.PaddingRight = UDim.new(0, 5)

local TemplateDropdownPadding = Instance.new("UIPadding", TemplateDropdown)
TemplateDropdownPadding.PaddingTop    = UDim.new(0, 10)
TemplateDropdownPadding.PaddingRight  = UDim.new(0, 10)
TemplateDropdownPadding.PaddingLeft   = UDim.new(0, 10)
TemplateDropdownPadding.PaddingBottom = UDim.new(0, 10)

local TemplateDropdownList = Instance.new("UIListLayout", TemplateDropdown)
TemplateDropdownList.Padding   = UDim.new(0, 5)
TemplateDropdownList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateDropdownDesc = Instance.new("TextLabel", TemplateDropdown)
TemplateDropdownDesc.Name = "Description"
TemplateDropdownDesc.Visible = false
TemplateDropdownDesc.Interactable = false
TemplateDropdownDesc.BackgroundTransparency = 1
TemplateDropdownDesc.BorderSizePixel = 0
TemplateDropdownDesc.AutomaticSize = Enum.AutomaticSize.Y
TemplateDropdownDesc.Size = UDim2.new(1, 0, 0, 15)
TemplateDropdownDesc.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
TemplateDropdownDesc.TextWrapped = true
TemplateDropdownDesc.TextXAlignment = Enum.TextXAlignment.Left
TemplateDropdownDesc.TextSize = 16
TemplateDropdownDesc.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateDropdownDesc.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TemplateDropdownDesc.LayoutOrder = 1

-- Gradients (disabled) pada root Dropdown (sesuai OG)
local TemplateDropdownGrad1 = Instance.new("UIGradient", TemplateDropdown)
TemplateDropdownGrad1.Enabled = false
TemplateDropdownGrad1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}
local TemplateDropdownGrad2 = Instance.new("UIGradient", TemplateDropdown)
TemplateDropdownGrad2.Enabled = false
TemplateDropdownGrad2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}
local TemplateDropdownGrad3 = Instance.new("UIGradient", TemplateDropdown)
TemplateDropdownGrad3.Enabled = false
TemplateDropdownGrad3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}

-- ====== Templates: DropdownList (container + 2 list view) ======
local DropdownListFolder = Instance.new("Folder", Templates)
DropdownListFolder.Name = "DropdownList"

local DropdownItems = Instance.new("ScrollingFrame", DropdownListFolder)
DropdownItems.Name = "DropdownItems"
DropdownItems.Visible = false
DropdownItems.Active = true
DropdownItems.Selectable = false
DropdownItems.ScrollingDirection = Enum.ScrollingDirection.Y
DropdownItems.AutomaticCanvasSize = Enum.AutomaticSize.Y
DropdownItems.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownItems.ElasticBehavior = Enum.ElasticBehavior.Never
DropdownItems.TopImage    = "rbxasset://textures/ui/Scroll/scroll-middle.png"
DropdownItems.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
DropdownItems.Size = UDim2.new(1, 0, 1, -50)
DropdownItems.Position = UDim2.new(0, 0, 0, 50)
DropdownItems.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
DropdownItems.ScrollBarThickness   = 5
DropdownItems.BackgroundTransparency = 1
DropdownItems.BorderSizePixel = 0
DropdownItems.BorderColor3   = Color3.fromRGB(0, 0, 0)
DropdownItems.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local DropdownItemsList = Instance.new("UIListLayout", DropdownItems)
DropdownItemsList.Padding   = UDim.new(0, 15)
DropdownItemsList.SortOrder = Enum.SortOrder.LayoutOrder

local DropdownItemsPadding = Instance.new("UIPadding", DropdownItems)
DropdownItemsPadding.PaddingTop    = UDim.new(0, 2)
DropdownItemsPadding.PaddingRight  = UDim.new(0, 10)
DropdownItemsPadding.PaddingLeft   = UDim.new(0, 10)
DropdownItemsPadding.PaddingBottom = UDim.new(0, 10)

local DropdownItemsSearch = Instance.new("ScrollingFrame", DropdownListFolder)
DropdownItemsSearch.Name = "DropdownItemsSearch"
DropdownItemsSearch.Visible = false
DropdownItemsSearch.Active = true
DropdownItemsSearch.Selectable = false
DropdownItemsSearch.ScrollingDirection = Enum.ScrollingDirection.Y
DropdownItemsSearch.AutomaticCanvasSize = Enum.AutomaticSize.Y
DropdownItemsSearch.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownItemsSearch.ElasticBehavior = Enum.ElasticBehavior.Never
DropdownItemsSearch.TopImage    = "rbxasset://textures/ui/Scroll/scroll-middle.png"
DropdownItemsSearch.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
DropdownItemsSearch.Size = UDim2.new(1, 0, 1, -50)
DropdownItemsSearch.Position = UDim2.new(0, 0, 0, 50)
DropdownItemsSearch.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
DropdownItemsSearch.ScrollBarThickness   = 5
DropdownItemsSearch.BackgroundTransparency = 1
DropdownItemsSearch.BorderSizePixel = 0
DropdownItemsSearch.BorderColor3   = Color3.fromRGB(0, 0, 0)
DropdownItemsSearch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local DropdownItemsSearchList = Instance.new("UIListLayout", DropdownItemsSearch)
DropdownItemsSearchList.Padding   = UDim.new(0, 15)
DropdownItemsSearchList.SortOrder = Enum.SortOrder.LayoutOrder

local DropdownItemsSearchPadding = Instance.new("UIPadding", DropdownItemsSearch)
DropdownItemsSearchPadding.PaddingTop    = UDim.new(0, 2)
DropdownItemsSearchPadding.PaddingRight  = UDim.new(0, 10)
DropdownItemsSearchPadding.PaddingLeft   = UDim.new(0, 10)
DropdownItemsSearchPadding.PaddingBottom = UDim.new(0, 10)

--[[ =========================
BLOCK 004: L1501–L2000
(Template DropdownButton, Code block, Section, DialogElements & Dialog, Global NotificationList, FloatIcon)
========================= ]]

-- ====== Template: DropdownButton ======
local TemplateDropdownButton = Instance.new("ImageButton", Templates)
TemplateDropdownButton.Name = "DropdownButton"
TemplateDropdownButton.Visible = false
TemplateDropdownButton.AutoButtonColor = false
TemplateDropdownButton.Selectable = false
TemplateDropdownButton.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateDropdownButton.BorderSizePixel = 0
TemplateDropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateDropdownButton.Position = UDim2.new(0, 0, 0.384, 0)
TemplateDropdownButton.Size = UDim2.new(1, 0, 0, 35)
TemplateDropdownButton.AutomaticSize = Enum.AutomaticSize.Y

local TemplateDropdownButtonCorner = Instance.new("UICorner", TemplateDropdownButton)
TemplateDropdownButtonCorner.CornerRadius = UDim.new(0, 6)

local TemplateDropdownButtonBody = Instance.new("Frame", TemplateDropdownButton)
TemplateDropdownButtonBody.BackgroundTransparency = 1
TemplateDropdownButtonBody.BorderSizePixel = 0
TemplateDropdownButtonBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateDropdownButtonBody.Size = UDim2.new(1, 0, 0, 35)
TemplateDropdownButtonBody.AutomaticSize = Enum.AutomaticSize.Y

local TemplateDropdownButtonList = Instance.new("UIListLayout", TemplateDropdownButtonBody)
TemplateDropdownButtonList.Padding = UDim.new(0, 5)
TemplateDropdownButtonList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateDropdownButtonPadding = Instance.new("UIPadding", TemplateDropdownButtonBody)
TemplateDropdownButtonPadding.PaddingTop    = UDim.new(0, 10)
TemplateDropdownButtonPadding.PaddingRight  = UDim.new(0, 10)
TemplateDropdownButtonPadding.PaddingLeft   = UDim.new(0, 10)
TemplateDropdownButtonPadding.PaddingBottom = UDim.new(0, 10)

local TemplateDropdownButtonTitle = Instance.new("TextLabel", TemplateDropdownButtonBody)
TemplateDropdownButtonTitle.Name = "Title"
TemplateDropdownButtonTitle.Interactable = false
TemplateDropdownButtonTitle.BackgroundTransparency = 1
TemplateDropdownButtonTitle.BorderSizePixel = 0
TemplateDropdownButtonTitle.Size = UDim2.new(1, 0, 0, 15)
TemplateDropdownButtonTitle.Text = "Button"
TemplateDropdownButtonTitle.TextWrapped = true
TemplateDropdownButtonTitle.TextSize = 16
TemplateDropdownButtonTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateDropdownButtonTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

local TemplateDropdownButtonDesc = Instance.new("TextLabel", TemplateDropdownButtonBody)
TemplateDropdownButtonDesc.Name = "Description"
TemplateDropdownButtonDesc.LayoutOrder = 1
TemplateDropdownButtonDesc.Visible = false
TemplateDropdownButtonDesc.Interactable = false
TemplateDropdownButtonDesc.BackgroundTransparency = 1
TemplateDropdownButtonDesc.BorderSizePixel = 0
TemplateDropdownButtonDesc.AutomaticSize = Enum.AutomaticSize.Y
TemplateDropdownButtonDesc.Size = UDim2.new(1, 0, 0, 15)
TemplateDropdownButtonDesc.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
TemplateDropdownButtonDesc.TextWrapped = true
TemplateDropdownButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
TemplateDropdownButtonDesc.TextSize = 16
TemplateDropdownButtonDesc.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateDropdownButtonDesc.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

-- 3 gradien (disabled by default sesuai OG)
local TemplateDropdownButtonGrad1 = Instance.new("UIGradient", TemplateDropdownButtonBody)
TemplateDropdownButtonGrad1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}
local TemplateDropdownButtonGrad2 = Instance.new("UIGradient", TemplateDropdownButtonBody)
TemplateDropdownButtonGrad2.Enabled = false
TemplateDropdownButtonGrad2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}
local TemplateDropdownButtonGrad3 = Instance.new("UIGradient", TemplateDropdownButtonBody)
TemplateDropdownButtonGrad3.Enabled = false
TemplateDropdownButtonGrad3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}

local TemplateDropdownButtonBodyCorner = Instance.new("UICorner", TemplateDropdownButtonBody)
TemplateDropdownButtonBodyCorner.CornerRadius = UDim.new(0, 6)

local TemplateDropdownButtonStroke = Instance.new("UIStroke", TemplateDropdownButton)
TemplateDropdownButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateDropdownButtonStroke.Thickness = 1.5
TemplateDropdownButtonStroke.Color = Color3.fromRGB(61, 61, 75)

-- ====== Template: Code (read-only code block) ======
local TemplateCode = Instance.new("Frame", Templates)
TemplateCode.Name = "Code"
TemplateCode.Visible = false
TemplateCode.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateCode.BorderSizePixel = 0
TemplateCode.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateCode.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
TemplateCode.Size = UDim2.new(1, 0, 0, 35)
TemplateCode.AutomaticSize = Enum.AutomaticSize.Y

local TemplateCodeCorner = Instance.new("UICorner", TemplateCode)
TemplateCodeCorner.CornerRadius = UDim.new(0, 6)

local TemplateCodeStroke = Instance.new("UIStroke", TemplateCode)
TemplateCodeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateCodeStroke.Thickness = 1.5
TemplateCodeStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateCodeTitle = Instance.new("TextLabel", TemplateCode)
TemplateCodeTitle.Name = "Title"
TemplateCodeTitle.Interactable = false
TemplateCodeTitle.BackgroundTransparency = 1
TemplateCodeTitle.BorderSizePixel = 0
TemplateCodeTitle.AutomaticSize = Enum.AutomaticSize.Y
TemplateCodeTitle.Size = UDim2.new(1, 0, 0, 15)
TemplateCodeTitle.Text = "Title"
TemplateCodeTitle.TextWrapped = true
TemplateCodeTitle.TextXAlignment = Enum.TextXAlignment.Left
TemplateCodeTitle.TextSize = 16
TemplateCodeTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateCodeTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local TemplateCodePadding = Instance.new("UIPadding", TemplateCode)
TemplateCodePadding.PaddingTop    = UDim.new(0, 10)
TemplateCodePadding.PaddingRight  = UDim.new(0, 10)
TemplateCodePadding.PaddingLeft   = UDim.new(0, 10)
TemplateCodePadding.PaddingBottom = UDim.new(0, 10)

local TemplateCodeList = Instance.new("UIListLayout", TemplateCode)
TemplateCodeList.Padding   = UDim.new(0, 5)
TemplateCodeList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateCodeBox = Instance.new("TextBox", TemplateCode)
TemplateCodeBox.Name = "Code"
TemplateCodeBox.Text = 'print("Hello World!")'
TemplateCodeBox.ClearTextOnFocus = false
TemplateCodeBox.MultiLine = true
TemplateCodeBox.Selectable = false
TemplateCodeBox.TextEditable = false
TemplateCodeBox.TextWrapped = true
TemplateCodeBox.TextXAlignment = Enum.TextXAlignment.Left
TemplateCodeBox.TextSize = 16
TemplateCodeBox.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateCodeBox.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TemplateCodeBox.BackgroundTransparency = 1
TemplateCodeBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TemplateCodeBox.BorderSizePixel = 0
TemplateCodeBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateCodeBox.Size = UDim2.new(1, 0, 0, 15)
TemplateCodeBox.AutomaticSize = Enum.AutomaticSize.Y
TemplateCodeBox.LayoutOrder = 1

-- ====== Template: Section (collapsible) ======
local TemplateSectionRoot = Instance.new("Frame", Templates)
TemplateSectionRoot.Name = "Section"
TemplateSectionRoot.Visible = false
TemplateSectionRoot.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateSectionRoot.BackgroundTransparency = 1
TemplateSectionRoot.BorderSizePixel = 0
TemplateSectionRoot.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateSectionRoot.Position = UDim2.new(0, 0, 0.43728, 0)
TemplateSectionRoot.Size = UDim2.new(1, 0, 0, 35)
TemplateSectionRoot.AutomaticSize = Enum.AutomaticSize.Y

local TemplateSectionButton = Instance.new("ImageButton", TemplateSectionRoot)
TemplateSectionButton.Name = "Button"
TemplateSectionButton.AutoButtonColor = false
TemplateSectionButton.Selectable = false
TemplateSectionButton.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
TemplateSectionButton.BorderSizePixel = 0
TemplateSectionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateSectionButton.Size = UDim2.new(1, 0, 0, 35)
TemplateSectionButton.AutomaticSize = Enum.AutomaticSize.Y

local TemplateSectionCorner = Instance.new("UICorner", TemplateSectionButton)
TemplateSectionCorner.CornerRadius = UDim.new(0, 6)

local TemplateSectionStroke = Instance.new("UIStroke", TemplateSectionButton)
TemplateSectionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TemplateSectionStroke.Thickness = 1.5
TemplateSectionStroke.Color = Color3.fromRGB(61, 61, 75)

local TemplateSectionTitle = Instance.new("TextLabel", TemplateSectionButton)
TemplateSectionTitle.Name = "Title"
TemplateSectionTitle.Interactable = false
TemplateSectionTitle.BackgroundTransparency = 1
TemplateSectionTitle.BorderSizePixel = 0
TemplateSectionTitle.Size = UDim2.new(1, 0, 0, 15)
TemplateSectionTitle.Text = "Section"
TemplateSectionTitle.TextWrapped = true
TemplateSectionTitle.TextXAlignment = Enum.TextXAlignment.Left
TemplateSectionTitle.TextSize = 16
TemplateSectionTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateSectionTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

local TemplateSectionArrow = Instance.new("ImageButton", TemplateSectionTitle)
TemplateSectionArrow.Name = "Arrow"
TemplateSectionArrow.BackgroundTransparency = 1
TemplateSectionArrow.BorderSizePixel = 0
TemplateSectionArrow.AnchorPoint = Vector2.new(1, 0.5)
TemplateSectionArrow.Position = UDim2.new(1, 0, 0.5, 0)
TemplateSectionArrow.Size = UDim2.new(0, 23, 0, 23)
TemplateSectionArrow.Image = "rbxassetid://120292618616139"
TemplateSectionArrow.ImageColor3 = Color3.fromRGB(197, 204, 219)
TemplateSectionArrow.AutoButtonColor = false

local TemplateSectionPadding = Instance.new("UIPadding", TemplateSectionButton)
TemplateSectionPadding.PaddingTop    = UDim.new(0, 10)
TemplateSectionPadding.PaddingRight  = UDim.new(0, 10)
TemplateSectionPadding.PaddingLeft   = UDim.new(0, 10)
TemplateSectionPadding.PaddingBottom = UDim.new(0, 10)

local TemplateSectionList = Instance.new("UIListLayout", TemplateSectionButton)
TemplateSectionList.Padding   = UDim.new(0, 5)
TemplateSectionList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateSectionDesc = Instance.new("TextLabel", TemplateSectionButton)
TemplateSectionDesc.Name = "Description"
TemplateSectionDesc.Visible = false
TemplateSectionDesc.LayoutOrder = 1
TemplateSectionDesc.Interactable = false
TemplateSectionDesc.BackgroundTransparency = 1
TemplateSectionDesc.BorderSizePixel = 0
TemplateSectionDesc.AutomaticSize = Enum.AutomaticSize.Y
TemplateSectionDesc.Size = UDim2.new(1, 0, 0, 15)
TemplateSectionDesc.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
TemplateSectionDesc.TextWrapped = true
TemplateSectionDesc.TextXAlignment = Enum.TextXAlignment.Left
TemplateSectionDesc.TextSize = 16
TemplateSectionDesc.TextColor3 = Color3.fromRGB(197, 204, 219)
TemplateSectionDesc.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

-- (3 gradien disabled di root button, plus stroke border — sudah diset di OG)
local TemplateSectionGrad1 = Instance.new("UIGradient", TemplateSectionButton)
TemplateSectionGrad1.Enabled = false
TemplateSectionGrad1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}
local TemplateSectionGrad2 = Instance.new("UIGradient", TemplateSectionButton)
TemplateSectionGrad2.Enabled = false
TemplateSectionGrad2.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(1, 1),
}
TemplateSectionGrad2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}
local TemplateSectionGrad3 = Instance.new("UIGradient", TemplateSectionButton)
TemplateSectionGrad3.Enabled = false
TemplateSectionGrad3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,     Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16,  Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32,  Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54,  Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1,     Color3.fromRGB(0, 158, 255)),
}

-- Container di bawah Section header (divider dsb)
local TemplateSectionInner = Instance.new("Frame", TemplateSectionRoot)
TemplateSectionInner.Visible = false
TemplateSectionInner.BackgroundTransparency = 1
TemplateSectionInner.BackgroundColor3 = Color3.fromRGB(207, 222, 255)
TemplateSectionInner.BorderSizePixel = 0
TemplateSectionInner.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateSectionInner.Position = UDim2.new(0, 0, 0, 35)
TemplateSectionInner.Size = UDim2.new(1, 0, 0, 30)
TemplateSectionInner.AutomaticSize = Enum.AutomaticSize.Y

local TemplateSectionInnerList = Instance.new("UIListLayout", TemplateSectionInner)
TemplateSectionInnerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TemplateSectionInnerList.Padding   = UDim.new(0, 10)
TemplateSectionInnerList.SortOrder = Enum.SortOrder.LayoutOrder

local TemplateSectionInnerPadding = Instance.new("UIPadding", TemplateSectionInner)
TemplateSectionInnerPadding.PaddingTop   = UDim.new(0, 10)
TemplateSectionInnerPadding.PaddingRight = UDim.new(0, 8)
TemplateSectionInnerPadding.PaddingLeft  = UDim.new(0, 8)

local TemplateSectionDivider = Instance.new("Frame", TemplateSectionInner)
TemplateSectionDivider.Name = "Divider"
TemplateSectionDivider.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
TemplateSectionDivider.BorderSizePixel  = 0
TemplateSectionDivider.BorderColor3     = Color3.fromRGB(61, 61, 75)
TemplateSectionDivider.Size = UDim2.new(1, 0, 0, 3)

-- ====== Templates: DialogElements ======
local DialogElements = Instance.new("Folder", Templates)
DialogElements.Name = "DialogElements"

-- Overlay
local DialogOverlay = Instance.new("Frame", DialogElements)
DialogOverlay.Name = "DarkOverlayDialog"
DialogOverlay.Visible = false
DialogOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DialogOverlay.BackgroundTransparency = 0.6
DialogOverlay.BorderSizePixel = 0
DialogOverlay.BorderColor3 = Color3.fromRGB(0, 0, 0)
DialogOverlay.Size = UDim2.new(1, 0, 1, 0)

local DialogOverlayCorner = Instance.new("UICorner", DialogOverlay)
DialogOverlayCorner.CornerRadius = UDim.new(0, 10)

-- Dialog root
local DialogRoot = Instance.new("Frame", DialogElements)
DialogRoot.Name = "Dialog"
DialogRoot.Visible = false
DialogRoot.ZIndex = 4
DialogRoot.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
DialogRoot.BorderSizePixel = 0
DialogRoot.BorderColor3     = Color3.fromRGB(61, 61, 75)
DialogRoot.AnchorPoint = Vector2.new(0.5, 0.5)
DialogRoot.Position   = UDim2.new(0.5, 0, 0.5, 0)
DialogRoot.Size       = UDim2.new(0, 250, 0, 0)
DialogRoot.ClipsDescendants = true
DialogRoot.AutomaticSize    = Enum.AutomaticSize.Y

local DialogCorner = Instance.new("UICorner", DialogRoot)
DialogCorner.CornerRadius = UDim.new(0, 6)

local DialogStroke = Instance.new("UIStroke", DialogRoot)
DialogStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DialogStroke.Thickness = 1.5
DialogStroke.Color = Color3.fromRGB(61, 61, 75)

-- Title bar
local DialogTitleBar = Instance.new("Frame", DialogRoot)
DialogTitleBar.Name = "Title"
DialogTitleBar.BackgroundTransparency = 1
DialogTitleBar.BorderSizePixel = 0
DialogTitleBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
DialogTitleBar.Size = UDim2.new(1, 0, 0, 25)
DialogTitleBar.AutomaticSize = Enum.AutomaticSize.Y

local DialogTitleText = Instance.new("TextLabel", DialogTitleBar)
DialogTitleText.Interactable = false
DialogTitleText.BackgroundTransparency = 1
DialogTitleText.BorderSizePixel = 0
DialogTitleText.AnchorPoint = Vector2.new(0, 0.5)
DialogTitleText.Position = UDim2.new(-0.05455, 12, 0.5, 0)
DialogTitleText.Size = UDim2.new(0, 0, 0, 20)
DialogTitleText.AutomaticSize = Enum.AutomaticSize.XY
DialogTitleText.Text = ""
DialogTitleText.TextSize = 20
DialogTitleText.TextXAlignment = Enum.TextXAlignment.Left
DialogTitleText.TextColor3 = Color3.fromRGB(197, 204, 219)
DialogTitleText.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
DialogTitleText.ZIndex = 0

local DialogTitleList = Instance.new("UIListLayout", DialogTitleBar)
DialogTitleList.FillDirection = Enum.FillDirection.Horizontal
DialogTitleList.VerticalAlignment = Enum.VerticalAlignment.Center
DialogTitleList.Padding   = UDim.new(0, 10)
DialogTitleList.SortOrder = Enum.SortOrder.LayoutOrder

local DialogTitlePadding = Instance.new("UIPadding", DialogTitleBar)
DialogTitlePadding.PaddingTop    = UDim.new(0, 5)
DialogTitlePadding.PaddingRight  = UDim.new(0, 15)
DialogTitlePadding.PaddingLeft   = UDim.new(0, 15)
DialogTitlePadding.PaddingBottom = UDim.new(0, 5)

local DialogTitleIcon = Instance.new("ImageButton", DialogTitleBar)
DialogTitleIcon.Name = "Icon"
DialogTitleIcon.Visible = false
DialogTitleIcon.BackgroundTransparency = 1
DialogTitleIcon.BorderSizePixel = 0
DialogTitleIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
DialogTitleIcon.Size = UDim2.new(0, 33, 0, 25)
local DialogTitleIconAspect = Instance.new("UIAspectRatioConstraint", DialogTitleIcon)

-- Dialog stacking
local DialogStack = Instance.new("UIListLayout", DialogRoot)
DialogStack.HorizontalAlignment = Enum.HorizontalAlignment.Center
DialogStack.SortOrder = Enum.SortOrder.LayoutOrder

-- Content
local DialogContent = Instance.new("Frame", DialogRoot)
DialogContent.Name = "Content"
DialogContent.Visible = false
DialogContent.ZIndex = 2
DialogContent.BackgroundTransparency = 1
DialogContent.BorderSizePixel = 0
DialogContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
DialogContent.Size = UDim2.new(1, 0, 0, 0)
DialogContent.Position = UDim2.new(0, 0, 0.21886, 0)
DialogContent.AutomaticSize = Enum.AutomaticSize.Y

local DialogContentList = Instance.new("UIListLayout", DialogContent)
DialogContentList.VerticalAlignment = Enum.VerticalAlignment.Center
DialogContentList.SortOrder = Enum.SortOrder.LayoutOrder

local DialogContentPadding = Instance.new("UIPadding", DialogContent)
DialogContentPadding.PaddingTop    = UDim.new(0, 5)
DialogContentPadding.PaddingRight  = UDim.new(0, 15)
DialogContentPadding.PaddingLeft   = UDim.new(0, 15)
DialogContentPadding.PaddingBottom = UDim.new(0, 5)

local DialogContentText = Instance.new("TextLabel", DialogContent)
DialogContentText.Interactable = false
DialogContentText.BackgroundTransparency = 1
DialogContentText.BorderSizePixel = 0
DialogContentText.Position = UDim2.new(0, 0, 0.125, 0)
DialogContentText.Size = UDim2.new(1, 0, 0, 0)
DialogContentText.AutomaticSize = Enum.AutomaticSize.Y
DialogContentText.Text = ""
DialogContentText.TextWrapped = true
DialogContentText.TextYAlignment = Enum.TextYAlignment.Top
DialogContentText.TextXAlignment = Enum.TextXAlignment.Left
DialogContentText.TextSize = 15
DialogContentText.TextColor3 = Color3.fromRGB(145, 154, 173)
DialogContentText.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

-- Root padding
local DialogRootPadding = Instance.new("UIPadding", DialogRoot)
DialogRootPadding.PaddingTop    = UDim.new(0, 10)
DialogRootPadding.PaddingBottom = UDim.new(0, 10)

-- Buttons area
local DialogButtons = Instance.new("Frame", DialogRoot)
DialogButtons.Name = "Buttons"
DialogButtons.ZIndex = 3
DialogButtons.BackgroundTransparency = 1
DialogButtons.BorderSizePixel = 0
DialogButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
DialogButtons.Size = UDim2.new(1, 0, 0, 0)
DialogButtons.Position = UDim2.new(0, 0, 0.53017, 0)
DialogButtons.AutomaticSize = Enum.AutomaticSize.Y

local DialogButtonsList = Instance.new("UIListLayout", DialogButtons)
DialogButtonsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
DialogButtonsList.Padding   = UDim.new(0, 10)
DialogButtonsList.SortOrder = Enum.SortOrder.LayoutOrder

local DialogButtonsPadding = Instance.new("UIPadding", DialogButtons)
DialogButtonsPadding.PaddingTop   = UDim.new(0, 5)
DialogButtonsPadding.PaddingRight = UDim.new(0, 10)
DialogButtonsPadding.PaddingLeft  = UDim.new(0, 10)

-- Button template di dialog
local DialogButtonTemplate = Instance.new("Frame", DialogElements)
DialogButtonTemplate.Name = "DialogButton"
DialogButtonTemplate.Visible = false
DialogButtonTemplate.BackgroundTransparency = 1
DialogButtonTemplate.BorderSizePixel = 0
DialogButtonTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
DialogButtonTemplate.AnchorPoint = Vector2.new(0.5, 1)
DialogButtonTemplate.Position = UDim2.new(0.5, 0, 0.327, 0)
DialogButtonTemplate.Size = UDim2.new(1, 0, 0, 30)

local DialogButton = Instance.new("TextButton", DialogButtonTemplate)
DialogButton.Name = "Button"
DialogButton.AutoButtonColor = false
DialogButton.Selectable = false
DialogButton.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
DialogButton.BorderSizePixel = 0
DialogButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
DialogButton.AnchorPoint = Vector2.new(0.5, 0.5)
DialogButton.Position = UDim2.new(0.5, 0, 0.5, 0)
DialogButton.Size = UDim2.new(1, 0, 1, 0)

local DialogButtonCorner = Instance.new("UICorner", DialogButton)
DialogButtonCorner.CornerRadius = UDim.new(0, 5)

local DialogButtonStroke = Instance.new("UIStroke", DialogButton)
DialogButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DialogButtonStroke.Thickness = 1.5
DialogButtonStroke.Color = Color3.fromRGB(61, 61, 75)

local DialogButtonList = Instance.new("UIListLayout", DialogButton)
DialogButtonList.HorizontalAlignment = Enum.HorizontalAlignment.Center
DialogButtonList.VerticalAlignment   = Enum.VerticalAlignment.Center
DialogButtonList.Padding   = UDim.new(0, 5)
DialogButtonList.SortOrder = Enum.SortOrder.LayoutOrder

local DialogButtonLabel = Instance.new("TextLabel", DialogButton)
DialogButtonLabel.Name = "Label"
DialogButtonLabel.Interactable = false
DialogButtonLabel.BackgroundTransparency = 1
DialogButtonLabel.BorderSizePixel = 0
DialogButtonLabel.Size = UDim2.new(1, 0, 0.45, 0)
DialogButtonLabel.Position = UDim2.new(0, 45, 0.083, 0)
DialogButtonLabel.Text = ""
DialogButtonLabel.TextWrapped = true
DialogButtonLabel.TextScaled = true
DialogButtonLabel.TextSize = 14
DialogButtonLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
DialogButtonLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

-- ====== Global: NotificationList (top-right stack) ======
local GlobalNotificationList = Instance.new("Frame", Gui.ScreenGui)
GlobalNotificationList.Name = "NotificationList"
GlobalNotificationList.ZIndex = 10
GlobalNotificationList.BackgroundTransparency = 1
GlobalNotificationList.BorderSizePixel = 0
GlobalNotificationList.BorderColor3 = Color3.fromRGB(0, 0, 0)
GlobalNotificationList.AnchorPoint = Vector2.new(0.5, 0)
GlobalNotificationList.Position   = UDim2.new(1, 0, 0, 0)
GlobalNotificationList.Size       = UDim2.new(0, 630, 1, 0)

local GlobalNotificationListLayout = Instance.new("UIListLayout", GlobalNotificationList)
GlobalNotificationListLayout.Padding   = UDim.new(0, 12)
GlobalNotificationListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local GlobalNotificationListPadding = Instance.new("UIPadding", GlobalNotificationList)
GlobalNotificationListPadding.PaddingTop   = UDim.new(0, 10)
GlobalNotificationListPadding.PaddingRight = UDim.new(0, 40)
GlobalNotificationListPadding.PaddingLeft  = UDim.new(0, 40)

-- ====== FloatIcon (small floating button) ======
local FloatIcon = Instance.new("Frame", Gui.ScreenGui)
FloatIcon.Name = "FloatIcon"
FloatIcon.Visible = false
FloatIcon.ZIndex = 0
FloatIcon.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
FloatIcon.BorderSizePixel = 2
FloatIcon.BorderColor3 = Color3.fromRGB(61, 61, 75)
FloatIcon.ClipsDescendants = true
FloatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
FloatIcon.Position   = UDim2.new(0.5, 0, 0, 45)
FloatIcon.Size       = UDim2.new(0, 85, 0, 45)
FloatIcon.AutomaticSize = Enum.AutomaticSize.X

local FloatIconCorner = Instance.new("UICorner", FloatIcon)
FloatIconCorner.CornerRadius = UDim.new(0, 10)

local FloatIconStroke = Instance.new("UIStroke", FloatIcon)
FloatIconStroke.Transparency = 0.5
FloatIconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
FloatIconStroke.Thickness = 1.5
FloatIconStroke.Color = Color3.fromRGB(95, 95, 117)

local FloatIconPadding = Instance.new("UIPadding", FloatIcon)
FloatIconPadding.PaddingTop = UDim.new(0, 8)
--[[ =========================
BLOCK 005: L2001–L2500
(FloatIcon content, smart require/registry, Library module body: CreateWindow, Tab, Section, Button (parsial sampai MouseButton1Up))
========================= ]]

-- ====== FloatIcon (lanjutan konten & children) ======
FloatIconPadding.PaddingRight  = UDim.new(0, 10)
FloatIconPadding.PaddingLeft   = UDim.new(0, 10)
FloatIconPadding.PaddingBottom = UDim.new(0, 8)

local FloatIconList = Instance.new("UIListLayout", FloatIcon)
FloatIconList.Padding            = UDim.new(0, 8)
FloatIconList.VerticalAlignment  = Enum.VerticalAlignment.Center
FloatIconList.SortOrder          = Enum.SortOrder.LayoutOrder
FloatIconList.FillDirection      = Enum.FillDirection.Horizontal

local FloatIconImage = Instance.new("ImageButton", FloatIcon)
FloatIconImage.Name = "Icon"
FloatIconImage.Active = false
FloatIconImage.Interactable = false
FloatIconImage.AutoButtonColor = false
FloatIconImage.BackgroundTransparency = 1
FloatIconImage.BorderSizePixel = 0
FloatIconImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
FloatIconImage.AnchorPoint = Vector2.new(0, 0.5)
FloatIconImage.Position = UDim2.new(0, 10, 0.5, 0)
FloatIconImage.Size = UDim2.new(1, 0, 1, 0)
FloatIconImage.Image = "rbxassetid://113216930555884"
local FloatIconImageAspect = Instance.new("UIAspectRatioConstraint", FloatIconImage)

local FloatIconLabel = Instance.new("TextLabel", FloatIcon)
FloatIconLabel.Interactable = false
FloatIconLabel.BackgroundTransparency = 1
FloatIconLabel.BorderSizePixel = 0
FloatIconLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
FloatIconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
FloatIconLabel.Position = UDim2.new(0.38615, 0, 0.53448, -1)
FloatIconLabel.Size = UDim2.new(0, 20, 0, 20)
FloatIconLabel.AutomaticSize = Enum.AutomaticSize.X
FloatIconLabel.Text = "NatHub"
FloatIconLabel.TextSize = 16
FloatIconLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
FloatIconLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

local FloatIconOpen = Instance.new("ImageButton", FloatIcon)
FloatIconOpen.Name = "Open"
FloatIconOpen.AutoButtonColor = false
FloatIconOpen.Selectable = false
FloatIconOpen.BackgroundTransparency = 1
FloatIconOpen.BorderSizePixel = 0
FloatIconOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
FloatIconOpen.AnchorPoint = Vector2.new(0, 0.5)
FloatIconOpen.Position = UDim2.new(0, 128, 0.5, 0)
FloatIconOpen.Size = UDim2.new(0, 20, 0, 20)
FloatIconOpen.Image = "rbxassetid://122219713887461"
FloatIconOpen.ImageColor3 = Color3.fromRGB(197, 204, 219)
local FloatIconOpenAspect = Instance.new("UIAspectRatioConstraint", FloatIconOpen)
local FloatIconOpenCorner = Instance.new("UICorner", FloatIconOpen)

-- ====== Smart require shim (agar bisa inject registry lokal) ======
local rawRequire = require
local Registry   = {}

local function smartRequire(mod)
    local rec = Registry[mod]
    if rec then
        if not rec.Required then
            rec.Required = true
            rec.Value = rec.Closure()
        end
        return rec.Value
    end
    return rawRequire(mod)
end

-- ====== Register: Library (module utama) ======
Registry[LibraryModule] = {
    Closure = function()
        local Exports = {}

        -- refs & singletons
        local IconAPI             = smartRequire(LibraryModule.IconModule)   -- Obsidian-style: IconAPI.Icon(name) -> {image, meta}
        local UIS                 = game:GetService("UserInputService")
        local Root                = LibraryModule.Parent
        local TemplatesFolder     = Templates
        local WindowTemplate      = Window
        local FloatIconTemplate   = FloatIcon

        -- jadikan template (copot dari parent tampilan)
        TemplatesFolder.Parent   = nil
        WindowTemplate.Parent    = nil
        FloatIconTemplate.Parent = nil

        -- anim & util
        local Anim = {
            Global = { Duration = 0.25, EasingStyle = Enum.EasingStyle.Quart, EasingDirection = Enum.EasingDirection.Out },
            Notification = { Duration = 0.5, EasingStyle = Enum.EasingStyle.Back, EasingDirection = Enum.EasingDirection.Out },
            PopupOpen = { Duration = 0.4, EasingStyle = Enum.EasingStyle.Back, EasingDirection = Enum.EasingDirection.Out },
            PopupClose = { Duration = 0.4, EasingStyle = Enum.EasingStyle.Back, EasingDirection = Enum.EasingDirection.In },
        }

        local function tween(instance, goal, spec)
            local info = TweenInfo.new(spec.Duration, spec.EasingStyle or Enum.EasingStyle.Linear, spec.EasingDirection or Enum.EasingDirection.Out)
            local tw   = game:GetService("TweenService"):Create(instance, info, goal)
            tw:Play()
            return tw
        end

        local function makeDraggable(handle, target)
            local api = {}
            local TS  = game:GetService("TweenService")
            local enabled = true
            local startPos, startUDim, current

            local function drag(deltaInput)
                local delta = deltaInput.Position - startPos
                local newUDim = UDim2.new(startUDim.X.Scale, startUDim.X.Offset + delta.X, startUDim.Y.Scale, startUDim.Y.Offset + delta.Y)
                TS:Create(target, TweenInfo.new(0.2, Enum.EasingStyle.Quart), { Position = newUDim }):Play()
            end

            handle.InputBegan:Connect(function(input)
                if enabled and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    startPos = input.Position
                    startUDim = target.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            current = nil
                        end
                    end)
                end
            end)

            handle.InputChanged:Connect(function(input)
                if enabled and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    current = input
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if enabled and input == current and startPos then
                    drag(input)
                end
            end)

            function api.SetAllowDragging(_, value)
                enabled = value
            end

            return api
        end

        -- windows stack
        local OpenWindows = {}

        -- ========== API: CreateWindow ==========
        function Exports.CreateWindow(_, opts)
            local cfg = {
                Title = opts.Title,
                Icon = opts.Icon,
                Version = opts.Author,
                Folder = opts.Folder,
                Size = opts.Size,
                ToggleKey = opts.ToggleKey or Enum.KeyCode.RightShift,
                LiveSearchDropdown = opts.LiveSearchDropdown or false,
            }

            -- container khusus window ini
            local mount = Instance.new("Folder")
            mount.Parent = Root
            Root.Name    = cfg.Title

            -- clone FloatIcon
            local floatBtn = FloatIconTemplate:Clone()
            floatBtn.Parent = mount
            floatBtn.TextLabel.Text = cfg.Title
            floatBtn.Visible = false
            -- set icon
            if not tostring(cfg.Icon):find("rbxassetid") then
                local asset, meta = IconAPI.Icon(cfg.Icon)
                floatBtn.Icon.Image = asset or cfg.Icon or ""
                floatBtn.Icon.ImageRectOffset = (meta and meta.ImageRectPosition) or Vector2.new(0, 0)
                floatBtn.Icon.ImageRectSize   = (meta and meta.ImageRectSize) or Vector2.new(0, 0)
            else
                floatBtn.Icon.Image = cfg.Icon
            end

            -- clone window
            local win = WindowTemplate:Clone()
            local WinGui = win
            local Top = WinGui.TopFrame
            local TabsSide = WinGui.TabButtons
            local TabsArea = WinGui.Tabs

            win.Name = cfg.Title
            Top.TextLabel.Text = (cfg.Title or "") .. " - " .. (cfg.Version or "")
            if not tostring(cfg.Icon):find("rbxassetid") then
                local asset, meta = IconAPI.Icon(cfg.Icon)
                Top.Icon.Image = asset or cfg.Icon or ""
                Top.Icon.ImageRectOffset = (meta and meta.ImageRectPosition) or Vector2.new(0, 0)
                Top.Icon.ImageRectSize   = (meta and meta.ImageRectSize) or Vector2.new(0, 0)
            else
                Top.Icon.Image = cfg.Icon
            end

            win.Size = cfg.Size
            win.Visible = false
            win.Parent  = mount
            table.insert(OpenWindows, win)

            -- tab registry
            local TabsByName, TabsOrder = {}, {}
            local ActiveTabName
            local dropdownOpen = false
            local dropdownCurrent

            local function registerTab(name, tabObject, tabButton, hasIcon)
                local rec = { Name = name, TabObject = tabObject, TabButton = tabButton, HasIcon = hasIcon }
                TabsByName[name] = rec
                table.insert(TabsOrder, rec)
            end

            local function setDropdownState(state, title)
                if title and dropdownOpen == false then
                    dropdownCurrent = title
                    for _, folder in ipairs(win.DropdownSelection.Dropdowns:GetChildren()) do
                        if folder:IsA("Folder") then
                            folder.DropdownItems.Visible = false
                            folder.DropdownItemsSearch.Visible = false
                        end
                    end
                    win.DropdownSelection.TopBar.Title.Text = title
                    local bucket = win.DropdownSelection.Dropdowns:FindFirstChild(title)
                    if bucket then
                        bucket.DropdownItems.Visible = true
                        bucket.DropdownItemsSearch.Visible = false
                    end
                end

                if state == true then
                    win.DropdownSelection.Size = UDim2.new(0, 0, 0, 0)
                    win.DarkOverlay.BackgroundTransparency = 1
                    win.DropdownSelection.Visible = true
                    win.DarkOverlay.Visible = true
                    win.DropdownSelection.Size = UDim2.new(0.728, 0, 0.684, 0)
                    tween(win.DarkOverlay, { BackgroundTransparency = 0.6 }, Anim.PopupOpen)
                    dropdownOpen = true
                elseif state == false then
                    win.DropdownSelection.Size = UDim2.new(0, 0, 0, 0)
                    local tw = tween(win.DarkOverlay, { BackgroundTransparency = 1 }, Anim.PopupClose)
                    tw.Completed:Wait()
                    win.DropdownSelection.Visible = false
                    win.DarkOverlay.Visible = false
                    dropdownOpen = false
                else
                    if dropdownOpen then
                        win.DropdownSelection.Size = UDim2.new(0, 0, 0, 0)
                        local tw = tween(win.DarkOverlay, { BackgroundTransparency = 1 }, Anim.PopupClose)
                        tw.Completed:Wait()
                        win.DropdownSelection.Visible = false
                        win.DarkOverlay.Visible = false
                        dropdownOpen = false
                    else
                        win.DropdownSelection.Size = UDim2.new(0, 0, 0, 0)
                        win.DarkOverlay.BackgroundTransparency = 1
                        win.DropdownSelection.Visible = true
                        win.DarkOverlay.Visible = true
                        win.DropdownSelection.Size = UDim2.new(0.728, 0, 0.684, 0)
                        tween(win.DarkOverlay, { BackgroundTransparency = 0.6 }, Anim.PopupOpen)
                        dropdownOpen = true
                    end
                end
            end

            local function activateTab(name)
                for tabName, rec in pairs(TabsByName) do
                    if tabName ~= name then
                        rec.TabObject.Visible = false
                        tween(rec.TabButton.TextLabel, {
                            Position = UDim2.new(0, 42, 0.5, 0),
                            Size = UDim2.new(0, 103, 0, 16),
                            TextTransparency = 0.5
                        }, Anim.Global)
                        tween(rec.TabButton.ImageButton, {
                            Position = UDim2.new(0, 12, 0, 18),
                            ImageTransparency = 0.5
                        }, Anim.Global)
                        tween(rec.TabButton.Bar, {
                            Size = UDim2.new(0, 5, 0, 0),
                            BackgroundTransparency = 1
                        }, Anim.Global)
                    else
                        ActiveTabName = name
                        rec.TabObject.Visible = true
                        tween(rec.TabButton.TextLabel, {
                            Position = UDim2.new(0, 57, 0.5, 0),
                            Size = UDim2.new(0, 88, 0, 16),
                            TextTransparency = 0
                        }, Anim.Global)
                        tween(rec.TabButton.ImageButton, {
                            Position = UDim2.new(0, 25, 0, 18),
                            ImageTransparency = 0
                        }, Anim.Global)
                        tween(rec.TabButton.Bar, {
                            Size = UDim2.new(0, 5, 0, 25),
                            BackgroundTransparency = 0
                        }, Anim.Global)

                        -- empty-state check
                        local count = 0
                        for _, child in ipairs(rec.TabObject:GetChildren()) do
                            if child:IsA("GuiObject") then
                                count += 1
                            end
                        end
                        win.Tabs.NoObjectFoundText.Visible = (count == 0)
                    end
                end
            end

            -- close dropdown via X
            win.DropdownSelection.TopBar.Close.MouseButton1Click:Connect(function()
                setDropdownState(false)
            end)

            -- search box (live & on blur)
            local SearchBox = win.DropdownSelection.TopBar.BoxFrame.Frame.TextBox
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                if not cfg.LiveSearchDropdown then return end
                local bucket = win.DropdownSelection.Dropdowns:FindFirstChild(dropdownCurrent)
                if not bucket then return end

                if string.gsub(SearchBox.Text, " ", "") ~= "" then
                    bucket.DropdownItems.Visible = false
                    bucket.DropdownItemsSearch.Visible = true
                    for _, btn in ipairs(bucket.DropdownItemsSearch:GetChildren()) do
                        if btn:IsA("GuiButton") then
                            btn.Visible = string.find(btn.Name:lower(), SearchBox.Text:lower()) ~= nil
                        end
                    end
                else
                    bucket.DropdownItems.Visible = true
                    bucket.DropdownItemsSearch.Visible = false
                end
            end)

            SearchBox.FocusLost:Connect(function()
                if cfg.LiveSearchDropdown then return end
                local bucket = win.DropdownSelection.Dropdowns:FindFirstChild(dropdownCurrent)
                if not bucket then return end

                if string.gsub(SearchBox.Text, " ", "") ~= "" then
                    bucket.DropdownItems.Visible = false
                    bucket.DropdownItemsSearch.Visible = true
                    for _, btn in ipairs(bucket.DropdownItemsSearch:GetChildren()) do
                        if btn:IsA("GuiButton") then
                            btn.Visible = string.find(btn.Name:lower(), SearchBox.Text:lower()) ~= nil
                        end
                    end
                else
                    bucket.DropdownItems.Visible = true
                    bucket.DropdownItemsSearch.Visible = false
                end
            end)

            -- ===== Tabs API =====
            local TabAPI, CurrentSectionContainer

            function Exports.Tab(_, tabOpts)
                TabAPI = {}
                local meta = { Title = tabOpts.Title, Icon = tabOpts.Icon }

                -- side button
                local btn = TemplatesFolder.TabButton:Clone()
                btn.Name = meta.Title
                btn.Parent = TabsSide.Lists
                btn.Visible = true
                btn.TextLabel.Text = meta.Title

                do -- set icon (Lucide)
                    local asset, iconMeta = IconAPI.Icon(meta.Icon)
                    btn.ImageButton.Image = asset or meta.Icon or ""
                    btn.ImageButton.ImageRectOffset = (iconMeta and iconMeta.ImageRectPosition) or Vector2.new(0, 0)
                    btn.ImageButton.ImageRectSize   = (iconMeta and iconMeta.ImageRectSize) or Vector2.new(0, 0)
                end

                -- content scroller
                local tabFrame = TemplatesFolder.Tab:Clone()
                tabFrame.Name = meta.Title
                tabFrame.Parent = TabsArea
                tabFrame.Visible = false

                registerTab(meta.Title, tabFrame, btn)

                -- initial style based on active
                if ActiveTabName == meta.Title then
                    tabFrame.Visible = true
                    btn.TextLabel.Position = UDim2.new(0, 57, 0.5, 0)
                    btn.TextLabel.Size = UDim2.new(0, 88, 0, 16)
                    btn.TextLabel.TextTransparency = 0
                    btn.ImageButton.Position = UDim2.new(0, 25, 0, 18)
                    btn.ImageButton.ImageTransparency = 0
                    btn.Bar.Size = UDim2.new(0, 5, 0, 25)
                    btn.Bar.BackgroundTransparency = 0
                else
                    btn.TextLabel.Position = UDim2.new(0, 42, 0.5, 0)
                    btn.TextLabel.Size = UDim2.new(0, 103, 0, 16)
                    btn.TextLabel.TextTransparency = 0.5
                    btn.ImageButton.Position = UDim2.new(0, 12, 0, 18)
                    btn.ImageButton.ImageTransparency = 0.5
                    btn.Bar.Size = UDim2.new(0, 5, 0, 0)
                    btn.Bar.BackgroundTransparency = 1
                end

                btn.MouseButton1Click:Connect(function()
                    activateTab(meta.Title)
                end)

                -- helper: switch container to latest section (or tab root by default)
                local function getContainer()
                    local list = {}
                    for _, ch in ipairs(tabFrame:GetChildren()) do
                        if ch:IsA("GuiObject") then
                            table.insert(list, ch)
                        end
                    end
                    return list
                end
                CurrentSectionContainer = tabFrame

                -- ===== Section =====
                function TabAPI.Section(_, sectionOpts)
                    local section = {
                        Title = sectionOpts.Title,
                        State = sectionOpts.Default or false,
                        TextXAlignment = sectionOpts.TextXAlignment or "Left",
                    }
                    local inst = TemplatesFolder.Section:Clone()
                    inst.Name = section.Title
                    inst.Button.Title.Text = section.Title
                    inst.Button.Title.TextXAlignment = Enum.TextXAlignment[section.TextXAlignment]
                    inst.Visible = true
                    inst.Parent = tabFrame

                    inst.Button.MouseButton1Click:Connect(function()
                        if section.State == true then
                            inst.Frame.Visible = false
                            tween(inst.Button.Title.Arrow, { Rotation = 0 }, Anim.Global)
                            section.State = false
                        else
                            inst.Frame.Visible = true
                            tween(inst.Button.Title.Arrow, { Rotation = 90 }, Anim.Global)
                            section.State = true
                        end
                    end)

                    function section:SetTitle(newTitle)
                        section.Title = newTitle
                        inst.Button.Title.Text = newTitle
                    end
                    function section:Destroy()
                        CurrentSectionContainer:Destroy()
                    end

                    CurrentSectionContainer = inst.Frame
                    return section
                end

                -- ===== Button =====
                function TabAPI.Button(_, btnOpts)
                    local api = {}
                    local cfg = {
                        Title = btnOpts.Title,
                        Desc = btnOpts.Desc,
                        Locked = btnOpts.Locked or false,
                        Callback = btnOpts.Callback or function() end,
                    }

                    local inst = TemplatesFolder.Button:Clone()
                    inst.Name = cfg.Title
                    inst.Parent = CurrentSectionContainer
                    inst.Frame.Title.Text = cfg.Title

                    if cfg.Desc and cfg.Desc ~= "" then
                        inst.Frame.Description.Visible = true
                        inst.Frame.Description.Text = cfg.Desc
                    end

                    if cfg.Locked then
                        inst.UIStroke.Color              = Color3.fromRGB(47, 47, 58)
                        inst.BackgroundColor3            = Color3.fromRGB(32, 35, 40)
                        inst.Frame.Title.TextColor3      = Color3.fromRGB(75, 77, 83)
                        inst.Frame.Title.ClickIcon.ImageColor3 = Color3.fromRGB(75, 77, 83)
                        inst.Frame.Description.TextColor3= Color3.fromRGB(75, 77, 83)
                    end

                    inst.Visible = true

                    local function enableRandomGradient()
                        local grads = {}
                        for _, g in ipairs(inst.Frame:GetChildren()) do
                            if g:IsA("UIGradient") then
                                g.Enabled = false
                                table.insert(grads, g)
                            end
                        end
                        if #grads > 0 then
                            local pick = grads[math.random(1, #grads)]
                            pick.Enabled = true
                            return pick
                        end
                    end
                    enableRandomGradient()

                    inst.MouseEnter:Connect(function()
                        if not cfg.Locked then
                            tween(inst.UIStroke, { Color = Color3.fromRGB(10, 135, 213) }, Anim.Global)
                        end
                    end)
                    inst.MouseLeave:Connect(function()
                        if not cfg.Locked then
                            tween(inst.UIStroke, { Color = Color3.fromRGB(60, 60, 74) }, Anim.Global)
                            inst.BackgroundColor3 = Color3.fromRGB(42, 45, 52)
                            tween(inst.Frame.Title,       { TextColor3 = Color3.fromRGB(196, 203, 218) }, Anim.Global)
                            tween(inst.Frame.Description, { TextColor3 = Color3.fromRGB(196, 203, 218) }, Anim.Global)
                        end
                    end)

                    inst.MouseButton1Down:Connect(function()
                        if not cfg.Locked then
                            enableRandomGradient()
                            tween(inst.Frame.Title, { TextColor3 = Color3.fromRGB(255, 255, 255) }, Anim.Global)
                            tween(inst.Frame.Title.ClickIcon, { ImageColor3 = Color3.fromRGB(255, 255, 255) }, Anim.Global)
                            tween(inst.Frame.Description, { TextColor3 = Color3.fromRGB(255, 255, 255) }, Anim.Global)
                            tween(inst.Frame, { BackgroundTransparency = 0 }, Anim.Global)
                        end
                    end)

                    inst.MouseButton1Up:Connect(function()
                        if not cfg.Locked then
                            tween(inst.Frame.Title, { TextColor3 = Color3.fromRGB(196, 203, 218) }, Anim.Global)
                            tween(inst.Frame.Title.ClickIcon, { ImageColor3 = Color3.fromRGB(197, 204, 219) }, Anim.Global)
                            tween(inst.Frame.Description, { TextColor3 = Color3.fromRGB(196, 203, 218) }, Anim.Global)
                            tween(inst.Frame, { BackgroundTransparency = 1 }, Anim.Global)
                            task.defer(cfg.Callback)
                        end
                    end)

                    return api
                end

                return TabAPI
            end

            return Exports
        end

        return Exports
    end
}
-- ===== Button (lanjutan: click, empty-state watcher, setters, lock/unlock) =====
                inst.MouseButton1Click:Connect(function()
                    if not cfg.Locked then
                        task.spawn(cfg.Callback)
                    end
                end)

                -- update empty-state ketika ada perubahan child pada tab
                tabFrame.ChildAdded:Connect(function()
                    local count = 0
                    for _, ch in ipairs(tabFrame:GetChildren()) do
                        if ch:IsA("GuiObject") then count += 1 end
                    end
                    TabsArea.NoObjectFoundText.Visible = (count == 0)
                end)
                tabFrame.ChildRemoved:Connect(function()
                    local count = 0
                    for _, ch in ipairs(tabFrame:GetChildren()) do
                        if ch:IsA("GuiObject") then count += 1 end
                    end
                    TabsArea.NoObjectFoundText.Visible = (count == 0)
                end)

                function api.SetTitle(_, t)
                    inst.Frame.Title.Text = t
                end
                function api.SetDesc(_, d)
                    if d and d ~= "" then
                        inst.Frame.Description.Text = d
                        inst.Frame.Description.Visible = true
                    end
                end
                function api.Lock(_)
                    cfg.Locked = true
                    tween(inst, { BackgroundColor3 = Color3.fromRGB(32,35,40) }, Anim.Global)
                    tween(inst.UIStroke, { Color = Color3.fromRGB(47,47,58) }, Anim.Global)
                    tween(inst.Frame.Title, { TextColor3 = Color3.fromRGB(75,77,83) }, Anim.Global)
                    tween(inst.Frame.Title.ClickIcon, { ImageColor3 = Color3.fromRGB(75,77,83) }, Anim.Global)
                    tween(inst.Frame.Description, { TextColor3 = Color3.fromRGB(75,77,83) }, Anim.Global)
                end
                function api.Unlock(_)
                    cfg.Locked = false
                    tween(inst, { BackgroundColor3 = Color3.fromRGB(42,45,52) }, Anim.Global)
                    tween(inst.UIStroke, { Color = Color3.fromRGB(60,60,74) }, Anim.Global)
                    tween(inst.Frame.Title, { TextColor3 = Color3.fromRGB(196,203,218) }, Anim.Global)
                    tween(inst.Frame.Title.ClickIcon, { ImageColor3 = Color3.fromRGB(196,203,218) }, Anim.Global)
                    tween(inst.Frame.Description, { TextColor3 = Color3.fromRGB(196,203,218) }, Anim.Global)
                end
                function api.Destroy(_)
                    inst:Destroy()
                end

                return api
            end

            -- ===== Code =====
            function TabAPI.Code(_, opts)
                local api = {}
                local cfg = { Title = opts.Title, Code = opts.Code }
                local inst = TemplatesFolder.Code:Clone()
                inst.Name = cfg.Title
                inst.Parent = CurrentSectionContainer
                inst.Title.Text = cfg.Title
                inst.Code.Text  = cfg.Code
                inst.Code.Visible = true
                inst.Code.Font = Enum.Font.Code
                inst.Visible = true

                function api.SetTitle(_, t)
                    cfg.Title = t
                    inst.Title.Text = t
                end
                function api.SetCode(_, c)
                    cfg.Code = c
                    inst.Code.Text = c
                end
                function api.Destroy(_)
                    inst:Destroy()
                end
                return api
            end

            -- ===== Paragraph =====
            function TabAPI.Paragraph(_, opts)
                local api = {}
                local cfg = { Title = opts.Title, Desc = opts.Desc, RichText = opts.RichText or false }
                local inst = TemplatesFolder.Paragraph:Clone()
                inst.Name = cfg.Title
                inst.Parent = CurrentSectionContainer
                inst.Title.Text = cfg.Title
                if cfg.Desc and cfg.Desc ~= "" then
                    inst.Description.Text = cfg.Desc
                    inst.Description.Visible = true
                else
                    inst.Description.Visible = false
                end
                inst.Title.RichText = cfg.RichText
                inst.Description.RichText = cfg.RichText
                inst.Visible = true

                function api.SetTitle(_, t)
                    cfg.Title = t
                    inst.Title.Text = t
                end
                function api.SetDesc(_, d)
                    cfg.Desc = d
                    inst.Description.Text = d
                    inst.Description.Visible = d ~= ""
                end
                function api.Destroy(_)
                    inst:Destroy()
                end
                return api
            end

            -- ===== Toggle =====
            function TabAPI.Toggle(_, opts)
                local api = {}
                local cfg = {
                    Title = opts.Title,
                    Desc = opts.Desc,
                    State = opts.Default or opts.Value or false,
                    Locked = opts.Locked or false,
                    Icon = opts.Icon,
                    Callback = opts.Callback or function() end,
                }

                local inst = TemplatesFolder.Toggle:Clone()
                inst.Name = cfg.Title
                inst.Parent = CurrentSectionContainer
                inst.Title.Text = cfg.Title

                -- icon di bola toggle (Obsidian-style)
                if cfg.Icon then
                    local as = tostring(cfg.Icon)
                    if as:find("rbxassetid") or as:match("%d") then
                        inst.Title.Fill.Ball.Icon.Image = as
                    else
                        local img, meta = IconAPI.Icon(as)
                        inst.Title.Fill.Ball.Icon.Image = img or as or ""
                        inst.Title.Fill.Ball.Icon.ImageRectOffset = (meta and meta.ImageRectPosition) or Vector2.new(0,0)
                        inst.Title.Fill.Ball.Icon.ImageRectSize   = (meta and meta.ImageRectSize) or Vector2.new(0,0)
                    end
                end

                if cfg.Desc and cfg.Desc ~= "" then
                    inst.Description.Visible = true
                    inst.Description.Text = cfg.Desc
                end

                local function paint(state)
                    if state then
                        tween(inst.Title.Fill.Ball, { Position = UDim2.new(0.5,0,0.5,0) }, Anim.Global)
                        tween(inst.Title.Fill, { BackgroundColor3 = Color3.fromRGB(192,209,199) }, Anim.Global)
                        tween(inst.Title.Fill.Ball.Icon, { ImageTransparency = 0 }, Anim.Global)
                    else
                        tween(inst.Title.Fill.Ball, { Position = UDim2.new(0,0,0.5,0) }, Anim.Global)
                        tween(inst.Title.Fill, { BackgroundColor3 = Color3.fromRGB(53,56,62) }, Anim.Global)
                        tween(inst.Title.Fill.Ball.Icon, { ImageTransparency = 1 }, Anim.Global)
                    end
                end

                paint(cfg.State)

                if cfg.Locked then
                    inst.UIStroke.Color = Color3.fromRGB(47,47,58)
                    inst.BackgroundColor3 = Color3.fromRGB(32,35,40)
                    inst.Title.TextColor3 = Color3.fromRGB(75,77,83)
                    inst.Description.TextColor3 = Color3.fromRGB(75,77,83)
                    inst.Title.Fill.BackgroundTransparency = 0.7
                    inst.Title.Fill.Ball.BackgroundTransparency = 0.7
                end

                inst.Visible = true

                inst.Title.Fill.MouseEnter:Connect(function()
                    if not cfg.Locked then
                        tween(inst.UIStroke, { Color = Color3.fromRGB(10,135,213) }, Anim.Global)
                    end
                end)
                inst.Title.Fill.MouseLeave:Connect(function()
                    if not cfg.Locked then
                        tween(inst.UIStroke, { Color = Color3.fromRGB(60,60,74) }, Anim.Global)
                        inst.BackgroundColor3 = Color3.fromRGB(42,45,52)
                        tween(inst.Title, { TextColor3 = Color3.fromRGB(196,203,218) }, Anim.Global)
                        tween(inst.Description, { TextColor3 = Color3.fromRGB(196,203,218) }, Anim.Global)
                    end
                end)

                local function setState(newState)
                    if newState ~= nil then
                        paint(newState)
                        cfg.State = newState
                    else
                        paint(not cfg.State)
                        cfg.State = not cfg.State
                    end
                    task.spawn(cfg.Callback, cfg.State)
                end

                inst.Title.Fill.MouseButton1Click:Connect(function()
                    if not cfg.Locked then
                        setState()
                    end
                end)

                function api.SetTitle(_, t)
                    cfg.Title = t
                    inst.Title.Text = t
                end
                function api.SetDesc(_, d)
                    if d and d ~= "" then
                        cfg.Desc = d
                        inst.Description.Text = d
                        inst.Description.Visible = true
                    end
                end
                function api.Set(_, v)
                    setState(v)
                end
                function api.Lock(_)
                    cfg.Locked = true
                    tween(inst, { BackgroundColor3 = Color3.fromRGB(32,35,40) }, Anim.Global)
                    tween(inst.UIStroke, { Color = Color3.fromRGB(47,47,58) }, Anim.Global)
                    tween(inst.Title, { TextColor3 = Color3.fromRGB(75,77,83) }, Anim.Global)
                    tween(inst.Description, { TextColor3 = Color3.fromRGB(75,77,83) }, Anim.Global)
                    tween(inst.Title.Fill, { BackgroundTransparency = 0.7 }, Anim.Global)
                    tween(inst.Title.Fill.Ball, { BackgroundTransparency = 0.7 }, Anim.Global)
                end
                function api.Unlock(_)
                    cfg.Locked = false
                    tween(inst, { BackgroundColor3 = Color3.fromRGB(42,45,52) }, Anim.Global)
                    tween(inst.UIStroke, { Color = Color3.fromRGB(60,60,74) }, Anim.Global)
                    tween(inst.Title, { TextColor3 = Color3.fromRGB(196,203,218) }, Anim.Global)
                    tween(inst.Description, { TextColor3 = Color3.fromRGB(196,203,218) }, Anim.Global)
                    tween(inst.Title.Fill, { BackgroundTransparency = 0 }, Anim.Global)
                    tween(inst.Title.Fill.Ball, { BackgroundTransparency = 0 }, Anim.Global)
                end
                function api.Destroy(_)
                    inst:Destroy()
                end

                task.defer(cfg.Callback, cfg.State)
                return api
            end

            -- ===== Slider =====
            function TabAPI.Slider(_, opts)
                local api = {}
                local cfg = {
                    Title = opts.Title,
                    Desc = opts.Desc,
                    Step = opts.Step or 1,
                    Value = {
                        Min = (opts.Value and opts.Value.Min) or 0,
                        Max = (opts.Value and opts.Value.Max) or (opts.Max or 100),
                        Default = nil,
                    },
                    Locked = opts.Locked or false,
                    Callback = opts.Callback or function() end,
                }
                cfg.Value.Default = (opts.Value and opts.Value.Default) or opts.Default or cfg.Value.Min

                local inst = TemplatesFolder.Slider:Clone()
                inst.Parent = CurrentSectionContainer
                inst.Name = cfg.Title
                inst.Title.Text = cfg.Title
                if cfg.Desc and cfg.Desc ~= "" then
                    inst.Description.Visible = true
                    inst.Description.Text = cfg.Desc
                end
                inst.Visible = true

                -- gradient randomizer saat fill melebar
                local function pickGrad()
                    local grads = {}
                    for _, g in ipairs(inst.SliderFrame.Frame.Slider.Fill.BackgroundGradient:GetChildren()) do
                        if g:IsA("UIGradient") then
                            g.Enabled = false
                            table.insert(grads, g)
                        end
                    end
                    if #grads > 0 then
                        local pick = grads[math.random(1, #grads)]
                        pick.Enabled = true
                        return pick
                    end
                end

                inst.SliderFrame.Frame.Slider.Fill.BackgroundGradient.Size = UDim2.new(0, inst.SliderFrame.Frame.Slider.AbsoluteSize.X, 1, 0)
                inst.SliderFrame.Frame.Slider:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    inst.SliderFrame.Frame.Slider.Fill.BackgroundGradient.Size = UDim2.new(0, inst.SliderFrame.Frame.Slider.AbsoluteSize.X, 1, 0)
                end)

                local lastTiny -- trigger ketika baru melewati ambang kecil
                inst.SliderFrame.Frame.Slider.Fill:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    if inst.SliderFrame.Frame.Slider.Fill.AbsoluteSize.X <= 3 then
                        lastTiny = inst.SliderFrame.Frame.Slider.Fill.AbsoluteSize.X
                    end
                    if lastTiny and inst.SliderFrame.Frame.Slider.Fill.AbsoluteSize.X > lastTiny then
                        pickGrad()
                        lastTiny = nil
                    end
                end)
                pickGrad()

                if cfg.Locked then
                    inst.UIStroke.Color = Color3.fromRGB(47,47,58)
                    inst.BackgroundColor3 = Color3.fromRGB(32,35,40)
                    inst.Title.TextColor3 = Color3.fromRGB(75,77,83)
                    inst.Description.TextColor3 = Color3.fromRGB(75,77,83)
                    inst.SliderFrame.Frame.Slider.UIStroke.Color = Color3.fromRGB(47,47,58)
                    inst.SliderFrame.Frame.Slider.BackgroundTransparency = 0.5
                    inst.SliderFrame.Frame.Slider.Fill.UIStroke.Transparency = 0.5
                    inst.SliderFrame.Frame.Slider.Fill.BackgroundGradient.BackgroundTransparency = 0.5
                    inst.SliderFrame.Frame.ValueText.TextTransparency = 0.6
                end

                local Trigger = inst.SliderFrame.Frame.Slider.Trigger
                local ValueText = inst.SliderFrame.Frame.ValueText
                local Fill = inst.SliderFrame.Frame.Slider.Fill
                local bar = inst.SliderFrame.Frame.Slider
                local default = cfg.Value.Default
                local minv = cfg.Value.Min
                local maxv = cfg.Value.Max
                local step = cfg.Step or 1
                local current = default
                local hovering, dragging = false, false

                local function toScale(val)
                    return (val - minv) / (maxv - minv)
                end

                ValueText.Text = tostring(default or minv)
                Fill.Size = UDim2.fromScale(toScale(default), 1)

                local function setVisualByValue(val)
                    if val == nil or val > maxv or val < minv then return end
                    local snapped = math.round(val / step) * step
                    current = math.clamp(snapped, minv, maxv)
                    tween(Fill, { Size = UDim2.fromScale(toScale(current), 1) }, Anim.Global)
                    ValueText.Text = tostring(current)
                    task.spawn(cfg.Callback, current)
                end

                local UISvc = game:GetService("UserInputService")
                local mouse = game.Players.LocalPlayer:GetMouse()

                local function dragLoop()
                    dragging = true
                    if cfg.Locked then return end
                    repeat
                        task.wait()
                        local alpha = math.clamp((mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                        local val = minv + alpha * (maxv - minv)
                        setVisualByValue(val)
                    until not dragging or cfg.Locked
                    if not hovering then
                        tween(inst.UIStroke, { Color = Color3.fromRGB(60,60,74) }, Anim.Global)
                    end
                end

                Trigger.MouseEnter:Connect(function()
                    hovering = true
                    if not cfg.Locked then
                        tween(inst.UIStroke, { Color = Color3.fromRGB(10,135,213) }, Anim.Global)
                    end
                end)
                Trigger.MouseLeave:Connect(function()
                    hovering = false
                    if not cfg.Locked and not dragging then
                        tween(inst.UIStroke, { Color = Color3.fromRGB(60,60,74) }, Anim.Global)
                    end
                end)
                Trigger.MouseButton1Down:Connect(function()
                    dragLoop()
                end)
                UISvc.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                function api.SetTitle(_, t)
                    cfg.Title = t
                    inst.Title.Text = t
                end
                function api.SetDesc(_, d)
                    if d and d ~= "" then
                        cfg.Desc = d
                        inst.Description.Text = d
                        inst.Description.Visible = true
                    end
                end
                function api.Set(_, v)
                    setVisualByValue(v)
                end
                function api.Lock(_)
                    cfg.Locked = true
                    tween(inst, { BackgroundColor3 = Color3.fromRGB(32,35,40) }, Anim.Global)
                    tween(inst.UIStroke, { Color = Color3.fromRGB(47,47,58) }, Anim.Global)
                    tween(inst.Title, { TextColor3 = Color3.fromRGB(75,77,83) }, Anim.Global)
                    tween(inst.Description, { TextColor3 = Color3.fromRGB(75,77,83) }, Anim.Global)
                    tween(inst.SliderFrame.Frame.Slider.UIStroke, { Color = Color3.fromRGB(47,47,58) }, Anim.Global)
                    tween(inst.SliderFrame.Frame.Slider, { BackgroundTransparency = 0.5 }, Anim.Global)
                    tween(inst.SliderFrame.Frame.Slider.Fill.UIStroke, { Transparency = 0.5 }, Anim.Global)
                    tween(inst.SliderFrame.Frame.Slider.Fill.BackgroundGradient, { BackgroundTransparency = 0.5 }, Anim.Global)
                    tween(inst.SliderFrame.Frame.ValueText, { TextTransparency = 0.6 }, Anim.Global)
                end
                function api.Unlock(_)
                    cfg.Locked = false
                    tween(inst, { BackgroundColor3 = Color3.fromRGB(42,45,52) }, Anim.Global)
                    tween(inst.UIStroke, { Color = Color3.fromRGB(60,60,74) }, Anim.Global)
                    -- === Slider “Unlock visual” state (contoh bagian atas potonganmu) ===
tween(SliderGui.Title, {
    TextColor3 = Color3.fromRGB(196, 203, 218)
}, GlobalTween)
tween(SliderGui.Description, {
    TextColor3 = Color3.fromRGB(196, 203, 218)
}, GlobalTween)
tween(SliderGui.SliderFrame.Frame.Slider.UIStroke, {
    Color = Color3.fromRGB(60, 60, 74)
}, GlobalTween)
tween(SliderGui.SliderFrame.Frame.Slider, {
    BackgroundTransparency = 0
}, GlobalTween)
tween(SliderGui.SliderFrame.Frame.Slider.Fill.UIStroke, {
    Transparency = 0
}, GlobalTween)
tween(SliderGui.SliderFrame.Frame.Slider.Fill.BackgroundGradient, {
    BackgroundTransparency = 0
}, GlobalTween)
tween(SliderGui.SliderFrame.Frame.ValueText, {
    TextTransparency = 0
}, GlobalTween)

function SliderAPI.Destroy()
    SliderGui:Destroy()
end

SliderAPI.Callback(currentValue) -- panggil callback awal
return SliderAPI


-- === Input ===
function SectionAPI.Input(self, opts)
    local state = {
        Title            = opts.Title,
        Desc             = opts.Desc,
        Placeholder      = opts.Placeholder or "",
        Default          = opts.Default or opts.Value or "",
        Text             = opts.Default or opts.Value or "",
        ClearTextOnFocus = opts.ClearTextOnFocus or false,
        Locked           = opts.Locked or false,
        MultiLine        = opts.MultiLine or false,
        Callback         = opts.Callback or function() end,
    }

    local textBoxGui = Templates.TextBox:Clone()
    textBoxGui.Name = state.Title
    textBoxGui.Parent = SectionBody
    textBoxGui.Title.Text = state.Title

    if state.Desc and state.Desc ~= "" then
        textBoxGui.Description.Text = state.Desc
        textBoxGui.Description.Visible = true
    else
        textBoxGui.Description.Visible = false
    end

    if state.Locked then
        textBoxGui.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        textBoxGui.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        textBoxGui.Title.TextColor3 = Color3.fromRGB(75, 77, 83)
        textBoxGui.Description.TextColor3 = Color3.fromRGB(75, 77, 83)
        textBoxGui.BoxFrame.Frame.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        textBoxGui.BoxFrame.Frame.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        textBoxGui.BoxFrame.Frame.TextBox.TextColor3 = Color3.fromRGB(75, 77, 83)
        textBoxGui.BoxFrame.Frame.TextBox.PlaceholderColor3 = Color3.fromRGB(75, 77, 83)
        textBoxGui.BoxFrame.Frame.TextBox.Active = false
        textBoxGui.BoxFrame.Frame.TextBox.Interactable = false
        textBoxGui.BoxFrame.Frame.TextBox.TextEditable = false
    end

    local tb = textBoxGui.BoxFrame.Frame.TextBox
    tb.Text = state.Default
    tb.PlaceholderText = state.Placeholder
    tb.MultiLine = state.MultiLine
    tb.AutomaticSize = state.MultiLine and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
    tb.ClearTextOnFocus = state.ClearTextOnFocus

    textBoxGui.Visible = true

    tb.MouseEnter:Connect(function()
        if not state.Locked then
            tween(textBoxGui.UIStroke, { Color = Color3.fromRGB(10, 135, 213) }, GlobalTween)
        end
    end)
    tb.MouseLeave:Connect(function()
        if not state.Locked then
            tween(textBoxGui.UIStroke, { Color = Color3.fromRGB(60, 60, 74) }, GlobalTween)
        end
    end)
    tb.Focused:Connect(function()
        if not state.Locked then
            tween(textBoxGui.UIStroke, { Color = Color3.fromRGB(60, 60, 74) }, GlobalTween)
            tween(textBoxGui.BoxFrame.Frame.UIStroke, { Color = Color3.fromRGB(10, 135, 213) }, GlobalTween)
        end
    end)
    tb.FocusLost:Connect(function()
        if not state.Locked then
            tween(textBoxGui.BoxFrame.Frame.UIStroke, { Color = Color3.fromRGB(60, 60, 74) }, GlobalTween)
            state.Text = tb.Text
            state.Callback(state.Text)
        end
    end)

    function state.Set(_, newText)
        tb.Text = newText
        state.Text = newText
        state.Callback(newText)
    end
    function state.SetTitle(_, newTitle)
        textBoxGui.Title.Text = newTitle
    end
    function state.SetDesc(_, newDesc)
        if newDesc and newDesc ~= "" then
            textBoxGui.Description.Text = newDesc
            textBoxGui.Description.Visible = true
        else
            textBoxGui.Description.Visible = false
        end
    end
    function state.SetPlaceholder(_, newPh)
        if newPh then
            tb.PlaceholderText = newPh -- PATCH: tadinya salah ke Description.Placeholder
        end
    end
    function state.Lock()
        state.Locked = true
        tween(textBoxGui.UIStroke, { Color = Color3.fromRGB(47, 47, 58) }, GlobalTween)
        tween(textBoxGui, { BackgroundColor3 = Color3.fromRGB(32, 35, 40) }, GlobalTween)
        tween(textBoxGui.Title, { TextColor3 = Color3.fromRGB(75, 77, 83) }, GlobalTween)
        tween(textBoxGui.Description, { TextColor3 = Color3.fromRGB(75, 77, 83) }, GlobalTween)
        tween(textBoxGui.BoxFrame.Frame, { BackgroundColor3 = Color3.fromRGB(32, 35, 40) }, GlobalTween)
        tween(textBoxGui.BoxFrame.Frame.UIStroke, { Color = Color3.fromRGB(47, 47, 58) }, GlobalTween)
        tween(tb, {
            TextColor3 = Color3.fromRGB(75, 77, 83),
            PlaceholderColor3 = Color3.fromRGB(75, 77, 83)
        }, GlobalTween)
        tb.Active = false
        tb.Interactable = false
        tb.TextEditable = false
    end
    function state.Unlock()
        state.Locked = false
        tween(textBoxGui.UIStroke, { Color = Color3.fromRGB(60, 60, 74) }, GlobalTween)
        tween(textBoxGui, { BackgroundColor3 = Color3.fromRGB(42, 45, 52) }, GlobalTween)
        tween(textBoxGui.Title, { TextColor3 = Color3.fromRGB(196, 203, 218) }, GlobalTween)
        tween(textBoxGui.Description, { TextColor3 = Color3.fromRGB(196, 203, 218) }, GlobalTween)
        tween(textBoxGui.BoxFrame.Frame, { BackgroundColor3 = Color3.fromRGB(42, 45, 52) }, GlobalTween)
        tween(textBoxGui.BoxFrame.Frame.UIStroke, { Color = Color3.fromRGB(60, 60, 74) }, GlobalTween)
        tween(tb, {
            TextColor3 = Color3.fromRGB(196, 203, 218),
            PlaceholderColor3 = Color3.fromRGB(139, 139, 139)
        }, GlobalTween)
        tb.Active = true
        tb.Interactable = true
        tb.TextEditable = true
    end
    function state.Destroy()
        textBoxGui:Destroy()
    end

    state.Callback(state.Text) -- callback awal
    return state
end


-- === Util untuk buat item dropdown (gradient random aktif) ===
local function CreateDropdownItemButton(text, parent)
    local btn = Templates.DropdownButton:Clone()
    btn.Parent = parent or nil
    btn.Name = text
    btn.Frame.Title.Text = text

    local function activateOneRandomGradient()
        local grads = {}
        for _, child in ipairs(btn.Frame:GetChildren()) do
            if child:IsA("UIGradient") then
                child.Enabled = false
                table.insert(grads, child)
            end
        end
        if #grads > 0 then
            local chosen = grads[math.random(1, #grads)]
            chosen.Enabled = true
            return chosen
        end
    end
    activateOneRandomGradient()
    return btn
end

local function JoinValues(values)
    return table.concat(values, ", ")
end


-- === Dropdown ===
function SectionAPI.Dropdown(self, opts)
    local state = {
        Title     = opts.Title,
        Desc      = opts.Desc,
        Multi     = opts.Multi or false,
        Values    = opts.Values or {},
        Value     = opts.Value or opts.Default,
        AllowNone = opts.AllowNone or false,
        Locked    = opts.Locked or false,
        Callback  = opts.Callback or function() end,
    }

    local dropdownGui  = Templates.Dropdown:Clone()
    local listGui      = Templates.DropdownList:Clone()

    listGui.Name = state.Title
    listGui.Parent = Overlay.DropdownSelection.Dropdowns

    dropdownGui.Parent = SectionBody
    dropdownGui.Name = state.Title
    dropdownGui.Title.Text = state.Title

    if state.Desc and state.Desc ~= "" then
        dropdownGui.Description.Visible = true
        dropdownGui.Description.Text = state.Desc
    else
        dropdownGui.Description.Visible = false
    end

    if state.Locked then
        dropdownGui.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        dropdownGui.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        dropdownGui.Title.TextColor3 = Color3.fromRGB(75, 77, 83)
        dropdownGui.Description.TextColor3 = Color3.fromRGB(75, 77, 83)
        dropdownGui.Title.ClickIcon.ImageColor3 = Color3.fromRGB(75, 77, 83)
        dropdownGui.Title.BoxFrame.Trigger.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        dropdownGui.Title.BoxFrame.Trigger.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        dropdownGui.Title.BoxFrame.Trigger.Title.TextColor3 = Color3.fromRGB(75, 77, 83)
        dropdownGui.Active = false
        dropdownGui.Interactable = false
    end

    dropdownGui.Visible = true

    -- pilih/set nilai item (single/multi)
    local function selectValues(isMulti, payload)
        if not isMulti then
            local itemBtn  = listGui.DropdownItems:FindFirstChild(payload)
            local itemBtnS = listGui.DropdownItemsSearch:FindFirstChild(payload)
            local chosen   = payload

            state.Value = chosen
            dropdownGui.Title.BoxFrame.Trigger.Title.Text = chosen

            -- reset style semua item yg bukan yg dipilih
            for _, btn in listGui.DropdownItems:GetChildren() do
                if btn:IsA("GuiButton") and btn.Name ~= payload then
                    tween(btn.Frame.Title,        { TextColor3 = Color3.fromRGB(196,203,218) }, GlobalTween)
                    tween(btn.Frame.Description,  { TextColor3 = Color3.fromRGB(196,203,218) }, GlobalTween)
                    tween(btn.Frame,              { BackgroundTransparency = 1 }, GlobalTween)
                    tween(btn.UIStroke,           { Color = Color3.fromRGB(60,60,74) }, GlobalTween)
                end
            end
            for _, btn in listGui.DropdownItemsSearch:GetChildren() do
                if btn:IsA("GuiButton") and btn.Name ~= payload then
                    tween(btn.Frame.Title,        { TextColor3 = Color3.fromRGB(196,203,218) }, GlobalTween)
                    tween(btn.Frame.Description,  { TextColor3 = Color3.fromRGB(196,203,218) }, GlobalTween)
                    tween(btn.Frame,              { BackgroundTransparency = 1 }, GlobalTween)
                    tween(btn.UIStroke,           { Color = Color3.fromRGB(60,60,74) }, GlobalTween)
                end
            end

            -- style item terpilih (biru)
            tween(itemBtn.Frame.Title,       { TextColor3 = Color3.fromRGB(255,255,255) }, GlobalTween)
            tween(itemBtn.Frame.Description, { TextColor3 = Color3.fromRGB(255,255,255) }, GlobalTween)
            tween(itemBtn.UIStroke,          { Color = Color3.fromRGB(10,135,213) }, GlobalTween)
            tween(itemBtn.Frame,             { BackgroundTransparency = 0 }, GlobalTween)

            tween(itemBtnS.Frame.Title,       { TextColor3 = Color3.fromRGB(255,255,255) }, GlobalTween)
            tween(itemBtnS.Frame.Description, { TextColor3 = Color3.fromRGB(255,255,255) }, GlobalTween)
            tween(itemBtnS.UIStroke,          { Color = Color3.fromRGB(10,135,213) }, GlobalTween)
            tween(itemBtnS.Frame,             { BackgroundTransparency = 0 }, GlobalTween)

            return chosen
        else
            -- multi-select: payload = { "ItemA", "ItemB", ... }
            local chosenList = state.Value
            for _, valueName in payload do
                local btn      = listGui.DropdownItems:FindFirstChild(valueName)
                local btnS     = listGui.DropdownItemsSearch:FindFirstChild(valueName)
                local existing = table.find(chosenList, valueName)

                if existing then
                    if (not state.AllowNone) and #chosenList == 1 then
                        return -- cegah kosong total jika AllowNone=false
                    end
                    table.remove(chosenList, existing)

                    tween(btn.Frame.Title,       { TextColor3 = Color3.fromRGB(196,203,218) }, GlobalTween)
                    tween(btn.Frame.Description, { TextColor3 = Color3.fromRGB(196,203,218) }, GlobalTween)
                    tween(btn.UIStroke,          { Color = Color3.fromRGB(60,60,74) }, GlobalTween)
                    tween(btn.Frame,             { BackgroundTransparency = 1 }, GlobalTween)

                    tween(btnS.Frame.Title,       { TextColor3 = Color3.fromRGB(196,203,218) }, GlobalTween)
                    tween(btnS.Frame.Description, { TextColor3 = Color3.fromRGB(196,203,218) }, GlobalTween)
                    tween(btnS.UIStroke,          { Color = Color3.fromRGB(60,60,74) }, GlobalTween)
                    tween(btnS.Frame,             { BackgroundTransparency = 1 }, GlobalTween)
                else
                    table.insert(chosenList, valueName)

                    tween(btn.Frame.Title,       { TextColor3 = Color3.fromRGB(255,255,255) }, GlobalTween)
                    tween(btn.Frame.Description, { TextColor3 = Color3.fromRGB(255,255,255) }, GlobalTween)
                    tween(btn.UIStroke,          { Color = Color3.fromRGB(10,135,213) }, GlobalTween)
                    tween(btn.Frame,             { BackgroundTransparency = 0 }, GlobalTween)

                    tween(btnS.Frame.Title,       { TextColor3 = Color3.fromRGB(255,255,255) }, GlobalTween)
                    tween(btnS.Frame.Description, { TextColor3 = Color3.fromRGB(255,255,255) }, GlobalTween)
                    tween(btnS.UIStroke,          { Color = Color3.fromRGB(10,135,213) }, GlobalTween)
                    tween(btnS.Frame,             { BackgroundTransparency = 0 }, GlobalTween)
                end
            end

            dropdownGui.Title.BoxFrame.Trigger.Title.Text = JoinValues(state.Value)
            return state.Value
        end
    end

    -- rebuild isi dropdown dari daftar Values
    local function refreshValues(values, clearFirst)
        -- deduplicate & beri suffix (x) jika duplicate
        local seen, flatValues = {}, {}
        for _, v in values do
            if typeof(v) == "string" then
                if not seen[v] then
                    seen[v] = 1
                    table.insert(flatValues, v)
                else
                    seen[v] = seen[v] + 1
                    table.insert(flatValues, v .. " (" .. seen[v] .. ")")
                end
            end
        end

        if clearFirst then
            state.Values = flatValues
            for _, c in listGui.DropdownItems:GetChildren() do
                if c:IsA("GuiButton") then c:Destroy() end
            end
            for _, c in listGui.DropdownItemsSearch:GetChildren() do
                if c:IsA("GuiButton") then c:Destroy() end
            end
        end

        if not state.Multi then
            if clearFirst then
                state.Value = nil
                dropdownGui.Title.BoxFrame.Trigger.Title.Text = ""
            end
            for _, v in flatValues do
                local btn  = CreateDropdownItemButton(v, listGui.DropdownItems)
                local btnS = CreateDropdownItemButton(v, listGui.DropdownItemsSearch)
                btn.Visible, btnS.Visible = true, true

                if state.Value == v then
                    btn.Frame.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btn.Frame.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btn.UIStroke.Color = Color3.fromRGB(10, 135, 213)
                    btn.Frame.BackgroundTransparency = 0

                    btnS.Frame.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btnS.Frame.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btnS.UIStroke.Color = Color3.fromRGB(10, 135, 213)
                    btnS.Frame.BackgroundTransparency = 0
                end

                btn.MouseButton1Click:Connect(function()
                    if not state.Locked then
                        local chosen = selectValues(false, v)
                        if chosen then state.Callback(chosen) end
                    end
                end)
                btnS.MouseButton1Click:Connect(function()
                    if not state.Locked then
                        local chosen = selectValues(false, v)
                        if chosen then state.Callback(chosen) end
                    end
                end)
            end
        else
            if clearFirst then
                state.Value = {}
                dropdownGui.Title.BoxFrame.Trigger.Title.Text = JoinValues(state.Value)
            end

            for _, v in flatValues do
                local btn  = CreateDropdownItemButton(v, listGui.DropdownItems)
                local btnS = CreateDropdownItemButton(v, listGui.DropdownItemsSearch)
                btn.Visible, btnS.Visible = true, true

                if table.find(state.Value, v) then
                    btn.Frame.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btn.Frame.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btn.UIStroke.Color = Color3.fromRGB(10, 135, 213)
                    btn.Frame.BackgroundTransparency = 0

                    btnS.Frame.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btnS.Frame.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btnS.UIStroke.Color = Color3.fromRGB(10, 135, 213)
                    btnS.Frame.BackgroundTransparency = 0
                end

                btn.MouseButton1Click:Connect(function()
                    if not state.Locked then
                        local chosen = selectValues(true, { v })
                        if chosen then state.Callback(chosen) end
                    end
                end)
                btnS.MouseButton1Click:Connect(function()
                    if not state.Locked then
                        local chosen = selectValues(true, { v })
                        if chosen then state.Callback(chosen) end
                    end
                end)
            end
        end
    end

    if not state.Multi then
        state.Value = state.Value or nil
        dropdownGui.Title.BoxFrame.Trigger.Title.Text = state.Value
        refreshValues(state.Values)
    else
        dropdownGui.Title.ClickIcon.Image = "rbxassetid://91415671397056" -- (ikuti aset og)
        if type(state.Value) == "string" then state.Value = { state.Value } end
        state.Value = state.Value or {}
        dropdownGui.Title.BoxFrame.Trigger.Title.Text = JoinValues(state.Value)
        refreshValues(state.Values)
    end

    dropdownGui.Title.BoxFrame.Trigger.MouseButton1Click:Connect(function()
        H(nil, state.Title) -- asumsi: H = handler buka dropdown list
    end)

    function state.SetTitle(_, newTitle)
        state.Title = newTitle
        dropdownGui.Name = newTitle
        dropdownGui.Title.Text = newTitle
        listGui.Name = newTitle
    end
    -- === Dropdown: setters & state ===
function ddState.SetTitle(_, newTitle)
    ddState.Title = newTitle
    ddGui.Title.Text = newTitle
end

function ddState.SetDesc(_, newDesc)
    if newDesc and newDesc ~= '' then
        ddState.Desc = newDesc
        ddGui.Description.Text = newDesc
    end
end

function ddState.Refresh(_, values)
    refreshDropdownItems(values, true)
end

function ddState.Select(_, valueOrList)
    ddState.Callback(applySelection(ddState.Multi, valueOrList))
end

function ddState.Lock(_)
    ddState.Locked = true
    tween(ddGui.UIStroke, { Color = Color3.fromRGB(47, 47, 58) }, TweenGlobal)
    tween(ddGui, { BackgroundColor3 = Color3.fromRGB(32, 35, 40) }, TweenGlobal)
    tween(ddGui.Title, { TextColor3 = Color3.fromRGB(75, 77, 83) }, TweenGlobal)
    tween(ddGui.Description, { TextColor3 = Color3.fromRGB(75, 77, 83) }, TweenGlobal)
    tween(ddGui.Title.ClickIcon, { ImageColor3 = Color3.fromRGB(75, 77, 83) }, TweenGlobal)
    tween(ddGui.Title.BoxFrame.Trigger, { BackgroundColor3 = Color3.fromRGB(32, 35, 40) }, TweenGlobal)
    tween(ddGui.Title.BoxFrame.Trigger.UIStroke, { Color = Color3.fromRGB(47, 47, 58) }, TweenGlobal)
    tween(ddGui.Title.BoxFrame.Trigger.Title, { TextColor3 = Color3.fromRGB(75, 77, 83) }, TweenGlobal)
    ddGui.Active = false
    ddGui.Interactable = false
end

function ddState.Unlock(_)
    ddState.Locked = false
    tween(ddGui.UIStroke, { Color = Color3.fromRGB(60, 60, 74) }, TweenGlobal)
    tween(ddGui, { BackgroundColor3 = Color3.fromRGB(42, 45, 52) }, TweenGlobal)
    tween(ddGui.Title, { TextColor3 = Color3.fromRGB(196, 203, 218) }, TweenGlobal)
    tween(ddGui.Description, { TextColor3 = Color3.fromRGB(196, 203, 218) }, TweenGlobal)
    tween(ddGui.Title.ClickIcon, { ImageColor3 = Color3.fromRGB(196, 203, 218) }, TweenGlobal)
    tween(ddGui.Title.BoxFrame.Trigger, { BackgroundColor3 = Color3.fromRGB(42, 45, 52) }, TweenGlobal)
    tween(ddGui.Title.BoxFrame.Trigger.UIStroke, { Color = Color3.fromRGB(60, 60, 74) }, TweenGlobal)
    tween(ddGui.Title.BoxFrame.Trigger.Title, { TextColor3 = Color3.fromRGB(196, 203, 218) }, TweenGlobal)
    ddGui.Active = true
    ddGui.Interactable = true
end

function ddState.Destroy(_)
    ddGui:Destroy()
end

ddState.Callback(ddState.Value)
return ddState


-- === Window API ===
return SectionAPI
end

function WindowAPI.SelectTab(_, tabName)
    local tab = Tabs[tabName]
    if tab then
        SwitchTab(tab.Name)
    end
end

function WindowAPI.Divider(_)
    local div = Templates.Divider:Clone()
    div.Parent = WindowGui.TabButtons.Lists
    div.Visible = true
end

function WindowAPI.SetToggleKey(_, key)
    if type(key) == 'string' then
        WindowAPI.ToggleKey = Enum.KeyCode[key]
    else
        WindowAPI.ToggleKey = key
    end
end

function WindowAPI.EditOpenButton(_) end -- stub, biarin

function WindowAPI.Dialog(_, opts)
    local dlgState = {
        Title = opts.Title,
        Content = opts.Content,
        Icon = opts.Icon,
        Buttons = opts.Buttons or {},
        Size = nil,
        PressDecreaseSize = UDim2.fromOffset(5, 5),
    }

    local dlg = Templates.DialogElements.Dialog:Clone()
    local overlay = Templates.DialogElements.DarkOverlayDialog:Clone()

    dlg.Title.TextLabel.Text = dlgState.Title
    if dlgState.Content and dlgState.Content ~= '' then
        dlg.Content.Visible = true
        dlg.Content.TextLabel.Text = dlgState.Content
    end

    if dlgState.Icon then
        if string.find(dlgState.Icon, 'rbxassetid') or string.match(dlgState.Icon, '%d') then
            dlg.Title.Icon.Image = dlgState.Icon
        else
            dlg.Title.Icon.Image = (h.Icon(dlgState.Icon) and h.Icon(dlgState.Icon)[1]) or dlgState.Icon or ''
            dlg.Title.Icon.ImageRectOffset = (h.Icon(dlgState.Icon) and h.Icon(dlgState.Icon)[2].ImageRectPosition) or Vector2.new(0, 0)
            dlg.Title.Icon.ImageRectSize   = (h.Icon(dlgState.Icon) and h.Icon(dlgState.Icon)[2].ImageRectSize) or Vector2.new(0, 0)
        end
        dlg.Title.Icon.Visible = true
    end

    dlg.Parent = WindowGui
    overlay.Parent = WindowGui
    dlgState.Size = UDim2.fromOffset(dlg.AbsoluteSize.X, dlg.AbsoluteSize.Y)
    overlay.Transparency = 1

    for _, btnDef in dlgState.Buttons do
        local btnState = {
            Title = btnDef.Title or 'Button',
            Callback = btnDef.Callback or function() end,
        }
        local btnGui = Templates.DialogElements.DialogButton:Clone()
        local originalSize = btnGui.Button.Size
        btnGui.Button.Label.Text = btnState.Title

        btnGui.Button.MouseButton1Click:Connect(function()
            btnState.Callback()
            local tw = tween(overlay, { Transparency = 1 }, TweenGlobal)
            dlg:Destroy()
            tw.Completed:Wait()
            overlay:Destroy()
        end)
        btnGui.Button.MouseButton1Down:Connect(function()
            tween(btnGui.Button, { Size = originalSize - dlgState.PressDecreaseSize }, TweenGlobal)
        end)
        btnGui.Button.MouseButton1Up:Connect(function()
            tween(btnGui.Button, { Size = originalSize }, TweenGlobal)
        end)
        btnGui.Button.MouseLeave:Connect(function()
            tween(btnGui.Button, { Size = originalSize }, TweenGlobal)
        end)

        btnGui.Parent = dlg.Buttons
        btnGui.Visible = true
    end

    tween(overlay, { Transparency = 0.6 }, TweenGlobal)
    dlg.Visible = true
    overlay.Visible = true
    return dlgState
end

-- === Window show/hide/maximize logic ===
local originalOpenBtnSize, targetWindowSize, savedWindowSize, savedWindowPos, isMaximized, dragHandle =
    OpenButtonGui.Size, WindowAPI.Size, WindowAPI.Size, WindowGui.Position, false, MakeDraggable(WindowGui.TopFrame, WindowGui)

MakeDraggable(OpenButtonGui, OpenButtonGui)

WindowGui.Visible = true
WindowGui.Size = UDim2.fromOffset(0, 0)

local isWindowVisible, guard = WindowGui.Visible, false

local function toggleWindow(force)
    if force == true then
        savedOpenButtonSize = OpenButtonGui.Size
        WindowGui.Size = UDim2.fromOffset(0, 0)
        WindowGui.Visible = true
        tween(OpenButtonGui, { Size = UDim2.new(0, 0, 0, 0) }, TweenGlobal)
        tween(WindowGui, { Size = targetWindowSize }, TweenGlobal).Completed:Wait()
        WindowGui.Tabs.Visible = true
        WindowGui.TabButtons.Visible = true
        OpenButtonGui.Visible = false

    elseif force == false then
        targetWindowSize = WindowGui.Size
        OpenButtonGui.Size = UDim2.fromOffset(0, 0)
        OpenButtonGui.Visible = true
        WindowGui.Tabs.Visible = false
        WindowGui.TabButtons.Visible = false
        tween(OpenButtonGui, { Size = originalOpenBtnSize }, TweenGlobal)
        tween(WindowGui, { Size = UDim2.fromOffset(0, 0) }, TweenGlobal).Completed:Wait()
        WindowGui.Visible = false

    else
        if isWindowVisible then
            targetWindowSize = WindowGui.Size
            OpenButtonGui.Size = UDim2.fromOffset(0, 0)
            OpenButtonGui.Visible = true
            WindowGui.Tabs.Visible = false
            WindowGui.TabButtons.Visible = false
            WindowGui.DropShadow.Visible = false
            tween(OpenButtonGui, { Size = originalOpenBtnSize }, TweenGlobal)
            tween(WindowGui, { Size = UDim2.fromOffset(0, 0) }, TweenGlobal).Completed:Wait()
            WindowGui.Visible = false
            isWindowVisible = false
        else
            savedOpenButtonSize = OpenButtonGui.Size
            WindowGui.Size = UDim2.fromOffset(0, 0)
            WindowGui.Visible = true
            WindowGui.DropShadow.Visible = true
            tween(OpenButtonGui, { Size = UDim2.new(0, 0, 0, 0) }, TweenGlobal)
            tween(WindowGui, { Size = targetWindowSize }, TweenGlobal).Completed:Wait()
            WindowGui.Tabs.Visible = true
            WindowGui.TabButtons.Visible = true
            OpenButtonGui.Visible = false
            isWindowVisible = true
        end
    end
end

WindowGui.TopFrame.Hide.MouseButton1Click:Connect(function()
    if not guard then
        guard = true
        toggleWindow(false)
        task.delay(TweenGlobal.Duration, function() guard = false end)
    end
end)

OpenButtonGui.Open.MouseButton1Click:Connect(function()
    if not guard then
        guard = true
        toggleWindow(true)
        task.delay(TweenGlobal.Duration, function() guard = false end)
    end
end)

WindowGui.TopFrame.Close.MouseButton1Click:Connect(function()
    WindowAPI:Dialog{
        Icon = 'triangle-alert',
        Title = 'Close Window',
        Content = [[Do you want to close this window? You will not able to open it again.]],
        Buttons = {
            { Title = 'Cancel' },
            {
                Title = 'Close Window',
                Callback = function()
                    RootGui.Parent = nil
                end
            }
        }
    }
end)

WindowGui.TopFrame.Maximize.MouseButton1Click:Connect(function()
    if not isMaximized then
        dragHandle:SetAllowDragging(false)
        savedWindowSize = WindowGui.Size
        savedWindowPos = WindowGui.Position
        tween(WindowGui, { Size = UDim2.new(1, 0, 1, 0) }, TweenGlobal)
        tween(WindowGui, { Position = UDim2.new(0.5, 0, 0.5, 0) }, TweenGlobal)
        tween(WindowGui.UICorner, { CornerRadius = UDim.new(0, 0) }, TweenGlobal)
        isMaximized = true
    else
        dragHandle:SetAllowDragging(true)
        tween(WindowGui, { Size = savedWindowSize }, TweenGlobal)
        tween(WindowGui, { Position = savedWindowPos }, TweenGlobal)
        tween(WindowGui.UICorner, { CornerRadius = UDim.new(0, 10) }, TweenGlobal)
        isMaximized = false
    end
end)

tween(WindowGui, { Size = targetWindowSize }, TweenGlobal)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not guard and not gpe and input.KeyCode == WindowAPI.ToggleKey then
        guard = true
        toggleWindow()
        task.delay(TweenGlobal.Duration, function() guard = false end)
    end
end)

return WindowAPI


-- === Notifications ===
function Library.Notify(_, opts)
    local api = {}
    local data = {
        Title    = opts.Title,
        Content  = opts.Content,
        Icon     = opts.Icon,
        Duration = opts.Duration or 5,
    }
    local notifGui = Templates.Notification:Clone()

    if #Windows == 1 and Windows[1].Visible and Windows[1].Tabs.Visible then
        notifGui.Parent = Windows[1].NotificationFrame.NotificationList
    else
        notifGui.Parent = GlobalNotifyHolder.NotificationList
    end

    notifGui.Items.Frame.Title.Text = data.Title
    notifGui.Items.Frame.Content.Text = data.Content
    notifGui.Items.Frame.Title.Icon.Image = (h.Icon(data.Icon) and h.Icon(data.Icon)[1]) or data.Icon or ''
    notifGui.Items.Frame.Title.Icon.ImageRectOffset = (h.Icon(data.Icon) and h.Icon(data.Icon)[2].ImageRectPosition) or Vector2.new(0, 0)
    notifGui.Items.Frame.Title.Icon.ImageRectSize   = (h.Icon(data.Icon) and h.Icon(data.Icon)[2].ImageRectSize) or Vector2.new(0, 0)

    notifGui.Items.Position = UDim2.new(0.75, 0, 0, 0)
    notifGui.Visible = true

    local function closeNow()
        if notifGui then
            tween(notifGui.Items, { Position = UDim2.new(0.75, 0, 0, 0) }, TweenNotify)
            task.wait(TweenNotify.Duration - (TweenNotify.Duration / 2))
            if notifGui then notifGui:Destroy() end
            notifGui = nil
        end
    end

    notifGui.Items.Frame.Title.Close.MouseButton1Click:Connect(closeNow)

    local twIn = tween(notifGui.Items, { Position = UDim2.new(0, 0, 0, 0) }, TweenNotify)
    twIn.Completed:Connect(function()
        tween(notifGui.Items.TimerBarFill.Bar, { Size = UDim2.new(0, 0, 1, 0) }, { Duration = data.Duration })
        task.delay(data.Duration, closeNow)
    end)

    function api.Close()
        closeNow()
    end

    return api
end

-- ====== (Stub) Library Module: Lucide GetIcon (Obsidian-style) ======
-- Taruh fungsi ini di modul utama Library kamu (bagian public API).
-- Di sini disisipkan agar blok awal punya referensi yang sama.
local _LucideOK, _Lucide = pcall(function()
    return loadstring(
        game:HttpGet("https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua")
    )()
end)

local Library = rawget(Gui, "_Library") or {}
Gui._Library = Library

function Library:GetIcon(IconName: string)
    if not _LucideOK then return end
    local ok, asset = pcall(_Lucide.GetAsset, IconName)
    if not ok then return end
    return asset -- { Url, ImageRectOffset, ImageRectSize }
end

-- return handle (optional tergantung arsitektur kamu)
return Gui