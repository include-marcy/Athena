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

local demoLibrary = athLibrary.new(demoLibraryCreateInfo);
demoLibrary:athSetClasses(library.classes);
demoLibrary:athSetProjectTypes(library.demoTypes);

local demoExtensionCreateInfo : athTypes.athExtensionCreateInfo = {
    name = "demo";
};
local demoExtension = athExtension.new(demoExtensionCreateInfo);

local demoExtensionWindowCreateInfo : athTypes.athExtensionWindowCreateInfo = {

};
demoExtension:athMakeWindow(demoExtensionWindowCreateInfo);