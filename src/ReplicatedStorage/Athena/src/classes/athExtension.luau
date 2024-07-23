-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);

-- Class Declaration
local athExtension = {};
athExtension.__index = athExtension;

export type athExtension = typeof(setmetatable({} :: {
    athClassName : "athExtension";
}, {} :: typeof(athExtension)));

--[==[
    @class athExtension

    Creates a new athExtension. athExtensions are a way to build portable, scalable Plugins for Roblox Studio.
    They are intended to simplify and abstract the process of building the internal workings of a plugin backend.
    They are also meant to be used to add new features to existing plugins.

    @param athExtensionCreateInfo;
    @return athExtension;
]==]
function athExtension.new(athExtensionCreateInfo : athTypes.athExtensionCreateInfo) : athExtension
    local extension = setmetatable({
        athClassName = "athExtension";
    }, athExtension);

    extension.name = athExtensionCreateInfo.name;

    return extension;
end

return athExtension;