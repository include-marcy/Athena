local HttpService = game:GetService("HttpService")
-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);
local athUserStore = require(athena.classes.athUserStore);

local athPackagesUserStore = athUserStore.new({
    name = "athenaPackages";
})

-- Class Definition
local athPackage = {};
athPackage.__index = athPackage;

export type athPackage = typeof(setmetatable({} :: {
    identity : string;
}, {} :: typeof(athPackage)));

--[==[
    @class athPackage
    Creates a virtual Package, an identity pointing to some resource in the cloud which needs to be maintained.
    Usually, these are stored on something like GitHub.

    @param athPackageCreateInfo;
    @return athPackage
]==]
function athPackage.new(athPackageCreateInfo : athTypes.athPackageCreateInfo) : athPackage
    local package = setmetatable({}, athPackage);

    package.identity = athPackageCreateInfo.packageIdentity;

    return package;
end

--[==[
    @class athPackage

    Sets the package's identity, an HTTP url describing the resource this package is linked to.
]==]
function athPackage:athSetPackageIdentity(packageIdentity : string)
    local package : athPackage = self;

    package.identity = packageIdentity;
end

--[==[
    @class athPackage

    Loads the current package identity into the data model.
]==]
function athPackage:athLoadPackage()
    local package : athPackage = self;

    if package:athGetPackageInstance() then
        package:athUpdatePackageInstance();
    else
        package:athBuildPackageInstance();
    end
end

--[==[
    @class athPackage

    Returns the existing package associated with this package identity, if one is found.
]==]
function athPackage:athGetPackageInstance()
    local package : athPackage = self;
    local packageIdentity = package.identity;

    return athPackagesUserStore:athGetPersistentInstanceAsync(packageIdentity);
end

--[==[
    @class athPackage

    Returns a description, a set of instructions, that details to the package how to build the instance structure of this package.
]==]
function athPackage:athGetPackageDescription()
        local HttpService = game:GetService("HttpService");
        local function MAKE_DESCRIPTION_FROM_GITHUB(gitUser, gitRepoName)
            local request = `https://api.github.com/repos/{gitUser}/{gitRepoName}/contents`;

            local currentFolder = Instance.new("Folder");
            currentFolder.Parent = game.ReplicatedStorage;

            local function download(link)
                local httpPageSource = HttpService:GetAsync(link);
                local httpPage = HttpService:JSONDecode(httpPageSource);

                for _, httpObject in httpPage do
                    if httpObject.type == "dir" then
                        local newFolder = Instance.new("Folder")
                        newFolder.Name = httpObject.name;
                        newFolder.Parent = currentFolder;
                        currentFolder = newFolder;

                        download(httpObject.url);
                    elseif httpObject.type == "file" then
                        local name = httpObject.name;
                        local filedata = string.split(name, ".");

                        if #filedata < 2 then
                            continue
                        end

                        local filetype = filedata[#filedata];

                        if filetype ~= "lua" and filetype ~= "luau" then
                            continue;
                        end

                        local filename = "";
                        for i = 1, #filedata - 1 do
                            local str = filedata[i];
                            filename ..= str;
                        end

                        local download_url = httpObject.download_url;
                        local source = HttpService:GetAsync(download_url);

                        local scriptFile = Instance.new("ModuleScript");
                        scriptFile.Name = filename;
                        scriptFile.Source = source;

                        if filename == "init" and (filetype == "lua" or filetype == "luau") then
                            scriptFile.Parent = currentFolder.Parent;
                            scriptFile.Name = currentFolder.Name;

                            for i, v in currentFolder:GetChildren() do
                                v.Parent = scriptFile;
                            end
                            currentFolder:Destroy();
                            currentFolder = scriptFile;
                        else
                            scriptFile.Parent = currentFolder;
                        end
                    end
                end
            end

            download(request);
        end

        MAKE_DESCRIPTION_FROM_GITHUB("sleitnick", "RbxCameraShaker");
end

--[==[
    @class athPackage

    Returns the existing package associated with this package identity, if one is found.
]==]
function athPackage:athBuildPackageInstance()
    local package : athPackage = self;
    local packageIdentity = package.identity;

    local packageInstance = Instance.new("Folder");
    athPackagesUserStore:athSetPersistentInstanceAsync(packageIdentity, packageInstance);

    package:athUpdatePackageInstance();
end

--[==[
    @class athPackage

    Updates the existing package associated with this package identity.
]==]
function athPackage:athUpdatePackageInstance()
    local package : athPackage = self;
    local packageIdentity = package.identity;
    local packageDescription = package:athGetPackageDescription();
    local packageInstance = athPackagesUserStore:athGetPersistentInstanceAsync(packageIdentity);

    
end

return athPackage;