-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services
local HttpService = game:GetService("HttpService");

-- Athena Dependencies
local athTypes = require(script.Parent.Parent.lib.athTypes);

-- Class Declaration
--[=[
	@class athConnection

	Represents a callback bound to a signal.
]=]
local athConnection = {};
athConnection.__index = athConnection;
export type athConnection = typeof(setmetatable({} :: {
	connectionId : string;
	signal : athSignal;
	callback : (any) -> (any);
	athClassName : "athSignal";
}, {} :: typeof(athConnection)))

--[=[
	@within athConnection

	Creates a new athConnection in the given signal, using the supplied callback.

	@param athConnectionCreateInfo athTypes.athConnectionCreateInfo
	@return connection athConnection
]=]
function athConnection.new(athConnectionCreateInfo : athTypes.athConnectionCreateInfo) : athConnection
	local connection = setmetatable({
		athClassName = "athSignal";
	}, athConnection);

	connection.signal = athConnectionCreateInfo.signal;
	connection.connectionId = HttpService:GenerateGUID(false);
	connection.callback = athConnectionCreateInfo.callback;

	local signal : athSignal = connection.signal;
	signal.payload[connection.connectionId] = connection;

	return connection;
end

--[=[
	@within athConnection

	Removes this athConnection from the athSignal it is tied to.
]=]
function athConnection:Disconnect()
	local connectionId = self.connectionId;
	local signal : athSignal = self.signal;

	signal.payload[connectionId] = nil;

	table.clear(self);
	setmetatable(self, nil);
end

-- Class Definition
--[=[
	@class athSignal
	athSignals are synchronization objects that allow for the connection of callbacks and the firing of their signal to execute all
	connected callbacks.
]=]
local athSignal = {};
athSignal.__index = athSignal;

export type athSignal = typeof(setmetatable({} :: {
	payload : {[string] : athConnection};
}, {} :: typeof(athSignal)));

--[=[
	@within athSignal
	Creates an athSignal, a synchronization object in Heimdall that allows for the connection of callbacks and the firing of the signal to execute all
	connected callbacks.

	@return athSignal
]=]
function athSignal.new() : athSignal
	local signal = setmetatable({}, athSignal);

	signal.payload = {};

	return signal;
end

--[=[
	@within athSignal
	Connects the provided callback to the athSignal, returning a clean-up object athConnection which can be used to remove the callback from the execution pool.

	@param func () -> ()
	@return athConnection
]=]
function athSignal:Connect(func : any) : athConnection
	local athConnectionCreateInfo : athTypes.athConnectionCreateInfo = {
		signal = self;
		callback = func;
	};
	local connection : athConnection = athConnection.new(athConnectionCreateInfo);

	return connection;
end

--[=[
	@within athSignal
	Wraps the function so that it will connect to this signal and execute its callback, before promptly disconnecting itself after 1 execution.

	@param func () -> ()
	@return athConnection
]=]
function athSignal:Once(func : any) : athConnection
	local signal : athSignal = self;
	local connection : athConnection; connection = signal:Connect(function()
		connection:Disconnect();
		func();
	end);

	return connection;
end

--[=[
	@within athSignal
	Fires the signal, causing all connected callbacks to execute once with the variadic arguments being passed on.

	@param ... any
	@return signal athSignal
]=]
function athSignal:Fire(...)
	local signal : athSignal = self;
	local payload = signal.payload;
	local arguments = {...};

	for _, connection in pairs(payload) do
		task.spawn(connection.callback, table.unpack(arguments));
	end
end

--[=[
	@within athSignal

	Destroys the signal and all connected athConnections.
]=]
function athSignal:Destroy()
	local signal : athSignal = self;
	local payload = signal.payload;

	for _, connection in pairs(payload) do
		connection:Disconnect();
	end

	table.clear(self);
	setmetatable(self, nil);
end

return athSignal;