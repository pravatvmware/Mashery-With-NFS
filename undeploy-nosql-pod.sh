#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=delete

kubectl $ACTION secret nosql-property
kubectl $ACTION secret nosql-resource
kubectl $ACTION secret nosql-p12
kubectl $ACTION secret nosql-trust-p12

for index in $(seq 0 0); do
	nosql_pod_yaml="nosql-pod-${index}.yaml"
 
	kubectl $ACTION -f $nosql_pod_yaml
done
