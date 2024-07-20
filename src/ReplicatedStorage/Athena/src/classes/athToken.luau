-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);

-- Class Definition
local athToken = {};
athToken.__index = athToken;

export type athToken = typeof(setmetatable({} :: {
    value : any;
}, {} :: typeof(athToken)));

function athToken.new(athTokenCreateInfo : athTypes.athTokenCreateInfo) : athToken
    local token = setmetatable({}, athToken);

    token.value = athTokenCreateInfo.value;

    table.freeze(token);

    return token;
end

function athToken:athReadValue()
    local token : athToken = self;

    return token.value;
end

return athToken;