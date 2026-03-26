-- =============================================
-- MOGUI - Linoria Inspired UI Library (Mogger Edition)
-- Clean API + Premium dark/gold aesthetic
-- =============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library

-- ==================== CREATE WINDOW ====================
function Library:CreateWindow(config)
    local self = setmetatable({}, Library)
    
    self.Window = Instance.new("ScreenGui")
    self.Window.Name = "MogUI"
    self.Window.ResetOnSpawn = false
    self.Window.Parent = playerGui
    
    -- Main Frame (Linoria-like but with mogger glow)
    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 620, 0, 680)
    self.Main.Position = UDim2.new(0.5, -310, 0.5, -340)
    self.Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    self.Main.BorderSizePixel = 0
    self.Main.Visible = false
    self.Main.Parent = self.Window
    
    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 16)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 215, 80)  -- Gold mogger accent
    stroke.Thickness = 2.5
    stroke.Parent = self.Main
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    self.TitleBar.Parent = self.Main
    Instance.new("UICorner", self.TitleBar).CornerRadius = UDim.new(0, 16)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "MOGUI"
    title.TextColor3 = Color3.fromRGB(255, 215, 80)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBlack
    title.Parent = self.TitleBar
    
    -- Close Button
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    self.CloseBtn.Position = UDim2.new(1, -50, 0, 5)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = Color3.new(1,1,1)
    self.CloseBtn.TextScaled = true
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.Parent = self.TitleBar
    Instance.new("UICorner", self.CloseBtn).CornerRadius = UDim.new(0, 10)
    
    -- Content Container
    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, -20, 1, -70)
    self.Content.Position = UDim2.new(0, 10, 0, 60)
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = self.Main
    
    -- Left / Right Group support (Linoria style)
    self.LeftGroup = Instance.new("ScrollingFrame")
    self.LeftGroup.Size = UDim2.new(0.48, 0, 1, 0)
    self.LeftGroup.BackgroundTransparency = 1
    self.LeftGroup.ScrollBarThickness = 4
    self.LeftGroup.Parent = self.Content
    
    Instance.new("UIListLayout", self.LeftGroup).Padding = UDim.new(0, 10)
    
    self:SetupDragging()
    self:SetupClose()
    self:SetupKeybind(config.ToggleKey or Enum.KeyCode.Comma)
    
    print("MogUI Loaded - Press , to open")
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

-- ==================== GROUP BOX (Linoria Style) ====================
function Library:AddLeftGroupbox(name)
    local group = Instance.new("Frame")
    group.Size = UDim2.new(1, 0, 0, 40)
    group.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    group.Parent = self.LeftGroup
    Instance.new("UICorner", group).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "   " .. name
    title.TextColor3 = Color3.fromRGB(255, 215, 80)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextScaled = true
    title.Font = Enum.Font.GothamSemibold
    title.Parent = group
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -50)
    content.Position = UDim2.new(0, 10, 0, 45)
    content.BackgroundTransparency = 1
    content.Parent = group
    
    Instance.new("UIListLayout", content).Padding = UDim.new(0, 8)
    
    return {
        AddButton = function(_, text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 45)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            btn.Text = text
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamSemibold
            btn.Parent = content
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
            
            btn.MouseButton1Click:Connect(callback)
            return btn
        end,
        
        AddToggle = function(_, text, default, callback)
            -- Simple toggle implementation (expandable)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 45)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = content
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.7, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = Color3.new(1,1,1)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextScaled = true
            lbl.Parent = toggleFrame
            
            print("Toggle added:", text)
            -- Full toggle code can be expanded here
        end,
        
        AddSlider = function(_, text, min, max, default, callback)
            print("Slider added:", text, "Range:", min, "-", max)
            -- Full slider code can be expanded
        end
    }
end

-- Open the menu initially for testing
task.wait(1)
local window = Library:CreateWindow({Title = "MOGUI • SIGMA EDITION"})
local tab = window:AddLeftGroupbox("Main Cheats")

tab:AddButton("MOG THE SERVER", function()
    print("💪 FULL MOG ACTIVATED")
end)

tab:AddToggle("Auto Rizz", true, function(v)
    print("Auto Rizz:", v)
end)

print("MogUI (Linoria-style + Mogger tweak) Ready!")
