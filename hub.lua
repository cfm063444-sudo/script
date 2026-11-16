--[[
    j39z HUB (FULL: MENU CŨ + ESP XỊN + ANTI-BAN)
    Owner: @UnknownGuy9876 | Channel: @SGCodexs
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    ESP_Enabled = true,
    ESP_MaxDistance = 1000,
    Speed_Enabled = false,
    Speed_Value = 35
}

local ActiveESP = {}

-- ==========================================
-- GIAO DIỆN (MENU CŨ)
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

-- NÚT SPEED NGOÀI MÀN HÌNH
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
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
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
Title.Text = "j39z Hub | CĐVN"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14

local function CreateToggle(text, yPos, default, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = MainFrame
    Btn.Size = UDim2.new(1, -20, 0, 30)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = default and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    Btn.Text = text .. (default and " [ON]" or " [OFF]")
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 14
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
        Btn.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

CreateToggle("ESP (Box + Máu)", 40, Config.ESP_Enabled, function(v) Config.ESP_Enabled = v end)
CreateToggle("Speed (Anti-Ban)", 75, Config.Speed_Enabled, function(v) Config.Speed_Enabled = v end)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainFrame
SpeedLabel.Size = UDim2.new(1, -20, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 115)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Tốc độ: 35"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SliderBg = Instance.new("TextButton") 
SliderBg.Parent = MainFrame
SliderBg.Size = UDim2.new(1, -20, 0, 30)
SliderBg.Position = UDim2.new(0, 10, 0, 140)
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
Knob.Size = UDim2.new(0, 26, 0, 26)
Knob.Position = UDim2.new(0.2, -13, 0, 2)
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
            Knob.Position = UDim2.new(percent, -13, 0, 2)
            Config.Speed_Value = math.floor(16 + (percent * 84))
            SpeedLabel.Text = "Tốc độ: " .. Config.Speed_Value
        end
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSpeed = false end end)

-- Kéo thả 2 nút ngoài
local dragging1, dragInput1, dragStart1, startPos1
local dragging2, dragInput2, dragStart2, startPos2
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging1 = true; dragStart1 = input.Position; startPos1 = ToggleBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging1 = false end end)
    end
end)
ToggleBtn.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput1 = input end end)
SpeedToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging2 = true; dragStart2 = input.Position; startPos2 = SpeedToggleBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging2 = false end end)
    end
end)
SpeedToggleBtn.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput2 = input end end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput1 and dragging1 then
        local delta = input.Position - dragStart1
        ToggleBtn.Position = UDim2.new(startPos1.X.Scale, startPos1.X.Offset + delta.X, startPos1.Y.Scale, startPos1.Y.Offset + delta.Y)
    elseif input == dragInput2 and dragging2 then
        local delta = input.Position - dragStart2
        SpeedToggleBtn.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
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
end)

-- ==========================================
-- ESP LOGIC (BILLBOARD GUI)
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
    if ActiveESP[target] then
        ActiveESP[target]:Destroy()
        ActiveESP[target] = nil
    end
end

-- ==========================================
-- MAIN LOOP (ANTI-BAN SPEED + ESP)
-- ==========================================
RunService.RenderStepped:Connect(function(dt)
    -- SPEED ANTI-BAN LOGIC (ĐÃ GIẢM NHẸ)
    if Config.Speed_Enabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        if hrp and humanoid and humanoid.MoveDirection.Magnitude > 0 then
            -- 1. Ép WalkSpeed về 16
            humanoid.WalkSpeed = 16 
            
            -- 2. Hệ số nhân giảm xuống 1.2 để chạy chậm lại, không bị vọt
            local moveDir = humanoid.MoveDirection
            local shiftDistance = math.clamp(Config.Speed_Value, 16, 35) * dt * 1.2
            
            hrp.CFrame = hrp.CFrame + (moveDir * shiftDistance)
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= 16 then
                humanoid.WalkSpeed = 16
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
                    if not ActiveESP[player] or not ActiveESP[player].Parent then
                        CreateESP(player)
                    end
                    
                    local esp = ActiveESP[player]
                    if esp then
                        local hpPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                        local text = esp:FindFirstChild("Text")
                        local box = esp:FindFirstChild("Box")
                        
                        if text then 
                            text.Text = string.format("%s [%d%%]", player.Name, hpPercent) 
                        end
                        
                        if box then
                            if hpPercent > 50 then box.BorderColor3 = Color3.fromRGB(0, 255, 0)
                            elseif hpPercent > 20 then box.BorderColor3 = Color3.fromRGB(255, 255, 0)
                            else box.BorderColor3 = Color3.fromRGB(255, 0, 0) end
                        end
                    end
                else
                    RemoveESP(player)
                end
            else
                RemoveESP(player)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player) RemoveESP(player) end)
