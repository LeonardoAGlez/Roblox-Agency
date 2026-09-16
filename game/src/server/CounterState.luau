--!strict

export type State = {
	count: number,
	lastAcceptedAt: number,
}

local CounterState = {}

function CounterState.new(): State
	return { count = 0, lastAcceptedAt = -math.huge }
end

-- The client can request an action; only this module chooses the resulting value.
function CounterState.tryIncrement(state: State, payload: unknown, now: number, minimumInterval: number): boolean
	if type(payload) ~= "table" then
		return false
	end
	local fields = payload :: { [unknown]: unknown }
	if fields.action ~= "increment" then
		return false
	end
	for key in fields do
		if key ~= "action" then
			return false
		end
	end
	if now - state.lastAcceptedAt < minimumInterval then
		return false
	end
	state.lastAcceptedAt = now
	state.count += 1
	return true
end

return table.freeze(CounterState)
