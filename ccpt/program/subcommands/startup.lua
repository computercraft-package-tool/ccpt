-- Startup
--[[ Run on Startup
]]--
function startup(args)
	-- Update silently on startup
	update(args, true)
end

_G.ccpt.subcommands.startup = {
    func = startup
}