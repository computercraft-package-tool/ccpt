--[[ 
	Subcommand to print the CCPT help page

	Authors: PentagonLP 2021, 2025
	@module help
]]

-- Load module dependencies
local properprint = _G.ccpt.loadmodule("/lib/properprint")

-- Module interface table
local help = {}

-- ## START OF MODULE ##

--[[ Table to store registered help info for the different subcommands
	@table helpinfo
	@field <subcommandname> subcommand_helpinfo Table containing information on what to display on the help page for the specific subcommand
	@table subcommand_helpinfo
	@field comment string Help information to be printed for the specific subcommand
]]
local helpinfo = {}

--[[ Add information abount a subcommand to the help page
	@tparam string subcommandname The name of the subcommand
	@tparam subcommand_helpinfo Table containing information on what to display on the help page for the specific subcommand
]]
function help.registerinfo(subcommandname, infotable)
	helpinfo[subcommandname] = infotable
end

--[[ Print the help page
]]
function help.func()
	print("Syntax: ccpt")
	for i, v in pairs(helpinfo) do
		if (not (v["comment"] == nil)) then
			properprint.pprint(i .. ": " .. v["comment"], 5)
		end
	end
	print("")
	print("This package tool has Super Creeper Powers.")
end

-- Register entry in the help page upon first module load
help.registerinfo("help", {
	comment = "Print help"
})

--[[ Allow autocompletion of the subcommand, but don't announce any further arguments by setting the autocompletion information to an empty table
]]
help.autocomplete = {}

-- ## END OF MODULE ##

return help
