-- Install
local autocomplete_helpers_subcommands = dofile(fs.combine(_G.ccpt.progdir, "program/autocomplete/autocomplete_helpers_subcommands.lua"))
local fileutils = dofile("lib/fileutils.lua")
local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))
local package = dofile(fs.combine(_G.ccpt.progdir, "program/package.lua"))
local properprint = dofile("lib/properprint.lua")
local statcounters = dofile(fs.combine(_G.ccpt.progdir, "program/statcounters.lua"))

local installtypes = misc.loadfolder("program/installtypes")

local install = {}

--[[ Recursive function to install Packages and dependencies
]]--
local function installpackage(packageid,packageinfo)
	properprint.pprint("Installing '" .. packageid .. "'...")
	-- Get Packageinfo
	if (packageinfo==nil) then
		print("Reading packageinfo of '" .. packageid .. "'...")
		packageinfo = package.getpackagedata(packageid)
		if packageinfo==false then
			return false
		end
	end
	
	-- Install dependencies
	properprint.pprint("Installing dependencies of '" .. packageid .. "', if there are any...")
	for k,v in pairs(packageinfo["dependencies"]) do
		local installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
		if installedpackages[k] == nil then
			if installpackage(k,nil)==false then
				return false
			end
		elseif installedpackages[k] < v then
			if upgradepackage(k,nil)==false then
				return false
			end
		end
	end
	
	-- Install package
	print("Installing '" .. packageid .. "'...")
	local installdata = packageinfo["install"]
	local result = installtypes[installdata["type"]]["install"](installdata)
	if result==false then
		return false
	end
	local installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
	installedpackages[packageid] = packageinfo["newestversion"]
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),installedpackages)
	print("'" .. packageid .. "' successfully installed!")
	statcounters.increasecounter("installed", 1)
end

--[[ Install a Package 
]]--
function install.func(args)
	if args[2] == nil then
		properprint.pprint("Incomplete command, missing: 'Package ID'; Syntax: 'ccpt install <PackageID>'")
		return
	end
	local packageinfo = package.getpackagedata(args[2])
	if packageinfo == false then
		return
	end
	if packageinfo["status"] == "installed" then
		properprint.pprint("Package '" .. args[2] .. "' is already installed.")
		return
	end
	-- Ok, all clear, lets get installing!
	local result = installpackage(args[2],packageinfo)
	if result==false then
		return
	end
	print("Install of '" .. args[2] .. "' complete!")
end

install.comment = "Install new Packages"
install.autocomplete = {
    func = autocomplete_helpers_subcommands.completepackageid,
    funcargs = {"not installed"}
}

return install