-- =============================================
-- MOGUI - Linoria + Rayfield Inspired UI Library
-- Clean, Modern, Premium Dark Theme with Gold Accents
-- =============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local MogUI = {}
MogUI.__index = MogUI

-- ==================== CREATE WINDOW ====================
function MogUI.new(title)
    local self = setmetatable({}, MogUI)

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MogUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = playerGui

    -- Main Frame
    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 720, 0, 680)
    self.Main.Position = UDim2.new(0.5, -360, 0.5, -340)
    self.Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    self.Main.BorderSizePixel = 0
    self.Main.Visible = false
    self.Main.Parent = self.ScreenGui

    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 16)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 215, 80)
    stroke.Thickness = 2.5
    stroke.Parent = self.Main

    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 60)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    self.TitleBar.Parent = self.Main
    Instance.new("UICorner", self.TitleBar).CornerRadius = UDim.new(0, 16)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "MOGUI"
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 80)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.Parent = self.TitleBar

    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Size = UDim2.new(0, 45, 0, 45)
    self.CloseBtn.Position = UDim2.new(1, -55, 0, 8)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = Color3.new(1,1,1)
    self.CloseBtn.TextScaled = true
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.Parent = self.TitleBar
    Instance.new("UICorner", self.CloseBtn).CornerRadius = UDim.new(0, 10)

    -- Tab Bar
    self.TabBar = Instance.new("Frame")
    self.TabBar.Size = UDim2.new(1, -20, 0, 50)
    self.TabBar.Position = UDim2.new(0, 10, 0, 70)
    self.TabBar.BackgroundTransparency = 1
    self.TabBar.Parent = self.Main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = self.TabBar

    self.Underline = Instance.new("Frame")
    self.Underline.BackgroundColor3 = Color3.fromRGB(255, 215, 80)
    self.Underline.Size = UDim2.new(0, 100, 0, 3)
    self.Underline.Parent = self.TabBar

    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -20, 1, -140)
    self.ContentArea.Position = UDim2.new(0, 10, 0, 130)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Parent = self.Main

    self.Tabs = {}
    self.CurrentTab = nil

    self:SetupDragging()
    self:SetupClose()
    self:SetupKeybind(Enum.KeyCode.Comma)

    print("✅ MogUI Loaded - Press , to open")
    return self
end

function MogUI:SetupDragging()
    local dragging = false
    local dragStart, startPos

    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function MogUI:SetupClose()
    self.CloseBtn.MouseButton1Click:Connect(function()
        self.Main.Visible = false
    end)
end

function MogUI:SetupKeybind(key)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == key then
            self.Main.Visible = not self.Main.Visible
        end
    end)
end

-- Create Tab
function MogUI:CreateTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 140, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.new(1,1,1)
    tabBtn.TextScaled = true
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.Parent = self.TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 6
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.Visible = false
    tabContent.Parent = self.ContentArea

    Instance.new("UIListLayout", tabContent).Padding = UDim.new(0, 12)

    self.Tabs[name] = tabContent

    tabBtn.MouseButton1Click:Connect(function()
        if self.CurrentTab == name then return end
        if self.CurrentTab then
            self.Tabs[self.CurrentTab].Visible = false
        end
        tabContent.Visible = true
        self.CurrentTab = name

        -- Underline animation
        local x = tabBtn.AbsolutePosition.X - self.TabBar.AbsolutePosition.X + 8
        TweenService:Create(self.Underline, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, tabBtn.AbsoluteSize.X - 16, 0, 3),
            Position = UDim2.new(0, x, 1, -6)
        }):Play()
    end)

    if not self.CurrentTab then
        tabBtn.MouseButton1Click:Fire()
    end

    return tabContent
end

-- ==================== UI CONTROLS ====================

function MogUI:AddButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 48)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(callback or function() end)
end

function MogUI:AddToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 48)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 52, 0, 28)
    toggle.Position = UDim2.new(1, -62, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 24, 0, 24)
    knob.Position = UDim2.new(0, 2, 0.5, -12)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = toggle
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = default or false

    local function update()
        if state then
            TweenService:Create(toggle, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(80, 200, 120)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.25), {Position = UDim2.new(1, -26, 0.5, -12)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -12)}):Play()
        end
        if callback then callback(state) end
    end

    toggle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            update()
        end
    end)

    update()
end

function MogUI:AddSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 68)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 24)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, 34)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 215, 80)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local value = default

    local function update(p)
        p = math.clamp(p, 0, 1)
        value = math.floor(min + (max - min) * p)
        label.Text = text .. ": " .. value
        fill.Size = UDim2.new(p, 0, 1, 0)
        if callback then callback(value) end
    end

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            local p = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
            update(p)
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
            update(p)
        end
    end)
end

function MogUI:AddDropdown(parent, text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 65)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Position = UDim2.new(0, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = default or options[1]
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local isOpen = false
    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 1, 8)
    list.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
    list.ClipsDescendants = true
    list.Visible = false
    list.Parent = frame
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            list.Visible = true
            TweenService:Create(list, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = UDim2.new(1,0,0,#options*38)}):Play()
        else
            TweenService:Create(list, TweenInfo.new(0.3), {Size = UDim2.new(1,0,0,0)}):Play()
            task.delay(0.35, function() list.Visible = false end)
        end
    end)

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 36)
        optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1,1,1)
        optBtn.TextScaled = true
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = list
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 8)

        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            isOpen = false
            TweenService:Create(list, TweenInfo.new(0.3), {Size = UDim2.new(1,0,0,0)}):Play()
            task.delay(0.35, function() list.Visible = false end)
            if callback then callback(opt) end
        end)
    end
end

function MogUI:AddColorPicker(parent, text, defaultColor, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 95)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 85, 0, 60)
    preview.Position = UDim2.new(0, 0, 0, 30)
    preview.BackgroundColor3 = defaultColor or Color3.fromRGB(255, 100, 100)
    preview.Parent = frame
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 12)

    local hueBar = Instance.new("Frame")
    hueBar.Size = UDim2.new(0, 28, 0, 60)
    hueBar.Position = UDim2.new(0, 100, 0, 30)
    hueBar.BackgroundColor3 = Color3.new(1,1,1)
    hueBar.Parent = frame
    local gradient = Instance.new("UIGradient", hueBar)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
    }
    Instance.new("UICorner", hueBar).CornerRadius = UDim.new(0, 8)

    local currentHue = 0

    local function update()
        local col = Color3.fromHSV(currentHue, 1, 1)
        preview.BackgroundColor3 = col
        if callback then callback(col) end
    end

    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn = RunService.RenderStepped:Connect(function()
                local rel = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                currentHue = rel
                update()
            end)
            local endConn = UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    conn:Disconnect()
                    endConn:Disconnect()
                end
            end)
        end
    end)

    update()
end

print("MogUI (Linoria + Rayfield Mix) Loaded - Ready for your exploit script")
return MogUI
