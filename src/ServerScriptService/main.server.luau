local ReplicatedStorage = game:GetService("ReplicatedStorage")

local athena = ReplicatedStorage.Athena.src;
local athTypes = require(athena.lib.athTypes);
local athPackage = require(athena.classes.athPackage);

local demoPackageCreateInfo : athTypes.athPackageCreateInfo = {
    packageIdentity = {
        packageCourier = "https://www.github.com/";
        packageShipper = "include-marcy";
        packageName = "Athena";
    };
    autoload = false;
    displayName = "myAthena";
};
local demoPackage = athPackage.new(demoPackageCreateInfo);
demoPackage:athLoadPackageAsync();