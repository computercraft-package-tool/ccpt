-- Install
local autocomplete_helpers_subcommands = _G.ccpt.loadmodule("autocomplete/autocomplete_helpers_subcommands")
local help = _G.ccpt.loadmodule("subcommands/help")
local package = _G.ccpt.loadmodule("package")
local properprint = _G.ccpt.loadmodule("/lib/properprint")
local upgardeinstall = _G.ccpt.loadmodule("upgradeinstall")

local install = {}

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
	local result = upgardeinstall.installpackage(args[2],packageinfo)
	if result==false then
		return
	end
	print("Install of '" .. args[2] .. "' complete!")
end

help.registerinfo("install", {
	comment = "Install new Packages"
})

install.autocomplete = {
    func = autocomplete_helpers_subcommands.completepackageid,
    funcargs = {"not installed"}
}

return install