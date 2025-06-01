-- Startup
local update = _G.ccpt.loadmodule("subcommands/update")

local startup = {}

--[[ Run on Startup
]]--
function startup.func(args)
	-- Update silently on startup
	update.func(args, true)
end

return startup