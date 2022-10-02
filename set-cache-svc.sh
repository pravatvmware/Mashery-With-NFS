#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
if [ "$1" != "" ]; then
    ACTION=$1
else        
    TEST=`kubectl describe service cache-svc 2>/dev/null | grep Port`
    if [ "$TEST" = "" ]; then
        ACTION=create
    else
        ACTION=replace
    fi
fi

for index in $(seq 0 0); do
	cache_svc_yaml="cache-svc-${index}.yaml"
 
	kubectl $ACTION -f $cache_svc_yaml
done
