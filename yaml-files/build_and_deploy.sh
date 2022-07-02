#!/bin/bash

set -e

echoGreen() { echo $'\e[0;32m'"$1"$'\e[0m'; }

NAMESPACE="$1"
USERNAME="$2"
PASSWORD="$3"

echoGreen "Deploying Nginx to Openshift"
oc login -u ${USERNAME} -p ${PASSWORD} https://console.cluster1.emea.cp.alex.com:8443
oc registry login
oc project ${NAMESPACE}

echoGreen "Building Image - Nginx"
docker build -t nginx -f nginx/Dockerfile ./nginx
docker tag nginx docker-registry-default.apps.cluster1.emea.cp.alex.com/${NAMESPACE}/nginx:latest
docker push docker-registry-default.apps.cluster1.emea.cp.alex.com/${NAMESPACE}/nginx:latest

echoGreen "Deploying"
oc process -f openshift-template.yaml \
   -p PROJECT_NAME=${NAMESPACE} \
   | oc apply -f -

echoGreen "Successfully deployed."
echoGreen "Open https://nginx-${NAMESPACE}.apps.cluster1.emea.cp.alex.com"