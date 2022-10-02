#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
if [ "$1" != "" ]; then
    ACTION=$1
else        
    TEST=`kubectl describe service cass-svc 2>/dev/null | grep Port`
    if [ "$TEST" = "" ]; then
        ACTION=create
    else
        ACTION=replace
    fi
fi

for index in $(seq 0 0); do
	cass_svc_yaml="cass-svc-${index}.yaml"
 
	kubectl $ACTION -f $cass_svc_yaml
done
