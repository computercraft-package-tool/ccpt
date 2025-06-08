--[[ 
	Subcommand called upon startup to initialize CCPT

	Authors: PentagonLP 2021, 2025
	@module startup
]]

-- Load module dependencies
local update = _G.ccpt.loadmodule("subcommands/update")

-- Module interface table
local startup = {}

-- ## START OF MODULE ##

--[[ Initialize CCPT on startup, run a silent 'ccpt update' in order to avoid console spam
	@tparam {string,...} args Array of all arguments of the 'ccpt'-command
]]
function startup.func(args)
	-- Update silently on startup
	update.func(args, true)
end

-- ## END OF MODULE ##

return startup
