--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local Protocol = require(ReplicatedStorage:WaitForChild("AgencyShared"):WaitForChild("CounterProtocol"))
local increment =
	ReplicatedStorage:WaitForChild(Protocol.RemoteFolder):WaitForChild(Protocol.IncrementRemote) :: RemoteEvent

local screen = Instance.new("ScreenGui")
screen.Name = "AgencyCounterUI"
screen.ResetOnSpawn = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local card = Instance.new("Frame")
card.Name = "CounterCard"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.fromScale(0.5, 0.5)
card.Size = UDim2.new(0.9, 0, 0, 300)
card.BackgroundColor3 = Color3.fromRGB(18, 25, 42)
card.BorderSizePixel = 0
card.Parent = screen

local bounds = Instance.new("UISizeConstraint")
bounds.MaxSize = Vector2.new(440, 300)
bounds.Parent = card
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = card
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(63, 89, 121)
stroke.Parent = card

local function label(name: string, text: string, y: number, height: number, size: number, color: Color3): TextLabel
	local element = Instance.new("TextLabel")
	element.Name = name
	element.BackgroundTransparency = 1
	element.Position = UDim2.fromOffset(20, y)
	element.Size = UDim2.new(1, -40, 0, height)
	element.Font = Enum.Font.GothamMedium
	element.Text = text
	element.TextSize = size
	element.TextColor3 = color
	element.TextWrapped = true
	element.Parent = card
	return element
end

label("Title", "TU PRIMER IMPULSO", 24, 28, 20, Color3.fromRGB(222, 232, 247))
label("Subtitle", "Cada toque suma. ¡Vamos por uno más!", 56, 38, 15, Color3.fromRGB(157, 178, 206))
local countLabel = label("Count", "0", 98, 70, 56, Color3.fromRGB(103, 232, 205))
countLabel.Font = Enum.Font.GothamBold

local button = Instance.new("TextButton")
button.Name = "IncrementButton"
button.Position = UDim2.fromOffset(24, 192)
button.Size = UDim2.new(1, -48, 0, 56)
button.BackgroundColor3 = Color3.fromRGB(103, 232, 205)
button.TextColor3 = Color3.fromRGB(12, 36, 39)
button.Text = "+1  SUMAR IMPULSO"
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.BorderSizePixel = 0
button.Selectable = true
button.Parent = card
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = button
label("SessionNote", "Tu contador se reinicia al salir.", 260, 22, 12, Color3.fromRGB(157, 178, 206))

local function renderCount()
	local count = player:GetAttribute(Protocol.CountAttribute)
	countLabel.Text = tostring(if typeof(count) == "number" then count else 0)
end

player:GetAttributeChangedSignal(Protocol.CountAttribute):Connect(renderCount)
renderCount()

local lastRequestAt = -math.huge
button.Activated:Connect(function()
	local now = os.clock()
	if now - lastRequestAt < Protocol.MinimumInterval then
		return
	end
	lastRequestAt = now
	increment:FireServer({ action = Protocol.IncrementAction })
end)

screen.Parent = player:WaitForChild("PlayerGui")
