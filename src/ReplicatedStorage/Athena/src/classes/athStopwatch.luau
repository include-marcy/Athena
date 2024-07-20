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

return athStopwatch;