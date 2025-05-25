-- Help
--[[ Print help
]]--
function help(args)
	print("Syntax: ccpt")
	for i,v in pairs(_G.ccpt.subcommands) do
		if (not (v["comment"] == nil)) then
			properprint.pprint(i .. ": " .. v["comment"],5)
		end
	end
	print("")
	print("This package tool has Super Creeper Powers.")
end

_G.ccpt.subcommands.help = {
    func = help,
    comment = "Print help"
}