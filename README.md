
# About

The image generated by this project can be used as to run a 
GoogleChrome / rendertron server.

# Usage

## Just try it out (using docker-compose)

Below an example of using the image in a docker-compose file.

In the `/examples` folder, you'll find a `docker-file` for an example setup.

```yaml
version: "3"

services:
  rendertron:
    image: hkdigital/rendertron   # docker-hub
    # image: hkdigital-rendertron   # local
    
    restart: always

    environment:
      # 
      # @see configuration section in README for all supported parameters
      # 
      
      # Width and height used by Googlebot Smartphone (2022-05-25): 412x732
      - rendertron_width=412
      - rendertron_height=732

```



# Rendertron configuration parameters

See the [configuration instructions in the official Renderton docs](https://github.com/GoogleChrome/rendertron#config). 
Below you can find the mapping to the ENV variables

| JSON config variable name        | Env variable                    | Type                |
|----------------------------------|---------------------------------|---------------------|
| timeout                          | rendertron_timeout              | number              |
| width                            | rendertron_width                | number              |
| height                           | rendertron_height               | number              |
| reqHeaders                       | rendertron_reqHeaders           | Stringified JSON    |
| cache                            | rendertron_cache                | boolean             |
| cacheConfig.cacheDurationMinutes | rendertron_cacheDurationMinutes | number              |
| cacheConfig.cacheMaxEntries      | rendertron_cacheMaxEntries      | number              |
| cacheConfig.snapshotDir          | rendertron_snapshotDir          | string              |
| renderOnly                       | rendertron_renderOnly           | Stringified JSON    |
| closeBrowser                     | rendertron_closeBrowser         | boolean             |
| restrictedUrlPattern             | rendertron_restrictedUrlPattern | string              |

# Build locally

Clone the latest commit from github into a local working directory

```bash
git clone --depth 1 \
  git@github.com:hkdigital/docker-images--rendertron.git \
  hkdigital-rendertron
```

Build the docker image

```bash
./build-latest-image.sh
```