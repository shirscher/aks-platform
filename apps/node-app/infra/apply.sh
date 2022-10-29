#!/bin/sh

SCRIPT_PATH=$(dirname $0)
set -e

terraform -chdir=${SCRIPT_PATH} apply -var-file="${SCRIPT_PATH}/prod.tfvars" -auto-approve
