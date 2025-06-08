--[[ 
	ComputerCraft Package Tool main file

	Authors: PentagonLP 2021, 2025
]]

-- Initialize global ccpt namespace
_G.ccpt = {}
-- Set program directory
_G.ccpt.progdir = fs.combine(fs.getDir(shell.getRunningProgram()), "../")
-- Init submodule loader
_G.ccpt.loadmodule = dofile(fs.combine(_G.ccpt.progdir, "program/moduleloader.lua")).loadmodule
-- Pass shell onto submodules
_G.ccpt.shell = shell

-- Load module dependencies
local autocomplete = _G.ccpt.loadmodule("autocomplete/autocomplete")
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")
local misc = _G.ccpt.loadmodule("misc")
local properprint = _G.ccpt.loadmodule("/lib/properprint")
local statcounters = _G.ccpt.loadmodule("statcounters")
local subcommands = _G.ccpt.loadmodule("subcommands")

-- Read arguments
local args = { ... }

-- Add to working path
local workingpathentry = ":" .. fs.combine(_G.ccpt.progdir, "program/shell")
if string.find(shell.path(), misc.regexEscape(workingpathentry)) == nil then
	shell.setPath(shell.path() .. workingpathentry)
end

-- Register autocomplete function
shell.setCompletionFunction(fs.combine(_G.ccpt.progdir, "program/shell/ccpt"), autocomplete.tabcomplete)

-- Add to startup file to run at startup
local startup = fileutils.readFile("startup", "") or ""
if string.find(startup, "shell.run(\"" .. shell.getRunningProgram() .. "\",\"startup\")", 1, true) == nil then
	startup = "-- ccpt: Search for updates\nshell.run(\"" ..
	shell.getRunningProgram() .. "\",\"startup\")\n\n" .. startup
	fileutils.storeFile("startup", startup)
	print("[Installer] Startup entry created!")
end

-- Call required function
if #args == 0 then
	properprint.pprint("Incomplete command, missing: 'Action'; Type 'ccpt help' for syntax.")
else
	if subcommands[args[1]] == nil then
		properprint.pprint("Action '" .. args[1] .. "' is unknown. Type 'ccpt help' for syntax.")
	else
		subcommands[args[1]]["func"](args)
	end
end

-- List stats of operations in this run
statcounters.printcounters()
