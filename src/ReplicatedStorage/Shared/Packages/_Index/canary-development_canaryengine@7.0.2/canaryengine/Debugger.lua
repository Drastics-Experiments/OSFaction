-- // Package

local Debugger = {}

-- // Types

type CallStack = { Source: string, SourceTree: { Instance }, DefinedLine: number }

-- // Variables

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Runtime = require(script.Parent.Runtime)
local RuntimeSettings = Runtime.Settings

local LogPrefix = "[Log]"

-- // Functions

Debugger.SessionLogs = {} :: { string }

local function ReverseTable<T>(t: { [number]: T }): { [number]: T }
	local NewTable = {}

	for index, value in t do
		table.insert(NewTable, #t - index + 1, value)
	end

	return NewTable
end

local function GetAncestorsUntilParentFolder(instance: Instance): { Instance }
	local Ancestors = {}

	repeat
		instance = instance.Parent :: Instance
		table.insert(Ancestors, instance)
	until instance.Parent == game

	return ReverseTable(Ancestors)
end

function Debugger.GetCallStack(instance: LuaSourceContainer): CallStack
	assert(instance:IsA("LuaSourceContainer"), "Instance must be a lua source container")

	local StackFunction = debug.info(2, "n")

	return {
		Source = `{instance:GetFullName()}{if StackFunction and StackFunction ~= ""
			then string.format(" @ %s", StackFunction)
			else ""}`,
		SourceTree = GetAncestorsUntilParentFolder(instance),
		DefinedLine = debug.info(2, "l"),
	}
end

function Debugger.LogEvent(eventName: string, ...: any)
	table.insert(Debugger.SessionLogs, eventName)

	if not (RunService:IsStudio() and RuntimeSettings.ShowLoggedEvents) then
		return
	end

	print(LogPrefix, string.format(eventName, ...))
end

function Debugger.GenerateUUID()
	return string.gsub(HttpService:GenerateGUID(false), "-", "")
end

-- // Actions

return table.freeze(Debugger)