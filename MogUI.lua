-- =============================================
-- MOGUI - FULLY FIXED & STABLE VERSION
-- Automatic Sizing + No Overlapping + All Methods Working
-- =============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

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

    -- Main Window
    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 800, 0, 740)
    self.Main.Position = UDim2.new(0.5, -400, 0.5, -370)
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
    self.TitleBar.Size = UDim2.new(1, 0, 0, 65)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    self.TitleBar.Parent = self.Main
    Instance.new("UICorner", self.TitleBar).CornerRadius = UDim.new(0, 14)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -130, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "MOGUI • ENHANCED UNIVERSAL"
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 80)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.TitleBar

    -- Close Button
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Size = UDim2.new(0, 55, 0, 55)
    self.CloseBtn.Position = UDim2.new(1, -70, 0, 5)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = Color3.new(1,1,1)
    self.CloseBtn.TextScaled = true
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.Parent = self.TitleBar
    Instance.new("UICorner", self.CloseBtn).CornerRadius = UDim.new(0, 12)

    -- Content Area
    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, -24, 1, -85)
    self.Content.Position = UDim2.new(0, 12, 0, 75)
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = self.Main

    -- Left Scrolling Frame
    self.LeftFrame = Instance.new("ScrollingFrame")
    self.LeftFrame.Size = UDim2.new(0.485, 0, 1, 0)
    self.LeftFrame.BackgroundTransparency = 1
    self.LeftFrame.ScrollBarThickness = 5
    self.LeftFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 80)
    self.LeftFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.LeftFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.LeftFrame.Parent = self.Content

    -- Right Scrolling Frame
    self.RightFrame = Instance.new("ScrollingFrame")
    self.RightFrame.Size = UDim2.new(0.485, 0, 1, 0)
    self.RightFrame.Position = UDim2.new(0.515, 0, 0, 0)
    self.RightFrame.BackgroundTransparency = 1
    self.RightFrame.ScrollBarThickness = 5
    self.RightFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 80)
    self.RightFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.RightFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.RightFrame.Parent = self.Content

    Instance.new("UIListLayout", self.LeftFrame).Padding = UDim.new(0, 16)
    Instance.new("UIListLayout", self.RightFrame).Padding = UDim.new(0, 16)

    self:SetupDragging()
    self:SetupClose()
    self:SetupKeybind(Enum.KeyCode.Comma)

    print("✅ MogUI Fixed & Clean Version Loaded - Press , to open")
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

-- ==================== GROUPBOX - FULLY FIXED ====================
function MogUI:AddLeftGroupbox(title)
    return self:CreateGroupbox(self.LeftFrame, title)
end

function MogUI:AddRightGroupbox(title)
    return self:CreateGroupbox(self.RightFrame, title)
end

function MogUI:CreateGroupbox(parent, title)
    local group = Instance.new("Frame")
    group.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    group.AutomaticSize = Enum.AutomaticSize.Y
    group.Size = UDim2.new(1, 0, 0, 0)
    group.BorderSizePixel = 0
    group.Parent = parent

    Instance.new("UICorner", group).CornerRadius = UDim.new(0, 12)

    -- Header
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundTransparency = 1
    header.Text = "   " .. title
    header.TextColor3 = Color3.fromRGB(255, 215, 80)
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextScaled = true
    header.Font = Enum.Font.GothamSemibold
    header.Parent = group

    -- Container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 1, -52)
    container.Position = UDim2.new(0, 8, 0, 48)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = group

    Instance.new("UIListLayout", container).Padding = UDim.new(0, 12)

    local groupbox = { container = container }

    -- AddButton
    function groupbox:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 48)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = container
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        btn.MouseButton1Click:Connect(callback or function() end)
    end

    -- AddToggle
    function groupbox:AddToggle(text, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 52)
        frame.BackgroundTransparency = 1
        frame.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.68, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1,1,1)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.Parent = frame

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(0, 58, 0, 30)
        toggleFrame.Position = UDim2.new(1, -68, 0.5, -15)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        toggleFrame.Parent = frame
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 26, 0, 26)
        knob.Position = UDim2.new(0, 2, 0.5, -13)
        knob.BackgroundColor3 = Color3.new(1,1,1)
        knob.Parent = toggleFrame
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local state = default or false

        local function update()
            if state then
                TweenService:Create(toggleFrame, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(80, 200, 120)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.25), {Position = UDim2.new(1, -28, 0.5, -13)}):Play()
            else
                TweenService:Create(toggleFrame, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -13)}):Play()
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

    -- AddSlider
    function groupbox:AddSlider(text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 70)
        frame.BackgroundTransparency = 1
        frame.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 26)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.new(1,1,1)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 12)
        bar.Position = UDim2.new(0, 0, 0, 34)
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
            if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                update(percent)
            end
        end)
    end

    return groupbox
end

print("✅ MogUI Library Ready")
return MogUI
