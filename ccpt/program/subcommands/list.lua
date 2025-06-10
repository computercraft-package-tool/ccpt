--[[ 
	Subcommand to list all packages known to CCPT, including their status

	Authors: PentagonLP 2021, 2025
	@module list
]]

-- Load module dependencies
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local help = _G.ccpt.loadmodule("subcommands/help")
local properprint = _G.ccpt.loadmodule("/lib/properprint")

-- Module interface table
local list = {}

-- ## START OF MODULE ##

--[[ Print a list of all known Packages
]]
function list.func()
	-- Read data
	print("Reading all packages data...")
	if not fs.exists(fs.combine(_G.ccpt.progdir, "packagedata")) then
		properprint.pprint("No Packages found. Please run 'cctp update' first.'")
		return
	end
	local packagedata = fileutils.readData(fs.combine(_G.ccpt.progdir, "packagedata"), true)
	print("Reading Installed packages...")
	local installedpackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)

	-- Print list
	properprint.pprint("List of all known Packages:")
	for k, v in pairs(installedpackages) do
		local updateinfo
		if packagedata[k]["newestversion"] > v then
			updateinfo = "outdated"
		else
			updateinfo = "up to date"
		end
		properprint.pprint(k .. " (installed, " .. updateinfo .. ")", 2)
	end
	for k, v in pairs(packagedata) do
		if installedpackages[k] == nil then
			properprint.pprint(k .. " (not installed)", 2)
		end
	end
end

-- Register entry in the help page upon first module load
help.registerinfo("list", {
	comment = "List installed and able to install Packages"
})

--[[ Allow autocompletion of the subcommand, but don't announce any further arguments by setting the autocompletion information to an empty table
]]
list.autocomplete = {}

-- ## END OF MODULE ##

return list
