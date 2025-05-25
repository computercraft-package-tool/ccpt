-- Uninstall
-- Remove installed Packages
function uninstall(args)
	-- Check input
	if args[2] == nil then
		properprint.pprint("Incomplete command, missing: 'Package ID'; Syntax: 'ccpt uninstall <PackageID>'")
		return
	end
	local packageinfo = getpackagedata(args[2])
	if packageinfo == false then
		return
	end
	if packageinfo["status"] == "not installed" then
		properprint.pprint("Package '" .. args[2] .. "' is not installed.")
		return
	end
	
	-- Check witch package(s) to remove (A package dependend on a package that's about to get removed is also removed)
	local packagestoremove = getpackagestoremove(args[2],packageinfo,fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true),{})
	local packagestoremovestring = ""
	for k,v in pairs(packagestoremove) do
		if not (k==args[2]) then
			packagestoremovestring = packagestoremovestring .. k .. " "
		end
	end
	
	-- Are you really really REALLY sure to remove these packages?
	if not (#packagestoremovestring==0) then
		properprint.pprint("There are installed packages that depend on the package you want to uninstall: " .. packagestoremovestring)
		properprint.pprint("These packages will be removed if you proceed. Are you sure you want to continue? [y/n]:")
		if ynchoice() == false then
			return
		end
	else
		properprint.pprint("There are no installed packages that depend on the package you want to uninstall.")
		properprint.pprint("'" .. args[2] .. "' will be removed if you proceed. Are you sure you want to continue? [y/n]:")
		if ynchoice() == false then
			return
		end
	end
	
	-- If cctp would be removed in the process, tell the user that that's a dump idea. But I mean, who am I to stop him, I guess...
	for k,v in pairs(packagestoremove) do
		if k=="ccpt" then
			if args[2] == "ccpt" then
				properprint.pprint("You are about to uninstall the package tool itself. You won't be able to install or uninstall stuff using the tool afterwords (obviously). Are you sure you want to continue? [y/n]:")
			else
				properprint.pprint("You are about to uninstall the package tool itself, because it depends one or more package that is removed. You won't be able to install or uninstall stuff using the tool afterwords (obviously). Are you sure you want to continue? [y/n]:")
			end
			
			if ynchoice() == false then
				return
			end
			break
		end
	end
	
	-- Uninstall package(s)
	for k,v in pairs(packagestoremove) do
		print("Uninstalling '" .. k .. "'...")
		local installdata = getpackagedata(k)["install"]
		local result = _G.ccpt.installtypes[installdata["type"]]["remove"](installdata)
		if result==false then
			return false
		end
		local installedpackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
		installedpackages[k] = nil
		fileutils.storeData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),installedpackages)
		print("'" .. k .. "' successfully uninstalled!")
		increasecounter("removed", 1)
	end
end

--[[ Recursive function to find all Packages that are dependend on the one we want to remove to also remove them
]]--
function getpackagestoremove(packageid,packageinfo,installedpackages,packagestoremove)
	packagestoremove[packageid] = true
	-- Get Packageinfo
	if (packageinfo==nil) then
		print("Reading packageinfo of '" .. packageid .. "'...")
		packageinfo = getpackagedata(packageid)
		if packageinfo==false then
			return false
		end
	end
	
	-- Check packages that are dependend on that said package
	for k,v in pairs(installedpackages) do
		if not (getpackagedata(k)["dependencies"][packageid]==nil) then
			local packagestoremovenew = getpackagestoremove(k,nil,installedpackages,packagestoremove)
			for l,w in pairs(packagestoremovenew) do
				packagestoremove[l] = true
			end
		end
	end
	
	return packagestoremove
end

_G.ccpt.subcommands.uninstall = {
    func = uninstall,
    comment = "Remove installed Packages"
}

_G.ccpt.autocomplete.next.uninstall = {
    func = completepackageid,
    funcargs = {"installed"}
}