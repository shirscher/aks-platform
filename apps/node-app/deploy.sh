#!/bin/sh

SCRIPT_PATH=$(dirname $0)
ACR_NAME=acromnip01
APP_NAME=node-app-api
set -e

echo "Deploying infrastructure..."
$SCRIPT_PATH/infra/apply.sh

echo "Publishing database"

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

echo "Deploying Kubernetes manifests for API..."
yq eval ".images[0].newTag = \"${BUILD_NUMBER}\"" $SCRIPT_PATH/k8s/overlays/prod/kustomization.yaml > $SCRIPT_PATH/k8s/overlays/prod/temp.yaml
mv -f $SCRIPT_PATH/k8s/overlays/prod/temp.yaml $SCRIPT_PATH/k8s/overlays/prod/kustomization.yaml
kubectl apply -k $SCRIPT_PATH/k8s/overlays/prod

echo "Done!"