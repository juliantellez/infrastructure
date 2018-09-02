#!bin/bash

# Copies dist/ files to /etc/drone/
#
# $DRONE_HOST: drone's domain name
# $DRONE_GITHUB_CLIENT: supplied by github's oauth
# $DRONE_GITHUB_SECRET: supplied by github's oauth
#

set -eo pipefail

DRONE_HOST=$1
DRONE_GITHUB_CLIENT=$2
DRONE_GITHUB_SECRET=$3

# Move to  workspace
ROOT="$( cd $( dirname $0 )/.. && pwd )"

echo "Creating dist files ..."
source $ROOT/scripts/create_dist.sh \
    $DRONE_HOST \
    $DRONE_GITHUB_CLIENT \
    $DRONE_GITHUB_SECRET

echo "Copying dist to /etc/drone ..."
sudo mkdir -p /etc/drone/
sudo cp -R $ROOT/dist/ /etc/drone/

if [ "$(uname)" == "Linux" ]; then
    echo "Copying Systemd service ..."
    sudo cp dist/drone.service /etc/systemd/system/drone.service
fi

echo "Done"