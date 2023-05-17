
# ........................................................................ About
#
# @see README at https://github.com/HKdigital/docker-image--rendertron
#

# ......................................................................... FROM

FROM hkdigital/nodejs

MAINTAINER Jens Kleinhout "hello@hkdigital.nl"

# .......................................................................... ENV

# Update the timestamp below to force an apt-get update during build
ENV APT_SOURCES_REFRESHED_AT 2023-05-17_14h53

# ................................................................... Rendertron

# @see https://github.com/dockette/rendertron/blob/master/rendertron/Dockerfile

RUN apt update && \
    apt install -y wget gnupg2 && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get -y install google-chrome-stable libxss1


# @see https://googlechrome.github.io/rendertron/deploy.html

#RUN apt-get update \
#    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
#    && apt-get update \
#    && apt-get install -y \
#        google-chrome-stable \
#        fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst \
#        fonts-freefont-ttf libxss1 \
#        --no-install-recommends \
#    && rm -rf /var/lib/apt/lists/*

# This directory will store cached files as specified in the config.json.
# If you haven't defined the cacheConfig.snapshotDir property you can remove
# the following line

RUN mkdir /cache

#
# A copy of rendertron is already included in the image, so the following
# line is not needed
#
# RUN npx degit https://github.com/GoogleChrome/rendertron.git rendertron

# ............................................................ COPY /image-files

# Copy files and folders from project folder "/image-files" into the image
# - The folder structure will be maintained by COPY
#
# @note
#    No star in COPY command to keep directory structure
#    @see http://stackoverflow.com/
#        questions/30215830/dockerfile-copy-keep-subdirectory-structure

# Update the timestamp below to force copy of image-files during build
ENV IMAGE_FILES_REFRESHED_AT 2023-05-17_14h53

COPY ./image-files/ /

# ..................................................... Build rendertron project

#RUN npm --prefix /srv/rendertron install && \
#    npm --prefix /srv/rendertron run build && \
#    rm -Rf /tmp/* && \
#    rm -Rf /var/lib/apt/lists/*

RUN cd /srv/rendertron \
    && npm install \
    && npm run build

# ................................................................. EXPOSE PORTS

# @note the expose command does not publish the ports (documentation only)
EXPOSE 3000
