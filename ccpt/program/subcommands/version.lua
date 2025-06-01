-- Version
local help = _G.ccpt.loadmodule("subcommands/help")
local properprint = _G.ccpt.loadmodule("/lib/properprint")

local version = {}

--[[ Print Version
]]--
function version.func(args)
	-- Print version
	properprint.pprint("ComputerCraft Package Tool")
	properprint.pprint("by PentagonLP")
	properprint.pprint("Version: 1.0")
end

help.registerinfo("version", {
	comment = "Print CCPT Version"
})

version.autocomplete = {}

return version