-- Roblox Services
local ReplicatedStorage = game:GetService("ReplicatedStorage");

-- Athena Dependencies
local ath = ReplicatedStorage.Athena.src;
local athTypes = require(ath.lib.athTypes);
local athLibrary = require(ath.classes.athLibrary);
local athExtension = require(ath.classes.athExtension);

-- Library Declaration
local library = script;
local demoLibraryCreateInfo : athTypes.athLibraryCreateInfo = {
    name = "demo";
};

local demoPackages = require(library["packages.ath"]);

-- Initialize the library:
local demoLibrary = athLibrary.new(demoLibraryCreateInfo);
-- Set the classes shortcut
demoLibrary:athSetClasses(library.classes);
-- Set the type module shortcut
demoLibrary:athSetProjectTypes(library.demoTypes);

-- Load the extension
local demoExtensionCreateInfo : athTypes.athExtensionCreateInfo = {
    name = "demo";
    icon = "rbxassetid://18624810014";
    description = "a demo tool.";
    gui = game.StarterGui.Frame;
};
local demoExtension = athExtension.new(demoExtensionCreateInfo);

demoExtension:athBindToExtensionLoaded(function()
    -- Load the library packages
    demoLibrary:athUpdatePackagesAsync(demoPackages);
end);
demoExtension:athBindToExtensionClosed(function()

end);

local demoExtensionWindowCreateInfo : athTypes.athExtensionWindowCreateInfo = {

};
demoExtension:athMakeWindow(demoExtensionWindowCreateInfo);