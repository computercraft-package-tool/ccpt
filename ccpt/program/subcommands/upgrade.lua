--[[ 
	Subcommand to upgrade all installed packages

	Authors: PentagonLP 2021, 2025
	@module upgrade
]]

-- Load module dependencies
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local help = _G.ccpt.loadmodule("subcommands/help")
local misc = _G.ccpt.loadmodule("misc")
local package = _G.ccpt.loadmodule("package")
local properprint = _G.ccpt.loadmodule("/lib/properprint")
local upgardeinstall = _G.ccpt.loadmodule("upgradeinstall")

-- Module interface table
local upgrade = {}

-- ## START OF MODULE ##

--[[ Upgrade all installed Packages
]]
-- TODO: Single package updates
function upgrade.func()
	local packageswithupdates = package.checkforupdates(
	fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true), false)
	if packageswithupdates == false then
		return
	end
	if #packageswithupdates == 0 then
		return
	end
	properprint.pprint("Do you want to update these packages? [y/n]:")
	if not misc.ynchoice() then
		return
	end
	for _, v in pairs(packageswithupdates) do
		upgardeinstall.upgradepackage(v, nil)
	end
end

-- Register entry in the help page upon first module load
help.registerinfo("upgrade", {
	comment = "Upgrade installed Packages"
})

--[[ Allow autocompletion of the subcommand, but don't announce any further arguments by setting the autocompletion information to an empty table
]]
upgrade.autocomplete = {}

-- ## END OF MODULE ##

return upgrade
