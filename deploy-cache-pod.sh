#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=create

ZONE=$1
if [ "$ZONE" != "" ]; then
    TML_DEPLOY_FILE=$(grep -inl "value: \"$ZONE\"" cache-pod-*.yaml)
    if [ "$TML_DEPLOY_FILE" != "" ]; then
        echo "Deployment file $TML_DEPLOY_FILE found for the given zone $ZONE. Deploying for the zone."
    	kubectl $ACTION -f $TML_DEPLOY_FILE
    	status=$(kubectl get secrets | grep -w cache-property)
    	if [ $? -ne 0 ]; then
        	kubectl $ACTION secret generic cache-property --from-file=tml_cache_properties.json
            kubectl $ACTION secret generic cache-resource --from-file=resources/tml-cache/
    	fi
    	exit 0;
    else
    	echo "No deployment file found for the given zone. Please enter a valid zone."
    	exit 1
    fi
fi

kubectl $ACTION secret generic cache-property --from-file=tml_cache_properties.json
kubectl $ACTION secret generic cache-resource --from-file=resources/tml-cache/

for index in $(seq 0 0); do
	cache_pod_yaml="cache-pod-${index}.yaml"
	kubectl $ACTION -f $cache_pod_yaml
done

# Check cache pods deployment progress
while [ : ]
do
    status=$(kubectl get pods| grep "cache-set")
    if [ $? -ne 0 ]; then
        break
    fi
    
    echo
    echo "$status"
    count=$(echo "$status" | grep "1/1 *Running" | wc -l)
    if [ $? -eq 0 ] && [ $count -eq $((1 * 1)) ]; then
        break
    fi
    sleep 5
done
