-- Help
local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))
local properprint = dofile("lib/properprint.lua")

local subcommands = misc.loadfolder("program/subcommands", {help = true})

local help = {}

--[[ Print help
]]--
function help.func(args)
	print("Syntax: ccpt")
	for i,v in pairs(subcommands) do
		if (not (v["comment"] == nil)) then
			properprint.pprint(i .. ": " .. v["comment"],5)
		end
	end
	print("")
	print("This package tool has Super Creeper Powers.")
end

help.comment = "Print help"

return help