-- ==============================
-- NAT HUB UI LIBRARY - REWRITE
-- Struktur jelas tanpa modifikasi nilai asli
-- ==============================

-- Konstanta Warna (dipisah untuk kemudahan)
local COLORS = {
    BackgroundDark = Color3.fromRGB(37, 40, 47),
    BackgroundDarker = Color3.fromRGB(32, 35, 41),
    Border = Color3.fromRGB(61, 61, 75),
    Text = Color3.fromRGB(197, 204, 219),
    BorderLight = Color3.fromRGB(95, 95, 117),
    TextDisabled = Color3.fromRGB(135, 140, 150),
    GradientBlue1 = Color3.fromRGB(110, 212, 255),
    GradientBlue2 = Color3.fromRGB(0, 124, 255),
    GradientBlue3 = Color3.fromRGB(0, 218, 255)
}

-- ==============================
-- KOMPONEN UTAMA
-- ==============================

local UI = {} -- Tabel utama untuk menyimpan semua elemen UI

-- 1. ScreenGui (Container Utama)
UI.ScreenGui = Instance.new("ScreenGui")
UI.ScreenGui.Name = "NatHub"
UI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.ScreenGui.ResetOnSpawn = false

-- Fungsi utilitas untuk referensi
local cloneRef = cloneref or function(...) return ... end

-- Penempatan GUI dengan fallback
if protect_gui then
    protect_gui(UI.ScreenGui)
elseif gethui then
    UI.ScreenGui.Parent = gethui()
elseif pcall(function() game.CoreGui:GetChildren() end) then
    UI.ScreenGui.Parent = cloneRef(game:GetService("CoreGui"))
else
    UI.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- 2. Window Utama
UI.MainWindow = Instance.new("Frame", UI.ScreenGui)
UI.MainWindow.Name = "Window"
UI.MainWindow.ZIndex = 0
UI.MainWindow.BorderSizePixel = 2
UI.MainWindow.BackgroundColor3 = COLORS.BackgroundDark
UI.MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
UI.MainWindow.Size = UDim2.new(0, 528, 0, 334)
UI.MainWindow.Position = UDim2.new(0.5278, 0, 0.5, 0)
UI.MainWindow.BorderColor3 = COLORS.Border

-- Sudut melengkung window
UI.WindowCorner = Instance.new("UICorner", UI.MainWindow)
UI.WindowCorner.CornerRadius = UDim.new(0, 10)

-- ==============================
-- KOMPONEN DROPDOWN
-- ==============================

-- 3. Container Dropdown
UI.DropdownContainer = Instance.new("Frame", UI.MainWindow)
UI.DropdownContainer.Name = "DropdownSelection"
UI.DropdownContainer.Visible = false -- Awalnya tersembunyi
UI.DropdownContainer.ZIndex = 4
UI.DropdownContainer.BorderSizePixel = 0
UI.DropdownContainer.BackgroundColor3 = COLORS.BackgroundDarker
UI.DropdownContainer.AnchorPoint = Vector2.new(0.5, 0.5)
UI.DropdownContainer.ClipsDescendants = true
UI.DropdownContainer.Size = UDim2.new(0.7281, 0, 0.68367, 0)
UI.DropdownContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.DropdownContainer.BorderColor3 = COLORS.Border

-- Sudut melengkung dropdown
UI.DropdownCorner = Instance.new("UICorner", UI.DropdownContainer)
UI.DropdownCorner.CornerRadius = UDim.new(0, 6)

-- Stroke dropdown
UI.DropdownStroke = Instance.new("UIStroke", UI.DropdownContainer)
UI.DropdownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.DropdownStroke.Thickness = 1.5
UI.DropdownStroke.Color = COLORS.Border

-- 4. TopBar Dropdown
UI.DropdownTopBar = Instance.new("Frame", UI.DropdownContainer)
UI.DropdownTopBar.Name = "TopBar"
UI.DropdownTopBar.BorderSizePixel = 0
UI.DropdownTopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownTopBar.BackgroundTransparency = 1
UI.DropdownTopBar.Size = UDim2.new(1, 0, 0, 50)
UI.DropdownTopBar.Position = UDim2.new(0, 0, 0, 0)
UI.DropdownTopBar.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- 5. Input Box di Dropdown
UI.DropdownInputContainer = Instance.new("Frame", UI.DropdownTopBar)
UI.DropdownInputContainer.Name = "BoxFrame"
UI.DropdownInputContainer.BorderSizePixel = 0
UI.DropdownInputContainer.BackgroundTransparency = 1
UI.DropdownInputContainer.AnchorPoint = Vector2.new(1, 0.5)
UI.DropdownInputContainer.Size = UDim2.new(0, 120, 0, 25)
UI.DropdownInputContainer.Position = UDim2.new(1, -50, 0.5, 0)

-- Shadow untuk input box
UI.DropdownInputShadow = Instance.new("ImageLabel", UI.DropdownInputContainer)
UI.DropdownInputShadow.Name = "DropShadow"
UI.DropdownInputShadow.ZIndex = 0
UI.DropdownInputShadow.BorderSizePixel = 0
UI.DropdownInputShadow.SliceCenter = Rect.new(49, 49, 450, 450)
UI.DropdownInputShadow.ScaleType = Enum.ScaleType.Slice
UI.DropdownInputShadow.ImageTransparency = 0.75
UI.DropdownInputShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownInputShadow.AnchorPoint = Vector2.new(0.5, 0.5)
UI.DropdownInputShadow.Image = "rbxassetid://6014261993"
UI.DropdownInputShadow.Size = UDim2.new(1, 30, 1, 30)
UI.DropdownInputShadow.BackgroundTransparency = 1
UI.DropdownInputShadow.Position = UDim2.new(0.5, 0, 0.5, 0)

-- Background input box
UI.DropdownInputBackground = Instance.new("Frame", UI.DropdownInputContainer)
UI.DropdownInputBackground.BorderSizePixel = 0
UI.DropdownInputBackground.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.DropdownInputBackground.AutomaticSize = Enum.AutomaticSize.Y
UI.DropdownInputBackground.Size = UDim2.new(1, 0, 1, 0)
UI.DropdownInputBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung input
UI.DropdownInputCorner = Instance.new("UICorner", UI.DropdownInputBackground)
UI.DropdownInputCorner.CornerRadius = UDim.new(0, 5)

-- Stroke input
UI.DropdownInputStroke = Instance.new("UIStroke", UI.DropdownInputBackground)
UI.DropdownInputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.DropdownInputStroke.Thickness = 1.5
UI.DropdownInputStroke.Color = COLORS.Border

-- TextBox input
UI.DropdownInput = Instance.new("TextBox", UI.DropdownInputBackground)
UI.DropdownInput.TextXAlignment = Enum.TextXAlignment.Left
UI.DropdownInput.BorderSizePixel = 0
UI.DropdownInput.TextWrapped = true
UI.DropdownInput.TextTruncate = Enum.TextTruncate.AtEnd
UI.DropdownInput.TextSize = 14
UI.DropdownInput.TextColor3 = COLORS.Text
UI.DropdownInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownInput.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.DropdownInput.ClipsDescendants = true
UI.DropdownInput.PlaceholderText = "Input here..."
UI.DropdownInput.Size = UDim2.new(1, -25, 1, 0)
UI.DropdownInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownInput.Text = ""
UI.DropdownInput.BackgroundTransparency = 1

-- Padding input
UI.DropdownInputPadding = Instance.new("UIPadding", UI.DropdownInput)
UI.DropdownInputPadding.PaddingTop = UDim.new(0, 10)
UI.DropdownInputPadding.PaddingRight = UDim.new(0, 10)
UI.DropdownInputPadding.PaddingLeft = UDim.new(0, 10)
UI.DropdownInputPadding.PaddingBottom = UDim.new(0, 10)

-- Tombol clear input
UI.DropdownClearButton = Instance.new("ImageButton", UI.DropdownInputBackground)
UI.DropdownClearButton.BorderSizePixel = 0
UI.DropdownClearButton.BackgroundTransparency = 1
UI.DropdownClearButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownClearButton.ImageColor3 = COLORS.Text
UI.DropdownClearButton.AnchorPoint = Vector2.new(1, 0.5)
UI.DropdownClearButton.Image = "rbxassetid://86928976705683"
UI.DropdownClearButton.Size = UDim2.new(0, 15, 0, 15)
UI.DropdownClearButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownClearButton.Position = UDim2.new(1, -5, 0.5, 0)

-- 6. Tombol Close Dropdown
UI.DropdownCloseButton = Instance.new("ImageButton", UI.DropdownTopBar)
UI.DropdownCloseButton.Name = "Close"
UI.DropdownCloseButton.BorderSizePixel = 0
UI.DropdownCloseButton.BackgroundTransparency = 1
UI.DropdownCloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownCloseButton.ImageColor3 = COLORS.Text
UI.DropdownCloseButton.ZIndex = 0
UI.DropdownCloseButton.AnchorPoint = Vector2.new(1, 0.5)
UI.DropdownCloseButton.Image = "rbxassetid://132453323679056"
UI.DropdownCloseButton.Size = UDim2.new(0, 25, 0, 25)
UI.DropdownCloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownCloseButton.Position = UDim2.new(1, -12, 0.5, 0)

-- 7. Judul Dropdown
UI.DropdownTitle = Instance.new("TextLabel", UI.DropdownTopBar)
UI.DropdownTitle.Name = "Title"
UI.DropdownTitle.TextWrapped = true
UI.DropdownTitle.Interactable = false
UI.DropdownTitle.ZIndex = 0
UI.DropdownTitle.BorderSizePixel = 0
UI.DropdownTitle.TextSize = 18
UI.DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.DropdownTitle.TextScaled = true
UI.DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.DropdownTitle.TextColor3 = COLORS.Text
UI.DropdownTitle.BackgroundTransparency = 1
UI.DropdownTitle.AnchorPoint = Vector2.new(0, 0.5)
UI.DropdownTitle.Size = UDim2.new(0.5, 0, 0, 18)
UI.DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownTitle.Text = "Dropdown"
UI.DropdownTitle.Position = UDim2.new(0, 12, 0.5, 0)

-- 8. Folder untuk item dropdown
UI.DropdownItems = Instance.new("Folder", UI.DropdownContainer)
UI.DropdownItems.Name = "Dropdowns"

-- ==============================
-- KOMPONEN TAB BUTTONS
-- ==============================

-- 9. Container Tab Buttons
UI.TabButtonsContainer = Instance.new("Frame", UI.MainWindow)
UI.TabButtonsContainer.Name = "TabButtons"
UI.TabButtonsContainer.BorderSizePixel = 0
UI.TabButtonsContainer.BackgroundColor3 = COLORS.BackgroundDark
UI.TabButtonsContainer.ClipsDescendants = true
UI.TabButtonsContainer.Size = UDim2.new(0, 165, 1, -35)
UI.TabButtonsContainer.Position = UDim2.new(0, 0, 0, 35)
UI.TabButtonsContainer.BorderColor3 = COLORS.Border
UI.TabButtonsContainer.SelectionGroup = true

-- 10. ScrollingFrame untuk list tab
UI.TabList = Instance.new("ScrollingFrame", UI.TabButtonsContainer)
UI.TabList.Name = "Lists"
UI.TabList.Active = true
UI.TabList.ScrollingDirection = Enum.ScrollingDirection.Y
UI.TabList.BorderSizePixel = 0
UI.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
UI.TabList.ElasticBehavior = Enum.ElasticBehavior.Never
UI.TabList.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
UI.TabList.BackgroundColor3 = COLORS.BackgroundDark
UI.TabList.Selectable = false
UI.TabList.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
UI.TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.TabList.Size = UDim2.new(1, 0, 1, 0)
UI.TabList.BorderColor3 = COLORS.Border
UI.TabList.ScrollBarThickness = 4
UI.TabList.BackgroundTransparency = 1

-- Layout untuk tab list
UI.TabListLayout = Instance.new("UIListLayout", UI.TabList)
UI.TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 11. Template Tab Button (Aktif)
UI.TabButtonTemplate = Instance.new("Frame", UI.TabList)
UI.TabButtonTemplate.Name = "TabButton"
UI.TabButtonTemplate.Visible = false
UI.TabButtonTemplate.BorderSizePixel = 0
UI.TabButtonTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TabButtonTemplate.Size = UDim2.new(1, 0, 0, 36)
UI.TabButtonTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
UI.TabButtonTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TabButtonTemplate.BackgroundTransparency = 1

-- Bar indikator tab aktif
UI.TabButtonBar = Instance.new("Frame", UI.TabButtonTemplate)
UI.TabButtonBar.Name = "Bar"
UI.TabButtonBar.BorderSizePixel = 0
UI.TabButtonBar.BackgroundColor3 = COLORS.Text
UI.TabButtonBar.AnchorPoint = Vector2.new(0, 0.5)
UI.TabButtonBar.Size = UDim2.new(0, 5, 0, 25)
UI.TabButtonBar.Position = UDim2.new(0, 8, 0, 18)
UI.TabButtonBar.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Gradien untuk bar (dinonaktifkan default)
UI.TabButtonBarGradient = Instance.new("UIGradient", UI.TabButtonBar)
UI.TabButtonBarGradient.Enabled = false
UI.TabButtonBarGradient.Rotation = 90
UI.TabButtonBarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLORS.GradientBlue1),
    ColorSequenceKeypoint.new(0.978, COLORS.GradientBlue2),
    ColorSequenceKeypoint.new(1, COLORS.GradientBlue3)
}

-- Sudut melengkung bar
UI.TabButtonBarCorner = Instance.new("UICorner", UI.TabButtonBar)
UI.TabButtonBarCorner.CornerRadius = UDim.new(0, 100)

-- Ikon tab
UI.TabButtonIcon = Instance.new("ImageButton", UI.TabButtonTemplate)
UI.TabButtonIcon.BorderSizePixel = 0
UI.TabButtonIcon.BackgroundTransparency = 1
UI.TabButtonIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TabButtonIcon.ImageColor3 = COLORS.Text
UI.TabButtonIcon.AnchorPoint = Vector2.new(0, 0.5)
UI.TabButtonIcon.Image = "rbxassetid://113216930555884"
UI.TabButtonIcon.Size = UDim2.new(0, 31, 0, 30)
UI.TabButtonIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TabButtonIcon.Position = UDim2.new(0, 21, 0, 18)

-- Aspect ratio untuk ikon
UI.TabButtonIconRatio = Instance.new("UIAspectRatioConstraint", UI.TabButtonIcon)

-- Label tab
UI.TabButtonLabel = Instance.new("TextLabel", UI.TabButtonTemplate)
UI.TabButtonLabel.TextWrapped = true
UI.TabButtonLabel.BorderSizePixel = 0
UI.TabButtonLabel.TextSize = 14
UI.TabButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
UI.TabButtonLabel.TextScaled = true
UI.TabButtonLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TabButtonLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.TabButtonLabel.TextColor3 = COLORS.Text
UI.TabButtonLabel.BackgroundTransparency = 1
UI.TabButtonLabel.AnchorPoint = Vector2.new(0, 0.5)
UI.TabButtonLabel.Size = UDim2.new(0, 88, 0, 16)
UI.TabButtonLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TabButtonLabel.Text = "NatHub"
UI.TabButtonLabel.Position = UDim2.new(0, 57, 0.5, 0)

-- Padding untuk tab list
UI.TabListPadding = Instance.new("UIPadding", UI.TabList)
UI.TabListPadding.PaddingTop = UDim.new(0, 8)

-- 12. Template Divider
UI.DividerTemplate = Instance.new("Frame", UI.TabList)
UI.DividerTemplate.Name = "Divider"
UI.DividerTemplate.Visible = false
UI.DividerTemplate.BorderSizePixel = 0
UI.DividerTemplate.BackgroundColor3 = COLORS.Border
UI.DividerTemplate.Size = UDim2.new(1, 0, 0, 1)
UI.DividerTemplate.BorderColor3 = COLORS.Border

-- 13. Template Tab Button (Non-Aktif)
UI.TabButtonInactiveTemplate = Instance.new("ImageButton", UI.TabList)
UI.TabButtonInactiveTemplate.Name = "TabButton"
UI.TabButtonInactiveTemplate.Active = false
UI.TabButtonInactiveTemplate.BorderSizePixel = 0
UI.TabButtonInactiveTemplate.AutoButtonColor = false
UI.TabButtonInactiveTemplate.Visible = false
UI.TabButtonInactiveTemplate.BackgroundTransparency = 1
UI.TabButtonInactiveTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TabButtonInactiveTemplate.Selectable = false
UI.TabButtonInactiveTemplate.Size = UDim2.new(1, 0, 0, 36)
UI.TabButtonInactiveTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Ikon tab non-aktif
UI.TabButtonInactiveIcon = Instance.new("ImageButton", UI.TabButtonInactiveTemplate)
UI.TabButtonInactiveIcon.BorderSizePixel = 0
UI.TabButtonInactiveIcon.ImageTransparency = 0.5
UI.TabButtonInactiveIcon.BackgroundTransparency = 1
UI.TabButtonInactiveIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TabButtonInactiveIcon.ImageColor3 = COLORS.Text
UI.TabButtonInactiveIcon.AnchorPoint = Vector2.new(0, 0.5)
UI.TabButtonInactiveIcon.Image = "rbxassetid://113216930555884"
UI.TabButtonInactiveIcon.Size = UDim2.new(0, 31, 0, 30)
UI.TabButtonInactiveIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TabButtonInactiveIcon.Position = UDim2.new(0, 6, 0, 18)

-- Aspect ratio untuk ikon non-aktif
UI.TabButtonInactiveIconRatio = Instance.new("UIAspectRatioConstraint", UI.TabButtonInactiveIcon)

-- Label tab non-aktif
UI.TabButtonInactiveLabel = Instance.new("TextLabel", UI.TabButtonInactiveTemplate)
UI.TabButtonInactiveLabel.TextWrapped = true
UI.TabButtonInactiveLabel.BorderSizePixel = 0
UI.TabButtonInactiveLabel.TextSize = 14
UI.TabButtonInactiveLabel.TextXAlignment = Enum.TextXAlignment.Left
UI.TabButtonInactiveLabel.TextTransparency = 0.5
UI.TabButtonInactiveLabel.TextScaled = true
UI.TabButtonInactiveLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TabButtonInactiveLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.TabButtonInactiveLabel.TextColor3 = COLORS.Text
UI.TabButtonInactiveLabel.BackgroundTransparency = 1
UI.TabButtonInactiveLabel.AnchorPoint = Vector2.new(0, 0.5)
UI.TabButtonInactiveLabel.Size = UDim2.new(0, 103, 0, 16)
UI.TabButtonInactiveLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TabButtonInactiveLabel.Text = "NatHub"
UI.TabButtonInactiveLabel.Position = UDim2.new(0, 42, 0.5, 0)

-- Bar untuk tab non-aktif (tersembunyi)
UI.TabButtonInactiveBar = Instance.new("Frame", UI.TabButtonInactiveTemplate)
UI.TabButtonInactiveBar.Name = "Bar"
UI.TabButtonInactiveBar.BorderSizePixel = 0
UI.TabButtonInactiveBar.BackgroundColor3 = COLORS.Text
UI.TabButtonInactiveBar.AnchorPoint = Vector2.new(0, 0.5)
UI.TabButtonInactiveBar.Size = UDim2.new(0, 5, 0, 0)
UI.TabButtonInactiveBar.Position = UDim2.new(0, 8, 0, 18)
UI.TabButtonInactiveBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TabButtonInactiveBar.BackgroundTransparency = 1

-- Sudut melengkung bar non-aktif
UI.TabButtonInactiveBarCorner = Instance.new("UICorner", UI.TabButtonInactiveBar)
UI.TabButtonInactiveBarCorner.CornerRadius = UDim.new(0, 100)

-- 14. Detail Tab Buttons Container
UI.TabButtonsCorner = Instance.new("UICorner", UI.TabButtonsContainer)
UI.TabButtonsCorner.CornerRadius = UDim.new(0, 6)

-- Anti Corner untuk tab buttons
UI.TabButtonsAntiCornerTop = Instance.new("Frame", UI.TabButtonsContainer)
UI.TabButtonsAntiCornerTop.Name = "AntiCornerTop"
UI.TabButtonsAntiCornerTop.BorderSizePixel = 0
UI.TabButtonsAntiCornerTop.BackgroundColor3 = COLORS.BackgroundDark
UI.TabButtonsAntiCornerTop.Size = UDim2.new(1, 0, 0, 5)
UI.TabButtonsAntiCornerTop.BorderColor3 = Color3.fromRGB(0, 0, 0)

UI.TabButtonsAntiCornerRight = Instance.new("Frame", UI.TabButtonsContainer)
UI.TabButtonsAntiCornerRight.Name = "AntiCornerRight"
UI.TabButtonsAntiCornerRight.BorderSizePixel = 0
UI.TabButtonsAntiCornerRight.BackgroundColor3 = COLORS.BackgroundDark
UI.TabButtonsAntiCornerRight.AnchorPoint = Vector2.new(0.5, 0)
UI.TabButtonsAntiCornerRight.Size = UDim2.new(0, 2, 1, 0)
UI.TabButtonsAntiCornerRight.Position = UDim2.new(1, 1, 0, 0)
UI.TabButtonsAntiCornerRight.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Border untuk tab buttons
UI.TabButtonsBorder = Instance.new("Frame", UI.TabButtonsContainer)
UI.TabButtonsBorder.Name = "Border"
UI.TabButtonsBorder.ZIndex = 2
UI.TabButtonsBorder.BorderSizePixel = 0
UI.TabButtonsBorder.BackgroundColor3 = COLORS.Border
UI.TabButtonsBorder.AnchorPoint = Vector2.new(1, 0)
UI.TabButtonsBorder.Size = UDim2.new(0, 2, 1, 0)
UI.TabButtonsBorder.Position = UDim2.new(1, 0, 0, 0)
UI.TabButtonsBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- ==============================
-- TOP FRAME WINDOW
-- ==============================

-- 15. Top Frame Window
UI.TopFrame = Instance.new("Frame", UI.MainWindow)
UI.TopFrame.Name = "TopFrame"
UI.TopFrame.BorderSizePixel = 0
UI.TopFrame.BackgroundColor3 = COLORS.BackgroundDark
UI.TopFrame.ClipsDescendants = true
UI.TopFrame.Size = UDim2.new(1, 0, 0, 35)
UI.TopFrame.Position = UDim2.new(0, 0, 0, 0)
UI.TopFrame.BorderColor3 = COLORS.Border

-- Ikon aplikasi
UI.AppIcon = Instance.new("ImageButton", UI.TopFrame)
UI.AppIcon.Name = "Icon"
UI.AppIcon.Active = false
UI.AppIcon.Interactable = false
UI.AppIcon.BorderSizePixel = 0
UI.AppIcon.BackgroundTransparency = 1
UI.AppIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.AppIcon.AnchorPoint = Vector2.new(0, 0.5)
UI.AppIcon.Image = "rbxassetid://113216930555884"
UI.AppIcon.Size = UDim2.new(0, 25, 0, 25)
UI.AppIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.AppIcon.Position = UDim2.new(0, 10, 0.5, 0)

-- Aspect ratio untuk ikon
UI.AppIconRatio = Instance.new("UIAspectRatioConstraint", UI.AppIcon)

-- Judul aplikasi
UI.AppTitle = Instance.new("TextLabel", UI.TopFrame)
UI.AppTitle.TextWrapped = true
UI.AppTitle.Interactable = false
UI.AppTitle.BorderSizePixel = 0
UI.AppTitle.TextSize = 14
UI.AppTitle.TextScaled = true
UI.AppTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.AppTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.AppTitle.TextColor3 = COLORS.Text
UI.AppTitle.BackgroundTransparency = 1
UI.AppTitle.AnchorPoint = Vector2.new(0.5, 0.5)
UI.AppTitle.Size = UDim2.new(1, 0, 0, 16)
UI.AppTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.AppTitle.Text = "NatHub - v1.2.3"
UI.AppTitle.Position = UDim2.new(0.5, 0, 0.5, -1)

-- Tombol Close
UI.CloseButton = Instance.new("ImageButton", UI.TopFrame)
UI.CloseButton.Name = "Close"
UI.CloseButton.BorderSizePixel = 0
UI.CloseButton.BackgroundTransparency = 1
UI.CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CloseButton.ImageColor3 = COLORS.Text
UI.CloseButton.AnchorPoint = Vector2.new(1, 0.5)
UI.CloseButton.Image = "rbxassetid://132453323679056"
UI.CloseButton.Size = UDim2.new(0, 20, 0, 20)
UI.CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.CloseButton.Position = UDim2.new(1, -15, 0.5, 0)

-- Tombol Maximize
UI.MaximizeButton = Instance.new("ImageButton", UI.TopFrame)
UI.MaximizeButton.Name = "Maximize"
UI.MaximizeButton.BorderSizePixel = 0
UI.MaximizeButton.BackgroundTransparency = 1
UI.MaximizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.MaximizeButton.ImageColor3 = COLORS.Text
UI.MaximizeButton.AnchorPoint = Vector2.new(1, 0.5)
UI.MaximizeButton.Image = "rbxassetid://108285848026510"
UI.MaximizeButton.Size = UDim2.new(0, 15, 0, 15)
UI.MaximizeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.MaximizeButton.Position = UDim2.new(1, -55, 0.5, 0)

-- Tombol Hide
UI.HideButton = Instance.new("ImageButton", UI.TopFrame)
UI.HideButton.Name = "Hide"
UI.HideButton.BorderSizePixel = 0
UI.HideButton.BackgroundTransparency = 1
UI.HideButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.HideButton.ImageColor3 = COLORS.Text
UI.HideButton.AnchorPoint = Vector2.new(1, 0.5)
UI.HideButton.Image = "rbxassetid://128209591224511"
UI.HideButton.Size = UDim2.new(0, 20, 0, 20)
UI.HideButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.HideButton.Position = UDim2.new(1, -90, 0.5, 0)

-- Sudut melengkung top frame
UI.TopFrameCorner = Instance.new("UICorner", UI.TopFrame)
UI.TopFrameCorner.CornerRadius = UDim.new(0, 6)

-- Border bawah top frame
UI.TopFrameBorder = Instance.new("Frame", UI.TopFrame)
UI.TopFrameBorder.Name = "Border"
UI.TopFrameBorder.ZIndex = 2
UI.TopFrameBorder.BorderSizePixel = 0
UI.TopFrameBorder.BackgroundColor3 = COLORS.Border
UI.TopFrameBorder.AnchorPoint = Vector2.new(0, 0.5)
UI.TopFrameBorder.Size = UDim2.new(1, 0, 0, 2)
UI.TopFrameBorder.Position = UDim2.new(0, 0, 1, 0)
UI.TopFrameBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- ==============================
-- WINDOW STROKE & TABS
-- ==============================

-- 16. Stroke untuk window utama
UI.WindowStroke = Instance.new("UIStroke", UI.MainWindow)
UI.WindowStroke.Transparency = 0.5
UI.WindowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.WindowStroke.Color = COLORS.BorderLight

-- 17. Area Konten Tab
UI.TabsContainer = Instance.new("Frame", UI.MainWindow)
UI.TabsContainer.Name = "Tabs"
UI.TabsContainer.BorderSizePixel = 0
UI.TabsContainer.BackgroundColor3 = COLORS.BackgroundDarker
UI.TabsContainer.Size = UDim2.new(1, -165, 1, -35)
UI.TabsContainer.Position = UDim2.new(0, 165, 0, 35)
UI.TabsContainer.BorderColor3 = COLORS.Border

-- Sudut melengkung tabs container
UI.TabsCorner = Instance.new("UICorner", UI.TabsContainer)
UI.TabsCorner.CornerRadius = UDim.new(0, 6)

-- Anti Corner untuk tabs
UI.TabsAntiCornerLeft = Instance.new("Frame", UI.TabsContainer)
UI.TabsAntiCornerLeft.Name = "AntiCornerLeft"
UI.TabsAntiCornerLeft.Visible = false
UI.TabsAntiCornerLeft.BorderSizePixel = 0
UI.TabsAntiCornerLeft.BackgroundColor3 = COLORS.BackgroundDarker
UI.TabsAntiCornerLeft.Size = UDim2.new(0, 5, 1, 0)
UI.TabsAntiCornerLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)

UI.TabsAntiCornerTop = Instance.new("Frame", UI.TabsContainer)
UI.TabsAntiCornerTop.Name = "AntiCornerTop"
UI.TabsAntiCornerTop.BorderSizePixel = 0
UI.TabsAntiCornerTop.BackgroundColor3 = COLORS.BackgroundDarker
UI.TabsAntiCornerTop.Size = UDim2.new(1, 0, 0, 5)
UI.TabsAntiCornerTop.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Teks saat tab kosong
UI.EmptyTabText = Instance.new("TextLabel", UI.TabsContainer)
UI.EmptyTabText.Name = "NoObjectFoundText"
UI.EmptyTabText.TextWrapped = true
UI.EmptyTabText.Interactable = false
UI.EmptyTabText.BorderSizePixel = 0
UI.EmptyTabText.TextSize = 14
UI.EmptyTabText.TextScaled = true
UI.EmptyTabText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.EmptyTabText.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.EmptyTabText.TextColor3 = COLORS.TextDisabled
UI.EmptyTabText.BackgroundTransparency = 1
UI.EmptyTabText.AnchorPoint = Vector2.new(0.5, 0.5)
UI.EmptyTabText.Size = UDim2.new(1, 0, 0, 16)
UI.EmptyTabText.Visible = false
UI.EmptyTabText.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.EmptyTabText.Text = "This tab is empty :("
UI.EmptyTabText.Position = UDim2.new(0.5, 0, 0.45, 0)

-- ==============================
-- NOTIFICATION & OVERLAY
-- ==============================

-- 18. Frame untuk notifikasi
UI.NotificationFrame = Instance.new("Frame", UI.MainWindow)
UI.NotificationFrame.Name = "NotificationFrame"
UI.NotificationFrame.BorderSizePixel = 0
UI.NotificationFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.NotificationFrame.ClipsDescendants = true
UI.NotificationFrame.Size = UDim2.new(1, 0, 1, 0)
UI.NotificationFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationFrame.BackgroundTransparency = 1

-- 19. List notifikasi
UI.NotificationList = Instance.new("Frame", UI.NotificationFrame)
UI.NotificationList.Name = "NotificationList"
UI.NotificationList.ZIndex = 5
UI.NotificationList.BorderSizePixel = 0
UI.NotificationList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.NotificationList.AnchorPoint = Vector2.new(0.5, 0)
UI.NotificationList.ClipsDescendants = true
UI.NotificationList.Size = UDim2.new(0, 630, 1, -35)
UI.NotificationList.Position = UDim2.new(1, 0, 0, 35)
UI.NotificationList.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationList.BackgroundTransparency = 1

-- Layout untuk notifikasi
UI.NotificationLayout = Instance.new("UIListLayout", UI.NotificationList)
UI.NotificationLayout.Padding = UDim.new(0, 12)
UI.NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk notifikasi
UI.NotificationPadding = Instance.new("UIPadding", UI.NotificationList)
UI.NotificationPadding.PaddingTop = UDim.new(0, 10)
UI.NotificationPadding.PaddingRight = UDim.new(0, 40)
UI.NotificationPadding.PaddingLeft = UDim.new(0, 40)
UI.NotificationPadding.PaddingBottom = UDim.new(0, 10)

-- 20. Overlay gelap
UI.DarkOverlay = Instance.new("Frame", UI.MainWindow)
UI.DarkOverlay.Name = "DarkOverlay"
UI.DarkOverlay.Visible = false
UI.DarkOverlay.BorderSizePixel = 0
UI.DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
UI.DarkOverlay.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DarkOverlay.BackgroundTransparency = 0.6

-- Sudut melengkung overlay
UI.DarkOverlayCorner = Instance.new("UICorner", UI.DarkOverlay)
UI.DarkOverlayCorner.CornerRadius = UDim.new(0, 10)

-- ==============================
-- MODULE SCRIPTS & TEMPLATES
-- ==============================

-- 21. ModuleScripts
UI.LibraryModule = Instance.new("ModuleScript", UI.ScreenGui)
UI.LibraryModule.Name = "Library"

UI.IconModule = Instance.new("ModuleScript", UI.LibraryModule)
UI.IconModule.Name = "IconModule"

UI.LucideIcons = Instance.new("ModuleScript", UI.IconModule)
UI.LucideIcons.Name = "Lucide"

-- 22. Folder Templates
UI.TemplatesFolder = Instance.new("Folder", UI.ScreenGui)
UI.TemplatesFolder.Name = "Templates"

-- Template Divider
UI.DividerTemplate2 = Instance.new("Frame", UI.TemplatesFolder)
UI.DividerTemplate2.Name = "Divider"
UI.DividerTemplate2.Visible = false
UI.DividerTemplate2.BorderSizePixel = 0
UI.DividerTemplate2.BackgroundColor3 = COLORS.Border
UI.DividerTemplate2.Size = UDim2.new(1, 0, 0, 1)
UI.DividerTemplate2.BorderColor3 = COLORS.Border

-- Template Tab (ScrollingFrame)
UI.TabTemplate = Instance.new("ScrollingFrame", UI.TemplatesFolder)
UI.TabTemplate.Name = "Tab"
UI.TabTemplate.Visible = false
UI.TabTemplate.Active = true
UI.TabTemplate.ScrollingDirection = Enum.ScrollingDirection.Y
UI.TabTemplate.BorderSizePixel = 0
UI.TabTemplate.CanvasSize = UDim2.new(0, 0, 0, 0)
UI.TabTemplate.ElasticBehavior = Enum.ElasticBehavior.Never
UI.TabTemplate.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
UI.TabTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TabTemplate.Selectable = false
UI.TabTemplate.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
UI.TabTemplate.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.TabTemplate.Size = UDim2.new(1, 0, 1, 0)
-- ==============================
-- KELANJUTAN NAT HUB UI LIBRARY - REWRITE
-- ==============================

-- 23. Template Tab (kelanjutan)
UI.TabTemplate.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
UI.TabTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TabTemplate.ScrollBarThickness = 5
UI.TabTemplate.BackgroundTransparency = 1

-- Layout untuk tab template
UI.TabTemplateLayout = Instance.new("UIListLayout", UI.TabTemplate)
UI.TabTemplateLayout.Padding = UDim.new(0, 15)
UI.TabTemplateLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk tab template
UI.TabTemplatePadding = Instance.new("UIPadding", UI.TabTemplate)
UI.TabTemplatePadding.PaddingTop = UDim.new(0, 10)
UI.TabTemplatePadding.PaddingRight = UDim.new(0, 14)
UI.TabTemplatePadding.PaddingLeft = UDim.new(0, 10)
UI.TabTemplatePadding.PaddingBottom = UDim.new(0, 10)

-- 24. Template Tab Button (Alternatif)
UI.TabButtonTemplate2 = Instance.new("ImageButton", UI.TemplatesFolder)
UI.TabButtonTemplate2.Name = "TabButton"
UI.TabButtonTemplate2.Visible = false
UI.TabButtonTemplate2.BorderSizePixel = 0
UI.TabButtonTemplate2.AutoButtonColor = false
UI.TabButtonTemplate2.BackgroundTransparency = 1
UI.TabButtonTemplate2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TabButtonTemplate2.Selectable = false
UI.TabButtonTemplate2.Size = UDim2.new(1, 0, 0, 36)
UI.TabButtonTemplate2.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Ikon untuk tab button template
UI.TabButtonTemplate2Icon = Instance.new("ImageButton", UI.TabButtonTemplate2)
UI.TabButtonTemplate2Icon.BorderSizePixel = 0
UI.TabButtonTemplate2Icon.ImageTransparency = 0.5
UI.TabButtonTemplate2Icon.BackgroundTransparency = 1
UI.TabButtonTemplate2Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TabButtonTemplate2Icon.ImageColor3 = COLORS.Text
UI.TabButtonTemplate2Icon.AnchorPoint = Vector2.new(0, 0.5)
UI.TabButtonTemplate2Icon.Image = "rbxassetid://113216930555884"
UI.TabButtonTemplate2Icon.Size = UDim2.new(0, 20, 0, 20)
UI.TabButtonTemplate2Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TabButtonTemplate2Icon.Position = UDim2.new(0, 12, 0, 18)

-- Aspect ratio untuk ikon
UI.TabButtonTemplate2IconRatio = Instance.new("UIAspectRatioConstraint", UI.TabButtonTemplate2Icon)

-- Label untuk tab button template
UI.TabButtonTemplate2Label = Instance.new("TextLabel", UI.TabButtonTemplate2)
UI.TabButtonTemplate2Label.TextWrapped = true
UI.TabButtonTemplate2Label.BorderSizePixel = 0
UI.TabButtonTemplate2Label.TextSize = 14
UI.TabButtonTemplate2Label.TextXAlignment = Enum.TextXAlignment.Left
UI.TabButtonTemplate2Label.TextTransparency = 0.5
UI.TabButtonTemplate2Label.TextScaled = true
UI.TabButtonTemplate2Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TabButtonTemplate2Label.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.TabButtonTemplate2Label.TextColor3 = COLORS.Text
UI.TabButtonTemplate2Label.BackgroundTransparency = 1
UI.TabButtonTemplate2Label.AnchorPoint = Vector2.new(0, 0.5)
UI.TabButtonTemplate2Label.Size = UDim2.new(0, 103, 0, 16)
UI.TabButtonTemplate2Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TabButtonTemplate2Label.Text = ""
UI.TabButtonTemplate2Label.Position = UDim2.new(0, 42, 0.5, 0)

-- Bar untuk tab button template
UI.TabButtonTemplate2Bar = Instance.new("Frame", UI.TabButtonTemplate2)
UI.TabButtonTemplate2Bar.Name = "Bar"
UI.TabButtonTemplate2Bar.BorderSizePixel = 0
UI.TabButtonTemplate2Bar.BackgroundColor3 = COLORS.Text
UI.TabButtonTemplate2Bar.AnchorPoint = Vector2.new(0, 0.5)
UI.TabButtonTemplate2Bar.Size = UDim2.new(0, 5, 0, 0)
UI.TabButtonTemplate2Bar.Position = UDim2.new(0, 8, 0, 18)
UI.TabButtonTemplate2Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TabButtonTemplate2Bar.BackgroundTransparency = 1

-- Sudut melengkung bar
UI.TabButtonTemplate2BarCorner = Instance.new("UICorner", UI.TabButtonTemplate2Bar)
UI.TabButtonTemplate2BarCorner.CornerRadius = UDim.new(0, 100)

-- 25. Template Button
UI.ButtonTemplate = Instance.new("ImageButton", UI.TemplatesFolder)
UI.ButtonTemplate.Name = "Button"
UI.ButtonTemplate.Visible = false
UI.ButtonTemplate.BorderSizePixel = 0
UI.ButtonTemplate.AutoButtonColor = false
UI.ButtonTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.ButtonTemplate.Selectable = false
UI.ButtonTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.ButtonTemplate.Size = UDim2.new(1, 0, 0, 35)
UI.ButtonTemplate.Position = UDim2.new(-0.0375, 0, 0.384, 0)
UI.ButtonTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung button
UI.ButtonTemplateCorner = Instance.new("UICorner", UI.ButtonTemplate)
UI.ButtonTemplateCorner.CornerRadius = UDim.new(0, 6)

-- Kontainer untuk konten button
UI.ButtonContent = Instance.new("Frame", UI.ButtonTemplate)
UI.ButtonContent.BorderSizePixel = 0
UI.ButtonContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ButtonContent.AutomaticSize = Enum.AutomaticSize.Y
UI.ButtonContent.Size = UDim2.new(1, 0, 0, 35)
UI.ButtonContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ButtonContent.BackgroundTransparency = 1

-- Layout untuk konten button
UI.ButtonContentLayout = Instance.new("UIListLayout", UI.ButtonContent)
UI.ButtonContentLayout.Padding = UDim.new(0, 5)
UI.ButtonContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk konten button
UI.ButtonContentPadding = Instance.new("UIPadding", UI.ButtonContent)
UI.ButtonContentPadding.PaddingTop = UDim.new(0, 10)
UI.ButtonContentPadding.PaddingRight = UDim.new(0, 10)
UI.ButtonContentPadding.PaddingLeft = UDim.new(0, 10)
UI.ButtonContentPadding.PaddingBottom = UDim.new(0, 10)

-- Judul button
UI.ButtonTitle = Instance.new("TextLabel", UI.ButtonContent)
UI.ButtonTitle.Name = "Title"
UI.ButtonTitle.TextWrapped = true
UI.ButtonTitle.Interactable = false
UI.ButtonTitle.BorderSizePixel = 0
UI.ButtonTitle.TextSize = 16
UI.ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ButtonTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.ButtonTitle.TextColor3 = COLORS.Text
UI.ButtonTitle.BackgroundTransparency = 1
UI.ButtonTitle.Size = UDim2.new(1, 0, 0, 15)
UI.ButtonTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ButtonTitle.Text = "Button"

-- Ikon klik pada judul
UI.ButtonClickIcon = Instance.new("ImageButton", UI.ButtonTitle)
UI.ButtonClickIcon.Name = "ClickIcon"
UI.ButtonClickIcon.BorderSizePixel = 0
UI.ButtonClickIcon.AutoButtonColor = false
UI.ButtonClickIcon.BackgroundTransparency = 1
UI.ButtonClickIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ButtonClickIcon.ImageColor3 = COLORS.Text
UI.ButtonClickIcon.AnchorPoint = Vector2.new(1, 0.5)
UI.ButtonClickIcon.Image = "rbxassetid://91877599529856"
UI.ButtonClickIcon.Size = UDim2.new(0, 23, 0, 23)
UI.ButtonClickIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ButtonClickIcon.Position = UDim2.new(1, 0, 0.5, 0)

-- Deskripsi button
UI.ButtonDescription = Instance.new("TextLabel", UI.ButtonContent)
UI.ButtonDescription.Name = "Description"
UI.ButtonDescription.TextWrapped = true
UI.ButtonDescription.Interactable = false
UI.ButtonDescription.BorderSizePixel = 0
UI.ButtonDescription.TextSize = 16
UI.ButtonDescription.TextXAlignment = Enum.TextXAlignment.Left
UI.ButtonDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ButtonDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.ButtonDescription.TextColor3 = COLORS.Text
UI.ButtonDescription.BackgroundTransparency = 1
UI.ButtonDescription.Size = UDim2.new(1, 0, 0, 15)
UI.ButtonDescription.Visible = false
UI.ButtonDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ButtonDescription.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
UI.ButtonDescription.LayoutOrder = 1
UI.ButtonDescription.AutomaticSize = Enum.AutomaticSize.Y

-- Gradien untuk button (3 variasi)
UI.ButtonGradient1 = Instance.new("UIGradient", UI.ButtonContent)
UI.ButtonGradient1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

UI.ButtonGradient2 = Instance.new("UIGradient", UI.ButtonContent)
UI.ButtonGradient2.Enabled = false
UI.ButtonGradient2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

UI.ButtonGradient3 = Instance.new("UIGradient", UI.ButtonContent)
UI.ButtonGradient3.Enabled = false
UI.ButtonGradient3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

-- Sudut melengkung konten button
UI.ButtonContentCorner = Instance.new("UICorner", UI.ButtonContent)
UI.ButtonContentCorner.CornerRadius = UDim.new(0, 6)

-- Stroke untuk button
UI.ButtonStroke = Instance.new("UIStroke", UI.ButtonTemplate)
UI.ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.ButtonStroke.Thickness = 1.5
UI.ButtonStroke.Color = COLORS.Border

-- 26. Template Paragraph
UI.ParagraphTemplate = Instance.new("Frame", UI.TemplatesFolder)
UI.ParagraphTemplate.Name = "Paragraph"
UI.ParagraphTemplate.Visible = false
UI.ParagraphTemplate.BorderSizePixel = 0
UI.ParagraphTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.ParagraphTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.ParagraphTemplate.Size = UDim2.new(1, 0, 0, 35)
UI.ParagraphTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
UI.ParagraphTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung paragraph
UI.ParagraphCorner = Instance.new("UICorner", UI.ParagraphTemplate)
UI.ParagraphCorner.CornerRadius = UDim.new(0, 6)

-- Stroke untuk paragraph
UI.ParagraphStroke = Instance.new("UIStroke", UI.ParagraphTemplate)
UI.ParagraphStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.ParagraphStroke.Thickness = 1.5
UI.ParagraphStroke.Color = COLORS.Border

-- Judul paragraph
UI.ParagraphTitle = Instance.new("TextLabel", UI.ParagraphTemplate)
UI.ParagraphTitle.Name = "Title"
UI.ParagraphTitle.TextWrapped = true
UI.ParagraphTitle.Interactable = false
UI.ParagraphTitle.BorderSizePixel = 0
UI.ParagraphTitle.TextSize = 16
UI.ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.ParagraphTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ParagraphTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
UI.ParagraphTitle.TextColor3 = COLORS.Text
UI.ParagraphTitle.BackgroundTransparency = 1
UI.ParagraphTitle.Size = UDim2.new(1, 0, 0, 15)
UI.ParagraphTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ParagraphTitle.Text = "Title"
UI.ParagraphTitle.AutomaticSize = Enum.AutomaticSize.Y

-- Padding untuk paragraph
UI.ParagraphPadding = Instance.new("UIPadding", UI.ParagraphTemplate)
UI.ParagraphPadding.PaddingTop = UDim.new(0, 10)
UI.ParagraphPadding.PaddingRight = UDim.new(0, 10)
UI.ParagraphPadding.PaddingLeft = UDim.new(0, 10)
UI.ParagraphPadding.PaddingBottom = UDim.new(0, 10)

-- Layout untuk paragraph
UI.ParagraphLayout = Instance.new("UIListLayout", UI.ParagraphTemplate)
UI.ParagraphLayout.Padding = UDim.new(0, 5)
UI.ParagraphLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Deskripsi paragraph
UI.ParagraphDescription = Instance.new("TextLabel", UI.ParagraphTemplate)
UI.ParagraphDescription.Name = "Description"
UI.ParagraphDescription.TextWrapped = true
UI.ParagraphDescription.Interactable = false
UI.ParagraphDescription.BorderSizePixel = 0
UI.ParagraphDescription.TextSize = 16
UI.ParagraphDescription.TextXAlignment = Enum.TextXAlignment.Left
UI.ParagraphDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ParagraphDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.ParagraphDescription.TextColor3 = COLORS.Text
UI.ParagraphDescription.BackgroundTransparency = 1
UI.ParagraphDescription.Size = UDim2.new(1, 0, 0, 15)
UI.ParagraphDescription.Visible = false
UI.ParagraphDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ParagraphDescription.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
UI.ParagraphDescription.LayoutOrder = 1
UI.ParagraphDescription.AutomaticSize = Enum.AutomaticSize.Y

-- 27. Template Toggle
UI.ToggleTemplate = Instance.new("ImageButton", UI.TemplatesFolder)
UI.ToggleTemplate.Name = "Toggle"
UI.ToggleTemplate.Visible = false
UI.ToggleTemplate.BorderSizePixel = 0
UI.ToggleTemplate.AutoButtonColor = false
UI.ToggleTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.ToggleTemplate.Selectable = false
UI.ToggleTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.ToggleTemplate.Size = UDim2.new(1, 0, 0, 35)
UI.ToggleTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
UI.ToggleTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung toggle
UI.ToggleCorner = Instance.new("UICorner", UI.ToggleTemplate)
UI.ToggleCorner.CornerRadius = UDim.new(0, 6)

-- Stroke untuk toggle
UI.ToggleStroke = Instance.new("UIStroke", UI.ToggleTemplate)
UI.ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.ToggleStroke.Thickness = 1.5
UI.ToggleStroke.Color = COLORS.Border

-- Padding untuk toggle
UI.TogglePadding = Instance.new("UIPadding", UI.ToggleTemplate)
UI.TogglePadding.PaddingTop = UDim.new(0, 10)
UI.TogglePadding.PaddingRight = UDim.new(0, 10)
UI.TogglePadding.PaddingLeft = UDim.new(0, 10)
UI.TogglePadding.PaddingBottom = UDim.new(0, 10)

-- Layout untuk toggle
UI.ToggleLayout = Instance.new("UIListLayout", UI.ToggleTemplate)
UI.ToggleLayout.Padding = UDim.new(0, 5)
UI.ToggleLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Deskripsi toggle
UI.ToggleDescription = Instance.new("TextLabel", UI.ToggleTemplate)
UI.ToggleDescription.Name = "Description"
UI.ToggleDescription.TextWrapped = true
UI.ToggleDescription.Interactable = false
UI.ToggleDescription.BorderSizePixel = 0
UI.ToggleDescription.TextSize = 16
UI.ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
UI.ToggleDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ToggleDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.ToggleDescription.TextColor3 = COLORS.Text
UI.ToggleDescription.BackgroundTransparency = 1
UI.ToggleDescription.Size = UDim2.new(1, 0, 0, 15)
UI.ToggleDescription.Visible = false
UI.ToggleDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ToggleDescription.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
UI.ToggleDescription.LayoutOrder = 1
UI.ToggleDescription.AutomaticSize = Enum.AutomaticSize.Y

-- Judul toggle
UI.ToggleTitle = Instance.new("TextLabel", UI.ToggleTemplate)
UI.ToggleTitle.Name = "Title"
UI.ToggleTitle.TextWrapped = true
UI.ToggleTitle.BorderSizePixel = 0
UI.ToggleTitle.TextSize = 16
UI.ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ToggleTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.ToggleTitle.TextColor3 = COLORS.Text
UI.ToggleTitle.BackgroundTransparency = 1
UI.ToggleTitle.Size = UDim2.new(1, 0, 0, 15)
UI.ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ToggleTitle.Text = "Toggle"

-- Toggle switch
UI.ToggleSwitch = Instance.new("ImageButton", UI.ToggleTitle)
UI.ToggleSwitch.Name = "Fill"
UI.ToggleSwitch.BorderSizePixel = 0
UI.ToggleSwitch.AutoButtonColor = false
UI.ToggleSwitch.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
UI.ToggleSwitch.ImageColor3 = COLORS.Text
UI.ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
UI.ToggleSwitch.Size = UDim2.new(0, 45, 0, 25)
UI.ToggleSwitch.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ToggleSwitch.Position = UDim2.new(1, 0, 0.5, 0)

-- Sudut melengkung toggle switch
UI.ToggleSwitchCorner = Instance.new("UICorner", UI.ToggleSwitch)
UI.ToggleSwitchCorner.CornerRadius = UDim.new(100, 0)

-- Ball toggle
UI.ToggleBall = Instance.new("ImageButton", UI.ToggleSwitch)
UI.ToggleBall.Name = "Ball"
UI.ToggleBall.Active = false
UI.ToggleBall.Interactable = false
UI.ToggleBall.BorderSizePixel = 0
UI.ToggleBall.AutoButtonColor = false
UI.ToggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ToggleBall.ImageColor3 = COLORS.Text
UI.ToggleBall.AnchorPoint = Vector2.new(0, 0.5)
UI.ToggleBall.Size = UDim2.new(0, 20, 0, 20)
UI.ToggleBall.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ToggleBall.Position = UDim2.new(0, 0, 0.5, 0)

-- Sudut melengkung ball toggle
UI.ToggleBallCorner = Instance.new("UICorner", UI.ToggleBall)
UI.ToggleBallCorner.CornerRadius = UDim.new(100, 0)

-- Ikon di dalam ball toggle
UI.ToggleBallIcon = Instance.new("ImageLabel", UI.ToggleBall)
UI.ToggleBallIcon.Name = "Icon"
UI.ToggleBallIcon.BorderSizePixel = 0
UI.ToggleBallIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ToggleBallIcon.ImageColor3 = Color3.fromRGB(54, 57, 63)
UI.ToggleBallIcon.AnchorPoint = Vector2.new(0.5, 0.5)
UI.ToggleBallIcon.Size = UDim2.new(1, -5, 1, -5)
UI.ToggleBallIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.ToggleBallIcon.BackgroundTransparency = 1
UI.ToggleBallIcon.Position = UDim2.new(0.5, 0, 0.5, 0)

-- Padding untuk toggle switch
UI.ToggleSwitchPadding = Instance.new("UIPadding", UI.ToggleSwitch)
UI.ToggleSwitchPadding.PaddingTop = UDim.new(0, 2)
UI.ToggleSwitchPadding.PaddingRight = UDim.new(0, 2)
UI.ToggleSwitchPadding.PaddingLeft = UDim.new(0, 2)
UI.ToggleSwitchPadding.PaddingBottom = UDim.new(0, 2)

-- 28. Template Notification
UI.NotificationTemplate = Instance.new("Frame", UI.TemplatesFolder)
UI.NotificationTemplate.Name = "Notification"
UI.NotificationTemplate.Visible = false
UI.NotificationTemplate.BorderSizePixel = 0
UI.NotificationTemplate.BackgroundColor3 = COLORS.BackgroundDark
UI.NotificationTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
UI.NotificationTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.NotificationTemplate.Size = UDim2.new(1, 0, 0, 65)
UI.NotificationTemplate.Position = UDim2.new(0.8244, 0, 0.88221, 0)
UI.NotificationTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationTemplate.BackgroundTransparency = 1

-- Canvas group untuk notification
UI.NotificationCanvas = Instance.new("CanvasGroup", UI.NotificationTemplate)
UI.NotificationCanvas.Name = "Items"
UI.NotificationCanvas.ZIndex = 2
UI.NotificationCanvas.BorderSizePixel = 0
UI.NotificationCanvas.BackgroundColor3 = COLORS.BackgroundDark
UI.NotificationCanvas.AutomaticSize = Enum.AutomaticSize.Y
UI.NotificationCanvas.Size = UDim2.new(0, 265, 0, 70)
UI.NotificationCanvas.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Frame untuk konten notification
UI.NotificationContent = Instance.new("Frame", UI.NotificationCanvas)
UI.NotificationContent.BorderSizePixel = 0
UI.NotificationContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.NotificationContent.AutomaticSize = Enum.AutomaticSize.Y
UI.NotificationContent.Size = UDim2.new(0, 265, 0, 70)
UI.NotificationContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationContent.BackgroundTransparency = 1

-- Layout untuk konten notification
UI.NotificationContentLayout = Instance.new("UIListLayout", UI.NotificationContent)
UI.NotificationContentLayout.Padding = UDim.new(0, 5)
UI.NotificationContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.NotificationContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk konten notification
UI.NotificationContentPadding = Instance.new("UIPadding", UI.NotificationContent)
UI.NotificationContentPadding.PaddingTop = UDim.new(0, 15)
UI.NotificationContentPadding.PaddingLeft = UDim.new(0, 15)
UI.NotificationContentPadding.PaddingBottom = UDim.new(0, 15)

-- Sub konten notification
UI.NotificationSubContent = Instance.new("TextLabel", UI.NotificationContent)
UI.NotificationSubContent.Name = "SubContent"
UI.NotificationSubContent.TextWrapped = true
UI.NotificationSubContent.BorderSizePixel = 0
UI.NotificationSubContent.TextSize = 12
UI.NotificationSubContent.TextXAlignment = Enum.TextXAlignment.Left
UI.NotificationSubContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.NotificationSubContent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI.NotificationSubContent.TextColor3 = Color3.fromRGB(181, 181, 181)
UI.NotificationSubContent.BackgroundTransparency = 1
UI.NotificationSubContent.AnchorPoint = Vector2.new(0, 0.5)
UI.NotificationSubContent.Size = UDim2.new(0, 218, 0, 10)
UI.NotificationSubContent.Visible = false
UI.NotificationSubContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationSubContent.Text = "This is a notification"
UI.NotificationSubContent.LayoutOrder = 1
UI.NotificationSubContent.AutomaticSize = Enum.AutomaticSize.Y
UI.NotificationSubContent.Position = UDim2.new(0, 0, 0, 19)

-- Gradien untuk sub konten notification
UI.NotificationSubContentGradient = Instance.new("UIGradient", UI.NotificationSubContent)
UI.NotificationSubContentGradient.Enabled = false
UI.NotificationSubContentGradient.Rotation = -90
UI.NotificationSubContentGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 226))
}

-- Judul notification
UI.NotificationTitle = Instance.new("TextLabel", UI.NotificationContent)
UI.NotificationTitle.Name = "Title"
UI.NotificationTitle.TextWrapped = true
UI.NotificationTitle.BorderSizePixel = 0
UI.NotificationTitle.TextSize = 16
UI.NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.NotificationTitle.TextScaled = true
UI.NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.NotificationTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
UI.NotificationTitle.TextColor3 = COLORS.Text
UI.NotificationTitle.BackgroundTransparency = 1
UI.NotificationTitle.AnchorPoint = Vector2.new(0, 0.5)
UI.NotificationTitle.Size = UDim2.new(0, 235, 0, 18)
UI.NotificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationTitle.Text = "Title"
UI.NotificationTitle.Position = UDim2.new(0, 0, 0, 9)

-- Tombol close notification
UI.NotificationClose = Instance.new("ImageButton", UI.NotificationTitle)
UI.NotificationClose.Name = "Close"
UI.NotificationClose.BorderSizePixel = 0
UI.NotificationClose.BackgroundTransparency = 1
UI.NotificationClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.NotificationClose.ImageColor3 = COLORS.Text
UI.NotificationClose.AnchorPoint = Vector2.new(0, 0.5)
UI.NotificationClose.Image = "rbxassetid://132453323679056"
UI.NotificationClose.Size = UDim2.new(0.09706, 0, 1.33333, 0)
UI.NotificationClose.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationClose.Position = UDim2.new(0.92, 0, 0.5, 0)

-- Aspect ratio untuk tombol close
UI.NotificationCloseRatio = Instance.new("UIAspectRatioConstraint", UI.NotificationClose)

-- Padding untuk judul notification
UI.NotificationTitlePadding = Instance.new("UIPadding", UI.NotificationTitle)
UI.NotificationTitlePadding.PaddingLeft = UDim.new(0, 30)

-- Ikon notification
UI.NotificationIcon = Instance.new("ImageButton", UI.NotificationTitle)
UI.NotificationIcon.Name = "Icon"
UI.NotificationIcon.BorderSizePixel = 0
UI.NotificationIcon.BackgroundTransparency = 1
UI.NotificationIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.NotificationIcon.ImageColor3 = COLORS.Text
UI.NotificationIcon.AnchorPoint = Vector2.new(0, 0.5)
UI.NotificationIcon.Image = "rbxassetid://92049322344253"
UI.NotificationIcon.Size = UDim2.new(0.09706, 0, 1.33333, 0)
UI.NotificationIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationIcon.Position = UDim2.new(0, -30, 0.5, 0)

-- Aspect ratio untuk ikon notification
UI.NotificationIconRatio = Instance.new("UIAspectRatioConstraint", UI.NotificationIcon)

-- Konten notification
UI.NotificationMainContent = Instance.new("TextLabel", UI.NotificationContent)
UI.NotificationMainContent.Name = "Content"
UI.NotificationMainContent.TextWrapped = true
UI.NotificationMainContent.BorderSizePixel = 0
UI.NotificationMainContent.TextSize = 16
UI.NotificationMainContent.TextXAlignment = Enum.TextXAlignment.Left
UI.NotificationMainContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.NotificationMainContent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.NotificationMainContent.TextColor3 = COLORS.Text
UI.NotificationMainContent.BackgroundTransparency = 1
UI.NotificationMainContent.AnchorPoint = Vector2.new(0, 0.5)
UI.NotificationMainContent.Size = UDim2.new(0, 218, 0, 10)
UI.NotificationMainContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationMainContent.Text = "Content"
UI.NotificationMainContent.LayoutOrder = 2
UI.NotificationMainContent.AutomaticSize = Enum.AutomaticSize.Y
UI.NotificationMainContent.Position = UDim2.new(0, 0, 0, 19)

-- Gradien untuk konten notification
UI.NotificationMainContentGradient = Instance.new("UIGradient", UI.NotificationMainContent)
UI.NotificationMainContentGradient.Enabled = false
UI.NotificationMainContentGradient.Rotation = -90
UI.NotificationMainContentGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 226))
}

-- Timer bar untuk notification
UI.NotificationTimerBar = Instance.new("Frame", UI.NotificationCanvas)
UI.NotificationTimerBar.Name = "TimerBarFill"
UI.NotificationTimerBar.BorderSizePixel = 0
UI.NotificationTimerBar.BackgroundColor3 = COLORS.Border
UI.NotificationTimerBar.AnchorPoint = Vector2.new(0, 1)
UI.NotificationTimerBar.Size = UDim2.new(1, 0, 0, 5)
UI.NotificationTimerBar.Position = UDim2.new(0, 0, 1, 0)
UI.NotificationTimerBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationTimerBar.BackgroundTransparency = 0.7

-- Sudut melengkung timer bar
UI.NotificationTimerBarCorner = Instance.new("UICorner", UI.NotificationTimerBar)

-- Bar dalam timer bar
UI.NotificationTimerBarInner = Instance.new("Frame", UI.NotificationTimerBar)
UI.NotificationTimerBarInner.Name = "Bar"
UI.NotificationTimerBarInner.BorderSizePixel = 0
UI.NotificationTimerBarInner.BackgroundColor3 = COLORS.Border
UI.NotificationTimerBarInner.Size = UDim2.new(1, 0, 1, 0)
UI.NotificationTimerBarInner.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung bar dalam timer bar
UI.NotificationTimerBarInnerCorner = Instance.new("UICorner", UI.NotificationTimerBarInner)

-- Stroke untuk notification canvas
UI.NotificationCanvasStroke = Instance.new("UIStroke", UI.NotificationCanvas)
UI.NotificationCanvasStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.NotificationCanvasStroke.Thickness = 1.5
UI.NotificationCanvasStroke.Color = COLORS.Border

-- Sudut melengkung notification canvas
UI.NotificationCanvasCorner = Instance.new("UICorner", UI.NotificationCanvas)

-- 29. Template Slider (dimulai)
UI.SliderTemplate = Instance.new("Frame", UI.TemplatesFolder)
UI.SliderTemplate.Name = "Slider"
UI.SliderTemplate.Visible = false
UI.SliderTemplate.BorderSizePixel = 0
UI.SliderTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.SliderTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.SliderTemplate.Size = UDim2.new(1, 0, 0, 35)
UI.SliderTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
UI.SliderTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
-- ==============================
-- KELANJUTAN NAT HUB UI LIBRARY - REWRITE
-- ==============================

-- 29. Template Slider (kelanjutan)
UI.SliderLayout = Instance.new("UIListLayout", UI.SliderTemplate)
UI.SliderLayout.Padding = UDim.new(0, 5)
UI.SliderLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Deskripsi slider
UI.SliderDescription = Instance.new("TextLabel", UI.SliderTemplate)
UI.SliderDescription.Name = "Description"
UI.SliderDescription.TextWrapped = true
UI.SliderDescription.Interactable = false
UI.SliderDescription.BorderSizePixel = 0
UI.SliderDescription.TextSize = 16
UI.SliderDescription.TextXAlignment = Enum.TextXAlignment.Left
UI.SliderDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.SliderDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.SliderDescription.TextColor3 = COLORS.Text
UI.SliderDescription.BackgroundTransparency = 1
UI.SliderDescription.Size = UDim2.new(1, 0, 0, 15)
UI.SliderDescription.Visible = false
UI.SliderDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.SliderDescription.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
UI.SliderDescription.LayoutOrder = 1
UI.SliderDescription.AutomaticSize = Enum.AutomaticSize.Y

-- Frame untuk slider
UI.SliderFrame = Instance.new("Frame", UI.SliderTemplate)
UI.SliderFrame.Name = "SliderFrame"
UI.SliderFrame.ZIndex = 0
UI.SliderFrame.BorderSizePixel = 0
UI.SliderFrame.Size = UDim2.new(1, 0, 0, 25)
UI.SliderFrame.LayoutOrder = 2
UI.SliderFrame.BackgroundTransparency = 1

-- Frame untuk track slider
UI.SliderTrack = Instance.new("Frame", UI.SliderFrame)
UI.SliderTrack.ZIndex = 0
UI.SliderTrack.BorderSizePixel = 0
UI.SliderTrack.AnchorPoint = Vector2.new(0, 0.5)
UI.SliderTrack.Size = UDim2.new(1, 0, 0, 20)
UI.SliderTrack.Position = UDim2.new(0, 0, 0.5, 0)
UI.SliderTrack.BackgroundTransparency = 1

-- Shadow untuk slider
UI.SliderShadow = Instance.new("ImageLabel", UI.SliderTrack)
UI.SliderShadow.Name = "DropShadow"
UI.SliderShadow.ZIndex = 0
UI.SliderShadow.BorderSizePixel = 0
UI.SliderShadow.SliceCenter = Rect.new(49, 49, 450, 450)
UI.SliderShadow.ScaleType = Enum.ScaleType.Slice
UI.SliderShadow.ImageTransparency = 0.75
UI.SliderShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
UI.SliderShadow.AnchorPoint = Vector2.new(0.5, 0.5)
UI.SliderShadow.Image = "rbxassetid://6014261993"
UI.SliderShadow.Size = UDim2.new(1, 25, 1, 25)
UI.SliderShadow.BackgroundTransparency = 1
UI.SliderShadow.Position = UDim2.new(0.5, 0, 0.5, 0)

-- Canvas group untuk slider
UI.SliderCanvas = Instance.new("CanvasGroup", UI.SliderTrack)
UI.SliderCanvas.Name = "Slider"
UI.SliderCanvas.BorderSizePixel = 0
UI.SliderCanvas.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.SliderCanvas.Size = UDim2.new(1, 0, 1, 0)
UI.SliderCanvas.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung slider
UI.SliderCorner = Instance.new("UICorner", UI.SliderCanvas)
UI.SliderCorner.CornerRadius = UDim.new(0, 5)

-- Stroke untuk slider
UI.SliderStroke = Instance.new("UIStroke", UI.SliderCanvas)
UI.SliderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SliderStroke.Thickness = 1.5
UI.SliderStroke.Color = COLORS.Border

-- Padding untuk slider
UI.SliderPadding = Instance.new("UIPadding", UI.SliderCanvas)
UI.SliderPadding.PaddingTop = UDim.new(0, 2)
UI.SliderPadding.PaddingRight = UDim.new(0, 2)
UI.SliderPadding.PaddingLeft = UDim.new(0, 2)
UI.SliderPadding.PaddingBottom = UDim.new(0, 2)

-- Trigger button untuk slider
UI.SliderTrigger = Instance.new("TextButton", UI.SliderCanvas)
UI.SliderTrigger.Name = "Trigger"
UI.SliderTrigger.BorderSizePixel = 0
UI.SliderTrigger.TextSize = 14
UI.SliderTrigger.AutoButtonColor = false
UI.SliderTrigger.TextColor3 = Color3.fromRGB(0, 0, 0)
UI.SliderTrigger.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.SliderTrigger.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI.SliderTrigger.BackgroundTransparency = 1
UI.SliderTrigger.Size = UDim2.new(1, 0, 1, 0)
UI.SliderTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.SliderTrigger.Text = ""

-- Fill untuk slider
UI.SliderFill = Instance.new("ImageButton", UI.SliderCanvas)
UI.SliderFill.Name = "Fill"
UI.SliderFill.Active = false
UI.SliderFill.Interactable = false
UI.SliderFill.BorderSizePixel = 0
UI.SliderFill.AutoButtonColor = false
UI.SliderFill.BackgroundTransparency = 1
UI.SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.SliderFill.Selectable = false
UI.SliderFill.AnchorPoint = Vector2.new(0, 0.5)
UI.SliderFill.Size = UDim2.new(0, 0, 1, 0)
UI.SliderFill.ClipsDescendants = true
UI.SliderFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.SliderFill.Position = UDim2.new(0, 0, 0.5, 0)

-- Sudut melengkung fill
UI.SliderFillCorner = Instance.new("UICorner", UI.SliderFill)
UI.SliderFillCorner.CornerRadius = UDim.new(0, 4)

-- Stroke untuk fill
UI.SliderFillStroke = Instance.new("UIStroke", UI.SliderFill)
UI.SliderFillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SliderFillStroke.Thickness = 1.5
UI.SliderFillStroke.Color = Color3.fromRGB(11, 136, 214)

-- Background gradient untuk fill
UI.SliderFillGradient = Instance.new("ImageButton", UI.SliderFill)
UI.SliderFillGradient.Name = "BackgroundGradient"
UI.SliderFillGradient.Active = false
UI.SliderFillGradient.Interactable = false
UI.SliderFillGradient.BorderSizePixel = 0
UI.SliderFillGradient.AutoButtonColor = false
UI.SliderFillGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.SliderFillGradient.Selectable = false
UI.SliderFillGradient.AnchorPoint = Vector2.new(0, 0.5)
UI.SliderFillGradient.Size = UDim2.new(1, 0, 1, 0)
UI.SliderFillGradient.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.SliderFillGradient.Position = UDim2.new(0, 0, 0.5, 0)

-- Sudut melengkung background gradient
UI.SliderFillGradientCorner = Instance.new("UICorner", UI.SliderFillGradient)
UI.SliderFillGradientCorner.CornerRadius = UDim.new(0, 4)

-- Gradien untuk fill (3 variasi)
UI.SliderGradient1 = Instance.new("UIGradient", UI.SliderFillGradient)
UI.SliderGradient1.Enabled = false
UI.SliderGradient1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

UI.SliderGradient2 = Instance.new("UIGradient", UI.SliderFillGradient)
UI.SliderGradient2.Enabled = false
UI.SliderGradient2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

UI.SliderGradient3 = Instance.new("UIGradient", UI.SliderFillGradient)
UI.SliderGradient3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

-- Teks nilai slider
UI.SliderValueText = Instance.new("TextLabel", UI.SliderTrack)
UI.SliderValueText.Name = "ValueText"
UI.SliderValueText.TextWrapped = true
UI.SliderValueText.Interactable = false
UI.SliderValueText.ZIndex = 2
UI.SliderValueText.BorderSizePixel = 0
UI.SliderValueText.TextSize = 14
UI.SliderValueText.TextXAlignment = Enum.TextXAlignment.Left
UI.SliderValueText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.SliderValueText.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
UI.SliderValueText.TextColor3 = COLORS.Text
UI.SliderValueText.BackgroundTransparency = 1
UI.SliderValueText.RichText = true
UI.SliderValueText.AnchorPoint = Vector2.new(0.5, 0.5)
UI.SliderValueText.Size = UDim2.new(1, -15, 1, 0)
UI.SliderValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.SliderValueText.Text = "0"
UI.SliderValueText.Position = UDim2.new(0.5, 0, 0.5, 0)

-- 30. Template TextBox
UI.TextBoxTemplate = Instance.new("Frame", UI.TemplatesFolder)
UI.TextBoxTemplate.Name = "TextBox"
UI.TextBoxTemplate.Visible = false
UI.TextBoxTemplate.BorderSizePixel = 0
UI.TextBoxTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.TextBoxTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.TextBoxTemplate.Size = UDim2.new(1, 0, 0, 35)
UI.TextBoxTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
UI.TextBoxTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung textbox
UI.TextBoxCorner = Instance.new("UICorner", UI.TextBoxTemplate)
UI.TextBoxCorner.CornerRadius = UDim.new(0, 6)

-- Stroke untuk textbox
UI.TextBoxStroke = Instance.new("UIStroke", UI.TextBoxTemplate)
UI.TextBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.TextBoxStroke.Thickness = 1.5
UI.TextBoxStroke.Color = COLORS.Border

-- Judul textbox
UI.TextBoxTitle = Instance.new("TextLabel", UI.TextBoxTemplate)
UI.TextBoxTitle.Name = "Title"
UI.TextBoxTitle.TextWrapped = true
UI.TextBoxTitle.Interactable = false
UI.TextBoxTitle.BorderSizePixel = 0
UI.TextBoxTitle.TextSize = 16
UI.TextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.TextBoxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TextBoxTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
UI.TextBoxTitle.TextColor3 = COLORS.Text
UI.TextBoxTitle.BackgroundTransparency = 1
UI.TextBoxTitle.Size = UDim2.new(1, 0, 0, 15)
UI.TextBoxTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TextBoxTitle.Text = "Input Textbox"
UI.TextBoxTitle.AutomaticSize = Enum.AutomaticSize.Y

-- Padding untuk textbox
UI.TextBoxPadding = Instance.new("UIPadding", UI.TextBoxTemplate)
UI.TextBoxPadding.PaddingTop = UDim.new(0, 10)
UI.TextBoxPadding.PaddingRight = UDim.new(0, 10)
UI.TextBoxPadding.PaddingLeft = UDim.new(0, 10)
UI.TextBoxPadding.PaddingBottom = UDim.new(0, 10)

-- Layout untuk textbox
UI.TextBoxLayout = Instance.new("UIListLayout", UI.TextBoxTemplate)
UI.TextBoxLayout.Padding = UDim.new(0, 10)
UI.TextBoxLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Deskripsi textbox
UI.TextBoxDescription = Instance.new("TextLabel", UI.TextBoxTemplate)
UI.TextBoxDescription.Name = "Description"
UI.TextBoxDescription.TextWrapped = true
UI.TextBoxDescription.Interactable = false
UI.TextBoxDescription.BorderSizePixel = 0
UI.TextBoxDescription.TextSize = 16
UI.TextBoxDescription.TextXAlignment = Enum.TextXAlignment.Left
UI.TextBoxDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TextBoxDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.TextBoxDescription.TextColor3 = COLORS.Text
UI.TextBoxDescription.BackgroundTransparency = 1
UI.TextBoxDescription.Size = UDim2.new(1, 0, 0, 15)
UI.TextBoxDescription.Visible = false
UI.TextBoxDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TextBoxDescription.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
UI.TextBoxDescription.LayoutOrder = 1
UI.TextBoxDescription.AutomaticSize = Enum.AutomaticSize.Y

-- Frame untuk box textbox
UI.TextBoxBoxFrame = Instance.new("Frame", UI.TextBoxTemplate)
UI.TextBoxBoxFrame.Name = "BoxFrame"
UI.TextBoxBoxFrame.ZIndex = 0
UI.TextBoxBoxFrame.BorderSizePixel = 0
UI.TextBoxBoxFrame.AutomaticSize = Enum.AutomaticSize.Y
UI.TextBoxBoxFrame.Size = UDim2.new(1, 0, 0, 25)
UI.TextBoxBoxFrame.LayoutOrder = 2
UI.TextBoxBoxFrame.BackgroundTransparency = 1

-- Shadow untuk box textbox
UI.TextBoxBoxShadow = Instance.new("ImageLabel", UI.TextBoxBoxFrame)
UI.TextBoxBoxShadow.Name = "DropShadow"
UI.TextBoxBoxShadow.ZIndex = 0
UI.TextBoxBoxShadow.BorderSizePixel = 0
UI.TextBoxBoxShadow.SliceCenter = Rect.new(49, 49, 450, 450)
UI.TextBoxBoxShadow.ScaleType = Enum.ScaleType.Slice
UI.TextBoxBoxShadow.ImageTransparency = 0.75
UI.TextBoxBoxShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
UI.TextBoxBoxShadow.AnchorPoint = Vector2.new(0.5, 0.5)
UI.TextBoxBoxShadow.Image = "rbxassetid://6014261993"
UI.TextBoxBoxShadow.Size = UDim2.new(1, 35, 1, 30)
UI.TextBoxBoxShadow.BackgroundTransparency = 1
UI.TextBoxBoxShadow.Position = UDim2.new(0.5, 0, 0.5, 0)

-- Background untuk box textbox
UI.TextBoxBoxBackground = Instance.new("Frame", UI.TextBoxBoxFrame)
UI.TextBoxBoxBackground.BorderSizePixel = 0
UI.TextBoxBoxBackground.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.TextBoxBoxBackground.AutomaticSize = Enum.AutomaticSize.Y
UI.TextBoxBoxBackground.Size = UDim2.new(1, 0, 0, 25)
UI.TextBoxBoxBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung box background
UI.TextBoxBoxCorner = Instance.new("UICorner", UI.TextBoxBoxBackground)
UI.TextBoxBoxCorner.CornerRadius = UDim.new(0, 5)

-- Stroke untuk box background
UI.TextBoxBoxStroke = Instance.new("UIStroke", UI.TextBoxBoxBackground)
UI.TextBoxBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.TextBoxBoxStroke.Thickness = 1.5
UI.TextBoxBoxStroke.Color = COLORS.Border

-- Layout untuk box background
UI.TextBoxBoxLayout = Instance.new("UIListLayout", UI.TextBoxBoxBackground)
UI.TextBoxBoxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UI.TextBoxBoxLayout.Padding = UDim.new(0, 5)
UI.TextBoxBoxLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.TextBoxBoxLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Textbox input
UI.TextBoxInput = Instance.new("TextBox", UI.TextBoxBoxBackground)
UI.TextBoxInput.TextXAlignment = Enum.TextXAlignment.Left
UI.TextBoxInput.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
UI.TextBoxInput.BorderSizePixel = 0
UI.TextBoxInput.TextWrapped = true
UI.TextBoxInput.TextTruncate = Enum.TextTruncate.AtEnd
UI.TextBoxInput.TextSize = 14
UI.TextBoxInput.TextColor3 = COLORS.Text
UI.TextBoxInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TextBoxInput.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.TextBoxInput.AutomaticSize = Enum.AutomaticSize.Y
UI.TextBoxInput.ClipsDescendants = true
UI.TextBoxInput.PlaceholderText = "Input here..."
UI.TextBoxInput.Size = UDim2.new(1, 0, 0, 25)
UI.TextBoxInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.TextBoxInput.Text = ""
UI.TextBoxInput.BackgroundTransparency = 1

-- Padding untuk textbox input
UI.TextBoxInputPadding = Instance.new("UIPadding", UI.TextBoxInput)
UI.TextBoxInputPadding.PaddingTop = UDim.new(0, 5)
UI.TextBoxInputPadding.PaddingRight = UDim.new(0, 10)
UI.TextBoxInputPadding.PaddingLeft = UDim.new(0, 10)
UI.TextBoxInputPadding.PaddingBottom = UDim.new(0, 5)

-- 31. Template Dropdown
UI.DropdownTemplate = Instance.new("ImageButton", UI.TemplatesFolder)
UI.DropdownTemplate.Name = "Dropdown"
UI.DropdownTemplate.Visible = false
UI.DropdownTemplate.BorderSizePixel = 0
UI.DropdownTemplate.AutoButtonColor = false
UI.DropdownTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.DropdownTemplate.Selectable = false
UI.DropdownTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.DropdownTemplate.Size = UDim2.new(1, 0, 0, 35)
UI.DropdownTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
UI.DropdownTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung dropdown
UI.DropdownCorner = Instance.new("UICorner", UI.DropdownTemplate)
UI.DropdownCorner.CornerRadius = UDim.new(0, 6)

-- Stroke untuk dropdown
UI.DropdownStroke = Instance.new("UIStroke", UI.DropdownTemplate)
UI.DropdownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.DropdownStroke.Thickness = 1.5
UI.DropdownStroke.Color = COLORS.Border

-- Judul dropdown
UI.DropdownTitle = Instance.new("TextLabel", UI.DropdownTemplate)
UI.DropdownTitle.Name = "Title"
UI.DropdownTitle.TextWrapped = true
UI.DropdownTitle.BorderSizePixel = 0
UI.DropdownTitle.TextSize = 16
UI.DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.DropdownTitle.TextColor3 = COLORS.Text
UI.DropdownTitle.BackgroundTransparency = 1
UI.DropdownTitle.Size = UDim2.new(1, 0, 0, 15)
UI.DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownTitle.Text = "Dropdown"
UI.DropdownTitle.Position = UDim2.new(0.03135, 0, 0, 0)

-- Ikon klik untuk dropdown
UI.DropdownClickIcon = Instance.new("ImageButton", UI.DropdownTitle)
UI.DropdownClickIcon.Name = "ClickIcon"
UI.DropdownClickIcon.BorderSizePixel = 0
UI.DropdownClickIcon.AutoButtonColor = false
UI.DropdownClickIcon.BackgroundTransparency = 1
UI.DropdownClickIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownClickIcon.ImageColor3 = COLORS.Text
UI.DropdownClickIcon.AnchorPoint = Vector2.new(1, 0.5)
UI.DropdownClickIcon.Image = "rbxassetid://77563793724007"
UI.DropdownClickIcon.Size = UDim2.new(0, 23, 0, 23)
UI.DropdownClickIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownClickIcon.Position = UDim2.new(1, 0, 0.5, 0)

-- Box frame untuk dropdown
UI.DropdownBoxFrame = Instance.new("ImageButton", UI.DropdownTitle)
UI.DropdownBoxFrame.Name = "BoxFrame"
UI.DropdownBoxFrame.Active = false
UI.DropdownBoxFrame.BorderSizePixel = 0
UI.DropdownBoxFrame.BackgroundTransparency = 1
UI.DropdownBoxFrame.Selectable = false
UI.DropdownBoxFrame.ZIndex = 0
UI.DropdownBoxFrame.AnchorPoint = Vector2.new(1, 0.5)
UI.DropdownBoxFrame.AutomaticSize = Enum.AutomaticSize.X
UI.DropdownBoxFrame.Size = UDim2.new(0, 20, 0, 20)
UI.DropdownBoxFrame.Position = UDim2.new(1, -33, 0.5, 0)

-- Shadow untuk box frame
UI.DropdownBoxShadow = Instance.new("ImageLabel", UI.DropdownBoxFrame)
UI.DropdownBoxShadow.Name = "DropShadow"
UI.DropdownBoxShadow.Interactable = false
UI.DropdownBoxShadow.ZIndex = 0
UI.DropdownBoxShadow.BorderSizePixel = 0
UI.DropdownBoxShadow.SliceCenter = Rect.new(49, 49, 450, 450)
UI.DropdownBoxShadow.ScaleType = Enum.ScaleType.Slice
UI.DropdownBoxShadow.ImageTransparency = 0.75
UI.DropdownBoxShadow.AutomaticSize = Enum.AutomaticSize.X
UI.DropdownBoxShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownBoxShadow.AnchorPoint = Vector2.new(0.5, 0.5)
UI.DropdownBoxShadow.Image = "rbxassetid://6014261993"
UI.DropdownBoxShadow.Size = UDim2.new(1, 28, 1, 28)
UI.DropdownBoxShadow.Visible = false
UI.DropdownBoxShadow.BackgroundTransparency = 1
UI.DropdownBoxShadow.Position = UDim2.new(0.5, 0, 0.5, 0)

-- Trigger untuk dropdown
UI.DropdownTrigger = Instance.new("ImageButton", UI.DropdownBoxFrame)
UI.DropdownTrigger.Name = "Trigger"
UI.DropdownTrigger.BorderSizePixel = 0
UI.DropdownTrigger.AutoButtonColor = false
UI.DropdownTrigger.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.DropdownTrigger.Selectable = false
UI.DropdownTrigger.AnchorPoint = Vector2.new(0.5, 0.5)
UI.DropdownTrigger.AutomaticSize = Enum.AutomaticSize.X
UI.DropdownTrigger.Size = UDim2.new(0, 20, 0, 20)
UI.DropdownTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownTrigger.Position = UDim2.new(0.5, 0, 0.5, 0)

-- Sudut melengkung trigger
UI.DropdownTriggerCorner = Instance.new("UICorner", UI.DropdownTrigger)
UI.DropdownTriggerCorner.CornerRadius = UDim.new(0, 5)

-- Stroke untuk trigger
UI.DropdownTriggerStroke = Instance.new("UIStroke", UI.DropdownTrigger)
UI.DropdownTriggerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.DropdownTriggerStroke.Thickness = 1.5
UI.DropdownTriggerStroke.Color = COLORS.Border

-- Layout untuk trigger
UI.DropdownTriggerLayout = Instance.new("UIListLayout", UI.DropdownTrigger)
UI.DropdownTriggerLayout.Padding = UDim.new(0, 5)
UI.DropdownTriggerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.DropdownTriggerLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Label untuk trigger
UI.DropdownTriggerLabel = Instance.new("TextLabel", UI.DropdownTrigger)
UI.DropdownTriggerLabel.Name = "Title"
UI.DropdownTriggerLabel.TextWrapped = true
UI.DropdownTriggerLabel.Interactable = false
UI.DropdownTriggerLabel.BorderSizePixel = 0
UI.DropdownTriggerLabel.TextSize = 16
UI.DropdownTriggerLabel.TextScaled = true
UI.DropdownTriggerLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownTriggerLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.DropdownTriggerLabel.TextColor3 = COLORS.Text
UI.DropdownTriggerLabel.BackgroundTransparency = 1
UI.DropdownTriggerLabel.AnchorPoint = Vector2.new(0, 0.5)
UI.DropdownTriggerLabel.Size = UDim2.new(0, 15, 0, 14)
UI.DropdownTriggerLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownTriggerLabel.Text = ""
UI.DropdownTriggerLabel.AutomaticSize = Enum.AutomaticSize.X
UI.DropdownTriggerLabel.Position = UDim2.new(-0.00345, 0, 0.5, 0)

-- Padding untuk trigger
UI.DropdownTriggerPadding = Instance.new("UIPadding", UI.DropdownTrigger)
UI.DropdownTriggerPadding.PaddingRight = UDim.new(0, 5)
UI.DropdownTriggerPadding.PaddingLeft = UDim.new(0, 5)

-- Padding untuk dropdown
UI.DropdownPadding = Instance.new("UIPadding", UI.DropdownTemplate)
UI.DropdownPadding.PaddingTop = UDim.new(0, 10)
UI.DropdownPadding.PaddingRight = UDim.new(0, 10)
UI.DropdownPadding.PaddingLeft = UDim.new(0, 10)
UI.DropdownPadding.PaddingBottom = UDim.new(0, 10)

-- Layout untuk dropdown
UI.DropdownLayout = Instance.new("UIListLayout", UI.DropdownTemplate)
UI.DropdownLayout.Padding = UDim.new(0, 5)
UI.DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Deskripsi dropdown
UI.DropdownDescription = Instance.new("TextLabel", UI.DropdownTemplate)
UI.DropdownDescription.Name = "Description"
UI.DropdownDescription.TextWrapped = true
UI.DropdownDescription.Interactable = false
UI.DropdownDescription.BorderSizePixel = 0
UI.DropdownDescription.TextSize = 16
UI.DropdownDescription.TextXAlignment = Enum.TextXAlignment.Left
UI.DropdownDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.DropdownDescription.TextColor3 = COLORS.Text
UI.DropdownDescription.BackgroundTransparency = 1
UI.DropdownDescription.Size = UDim2.new(1, 0, 0, 15)
UI.DropdownDescription.Visible = false
UI.DropdownDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownDescription.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
UI.DropdownDescription.LayoutOrder = 1
UI.DropdownDescription.AutomaticSize = Enum.AutomaticSize.Y

-- Gradien untuk dropdown (3 variasi)
UI.DropdownGradient1 = Instance.new("UIGradient", UI.DropdownTemplate)
UI.DropdownGradient1.Enabled = false
UI.DropdownGradient1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

UI.DropdownGradient2 = Instance.new("UIGradient", UI.DropdownTemplate)
UI.DropdownGradient2.Enabled = false
UI.DropdownGradient2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

UI.DropdownGradient3 = Instance.new("UIGradient", UI.DropdownTemplate)
UI.DropdownGradient3.Enabled = false
UI.DropdownGradient3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

-- Folder untuk dropdown list
UI.DropdownListFolder = Instance.new("Folder", UI.TemplatesFolder)
UI.DropdownListFolder.Name = "DropdownList"

-- Scrolling frame untuk dropdown items
UI.DropdownItems = Instance.new("ScrollingFrame", UI.DropdownListFolder)
UI.DropdownItems.Name = "DropdownItems"
UI.DropdownItems.Visible = false
UI.DropdownItems.Active = true
UI.DropdownItems.ScrollingDirection = Enum.ScrollingDirection.Y
UI.DropdownItems.BorderSizePixel = 0
UI.DropdownItems.CanvasSize = UDim2.new(0, 0, 0, 0)
UI.DropdownItems.ElasticBehavior = Enum.ElasticBehavior.Never
UI.DropdownItems.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
UI.DropdownItems.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownItems.Selectable = false
UI.DropdownItems.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
UI.DropdownItems.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.DropdownItems.Size = UDim2.new(1, 0, 1, -50)
UI.DropdownItems.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
UI.DropdownItems.Position = UDim2.new(0, 0, 0, 50)
UI.DropdownItems.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownItems.ScrollBarThickness = 5
UI.DropdownItems.BackgroundTransparency = 1

-- Layout untuk dropdown items
UI.DropdownItemsLayout = Instance.new("UIListLayout", UI.DropdownItems)
UI.DropdownItemsLayout.Padding = UDim.new(0, 15)
UI.DropdownItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk dropdown items
UI.DropdownItemsPadding = Instance.new("UIPadding", UI.DropdownItems)
UI.DropdownItemsPadding.PaddingTop = UDim.new(0, 2)
UI.DropdownItemsPadding.PaddingRight = UDim.new(0, 10)
UI.DropdownItemsPadding.PaddingLeft = UDim.new(0, 10)
UI.DropdownItemsPadding.PaddingBottom = UDim.new(0, 10)

-- Scrolling frame untuk dropdown items search
UI.DropdownItemsSearch = Instance.new("ScrollingFrame", UI.DropdownListFolder)
UI.DropdownItemsSearch.Name = "DropdownItemsSearch"
UI.DropdownItemsSearch.Visible = false
UI.DropdownItemsSearch.Active = true
UI.DropdownItemsSearch.ScrollingDirection = Enum.ScrollingDirection.Y
UI.DropdownItemsSearch.BorderSizePixel = 0
UI.DropdownItemsSearch.CanvasSize = UDim2.new(0, 0, 0, 0)
UI.DropdownItemsSearch.ElasticBehavior = Enum.ElasticBehavior.Never
UI.DropdownItemsSearch.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
UI.DropdownItemsSearch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownItemsSearch.Selectable = false
UI.DropdownItemsSearch.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
UI.DropdownItemsSearch.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.DropdownItemsSearch.Size = UDim2.new(1, 0, 1, -50)
UI.DropdownItemsSearch.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
UI.DropdownItemsSearch.Position = UDim2.new(0, 0, 0, 50)
UI.DropdownItemsSearch.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownItemsSearch.ScrollBarThickness = 5
UI.DropdownItemsSearch.BackgroundTransparency = 1

-- Layout untuk dropdown items search
UI.DropdownItemsSearchLayout = Instance.new("UIListLayout", UI.DropdownItemsSearch)
UI.DropdownItemsSearchLayout.Padding = UDim.new(0, 15)
UI.DropdownItemsSearchLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk dropdown items search
UI.DropdownItemsSearchPadding = Instance.new("UIPadding", UI.DropdownItemsSearch)
UI.DropdownItemsSearchPadding.PaddingTop = UDim.new(0, 2)
UI.DropdownItemsSearchPadding.PaddingRight = UDim.new(0, 10)
UI.DropdownItemsSearchPadding.PaddingLeft = UDim.new(0, 10)
UI.DropdownItemsSearchPadding.PaddingBottom = UDim.new(0, 10)

-- 32. Template Color Picker (dimulai)
UI.ColorPickerTemplate = Instance.new("ImageButton", UI.TemplatesFolder)
UI.ColorPickerTemplate.Visible = false
UI.ColorPickerTemplate.BorderSizePixel = 0
UI.ColorPickerTemplate.AutoButtonColor = false
UI.ColorPickerTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.ColorPickerTemplate.Selectable = false
-- ==============================
-- KELANJUTAN NAT HUB UI LIBRARY - REWRITE
-- ==============================

-- 32. Template Dropdown Button (Color Picker)
UI.DropdownButtonTemplate = Instance.new("ImageButton", UI.TemplatesFolder)
UI.DropdownButtonTemplate.Name = "DropdownButton"
UI.DropdownButtonTemplate.Visible = false
UI.DropdownButtonTemplate.BorderSizePixel = 0
UI.DropdownButtonTemplate.AutoButtonColor = false
UI.DropdownButtonTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.DropdownButtonTemplate.Selectable = false
UI.DropdownButtonTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.DropdownButtonTemplate.Size = UDim2.new(1, 0, 0, 35)
UI.DropdownButtonTemplate.Position = UDim2.new(0, 0, 0.384, 0)
UI.DropdownButtonTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung dropdown button
UI.DropdownButtonCorner = Instance.new("UICorner", UI.DropdownButtonTemplate)
UI.DropdownButtonCorner.CornerRadius = UDim.new(0, 6)

-- Frame konten dropdown button
UI.DropdownButtonContent = Instance.new("Frame", UI.DropdownButtonTemplate)
UI.DropdownButtonContent.BorderSizePixel = 0
UI.DropdownButtonContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownButtonContent.AutomaticSize = Enum.AutomaticSize.Y
UI.DropdownButtonContent.Size = UDim2.new(1, 0, 0, 35)
UI.DropdownButtonContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownButtonContent.BackgroundTransparency = 1

-- Layout untuk dropdown button content
UI.DropdownButtonContentLayout = Instance.new("UIListLayout", UI.DropdownButtonContent)
UI.DropdownButtonContentLayout.Padding = UDim.new(0, 5)
UI.DropdownButtonContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk dropdown button content
UI.DropdownButtonContentPadding = Instance.new("UIPadding", UI.DropdownButtonContent)
UI.DropdownButtonContentPadding.PaddingTop = UDim.new(0, 10)
UI.DropdownButtonContentPadding.PaddingRight = UDim.new(0, 10)
UI.DropdownButtonContentPadding.PaddingLeft = UDim.new(0, 10)
UI.DropdownButtonContentPadding.PaddingBottom = UDim.new(0, 10)

-- Judul dropdown button
UI.DropdownButtonTitle = Instance.new("TextLabel", UI.DropdownButtonContent)
UI.DropdownButtonTitle.Name = "Title"
UI.DropdownButtonTitle.TextWrapped = true
UI.DropdownButtonTitle.Interactable = false
UI.DropdownButtonTitle.BorderSizePixel = 0
UI.DropdownButtonTitle.TextSize = 16
UI.DropdownButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownButtonTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.DropdownButtonTitle.TextColor3 = COLORS.Text
UI.DropdownButtonTitle.BackgroundTransparency = 1
UI.DropdownButtonTitle.Size = UDim2.new(1, 0, 0, 15)
UI.DropdownButtonTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownButtonTitle.Text = "Button"

-- Deskripsi dropdown button
UI.DropdownButtonDescription = Instance.new("TextLabel", UI.DropdownButtonContent)
UI.DropdownButtonDescription.Name = "Description"
UI.DropdownButtonDescription.TextWrapped = true
UI.DropdownButtonDescription.Interactable = false
UI.DropdownButtonDescription.BorderSizePixel = 0
UI.DropdownButtonDescription.TextSize = 16
UI.DropdownButtonDescription.TextXAlignment = Enum.TextXAlignment.Left
UI.DropdownButtonDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DropdownButtonDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.DropdownButtonDescription.TextColor3 = COLORS.Text
UI.DropdownButtonDescription.BackgroundTransparency = 1
UI.DropdownButtonDescription.Size = UDim2.new(1, 0, 0, 15)
UI.DropdownButtonDescription.Visible = false
UI.DropdownButtonDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DropdownButtonDescription.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
UI.DropdownButtonDescription.LayoutOrder = 1
UI.DropdownButtonDescription.AutomaticSize = Enum.AutomaticSize.Y

-- Gradien untuk dropdown button (3 variasi)
UI.DropdownButtonGradient1 = Instance.new("UIGradient", UI.DropdownButtonContent)
UI.DropdownButtonGradient1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

UI.DropdownButtonGradient2 = Instance.new("UIGradient", UI.DropdownButtonContent)
UI.DropdownButtonGradient2.Enabled = false
UI.DropdownButtonGradient2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

UI.DropdownButtonGradient3 = Instance.new("UIGradient", UI.DropdownButtonContent)
UI.DropdownButtonGradient3.Enabled = false
UI.DropdownButtonGradient3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

-- Sudut melengkung konten dropdown button
UI.DropdownButtonContentCorner = Instance.new("UICorner", UI.DropdownButtonContent)
UI.DropdownButtonContentCorner.CornerRadius = UDim.new(0, 6)

-- Stroke untuk dropdown button
UI.DropdownButtonStroke = Instance.new("UIStroke", UI.DropdownButtonTemplate)
UI.DropdownButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.DropdownButtonStroke.Thickness = 1.5
UI.DropdownButtonStroke.Color = COLORS.Border

-- 33. Template Code
UI.CodeTemplate = Instance.new("Frame", UI.TemplatesFolder)
UI.CodeTemplate.Name = "Code"
UI.CodeTemplate.Visible = false
UI.CodeTemplate.BorderSizePixel = 0
UI.CodeTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.CodeTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.CodeTemplate.Size = UDim2.new(1, 0, 0, 35)
UI.CodeTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
UI.CodeTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung code
UI.CodeCorner = Instance.new("UICorner", UI.CodeTemplate)
UI.CodeCorner.CornerRadius = UDim.new(0, 6)

-- Stroke untuk code
UI.CodeStroke = Instance.new("UIStroke", UI.CodeTemplate)
UI.CodeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.CodeStroke.Thickness = 1.5
UI.CodeStroke.Color = COLORS.Border

-- Judul code
UI.CodeTitle = Instance.new("TextLabel", UI.CodeTemplate)
UI.CodeTitle.Name = "Title"
UI.CodeTitle.TextWrapped = true
UI.CodeTitle.Interactable = false
UI.CodeTitle.BorderSizePixel = 0
UI.CodeTitle.TextSize = 16
UI.CodeTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.CodeTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CodeTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
UI.CodeTitle.TextColor3 = COLORS.Text
UI.CodeTitle.BackgroundTransparency = 1
UI.CodeTitle.Size = UDim2.new(1, 0, 0, 15)
UI.CodeTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.CodeTitle.Text = "Title"
UI.CodeTitle.AutomaticSize = Enum.AutomaticSize.Y

-- Padding untuk code
UI.CodePadding = Instance.new("UIPadding", UI.CodeTemplate)
UI.CodePadding.PaddingTop = UDim.new(0, 10)
UI.CodePadding.PaddingRight = UDim.new(0, 10)
UI.CodePadding.PaddingLeft = UDim.new(0, 10)
UI.CodePadding.PaddingBottom = UDim.new(0, 10)

-- Layout untuk code
UI.CodeLayout = Instance.new("UIListLayout", UI.CodeTemplate)
UI.CodeLayout.Padding = UDim.new(0, 5)
UI.CodeLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Textbox untuk code
UI.CodeBox = Instance.new("TextBox", UI.CodeTemplate)
UI.CodeBox.Name = "Code"
UI.CodeBox.TextXAlignment = Enum.TextXAlignment.Left
UI.CodeBox.BorderSizePixel = 0
UI.CodeBox.TextEditable = false
UI.CodeBox.TextWrapped = true
UI.CodeBox.TextSize = 16
UI.CodeBox.TextColor3 = COLORS.Text
UI.CodeBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CodeBox.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.CodeBox.AutomaticSize = Enum.AutomaticSize.Y
UI.CodeBox.Selectable = false
UI.CodeBox.MultiLine = true
UI.CodeBox.ClearTextOnFocus = false
UI.CodeBox.Size = UDim2.new(1, 0, 0, 15)
UI.CodeBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.CodeBox.Text = 'print("Hello World!")'
UI.CodeBox.LayoutOrder = 1
UI.CodeBox.BackgroundTransparency = 1

-- 34. Template Section
UI.SectionTemplate = Instance.new("Frame", UI.TemplatesFolder)
UI.SectionTemplate.Name = "Section"
UI.SectionTemplate.Visible = false
UI.SectionTemplate.BorderSizePixel = 0
UI.SectionTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.SectionTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.SectionTemplate.Size = UDim2.new(1, 0, 0, 35)
UI.SectionTemplate.Position = UDim2.new(0, 0, 0.43728, 0)
UI.SectionTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.SectionTemplate.BackgroundTransparency = 1

-- Button untuk section
UI.SectionButton = Instance.new("ImageButton", UI.SectionTemplate)
UI.SectionButton.Name = "Button"
UI.SectionButton.BorderSizePixel = 0
UI.SectionButton.AutoButtonColor = false
UI.SectionButton.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.SectionButton.Selectable = false
UI.SectionButton.AutomaticSize = Enum.AutomaticSize.Y
UI.SectionButton.Size = UDim2.new(1, 0, 0, 35)
UI.SectionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Sudut melengkung section button
UI.SectionButtonCorner = Instance.new("UICorner", UI.SectionButton)
UI.SectionButtonCorner.CornerRadius = UDim.new(0, 6)

-- Stroke untuk section button
UI.SectionButtonStroke = Instance.new("UIStroke", UI.SectionButton)
UI.SectionButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SectionButtonStroke.Thickness = 1.5
UI.SectionButtonStroke.Color = COLORS.Border

-- Judul section
UI.SectionTitle = Instance.new("TextLabel", UI.SectionButton)
UI.SectionTitle.Name = "Title"
UI.SectionTitle.TextWrapped = true
UI.SectionTitle.Interactable = false
UI.SectionTitle.BorderSizePixel = 0
UI.SectionTitle.TextSize = 16
UI.SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.SectionTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.SectionTitle.TextColor3 = COLORS.Text
UI.SectionTitle.BackgroundTransparency = 1
UI.SectionTitle.Size = UDim2.new(1, 0, 0, 15)
UI.SectionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.SectionTitle.Text = "Section"

-- Arrow untuk section
UI.SectionArrow = Instance.new("ImageButton", UI.SectionTitle)
UI.SectionArrow.Name = "Arrow"
UI.SectionArrow.BorderSizePixel = 0
UI.SectionArrow.AutoButtonColor = false
UI.SectionArrow.BackgroundTransparency = 1
UI.SectionArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.SectionArrow.ImageColor3 = COLORS.Text
UI.SectionArrow.AnchorPoint = Vector2.new(1, 0.5)
UI.SectionArrow.Image = "rbxassetid://120292618616139"
UI.SectionArrow.Size = UDim2.new(0, 23, 0, 23)
UI.SectionArrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.SectionArrow.Position = UDim2.new(1, 0, 0.5, 0)

-- Padding untuk section button
UI.SectionButtonPadding = Instance.new("UIPadding", UI.SectionButton)
UI.SectionButtonPadding.PaddingTop = UDim.new(0, 10)
UI.SectionButtonPadding.PaddingRight = UDim.new(0, 10)
UI.SectionButtonPadding.PaddingLeft = UDim.new(0, 10)
UI.SectionButtonPadding.PaddingBottom = UDim.new(0, 10)

-- Layout untuk section button
UI.SectionButtonLayout = Instance.new("UIListLayout", UI.SectionButton)
UI.SectionButtonLayout.Padding = UDim.new(0, 5)
UI.SectionButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Deskripsi section
UI.SectionDescription = Instance.new("TextLabel", UI.SectionButton)
UI.SectionDescription.Name = "Description"
UI.SectionDescription.TextWrapped = true
UI.SectionDescription.Interactable = false
UI.SectionDescription.BorderSizePixel = 0
UI.SectionDescription.TextSize = 16
UI.SectionDescription.TextXAlignment = Enum.TextXAlignment.Left
UI.SectionDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.SectionDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.SectionDescription.TextColor3 = COLORS.Text
UI.SectionDescription.BackgroundTransparency = 1
UI.SectionDescription.Size = UDim2.new(1, 0, 0, 15)
UI.SectionDescription.Visible = false
UI.SectionDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.SectionDescription.Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
UI.SectionDescription.LayoutOrder = 1
UI.SectionDescription.AutomaticSize = Enum.AutomaticSize.Y

-- Gradien untuk section (3 variasi)
UI.SectionGradient1 = Instance.new("UIGradient", UI.SectionButton)
UI.SectionGradient1.Enabled = false
UI.SectionGradient1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

UI.SectionGradient2 = Instance.new("UIGradient", UI.SectionButton)
UI.SectionGradient2.Enabled = false
UI.SectionGradient2.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(1, 1)
}
UI.SectionGradient2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

UI.SectionGradient3 = Instance.new("UIGradient", UI.SectionButton)
UI.SectionGradient3.Enabled = false
UI.SectionGradient3.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

-- Stroke untuk section button
UI.SectionButtonStroke2 = Instance.new("UIStroke", UI.SectionButton)
UI.SectionButtonStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SectionButtonStroke2.Thickness = 1.5
UI.SectionButtonStroke2.Color = COLORS.Border

-- Konten section
UI.SectionContent = Instance.new("Frame", UI.SectionTemplate)
UI.SectionContent.Visible = false
UI.SectionContent.BorderSizePixel = 0
UI.SectionContent.BackgroundColor3 = Color3.fromRGB(207, 222, 255)
UI.SectionContent.AutomaticSize = Enum.AutomaticSize.Y
UI.SectionContent.Size = UDim2.new(1, 0, 0, 30)
UI.SectionContent.Position = UDim2.new(0, 0, 0, 35)
UI.SectionContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.SectionContent.BackgroundTransparency = 1

-- Layout untuk section content
UI.SectionContentLayout = Instance.new("UIListLayout", UI.SectionContent)
UI.SectionContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UI.SectionContentLayout.Padding = UDim.new(0, 10)
UI.SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk section content
UI.SectionContentPadding = Instance.new("UIPadding", UI.SectionContent)
UI.SectionContentPadding.PaddingTop = UDim.new(0, 10)
UI.SectionContentPadding.PaddingRight = UDim.new(0, 8)
UI.SectionContentPadding.PaddingLeft = UDim.new(0, 8)

-- Divider untuk section content
UI.SectionDivider = Instance.new("Frame", UI.SectionContent)
UI.SectionDivider.Name = "Divider"
UI.SectionDivider.BorderSizePixel = 0
UI.SectionDivider.BackgroundColor3 = COLORS.Border
UI.SectionDivider.Size = UDim2.new(1, 0, 0, 3)
UI.SectionDivider.BorderColor3 = COLORS.Border

-- 35. Folder Dialog Elements
UI.DialogElementsFolder = Instance.new("Folder", UI.TemplatesFolder)
UI.DialogElementsFolder.Name = "DialogElements"

-- Dark overlay untuk dialog
UI.DarkOverlayDialog = Instance.new("Frame", UI.DialogElementsFolder)
UI.DarkOverlayDialog.Name = "DarkOverlayDialog"
UI.DarkOverlayDialog.Visible = false
UI.DarkOverlayDialog.BorderSizePixel = 0
UI.DarkOverlayDialog.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.DarkOverlayDialog.Size = UDim2.new(1, 0, 1, 0)
UI.DarkOverlayDialog.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DarkOverlayDialog.BackgroundTransparency = 0.6

-- Sudut melengkung dark overlay
UI.DarkOverlayDialogCorner = Instance.new("UICorner", UI.DarkOverlayDialog)
UI.DarkOverlayDialogCorner.CornerRadius = UDim.new(0, 10)

-- Dialog
UI.Dialog = Instance.new("Frame", UI.DialogElementsFolder)
UI.Dialog.Name = "Dialog"
UI.Dialog.Visible = false
UI.Dialog.ZIndex = 4
UI.Dialog.BorderSizePixel = 0
UI.Dialog.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
UI.Dialog.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Dialog.ClipsDescendants = true
UI.Dialog.AutomaticSize = Enum.AutomaticSize.Y
UI.Dialog.Size = UDim2.new(0, 250, 0, 0)
UI.Dialog.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.Dialog.BorderColor3 = COLORS.Border

-- Sudut melengkung dialog
UI.DialogCorner = Instance.new("UICorner", UI.Dialog)
UI.DialogCorner.CornerRadius = UDim.new(0, 6)

-- Stroke untuk dialog
UI.DialogStroke = Instance.new("UIStroke", UI.Dialog)
UI.DialogStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.DialogStroke.Thickness = 1.5
UI.DialogStroke.Color = COLORS.Border

-- Title dialog
UI.DialogTitle = Instance.new("Frame", UI.Dialog)
UI.DialogTitle.Name = "Title"
UI.DialogTitle.BorderSizePixel = 0
UI.DialogTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DialogTitle.AutomaticSize = Enum.AutomaticSize.Y
UI.DialogTitle.Size = UDim2.new(1, 0, 0, 25)
UI.DialogTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DialogTitle.BackgroundTransparency = 1

-- Label untuk dialog title
UI.DialogTitleLabel = Instance.new("TextLabel", UI.DialogTitle)
UI.DialogTitleLabel.Interactable = false
UI.DialogTitleLabel.ZIndex = 0
UI.DialogTitleLabel.BorderSizePixel = 0
UI.DialogTitleLabel.TextSize = 20
UI.DialogTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
UI.DialogTitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DialogTitleLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.DialogTitleLabel.TextColor3 = COLORS.Text
UI.DialogTitleLabel.BackgroundTransparency = 1
UI.DialogTitleLabel.AnchorPoint = Vector2.new(0, 0.5)
UI.DialogTitleLabel.Size = UDim2.new(0, 0, 0, 20)
UI.DialogTitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DialogTitleLabel.Text = ""
UI.DialogTitleLabel.LayoutOrder = 1
UI.DialogTitleLabel.AutomaticSize = Enum.AutomaticSize.XY
UI.DialogTitleLabel.Position = UDim2.new(-0.05455, 12, 0.5, 0)

-- Layout untuk dialog title
UI.DialogTitleLayout = Instance.new("UIListLayout", UI.DialogTitle)
UI.DialogTitleLayout.Padding = UDim.new(0, 10)
UI.DialogTitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.DialogTitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.DialogTitleLayout.FillDirection = Enum.FillDirection.Horizontal

-- Padding untuk dialog title
UI.DialogTitlePadding = Instance.new("UIPadding", UI.DialogTitle)
UI.DialogTitlePadding.PaddingTop = UDim.new(0, 5)
UI.DialogTitlePadding.PaddingRight = UDim.new(0, 15)
UI.DialogTitlePadding.PaddingLeft = UDim.new(0, 15)
UI.DialogTitlePadding.PaddingBottom = UDim.new(0, 5)

-- Ikon untuk dialog title
UI.DialogTitleIcon = Instance.new("ImageButton", UI.DialogTitle)
UI.DialogTitleIcon.Name = "Icon"
UI.DialogTitleIcon.BorderSizePixel = 0
UI.DialogTitleIcon.Visible = false
UI.DialogTitleIcon.BackgroundTransparency = 1
UI.DialogTitleIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DialogTitleIcon.ImageColor3 = COLORS.Text
UI.DialogTitleIcon.Size = UDim2.new(0, 33, 0, 25)
UI.DialogTitleIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DialogTitleIcon.Position = UDim2.new(0, 0, 0.2125, 0)

-- Aspect ratio untuk dialog title icon
UI.DialogTitleIconRatio = Instance.new("UIAspectRatioConstraint", UI.DialogTitleIcon)

-- Layout untuk dialog
UI.DialogLayout = Instance.new("UIListLayout", UI.Dialog)
UI.DialogLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UI.DialogLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content dialog
UI.DialogContent = Instance.new("Frame", UI.Dialog)
UI.DialogContent.Name = "Content"
UI.DialogContent.Visible = false
UI.DialogContent.ZIndex = 2
UI.DialogContent.BorderSizePixel = 0
UI.DialogContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DialogContent.AutomaticSize = Enum.AutomaticSize.Y
UI.DialogContent.Size = UDim2.new(1, 0, 0, 0)
UI.DialogContent.Position = UDim2.new(0, 0, 0.21886, 0)
UI.DialogContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DialogContent.BackgroundTransparency = 1

-- Layout untuk dialog content
UI.DialogContentLayout = Instance.new("UIListLayout", UI.DialogContent)
UI.DialogContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.DialogContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk dialog content
UI.DialogContentPadding = Instance.new("UIPadding", UI.DialogContent)
UI.DialogContentPadding.PaddingTop = UDim.new(0, 5)
UI.DialogContentPadding.PaddingRight = UDim.new(0, 15)
UI.DialogContentPadding.PaddingLeft = UDim.new(0, 15)
UI.DialogContentPadding.PaddingBottom = UDim.new(0, 5)

-- Text untuk dialog content
UI.DialogContentText = Instance.new("TextLabel", UI.DialogContent)
UI.DialogContentText.TextWrapped = true
UI.DialogContentText.Interactable = false
UI.DialogContentText.BorderSizePixel = 0
UI.DialogContentText.TextSize = 15
UI.DialogContentText.TextXAlignment = Enum.TextXAlignment.Left
UI.DialogContentText.TextYAlignment = Enum.TextYAlignment.Top
UI.DialogContentText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DialogContentText.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.DialogContentText.TextColor3 = Color3.fromRGB(145, 154, 173)
UI.DialogContentText.BackgroundTransparency = 1
UI.DialogContentText.Size = UDim2.new(1, 0, 0, 0)
UI.DialogContentText.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DialogContentText.Text = ""
UI.DialogContentText.AutomaticSize = Enum.AutomaticSize.Y
UI.DialogContentText.Position = UDim2.new(0, 0, 0.125, 0)

-- Padding untuk dialog
UI.DialogPadding = Instance.new("UIPadding", UI.Dialog)
UI.DialogPadding.PaddingTop = UDim.new(0, 10)
UI.DialogPadding.PaddingBottom = UDim.new(0, 10)

-- Buttons dialog
UI.DialogButtons = Instance.new("Frame", UI.Dialog)
UI.DialogButtons.Name = "Buttons"
UI.DialogButtons.ZIndex = 3
UI.DialogButtons.BorderSizePixel = 0
UI.DialogButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DialogButtons.AutomaticSize = Enum.AutomaticSize.Y
UI.DialogButtons.Size = UDim2.new(1, 0, 0, 0)
UI.DialogButtons.Position = UDim2.new(0, 0, 0.53017, 0)
UI.DialogButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DialogButtons.BackgroundTransparency = 1

-- Layout untuk dialog buttons
UI.DialogButtonsLayout = Instance.new("UIListLayout", UI.DialogButtons)
UI.DialogButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UI.DialogButtonsLayout.Padding = UDim.new(0, 10)
UI.DialogButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk dialog buttons
UI.DialogButtonsPadding = Instance.new("UIPadding", UI.DialogButtons)
UI.DialogButtonsPadding.PaddingTop = UDim.new(0, 5)
UI.DialogButtonsPadding.PaddingRight = UDim.new(0, 10)
UI.DialogButtonsPadding.PaddingLeft = UDim.new(0, 10)

-- Dialog button template
UI.DialogButtonTemplate = Instance.new("Frame", UI.DialogElementsFolder)
UI.DialogButtonTemplate.Name = "DialogButton"
UI.DialogButtonTemplate.Visible = false
UI.DialogButtonTemplate.BorderSizePixel = 0
UI.DialogButtonTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DialogButtonTemplate.AnchorPoint = Vector2.new(0.5, 1)
UI.DialogButtonTemplate.Size = UDim2.new(1, 0, 0, 30)
UI.DialogButtonTemplate.Position = UDim2.new(0.5, 0, 0.327, 0)
UI.DialogButtonTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DialogButtonTemplate.BackgroundTransparency = 1

-- Button untuk dialog button
UI.DialogButton = Instance.new("TextButton", UI.DialogButtonTemplate)
UI.DialogButton.Name = "Button"
UI.DialogButton.BorderSizePixel = 0
UI.DialogButton.AutoButtonColor = false
UI.DialogButton.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
UI.DialogButton.Selectable = false
UI.DialogButton.AnchorPoint = Vector2.new(0.5, 0.5)
UI.DialogButton.Size = UDim2.new(1, 0, 1, 0)
UI.DialogButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DialogButton.Position = UDim2.new(0.5, 0, 0.5, 0)

-- Sudut melengkung dialog button
UI.DialogButtonCorner = Instance.new("UICorner", UI.DialogButton)
UI.DialogButtonCorner.CornerRadius = UDim.new(0, 5)

-- Stroke untuk dialog button
UI.DialogButtonStroke = Instance.new("UIStroke", UI.DialogButton)
UI.DialogButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.DialogButtonStroke.Thickness = 1.5
UI.DialogButtonStroke.Color = COLORS.Border

-- Layout untuk dialog button
UI.DialogButtonLayout = Instance.new("UIListLayout", UI.DialogButton)
UI.DialogButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UI.DialogButtonLayout.Padding = UDim.new(0, 5)
UI.DialogButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.DialogButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Label untuk dialog button
UI.DialogButtonLabel = Instance.new("TextLabel", UI.DialogButton)
UI.DialogButtonLabel.Name = "Label"
UI.DialogButtonLabel.TextWrapped = true
UI.DialogButtonLabel.Interactable = false
UI.DialogButtonLabel.BorderSizePixel = 0
UI.DialogButtonLabel.TextSize = 14
UI.DialogButtonLabel.TextScaled = true
UI.DialogButtonLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.DialogButtonLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
UI.DialogButtonLabel.TextColor3 = COLORS.Text
UI.DialogButtonLabel.BackgroundTransparency = 1
UI.DialogButtonLabel.Size = UDim2.new(1, 0, 0.45, 0)
UI.DialogButtonLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.DialogButtonLabel.Text = ""
UI.DialogButtonLabel.Position = UDim2.new(0, 45, 0.083, 0)

-- 36. Notification List (di ScreenGui)
UI.NotificationListScreen = Instance.new("Frame", UI.ScreenGui)
UI.NotificationListScreen.Name = "NotificationList"
UI.NotificationListScreen.ZIndex = 10
UI.NotificationListScreen.BorderSizePixel = 0
UI.NotificationListScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.NotificationListScreen.AnchorPoint = Vector2.new(0.5, 0)
UI.NotificationListScreen.Size = UDim2.new(0, 630, 1, 0)
UI.NotificationListScreen.Position = UDim2.new(1, 0, 0, 0)
UI.NotificationListScreen.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.NotificationListScreen.BackgroundTransparency = 1

-- Layout untuk notification list
UI.NotificationListScreenLayout = Instance.new("UIListLayout", UI.NotificationListScreen)
UI.NotificationListScreenLayout.Padding = UDim.new(0, 12)
UI.NotificationListScreenLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding untuk notification list
UI.NotificationListScreenPadding = Instance.new("UIPadding", UI.NotificationListScreen)
UI.NotificationListScreenPadding.PaddingTop = UDim.new(0, 10)
UI.NotificationListScreenPadding.PaddingRight = UDim.new(0, 40)
UI.NotificationListScreenPadding.PaddingLeft = UDim.new(0, 40)

-- 37. Float Icon
UI.FloatIcon = Instance.new("Frame", UI.ScreenGui)
UI.FloatIcon.Name = "FloatIcon"
UI.FloatIcon.Visible = false
UI.FloatIcon.ZIndex = 0
UI.FloatIcon.BorderSizePixel = 2
UI.FloatIcon.BackgroundColor3 = COLORS.BackgroundDark
UI.FloatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
UI.FloatIcon.ClipsDescendants = true
UI.FloatIcon.AutomaticSize = Enum.AutomaticSize.X
UI.FloatIcon.Size = UDim2.new(0, 85, 0, 45)
UI.FloatIcon.Position = UDim2.new(0.5, 0, 0, 45)
UI.FloatIcon.BorderColor3 = COLORS.Border

-- Sudut melengkung float icon
UI.FloatIconCorner = Instance.new("UICorner", UI.FloatIcon)
UI.FloatIconCorner.CornerRadius = UDim.new(0, 10)

-- Stroke untuk float icon
UI.FloatIconStroke = Instance.new("UIStroke", UI.FloatIcon)
UI.FloatIconStroke.Transparency = 0.5
UI.FloatIconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.FloatIconStroke.Thickness = 1.5
UI.FloatIconStroke.Color = Color3.fromRGB(95, 95, 117)

-- Padding untuk float icon
UI.FloatIconPadding = Instance.new("UIPadding", UI.FloatIcon)
UI.FloatIconPadding.PaddingTop = UDim.new(0, 8)
-- ==============================
-- KELANJUTAN NAT HUB UI LIBRARY - REWRITE
-- ==============================

-- 37. Float Icon (kelanjutan)
UI.FloatIconPadding.PaddingRight = UDim.new(0, 10)
UI.FloatIconPadding.PaddingLeft = UDim.new(0, 10)
UI.FloatIconPadding.PaddingBottom = UDim.new(0, 8)

-- Layout untuk float icon
UI.FloatIconLayout = Instance.new("UIListLayout", UI.FloatIcon)
UI.FloatIconLayout.Padding = UDim.new(0, 8)
UI.FloatIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.FloatIconLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.FloatIconLayout.FillDirection = Enum.FillDirection.Horizontal

-- Ikon untuk float icon
UI.FloatIconIcon = Instance.new("ImageButton", UI.FloatIcon)
UI.FloatIconIcon.Name = "Icon"
UI.FloatIconIcon.Active = false
UI.FloatIconIcon.Interactable = false
UI.FloatIconIcon.BorderSizePixel = 0
UI.FloatIconIcon.AutoButtonColor = false
UI.FloatIconIcon.BackgroundTransparency = 1
UI.FloatIconIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.FloatIconIcon.AnchorPoint = Vector2.new(0, 0.5)
UI.FloatIconIcon.Image = "rbxassetid://113216930555884"
UI.FloatIconIcon.Size = UDim2.new(1, 0, 1, 0)
UI.FloatIconIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.FloatIconIcon.Position = UDim2.new(0, 10, 0.5, 0)

-- Aspect ratio untuk float icon
UI.FloatIconIconRatio = Instance.new("UIAspectRatioConstraint", UI.FloatIconIcon)

-- Label untuk float icon
UI.FloatIconLabel = Instance.new("TextLabel", UI.FloatIcon)
UI.FloatIconLabel.Interactable = false
UI.FloatIconLabel.BorderSizePixel = 0
UI.FloatIconLabel.TextSize = 16
UI.FloatIconLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.FloatIconLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI.FloatIconLabel.TextColor3 = COLORS.Text
UI.FloatIconLabel.BackgroundTransparency = 1
UI.FloatIconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
UI.FloatIconLabel.Size = UDim2.new(0, 20, 0, 20)
UI.FloatIconLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.FloatIconLabel.Text = "NatHub"
UI.FloatIconLabel.AutomaticSize = Enum.AutomaticSize.X
UI.FloatIconLabel.Position = UDim2.new(0.38615, 0, 0.53448, -1)

-- Tombol open untuk float icon
UI.FloatIconOpenButton = Instance.new("ImageButton", UI.FloatIcon)
UI.FloatIconOpenButton.Name = "Open"
UI.FloatIconOpenButton.BorderSizePixel = 0
UI.FloatIconOpenButton.AutoButtonColor = false
UI.FloatIconOpenButton.BackgroundTransparency = 1
UI.FloatIconOpenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.FloatIconOpenButton.ImageColor3 = COLORS.Text
UI.FloatIconOpenButton.Selectable = false
UI.FloatIconOpenButton.AnchorPoint = Vector2.new(0, 0.5)
UI.FloatIconOpenButton.Image = "rbxassetid://122219713887461"
UI.FloatIconOpenButton.Size = UDim2.new(0, 20, 0, 20)
UI.FloatIconOpenButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
UI.FloatIconOpenButton.Position = UDim2.new(0, 128, 0.5, 0)

-- Aspect ratio untuk tombol open
UI.FloatIconOpenButtonRatio = Instance.new("UIAspectRatioConstraint", UI.FloatIconOpenButton)

-- Sudut melengkung tombol open
UI.FloatIconOpenButtonCorner = Instance.new("UICorner", UI.FloatIconOpenButton)

-- ==============================
-- IMPLEMENTASI LIBRARY
-- ==============================

-- Fungsi require dan cache untuk modul
local require, moduleCache = require, {}
local customRequire = function(module)
    local cached = moduleCache[module]
    if cached then
        if not cached.Required then
            cached.Required = true
            cached.Value = cached.Closure()
        end
        return cached.Value
    end
    return require(module)
end

-- Cache untuk Library Module
moduleCache[UI.LibraryModule] = {
    Closure = function()
        local libraryModule, library = UI.LibraryModule, {}
        local iconModule, userInputService, screenGui, templates, mainWindow, floatIcon = 
            customRequire(libraryModule.IconModule), 
            game:GetService("UserInputService"), 
            libraryModule.Parent, 
            libraryModule.Parent.Templates, 
            libraryModule.Parent.Window, 
            libraryModule.Parent.FloatIcon
        
        -- Sembunyikan templates sementara
        templates.Parent = nil
        mainWindow.Parent = nil
        floatIcon.Parent = nil
        
        -- Konfigurasi animasi
        local tweenConfig = {
            Global = {
                Duration = 0.25,
                EasingStyle = Enum.EasingStyle.Quart,
                EasingDirection = Enum.EasingDirection.Out
            },
            Notification = {
                Duration = 0.5,
                EasingStyle = Enum.EasingStyle.Back,
                EasingDirection = Enum.EasingDirection.Out
            },
            PopupOpen = {
                Duration = 0.4,
                EasingStyle = Enum.EasingStyle.Back,
                EasingDirection = Enum.EasingDirection.Out
            },
            PopupClose = {
                Duration = 0.4,
                EasingStyle = Enum.EasingStyle.Back,
                EasingDirection = Enum.EasingDirection.In
            }
        }
        
        -- Fungsi tween
        local tween = function(object, target, config)
            local tweenInfo = TweenInfo.new(
                config.Duration or tweenConfig.Global.Duration, 
                config.EasingStyle or Enum.EasingStyle.Linear, 
                config.EasingDirection or Enum.EasingDirection.Out
            )
            local tween = game:GetService("TweenService"):Create(object, tweenInfo, target)
            tween:Play()
            return tween
        end
        
        -- Fungsi drag
        local makeDraggable = function(dragObject, targetObject)
            local dragInput, dragStart, startPos, dragging = nil, nil, nil, false
            local tweenService = game:GetService("TweenService")
            
            local updateInput = function(input)
                local delta = input.Position - dragStart
                local position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X, 
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
                tweenService:Create(targetObject, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                    Position = position
                }):Play()
            end
            
            dragObject.InputBegan:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                    input.UserInputType == Enum.UserInputType.Touch) then
                    dragging = true
                    dragStart = input.Position
                    startPos = targetObject.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            
            dragObject.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                    input.UserInputType == Enum.UserInputType.Touch) then
                    dragInput = input
                end
            end)
            
            userInputService.InputChanged:Connect(function(input)
                if dragging and input == dragInput then
                    updateInput(input)
                end
            end)
            
            local dragFunctions = {}
            function dragFunctions.SetAllowDragging(enabled)
                dragging = enabled
            end
            return dragFunctions
        end
        
        -- Windows list
        local windows = {}
        
        -- Fungsi untuk membuat window
        function library.CreateWindow(config)
            local windowConfig, windowFolder = {
                Title = config.Title,
                Icon = config.Icon,
                Version = config.Author,
                Folder = config.Folder,
                Size = config.Size,
                ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift,
                LiveSearchDropdown = config.LiveSearchDropdown or false
            }, Instance.new("Folder")
            
            windowFolder.Parent = screenGui
            screenGui.Name = windowConfig.Title
            
            -- Clone float icon
            local floatIconClone = floatIcon:Clone()
            floatIconClone.Parent = windowFolder
            floatIconClone.TextLabel.Text = windowConfig.Title
            floatIconClone.Visible = false
            
            -- Set icon
            if not windowConfig.Icon:find("rbxassetid") then
                local iconData = iconModule.Icon(windowConfig.Icon)
                floatIconClone.Icon.Image = iconData[1] or windowConfig.Icon or ""
                floatIconClone.Icon.ImageRectOffset = iconData[2].ImageRectPosition or Vector2.new(0, 0)
                floatIconClone.Icon.ImageRectSize = iconData[2].ImageRectSize or Vector2.new(0, 0)
            else
                floatIconClone.Icon.Image = windowConfig.Icon
            end
            
            -- Clone main window
            local mainWindowClone = mainWindow:Clone()
            local window = mainWindowClone
            local topFrame, tabButtons, tabs = window.TopFrame, window.TabButtons, window.Tabs
            
            window.Name = windowConfig.Title
            topFrame.TextLabel.Text = windowConfig.Title .. " - " .. windowConfig.Version
            
            -- Set icon
            if not windowConfig.Icon:find("rbxassetid") then
                local iconData = iconModule.Icon(windowConfig.Icon)
                topFrame.Icon.Image = iconData[1] or windowConfig.Icon or ""
                topFrame.Icon.ImageRectOffset = iconData[2].ImageRectPosition or Vector2.new(0, 0)
                topFrame.Icon.ImageRectSize = iconData[2].ImageRectSize or Vector2.new(0, 0)
            else
                topFrame.Icon.Image = windowConfig.Icon
            end
            
            window.Size = windowConfig.Size
            window.Visible = false
            window.Parent = windowFolder
            table.insert(windows, window)
            
            local tabsData, tabsList = {}, {}
            local selectedTab, dropdownOpen = nil, false
            
            -- Fungsi untuk mendaftarkan tab
            local registerTab = function(name, tabObject, tabButton, hasIcon)
                local tabInfo = {
                    Name = name,
                    TabObject = tabObject,
                    TabButton = tabButton,
                    HasIcon = hasIcon
                }
                tabsData[name] = tabInfo
                table.insert(tabsList, tabsData[name])
            end
            
            -- Fungsi untuk toggle dropdown
            local toggleDropdown = function(open, selectedTabName)
                if selectedTabName and dropdownOpen == false then
                    selectedTab = selectedTabName
                    -- Tutup semua dropdown
                    for _, folder in window.DropdownSelection.Dropdowns:GetChildren() do
                        if folder:IsA("Folder") then
                            folder:FindFirstChild("DropdownItems").Visible = false
                            folder:FindFirstChild("DropdownItemsSearch").Visible = false
                        end
                    end
                    -- Buka dropdown yang dipilih
                    window.DropdownSelection.TopBar.Title.Text = selectedTabName
                    local selectedFolder = window.DropdownSelection.Dropdowns:FindFirstChild(selectedTabName)
                    if selectedFolder then
                        selectedFolder:FindFirstChild("DropdownItems").Visible = true
                        selectedFolder:FindFirstChild("DropdownItemsSearch").Visible = false
                    end
                end
                
                if open == true then
                    window.DropdownSelection.Size = UDim2.new(0, 0, 0, 0)
                    window.DarkOverlay.BackgroundTransparency = 1
                    window.DropdownSelection.Visible = true
                    window.DarkOverlay.Visible = true
                    window.DropdownSelection.Size = UDim2.new(0.728, 0, 0.684, 0)
                    tween(window.DarkOverlay, {
                        BackgroundTransparency = 0.6
                    }, tweenConfig.PopupOpen)
                    dropdownOpen = open
                elseif open == false then
                    window.DropdownSelection.Size = UDim2.new(0, 0, 0, 0)
                    local closeTween = tween(window.DarkOverlay, {
                        BackgroundTransparency = 1
                    }, tweenConfig.PopupClose)
                    closeTween.Completed:Wait()
                    window.DropdownSelection.Visible = false
                    window.DarkOverlay.Visible = false
                    dropdownOpen = open
                else
                    -- Toggle
                    if dropdownOpen then
                        window.DropdownSelection.Size = UDim2.new(0, 0, 0, 0)
                        local closeTween = tween(window.DarkOverlay, {
                            BackgroundTransparency = 1
                        }, tweenConfig.PopupClose)
                        closeTween.Completed:Wait()
                        window.DropdownSelection.Visible = false
                        window.DarkOverlay.Visible = false
                        dropdownOpen = false
                    else
                        window.DropdownSelection.Size = UDim2.new(0, 0, 0, 0)
                        window.DarkOverlay.BackgroundTransparency = 1
                        window.DropdownSelection.Visible = true
                        window.DarkOverlay.Visible = true
                        window.DropdownSelection.Size = UDim2.new(0.728, 0, 0.684, 0)
                        tween(window.DarkOverlay, {
                            BackgroundTransparency = 0.6
                        }, tweenConfig.PopupOpen)
                        dropdownOpen = true
                    end
                end
            end
            
            -- Fungsi untuk memilih tab
            local selectTab = function(tabName)
                for name, tabInfo in pairs(tabsData) do
                    if name ~= tabName then
                        tabInfo.TabObject.Visible = false
                        tween(tabInfo.TabButton.TextLabel, {
                            Position = UDim2.new(0, 42, 0.5, 0),
                            Size = UDim2.new(0, 103, 0, 16),
                            TextTransparency = 0.5
                        }, tweenConfig.Global)
                        tween(tabInfo.TabButton.ImageButton, {
                            Position = UDim2.new(0, 12, 0, 18),
                            ImageTransparency = 0.5
                        }, tweenConfig.Global)
                        tween(tabInfo.TabButton.Bar, {
                            Size = UDim2.new(0, 5, 0, 0),
                            BackgroundTransparency = 1
                        }, tweenConfig.Global)
                    elseif name == tabName then
                        selectedTab = tabName
                        tabInfo.TabObject.Visible = true
                        tween(tabInfo.TabButton.TextLabel, {
                            Position = UDim2.new(0, 57, 0.5, 0),
                            Size = UDim2.new(0, 88, 0, 16),
                            TextTransparency = 0
                        }, tweenConfig.Global)
                        tween(tabInfo.TabButton.ImageButton, {
                            Position = UDim2.new(0, 25, 0, 18),
                            ImageTransparency = 0
                        }, tweenConfig.Global)
                        tween(tabInfo.TabButton.Bar, {
                            Size = UDim2.new(0, 5, 0, 25),
                            BackgroundTransparency = 0
                        }, tweenConfig.Global)
                        
                        -- Cek apakah tab kosong
                        local guiObjectCount = 0
                        for _, child in ipairs(tabInfo.TabObject:GetChildren()) do
                            if child:IsA("GuiObject") then
                                guiObjectCount = guiObjectCount + 1
                            end
                        end
                        if guiObjectCount == 0 then
                            tabs.NoObjectFoundText.Visible = true
                        else
                            tabs.NoObjectFoundText.Visible = false
                        end
                    end
                end
            end
            
            -- Event handler untuk close dropdown
            window.DropdownSelection.TopBar.Close.MouseButton1Click:Connect(function()
                toggleDropdown(false)
            end)
            
            -- Search functionality
            local searchBox = window.DropdownSelection.TopBar.BoxFrame.Frame.TextBox
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                if not windowConfig.LiveSearchDropdown then
                    return
                end
                
                local dropdownFolder = window.DropdownSelection.Dropdowns:FindFirstChild(selectedTab)
                if string.gsub(searchBox.Text, " ", "") ~= "" then
                    if not dropdownFolder then
                        return
                    end
                    dropdownFolder:FindFirstChild("DropdownItems").Visible = false
                    dropdownFolder:FindFirstChild("DropdownItemsSearch").Visible = true
                    
                    for _, item in dropdownFolder:FindFirstChild("DropdownItemsSearch"):GetChildren() do
                        if item:IsA("GuiButton") then
                            if string.find(item.Name:lower(), searchBox.Text:lower()) then
                                item.Visible = true
                            else
                                item.Visible = false
                            end
                        end
                    end
                else
                    dropdownFolder:FindFirstChild("DropdownItems").Visible = true
                    dropdownFolder:FindFirstChild("DropdownItemsSearch").Visible = false
                end
            end)
            
            searchBox.FocusLost:Connect(function()
                if windowConfig.LiveSearchDropdown then
                    return
                end
                
                local dropdownFolder = window.DropdownSelection.Dropdowns:FindFirstChild(selectedTab)
                if string.gsub(searchBox.Text, " ", "") ~= "" then
                    if not dropdownFolder then
                        return
                    end
                    dropdownFolder:FindFirstChild("DropdownItems").Visible = false
                    dropdownFolder:FindFirstChild("DropdownItemsSearch").Visible = true
                    
                    for _, item in dropdownFolder:FindFirstChild("DropdownItemsSearch"):GetChildren() do
                        if item:IsA("GuiButton") then
                            if string.find(item.Name:lower(), searchBox.Text:lower()) then
                                item.Visible = true
                            else
                                item.Visible = false
                            end
                        end
                    end
                else
                    dropdownFolder:FindFirstChild("DropdownItems").Visible = true
                    dropdownFolder:FindFirstChild("DropdownItemsSearch").Visible = false
                end
            end)
            
            -- Fungsi untuk membuat tab
            function windowConfig.Tab(tabName, tabConfig)
                local tabFunctions, tabInfo, tabButton = {}, {
                    Title = tabConfig.Title,
                    Icon = tabConfig.Icon
                }, templates.TabButton:Clone()
                
                tabButton.Name = tabInfo.Title
                tabButton.Parent = window.TabButtons.Lists
                tabButton.Visible = true
                tabButton.TextLabel.Text = tabInfo.Title
                
                -- Set icon
                local iconData = iconModule.Icon(tabInfo.Icon)
                tabButton.ImageButton.Image = (iconData and iconData[1]) or tabInfo.Icon or ""
                tabButton.ImageButton.ImageRectOffset = (iconData and iconData[2].ImageRectPosition) or Vector2.new(0, 0)
                tabButton.ImageButton.ImageRectSize = (iconData and iconData[2].ImageRectSize) or Vector2.new(0, 0)
                
                local tabContent = templates.Tab:Clone()
                tabContent.Name = tabInfo.Title
                tabContent.Parent = window.Tabs
                tabContent.Visible = false
                
                registerTab(tabInfo.Title, tabContent, tabButton)
                
                -- Set initial tab state
                if selectedTab == tabInfo.Title then
                    tabContent.Visible = true
                    tabButton.TextLabel.Position = UDim2.new(0, 57, 0.5, 0)
                    tabButton.TextLabel.Size = UDim2.new(0, 88, 0, 16)
                    tabButton.TextLabel.TextTransparency = 0
                    tabButton.ImageButton.Position = UDim2.new(0, 25, 0, 18)
                    tabButton.ImageButton.ImageTransparency = 0
                    tabButton.Bar.Size = UDim2.new(0, 5, 0, 25)
                    tabButton.Bar.BackgroundTransparency = 0
                else
                    tabButton.TextLabel.Position = UDim2.new(0, 42, 0.5, 0)
                    tabButton.TextLabel.Size = UDim2.new(0, 103, 0, 16)
                    tabButton.TextLabel.TextTransparency = 0.5
                    tabButton.ImageButton.Position = UDim2.new(0, 12, 0, 18)
                    tabButton.ImageButton.ImageTransparency = 0.5
                    tabButton.Bar.Size = UDim2.new(0, 5, 0, 0)
                    tabButton.Bar.BackgroundTransparency = 1
                end
                
                tabButton.MouseButton1Click:Connect(function()
                    selectTab(tabInfo.Title)
                end)
                
                -- Helper functions
                local getElements, tabContainer = function()
                    local elements = {}
                    for _, child in pairs(tabContent:GetChildren()) do
                        if child:IsA("GuiObject") then
                            table.insert(elements, child)
                        end
                    end
                    return elements
                end, tabContent
                
                -- Fungsi untuk membuat section
                function tabFunctions.Section(sectionName, sectionConfig)
                    local sectionFunctions, sectionInstance = {
                        Title = sectionConfig.Title,
                        State = sectionConfig.Default or false,
                        TextXAlignment = sectionConfig.TextXAlignment or "Left"
                    }, templates.Section:Clone()
                    
                    sectionInstance.Name = sectionFunctions.Title
                    sectionInstance.Button.Title.Text = sectionFunctions.Title
                    sectionInstance.Button.Title.TextXAlignment = Enum.TextXAlignment[sectionFunctions.TextXAlignment]
                    sectionInstance.Visible = true
                    sectionInstance.Parent = tabContainer
                    
                    -- Toggle section
                    sectionInstance.Button.MouseButton1Click:Connect(function()
                        if sectionFunctions.State == true then
                            sectionInstance.Frame.Visible = false
                            tween(sectionInstance.Button.Title.Arrow, {
                                Rotation = 0
                            }, tweenConfig.Global)
                            sectionFunctions.State = false
                        elseif sectionFunctions.State == false then
                            sectionInstance.Frame.Visible = true
                            tween(sectionInstance.Button.Title.Arrow, {
                                Rotation = 90
                            }, tweenConfig.Global)
                            sectionFunctions.State = true
                        end
                    end)
                    
                    function sectionFunctions.SetTitle(self, newTitle)
                        sectionFunctions.Title = newTitle
                        sectionInstance.Button.Title.Text = newTitle
                    end
                    
                    function sectionFunctions.Destroy(self)
                        tabContainer:Destroy()
                    end
                    
                    tabContainer = sectionInstance.Frame
                    return sectionFunctions
                end
                
                -- Fungsi untuk membuat button
                function tabFunctions.Button(buttonName, buttonConfig)
                    local buttonFunctions, buttonInfo, buttonInstance = {}, {
                        Title = buttonConfig.Title,
                        Desc = buttonConfig.Desc,
                        Locked = buttonConfig.Locked or false,
                        Callback = buttonConfig.Callback or function() end
                    }, templates.Button:Clone()
                    
                    buttonInstance.Name = buttonInfo.Title
                    buttonInstance.Parent = tabContainer
                    buttonInstance.Frame.Title.Text = buttonInfo.Title
                    
                    if buttonInfo.Desc and buttonInfo.Desc ~= "" then
                        buttonInstance.Frame.Description.Visible = true
                        buttonInstance.Frame.Description.Text = buttonInfo.Desc
                    end
                    
                    if buttonInfo.Locked then
                        buttonInstance.UIStroke.Color = Color3.fromRGB(47, 47, 58)
                        buttonInstance.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
                        buttonInstance.Frame.Title.TextColor3 = Color3.fromRGB(75, 77, 83)
                        buttonInstance.Frame.Title.ClickIcon.ImageColor3 = Color3.fromRGB(75, 77, 83)
                        buttonInstance.Frame.Description.TextColor3 = Color3.fromRGB(75, 77, 83)
                    end
                    
                    buttonInstance.Visible = true
                    
                    -- Random gradient effect
                    local activateRandomGradient = function()
                        local gradients = {}
                        for _, child in ipairs(buttonInstance.Frame:GetChildren()) do
                            if child:IsA("UIGradient") then
                                child.Enabled = false
                                table.insert(gradients, child)
                            end
                        end
                        local selectedGradient = gradients[math.random(1, #gradients)]
                        selectedGradient.Enabled = true
                        return selectedGradient
                    end
                    
                    activateRandomGradient()
                    
                    -- Mouse events
                    buttonInstance.MouseEnter:Connect(function()
                        if not buttonInfo.Locked then
                            tween(buttonInstance.UIStroke, {
                                Color = Color3.fromRGB(10, 135, 213)
                            }, tweenConfig.Global)
                        end
                    end)
                    
                    buttonInstance.MouseLeave:Connect(function()
                        if not buttonInfo.Locked then
                            tween(buttonInstance.UIStroke, {
                                Color = Color3.fromRGB(60, 60, 74)
                            }, tweenConfig.Global)
                            buttonInstance.BackgroundColor3 = Color3.fromRGB(42, 45, 52)
                            tween(buttonInstance.Frame.Title, {
                                TextColor3 = Color3.fromRGB(196, 203, 218)
                            }, tweenConfig.Global)
                            tween(buttonInstance.Frame.Description, {
                                TextColor3 = Color3.fromRGB(196, 203, 218)
                            }, tweenConfig.Global)
                        end
                    end)
                    
                    buttonInstance.MouseButton1Down:Connect(function()
                        if not buttonInfo.Locked then
                            activateRandomGradient()
                            tween(buttonInstance.Frame.Title, {
                                TextColor3 = Color3.fromRGB(255, 255, 255)
                            }, tweenConfig.Global)
                            tween(buttonInstance.Frame.Title.ClickIcon, {
                                ImageColor3 = Color3.fromRGB(255, 255, 255)
                            }, tweenConfig.Global)
                            tween(buttonInstance.Frame.Description, {
                                TextColor3 = Color3.fromRGB(255, 255, 255)
                            }, tweenConfig.Global)
                            tween(buttonInstance.Frame, {
                                BackgroundTransparency = 0
                            }, tweenConfig.Global)
                        end
                    end)
                    
                    buttonInstance.MouseButton1Up:Connect(function()
                        if not buttonInfo.Locked then
                            tween(buttonInstance.Frame.Title, {
                                TextColor3 = Color3.fromRGB(196, 203, 218)
                            }, tweenConfig.Global)
                            tween(buttonInstance.Frame.Title.ClickIcon, {
                              -- ==============================
-- KELANJUTAN NAT HUB UI LIBRARY - REWRITE
-- ==============================

-- Kelanjutan dari fungsi tabFunctions.Button.MouseButton1Up
buttonInstance.MouseButton1Up:Connect(function()
    if not buttonInfo.Locked then
        tween(buttonInstance.Frame.Title.ClickIcon, {
            ImageColor3 = Color3.fromRGB(196, 203, 218)
        }, tweenConfig.Global)
        tween(buttonInstance.Frame.Description, {
            TextColor3 = Color3.fromRGB(196, 203, 218)
        }, tweenConfig.Global)
        tween(buttonInstance.Frame, {
            BackgroundTransparency = 1
        }, tweenConfig.Global)
    end
end)

buttonInstance.MouseLeave:Connect(function()
    if not buttonInfo.Locked then
        tween(buttonInstance.Frame.Title, {
            TextColor3 = Color3.fromRGB(196, 203, 218)
        }, tweenConfig.Global)
        tween(buttonInstance.Frame.Title.ClickIcon, {
            ImageColor3 = Color3.fromRGB(196, 203, 218)
        }, tweenConfig.Global)
        tween(buttonInstance.Frame.Description, {
            TextColor3 = Color3.fromRGB(196, 203, 218)
        }, tweenConfig.Global)
        tween(buttonInstance.Frame, {
            BackgroundTransparency = 1
        }, tweenConfig.Global)
    end
end)

buttonInstance.MouseButton1Click:Connect(function()
    if not buttonInfo.Locked then
        buttonInfo.Callback()
    end
end)

-- Monitor perubahan pada tab untuk menampilkan/menyembunyikan teks "No Object Found"
tabContent.ChildAdded:Connect(function()
    if #getElements() > 0 then
        tabs.NoObjectFoundText.Visible = false
    else
        tabs.NoObjectFoundText.Visible = true
    end
end)

tabContent.ChildRemoved:Connect(function()
    if #getElements() > 0 then
        tabs.NoObjectFoundText.Visible = false
    else
        tabs.NoObjectFoundText.Visible = true
    end
end)

-- Fungsi untuk mengubah judul button
function buttonFunctions.SetTitle(self, newTitle)
    buttonInstance.Frame.Title.Text = newTitle
end

-- Fungsi untuk mengubah deskripsi button
function buttonFunctions.SetDesc(self, newDesc)
    if newDesc and newDesc ~= "" then
        buttonInstance.Frame.Description.Text = newDesc
    end
end

-- Fungsi untuk mengunci button
function buttonFunctions.Lock(self)
    buttonInfo.Locked = true
    tween(buttonInstance, {
        BackgroundColor3 = Color3.fromRGB(32, 35, 40)
    }, tweenConfig.Global)
    tween(buttonInstance.UIStroke, {
        Color = Color3.fromRGB(47, 47, 58)
    }, tweenConfig.Global)
    tween(buttonInstance.Frame.Title, {
        TextColor3 = Color3.fromRGB(75, 77, 83)
    }, tweenConfig.Global)
    tween(buttonInstance.Frame.Title.ClickIcon, {
        ImageColor3 = Color3.fromRGB(75, 77, 83)
    }, tweenConfig.Global)
    tween(buttonInstance.Frame.Description, {
        TextColor3 = Color3.fromRGB(75, 77, 83)
    }, tweenConfig.Global)
end

-- Fungsi untuk membuka kunci button
function buttonFunctions.Unlock(self)
    buttonInfo.Locked = false
    tween(buttonInstance, {
        BackgroundColor3 = Color3.fromRGB(42, 45, 52)
    }, tweenConfig.Global)
    tween(buttonInstance.UIStroke, {
        Color = Color3.fromRGB(60, 60, 74)
    }, tweenConfig.Global)
    tween(buttonInstance.Frame.Title, {
        TextColor3 = Color3.fromRGB(196, 203, 218)
    }, tweenConfig.Global)
    tween(buttonInstance.Frame.Title.ClickIcon, {
        ImageColor3 = Color3.fromRGB(196, 203, 218)
    }, tweenConfig.Global)
    tween(buttonInstance.Frame.Description, {
        TextColor3 = Color3.fromRGB(196, 203, 218)
    }, tweenConfig.Global)
end

-- Fungsi untuk menghapus button
function buttonFunctions.Destroy(self)
    buttonInstance:Destroy()
end

return buttonFunctions

-- Fungsi untuk membuat Code
function tabFunctions.Code(codeName, codeConfig)
    local codeFunctions, codeInstance = {}, {
        Title = codeConfig.Title,
        Code = codeConfig.Code
    }, templates.Code:Clone()
    
    codeInstance.Name = codeFunctions.Title
    codeInstance.Parent = tabContainer
    codeInstance.Title.Text = codeFunctions.Title
    codeInstance.Code.Text = codeFunctions.Code
    codeInstance.Code.Visible = true
    codeInstance.Code.Font = Enum.Font.Code
    codeInstance.Visible = true
    
    -- Fungsi untuk mengubah judul code
    function codeFunctions.SetTitle(self, newTitle)
        codeFunctions.Title = newTitle
        codeInstance.Title.Text = newTitle
    end
    
    -- Fungsi untuk mengubah isi code
    function codeFunctions.SetCode(self, newCode)
        codeFunctions.Code = newCode
        codeInstance.Code.Text = newCode
    end
    
    -- Fungsi untuk menghapus code
    function codeFunctions.Destroy(self)
        codeInstance:Destroy()
    end
    
    return codeFunctions
end

-- Fungsi untuk membuat Paragraph
function tabFunctions.Paragraph(paragraphName, paragraphConfig)
    local paragraphFunctions, paragraphInstance = {}, {
        Title = paragraphConfig.Title,
        Desc = paragraphConfig.Desc,
        RichText = paragraphConfig.RichText or false
    }, templates.Paragraph:Clone()
    
    paragraphInstance.Name = paragraphFunctions.Title
    paragraphInstance.Parent = tabContainer
    paragraphInstance.Title.Text = paragraphFunctions.Title
    
    if paragraphFunctions.Desc and paragraphFunctions.Desc ~= "" then
        paragraphInstance.Description.Text = paragraphFunctions.Desc
        paragraphInstance.Description.Visible = true
    else
        paragraphInstance.Description.Visible = false
    end
    
    paragraphInstance.Title.RichText = paragraphFunctions.RichText
    paragraphInstance.Description.RichText = paragraphFunctions.RichText
    paragraphInstance.Visible = true
    
    -- Fungsi untuk mengubah judul paragraph
    function paragraphFunctions.SetTitle(self, newTitle)
        paragraphFunctions.Title = newTitle
        paragraphInstance.Title.Text = newTitle
    end
    
    -- Fungsi untuk mengubah deskripsi paragraph
    function paragraphFunctions.SetDesc(self, newDesc)
        paragraphFunctions.Desc = newDesc
        paragraphInstance.Description.Text = newDesc
        if newDesc ~= "" then
            paragraphInstance.Visible = true
        else
            paragraphInstance.Visible = false
        end
    end
    
    -- Fungsi untuk menghapus paragraph
    function paragraphFunctions.Destroy(self)
        paragraphInstance:Destroy()
    end
    
    return paragraphFunctions
end

-- Fungsi untuk membuat Colorpicker (placeholder)
function tabFunctions.Colorpicker(colorpickerName)
    -- Fungsi ini sengaja dikosongkan dalam kode asli
end

-- Fungsi untuk membuat Toggle
function tabFunctions.Toggle(toggleName, toggleConfig)
    local toggleFunctions, toggleInfo = {}, {
        Title = toggleConfig.Title,
        Desc = toggleConfig.Desc,
        State = toggleConfig.Default or toggleConfig.Value or false,
        Locked = toggleConfig.Locked or false,
        Icon = toggleConfig.Icon,
        Callback = toggleConfig.Callback or function() end
    }, templates.Toggle:Clone()
    
    toggleInstance.Name = toggleFunctions.Title
    toggleInstance.Parent = tabContainer
    toggleInstance.Title.Text = toggleFunctions.Title
    
    -- Set ikon toggle
    if toggleFunctions.Icon then
        if string.find(toggleFunctions.Icon, "rbxassetid") or string.match(toggleFunctions.Icon, "%d") then
            toggleInstance.Title.Fill.Ball.Icon.Image = toggleFunctions.Icon
        else
            local iconData = iconModule.Icon(toggleFunctions.Icon)
            toggleInstance.Title.Fill.Ball.Icon.Image = (iconData and iconData[1]) or toggleFunctions.Icon or ""
            toggleInstance.Title.Fill.Ball.Icon.ImageRectOffset = (iconData and iconData[2].ImageRectPosition) or Vector2.new(0, 0)
            toggleInstance.Title.Fill.Ball.Icon.ImageRectSize = (iconData and iconData[2].ImageRectSize) or Vector2.new(0, 0)
        end
    end
    
    -- Set deskripsi toggle
    if toggleFunctions.Desc and toggleFunctions.Desc ~= "" then
        toggleInstance.Description.Visible = true
        toggleInstance.Description.Text = toggleFunctions.Desc
    end
    
    -- Set state awal toggle
    if toggleFunctions.State == true then
        toggleInstance.Title.Fill.Ball.Position = UDim2.new(0.5, 0, 0.5, 0)
        toggleInstance.Title.Fill.BackgroundColor3 = Color3.fromRGB(192, 209, 199)
        toggleInstance.Title.Fill.Ball.Icon.ImageTransparency = 0
    else
        toggleInstance.Title.Fill.Ball.Position = UDim2.new(0, 0, 0.5, 0)
        toggleInstance.Title.Fill.BackgroundColor3 = Color3.fromRGB(53, 56, 62)
        toggleInstance.Title.Fill.Ball.Icon.ImageTransparency = 1
    end
    
    -- Set state terkunci
    if toggleFunctions.Locked then
        toggleInstance.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        toggleInstance.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        toggleInstance.Title.TextColor3 = Color3.fromRGB(75, 77, 83)
        toggleInstance.Description.TextColor3 = Color3.fromRGB(75, 77, 83)
        toggleInstance.Title.Fill.BackgroundTransparency = 0.7
        toggleInstance.Title.Fill.Ball.BackgroundTransparency = 0.7
    end
    
    toggleInstance.Visible = true
    
    -- Event mouse enter
    toggleInstance.Title.Fill.MouseEnter:Connect(function()
        if not toggleFunctions.Locked then
            tween(toggleInstance.UIStroke, {
                Color = Color3.fromRGB(10, 135, 213)
            }, tweenConfig.Global)
        end
    end)
    
    -- Event mouse leave
    toggleInstance.Title.Fill.MouseLeave:Connect(function()
        if not toggleFunctions.Locked then
            tween(toggleInstance.UIStroke, {
                Color = Color3.fromRGB(60, 60, 74)
            }, tweenConfig.Global)
            toggleInstance.BackgroundColor3 = Color3.fromRGB(42, 45, 52)
            tween(toggleInstance.Title, {
                TextColor3 = Color3.fromRGB(196, 203, 218)
            }, tweenConfig.Global)
            tween(toggleInstance.Description, {
                TextColor3 = Color3.fromRGB(196, 203, 218)
            }, tweenConfig.Global)
        end
    end)
    
    -- Fungsi untuk mengubah posisi ball toggle
    local setTogglePosition = function(state)
        if state == true then
            tween(toggleInstance.Title.Fill.Ball, {
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, tweenConfig.Global)
            tween(toggleInstance.Title.Fill, {
                BackgroundColor3 = Color3.fromRGB(192, 209, 199)
            }, tweenConfig.Global)
            tween(toggleInstance.Title.Fill.Ball.Icon, {
                ImageTransparency = 0
            }, tweenConfig.Global)
        elseif state == false then
            tween(toggleInstance.Title.Fill.Ball, {
                Position = UDim2.new(0, 0, 0.5, 0)
            }, tweenConfig.Global)
            tween(toggleInstance.Title.Fill, {
                BackgroundColor3 = Color3.fromRGB(53, 56, 62)
            }, tweenConfig.Global)
            tween(toggleInstance.Title.Fill.Ball.Icon, {
                ImageTransparency = 1
            }, tweenConfig.Global)
        end
    end
    
    -- Fungsi untuk toggle state
    local toggleState = function(newState)
        if newState then
            setTogglePosition(newState)
        else
            setTogglePosition(not toggleFunctions.State)
        end
        toggleFunctions.State = newState or not toggleFunctions.State
        toggleFunctions.Callback(toggleFunctions.State)
    end
    
    -- Event klik pada toggle
    toggleInstance.Title.Fill.MouseButton1Click:Connect(function()
        if not toggleFunctions.Locked then
            toggleState()
        end
    end)
    
    -- Fungsi untuk mengubah judul toggle
    function toggleFunctions.SetTitle(self, newTitle)
        toggleFunctions.Title = newTitle
        toggleInstance.Title.Text = newTitle
    end
    
    -- Fungsi untuk mengubah deskripsi toggle
    function toggleFunctions.SetDesc(self, newDesc)
        if newDesc and newDesc ~= "" then
            toggleFunctions.Desc = newDesc
            toggleInstance.Description.Text = newDesc
        end
    end
    
    -- Fungsi untuk mengatur state toggle
    function toggleFunctions.Set(self, newState)
        toggleState(newState)
    end
    
    -- Fungsi untuk mengunci toggle
    function toggleFunctions.Lock(self)
        toggleFunctions.Locked = true
        tween(toggleInstance, {
            BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        }, tweenConfig.Global)
        tween(toggleInstance.UIStroke, {
            Color = Color3.fromRGB(47, 47, 58)
        }, tweenConfig.Global)
        tween(toggleInstance.Title, {
            TextColor3 = Color3.fromRGB(75, 77, 83)
        }, tweenConfig.Global)
        tween(toggleInstance.Description, {
            TextColor3 = Color3.fromRGB(75, 77, 83)
        }, tweenConfig.Global)
        tween(toggleInstance.Title.Fill, {
            BackgroundTransparency = 0.7
        }, tweenConfig.Global)
        tween(toggleInstance.Title.Fill.Ball, {
            BackgroundTransparency = 0.7
        }, tweenConfig.Global)
    end
    
    -- Fungsi untuk membuka kunci toggle
    function toggleFunctions.Unlock(self)
        toggleFunctions.Locked = false
        tween(toggleInstance, {
            BackgroundColor3 = Color3.fromRGB(42, 45, 52)
        }, tweenConfig.Global)
        tween(toggleInstance.UIStroke, {
            Color = Color3.fromRGB(60, 60, 74)
        }, tweenConfig.Global)
        tween(toggleInstance.Title, {
            TextColor3 = Color3.fromRGB(196, 203, 218)
        }, tweenConfig.Global)
        tween(toggleInstance.Description, {
            TextColor3 = Color3.fromRGB(196, 203, 218)
        }, tweenConfig.Global)
        tween(toggleInstance.Title.Fill, {
            BackgroundTransparency = 0
        }, tweenConfig.Global)
        tween(toggleInstance.Title.Fill.Ball, {
            BackgroundTransparency = 0
        }, tweenConfig.Global)
    end
    
    -- Fungsi untuk menghapus toggle
    function toggleFunctions.Destroy(self)
        toggleInstance:Destroy()
    end
    
    -- Panggil callback dengan state awal
    toggleFunctions.Callback(toggleFunctions.State)
    
    return toggleFunctions
end

-- Fungsi untuk membuat Slider
function tabFunctions.Slider(sliderName, sliderConfig)
    local sliderInfo = {
        Title = sliderConfig.Title,
        Desc = sliderConfig.Desc,
        Step = sliderConfig.Step or 1,
        Value = {
            Min = sliderConfig.Value.Min or 0,
            Max = sliderConfig.Value.Max or nil,
            Default = nil
        },
        Locked = sliderConfig.Locked,
        Callback = sliderConfig.Callback or function() end
    }
    
    sliderInfo.Value.Default = sliderConfig.Value.Default or sliderConfig.Default or sliderInfo.Value.Min
    
    local step, sliderInstance, mouse, sliderClone = sliderInfo.Step, templates.Slider:Clone(), game.Players.LocalPlayer:GetMouse(), templates.Slider:Clone()
    
    sliderClone.Parent = tabContainer
    sliderClone.Name = sliderInfo.Title
    sliderClone.Title.Text = sliderInfo.Title
    
    if sliderInfo.Desc and sliderInfo.Desc ~= "" then
        sliderClone.Description.Visible = true
        sliderClone.Description.Text = sliderInfo.Desc
    end
    
    sliderClone.Visible = true
    
    -- Fungsi untuk mengaktifkan gradien acak
    local activateRandomGradient = function()
        local gradients = {}
        for _, gradient in ipairs(sliderClone.SliderFrame.Frame.Slider.Fill.BackgroundGradient:GetChildren()) do
            if gradient:IsA("UIGradient") then
                gradient.Enabled = false
                table.insert(gradients, gradient)
            end
        end
        local selectedGradient = gradients[math.random(1, #gradients)]
        selectedGradient.Enabled = true
        return selectedGradient
    end
    
    -- Atur ukuran gradien
    sliderClone.SliderFrame.Frame.Slider.Fill.BackgroundGradient.Size = UDim2.new(0, sliderClone.SliderFrame.Frame.Slider.AbsoluteSize.X, 1, 0)
    sliderClone.SliderFrame.Frame.Slider:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        sliderClone.SliderFrame.Frame.Slider.Fill.BackgroundGradient.Size = UDim2.new(0, sliderClone.SliderFrame.Frame.Slider.AbsoluteSize.X, 1, 0)
    end)
    
    -- Deteksi perubahan ukuran untuk mengaktifkan gradien
    local lastSize
    sliderClone.SliderFrame.Frame.Slider.Fill:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if sliderClone.SliderFrame.Frame.Slider.Fill.AbsoluteSize.X <= 3 then
            lastSize = sliderClone.SliderFrame.Frame.Slider.Fill.AbsoluteSize.X
        end
        if lastSize and sliderClone.SliderFrame.Frame.Slider.Fill.AbsoluteSize.X > lastSize then
            activateRandomGradient()
            lastSize = nil
        end
    end)
    
    activateRandomGradient()
    
    -- Set state terkunci
    if sliderInfo.Locked then
        sliderClone.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        sliderClone.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        sliderClone.Title.TextColor3 = Color3.fromRGB(75, 77, 83)
        sliderClone.Description.TextColor3 = Color3.fromRGB(75, 77, 83)
        sliderClone.SliderFrame.Frame.Slider.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        sliderClone.SliderFrame.Frame.Slider.BackgroundTransparency = 0.5
        sliderClone.SliderFrame.Frame.Slider.Fill.UIStroke.Transparency = 0.5
        sliderClone.SliderFrame.Frame.Slider.Fill.BackgroundGradient.BackgroundTransparency = 0.5
        sliderClone.SliderFrame.Frame.ValueText.TextTransparency = 0.6
    end
    
    -- Variabel untuk slider
    local sliderTrigger, valueText, sliderFill, sliderElement, defaultValue, minValue, maxValue, step, currentValue, isDragging, isHovering = 
        sliderClone.SliderFrame.Frame.Slider.Trigger, 
        sliderClone.SliderFrame.Frame.ValueText, 
        sliderClone.SliderFrame.Frame.Slider.Fill, 
        sliderClone, 
        sliderInfo.Value.Default, 
        sliderInfo.Value.Min, 
        sliderInfo.Value.Max, 
        step or 1, 
        sliderInfo.Value.Default, 
        false, 
        false
    
    -- Fungsi untuk mengkonversi nilai ke posisi slider
    local valueToPosition = function(value)
        return (value - minValue) / (maxValue - minValue) * 1 + 0
    end
    
    -- Inisialisasi tampilan slider
    valueText.Text = tostring(defaultValue) or tostring(minValue)
    sliderFill.Size = UDim2.fromScale(valueToPosition(defaultValue), 1)
    
    -- Fungsi untuk menyeret slider
    local startDrag, setValue = function()
        isDragging = true
        if sliderInfo.Locked then
            return
        end
        repeat
            task.wait()
            local mousePosition = math.clamp((mouse.X - sliderElement.AbsolutePosition.X) / sliderElement.AbsoluteSize.X, 0, 1)
            currentValue = minValue + (mousePosition * (maxValue - minValue))
            local roundedValue = math.round(currentValue / step) * step
            currentValue = math.clamp(roundedValue, minValue, maxValue)
            tween(sliderFill, {
                Size = UDim2.fromScale(valueToPosition(currentValue), 1)
            }, tweenConfig.Global)
            valueText.Text = tostring(currentValue)
            sliderInfo.Value = currentValue
            task.spawn(sliderInfo.Callback, currentValue)
        until isDragging == false or sliderInfo.Locked == true
        
        if not isHovering then
            tween(sliderClone.UIStroke, {
                Color = Color3.fromRGB(60, 60, 74)
            }, tweenConfig.Global)
        end
    end, function(newValue)
        if not newValue or newValue > maxValue or newValue < minValue then
            return
        end
        local roundedValue = math.round(newValue / step) * step
        currentValue = math.clamp(roundedValue, minValue, maxValue)
        tween(sliderFill, {
            Size = UDim2.fromScale(valueToPosition(newValue), 1)
        }, tweenConfig.Global)
        currentValue = newValue
        valueText.Text = tostring(currentValue)
        sliderInfo.Value = currentValue
        task.spawn(sliderInfo.Callback, currentValue)
    end
    
    -- Event mouse enter
    sliderTrigger.MouseEnter:Connect(function()
        isHovering = true
        if not sliderInfo.Locked then
            tween(sliderClone.UIStroke, {
                Color = Color3.fromRGB(10, 135, 213)
            }, tweenConfig.Global)
        end
    end)
    
    -- Event mouse leave
    sliderTrigger.MouseLeave:Connect(function()
        isHovering = false
        if not sliderInfo.Locked and not isDragging then
            tween(sliderClone.UIStroke, {
                Color = Color3.fromRGB(60, 60, 74)
            }, tweenConfig.Global)
        end
    end)
    
    -- Event mouse button down
    sliderTrigger.MouseButton1Down:Connect(function()
        startDrag()
    end)
    
    -- Event input ended
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    -- Fungsi untuk slider
    local sliderFunctions = {}
    
    -- Fungsi untuk mengubah judul slider
    function sliderFunctions.SetTitle(self, newTitle)
        sliderInfo.Title = newTitle
        sliderClone.Title.Text = newTitle
    end
    
    -- Fungsi untuk mengubah deskripsi slider
    function sliderFunctions.SetDesc(self, newDesc)
        if newDesc and newDesc ~= "" then
            sliderInfo.Desc = newDesc
            sliderClone.Description.Text = newDesc
        end
    end
    
    -- Fungsi untuk mengatur nilai slider
    function sliderFunctions.Set(self, newValue)
        setValue(newValue)
    end
    
    -- Fungsi untuk mengunci slider
    function sliderFunctions.Lock(self)
        sliderInfo.Locked = true
        tween(sliderClone, {
            BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        }, tweenConfig.Global)
        tween(sliderClone.UIStroke, {
            Color = Color3.fromRGB(47, 47, 58)
        }, tweenConfig.Global)
        tween(sliderClone.Title, {
            TextColor3 = Color3.fromRGB(75, 77, 83)
        }, tweenConfig.Global)
        tween(sliderClone.Description, {
            TextColor3 = Color3.fromRGB(75, 77, 83)
        }, tweenConfig.Global)
        tween(sliderClone.SliderFrame.Frame.Slider.UIStroke, {
            Color = Color3.fromRGB(47, 47, 58)
        }, tweenConfig.Global)
        tween(sliderClone.SliderFrame.Frame.Slider, {
            BackgroundTransparency = 0.5
        }, tweenConfig.Global)
        tween(sliderClone.SliderFrame.Frame.Slider.Fill.UIStroke, {
            Transparency = 0.5
        }, tweenConfig.Global)
        tween(sliderClone.SliderFrame.Frame.Slider.Fill.BackgroundGradient, {
            BackgroundTransparency = 0.5
        }, tweenConfig.Global)
        tween(sliderClone.SliderFrame.Frame.ValueText, {
            TextTransparency = 0.6
        }, tweenConfig.Global)
    end
    
    -- Fungsi untuk membuka kunci slider
    function sliderFunctions.Unlock(self)
        sliderInfo.Locked = false
        tween(sliderClone, {
            BackgroundColor3 = Color3.fromRGB(42, 45, 52)
        }, tweenConfig.Global)
        tween(sliderClone.UIStroke, {
            Color = Color3.fromRGB(60, 60, 74)
        }, tweenConfig.Global)
      -- ==============================
-- KELANJUTAN NAT HUB UI LIBRARY - REWRITE
-- ==============================

-- Kelanjutan dari fungsi sliderFunctions.Unlock
tween(sliderClone.Title, {
    TextColor3 = Color3.fromRGB(196, 203, 218)
}, tweenConfig.Global)
tween(sliderClone.Description, {
    TextColor3 = Color3.fromRGB(196, 203, 218)
}, tweenConfig.Global)
tween(sliderClone.SliderFrame.Frame.Slider.UIStroke, {
    Color = Color3.fromRGB(60, 60, 74)
}, tweenConfig.Global)
tween(sliderClone.SliderFrame.Frame.Slider, {
    BackgroundTransparency = 0
}, tweenConfig.Global)
tween(sliderClone.SliderFrame.Frame.Slider.Fill.UIStroke, {
    Transparency = 0
}, tweenConfig.Global)
tween(sliderClone.SliderFrame.Frame.Slider.Fill.BackgroundGradient, {
    BackgroundTransparency = 0
}, tweenConfig.Global)
tween(sliderClone.SliderFrame.Frame.ValueText, {
    TextTransparency = 0
}, tweenConfig.Global)

-- Fungsi untuk menghapus slider
function sliderFunctions.Destroy(self)
    sliderClone:Destroy()
end

-- Panggil callback dengan nilai awal
sliderInfo.Callback(defaultValue)

return sliderFunctions

-- Fungsi untuk membuat Input/TextBox
function tabFunctions.Input(inputName, inputConfig)
    local inputInfo, inputInstance = {
        Title = inputConfig.Title,
        Desc = inputConfig.Desc,
        Placeholder = inputConfig.Placeholder or "",
        Default = inputConfig.Default or inputConfig.Value or "",
        Text = inputConfig.Default or inputConfig.Value or "",
        ClearTextOnFocus = inputConfig.ClearTextOnFocus or false,
        Locked = inputConfig.Locked or false,
        MultiLine = inputConfig.MultiLine or false,
        Callback = inputConfig.Callback or function() end
    }, templates.TextBox:Clone()
    
    inputInstance.Name = inputInfo.Title
    inputInstance.Parent = tabContainer
    inputInstance.Title.Text = inputInfo.Title
    
    if inputInfo.Desc and inputInfo.Desc ~= "" then
        inputInstance.Description.Text = inputInfo.Desc
        inputInstance.Description.Visible = true
    else
        inputInstance.Description.Visible = false
    end
    
    -- Set state terkunci
    if inputInfo.Locked then
        inputInstance.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        inputInstance.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        inputInstance.Title.TextColor3 = Color3.fromRGB(75, 77, 83)
        inputInstance.Description.TextColor3 = Color3.fromRGB(75, 77, 83)
        inputInstance.BoxFrame.Frame.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        inputInstance.BoxFrame.Frame.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        inputInstance.BoxFrame.Frame.TextBox.TextColor3 = Color3.fromRGB(75, 77, 83)
        inputInstance.BoxFrame.Frame.TextBox.PlaceholderColor3 = Color3.fromRGB(75, 77, 83)
        inputInstance.BoxFrame.Frame.TextBox.Active = false
        inputInstance.BoxFrame.Frame.TextBox.Interactable = false
        inputInstance.BoxFrame.Frame.TextBox.TextEditable = false
    end
    
    -- Set nilai awal dan properti textbox
    inputInstance.BoxFrame.Frame.TextBox.Text = inputInfo.Default
    inputInstance.BoxFrame.Frame.TextBox.PlaceholderText = inputInfo.Placeholder
    inputInstance.BoxFrame.Frame.TextBox.MultiLine = inputInfo.MultiLine
    
    if inputInfo.MultiLine then
        inputInstance.BoxFrame.Frame.TextBox.AutomaticSize = Enum.AutomaticSize.Y
    else
        inputInstance.BoxFrame.Frame.TextBox.AutomaticSize = Enum.AutomaticSize.None
    end
    
    inputInstance.BoxFrame.Frame.TextBox.ClearTextOnFocus = inputInfo.ClearTextOnFocus
    inputInstance.Visible = true
    
    -- Event mouse enter
    inputInstance.BoxFrame.Frame.TextBox.MouseEnter:Connect(function()
        if not inputInfo.Locked then
            tween(inputInstance.UIStroke, {
                Color = Color3.fromRGB(10, 135, 213)
            }, tweenConfig.Global)
        end
    end)
    
    -- Event mouse leave
    inputInstance.BoxFrame.Frame.TextBox.MouseLeave:Connect(function()
        if not inputInfo.Locked then
            tween(inputInstance.UIStroke, {
                Color = Color3.fromRGB(60, 60, 74)
            }, tweenConfig.Global)
        end
    end)
    
    -- Event focused
    inputInstance.BoxFrame.Frame.TextBox.Focused:Connect(function()
        if not inputInfo.Locked then
            tween(inputInstance.UIStroke, {
                Color = Color3.fromRGB(60, 60, 74)
            }, tweenConfig.Global)
            tween(inputInstance.BoxFrame.Frame.UIStroke, {
                Color = Color3.fromRGB(10, 135, 213)
            }, tweenConfig.Global)
        end
    end)
    
    -- Event focus lost
    inputInstance.BoxFrame.Frame.TextBox.FocusLost:Connect(function()
        if not inputInfo.Locked then
            tween(inputInstance.BoxFrame.Frame.UIStroke, {
                Color = Color3.fromRGB(60, 60, 74)
            }, tweenConfig.Global)
            inputInfo.Text = inputInstance.BoxFrame.Frame.TextBox.Text
            inputInfo.Callback(inputInfo.Text)
        end
    end)
    
    -- Fungsi untuk mengatur nilai input
    function inputInfo.Set(self, newValue)
        inputInstance.BoxFrame.Frame.TextBox.Text = newValue
        inputInfo.Text = newValue
        inputInfo.Callback(newValue)
    end
    
    -- Fungsi untuk mengubah judul input
    function inputInfo.SetTitle(self, newTitle)
        inputInstance.Title.Text = newTitle
    end
    
    -- Fungsi untuk mengubah deskripsi input
    function inputInfo.SetDesc(self, newDesc)
        if newDesc and newDesc ~= "" then
            inputInstance.Description.Text = newDesc
        end
    end
    
    -- Fungsi untuk mengubah placeholder
    function inputInfo.SetPlaceholder(self, newPlaceholder)
        if newPlaceholder then
            inputInstance.Description.Placeholder = newPlaceholder
        end
    end
    
    -- Fungsi untuk mengunci input
    function inputInfo.Lock(self)
        inputInfo.Locked = true
        tween(inputInstance.UIStroke, {
            Color = Color3.fromRGB(47, 47, 58)
        }, tweenConfig.Global)
        tween(inputInstance, {
            BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        }, tweenConfig.Global)
        tween(inputInstance.Title, {
            TextColor3 = Color3.fromRGB(75, 77, 83)
        }, tweenConfig.Global)
        tween(inputInstance.Description, {
            TextColor3 = Color3.fromRGB(75, 77, 83)
        }, tweenConfig.Global)
        tween(inputInstance.BoxFrame.Frame, {
            BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        }, tweenConfig.Global)
        tween(inputInstance.BoxFrame.Frame.UIStroke, {
            Color = Color3.fromRGB(47, 47, 58)
        }, tweenConfig.Global)
        tween(inputInstance.BoxFrame.Frame.TextBox, {
            TextColor3 = Color3.fromRGB(75, 77, 83),
            PlaceholderColor3 = Color3.fromRGB(75, 77, 83)
        }, tweenConfig.Global)
        inputInstance.BoxFrame.Frame.TextBox.Active = false
        inputInstance.BoxFrame.Frame.TextBox.Interactable = false
        inputInstance.BoxFrame.Frame.TextBox.TextEditable = false
    end
    
    -- Fungsi untuk membuka kunci input
    function inputInfo.Unlock(self)
        inputInfo.Locked = false
        tween(inputInstance.UIStroke, {
            Color = Color3.fromRGB(60, 60, 74)
        }, tweenConfig.Global)
        tween(inputInstance, {
            BackgroundColor3 = Color3.fromRGB(42, 45, 52)
        }, tweenConfig.Global)
        tween(inputInstance.Title, {
            TextColor3 = Color3.fromRGB(196, 203, 218)
        }, tweenConfig.Global)
        tween(inputInstance.Description, {
            TextColor3 = Color3.fromRGB(196, 203, 218)
        }, tweenConfig.Global)
        tween(inputInstance.BoxFrame.Frame, {
            BackgroundColor3 = Color3.fromRGB(42, 45, 52)
        }, tweenConfig.Global)
        tween(inputInstance.BoxFrame.Frame.UIStroke, {
            Color = Color3.fromRGB(60, 60, 74)
        }, tweenConfig.Global)
        tween(inputInstance.BoxFrame.Frame.TextBox, {
            TextColor3 = Color3.fromRGB(196, 203, 218),
            PlaceholderColor3 = Color3.fromRGB(139, 139, 139)
        }, tweenConfig.Global)
        inputInstance.BoxFrame.Frame.TextBox.Active = true
        inputInstance.BoxFrame.Frame.TextBox.Interactable = true
        inputInstance.BoxFrame.Frame.TextBox.TextEditable = true
    end
    
    -- Fungsi untuk menghapus input
    function inputInfo.Destroy(self)
        inputInstance:Destroy()
    end
    
    -- Panggil callback dengan nilai awal
    inputInfo.Callback(inputInfo.Text)
    
    return inputInfo
end

-- Fungsi utilitas untuk dropdown
local createDropdownButton, joinTable = function(buttonName, parent)
    local dropdownButton = templates.DropdownButton:Clone()
    dropdownButton.Parent = parent or nil
    dropdownButton.Name = buttonName
    dropdownButton.Frame.Title.Text = buttonName
    
    -- Fungsi untuk mengaktifkan gradien acak
    local activateRandomGradient = function()
        local gradients = {}
        for _, child in ipairs(dropdownButton.Frame:GetChildren()) do
            if child:IsA("UIGradient") then
                child.Enabled = false
                table.insert(gradients, child)
            end
        end
        local selectedGradient = gradients[math.random(1, #gradients)]
        selectedGradient.Enabled = true
        return selectedGradient
    end
    
    activateRandomGradient()
    return dropdownButton
end, function(tableArray)
    return table.concat(tableArray, ", ")
end

-- Fungsi untuk membuat Dropdown
function tabFunctions.Dropdown(dropdownName, dropdownConfig)
    local dropdownInfo, dropdownInstance, dropdownFolder, selectedValues = {
        Title = dropdownConfig.Title,
        Desc = dropdownConfig.Desc,
        Multi = dropdownConfig.Multi or false,
        Values = dropdownConfig.Values or {},
        Value = dropdownConfig.Value or dropdownConfig.Default,
        AllowNone = dropdownConfig.AllowNone or false,
        Locked = dropdownConfig.Locked or false,
        Callback = dropdownConfig.Callback or function() end
    }, templates.Dropdown:Clone(), (templates.DropdownList:Clone())
    
    dropdownFolder.Name = dropdownInfo.Title
    dropdownFolder.Parent = window.DropdownSelection.Dropdowns
    dropdownInstance.Parent = tabContainer
    dropdownInstance.Name = dropdownInfo.Title
    dropdownInstance.Title.Text = dropdownInfo.Title
    
    if dropdownInfo.Desc and dropdownInfo.Desc ~= "" then
        dropdownInstance.Description.Visible = true
        dropdownInstance.Description.Text = dropdownInfo.Desc
    else
        dropdownInstance.Description.Visible = false
    end
    
    -- Set state terkunci
    if dropdownInfo.Locked then
        dropdownInstance.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        dropdownInstance.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        dropdownInstance.Title.TextColor3 = Color3.fromRGB(75, 77, 83)
        dropdownInstance.Description.TextColor3 = Color3.fromRGB(75, 77, 83)
        dropdownInstance.Title.ClickIcon.ImageColor3 = Color3.fromRGB(75, 77, 83)
        dropdownInstance.Title.BoxFrame.Trigger.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        dropdownInstance.Title.BoxFrame.Trigger.UIStroke.Color = Color3.fromRGB(47, 47, 58)
        dropdownInstance.Title.BoxFrame.Trigger.Title.TextColor3 = Color3.fromRGB(75, 77, 83)
        dropdownInstance.Active = false
        dropdownInstance.Interactable = false
    end
    
    dropdownInstance.Visible = true
    
    -- Fungsi untuk memilih nilai dropdown
    local selectValue = function(isRemoving, value)
        if not isRemoving then
            -- Mode single selection
            local selectedItem, searchItem = dropdownFolder.DropdownItems:FindFirstChild(value), dropdownFolder.DropdownItemsSearch:FindFirstChild(value)
            selectedValues = value
            dropdownInfo.Value = selectedValues
            dropdownInstance.Title.BoxFrame.Trigger.Title.Text = selectedValues
            
            -- Reset semua item yang tidak dipilih
            for _, item in dropdownFolder.DropdownItems:GetChildren() do
                if item:IsA("GuiButton") and item.Name ~= value then
                    tween(item.Frame.Title, {
                        TextColor3 = Color3.fromRGB(196, 203, 218)
                    }, tweenConfig.Global)
                    tween(item.Frame.Description, {
                        TextColor3 = Color3.fromRGB(196, 203, 218)
                    }, tweenConfig.Global)
                    tween(item.Frame, {
                        BackgroundTransparency = 1
                    }, tweenConfig.Global)
                    tween(item.UIStroke, {
                        Color = Color3.fromRGB(60, 60, 74)
                    }, tweenConfig.Global)
                end
            end
            
            for _, item in dropdownFolder.DropdownItemsSearch:GetChildren() do
                if item:IsA("GuiButton") and item.Name ~= value then
                    tween(item.Frame.Title, {
                        TextColor3 = Color3.fromRGB(196, 203, 218)
                    }, tweenConfig.Global)
                    tween(item.Frame.Description, {
                        TextColor3 = Color3.fromRGB(196, 203, 218)
                    }, tweenConfig.Global)
                    tween(item.Frame, {
                        BackgroundTransparency = 1
                    }, tweenConfig.Global)
                    tween(item.UIStroke, {
                        Color = Color3.fromRGB(60, 60, 74)
                    }, tweenConfig.Global)
                end
            end
            
            -- Highlight item yang dipilih
            if selectedItem then
                tween(selectedItem.Frame.Title, {
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }, tweenConfig.Global)
                tween(selectedItem.Frame.Description, {
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }, tweenConfig.Global)
                tween(selectedItem.UIStroke, {
                    Color = Color3.fromRGB(10, 135, 213)
                }, tweenConfig.Global)
                tween(selectedItem.Frame, {
                    BackgroundTransparency = 0
                }, tweenConfig.Global)
            end
            
            if searchItem then
                tween(searchItem.Frame.Title, {
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }, tweenConfig.Global)
                tween(searchItem.Frame.Description, {
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }, tweenConfig.Global)
                tween(searchItem.UIStroke, {
                    Color = Color3.fromRGB(10, 135, 213)
                }, tweenConfig.Global)
                tween(searchItem.Frame, {
                    BackgroundTransparency = 0
                }, tweenConfig.Global)
            end
            
            return selectedValues
        elseif isRemoving then
            -- Mode multi selection
            for _, valueName in value do
                local selectedItem, searchItem, index = dropdownFolder.DropdownItems:FindFirstChild(valueName), dropdownFolder.DropdownItemsSearch:FindFirstChild(valueName), table.find(selectedValues, valueName)
                
                if index then
                    -- Hapus dari selection
                    if not dropdownInfo.AllowNone and #dropdownInfo.Value == 1 then
                        return
                    end
                    table.remove(selectedValues, index)
                    
                    -- Reset tampilan item yang dihapus
                    if selectedItem then
                        tween(selectedItem.Frame.Title, {
                            TextColor3 = Color3.fromRGB(196, 203, 218)
                        }, tweenConfig.Global)
                        tween(selectedItem.Frame.Description, {
                            TextColor3 = Color3.fromRGB(196, 203, 218)
                        }, tweenConfig.Global)
                        tween(selectedItem.UIStroke, {
                            Color = Color3.fromRGB(60, 60, 74)
                        }, tweenConfig.Global)
                        tween(selectedItem.Frame, {
                            BackgroundTransparency = 1
                        }, tweenConfig.Global)
                    end
                    
                    if searchItem then
                        tween(searchItem.Frame.Title, {
                            TextColor3 = Color3.fromRGB(196, 203, 218)
                        }, tweenConfig.Global)
                        tween(searchItem.Frame.Description, {
                            TextColor3 = Color3.fromRGB(196, 203, 218)
                        }, tweenConfig.Global)
                        tween(searchItem.UIStroke, {
                            Color = Color3.fromRGB(60, 60, 74)
                        }, tweenConfig.Global)
                        tween(searchItem.Frame, {
                            BackgroundTransparency = 1
                        }, tweenConfig.Global)
                    end
                else
                    -- Tambahkan ke selection
                    table.insert(selectedValues, valueName)
                    
                    -- Highlight item yang ditambahkan
                    if selectedItem then
                        tween(selectedItem.Frame.Title, {
                            TextColor3 = Color3.fromRGB(255, 255, 255)
                        }, tweenConfig.Global)
                        tween(selectedItem.Frame.Description, {
                            TextColor3 = Color3.fromRGB(255, 255, 255)
                        }, tweenConfig.Global)
                        tween(selectedItem.UIStroke, {
                            Color = Color3.fromRGB(10, 135, 213)
                        }, tweenConfig.Global)
                        tween(selectedItem.Frame, {
                            BackgroundTransparency = 0
                        }, tweenConfig.Global)
                    end
                    
                    if searchItem then
                        tween(searchItem.Frame.Title, {
                            TextColor3 = Color3.fromRGB(255, 255, 255)
                        }, tweenConfig.Global)
                        tween(searchItem.Frame.Description, {
                            TextColor3 = Color3.fromRGB(255, 255, 255)
                        }, tweenConfig.Global)
                        tween(searchItem.UIStroke, {
                            Color = Color3.fromRGB(10, 135, 213)
                        }, tweenConfig.Global)
                        tween(searchItem.Frame, {
                            BackgroundTransparency = 0
                        }, tweenConfig.Global)
                    end
                end
            end
            
            dropdownInfo.Value = selectedValues
            dropdownInstance.Title.BoxFrame.Trigger.Title.Text = joinTable(selectedValues)
            return selectedValues
        end
    end
    
    -- Fungsi untuk refresh opsi dropdown
    local refreshOptions = function(values, isInitial)
        local uniqueValues, processedValues = {}, {}
        
        -- Proses nilai untuk menghindari duplikat
        for _, value in values do
            if typeof(value) == "string" then
                if not uniqueValues[value] then
                    uniqueValues[value] = 1
                    table.insert(processedValues, value)
                else
                    uniqueValues[value] = uniqueValues[value] + 1
                    table.insert(processedValues, value .. " (" .. uniqueValues[value] .. ")")
                end
            end
        end
        
        if isInitial then
            dropdownInfo.Values = processedValues
            
            -- Hapus semua item yang ada
            for _, item in dropdownFolder.DropdownItems:GetChildren() do
                if item:IsA("GuiButton") then
                    item:Destroy()
                end
            end
            
            for _, item in dropdownFolder.DropdownItemsSearch:GetChildren() do
                if item:IsA("GuiButton") then
                    item:Destroy()
                end
            end
        end
        
        if not dropdownInfo.Multi then
            if isInitial then
                selectedValues = nil
                dropdownInstance.Title.BoxFrame.Trigger.Title.Text = ""
            end
            
            -- Buat item untuk single selection
            for _, value in processedValues do
                local mainItem, searchItem = createDropdownButton(value, dropdownFolder.DropdownItems), createDropdownButton(value, dropdownFolder.DropdownItemsSearch)
                mainItem.Visible = true
                searchItem.Visible = true
                
                if selectedValues == value then
                    mainItem.Frame.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    mainItem.Frame.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
                    mainItem.UIStroke.Color = Color3.fromRGB(10, 135, 213)
                    mainItem.Frame.BackgroundTransparency = 0
                    
                    searchItem.Frame.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    searchItem.Frame.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
                    searchItem.UIStroke.Color = Color3.fromRGB(10, 135, 213)
                    searchItem.Frame.BackgroundTransparency = 0
                end
                
                mainItem.MouseButton1Click:Connect(function()
                    if not dropdownInfo.Locked then
                        local result = selectValue(false, value)
                        if result then
                            dropdownInfo.Callback(result)
                        end
                    end
                end)
                
                searchItem.MouseButton1Click:Connect(function()
                    if not dropdownInfo.Locked then
                        local result = selectValue(false, value)
                        if result then
                            dropdownInfo.Callback(result)
                        end
                    end
                end)
            end
        elseif dropdownInfo.Multi then
            if isInitial then
                dropdownInstance.Title.ClickIcon.Image = "rbxassetid://91415671397056"
                
                if type(dropdownInfo.Value) == "string" then
                    dropdownInfo.Value = {dropdownInfo.Value}
                end
                
                selectedValues = dropdownInfo.Value or {}
                dropdownInstance.Title.BoxFrame.Trigger.Title.Text = joinTable(selectedValues)
            end
            
            -- Buat item untuk multi selection
            for _, value in processedValues do
                local mainItem, searchItem = createDropdownButton(value, dropdownFolder.DropdownItems), createDropdownButton(value, dropdownFolder.DropdownItemsSearch)
                mainItem.Visible = true
                searchItem.Visible = true
                
                if table.find(selectedValues, value) then
                    mainItem.Frame.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    mainItem.Frame.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
                    mainItem.UIStroke.Color = Color3.fromRGB(10, 135, 213)
                    mainItem.Frame.BackgroundTransparency = 0
                    
                    searchItem.Frame.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    searchItem.Frame.Description.TextColor3 = Color3.fromRGB(255, 255, 255)
                    searchItem.UIStroke.Color = Color3.fromRGB(10, 135, 213)
                    searchItem.Frame.BackgroundTransparency = 0
                end
                
                mainItem.MouseButton1Click:Connect(function()
                    if not dropdownInfo.Locked then
                        local result = selectValue(true, {value})
                        if result then
                            dropdownInfo.Callback(result)
                        end
                    end
                end)
                
                searchItem.MouseButton1Click:Connect(function()
                    if not dropdownInfo.Locked then
                        local result = selectValue(true, {value})
                        if result then
                            dropdownInfo.Callback(result)
                        end
                    end
                end)
            end
        end
    end
    
    -- Inisialisasi dropdown
    if not dropdownInfo.Multi then
        selectedValues = dropdownInfo.Value or nil
        dropdownInstance.Title.BoxFrame.Trigger.Title.Text = selectedValues
        refreshOptions(dropdownInfo.Values, true)
    elseif dropdownInfo.Multi then
        dropdownInstance.Title.ClickIcon.Image = "rbxassetid://91415671397056"
        
        if type(dropdownInfo.Value) == "string" then
            dropdownInfo.Value = {dropdownInfo.Value}
        end
        
        selectedValues = dropdownInfo.Value or {}
        dropdownInstance.Title.BoxFrame.Trigger.Title.Text = joinTable(selectedValues)
        refreshOptions(dropdownInfo.Values, true)
    end
    
    -- Event untuk membuka dropdown
    dropdownInstance.Title.BoxFrame.Trigger.MouseButton1Click:Connect(function()
        toggleDropdown(nil, dropdownInfo.Title)
    end)
    
    -- Fungsi untuk mengubah judul dropdown
    function dropdownInfo.SetTitle(self, newTitle)
        dropdownInfo.Title = newTitle
        dropdownInstance.Title.Text = newTitle
    end
    -- ==============================
-- KELANJUTAN NAT HUB UI LIBRARY - REWRITE
-- ==============================

-- Kelanjutan dari fungsi dropdownInfo.SetTitle
function dropdownInfo.SetDesc(self, newDesc)
    if newDesc and newDesc ~= "" then
        dropdownInfo.Desc = newDesc
        dropdownInstance.Description.Text = newDesc
    end
end

-- Fungsi untuk refresh opsi dropdown
function dropdownInfo.Refresh(self, newValues)
    refreshOptions(newValues, true)
end

-- Fungsi untuk memilih nilai dropdown
function dropdownInfo.Select(self, values)
    dropdownInfo.Callback(selectValue(dropdownInfo.Multi, values))
end

-- Fungsi untuk mengunci dropdown
function dropdownInfo.Lock(self)
    dropdownInfo.Locked = true
    tween(dropdownInstance.UIStroke, {
        Color = Color3.fromRGB(47, 47, 58)
    }, tweenConfig.Global)
    tween(dropdownInstance, {
        BackgroundColor3 = Color3.fromRGB(32, 35, 40)
    }, tweenConfig.Global)
    tween(dropdownInstance.Title, {
        TextColor3 = Color3.fromRGB(75, 77, 83)
    }, tweenConfig.Global)
    tween(dropdownInstance.Description, {
        TextColor3 = Color3.fromRGB(75, 77, 83)
    }, tweenConfig.Global)
    tween(dropdownInstance.Title.ClickIcon, {
        ImageColor3 = Color3.fromRGB(75, 77, 83)
    }, tweenConfig.Global)
    tween(dropdownInstance.Title.BoxFrame.Trigger, {
        BackgroundColor3 = Color3.fromRGB(32, 35, 40)
    }, tweenConfig.Global)
    tween(dropdownInstance.Title.BoxFrame.Trigger.UIStroke, {
        Color = Color3.fromRGB(47, 47, 58)
    }, tweenConfig.Global)
    tween(dropdownInstance.Title.BoxFrame.Trigger.Title, {
        TextColor3 = Color3.fromRGB(75, 77, 83)
    }, tweenConfig.Global)
    dropdownInstance.Active = false
    dropdownInstance.Interactable = false
end

-- Fungsi untuk membuka kunci dropdown
function dropdownInfo.Unlock(self)
    dropdownInfo.Locked = false
    tween(dropdownInstance.UIStroke, {
        Color = Color3.fromRGB(60, 60, 74)
    }, tweenConfig.Global)
    tween(dropdownInstance, {
        BackgroundColor3 = Color3.fromRGB(42, 45, 52)
    }, tweenConfig.Global)
    tween(dropdownInstance.Title, {
        TextColor3 = Color3.fromRGB(196, 203, 218)
    }, tweenConfig.Global)
    tween(dropdownInstance.Description, {
        TextColor3 = Color3.fromRGB(196, 203, 218)
    }, tweenConfig.Global)
    tween(dropdownInstance.Title.ClickIcon, {
        ImageColor3 = Color3.fromRGB(196, 203, 218)
    }, tweenConfig.Global)
    tween(dropdownInstance.Title.BoxFrame.Trigger, {
        BackgroundColor3 = Color3.fromRGB(42, 45, 52)
    }, tweenConfig.Global)
    tween(dropdownInstance.Title.BoxFrame.Trigger.UIStroke, {
        Color = Color3.fromRGB(60, 60, 74)
    }, tweenConfig.Global)
    tween(dropdownInstance.Title.BoxFrame.Trigger.Title, {
        TextColor3 = Color3.fromRGB(196, 203, 218)
    }, tweenConfig.Global)
    dropdownInstance.Active = true
    dropdownInstance.Interactable = true
end

-- Fungsi untuk menghapus dropdown
function dropdownInfo.Destroy(self)
    dropdownInstance:Destroy()
end

-- Panggil callback dengan nilai awal
dropdownInfo.Callback(dropdownInfo.Value)

return dropdownInfo

-- Akhir dari fungsi tabFunctions
end

-- Fungsi untuk memilih tab
function windowConfig.SelectTab(self, tabName)
    local tab = tabsData[tabName]
    if tab then
        selectTab(tab.Name)
    end
end

-- Fungsi untuk membuat divider
function windowConfig.Divider(self)
    local divider = templates.Divider:Clone()
    divider.Parent = window.TabButtons.Lists
    divider.Visible = true
end

-- Fungsi untuk mengatur tombol toggle
function windowConfig.SetToggleKey(self, keyCode)
    if type(keyCode) == "string" then
        windowConfig.ToggleKey = Enum.KeyCode[keyCode]
    else
        windowConfig.ToggleKey = keyCode
    end
end

-- Fungsi untuk mengedit tombol open (placeholder)
function windowConfig.EditOpenButton(self)
    -- Fungsi ini sengaja dikosongkan dalam kode asli
end

-- Fungsi untuk membuat dialog
function windowConfig.Dialog(self, dialogConfig)
    local dialogInfo, dialogInstance, darkOverlay = {
        Title = dialogConfig.Title,
        Content = dialogConfig.Content,
        Icon = dialogConfig.Icon,
        Buttons = dialogConfig.Buttons or {},
        Size = nil,
        PressDecreaseSize = UDim2.fromOffset(5, 5)
    }, templates.DialogElements.Dialog:Clone(), templates.DialogElements.DarkOverlayDialog:Clone()
    
    dialogInstance.Title.TextLabel.Text = dialogInfo.Title
    
    if dialogInfo.Content and dialogInfo.Content ~= "" then
        dialogInstance.Content.Visible = true
        dialogInstance.Content.TextLabel.Text = dialogInfo.Content
    end
    
    -- Set ikon dialog
    if dialogInfo.Icon then
        if string.find(dialogInfo.Icon, "rbxassetid") or string.match(dialogInfo.Icon, "%d") then
            dialogInstance.Title.Icon.Image = dialogInfo.Icon
        else
            local iconData = iconModule.Icon(dialogInfo.Icon)
            dialogInstance.Title.Icon.Image = (iconData and iconData[1]) or dialogInfo.Icon or ""
            dialogInstance.Title.Icon.ImageRectOffset = (iconData and iconData[2].ImageRectPosition) or Vector2.new(0, 0)
            dialogInstance.Title.Icon.ImageRectSize = (iconData and iconData[2].ImageRectSize) or Vector2.new(0, 0)
        end
        dialogInstance.Title.Icon.Visible = true
    end
    
    dialogInstance.Parent = window
    darkOverlay.Parent = window
    
    dialogInfo.Size = UDim2.fromOffset(dialogInstance.AbsoluteSize.X, dialogInstance.AbsoluteSize.Y)
    darkOverlay.Transparency = 1
    
    -- Buat tombol-tombol dialog
    for _, buttonConfig in dialogInfo.Buttons do
        local buttonInfo, buttonInstance = {
            Title = buttonConfig.Title or "Button",
            Callback = buttonConfig.Callback or function() end
        }, templates.DialogElements.DialogButton:Clone()
        
        local originalSize = buttonInstance.Button.Size
        buttonInstance.Button.Label.Text = buttonInfo.Title
        
        buttonInstance.Button.MouseButton1Click:Connect(function()
            buttonInfo.Callback()
            local fadeOut = tween(darkOverlay, {
                Transparency = 1
            }, tweenConfig.Global)
            dialogInstance:Destroy()
            fadeOut.Completed:Wait()
            darkOverlay:Destroy()
        end)
        
        buttonInstance.Button.MouseButton1Down:Connect(function()
            tween(buttonInstance.Button, {
                Size = originalSize - dialogInfo.PressDecreaseSize
            }, tweenConfig.Global)
        end)
        
        buttonInstance.Button.MouseButton1Up:Connect(function()
            tween(buttonInstance.Button, {
                Size = originalSize
            }, tweenConfig.Global)
        end)
        
        buttonInstance.Button.MouseLeave:Connect(function()
            tween(buttonInstance.Button, {
                Size = originalSize
            }, tweenConfig.Global)
        end)
        
        buttonInstance.Parent = dialogInstance.Buttons
        buttonInstance.Visible = true
    end
    
    tween(darkOverlay, {
        Transparency = 0.6
    }, tweenConfig.Global)
    dialogInstance.Visible = true
    darkOverlay.Visible = true
    
    return dialogInfo
end

-- Variabel untuk animasi window
local floatIconSize, windowSize, originalWindowSize, windowPosition, isMaximized, windowDragFunctions = 
    floatIcon.Size, 
    windowConfig.Size, 
    windowConfig.Size, 
    window.Position, 
    false, 
    makeDraggable(window.TopFrame, window)

-- Buat window dapat diseret
makeDraggable(floatIcon, floatIcon)

window.Visible = true
window.Size = UDim2.fromOffset(0, 0)

local windowVisible, isAnimating = window.Visible, false

-- Fungsi untuk toggle window
local toggleWindow = function(show)
    if show == true then
        floatIconSize = floatIcon.Size
        window.Size = UDim2.fromOffset(0, 0)
        window.Visible = true
        tween(floatIcon, {
            Size = UDim2.new(0, 0, 0, 0)
        }, tweenConfig.Global)
        tween(window, {
            Size = windowSize
        }, tweenConfig.Global).Completed:Wait()
        window.Tabs.Visible = true
        window.TabButtons.Visible = true
        floatIcon.Visible = false
    elseif show == false then
        windowSize = window.Size
        floatIcon.Size = UDim2.fromOffset(0, 0)
        floatIcon.Visible = true
        window.Tabs.Visible = false
        window.TabButtons.Visible = false
        tween(floatIcon, {
            Size = floatIconSize
        }, tweenConfig.Global)
        tween(window, {
            Size = UDim2.fromOffset(0, 0)
        }, tweenConfig.Global).Completed:Wait()
        window.Visible = false
    else
        -- Toggle
        if windowVisible then
            windowSize = window.Size
            floatIcon.Size = UDim2.fromOffset(0, 0)
            floatIcon.Visible = true
            window.Tabs.Visible = false
            window.TabButtons.Visible = false
            window.DropShadow.Visible = false
            tween(floatIcon, {
                Size = floatIconSize
            }, tweenConfig.Global)
            tween(window, {
                Size = UDim2.fromOffset(0, 0)
            }, tweenConfig.Global).Completed:Wait()
            window.Visible = false
            windowVisible = false
        else
            floatIconSize = floatIcon.Size
            window.Size = UDim2.fromOffset(0, 0)
            window.Visible = true
            window.DropShadow.Visible = true
            tween(floatIcon, {
                Size = UDim2.new(0, 0, 0, 0)
            }, tweenConfig.Global)
            tween(window, {
                Size = windowSize
            }, tweenConfig.Global).Completed:Wait()
            window.Tabs.Visible = true
            window.TabButtons.Visible = true
            floatIcon.Visible = false
            windowVisible = true
        end
    end
end

-- Event untuk tombol hide
window.TopFrame.Hide.MouseButton1Click:Connect(function()
    if not isAnimating then
        isAnimating = true
        toggleWindow(false)
        task.delay(tweenConfig.Global.Duration, function()
            isAnimating = false
        end)
    end
end)

-- Event untuk tombol open di float icon
floatIcon.Open.MouseButton1Click:Connect(function()
    if not isAnimating then
        isAnimating = true
        toggleWindow(true)
        task.delay(tweenConfig.Global.Duration, function()
            isAnimating = false
        end)
    end
end)

-- Event untuk tombol close
window.TopFrame.Close.MouseButton1Click:Connect(function()
    windowConfig:Dialog{
        Icon = "triangle-alert",
        Title = "Close Window",
        Content = [[Do you want to close this window? You will not able to open it again.]],
        Buttons = {
            {
                Title = "Cancel"
            },
            {
                Title = "Close Window",
                Callback = function()
                    windowFolder.Parent = nil
                end
            }
        }
    }
end)

-- Event untuk tombol maximize
window.TopFrame.Maximize.MouseButton1Click:Connect(function()
    if not isMaximized then
        windowDragFunctions.SetAllowDragging(false)
        originalWindowSize = window.Size
        windowPosition = window.Position
        tween(window, {
            Size = UDim2.new(1, 0, 1, 0)
        }, tweenConfig.Global)
        tween(window, {
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, tweenConfig.Global)
        tween(window.UICorner, {
            CornerRadius = UDim.new(0, 0)
        }, tweenConfig.Global)
        isMaximized = true
    else
        windowDragFunctions.SetAllowDragging(true)
        tween(window, {
            Size = originalWindowSize
        }, tweenConfig.Global)
        tween(window, {
            Position = windowPosition
        }, tweenConfig.Global)
        tween(window.UICorner, {
            CornerRadius = UDim.new(0, 10)
        }, tweenConfig.Global)
        isMaximized = false
    end
end)

-- Animasi pembukaan window
tween(window, {
    Size = windowSize
}, tweenConfig.Global)

-- Event untuk tombol toggle key
userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not isAnimating and not gameProcessedEvent and input.KeyCode == windowConfig.ToggleKey then
        isAnimating = true
        toggleWindow()
        task.delay(tweenConfig.Global.Duration, function()
            isAnimating = false
        end)
    end
end)

return windowConfig

-- Fungsi untuk membuat notifikasi
function library.Notify(notificationName, notificationConfig)
    local notificationFunctions, notificationInfo, notificationInstance = {}, {
        Title = notificationConfig.Title,
        Content = notificationConfig.Content,
        Icon = notificationConfig.Icon,
        Duration = notificationConfig.Duration or 5
    }, templates.Notification:Clone()
    
    -- Tentukan parent notifikasi
    if #windows == 1 and windows[1].Visible and windows[1].Tabs.Visible then
        notificationInstance.Parent = windows[1].NotificationFrame.NotificationList
    else
        notificationInstance.Parent = screenGui.NotificationList
    end
    
    notificationInstance.Items.Frame.Title.Text = notificationInfo.Title
    notificationInstance.Items.Frame.Content.Text = notificationInfo.Content
    
    -- Set ikon notifikasi
    local iconData = iconModule.Icon(notificationInfo.Icon)
    notificationInstance.Items.Frame.Title.Icon.Image = (iconData and iconData[1]) or notificationInfo.Icon or ""
    notificationInstance.Items.Frame.Title.Icon.ImageRectOffset = (iconData and iconData[2].ImageRectPosition) or Vector2.new(0, 0)
    notificationInstance.Items.Frame.Title.Icon.ImageRectSize = (iconData and iconData[2].ImageRectSize) or Vector2.new(0, 0)
    
    notificationInstance.Items.Position = UDim2.new(0.75, 0, 0, 0)
    notificationInstance.Visible = true
    
    -- Fungsi untuk menutup notifikasi
    local closeNotification = function()
        if notificationInstance then
            tween(notificationInstance.Items, {
                Position = UDim2.new(0.75, 0, 0, 0)
            }, tweenConfig.Notification)
            task.wait(tweenConfig.Notification.Duration - (tweenConfig.Notification.Duration / 2))
            if notificationInstance then
                notificationInstance:Destroy()
            end
            notificationInstance = nil
        end
    end
    
    notificationInstance.Items.Frame.Title.Close.MouseButton1Click:Connect(closeNotification)
    
    local slideIn = tween(notificationInstance.Items, {
        Position = UDim2.new(0, 0, 0, 0)
    }, tweenConfig.Notification)
    
    slideIn.Completed:Connect(function()
        tween(notificationInstance.Items.TimerBarFill.Bar, {
            Size = UDim2.new(0, 0, 1, 0)
        }, {
            Duration = notificationInfo.Duration
        })
        task.delay(notificationInfo.Duration, closeNotification)
    end)
    
    function notificationFunctions.Close(self)
        closeNotification()
    end
    
    return notificationFunctions
end

return library
end
}

-- Cache untuk IconModule
moduleCache[UI.IconModule] = {
    Closure = function()
        local iconModule = UI.IconModule
        local iconSets, iconFunctions = {
            lucide = customRequire(iconModule.Lucide)
        }, {
            IconsType = "lucide"
        }
        
        function iconFunctions.SetIconsType(self, iconsType)
            iconFunctions.IconsType = iconsType
        end
        
        function iconFunctions.Icon(self, iconName, iconsType)
            local iconSet = iconSets[iconsType or iconFunctions.IconsType]
            if iconSet.Icons[iconName] then
                return {
                    iconSet.Spritesheets[tostring(iconSet.Icons[iconName].Image)],
                    iconSet.Icons[iconName]
                }
            end
            return nil
        end
        
        return iconFunctions
    end
}

return Library