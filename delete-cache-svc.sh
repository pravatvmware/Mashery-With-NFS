#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=delete
 
for index in $(seq 0 0); do
	cache_svc_yaml="cache-svc-${index}.yaml"
 
	kubectl $ACTION -f $cache_svc_yaml
done
