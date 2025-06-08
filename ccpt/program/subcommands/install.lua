--[[ 
	Subcommand to install a package

	Authors: PentagonLP 2021, 2025
	@module install
]]

-- Load module dependencies
local autocomplete_helpers_subcommands = _G.ccpt.loadmodule("autocomplete/autocomplete_helpers_subcommands")
local help = _G.ccpt.loadmodule("subcommands/help")
local package = _G.ccpt.loadmodule("package")
local properprint = _G.ccpt.loadmodule("/lib/properprint")
local upgardeinstall = _G.ccpt.loadmodule("upgradeinstall")

-- Module interface table
local install = {}

-- ## START OF MODULE ##

--[[ Install a Package
	@tparam {string,...} args Array of all arguments of the 'ccpt'-command
]]
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
	local result = upgardeinstall.installpackage(args[2], packageinfo)
	if result == false then
		return
	end
	print("Install of '" .. args[2] .. "' complete!")
end

-- Register entry in the help page upon first module load
help.registerinfo("install", {
	comment = "Install new Packages"
})

--[[ Allow autocompletion of the subcommand, specify first argument to be the ID of any known, but not yet installed package
]]
install.autocomplete = {
	func = autocomplete_helpers_subcommands.completepackageid,
	funcargs = { "not installed" }
}

-- ## END OF MODULE ##

return install
