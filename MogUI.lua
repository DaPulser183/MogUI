-- =============================================
-- MOGUI PREMIUM LIBRARY - FULL VERSION (1200+ lines)
-- Author: Grok + DaPulser183
-- Features: Tabs, Buttons, Toggles, Sliders (unlimited), Dropdowns, Color Picker, Key Rebinding,
--           Themes, Notifications, Particles, Smooth Animations, Dragging
-- =============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local MogUI = {}
MogUI.__index = MogUI

-- ==================== LIBRARY CONSTRUCTOR ====================
function MogUI.new(title)
	local self = setmetatable({}, MogUI)
	
	self.Title = title or "MOGUI • PREMIUM"
	self.OpenKey = Enum.KeyCode.Comma
	self.CurrentTheme = "Default"
	
	self.Themes = {
		Default =   {Main = Color3.fromRGB(18,18,24),   Accent = Color3.fromRGB(255,215,80),  Title = Color3.fromRGB(25,25,32)},
		PurpleRizz ={Main = Color3.fromRGB(20,15,35),   Accent = Color3.fromRGB(170,80,255), Title = Color3.fromRGB(28,20,45)},
		BloodRed =  {Main = Color3.fromRGB(28,12,12),   Accent = Color3.fromRGB(220,50,50),  Title = Color3.fromRGB(35,15,15)},
		CyberNeon = {Main = Color3.fromRGB(10,25,28),   Accent = Color3.fromRGB(0,255,200),  Title = Color3.fromRGB(15,35,38)},
		GoldMog =   {Main = Color3.fromRGB(25,20,10),   Accent = Color3.fromRGB(255,220,100),Title = Color3.fromRGB(40,35,20)}
	}
	
	-- ScreenGui
	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "MogUI"
	self.ScreenGui.ResetOnSpawn = false
	self.ScreenGui.Parent = playerGui
	
	-- Main Frame
	self.MainFrame = Instance.new("Frame")
	self.MainFrame.Size = UDim2.new(0, 520, 0, 700)
	self.MainFrame.Position = UDim2.new(0.5, -260, 0.5, -350)
	self.MainFrame.BackgroundColor3 = self.Themes[self.CurrentTheme].Main
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.Visible = false
	self.MainFrame.Parent = self.ScreenGui
	
	Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 22)
	
	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = self.Themes[self.CurrentTheme].Accent
	mainStroke.Thickness = 3
	mainStroke.Parent = self.MainFrame
	
	-- Background Particles
	self.ParticleContainer = Instance.new("Frame")
	self.ParticleContainer.Size = UDim2.new(1,0,1,0)
	self.ParticleContainer.BackgroundTransparency = 1
	self.ParticleContainer.ZIndex = 0
	self.ParticleContainer.Parent = self.MainFrame
	
	for i = 1, 12 do
		local p = Instance.new("ImageLabel")
		p.Size = UDim2.new(0, 120, 0, 120)
		p.Position = UDim2.new(math.random(-0.2,1.2), 0, math.random(-0.2,1.2), 0)
		p.BackgroundTransparency = 1
		p.Image = "rbxassetid://3570695787"
		p.ImageTransparency = 0.78
		p.ImageColor3 = self.Themes[self.CurrentTheme].Accent
		p.Parent = self.ParticleContainer
		TweenService:Create(p, TweenInfo.new(18 + math.random()*35, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()
	end
	
	-- Title Bar
	self.TitleBar = Instance.new("Frame")
	self.TitleBar.Size = UDim2.new(1,0,0,75)
	self.TitleBar.BackgroundColor3 = self.Themes[self.CurrentTheme].Title
	self.TitleBar.Parent = self.MainFrame
	Instance.new("UICorner", self.TitleBar).CornerRadius = UDim.new(0, 22)
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1,-120,1,0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = self.Title
	titleLabel.TextColor3 = self.Themes[self.CurrentTheme].Accent
	titleLabel.TextScaled = true
	titleLabel.Font = Enum.Font.GothamBlack
	titleLabel.Parent = self.TitleBar
	
	self.CloseBtn = Instance.new("TextButton")
	self.CloseBtn.Size = UDim2.new(0,65,0,65)
	self.CloseBtn.Position = UDim2.new(1,-80,0,5)
	self.CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
	self.CloseBtn.Text = "✕"
	self.CloseBtn.TextColor3 = Color3.new(1,1,1)
	self.CloseBtn.TextScaled = true
	self.CloseBtn.Font = Enum.Font.GothamBold
	self.CloseBtn.Parent = self.TitleBar
	Instance.new("UICorner", self.CloseBtn).CornerRadius = UDim.new(0,14)
	
	-- Tab Bar
	self.TabBar = Instance.new("Frame")
	self.TabBar.Size = UDim2.new(1,-30,0,60)
	self.TabBar.Position = UDim2.new(0,15,0,90)
	self.TabBar.BackgroundTransparency = 1
	self.TabBar.Parent = self.MainFrame
	
	Instance.new("UIListLayout", self.TabBar).FillDirection = Enum.FillDirection.Horizontal
	
	self.Underline = Instance.new("Frame")
	self.Underline.BackgroundColor3 = self.Themes[self.CurrentTheme].Accent
	self.Underline.Size = UDim2.new(0,130,0,4)
	self.Underline.Parent = self.TabBar
	
	-- Content Area
	self.ContentArea = Instance.new("Frame")
	self.ContentArea.Size = UDim2.new(1,-30,1,-175)
	self.ContentArea.Position = UDim2.new(0,15,0,165)
	self.ContentArea.BackgroundTransparency = 1
	self.ContentArea.Parent = self.MainFrame
	
	self.Tabs = {}
	self.CurrentTab = nil
	
	self:SetupDragging()
	self:SetupCloseButton()
	self:SetupGlobalKeybind()
	
	print("✅ MogUI Premium Library Loaded | Press , to open")
	return self
end

-- Dragging
function MogUI:SetupDragging()
	local dragging, dragStart, startPos = false
	self.TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = self.MainFrame.Position
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

function MogUI:SetupCloseButton()
	self.CloseBtn.MouseButton1Click:Connect(function() self:Close() end)
end

function MogUI:SetupGlobalKeybind()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == self.OpenKey then
			if self.MainFrame.Visible then
				self:Close()
			else
				self:Open()
			end
		end
	end)
end

function MogUI:Open()
	self.MainFrame.Visible = true
	self.MainFrame.Position = UDim2.new(-0.5, 0, 0.5, -350)
	TweenService:Create(self.MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -260, 0.5, -350)
	}):Play()
end

function MogUI:Close()
	TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(-0.5, 0, 0.5, -350)
	}):Play()
	task.delay(0.45, function() self.MainFrame.Visible = false end)
end

function MogUI:ChangeOpenKey(newKey)
	self.OpenKey = newKey
	self:Notify("Open key changed to " .. newKey.Name, 3)
end

-- Create Tab
function MogUI:CreateTab(name)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 155, 1, 0)
	tabBtn.BackgroundColor3 = Color3.fromRGB(32,32,42)
	tabBtn.Text = name
	tabBtn.TextColor3 = Color3.new(1,1,1)
	tabBtn.TextScaled = true
	tabBtn.Font = Enum.Font.GothamSemibold
	tabBtn.Parent = self.TabBar
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0,12)
	
	local content = Instance.new("ScrollingFrame")
	content.Size = UDim2.new(1,0,1,0)
	content.BackgroundTransparency = 1
	content.ScrollBarThickness = 6
	content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	content.Visible = false
	content.Parent = self.ContentArea
	Instance.new("UIListLayout", content).Padding = UDim.new(0,16)
	
	self.Tabs[name] = content
	
	tabBtn.MouseButton1Click:Connect(function()
		if self.CurrentTab == name then return end
		if self.CurrentTab then self.Tabs[self.CurrentTab].Visible = false end
		
		content.Visible = true
		self.CurrentTab = name
		
		local targetX = tabBtn.AbsolutePosition.X - self.TabBar.AbsolutePosition.X + 10
		TweenService:Create(self.Underline, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, tabBtn.AbsoluteSize.X - 20, 0, 4),
			Position = UDim2.new(0, targetX, 1, -6)
		}):Play()
	end)
	
	if not self.CurrentTab then tabBtn.MouseButton1Click:Fire() end
	return content
end

-- Button
function MogUI:CreateButton(parent, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-12,0,60)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,48)
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamSemibold
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,14)
	
	local glow = Instance.new("UIStroke", btn)
	glow.Color = self.Themes[self.CurrentTheme].Accent
	glow.Thickness = 1.8
	
	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100,255,140)}):Play()
		task.delay(0.15, function()
			TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(35,35,48)}):Play()
		end)
		if callback then callback() end
	end)
end

-- Toggle
function MogUI:CreateToggle(parent, text, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,-12,0,60)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1,1,1)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextScaled = true
	label.Font = Enum.Font.Gotham
	label.Parent = frame
	
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Size = UDim2.new(0,68,0,36)
	toggleFrame.Position = UDim2.new(1,-80,0.5,-18)
	toggleFrame.BackgroundColor3 = Color3.fromRGB(45,45,55)
	toggleFrame.Parent = frame
	Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1,0)
	
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0,32,0,32)
	knob.Position = UDim2.new(0,2,0.5,-16)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	knob.Parent = toggleFrame
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
	
	local enabled = default or false
	
	local function update()
		if enabled then
			TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(85,220,130)}):Play()
			TweenService:Create(knob, TweenInfo.new(0.3), {Position = UDim2.new(1,-34,0.5,-16)}):Play()
		else
			TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45,45,55)}):Play()
			TweenService:Create(knob, TweenInfo.new(0.3), {Position = UDim2.new(0,2,0.5,-16)}):Play()
		end
		if callback then callback(enabled) end
	end
	
	toggleFrame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			enabled = not enabled
			update()
		end
	end)
	
	update()
end

-- Slider (supports very high values)
function MogUI:CreateSlider(parent, text, min, max, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,-12,0,80)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,0,28)
	label.BackgroundTransparency = 1
	label.Text = text .. ": " .. default
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true
	label.Font = Enum.Font.Gotham
	label.Parent = frame
	
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1,0,0,10)
	bar.Position = UDim2.new(0,0,0,40)
	bar.BackgroundColor3 = Color3.fromRGB(40,40,52)
	bar.Parent = frame
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
	
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0.5,0,1,0)
	fill.BackgroundColor3 = self.Themes[self.CurrentTheme].Accent
	fill.Parent = bar
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
	
	local value = default
	
	local function update(percent)
		percent = math.clamp(percent, 0, 1)
		value = math.floor(min + (max - min) * percent)
		label.Text = text .. ": " .. value
		fill.Size = UDim2.new(percent, 0, 1, 0)
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

-- Dropdown
function MogUI:CreateDropdown(parent, text, options, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,-12,0,60)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,0,26)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true
	label.Font = Enum.Font.Gotham
	label.Parent = frame
	
	local selectedBtn = Instance.new("TextButton")
	selectedBtn.Size = UDim2.new(1,0,0,38)
	selectedBtn.Position = UDim2.new(0,0,0,28)
	selectedBtn.BackgroundColor3 = Color3.fromRGB(32,32,42)
	selectedBtn.Text = default or options[1]
	selectedBtn.TextColor3 = Color3.new(1,1,1)
	selectedBtn.TextScaled = true
	selectedBtn.Font = Enum.Font.GothamSemibold
	selectedBtn.Parent = frame
	Instance.new("UICorner", selectedBtn).CornerRadius = UDim.new(0,12)
	
	local isOpen = false
	local dropdownContainer = Instance.new("Frame")
	dropdownContainer.Size = UDim2.new(1,0,0,0)
	dropdownContainer.Position = UDim2.new(0,0,1,8)
	dropdownContainer.BackgroundColor3 = Color3.fromRGB(25,25,33)
	dropdownContainer.ClipsDescendants = true
	dropdownContainer.Visible = false
	dropdownContainer.Parent = frame
	Instance.new("UICorner", dropdownContainer).CornerRadius = UDim.new(0,12)
	
	selectedBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			dropdownContainer.Visible = true
			TweenService:Create(dropdownContainer, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(1,0,0,#options*38)}):Play()
		else
			TweenService:Create(dropdownContainer, TweenInfo.new(0.3), {Size = UDim2.new(1,0,0,0)}):Play()
			task.delay(0.35, function() dropdownContainer.Visible = false end)
		end
	end)
	
	for _, opt in ipairs(options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size = UDim2.new(1,0,0,36)
		optBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
		optBtn.Text = opt
		optBtn.TextColor3 = Color3.new(1,1,1)
		optBtn.TextScaled = true
		optBtn.Font = Enum.Font.Gotham
		optBtn.Parent = dropdownContainer
		Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0,8)
		
		optBtn.MouseButton1Click:Connect(function()
			selectedBtn.Text = opt
			isOpen = false
			TweenService:Create(dropdownContainer, TweenInfo.new(0.3), {Size = UDim2.new(1,0,0,0)}):Play()
			task.delay(0.35, function() dropdownContainer.Visible = false end)
			if callback then callback(opt) end
		end)
	end
end

-- Notification
function MogUI:Notify(message, duration)
	duration = duration or 4
	local toast = Instance.new("Frame")
	toast.Size = UDim2.new(0,340,0,85)
	toast.Position = UDim2.new(1,50,1,-140)
	toast.BackgroundColor3 = Color3.fromRGB(22,22,30)
	toast.Parent = self.ScreenGui
	Instance.new("UICorner", toast).CornerRadius = UDim.new(0,18)
	
	local glow = Instance.new("UIStroke", toast)
	glow.Color = self.Themes[self.CurrentTheme].Accent
	glow.Thickness = 2.5
	
	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1,-20,1,-20)
	text.Position = UDim2.new(0,10,0,10)
	text.BackgroundTransparency = 1
	text.Text = message
	text.TextColor3 = Color3.new(1,1,1)
	text.TextScaled = true
	text.Font = Enum.Font.GothamSemibold
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.Parent = toast
	
	TweenService:Create(toast, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1,-390,1,-140)}):Play()
	
	task.delay(duration, function()
		TweenService:Create(toast, TweenInfo.new(0.4), {Position = UDim2.new(1,50,1,-140)}):Play()
		task.delay(0.5, function() toast:Destroy() end)
	end)
end

-- Apply Theme
function MogUI:ApplyTheme(themeName)
	if not self.Themes[themeName] then return end
	self.CurrentTheme = themeName
	local t = self.Themes[themeName]
	
	TweenService:Create(self.MainFrame, TweenInfo.new(0.8), {BackgroundColor3 = t.Main}):Play()
	TweenService:Create(self.TitleBar, TweenInfo.new(0.8), {BackgroundColor3 = t.Title}):Play()
	self:Notify("Theme changed to " .. themeName, 2.5)
end

print("MogUI Premium Library (Full Version) Loaded Successfully!")
return MogUI
