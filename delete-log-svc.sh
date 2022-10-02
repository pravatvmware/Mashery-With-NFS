#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=delete
 
for index in $(seq 0 0); do
	log_svc_yaml="log-svc-${index}.yaml"
 
	kubectl $ACTION -f $log_svc_yaml
done
