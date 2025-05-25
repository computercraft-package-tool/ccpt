-- Update
dofile(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../package.lua"))

-- Link to a list of packages that are present by default (used in 'update()')
local defaultpackageurl = "https://github.com/computercraft-package-tool/ccpt/releases/download/v1.0/defaultpackages.ccpt"

--[[ Get packageinfo from the internet and search from updates
	@param boolean startup: Run with startup=true on computer startup; if startup=true it doesn't print as much to the console
]]--
function update(args, startup)
	startup = startup or false
	-- Fetch default Packages
	bprint("Fetching Default Packages...", startup)
	local packages = httputils.gethttpdata(defaultpackageurl)["packages"]
	if defaultpackages==false then 
		return
	end
	-- Load custom packages
	bprint("Reading Custom packages...", startup)
	local custompackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../custompackages"),true)
	-- Add Custom Packages to overall package list
	for k,v in pairs(custompackages) do
		packages[k] = v
	end
	
	-- Fetch package data from the diffrent websites
	local packagedata = {}
	for k,v in pairs(packages) do
		bprint("Downloading package data of '" .. k .. "'...", startup)
		local packageinfo = httputils.gethttpdata(v)
		if not (packageinfo==false) then
			packagedata[k] = packageinfo
		else
			properprint.pprint("Failed to retrieve data about '" .. k .. "' via '" .. v .. "'. Skipping this package.")
		end
	end
	bprint("Storing package data of all packages...",startup)
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../packagedata"), packagedata)
	-- Read installed packages
	bprint("Reading Installed Packages...",startup)
	local installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
	local installedpackagesnew = {}
	for k,v in pairs(installedpackages) do
		if packagedata[k]==nil then
			properprint.pprint("Package '" .. k .. "' was removed from the packagelist, but is installed. It will no longer be marked as 'installed', but its files won't be deleted.")
		else
			installedpackagesnew[k] = v
		end
	end
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),installedpackagesnew)
	bprint("Data update complete!",startup)
	
	-- Check for updates
	checkforupdates(installedpackagesnew, startup)
end

_G.ccpt.subcommands.update = {
    func = update,
    comment = "Search for new Versions & Packages"
};