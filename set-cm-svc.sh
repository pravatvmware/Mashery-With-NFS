#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
if [ "$1" != "" ]; then
    ACTION=$1
else        
    TEST=`kubectl describe service cm-svc 2>/dev/null | grep Port`
    if [ "$TEST" = "" ]; then
        ACTION=create
    else
        ACTION=replace
    fi
fi

for index in $(seq 0 0); do
	cm_svc_yaml="cm-svc-${index}.yaml"
 
	kubectl $ACTION -f $cm_svc_yaml
done
