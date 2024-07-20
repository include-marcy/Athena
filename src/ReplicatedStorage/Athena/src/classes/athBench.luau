-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- Roblox Services
local HttpService = game:GetService("HttpService");

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);
local athToken = require(athena.classes.athToken);
local athStopwatch = require(athena.classes.athStopwatch);
local athAuthor = require(athena.classes.athAuthor);

-- Class Declaration
local athBench = {};
athBench.__index = athBench;

export type athBench = typeof(setmetatable({} :: {
    _frequencyHookStates : {[string] : number};
    _authors : {[string] : athAuthor};
}, {} :: typeof(athBench)));

function athBench.new(athBenchCreateInfo : athTypes.athBenchCreateInfo) : athBench
    local bench = setmetatable({}, athBench);

    bench._frequencyHookStates = {};
    bench._authors = {};
    bench._debugDump = {
        profile = {};
        tokens = {};
        biography = {};
    };

    return bench;
end

function athBench:athNetworkUsage(payload : any, rate : number) : number
    -- return the data in kb/s
    local encoded = HttpService:JSONEncode(payload);

    return (#encoded) * rate;
end

function athBench:athMakeFrequencyHook(name : string, callback : () -> ()) : () -> ()
    local bench : athBench = self;
    local num = bench._frequencyHookStates[name] or 0;

    return function(...)
        num += 1;
        bench._frequencyHookStates[name] = num;
        callback(...);
    end
end

function athBench:athGetFrequency(name : string) : number
    local bench : athBench = self;
    local num = bench._frequencyHookStates[name] or 0;

    return num
end

function athBench:athMakeToken(name : string, value : any) : athToken.athToken
    local bench : athBench = self;

    local token = athToken.new({
        name = name;
        value = value;
    })

    bench._debugDump.tokens[name] = token;

    return token;
end

function athBench:athReadToken(name : string) : any
    local bench : athBench = self;

    local token : athToken.athToken? = bench._debugDump.tokens[name];
    if not token then
        return nil;
    end

    return token:athReadValue();
end

function athBench:athMakeStopwatch(name : string) : athStopwatch.athStopwatch
    return athStopwatch.new({
        name = name;
    });
end

function athBench:athMakeAuthor(name : string) : athAuthor.athAuthor
    local bench : athBench = self;
    local author = athAuthor.new({
        name = name;
    });

    bench._authors[name] = author;

    return author;
end

return athBench;