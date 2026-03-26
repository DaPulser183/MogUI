-- MOGUI Premium - Loadstring Ready Version
-- Toggle Key: Comma (,)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MogUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 440, 0, 600)
mainFrame.Position = UDim2.new(0.5, -220, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 215, 80)
stroke.Thickness = 2.5
stroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 65)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MOGUI • PREMIUM"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 80)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 55, 0, 55)
closeBtn.Position = UDim2.new(1, -62, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 12)

-- Content Area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -30, 1, -100)
content.Position = UDim2.new(0, 15, 0, 80)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local welcome = Instance.new("TextLabel")
welcome.Size = UDim2.new(1, 0, 0.7, 0)
welcome.BackgroundTransparency = 1
welcome.Text = "MOGGER MENU\n\nLoaded via GitHub\n\nPress , (Comma) to toggle"
welcome.TextColor3 = Color3.new(1,1,1)
welcome.TextScaled = true
welcome.Font = Enum.Font.GothamBold
welcome.Parent = content

-- Tween Helper
local function tween(obj, props, info)
	TweenService:Create(obj, info or TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props):Play()
end

local function openMenu()
	mainFrame.Visible = true
	mainFrame.Position = UDim2.new(-0.6, 0, 0.5, -300)
	tween(mainFrame, {Position = UDim2.new(0.5, -220, 0.5, -300)})
end

local function closeMenu()
	tween(mainFrame, {Position = UDim2.new(-0.6, 0, 0.5, -300)}, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
	task.delay(0.4, function() mainFrame.Visible = false end)
end

closeBtn.MouseButton1Click:Connect(closeMenu)

-- Dragging
local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Toggle with Comma key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Comma then
		if mainFrame.Visible then
			closeMenu()
		else
			openMenu()
		end
	end
end)

print("✅ MOGUI Premium Loaded from GitHub - Press , to open")
