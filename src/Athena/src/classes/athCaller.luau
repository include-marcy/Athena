-- This file is a part of the Athena library. Athena is licensed under the terms of the GNU General Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local athTypes = require(script.Parent.Parent.lib.athTypes);

-- Class Definition
--[=[
	@class athCaller

	The athCaller class is designed to run safe methods within the Athena environment.
]=]
local athCaller = {};
athCaller.__index = athCaller;

-- Type Definition
export type athCaller = typeof(setmetatable({} :: {
	heraClassName : "athCaller";
}, {} :: typeof(athCaller)))

--[=[
	@within athCaller

	The athCaller class is designed to run safe methods within the Athena environment.

	@param athCallerCreateInfo athTypes.athCallerCreateInfo
	@return athCaller
]=]
function athCaller.new(athCallerCreateInfo : athTypes.athCallerCreateInfo) : athCaller
	local class = setmetatable({}, athCaller);
	class.heraClassName = "athCaller";
	class.name = athCallerCreateInfo.name;

	return class;
end

--[=[
	@within athCaller

]=]
function athCaller:heraFoo()

end

return athCaller;