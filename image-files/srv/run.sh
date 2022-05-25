#!/bin/bash

#
# @note
#   This script should be set as "CMD" of "ENTRY_POINT" in your Dockerfile
#
# @note
#   dumb-init is already specified in the Dockerfile as ENTRYPOINT
#   Otherwise use: #!/usr/bin/dumb-init /bin/bash
#

NODE_CMD="node"

echo
echo "Running [run.sh] from image [hkdigital/rendertron]"
echo "- $(date)"

echo
echo "Setup nodejs user"

# .................................................................. NodeJS User

USER="nodejs"
id "${USER}" &> /dev/null || useradd "${USER}"

usermod -u 1000 "${USER}"
groupmod -g 1001 "${USER}"

passwd -d "${USER}"

# ...................................................... Set project root folder

PROJECT_FOLDER="/srv/rendertron"

# ........................................ Convert ENV parameters to config.json

sudo -E "${NODE_CMD}" "make-config-from-env.js"

# .................................................................. NodeJS User

cd /srv/rendertron

#
# sudo -E -> keep most environment variables
# sudo -u ${USER} -> execute as the specified user
#

sudo -E -u "${USER}" "${NODE_CMD}" "build/rendertron.js"
