--!strict

local RunService = game:GetService("RunService")
if not RunService:IsStudio() then
	warn("[AgencyIntegration] SKIPPED: tests only run in Studio")
	return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TIMEOUT = 10
local OBSERVATION_WINDOW = 1

local function waitForChild(parent: Instance, name: string): Instance
	local child = parent:WaitForChild(name, TIMEOUT)
	assert(child, string.format("[AgencyIntegration] FAIL: timed out waiting for %s.%s", parent.Name, name))
	return child
end

local function waitUntil(predicate: () -> boolean, message: string)
	local deadline = os.clock() + TIMEOUT
	repeat
		if predicate() then
			return
		end
		task.wait(0.05)
	until os.clock() >= deadline
	error("[AgencyIntegration] FAIL: " .. message)
end

local player = Players.LocalPlayer
local shared = waitForChild(ReplicatedStorage, "AgencyShared")
local protocolModule = waitForChild(shared, "CounterProtocol")
assert(protocolModule:IsA("ModuleScript"), "[AgencyIntegration] FAIL: protocol is not a module")
local Protocol = require(ReplicatedStorage.AgencyShared.CounterProtocol)
local remote = waitForChild(waitForChild(ReplicatedStorage, Protocol.RemoteFolder), Protocol.IncrementRemote)
assert(remote:IsA("RemoteEvent"), "[AgencyIntegration] FAIL: increment is not a RemoteEvent")
local gui = waitForChild(waitForChild(player, "PlayerGui"), "AgencyCounterUI")
local card = waitForChild(gui, "CounterCard")
local countLabel = waitForChild(card, "Count")
assert(countLabel:IsA("TextLabel"), "[AgencyIntegration] FAIL: Count is not a TextLabel")
local button = waitForChild(card, "IncrementButton")
assert(button:IsA("TextButton"), "[AgencyIntegration] FAIL: button is not a TextButton")

local function expectCount(expected: number)
	waitUntil(function()
		return player:GetAttribute(Protocol.CountAttribute) == expected and countLabel.Text == tostring(expected)
	end, string.format("replicated count and UI did not reach %d", expected))
end

local function expectStable(expected: number)
	local deadline = os.clock() + OBSERVATION_WINDOW
	repeat
		assert(
			player:GetAttribute(Protocol.CountAttribute) == expected,
			"[AgencyIntegration] FAIL: unexpected count change"
		)
		assert(countLabel.Text == tostring(expected), "[AgencyIntegration] FAIL: UI disagrees with replicated count")
		task.wait(0.05)
	until os.clock() >= deadline
end

expectCount(0)
local invalidPayloads: { unknown } =
	{ false, 100, "increment", {}, { action = "set" }, { action = "increment", count = 999 } }
for _, payload in invalidPayloads do
	remote:FireServer(payload)
end
remote:FireServer(nil)
remote:FireServer()
remote:FireServer({ action = Protocol.IncrementAction }, "unexpected")
remote:FireServer({ action = Protocol.IncrementAction }, nil)
expectStable(0)
print("[AgencyIntegration] PASS: invalid payloads and extra arguments preserve zero")

-- No yields: all requests enter the same burst, bypassing the UI's client cooldown.
for _ = 1, 20 do
	remote:FireServer({ action = Protocol.IncrementAction })
end
expectCount(1)
expectStable(1)
print("[AgencyIntegration] PASS: burst of 20 accepted exactly once; UI matches")

task.wait(Protocol.MinimumInterval + 0.1)
remote:FireServer({ action = Protocol.IncrementAction })
expectCount(2)
expectStable(2)
print("[AgencyIntegration] PASS: request after cooldown accepted; UI matches")
print("[AgencyIntegration] ALL PASSED; final count=2; ready for manual button click")
