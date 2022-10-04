#!/bin/sh

SERVICE_PRINCIPAL_NAME=sp-terraform-p

echo "Running terraform destroy for platform..."
terraform destroy -input=false -var-file="./prod.tfvars" -auto-approve
