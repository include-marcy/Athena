-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);

-- Class Definition
--[=[
    @class athHost

    An athHost is the entry location of a new Athena project.
]=]
local athHost = {};
athHost.__index = athHost;

export type athHost = typeof(setmetatable({} :: {
    athClassName : "athHost";
    projectName : string;
}, {} :: typeof(athHost)));

--[=[
    @within athHost

    Creates a new athHost, the entry location of a new Athena project.

    @param athHostCreateInfo athTypes.athHostCreateInfo
    @return host athHost
]=]
function athHost.new(athHostCreateInfo : athTypes.athHostCreateInfo) : athHost
    local host = setmetatable({
        athClassName = "athHost";
    }, athHost);

    host.projectName = athHostCreateInfo.projectName;

    return host :: athHost;
end

return athHost;