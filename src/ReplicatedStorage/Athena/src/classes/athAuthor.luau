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

    table.insert(author._debugDump.biography, {
        author = author.name;
        message = message;
        timeStamp = os.time();
    });

    if author.mode == "ATH_LOG_MODE_LOUD" then
        warn(message);
    elseif author.mode == "ATH_LOG_MODE_QUIET" then
        print(message);
    elseif author.mode == "ATH_LOG_MODE_SILENT" then
        return;
    end

    return message;
end

return athAuthor;