-- Install
--[[ Install a Package 
]]--
function install(args)
	if args[2] == nil then
		properprint.pprint("Incomplete command, missing: 'Package ID'; Syntax: 'ccpt install <PackageID>'")
		return
	end
	local packageinfo = getpackagedata(args[2])
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

--[[ Recursive function to install Packages and dependencies
]]--
function installpackage(packageid,packageinfo)
	properprint.pprint("Installing '" .. packageid .. "'...")
	-- Get Packageinfo
	if (packageinfo==nil) then
		print("Reading packageinfo of '" .. packageid .. "'...")
		packageinfo = getpackagedata(packageid)
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
	local result = _G.ccpt.installtypes[installdata["type"]]["install"](installdata)
	if result==false then
		return false
	end
	local installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
	installedpackages[packageid] = packageinfo["newestversion"]
	fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),installedpackages)
	print("'" .. packageid .. "' successfully installed!")
	increasecounter("installed", 1)
end

_G.ccpt.subcommands.install = {
    func = install,
    comment = "Install new Packages"
}

_G.ccpt.autocomplete.next.install = {
    func = completepackageid,
    funcargs = {"not installed"}
}