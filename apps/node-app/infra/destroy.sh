#!/bin/sh

SCRIPT_PATH=$(dirname $0)
set -e

terraform destroy -input=false -var-file="./prod.tfvars" -auto-approve
