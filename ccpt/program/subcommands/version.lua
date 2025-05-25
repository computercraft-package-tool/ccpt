-- Version
--[[ Print Version
]]--
function version(args)
	-- Print version
	properprint.pprint("ComputerCraft Package Tool")
	properprint.pprint("by PentagonLP")
	properprint.pprint("Version: 1.0")
end

_G.ccpt.subcommands.version = {
    func = version,
    comment = "Print CCPT Version"
}