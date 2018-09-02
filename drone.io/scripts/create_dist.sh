#!bin/bash

# Outputs drone's configuration to a dist folder
#
# $DRONE_HOST: drone's domain name
# $DRONE_GITHUB_CLIENT: supplied by github's oauth
# $DRONE_GITHUB_SECRET: supplied by github's oauth
#

set -eo pipefail

DRONE_HOST=$1
DRONE_GITHUB_CLIENT=$2
DRONE_GITHUB_SECRET=$3

if [[ -z "$DRONE_HOST" || -z "$DRONE_GITHUB_CLIENT" || -z "$DRONE_GITHUB_SECRET" ]]; then
    echo 'ERROR: MISSING DRONE_HOST OR DRONE_GITHUB_CLIENT OR DRONE_GITHUB_SECRET'
    exit 1
fi

# Create working space
mkdir -p dist

# Generate env files
source scripts/create_secret.sh
source scripts/create_agent_env.sh \
    $DRONE_HOST \
    $SECRET \
    dist/agent.env
source scripts/create_server_env.sh \
    $DRONE_HOST \
    $SECRET \
    $DRONE_GITHUB_CLIENT \
    $DRONE_GITHUB_SECRET \
    dist/server.env

# Copy config files
cp config/docker-compose.yml dist/docker-compose.yml
cp config/drone.service dist/drone.service
