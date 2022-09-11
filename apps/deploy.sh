#!/bin/sh

# Create pipelines from code in all app folders
source ./node-api/pipelines/create-pipelines.sh
#source ./angular-static-website/pipelines/create-pipelines.sh

# Run all pipelines
source ./node-api/pipelines/run-pipeline.sh infrastructure-release
source ./node-api/pipelines/run-pipeline.sh database-release
source ./node-api/pipelines/run-pipeline.sh application-release