-- Startup
local update = dofile(fs.combine(_G.ccpt.progdir, "program/subcommands/update.lua"))

local startup = {}

--[[ Run on Startup
]]--
function startup.func(args)
	-- Update silently on startup
	update.func(args, true)
end

return startup