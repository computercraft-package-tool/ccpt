-- Upgrade
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local help = _G.ccpt.loadmodule("subcommands/help")
local misc = _G.ccpt.loadmodule("misc")
local package = _G.ccpt.loadmodule("package")
local properprint = _G.ccpt.loadmodule("/lib/properprint")
local upgardeinstall = _G.ccpt.loadmodule("upgradeinstall")

local upgrade = {}

-- Upgrade installed Packages
-- TODO: Single package updates
function upgrade.func(args)
	local packageswithupdates = package.checkforupdates(fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true),false)
	if packageswithupdates==false then
		return
	end
	if #packageswithupdates==0 then
		return
	end
	properprint.pprint("Do you want to update these packages? [y/n]:")
	if not misc.ynchoice() then
		return
	end
	for k,v in pairs(packageswithupdates) do
		upgardeinstall.upgradepackage(v,nil)
	end
end

help.registerinfo("upgrade", {
	comment = "Upgrade installed Packages"
})

upgrade.autocomplete = {}

return upgrade