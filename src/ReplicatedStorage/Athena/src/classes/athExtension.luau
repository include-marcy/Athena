-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);
local athSignal = require(athena.classes.athSignal);
local athTrove = require(athena.packages.trove);

-- Class Declaration
local athExtension = {};
athExtension.__index = athExtension;

export type athExtension = typeof(setmetatable({} :: {
    athClassName : "athExtension";
    athExtensionName : string;
    athExtensionIcon : string;
    athExtensionLoaded : athSignal.athSignal;
    athExtensionClosed : athSignal.athSignal;
    _loaded : boolean?;
    _closed : boolean?;
    trove : athTrove.athTrove;
    _boundCallbacks : {
        [number] : {
            callbackType : "ATH_EXT_CALLBACK_TYPE_LOADED" | ";ATH_EXT_CALLBACK_TYPE_CLOSED";
            callback : () -> ();
        };
    };
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
        athExtensionLoaded = athSignal.new();
        athExtensionClosed = athSignal.new();
    }, athExtension);

    extension.athExtensionName = athExtensionCreateInfo.name;
    extension.athExtensionIcon = athExtensionCreateInfo.icon;

    extension._boundCallbacks = {}
    extension.trove = athTrove.new();

    extension.trove:Add(extension.athExtensionLoaded:Connect(function()
        if extension._loaded then
            return;
        end

        extension._loaded = true;

        for _, cb in extension._boundCallbacks do
            if cb.callbackType == "ATH_EXT_CALLBACK_TYPE_LOADED" then
                task.spawn(cb.callback);
            end
        end
    end));

    extension.trove:Add(extension.athExtensionLoaded:Connect(function()
        if extension._closed then
            return;
        end

        extension._closed = true;

        for _, cb in extension._boundCallbacks do
            if cb.callbackType == "ATH_EXT_CALLBACK_TYPE_CLOSED" then
                task.spawn(cb.callback);
            end
        end
    end));

    return extension;
end

--[==[
    @class athExtension

    Loads the athExtension, with the following actions being loaded:
    - Populates the toolbar with this extension's buttons.
    - Loads the code of this athExtension's main function.
    - Fires the loaded event
    - Allows it to be closed
]==]
function athExtension:athLoadExtension()
    local extension : athExtension = self;
    if extension._loaded then
        return;
    end

    extension.athExtensionLoaded:Fire();
end

function athExtension:athMakeWindow(athExtensionWindowCreateInfo : athTypes.athExtensionWindowCreateInfo)

end

function athExtension:athBindToExtensionLoaded(callback : () -> ())
    local extension : athExtension = self;

    if extension._loaded then
        return callback();
    end

    table.insert(extension._boundCallbacks, {
        callbackType = "ATH_EXT_CALLBACK_TYPE_LOADED";
        callback = callback;
    });
end

function athExtension:athBindToExtensionClosed(callback : () -> ())
    local extension : athExtension = self;

    if extension._closed then
        return callback();
    end

    table.insert(extension._boundCallbacks, {
        callbackType = "ATH_EXT_CALLBACK_TYPE_CLOSED";
        callback = callback;
    });
end

function athExtension:athCloseExtension()
    local extension : athExtension = self;
    if extension._closed then
        return;
    end

    extension.athExtensionClosed:Fire();

    extension.trove:Destroy();
    extension.trove = nil;
    table.clear(extension);
    setmetatable(extension, nil);
    extension = nil;
end

return athExtension;