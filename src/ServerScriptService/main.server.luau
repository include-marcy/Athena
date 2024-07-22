local athena = require(game.ReplicatedStorage.Athena)
local athTypes = require(game.ReplicatedStorage.Athena.src.lib.athTypes);
local athPackage = require(game.ReplicatedStorage.Athena.src.classes.athPackage);

local demoPackageCreateInfo : athTypes.athPackageCreateInfo = {
    packageIdentity = {
        packageCourier = "https://www.github.com/";
        packageShipper = "include-marcy";
        packageName = "Athena";
    };
    autoload = true;
    displayName = "myAthena";
};
local demoPackage = athPackage.new(demoPackageCreateInfo);