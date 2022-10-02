#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
if [ "$1" != "" ]; then
    ACTION=$1
else        
    TEST=`kubectl get statefulset cass-set-0 2>/dev/null | grep cass-set-0`
    if [ "$TEST" = "" ]; then
        ACTION=create
    else
        ACTION=replace
    fi
fi

kubectl $ACTION secret generic nosql-property --from-file=tml_nosql_properties.json
kubectl $ACTION secret generic nosql-resource --from-file=resources/tml-nosql/
kubectl $ACTION secret generic nosql-p12 --from-file=tml-nosql.p12
kubectl $ACTION secret generic nosql-trust-p12 --from-file=tml-nosql-trust.p12

for index in $(seq 0 0); do
	nosql_pod_yaml="nosql-pod-${index}.yaml"
 
	kubectl $ACTION -f $nosql_pod_yaml
	#Provide some time for pod's creation
	sleep 10
	while [ : ]
	do
	    status=$(kubectl get pods| grep "cass-set-$index")
	    if [ $? -ne 0 ]; then
	        break
	    fi
	    
	    echo
	    echo "$status"
	    count=$(echo "$status" | grep "1/1 *Running" | wc -l)
	    if [ $? -eq 0 ] && [ $count -eq 1 ]; then
	        break
	    fi
	    sleep 5
	done
done
