--[[ 
	Subcommand to print the version information of CCPT

	Authors: PentagonLP 2021, 2025
	@module version
]]

-- Load module dependencies
local help = _G.ccpt.loadmodule("subcommands/help")
local properprint = _G.ccpt.loadmodule("/lib/properprint")

-- Module interface table
local version = {}

-- ## START OF MODULE ##

--[[ Print Version
]]
function version.func()
	-- Print version
	properprint.pprint("ComputerCraft Package Tool")
	properprint.pprint("by PentagonLP")
	properprint.pprint("Version: 1.0")
end

-- Register entry in the help page upon first module load
help.registerinfo("version", {
	comment = "Print CCPT Version"
})

--[[ Allow autocompletion of the subcommand, but don't announce any further arguments by setting the autocompletion information to an empty table
]]
version.autocomplete = {}

-- ## END OF MODULE ##

return version
