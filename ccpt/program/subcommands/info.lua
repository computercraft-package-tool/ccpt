--[[ 
	Subcommand get information about a single package

	Authors: PentagonLP 2021, 2025
	@module info
]]

-- Load module dependencies
local autocomplete_helpers_subcommands = _G.ccpt.loadmodule("autocomplete/autocomplete_helpers_subcommands")
local help = _G.ccpt.loadmodule("subcommands/help")
local installtypes = _G.ccpt.loadmodule("installtypes")
local package = _G.ccpt.loadmodule("package")
local properprint = _G.ccpt.loadmodule("/lib/properprint")

-- Module interface table
local info = {}

-- ## START OF MODULE ##

--[[ Print information about a package
	@tparam {string,...} args Array of all arguments of the 'ccpt'-command
]] --
function info.func(args)
	-- Check input
	if args[2] == nil then
		properprint.pprint("Incomplete command, missing: 'Package ID'; Syntax: 'ccpt info <PackageID>'")
		return
	end

	-- Get packagedata
	local packageinfo = package.getpackagedata(args[2])
	if packageinfo == false then
		return
	end

	-- Print packagedata
	properprint.pprint(packageinfo["name"] .. " by " .. packageinfo["author"])
	properprint.pprint(packageinfo["comment"])
	if not (packageinfo["website"] == nil) then
		properprint.pprint("Website: " .. packageinfo["website"])
	end
	properprint.pprint("Installation Type: " .. installtypes[packageinfo["install"]["type"]]["desc"])
	if packageinfo["status"] == "installed" then
		properprint.pprint("Installed, Version: " .. packageinfo["installedversion"] .. "; Newest Version is " .. packageinfo["newestversion"])
	else
		properprint.pprint("Not installed; Newest Version is " .. packageinfo["newestversion"])
	end
end

-- Register entry in the help page upon first module load
help.registerinfo("info", {
	comment = "Information about a package"
})

--[[ Allow autocompletion of the subcommand, specify first argument to be the ID of any known package
]]
info.autocomplete = {
	func = autocomplete_helpers_subcommands.completepackageid,
	funcargs = {}
}

-- ## END OF MODULE ##

return info
