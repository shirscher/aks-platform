#!/bin/sh

SCRIPT_PATH=$(dirname $0)
ACR_NAME=acromnip01
APP_NAME=node-app-api
set -e

echo "Deploying infrastructure..."
terraform -chdir=${SCRIPT_PATH}/infra apply -var-file=prod.tfvars -auto-approve

echo "Publishing database..."
npm run typeorm:migration:run

echo "Building UI..."

echo "Deploying UI to storage container..."

echo "Building API..."
BUILD_NUMBER=$(date '+%Y.%m.%d.%H%M%S')
echo "BUILD_NUMBER = ${BUILD_NUMBER}"
docker build -t ${APP_NAME} $SCRIPT_PATH/api

echo "Pushing API container image..."
docker tag ${APP_NAME} ${ACR_NAME}.azurecr.io/${APP_NAME}:${BUILD_NUMBER}
az acr login --name ${ACR_NAME}
docker push ${ACR_NAME}.azurecr.io/${APP_NAME}:${BUILD_NUMBER}

echo "Deploying Helm chart..."
NAMESPACE=node-app
GIT_COMMIT=$(git rev-parse --short HEAD)
GIT_COMMIT=ffffff
kubectl apply -f ${SCRIPT_PATH}/chart/namespace.yaml
helm upgrade node-app-api --namespace "$NAMESPACE" --install -f ${SCRIPT_PATH}/chart/values.yaml --set gitCommit=$GIT_COMMIT --set buildNumber=$BUILD_NUMBER ${SCRIPT_PATH}/chart

echo "Done!"