--[[ 
	Subcommand to fetch the packageinfo file from all known packages and cache the package data locally, in preperation of install/upgrade/uninstall

	Authors: PentagonLP 2021, 2025
	@module update
]]

-- Load module dependencies
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local help = _G.ccpt.loadmodule("subcommands/help")
local httputils = _G.ccpt.loadmodule("/lib/httputils")
local misc = _G.ccpt.loadmodule("misc")
local package = _G.ccpt.loadmodule("package")
local properprint = _G.ccpt.loadmodule("/lib/properprint")

-- Module interface table
local update = {}

-- ## START OF MODULE ##

-- Link to a list of packages that are present by default (used in 'update.func()')
local defaultpackageurl = "https://github.com/computercraft-package-tool/ccpt/releases/download/v1.0/defaultpackages.ccpt"

--[[ Get packageinfo from the internet and search from updates
	@tparam nil _ Placeholder argument where @ref{main} passes in the arguments of the 'ccpt' command, which are not needed in this function
	@tparam boolean startup Run with startup=true on computer startup; if startup=true it doesn't print as much to the console
]] --
function update.func(_, startup)
	startup = startup or false
	-- Fetch default Packages
	misc.bprint("Fetching Default Packages...", startup)
	local packages = httputils.gethttpdata(defaultpackageurl)["packages"]
	if packages == false then
		return
	end

	-- Load custom packages
	misc.bprint("Reading Custom packages...", startup)
	local custompackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "custompackages"), true)
	-- Add Custom Packages to overall package list
	for k, v in pairs(custompackages) do
		packages[k] = v
	end

	-- Fetch package data from the diffrent websites
	local packagedata = {}
	for k, v in pairs(packages) do
		misc.bprint("Downloading package data of '" .. k .. "'...", startup)
		local packageinfo = httputils.gethttpdata(v)
		if not (packageinfo == false) then
			packagedata[k] = packageinfo
		else
			properprint.pprint("Failed to retrieve data about '" .. k .. "' via '" .. v .. "'. Skipping this package.")
		end
	end
	misc.bprint("Storing package data of all packages...", startup)
	fileutils.storeData(fs.combine(_G.ccpt.progdir, "packagedata"), packagedata)

	-- Read installed packages
	misc.bprint("Reading Installed Packages...", startup)
	local installedpackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)
	local installedpackagesnew = {}
	for k, v in pairs(installedpackages) do
		if packagedata[k] == nil then
			properprint.pprint("Package '" .. k .. "' was removed from the packagelist, but is installed. It will no longer be marked as 'installed', but its files won't be deleted.")
		else
			installedpackagesnew[k] = v
		end
	end
	fileutils.storeData(fs.combine(_G.ccpt.progdir, "installedpackages"), installedpackagesnew)
	misc.bprint("Data update complete!", startup)

	-- Check for updates
	package.checkforupdates(installedpackagesnew, startup)
end

-- Register entry in the help page upon first module load
help.registerinfo("update", {
	comment = "Search for new Versions & Packages"
})

--[[ Allow autocompletion of the subcommand, but don't announce any further arguments by setting the autocompletion information to an empty table
]]
update.autocomplete = {}

-- ## END OF MODULE ##

return update
