-- Help
local properprint = _G.ccpt.loadmodule("/lib/properprint")

local help = {}

local helpinfo = {}

function help.registerinfo(subcommandname, infotable)
	helpinfo[subcommandname] = infotable
end

--[[ Print help
]]--
function help.func(args)
	print("Syntax: ccpt")
	for i,v in pairs(helpinfo) do
		if (not (v["comment"] == nil)) then
			properprint.pprint(i .. ": " .. v["comment"],5)
		end
	end
	print("")
	print("This package tool has Super Creeper Powers.")
end

help.registerinfo("help", {
	comment = "Print help"
})

help.autocomplete = {}

return help