#!/bin/bash

echo "Deploying reporting pod and service"
source set-reporting-svc.sh "local"
source deploy-reporting-pod.sh "local"
if [ $? -ne 0 ]; then
   exit $?
fi
echo "Finished the deployment of Reporting pod and service"