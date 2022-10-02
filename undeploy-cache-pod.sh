#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=delete

ZONE=$1
if [ "$ZONE" != "" ]; then
    TML_DEPLOY_FILE=$(grep -inl "value: \"$ZONE\"" cache-pod-*.yaml)
    if [ "$TML_DEPLOY_FILE" != "" ]; then
        echo "Deployment file $TML_DEPLOY_FILE found for the given zone $ZONE. Removing the deployment for the zone."
    	kubectl $ACTION -f $TML_DEPLOY_FILE
    	status=$(kubectl get secrets | grep -w cache-property)
    	if [ $? -eq 0 ]; then
        	kubectl $ACTION secret cache-property
			kubectl $ACTION secret cache-resource
			
    	fi
    	exit 0;
    else
    	echo "No deployment file found for the given zone. Please enter a valid zone."
    	exit 1
    fi
fi

kubectl $ACTION secret cache-property
kubectl $ACTION secret cache-resource

for index in $(seq 0 0); do
	cache_pod_yaml="cache-pod-${index}.yaml"
 
	kubectl $ACTION -f $cache_pod_yaml
done
