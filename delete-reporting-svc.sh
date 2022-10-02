#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=delete
ZONE=$1

if [ "$ZONE" != "" ]; then
    TML_REPORT_SVC_FILE=$(find . -name reporting-svc-$ZONE.yaml)
    if [ "$TML_REPORT_SVC_FILE" != "" ]; then
        echo "Deleting internal reporting service for the zone $ZONE."
    	kubectl $ACTION -f $TML_REPORT_SVC_FILE
    	#exit 0;
    else
    	echo "Service deployment file not found for the given zone. Please enter a valid zone."
    	exit 1
    fi
    TML_REPORT_SVC_EXTERNAL_FILE=$(find . -name reporting-svc-external-$ZONE.yaml)
    if [ "$TML_REPORT_SVC_EXTERNAL_FILE" != "" ]; then
        echo "Deleting external reporting service for the zone $ZONE."
    	kubectl $ACTION -f $TML_REPORT_SVC_EXTERNAL_FILE
    	return 0;
    else
    	echo "External Service deployment file not found for the given zone. Please enter a valid zone."
    	exit 1
    fi
fi

for i in reporting-svc-*.yaml; do
    kubectl $ACTION -f "$i"
done