#!/bin/bash

terraform apply -var-file="./prod.tfvars" -auto-approve

# TODO: Log into kubectl