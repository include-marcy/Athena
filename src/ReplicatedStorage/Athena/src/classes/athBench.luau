-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- Roblox Services
local HttpService = game:GetService("HttpService");

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);

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

local athStopwatch = {};
athStopwatch.__index = athStopwatch;

export type athStopwatch = typeof(setmetatable({} :: {
    name : string;
    _clicked : boolean;
    _startTime : number;
    _elapsedTime : number;
    _stopTime : number?;
}, {} :: typeof(athStopwatch)));

function athStopwatch.new(athStopwatchCreateInfo) : athStopwatch
    local stopwatch = setmetatable({}, athStopwatch);

    stopwatch.name = athStopwatchCreateInfo.name;
    stopwatch._clicked = false;
    stopwatch._startTime = os.clock();
    stopwatch._elapsedTime = 0;

    return stopwatch;
end

function athStopwatch:athClick()
    local stopwatch : athStopwatch = self;

    if stopwatch._clicked then
        return;
    end

    stopwatch._clicked = true;
    stopwatch._stopTime = os.clock();
    stopwatch._elapsedTime = (stopwatch._stopTime - stopwatch._startTime);
end

function athStopwatch:athGetTime() : number
    local stopwatch : athStopwatch = self;

    return stopwatch._elapsedTime;
end

function athStopwatch:athGetState() : boolean
    local stopwatch : athStopwatch = self;

    return stopwatch._clicked;
end

function athStopwatch:athGetName() : string
    local stopwatch : athStopwatch = self;

    return stopwatch.name;
end

function athBench:athMakeStopwatch(name : string) : athStopwatch
    return athStopwatch.new({
        name = name;
    });
end

local athAuthor = {};
athAuthor.__index = athAuthor;

export type athAuthor = typeof(setmetatable({} :: {
    name : string;
    mode : "ATH_LOG_MODE_QUIET" | "ATH_LOG_MODE_LOUD" | "ATH_LOG_MODE_SILENT";
    _logLayers : {[number]: {
        transform : (string) -> (string);
    }};
    _biography : {[number]: string};
}, {} :: typeof(athAuthor)));

function athAuthor.new(athAuthorCreateInfo) : athAuthor
    local author = setmetatable({}, athAuthor);

    author.name = athAuthorCreateInfo.name;
    author.mode = athAuthorCreateInfo.mode;

    author._logLayers = {};
    author._biography = {};

    return author;
end

function athAuthor:athAddLogLayer(athLogLayerCreateInfo)
    local author : athAuthor = self;

    table.insert(author._logLayers, athLogLayerCreateInfo);
end

function athAuthor:athLog(message : string) : string
    local author : athAuthor = self;

    for _, logLayer in author._logLayers do
        local transform = logLayer.transform;
        if transform then
            message = transform(message);
        end
    end

    table.insert(author._biography, message);

    if author.mode == "ATH_LOG_MODE_LOUD" then
        warn(message);
    elseif author.mode == "ATH_LOG_MODE_QUIET" then
        print(message);
    elseif author.mode == "ATH_LOG_MODE_SILENT" then
        return;
    end

    return message;
end

function athBench:athMakeAuthor(name : string) : athAuthor
    local bench : athBench = self;
    local author = athAuthor.new({
        name = name;
    });

    bench._authors[name] = author;

    return author;
end

return athBench;