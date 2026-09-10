-- AdminUI.lua
-- Für dein eigenes Roblox-Spiel.
-- Hinweis: Ban/Kick/GiveItem sollten serverseitig über ein validiertes RemoteEvent ausgeführt werden.
-- Diese Datei stellt zunächst die UI und harmlose lokale Funktionen bereit.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Alte UI entfernen, falls das Script zweimal geladen wird
local old = PlayerGui:FindFirstChild("AdminUI")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "AdminUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(430, 320)
frame.Position = UDim2.new(0.5, -215, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.fromOffset(15, 5)
title.BackgroundTransparency = 1
title.Text = "Admin Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(35, 35)
close.Position = UDim2.new(1, -42, 0, 10)
close.Text = "X"
close.TextSize = 18
close.Font = Enum.Font.GothamBold
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(170, 55, 55)
close.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -30, 0, 30)
info.Position = UDim2.fromOffset(15, 50)
info.BackgroundTransparency = 1
info.Text = "Spieler: " .. #Players:GetPlayers()
info.TextColor3 = Color3.fromRGB(190, 190, 190)
info.TextSize = 15
info.Font = Enum.Font.Gotham
info.TextXAlignment = Enum.TextXAlignment.Left
info.Parent = frame

local function makeButton(text, x, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(190, 42)
    b.Position = UDim2.fromOffset(x, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Text = text
    b.TextSize = 16
    b.Font = Enum.Font.GothamMedium
    b.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b

    return b
end

local playersButton = makeButton("Spieler anzeigen", 15, 95)
local serverButton = makeButton("Server-Info", 220, 95)
local respawnButton = makeButton("Respawn", 15, 150)
local hideButton = makeButton("UI schließen", 220, 150)

local output = Instance.new("TextLabel")
output.Size = UDim2.new(1, -30, 0, 90)
output.Position = UDim2.fromOffset(15, 205)
output.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
output.TextColor3 = Color3.fromRGB(220, 220, 220)
output.TextSize = 14
output.Font = Enum.Font.Code
output.TextWrapped = true
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.Text = "Bereit."
output.Parent = frame

local outputCorner = Instance.new("UICorner")
outputCorner.CornerRadius = UDim.new(0, 8)
outputCorner.Parent = output

playersButton.MouseButton1Click:Connect(function()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(names, player.Name)
    end
    output.Text = "Spieler (" .. #names .. "):\n" .. table.concat(names, ", ")
end)

serverButton.MouseButton1Click:Connect(function()
    output.Text = "Server:\nPlaceId: " .. tostring(game.PlaceId)
        .. "\nJobId: " .. tostring(game.JobId)
        .. "\nSpieler: " .. #Players:GetPlayers()
end)

respawnButton.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
        output.Text = "Respawn ausgelöst."
    else
        output.Text = "Kein Humanoid gefunden."
    end
end)

hideButton.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

Players.PlayerAdded:Connect(function()
    info.Text = "Spieler: " .. #Players:GetPlayers()
end)

Players.PlayerRemoving:Connect(function()
    task.defer(function()
        info.Text = "Spieler: " .. #Players:GetPlayers()
    end)
end)

-- UI mit F4 wieder ein-/ausblenden
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F4 then
        gui.Enabled = not gui.Enabled
    end
end)

print("AdminUI geladen.")
