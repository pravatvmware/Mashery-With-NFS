#!/bin/bash
# Copyright (c) 2020, TIBCO Software Inc. All rights reserved.
#
source undeploy-cm-pod.sh
source undeploy-tm-pod.sh
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

if [ "false" = "true" -o "false" = "TRUE" ]; then
		source undeploy-reporting-pod.sh "local"
		source delete-reporting-svc.sh "local"
		kubectl delete pvc $(kubectl get pvc -o=jsonpath='{.items[?(@.metadata.labels.app=="reporting-svc")].metadata.name}')
fi