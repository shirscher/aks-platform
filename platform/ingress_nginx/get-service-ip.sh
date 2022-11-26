#!/bin/bash

SERVICE=ingress-nginx-controller
NAMESPACE=ingress-nginx

ATTEMPT_COUNT=0
MAX_ATTEMPTS=10
SLEEP=5

while true;
do
  kubectl get svc -n $NAMESPACE $SERVICE -o jsonpath='{"{\"ip\": "}{"\""}{.status.loadBalancer.ingress[0].ip}{"\"}"}' | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" >/dev/null

  if [ $? -eq 0 ]; then
    kubectl get svc -n $NAMESPACE $SERVICE -o jsonpath='{"{\"ip\": "}{"\""}{.status.loadBalancer.ingress[0].ip}{"\"}"}'
    exit 0
  fi

  ATTEMPT_COUNT=$((ATTEMPT_COUNT+1))
  if [ "$ATTEMPT_COUNT" == "$MAX_ATTEMPTS" ]; then
    exit 1
  fi

  sleep $SLEEP
done