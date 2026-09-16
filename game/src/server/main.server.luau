--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Protocol = require(ReplicatedStorage:WaitForChild("AgencyShared"):WaitForChild("CounterProtocol"))
local CounterState = require(script.Parent.CounterState)
local states: { [Player]: CounterState.State } = {}

local remotes = Instance.new("Folder")
remotes.Name = Protocol.RemoteFolder

local increment = Instance.new("RemoteEvent")
increment.Name = Protocol.IncrementRemote
increment.Parent = remotes

local function addPlayer(player: Player)
	if states[player] then
		return
	end
	states[player] = CounterState.new()
	player:SetAttribute(Protocol.CountAttribute, 0)
end

Players.PlayerAdded:Connect(addPlayer)
Players.PlayerRemoving:Connect(function(player: Player)
	states[player] = nil
end)
for _, player in Players:GetPlayers() do
	addPlayer(player)
end

increment.OnServerEvent:Connect(function(player: Player, payload: unknown, ...: unknown)
	-- Reject unexpected positional arguments as well as malformed payloads.
	if select("#", ...) ~= 0 then
		return
	end
	local state = states[player]
	if state and CounterState.tryIncrement(state, payload, os.clock(), Protocol.MinimumInterval) then
		player:SetAttribute(Protocol.CountAttribute, state.count)
	end
end)

-- Publish the remote only after the handler and player state are ready.
remotes.Parent = ReplicatedStorage
