--[[ 
	Subcommand to remove an URL to a custom packageinfo file

	Authors: PentagonLP 2021, 2025
	@module remove
]]

-- Load module dependencies
local autocomplete_helpers_subcommands = _G.ccpt.loadmodule("autocomplete/autocomplete_helpers_subcommands")
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local help = _G.ccpt.loadmodule("subcommands/help")
local misc = _G.ccpt.loadmodule("misc")
local properprint = _G.ccpt.loadmodule("/lib/properprint")
local update = _G.ccpt.loadmodule("subcommands/update")

-- Module interface table
local remove = {}

-- ## START OF MODULE ##

--[[ Remove a given custom-added package from the custom package list
	@tparam {string,...} args Array of all arguments of the 'ccpt'-command
]]
function remove.func(args)
	-- Check input
	if args[2] == nil then
		properprint.pprint("Incomplete command, missing: 'Package ID'; Syntax: 'ccpt remove <PackageID>'")
		return
	end
	local custompackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "custompackages"), true)
	if custompackages[args[2]] == nil then
		properprint.pprint("A custom package with the id '" .. args[2] .. "' does not exist!")
		return
	end

	-- Really wanna do that?
	properprint.pprint("Do you want to remove the custom package '" .. args[2] .. "'? There is no undo. [y/n]:")
	if not misc.ynchoice() then
		properprint.pprint("Canceled. No action was taken.")
		return
	end

	-- Remove entry from custompackages file
	custompackages[args[2]] = nil
	fileutils.storeData(fs.combine(_G.ccpt.progdir, "custompackages"), custompackages)
	properprint.pprint("Custom package successfully removed!")

	-- Update packagedata?
	properprint.pprint("Do you want to update the package data ('cctp update')? Your custom package will still be able to be installed/updated/uninstalled until updating. [y/n]:")
	if misc.ynchoice() then
		update.func()
	end
end

-- Register entry in the help page upon first module load
help.registerinfo("remove", {
	comment = "Remove Package URL from local list"
})

--[[ Allow autocompletion of the subcommand, specify first argument to be the ID of any custom-added packages
]]
remove.autocomplete = {
	func = autocomplete_helpers_subcommands.completecustompackageid,
	funcargs = {}
}

-- ## END OF MODULE ##

return remove
