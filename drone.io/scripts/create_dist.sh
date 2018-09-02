#!bin/bash

# Outputs drone's configuration to a dist folder
#
# $DRONE_HOST: drone's domain name
# $DRONE_GITHUB_CLIENT: supplied by github's oauth
# $DRONE_GITHUB_SECRET: supplied by github's oauth
#

DRONE_HOST=$1
DRONE_GITHUB_CLIENT=$2
DRONE_GITHUB_SECRET=$3

if [[ -z "$DRONE_HOST" || -z "$DRONE_GITHUB_CLIENT" || -z "$DRONE_GITHUB_SECRET" ]]; then
    echo 'ERROR: MISSING DRONE_HOST OR DRONE_GITHUB_CLIENT OR DRONE_GITHUB_SECRET'
    exit 1
fi

# Move to workspace
ROOT="$( cd $( dirname $0 )/.. && pwd )"

# Create dist
mkdir -p $ROOT/dist

# Generate env files
source $ROOT/scripts/create_secret.sh

source $ROOT/scripts/create_agent_env.sh \
    $DRONE_HOST \
    $SECRET \
    $ROOT/dist/agent.env

source $ROOT/scripts/create_server_env.sh \
    $DRONE_HOST \
    $SECRET \
    $DRONE_GITHUB_CLIENT \
    $DRONE_GITHUB_SECRET \
    $ROOT/dist/server.env

# # Copy config files
cp $ROOT/config/docker-compose.yml $ROOT/dist/docker-compose.yml
cp $ROOT/config/drone.service $ROOT/dist/drone.service
