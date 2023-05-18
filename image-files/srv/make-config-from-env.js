//
// Original source of this file copied from
// https://github.com/arodik/docker-rendertron
//

/* ------------------------------------------------------------------ Imports */

const fs = require("fs");

/* ---------------------------------------------------------------- Constants */

const CONFIG_FILE_PATH = "/srv/rendertron/config.json";
const ENV_PREFIX = 'rendertron_';

/* ---------------------------------------------------------------- Internals */

const Bool = value => value === 'true';
const StringifiedJSON = value => JSON.parse(value);
const Identity = value => value;
const TransformIdentity = (config, name, value) => config[name] = value;
const TransformCacheConfig = (config, name, value) => {
    config.cacheConfig = config.cacheConfig || {};
    config.cacheConfig[name] = value;
}

const configVars = {
    timeout: {
        type: Number,
    },
    width: {
        type: Number,
    },
    height: {
        type: Number,
    },
    cache: {
        type: String,
    },
    closeBrowser: {
        type: Bool,
    },
    restrictedUrlPattern: {
        type: String,
    },
    cacheDurationMinutes: {
        type: Number,
        transform: TransformCacheConfig,
    },
    cacheMaxEntries: {
        type: Number,
        transform: TransformCacheConfig,
    },
    snapshotDir: {
        type: String,
        transform: TransformCacheConfig,
    },
    reqHeaders: {
        type: StringifiedJSON,
    },
    renderOnly: {
        type: StringifiedJSON,
    }
};

/* ---------------------------------------------------- Process ENV variables */

const rendertronConfig = {};

Object.keys(configVars).forEach( ( envVarName ) =>
{
    const castToType = configVars[ envVarName ].type || Identity;

    const addConfigValue =
        configVars[envVarName].transform || TransformIdentity;

    const envKey = ENV_PREFIX + envVarName;

    const envValue = process.env[ envKey ];

    if( envValue !== undefined )
    {
      const castedValue = castToType( envValue );
      addConfigValue( rendertronConfig, envVarName, castedValue );
    }
} );

/* -------------------------------------------------------- Write config file */

const configString = JSON.stringify(rendertronConfig, null, 2);

fs.writeFileSync( CONFIG_FILE_PATH, configString);
