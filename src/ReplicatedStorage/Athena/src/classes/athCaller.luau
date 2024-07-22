-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);
local athUtils = require(athena.lib.athUtils);

-- Class Definition
local athCaller = {};
athCaller.__index = athCaller;

export type athCaller = typeof(setmetatable({} :: {
    athClassName : "athCaller";
}, {} :: typeof(athCaller)));

function athCaller.new(athCallerCreateInfo : athTypes.athCallerCreateInfo) : athCaller
    local caller = setmetatable({
        athClassName = "athCaller";
    }, athCaller);

    return caller;
end

function athCaller:athFoo()

end

return athCaller;