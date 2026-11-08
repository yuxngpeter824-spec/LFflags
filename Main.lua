-- MAX PERFORMANCE V3
-- Delta / Roblox

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local enabled = false
local saved = {}
local frames = 0
local last = os.clock()

local gui = Instance.new("ScreenGui")
gui.Name = "MaxPerformanceV3"
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(230, 165)
main.Position = UDim2.new(0.5, -115, 0.35, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local function button(name, text, position, size)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Text = text
    b.Position = position
    b.Size = size
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 13
    b.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = b

    return b
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.BackgroundTransparency = 1
title.Text = "MAX PERFORMANCE V3"
title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.TextSize = 13
title.Parent = main

local minimise = button("Minimise", "-", UDim2.new(1, -35, 0, 3), UDim2.fromOffset(30, 25))

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 25)
status.Position = UDim2.fromOffset(5, 35)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1, 1, 1)
status.Text = "Performance: OFF"
status.Parent = main

local toggle = button("Toggle", "ENABLE BOOST", UDim2.fromOffset(10, 65), UDim2.new(1, -20, 0, 30))

local stats = Instance.new("TextLabel")
stats.Size = UDim2.new(1, -10, 0, 25)
stats.Position = UDim2.fromOffset(5, 105)
stats.BackgroundTransparency = 1
stats.TextColor3 = Color3.fromRGB(0, 255, 170)
stats.Text = "FPS: -- | Ping: --"
stats.Parent = main

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(55, 35)
reopen.Position = UDim2.new(0, 10, 0.5, 0)
reopen.Text = "OPEN"
reopen.Visible = false
reopen.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.Parent = gui

minimise.MouseButton1Click:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

local function optimise(obj)
    if saved[obj] ~= nil then return end

    if obj:IsA("PostEffect")
    or obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Smoke")
    or obj:IsA("Fire")
    or obj:IsA("Sparkles") then

        saved[obj] = obj.Enabled
        obj.Enabled = false

    elseif obj:IsA("BasePart") then
        saved[obj] = obj.CastShadow
        obj.CastShadow = false
    end
end

local function boost()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        optimise(obj)
    end

    for _, obj in ipairs(Lighting:GetDescendants()) do
        optimise(obj)
    end

    Lighting.GlobalShadows = false
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
end

local function restore()
    for obj, value in pairs(saved) do
        if obj and obj.Parent then
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.CastShadow = value
                else
                    obj.Enabled = value
                end
            end)
        end
    end

    table.clear(saved)
end

Workspace.DescendantAdded:Connect(function(obj)
    if enabled then
        optimise(obj)
    end
end)

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        boost()
        status.Text = "Performance: ON"
        toggle.Text = "DISABLE BOOST"
    else
        restore()
        status.Text = "Performance: OFF"
        toggle.Text = "ENABLE BOOST"
    end
end)

RunService.RenderStepped:Connect(function()
    frames += 1

    local now = os.clock()

    if now - last >= 1 then
        local fps = frames
        frames = 0
        last = now

        local ping = "--"

        pcall(function()
            ping = math.floor(
                Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            ) .. " ms"
        end)

        stats.Text = "FPS: " .. fps .. " | Ping: " .. ping
    end
end)

gui.Parent = player:WaitForChild("PlayerGui")
