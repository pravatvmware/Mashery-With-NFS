#!/bin/bash

echo "Undeploying reporting pod and service"

source undeploy-reporting-pod.sh "local"
source delete-reporting-svc.sh "local"
kubectl delete pvc $(kubectl get pvc -o=jsonpath='{.items[?(@.metadata.labels.app=="reporting-svc")].metadata.name}')

echo "Finished the undeployment of Reporting pod and service"