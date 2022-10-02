#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#

if [ "$1" != "" ]; then
    ACTION=$1
else        
    TEST=`kubectl get namespace ml550 2>/dev/null | grep ml550`
    if [ "$TEST" = "" ]; then
        ACTION=create
        kubectl $ACTION -f tml-namespace.yaml
    else
        ACTION=replace
    fi
fi

