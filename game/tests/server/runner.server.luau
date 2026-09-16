--!strict

local RunService = game:GetService("RunService")
if not RunService:IsStudio() then
	warn("[AgencyTests] SKIPPED: tests only run in Studio")
	return
end

local tests = 0
-- Explicit registration keeps module paths resolvable by the type checker.
local specs = {
	["CounterState.spec"] = require(script.Parent["CounterState.spec"]),
}
for _, child in script.Parent:GetChildren() do
	if child:IsA("ModuleScript") and string.match(child.Name, "%.spec$") then
		local ok, failure = pcall(function()
			local run = specs[child.Name]
			assert(run, "spec must be registered in runner: " .. child.Name)
			run()
		end)
		assert(ok, string.format("[AgencyTests] FAIL %s: %s", child.Name, tostring(failure)))
		tests += 1
		print(string.format("[AgencyTests] PASS %s", child.Name))
	end
end
assert(tests > 0, "[AgencyTests] FAIL: no specs discovered")
print(string.format("[AgencyTests] ALL PASSED (%d spec)", tests))
