#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
if [ "$1" != "" ]; then
    ACTION=$1
else        
    TEST=`kubectl describe service tm-svc 2>/dev/null | grep Port`
    if [ "$TEST" = "" ]; then
        ACTION=create
    else
        ACTION=replace
    fi
fi

kubectl $ACTION -f tm-svc.yaml
