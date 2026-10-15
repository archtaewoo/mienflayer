--!strict
-- 운전 UI: W = 역행(가속), S = 제동, 아무 키도 안 누르면 타행

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage.Shared.Config)

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild(Config.RemoteName) :: RemoteEvent
local train = workspace:WaitForChild(Config.TrainName)

local gui = Instance.new("ScreenGui")
gui.Name = "TrainHUD"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 1)
frame.Position = UDim2.new(0.5, 0, 1, -20)
frame.Size = UDim2.fromOffset(320, 110)
frame.BackgroundColor3 = Color3.fromRGB(20, 24, 30)
frame.BackgroundTransparency = 0.2
frame.Parent = gui
Instance.new("UICorner").Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 50)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.GothamBold
label.TextSize = 28
label.Text = "0 km/h"
label.Parent = frame

local function makeButton(text: string, x: number, value: number)
	local button = Instance.new("TextButton")
	button.Size = UDim2.fromOffset(96, 40)
	button.Position = UDim2.fromOffset(x, 60)
	button.Text = text
	button.Font = Enum.Font.GothamMedium
	button.TextSize = 16
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundColor3 = Color3.fromRGB(50, 60, 75)
	button.Parent = frame
	Instance.new("UICorner").Parent = button
	button.Activated:Connect(function()
		remote:FireServer(value)
	end)
end

makeButton("제동 (S)", 10, -1)
makeButton("타행", 112, 0)
makeButton("역행 (W)", 214, 1)

local notchText = { [-1] = "제동", [0] = "타행", [1] = "역행" }
local function refresh()
	local kmh = train:GetAttribute("SpeedKmh") or 0
	local notch = train:GetAttribute("Notch") or 0
	label.Text = string.format("%d km/h  ·  %s", kmh, notchText[notch] or "")
end
train:GetAttributeChangedSignal("SpeedKmh"):Connect(refresh)
train:GetAttributeChangedSignal("Notch"):Connect(refresh)

local function currentNotch(): number
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		return -1
	elseif UserInputService:IsKeyDown(Enum.KeyCode.W) then
		return 1
	end
	return 0
end

local function onKey(input: InputObject, processed: boolean)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
		remote:FireServer(currentNotch())
	end
end
UserInputService.InputBegan:Connect(onKey)
UserInputService.InputEnded:Connect(onKey)

gui.Parent = player:WaitForChild("PlayerGui")
