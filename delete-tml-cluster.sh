#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
source undeploy-cm-pod.sh
source undeploy-tm-pod.sh
#source undeploy-ds-pod.sh
#source undeploy-oauth-pod.sh
source undeploy-cache-pod.sh
source undeploy-sql-pod.sh
source undeploy-log-pod.sh
source undeploy-nosql-pod.sh

source delete-cm-svc.sh
source delete-tm-svc.sh
source delete-cache-svc.sh
source delete-mysql-svc.sh
source delete-log-svc.sh
source delete-cass-svc.sh

# To delete ALL persistent volumes for tmgc-cache
kubectl delete pvc $(kubectl get pvc -o=jsonpath='{.items[?(@.metadata.labels.app=="cache-svc")].metadata.name}')

# To delete ALL persistent volumes for database
kubectl delete pvc $(kubectl get pvc -o=jsonpath='{.items[?(@.metadata.labels.app=="mysql-svc")].metadata.name}')

# To delete ALL persistent volumes for Log
kubectl delete pvc $(kubectl get pvc -o=jsonpath='{.items[?(@.metadata.labels.app=="log-svc")].metadata.name}')

# To delete ALL persistent volumes for Cassandra
kubectl delete pvc $(kubectl get pvc -o=jsonpath='{.items[?(@.metadata.labels.app=="cass-svc")].metadata.name}')

if [ "false" = "true" -o "false" = "TRUE" ]; then
		source undeploy-reporting-pod.sh "local"
		source delete-reporting-svc.sh "local"
		kubectl delete pvc $(kubectl get pvc -o=jsonpath='{.items[?(@.metadata.labels.app=="reporting-svc")].metadata.name}')
fi

source delete-storage-classes.sh

kubectl delete secret cluster-property
kubectl delete secret zones-property
kubectl delete secret papi-property
