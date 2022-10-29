#!/bin/sh

set -e

echo "Running terraform destroy for platform..."
terraform destroy -input=false -var-file="./prod.tfvars" -auto-approve
