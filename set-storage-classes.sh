#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
if [ "$1" != "" ]; then
    ACTION=$1
else        
    TEST=`kubectl get StorageClass sql-storage-class 2>/dev/null | grep sql-storage`
    if [ "$TEST" = "" ]; then
        ACTION=create
    else
        ACTION=replace
    fi
fi

for index in $(seq 0 0); do
	storage_classes_yaml="storage-classes-${index}.yaml"
 
	kubectl $ACTION -f $storage_classes_yaml
done
