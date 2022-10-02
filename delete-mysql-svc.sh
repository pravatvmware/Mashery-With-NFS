#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=delete
 
for index in $(seq 0 0); do
	mysql_svc_yaml="mysql-svc-${index}.yaml"
 
	kubectl $ACTION -f $mysql_svc_yaml
done
