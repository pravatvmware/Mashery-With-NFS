#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=delete
  
for index in $(seq 0 0); do
	cm_svc_yaml="cm-svc-${index}.yaml"
 
	kubectl $ACTION -f $cm_svc_yaml
done
