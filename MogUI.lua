-- =============================================
-- MOGUI - Linoria Style UI Library (Mogger Edition)
-- Clean GroupBox API + Premium Gold Accents
-- =============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library

-- Create Window
function Library:CreateWindow(title)
    local self = setmetatable({}, Library)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MogUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = playerGui
    
    -- Main Window (Linoria-like size and layout)
    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 680, 0, 720)
    self.Main.Position = UDim2.new(0.5, -340, 0.5, -360)
    self.Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    self.Main.BorderSizePixel = 0
    self.Main.Visible = false
    self.Main.Parent = self.ScreenGui
    
    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 12)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 215, 80) -- Gold mogger accent
    stroke.Thickness = 2.5
    stroke.Parent = self.Main
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 55)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    self.TitleBar.Parent = self.Main
    Instance.new("UICorner", self.TitleBar).CornerRadius = UDim.new(0, 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "MOGUI"
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 80)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.Parent = self.TitleBar
    
    -- Close Button
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Size = UDim2.new(0, 45, 0, 45)
    self.CloseBtn.Position = UDim2.new(1, -55, 0, 5)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 50, 50)
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = Color3.new(1,1,1)
    self.CloseBtn.TextScaled = true
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.Parent = self.TitleBar
    Instance.new("UICorner", self.CloseBtn).CornerRadius = UDim.new(0, 10)
    
    -- Content Frame
    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, -20, 1, -70)
    self.Content.Position = UDim2.new(0, 10, 0, 65)
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = self.Main
    
    -- Left Group (Linoria style)
    self.Left = Instance.new("ScrollingFrame")
    self.Left.Size = UDim2.new(0.48, 0, 1, 0)
    self.Left.Position = UDim2.new(0, 0, 0, 0)
    self.Left.BackgroundTransparency = 1
    self.Left.ScrollBarThickness = 5
    self.Left.Parent = self.Content
    
    Instance.new("UIListLayout", self.Left).Padding = UDim.new(0, 12)
    
    self:SetupDragging()
    self:SetupClose()
    self:SetupKeybind(Enum.KeyCode.Comma)
    
    print("✅ MogUI (Linoria Style) Loaded - Press , to open")
    return self
end

function Library:SetupDragging()
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

function Library:SetupClose()
    self.CloseBtn.MouseButton1Click:Connect(function()
        self.Main.Visible = false
    end)
end

function Library:SetupKeybind(key)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == key then
            self.Main.Visible = not self.Main.Visible
        end
    end)
end

-- Create Left GroupBox (very Linoria-like)
function Library:AddLeftGroupbox(title)
    local group = Instance.new("Frame")
    group.Size = UDim2.new(1, 0, 0, 50)
    group.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    group.Parent = self.Left
    Instance.new("UICorner", group).CornerRadius = UDim.new(0, 10)
    
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
    
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)
    
    local groupbox = {}
    
    function groupbox:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 42)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = container
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        btn.MouseButton1Click:Connect(callback or function() end)
        return btn
    end
    
    function groupbox:AddToggle(text, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 42)
        frame.BackgroundTransparency = 1
        frame.Parent = container
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.75, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextScaled = true
        lbl.Font = Enum.Font.Gotham
        lbl.Parent = frame
        
        local toggle = Instance.new("Frame")
        toggle.Size = UDim2.new(0, 50, 0, 26)
        toggle.Position = UDim2.new(1, -60, 0.5, -13)
        toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        toggle.Parent = frame
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
        
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 22, 0, 22)
        knob.Position = UDim2.new(0, 2, 0.5, -11)
        knob.BackgroundColor3 = Color3.new(1,1,1)
        knob.Parent = toggle
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        
        local state = default or false
        
        local function update()
            if state then
                TweenService:Create(toggle, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(80, 200, 120)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.25), {Position = UDim2.new(1, -24, 0.5, -11)}):Play()
            else
                TweenService:Create(toggle, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -11)}):Play()
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
    
    function groupbox:AddSlider(text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 55)
        frame.BackgroundTransparency = 1
        frame.Parent = container
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.Text = text .. ": " .. default
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.TextScaled = true
        lbl.Font = Enum.Font.Gotham
        lbl.Parent = frame
        
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 8)
        bar.Position = UDim2.new(0, 0, 0, 28)
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
            lbl.Text = text .. ": " .. value
            fill.Size = UDim2.new(p, 0, 1, 0)
            if callback then callback(value) end
        end
        
        bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                local p = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                update(p)
            end
        end)
        
        return {Update = update}
    end
    
    return groupbox
end

-- Quick test
task.wait(1)
local window = Library:CreateWindow("MOGUI • SIGMA HUB")

local mainGroup = window:AddLeftGroupbox("Main")
mainGroup:AddButton("MOG THE SERVER", function() print("💪 MOG ACTIVATED") end)
mainGroup:AddToggle("Auto Mog", true, function(v) print("Auto Mog:", v) end)
mainGroup:AddSlider("Mog Power", 0, 200, 85, function(v) print("Power:", v) end)

print("MogUI ready!")
