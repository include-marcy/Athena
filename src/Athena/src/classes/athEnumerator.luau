-- This file is a part of the Athena library. Athena is licensed under the terms of the MIT License. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local athTypes = require(script.Parent.Parent.lib.athTypes);

-- Class Definition
--[=[
	@class athEnumerator

	The athEnumerator class is designed to easily create a list of enums for your library or plugin, for use within the context of that library or plugin by programmers outside the list of maintainers or even within them as well.
]=]
local athEnumerator = {};
athEnumerator.__index = athEnumerator;

-- Type Definition
export type athEnumerator = typeof(setmetatable({} :: {
	athClassName : "athEnumerator";
}, {} :: typeof(athEnumerator)))

--[=[
	@within athEnumerator

	The athEnumerator class is designed to easily create a list of enums for your library or plugin, for use within the context of that library or plugin by programmers outside the list of maintainers or even within them as well.

	@param athEnumeratorCreateInfo heraTypes.athEnumeratorCreateInfo
	@return athEnumerator
]=]
function athEnumerator.new(athEnumeratorCreateInfo : athTypes.athEnumeratorCreateInfo) : athEnumerator
	local class = setmetatable({}, athEnumerator);
	class.athClassName = "athEnumerator";
	class.name = athEnumeratorCreateInfo.name;

	return class;
end

return athEnumerator;