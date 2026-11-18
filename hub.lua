--[[
    j39z ULTIMATE HUB (ESP + SPEED + AURA + TROLL TOOLS)
    Owner: @UnknownGuy9876 | Channel: @SGCodexs
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    ESP_Enabled = true,
    ESP_MaxDistance = 1000,
    Speed_Enabled = false,
    Speed_Value = 35,
    Aura_Enabled = false,
    Aura_Range = 20,
    
    -- Config cho Troll Tools
    NormalTele_Enabled = false,
    ChatSpam_Enabled = false,
    AutoRun_Enabled = false,
    SelectedPlayer = nil,
    SpamSpeed = 4,
    runAngle = 0
}

local ActiveESP = {}
local SpeedMenuBtn, SpeedMenuTxt

-- ==========================================
-- GIAO DIỆN CHÍNH (MENU HUB)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "j39zMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.Text = "j39z"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 14
ToggleBtn.BorderSizePixel = 0
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = ToggleBtn

local SpeedToggleBtn = Instance.new("TextButton")
SpeedToggleBtn.Parent = ScreenGui
SpeedToggleBtn.Size = UDim2.new(0, 50, 0, 50)
SpeedToggleBtn.Position = UDim2.new(0, 80, 0.5, -25)
SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
SpeedToggleBtn.Text = "⚡"
SpeedToggleBtn.TextColor3 = Color3.fromRGB(50, 50, 50)
SpeedToggleBtn.Font = Enum.Font.SourceSansBold
SpeedToggleBtn.TextSize = 22
SpeedToggleBtn.BorderSizePixel = 0
Instance.new("UICorner", SpeedToggleBtn).CornerRadius = UDim.new(1, 0)
local SpdStroke = Instance.new("UIStroke")
SpdStroke.Color = Color3.fromRGB(50, 50, 50)
SpdStroke.Thickness = 1.5
SpdStroke.Parent = SpeedToggleBtn

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 250, 0, 450) -- Tăng chiều cao để chứa đồ nghề
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Title.Text = "j39z Hub | ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14

local function CreateToggle(parent, text, yPos, default, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = parent
    Btn.Size = UDim2.new(1, -20, 0, 30)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = default and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    Btn.Text = text .. (default and " [ON]" or " [OFF]")
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
        Btn.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
        
        if text == "Speed (Slider)" then
            Config.Speed_Enabled = state
            if state then
                SpeedToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
                SpdStroke.Color = Color3.fromRGB(255, 255, 0)
                SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 0)
            else
                SpeedToggleBtn.TextColor3 = Color3.fromRGB(50, 50, 50)
                SpdStroke.Color = Color3.fromRGB(50, 50, 50)
                SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            end
        end
    end)
    return Btn
end

-- CÁC NÚT CỦA HUB CŨ
CreateToggle(MainFrame, "ESP (Box + Máu)", 40, Config.ESP_Enabled, function(v) Config.ESP_Enabled = v end)
SpeedMenuBtn = CreateToggle(MainFrame, "Speed (Slider)", 75, Config.Speed_Enabled, function(v) Config.Speed_Enabled = v end)
CreateToggle(MainFrame, "Aura Silent (Tự Chém)", 110, Config.Aura_Enabled, function(v) Config.Aura_Enabled = v end)

-- Slider Speed
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainFrame
SpeedLabel.Size = UDim2.new(1, -20, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 145)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Tốc độ: 35"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SliderBg = Instance.new("TextButton") 
SliderBg.Parent = MainFrame
SliderBg.Size = UDim2.new(1, -20, 0, 20)
SliderBg.Position = UDim2.new(0, 10, 0, 170)
SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SliderBg.Text = ""
SliderBg.BorderSizePixel = 0
SliderBg.AutoButtonColor = false
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(0, 6)

local Fill = Instance.new("Frame")
Fill.Parent = SliderBg
Fill.Size = UDim2.new(0.2, 0, 1, 0) 
Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Fill.BorderSizePixel = 0
Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 6)

local Knob = Instance.new("Frame")
Knob.Parent = SliderBg
Knob.Size = UDim2.new(0, 20, 0, 20)
Knob.Position = UDim2.new(0.2, -10, 0, 0)
Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Knob.BorderSizePixel = 0
Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

local draggingSpeed = false
SliderBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSpeed = true end end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if draggingSpeed then
            local percent = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            Knob.Position = UDim2.new(percent, -10, 0, 0)
            Config.Speed_Value = math.floor(16 + (percent * 84))
            SpeedLabel.Text = "Tốc độ: " .. Config.Speed_Value
        end
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSpeed = false end end)

-- ==========================================
-- PHẦN TROLL TOOLS (THÊM VÀO)
-- ==========================================

local SelectBtn = Instance.new("TextButton")
SelectBtn.Parent = MainFrame
SelectBtn.Size = UDim2.new(1, -20, 0, 30)
SelectBtn.Position = UDim2.new(0, 10, 0, 200)
SelectBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
SelectBtn.Text = "Chọn Người Chơi (Mục tiêu)"
SelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectBtn.Font = Enum.Font.SourceSansBold
SelectBtn.TextSize = 13
Instance.new("UICorner", SelectBtn).CornerRadius = UDim.new(0, 4)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -20, 0, 0)
ScrollFrame.Position = UDim2.new(0, 10, 0, 235)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ScrollFrame.Visible = false
ScrollFrame.ScrollBarThickness = 4
Instance.new("UICorner", ScrollFrame).CornerRadius = UDim.new(0, 4)
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame

SelectBtn.MouseButton1Click:Connect(function()
    if ScrollFrame.Visible then
        ScrollFrame.Visible = false
        ScrollFrame.Size = UDim2.new(1, -20, 0, 0)
    else
        for _, child in pairs(ScrollFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local pBtn = Instance.new("TextButton")
                pBtn.Parent = ScrollFrame
                pBtn.Size = UDim2.new(1, 0, 0, 25)
                pBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                pBtn.Text = player.Name
                pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                pBtn.MouseButton1Click:Connect(function()
                    Config.SelectedPlayer = player
                    SelectBtn.Text = "Mục tiêu: " .. player.Name
                    ScrollFrame.Visible = false
                    ScrollFrame.Size = UDim2.new(1, -20, 0, 0)
                end)
            end
        end
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 5)
        ScrollFrame.Visible = true
        ScrollFrame.Size = UDim2.new(1, -20, 0, 80)
    end
end)

local NormalBtn = CreateToggle(MainFrame, "Chaos Tele (Người)", 245, false, function(v) Config.NormalTele_Enabled = v end)
local RunBtn = CreateToggle(MainFrame, "Auto Run (Tự Chạy)", 280, false, function(v) Config.AutoRun_Enabled = v end)

-- Ô nhập chữ Spam
local SpamBox = Instance.new("TextBox")
SpamBox.Parent = MainFrame
SpamBox.Size = UDim2.new(1, -20, 0, 30)
SpamBox.Position = UDim2.new(0, 10, 0, 320)
SpamBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SpamBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamBox.PlaceholderText = "Nhập chữ để spam..."
SpamBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SpamBox.Text = "j39z"
SpamBox.Font = Enum.Font.SourceSans
SpamBox.TextSize = 13
SpamBox.BorderSizePixel = 0
Instance.new("UICorner", SpamBox).CornerRadius = UDim.new(0, 4)

local SpamBtn = CreateToggle(MainFrame, "Spam Chat (4s/lần)", 360, false, function(v) Config.ChatSpam_Enabled = v end)

-- Kéo thả Menu
local dragging
local dragInput
local dragStart
local startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
SpeedToggleBtn.MouseButton1Click:Connect(function()
    Config.Speed_Enabled = not Config.Speed_Enabled
    if Config.Speed_Enabled then
        SpeedToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
        SpdStroke.Color = Color3.fromRGB(255, 255, 0)
        SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 0)
    else
        SpeedToggleBtn.TextColor3 = Color3.fromRGB(50, 50, 50)
        SpdStroke.Color = Color3.fromRGB(50, 50, 50)
        SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    end
    if SpeedMenuBtn then
        SpeedMenuBtn.BackgroundColor3 = Config.Speed_Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
        SpeedMenuBtn.Text = "Speed (Slider)" .. (Config.Speed_Enabled and " [ON]" or " [OFF]")
    end
end)

-- ==========================================
-- ESP LOGIC
-- ==========================================
local function CreateESP(target)
    local char = target.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if ActiveESP[target] then ActiveESP[target]:Destroy() end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "j39zESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(3.5, 0, 4.5, 0) 
    billboard.StudsOffset = Vector3.new(0, 0, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.fromRGB(0, 255, 0)
    box.Parent = billboard
    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Size = UDim2.new(1, 0, 0, 20)
    text.Position = UDim2.new(0, 0, -0.15, 0) 
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeTransparency = 0
    text.TextSize = 12
    text.Font = Enum.Font.GothamBold
    text.Parent = billboard
    ActiveESP[target] = billboard
end
local function RemoveESP(target)
    if ActiveESP[target] then ActiveESP[target]:Destroy(); ActiveESP[target] = nil end
end

-- ==========================================
-- MAIN LOOP (SPEED + AURA + ESP + TELE)
-- ==========================================
task.spawn(function()
    while task.wait(Config.SpamSpeed) do
        if Config.ChatSpam_Enabled and SpamBox.Text ~= "" then
            pcall(function()
                if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    TextChatService.TextChannels.RBXGeneral:SendAsync(SpamBox.Text)
                else
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(SpamBox.Text, "All")
                end
            end)
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    -- SPEED
    if Config.Speed_Enabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hrp and humanoid and humanoid.MoveDirection.Magnitude > 0 then
            humanoid.WalkSpeed = 16 
            local shiftDistance = Config.Speed_Value * dt * 1.5 
            hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * shiftDistance)
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= 16 then humanoid.WalkSpeed = 16 end
        end
    end

    -- AUTO RUN
    if Config.AutoRun_Enabled and not Config.NormalTele_Enabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            Config.runAngle = Config.runAngle + (dt * 5)
            local targetPos = hrp.Position + Vector3.new(math.cos(Config.runAngle) * 15, 0, math.sin(Config.runAngle) * 15)
            hum:MoveTo(targetPos)
        end
    end

    -- TELE NGƯỜI
    if Config.SelectedPlayer and Config.SelectedPlayer.Character and Config.NormalTele_Enabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetHRP = Config.SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and targetHRP then
            local rx, ry, rz = math.random(-6, 6), math.random(-2, 8), math.random(-6, 6)
            local targetPos = targetHRP.Position + Vector3.new(rx, ry, rz)
            pcall(function()
                hrp.CFrame = CFrame.new(targetPos, targetHRP.Position)
                hrp.Velocity = Vector3.new(0,0,0)
                hrp.Size = Vector3.new(10, 10, 10) 
            end)
        end
    end

    -- AURA SILENT
    if Config.Aura_Enabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if hrp and tool and tool:FindFirstChild("Handle") then
            local params = OverlapParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {LocalPlayer.Character}
            local parts = workspace:GetPartBoundsInBox(hrp.CFrame, Vector3.new(Config.Aura_Range, Config.Aura_Range, Config.Aura_Range), params)
            for _, part in ipairs(parts) do
                local model = part:FindFirstAncestorOfClass("Model")
                local otherPlayer = model and Players:GetPlayerFromCharacter(model)
                if otherPlayer and otherPlayer ~= LocalPlayer then
                    local otherHum = otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid")
                    if otherHum and otherHum.Health > 0 then
                        if tool.Enabled then
                            pcall(function()
                                tool:Activate() 
                                tool.Handle.Touched:Fire(part) 
                            end)
                        end
                    end
                end
            end
        end
    end

    -- ESP LOGIC
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            
            if Config.ESP_Enabled and humanoid and humanoid.Health > 0 and hrp and head then
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                if dist <= Config.ESP_MaxDistance then
                    if not ActiveESP[player] or not ActiveESP[player].Parent then CreateESP(player) end
                    local esp = ActiveESP[player]
                    if esp then
                        local hpPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                        local text = esp:FindFirstChild("Text")
                        local box = esp:FindFirstChild("Box")
                        if text then text.Text = string.format("%s [%d%%]", player.Name, hpPercent) end
                        if box then
                            if hpPercent > 50 then box.BorderColor3 = Color3.fromRGB(0, 255, 0)
                            elseif hpPercent > 20 then box.BorderColor3 = Color3.fromRGB(255, 255, 0)
                            else box.BorderColor3 = Color3.fromRGB(255, 0, 0) end
                        end
                    end
                else RemoveESP(player) end
            else RemoveESP(player) end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player) RemoveESP(player) end)
