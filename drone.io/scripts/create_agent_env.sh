#!bin/bash

# Creates an env file for drone's server
#
# $DRONE_HOST: drone's domain name
# $DRONE_SECRET: to be shared with drone's server
#

DRONE_HOST=$1
DRONE_SECRET=$2
OUTPUT_FILE=$3

echo "#DRONE AGENT

DRONE_SECRET=$DRONE_SECRET
DRONE_SERVER=wss://$DRONE_HOST/ws/broker" > $OUTPUT_FILE