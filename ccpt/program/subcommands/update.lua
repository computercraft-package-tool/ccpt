-- Update
local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))
local fileutils = dofile("lib/fileutils.lua")
local httputils = dofile("lib/httputils.lua")
local package = dofile(fs.combine(_G.ccpt.progdir, "program/package.lua"))
local properprint = dofile("lib/properprint.lua")

local update = {}

-- Link to a list of packages that are present by default (used in 'update.func()')
local defaultpackageurl = "https://github.com/computercraft-package-tool/ccpt/releases/download/v1.0/defaultpackages.ccpt"

--[[ Get packageinfo from the internet and search from updates
	@param boolean startup: Run with startup=true on computer startup; if startup=true it doesn't print as much to the console
]]--
function update.func(args, startup)
	startup = startup or false
	-- Fetch default Packages
	misc.bprint("Fetching Default Packages...", startup)
	local packages = httputils.gethttpdata(defaultpackageurl)["packages"]
	if packages==false then 
		return
	end

	-- Load custom packages
	misc.bprint("Reading Custom packages...", startup)
	local custompackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../custompackages"),true)
	-- Add Custom Packages to overall package list
	for k,v in pairs(custompackages) do
		packages[k] = v
	end
	
	-- Fetch package data from the diffrent websites
	local packagedata = {}
	for k,v in pairs(packages) do
		misc.bprint("Downloading package data of '" .. k .. "'...", startup)
		local packageinfo = httputils.gethttpdata(v)
		if not (packageinfo==false) then
			packagedata[k] = packageinfo
		else
			properprint.pprint("Failed to retrieve data about '" .. k .. "' via '" .. v .. "'. Skipping this package.")
		end
	end
	misc.bprint("Storing package data of all packages...",startup)
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../packagedata"), packagedata)

	-- Read installed packages
	misc.bprint("Reading Installed Packages...",startup)
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
	misc.bprint("Data update complete!",startup)
	
	-- Check for updates
	package.checkforupdates(installedpackagesnew, startup)
end

update.comment = "Search for new Versions & Packages"

return update