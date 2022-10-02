#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=delete
 
for index in $(seq 0 0); do
	cass_svc_yaml="cass-svc-${index}.yaml"
 
	kubectl $ACTION -f $cass_svc_yaml
done
