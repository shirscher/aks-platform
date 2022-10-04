#!/bin/sh

SCRIPT_PATH=$(dirname $0)
set -e

echo "Deploying node-app..."
$SCRIPT_PATH/node-app/deploy.sh
