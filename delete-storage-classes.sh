#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=delete

for index in $(seq 0 0); do
	storage_classes_yaml="storage-classes-${index}.yaml"
 
	kubectl $ACTION -f $storage_classes_yaml
done
