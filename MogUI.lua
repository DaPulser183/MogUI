--!strict
-- MogUI Premium Edition
-- Modern, smooth, and highly customizable UI Library for Roblox.

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Fallback for environments lacking CoreGui access
local targetGui = select(2, pcall(function() return CoreGui end)) or Players.LocalPlayer:WaitForChild("PlayerGui")

local MogUI = {
    Themes = {
        Default = {
            Background = Color3.fromRGB(15, 15, 18),
            Container = Color3.fromRGB(22, 22, 26),
            Border = Color3.fromRGB(35, 35, 42),
            Accent = Color3.fromRGB(235, 185, 50), -- Gold Mog
            Text = Color3.fromRGB(255, 255, 255),
            TextDark = Color3.fromRGB(160, 160, 170),
            Hover = Color3.fromRGB(30, 30, 35)
        },
        PurpleRizz = {
            Background = Color3.fromRGB(15, 12, 20),
            Container = Color3.fromRGB(22, 18, 28),
            Border = Color3.fromRGB(40, 30, 50),
            Accent = Color3.fromRGB(160, 80, 255),
            Text = Color3.fromRGB(255, 255, 255),
            TextDark = Color3.fromRGB(160, 150, 180),
            Hover = Color3.fromRGB(30, 25, 40)
        },
        BloodRed = {
            Background = Color3.fromRGB(18, 10, 10),
            Container = Color3.fromRGB(25, 15, 15),
            Border = Color3.fromRGB(45, 20, 20),
            Accent = Color3.fromRGB(220, 40, 40),
            Text = Color3.fromRGB(255, 255, 255),
            TextDark = Color3.fromRGB(180, 150, 150),
            Hover = Color3.fromRGB(35, 20, 20)
        },
        CyberNeon = {
            Background = Color3.fromRGB(10, 15, 20),
            Container = Color3.fromRGB(15, 22, 30),
            Border = Color3.fromRGB(20, 40, 50),
            Accent = Color3.fromRGB(0, 255, 200),
            Text = Color3.fromRGB(255, 255, 255),
            TextDark = Color3.fromRGB(130, 180, 200),
            Hover = Color3.fromRGB(25, 35, 45)
        }
    },
    CurrentTheme = "Default",
    Toggled = true,
    ToggleKey = Enum.KeyCode.Comma,
    ActiveWindow = nil
}

-- Utility: Create instances efficiently
local function Make(className: string, properties: table): Instance
    local inst = Instance.new(className)
    for k, v in pairs(properties) do
        if k ~= "Parent" then inst[k] = v end
    end
    if properties.Parent then inst.Parent = properties.Parent end
    return inst
end

-- Utility: Tween instances
local function Tween(instance: Instance, properties: table, length: number, style: Enum.EasingStyle?, direction: Enum.EasingDirection?)
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    local info = TweenInfo.new(length or 0.3, style, direction)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

-- Utility: Drag logic
local function MakeDraggable(topbarObject: Instance, object: Instance)
    local dragging, dragInput, dragStart, startPos
    
    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(object, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1, Enum.EasingStyle.Linear)
        end
    end)
end

-- Main Library Constructor
function MogUI.new(title: string)
    local library = {}
    local theme = MogUI.Themes[MogUI.CurrentTheme]

    local ScreenGui = Make("ScreenGui", {
        Name = "MogUI_" .. tostring(math.random(1000, 9999)),
        ResetOnSpawn = false,
        Parent = targetGui,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    MogUI.ActiveWindow = ScreenGui

    local Main = Make("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = theme.Background,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = false
    })
    
    Make("UICorner", { CornerRadius = UDim.new(0, 16), Parent = Main })
    Make("UIStroke", { Color = theme.Border, Thickness = 1, Parent = Main })

    -- Glow Background Effect
    local Glow = Make("ImageLabel", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -30, 0, -30),
        Size = UDim2.new(1, 60, 1, 60),
        Image = "rbxassetid://5028857084",
        ImageColor3 = theme.Accent,
        ImageTransparency = 0.8,
        ZIndex = 0
    })

    local Topbar = Make("Frame", {
        Name = "Topbar",
        Parent = Main,
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    local TitleLabel = Make("TextLabel", {
        Name = "Title",
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title .. " <font color='rgb(" .. math.floor(theme.Accent.R*255) .. "," .. math.floor(theme.Accent.G*255) .. "," .. math.floor(theme.Accent.B*255) .. ")'>[PREMIUM]</font>",
        RichText = true,
        TextColor3 = theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local Divider = Make("Frame", {
        Name = "Divider",
        Parent = Main,
        BackgroundColor3 = theme.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 0, 1)
    })

    MakeDraggable(Topbar, Main)

    local Sidebar = Make("ScrollingFrame", {
        Name = "Sidebar",
        Parent = Main,
        Active = true,
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, 46),
        Size = UDim2.new(0, 140, 1, -50),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Accent
    })
    
    local SidebarLayout = Make("UIListLayout", {
        Parent = Sidebar,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local ContentContainer = Make("Frame", {
        Name = "ContentContainer",
        Parent = Main,
        BackgroundColor3 = theme.Container,
        Position = UDim2.new(0, 150, 0, 46),
        Size = UDim2.new(1, -156, 1, -52),
        ClipsDescendants = true
    })
    Make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = ContentContainer })

    -- Open/Close Logic
    UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == MogUI.ToggleKey and not processed then
            MogUI.Toggled = not MogUI.Toggled
            if MogUI.Toggled then
                Main.Visible = true
                Tween(Main, {Position = UDim2.new(0.5, -300, 0.5, -200), Size = UDim2.new(0, 600, 0, 400)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                Tween(Main.UIScale or Make("UIScale", {Parent=Main, Scale=0}), {Scale = 1}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            else
                local tween = Tween(Main, {Position = UDim2.new(0.5, -300, 0.5, -150)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                Tween(Main.UIScale, {Scale = 0.8}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                tween.Completed:Wait()
                Main.Visible = false
            end
        end
    end)
    
    -- Notification System
    local NotifContainer = Make("Frame", {
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -220, 1, -20),
        Size = UDim2.new(0, 200, 1, 0),
        AnchorPoint = Vector2.new(0, 1)
    })
    local NotifLayout = Make("UIListLayout", {
        Parent = NotifContainer,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    function library:Notify(text: string, duration: number?)
        duration = duration or 3
        local notif = Make("Frame", {
            Parent = NotifContainer,
            BackgroundColor3 = theme.Container,
            Size = UDim2.new(1, 40, 0, 40), -- start offset
            BackgroundTransparency = 1
        })
        Make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = notif })
        Make("UIStroke", { Color = theme.Accent, Thickness = 1, Parent = notif })
        local nText = Make("TextLabel", {
            Parent = notif,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Text = text,
            Font = Enum.Font.Gotham,
            TextColor3 = theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1
        })
        
        Tween(notif, {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Back)
        Tween(nText, {TextTransparency = 0}, 0.3)
        
        task.delay(duration, function()
            Tween(notif, {BackgroundTransparency = 1, Size = UDim2.new(1, 40, 0, 40)}, 0.4)
            local fade = Tween(nText, {TextTransparency = 1}, 0.4)
            fade.Completed:Wait()
            notif:Destroy()
        end)
    end

    local tabs = {}
    local activeTab = nil

    -- Create Tab Method
    function library:CreateTab(name: string)
        local tab = {Elements = {}}

        local TabButton = Make("TextButton", {
            Name = "TabBtn_" .. name,
            Parent = Sidebar,
            BackgroundColor3 = theme.Hover,
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Size = UDim2.new(1, -10, 0, 32),
            Font = Enum.Font.GothamMedium,
            Text = name,
            TextColor3 = theme.TextDark,
            TextSize = 14
        })
        Make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabButton })

        local Indicator = Make("Frame", {
            Parent = TabButton,
            BackgroundColor3 = theme.Accent,
            Position = UDim2.new(0, 0, 0.5, -8),
            Size = UDim2.new(0, 3, 0, 0), -- 0 size when inactive
            BorderSizePixel = 0
        })
        Make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Indicator })

        local ContentScroll = Make("ScrollingFrame", {
            Name = name .. "_Content",
            Parent = ContentContainer,
            Active = true,
            BackgroundColor3 = theme.Background,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = theme.Border,
            Visible = false
        })
        Make("UIListLayout", { Parent = ContentScroll, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
        Make("UIPadding", { Parent = ContentScroll, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })

        if not activeTab then
            activeTab = name
            ContentScroll.Visible = true
            TabButton.TextColor3 = theme.Text
            TabButton.BackgroundTransparency = 0.5
            Tween(Indicator, {Size = UDim2.new(0, 3, 0, 16)}, 0.3)
        end

        TabButton.MouseButton1Click:Connect(function()
            if activeTab == name then return end
            for _, t in pairs(tabs) do
                t.Content.Visible = false
                Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(t.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
                Tween(t.Button, {TextColor3 = theme.TextDark}, 0.2)
            end
            activeTab = name
            ContentScroll.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0.5}, 0.2)
            Tween(Indicator, {Size = UDim2.new(0, 3, 0, 16)}, 0.3, Enum.EasingStyle.Back)
            Tween(TabButton, {TextColor3 = theme.Text}, 0.2)
        end)

        tabs[name] = {Content = ContentScroll, Button = TabButton, Indicator = Indicator}

        -- ELEMENT PARSERS
        
        -- Create Button
        function tab:CreateButton(btnName: string, callback: function)
            local btnFrame = Make("Frame", {
                Parent = ContentScroll,
                BackgroundColor3 = theme.Container,
                Size = UDim2.new(1, -5, 0, 38)
            })
            Make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btnFrame })
            local stroke = Make("UIStroke", { Color = theme.Border, Thickness = 1, Parent = btnFrame })
            
            local btn = Make("TextButton", {
                Parent = btnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = btnName,
                TextColor3 = theme.Text,
                TextSize = 14
            })
            
            btn.MouseEnter:Connect(function()
                Tween(btnFrame, {BackgroundColor3 = theme.Hover}, 0.2)
                Tween(stroke, {Color = theme.Accent}, 0.2)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btnFrame, {BackgroundColor3 = theme.Container}, 0.2)
                Tween(stroke, {Color = theme.Border}, 0.2)
            end)
            btn.MouseButton1Down:Connect(function()
                Tween(btnFrame, {Size = UDim2.new(1, -15, 0, 34)}, 0.1)
            end)
            btn.MouseButton1Up:Connect(function()
                Tween(btnFrame, {Size = UDim2.new(1, -5, 0, 38)}, 0.1)
                pcall(callback)
            end)
        end

        -- Create Toggle
        function tab:CreateToggle(tglName: string, default: boolean, callback: function)
            local state = default or false
            local tglFrame = Make("Frame", { Parent = ContentScroll, BackgroundColor3 = theme.Container, Size = UDim2.new(1, -5, 0, 38) })
            Make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tglFrame })
            Make("UIStroke", { Color = theme.Border, Thickness = 1, Parent = tglFrame })
            
            Make("TextLabel", { Parent = tglFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -60, 1, 0), Font = Enum.Font.GothamMedium, Text = tglName, TextColor3 = theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
            
            local TglBg = Make("Frame", { Parent = tglFrame, BackgroundColor3 = state and theme.Accent or theme.Background, Position = UDim2.new(1, -45, 0.5, -10), Size = UDim2.new(0, 36, 0, 20) })
            Make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = TglBg })
            
            local Knob = Make("Frame", { Parent = TglBg, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(0, state and 18 or 2, 0.5, -8), Size = UDim2.new(0, 16, 0, 16) })
            Make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })
            
            local btn = Make("TextButton", { Parent = tglFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" })
            
            btn.MouseButton1Click:Connect(function()
                state = not state
                Tween(TglBg, {BackgroundColor3 = state and theme.Accent or theme.Background}, 0.2)
                Tween(Knob, {Position = UDim2.new(0, state and 18 or 2, 0.5, -8)}, 0.3, Enum.EasingStyle.Back)
                pcall(callback, state)
            end)
            -- Call initially
            task.spawn(callback, state)
        end

        -- Create Slider
        function tab:CreateSlider(sldName: string, min: number, max: number, default: number, callback: function)
            local value = default or min
            local sldFrame = Make("Frame", { Parent = ContentScroll, BackgroundColor3 = theme.Container, Size = UDim2.new(1, -5, 0, 50) })
            Make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = sldFrame })
            Make("UIStroke", { Color = theme.Border, Thickness = 1, Parent = sldFrame })
            
            Make("TextLabel", { Parent = sldFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20), Font = Enum.Font.GothamMedium, Text = sldName, TextColor3 = theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
            
            local ValueLabel = Make("TextLabel", { Parent = sldFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20), Font = Enum.Font.GothamMedium, Text = tostring(value), TextColor3 = theme.TextDark, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right })
            
            local TrackBg = Make("Frame", { Parent = sldFrame, BackgroundColor3 = theme.Background, Position = UDim2.new(0, 10, 0, 32), Size = UDim2.new(1, -20, 0, 6) })
            Make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = TrackBg })
            
            local Fill = Make("Frame", { Parent = TrackBg, BackgroundColor3 = theme.Accent, Size = UDim2.new((value - min) / (max - min), 0, 1, 0) })
            Make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
            
            local btn = Make("TextButton", { Parent = sldFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" })
            
            local dragging = false
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local p = math.clamp((input.Position.X - TrackBg.AbsolutePosition.X) / TrackBg.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + ((max - min) * p))
                    Tween(Fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05, Enum.EasingStyle.Linear)
                    ValueLabel.Text = tostring(value)
                    pcall(callback, value)
                end
            end)
            -- Call initially
            task.spawn(callback, value)
        end

        -- Create Dropdown
        function tab:CreateDropdown(drpName: string, options: table, callback: function)
            local drpFrame = Make("Frame", { Parent = ContentScroll, BackgroundColor3 = theme.Container, Size = UDim2.new(1, -5, 0, 38), ClipsDescendants = true })
            Make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = drpFrame })
            Make("UIStroke", { Color = theme.Border, Thickness = 1, Parent = drpFrame })
            
            local TopBtn = Make("TextButton", { Parent = drpFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38), Text = "" })
            local Title = Make("TextLabel", { Parent = TopBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -40, 1, 0), Font = Enum.Font.GothamMedium, Text = drpName .. " : ...", TextColor3 = theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
            
            local Arrow = Make("TextLabel", { Parent = TopBtn, BackgroundTransparency = 1, Position = UDim2.new(1, -25, 0, 0), Size = UDim2.new(0, 20, 1, 0), Font = Enum.Font.GothamBold, Text = "+", TextColor3 = theme.TextDark, TextSize = 18 })
            
            local ItemContainer = Make("Frame", { Parent = drpFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 5, 0, 38), Size = UDim2.new(1, -10, 1, -40) })
            local ItemLayout = Make("UIListLayout", { Parent = ItemContainer, Padding = UDim.new(0, 4) })
            
            local open = false
            TopBtn.MouseButton1Click:Connect(function()
                open = not open
                Tween(drpFrame, {Size = UDim2.new(1, -5, 0, open and (38 + (#options * 30) + 10) or 38)}, 0.3, Enum.EasingStyle.Quart)
                Arrow.Text = open and "-" or "+"
            end)
            
            for _, opt in ipairs(options) do
                local optBtn = Make("TextButton", { Parent = ItemContainer, BackgroundColor3 = theme.Background, Size = UDim2.new(1, 0, 0, 28), Font = Enum.Font.Gotham, Text = "  " .. opt, TextColor3 = theme.TextDark, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
                Make("UICorner", { CornerRadius = UDim.new(0, 4), Parent = optBtn })
                
                optBtn.MouseEnter:Connect(function() Tween(optBtn, {TextColor3 = theme.Accent}, 0.2) end)
                optBtn.MouseLeave:Connect(function() Tween(optBtn, {TextColor3 = theme.TextDark}, 0.2) end)
                
                optBtn.MouseButton1Click:Connect(function()
                    Title.Text = drpName .. " : " .. opt
                    open = false
                    Tween(drpFrame, {Size = UDim2.new(1, -5, 0, 38)}, 0.3)
                    Arrow.Text = "+"
                    pcall(callback, opt)
                end)
            end
        end

        -- Create Keybind
        function tab:CreateKeybind(kbName: string, defaultKey: Enum.KeyCode, callback: function)
            local key = defaultKey
            local kbFrame = Make("Frame", { Parent = ContentScroll, BackgroundColor3 = theme.Container, Size = UDim2.new(1, -5, 0, 38) })
            Make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = kbFrame })
            Make("UIStroke", { Color = theme.Border, Thickness = 1, Parent = kbFrame })
            
            Make("TextLabel", { Parent = kbFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -100, 1, 0), Font = Enum.Font.GothamMedium, Text = kbName, TextColor3 = theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
            
            local KeyBox = Make("TextButton", { Parent = kbFrame, BackgroundColor3 = theme.Background, Position = UDim2.new(1, -85, 0.5, -12), Size = UDim2.new(0, 75, 0, 24), Font = Enum.Font.Gotham, Text = key.Name, TextColor3 = theme.Accent, TextSize = 13 })
            Make("UICorner", { CornerRadius = UDim.new(0, 4), Parent = KeyBox })
            
            local binding = false
            KeyBox.MouseButton1Click:Connect(function()
                binding = true
                KeyBox.Text = "..."
                Tween(KeyBox, {BackgroundColor3 = theme.Hover}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    binding = false
                    key = input.KeyCode
                    KeyBox.Text = key.Name
                    Tween(KeyBox, {BackgroundColor3 = theme.Background}, 0.2)
                elseif not binding and input.KeyCode == key then
                    pcall(callback)
                end
            end)
        end

        -- Update scroll size dynamically
        ContentScroll.ChildAdded:Connect(function()
            local layout = ContentScroll:FindFirstChildOfClass("UIListLayout")
            if layout then
                ContentScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
            end
        end)

        return tab
    end

    -- Toggle setting keybind configuration
    function library:SetToggleKey(key: Enum.KeyCode)
        MogUI.ToggleKey = key
    end

    return library
end

return MogUI
