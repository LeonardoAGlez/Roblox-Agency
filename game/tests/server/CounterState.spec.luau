--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local server = ServerScriptService:WaitForChild("AgencyServer", 10)
assert(server, "AgencyServer missing after 10 seconds")
local module = server:WaitForChild("CounterState", 10)
assert(module and module:IsA("ModuleScript"), "CounterState missing after 10 seconds")
local CounterState = require(module)

return function()
	local state = CounterState.new()
	assert(state.count == 0, "new sessions start at zero")
	assert(CounterState.tryIncrement(state, { action = "increment" }, 0, 0.3), "first request accepted")
	assert(state.count == 1, "server adds exactly one")
	assert(not CounterState.tryIncrement(state, { action = "increment" }, 0.1, 0.3), "burst rejected")
	assert(state.count == 1, "rejection must not increment")
	assert(CounterState.tryIncrement(state, { action = "increment" }, 0.3, 0.3), "interval boundary accepted")

	local invalidPayloads: { unknown } =
		{ false, 100, "increment", {}, { action = "set" }, { action = "increment", count = 999 } }
	for _, payload in invalidPayloads do
		assert(not CounterState.tryIncrement(state, payload, 1, 0.3), "malformed payload rejected")
	end
	assert(not CounterState.tryIncrement(state, nil, 1, 0.3), "nil payload rejected")
	assert(state.count == 2, "malformed requests preserve count")
	assert(
		CounterState.tryIncrement(state, { action = "increment" }, 1, 0.3),
		"invalid payloads do not consume interval"
	)

	local secondPlayer = CounterState.new()
	assert(secondPlayer.count == 0, "players have isolated counts")
	assert(
		CounterState.tryIncrement(secondPlayer, { action = "increment" }, 1, 0.3),
		"players have isolated rate limits"
	)
	assert(state.count == 3 and secondPlayer.count == 1, "player state remains independent")
end
