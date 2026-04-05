local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Sl1wed.lua',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- TABY
local Tabs = {
    ['.Lua'] = Window:AddTab('.Lua'),
    ['Settings'] = Window:AddTab('Settings'),
}

local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.BorderColor3 = Color3.fromRGB(255,255,255)
Frame.Visible = false
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Sl1wed.Lua"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = Frame

local PosLabel = Instance.new("TextLabel")
PosLabel.Size = UDim2.new(1, 0, 0, 25)
PosLabel.Position = UDim2.new(0, 0, 0, 30)
PosLabel.BackgroundTransparency = 1
PosLabel.TextColor3 = Color3.fromRGB(255,255,255)
PosLabel.Text = "0,0,0"
PosLabel.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 55)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255,255,255)
StatusLabel.Text = "X: OFF"
StatusLabel.Parent = Frame


local MainGroup = Tabs['.Lua']:AddLeftGroupbox('Main')

local BetterVD = MainGroup:AddToggle('BetterVD', {
    Text = 'Better VD',
    Default = false,
})

local Slider1 = MainGroup:AddSlider('SpamSpeed', {
    Text = 'SpamSpeed',
    Default = 100,
    Min = 100,
    Max = 1000,
    Rounding = 0,
})

local Slider2 = MainGroup:AddSlider('Position', {
    Text = 'Position',
    Default = 50,
    Min = 50,
    Max = 101,
    Rounding = 0,
})



local SlidersUnlocked = false

BetterVD:OnChanged(function(val)
    Frame.Visible = val
    SlidersUnlocked = false
    StatusLabel.Text = "X: OFF"
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.X then
        if BetterVD.Value and Frame.Visible then
            SlidersUnlocked = not SlidersUnlocked
            StatusLabel.Text = SlidersUnlocked and "X: ON" or "X: OFF"
        end
    end
end)


task.spawn(function()
    while true do
        task.wait(0.1)

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position

            local posValue = Slider2.Value
            local posText = posValue == 101 and "INF" or tostring(posValue)

            PosLabel.Text = string.format(
                "X: %.0f Y: %.0f Z: %.0f | %s",
                pos.X, pos.Y, pos.Z, posText
            )
        end
    end
end)



task.spawn(function()
    local t = 0
    local currentDistance = 50000
    local targetDistance = 50000

    while true do
        task.wait(0.03)

        if not BetterVD.Value or not SlidersUnlocked then
            continue
        end

        local char = LocalPlayer.Character
        if not char then continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local val = Slider2.Value

        
        if val == 101 then
            targetDistance = math.random(10000000000, 51000000000) -- 10B → 51B
        else
            local base = val * 1000
            targetDistance = base + math.random(0, 9000)
        end

        
        currentDistance = currentDistance + (targetDistance - currentDistance) * 0.05

        
        local speed = Slider1.Value / 1000
        t = t + speed

       
        local x = math.cos(t) * currentDistance
        local y = math.sin(t * 0.7) * (currentDistance / 2)
        local z = math.sin(t) * currentDistance

        hrp.CFrame = CFrame.new(x, y, z)
    end
end)


Slider1:OnChanged(function(val)
    if not BetterVD.Value or not SlidersUnlocked then return end
end)

Slider2:OnChanged(function(val)
    if not BetterVD.Value or not SlidersUnlocked then return end
end)

-- SETTINGS
local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu keybind'
})

Library.ToggleKeybind = Options.MenuKeybind

-- MANAGERY
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('Sl1wed')
SaveManager:SetFolder('Sl1wed/configs')

-- CONFIG + THEME w Settings
SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])

SaveManager:LoadAutoloadConfig()
message.txt
