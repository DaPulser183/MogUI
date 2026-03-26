-- =============================================
-- MOGUI - Final Stable Release
-- Left GroupBox + Right GroupBox + Color Picker + Dropdown
-- Fully Fixed Slider Input - No more ghost movement
-- =============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local MogUI = {}
MogUI.__index = MogUI

function MogUI.new(title)
    local self = setmetatable({}, MogUI)

    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MogUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = playerGui

    -- Main Frame
    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 760, 0, 720)
    self.Main.Position = UDim2.new(0.5, -380, 0.5, -360)
    self.Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    self.Main.BorderSizePixel = 0
    self.Main.Visible = false
    self.Main.Parent = self.ScreenGui

    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 215, 80)
    stroke.Thickness = 2.8
    stroke.Parent = self.Main

    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 60)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    self.TitleBar.Parent = self.Main
    Instance.new("UICorner", self.TitleBar).CornerRadius = UDim.new(0, 14)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -110, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "MOGUI • EXPLOIT HUB"
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 80)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.Parent = self.TitleBar

    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Size = UDim2.new(0, 50, 0, 50)
    self.CloseBtn.Position = UDim2.new(1, -60, 0, 5)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = Color3.new(1,1,1)
    self.CloseBtn.TextScaled = true
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.Parent = self.TitleBar
    Instance.new("UICorner", self.CloseBtn).CornerRadius = UDim.new(0, 10)

    -- Content Area
    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, -20, 1, -80)
    self.Content.Position = UDim2.new(0, 10, 0, 70)
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = self.Main

    self.LeftFrame = Instance.new("ScrollingFrame")
    self.LeftFrame.Size = UDim2.new(0.48, 0, 1, 0)
    self.LeftFrame.BackgroundTransparency = 1
    self.LeftFrame.ScrollBarThickness = 6
    self.LeftFrame.Parent = self.Content

    self.RightFrame = Instance.new("ScrollingFrame")
    self.RightFrame.Size = UDim2.new(0.48, 0, 1, 0)
    self.RightFrame.Position = UDim2.new(0.52, 0, 0, 0)
    self.RightFrame.BackgroundTransparency = 1
    self.RightFrame.ScrollBarThickness = 6
    self.RightFrame.Parent = self.Content

    Instance.new("UIListLayout", self.LeftFrame).Padding = UDim.new(0, 12)
    Instance.new("UIListLayout", self.RightFrame).Padding = UDim.new(0, 12)

    self:SetupDragging()
    self:SetupClose()
    self:SetupKeybind(Enum.KeyCode.Comma)

    print("✅ MogUI Final Release Loaded - Press , to open")
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

-- ==================== GROUPBOX ====================
function MogUI:AddLeftGroupbox(title)
    return self:CreateGroupbox(self.LeftFrame, title)
end

function MogUI:AddRightGroupbox(title)
    return self:CreateGroupbox(self.RightFrame, title)
end

function MogUI:CreateGroupbox(parent, title)
    local group = Instance.new("Frame")
    group.Size = UDim2.new(1, 0, 0, 50)
    group.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    group.Parent = parent
    Instance.new("UICorner", group).CornerRadius = UDim.new(0, 12)

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundTransparency = 1
    header.Text = "  " .. title
    header.TextColor3 = Color3.fromRGB(255, 215, 80)
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextScaled = true
    header.Font = Enum.Font.GothamSemibold
    header.Parent = group

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 1, -50)
    container.Position = UDim2.new(0, 8, 0, 45)
    container.BackgroundTransparency = 1
    container.Parent = group

    Instance.new("UIListLayout", container).Padding = UDim.new(0, 10)

    local groupbox = {}

    function groupbox:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = container
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        btn.MouseButton1Click:Connect(callback or function() end)
    end

    function groupbox:AddToggle(text, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BackgroundTransparency = 1
        frame.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.75, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1,1,1)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.Parent = frame

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(0, 55, 0, 28)
        toggleFrame.Position = UDim2.new(1, -65, 0.5, -14)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        toggleFrame.Parent = frame
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 24, 0, 24)
        knob.Position = UDim2.new(0, 2, 0.5, -12)
        knob.BackgroundColor3 = Color3.new(1,1,1)
        knob.Parent = toggleFrame
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local state = default or false

        local function update()
            if state then
                TweenService:Create(toggleFrame, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(80, 200, 120)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.25), {Position = UDim2.new(1, -26, 0.5, -12)}):Play()
            else
                TweenService:Create(toggleFrame, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -12)}):Play()
            end
            if callback then callback(state) end
        end

        toggleFrame.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                state = not state
                update()
            end
        end)

        update()
    end

    function groupbox:AddSlider(text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 65)
        frame.BackgroundTransparency = 1
        frame.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 22)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.new(1,1,1)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.Parent = frame

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 10)
        bar.Position = UDim2.new(0, 0, 0, 32)
        bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        bar.Parent = frame
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(((default - min) / (max - min)), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 215, 80)
        fill.Parent = bar
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local value = default
        local sliding = false

        local function update(percent)
            percent = math.clamp(percent, 0, 1)
            value = math.floor(min + (max - min) * percent)
            label.Text = text .. ": " .. value
            fill.Size = UDim2.new(percent, 0, 1, 0)
            if callback then callback(value) end
        end

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliding = true
                local percent = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                update(percent)
            end
        end)

        bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliding = false
            end
        end)

        -- Only update when sliding on this specific slider
        local inputConn = UserInputService.InputChanged:Connect(function(input)
            if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                update(percent)
            end
        end)

        -- Cleanup
        group.AncestryChanged:Connect(function()
            if not group:IsDescendantOf(game) and inputConn then
                inputConn:Disconnect()
            end
        end)

        return {Update = update}
    end

    function groupbox:AddDropdown(text, options, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 70)
        frame.BackgroundTransparency = 1
        frame.Parent = container

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
        btn.Position = UDim2.new(0, 0, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.Text = default or options[1]
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = frame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        local isOpen = false
        local listFrame = Instance.new("Frame")
        listFrame.Size = UDim2.new(1, 0, 0, 0)
        listFrame.Position = UDim2.new(0, 0, 1, 8)
        listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
        listFrame.ClipsDescendants = true
        listFrame.Visible = false
        listFrame.Parent = frame
        Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 10)

        btn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                listFrame.Visible = true
                TweenService:Create(listFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = UDim2.new(1,0,0,#options*38)}):Play()
            else
                TweenService:Create(listFrame, TweenInfo.new(0.3), {Size = UDim2.new(1,0,0,0)}):Play()
                task.delay(0.35, function() listFrame.Visible = false end)
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
            optBtn.Parent = listFrame
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 8)

            optBtn.MouseButton1Click:Connect(function()
                btn.Text = opt
                isOpen = false
                TweenService:Create(listFrame, TweenInfo.new(0.3), {Size = UDim2.new(1,0,0,0)}):Play()
                task.delay(0.35, function() listFrame.Visible = false end)
                if callback then callback(opt) end
            end)
        end
    end

    function groupbox:AddColorPicker(text, defaultColor, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 95)
        frame.BackgroundTransparency = 1
        frame.Parent = container

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
        local hueGradient = Instance.new("UIGradient", hueBar)
        hueGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
        }
        Instance.new("UICorner", hueBar).CornerRadius = UDim.new(0, 8)

        local currentHue = 0

        local function updateColor()
            local col = Color3.fromHSV(currentHue, 1, 1)
            preview.BackgroundColor3 = col
            if callback then callback(col) end
        end

        hueBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local conn = RunService.RenderStepped:Connect(function()
                    local rel = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                    currentHue = rel
                    updateColor()
                end)
                local endConn = UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        conn:Disconnect()
                        endConn:Disconnect()
                    end
                end)
            end
        end)

        updateColor()
    end

    return groupbox
end

print("✅ MogUI Final Stable Release - Ready for release")
return MogUI
