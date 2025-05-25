--[[ Explode
]]--
function boom(args)
	print("|--------------|")
	print("| |-|      |-| |")
	print("|    |----|    |")
	print("|  |--------|  |")
	print("|  |--------|  |")
	print("|  |-      -|  |")
	print("|--------------|")
	print("....\"Have you exploded today?\"...")
end

_G.ccpt.subcommands.boom = {
    func = boom
}