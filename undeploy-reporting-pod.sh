#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=delete

ZONE=$1
if [ "$ZONE" != "" ]; then
    TML_DEPLOY_FILE=$(grep -inl "value: \"$ZONE\"" reporting-pod-*.yaml)
    if [ "$TML_DEPLOY_FILE" != "" ]; then
        echo "Deployment file $TML_DEPLOY_FILE found for the given zone $ZONE. Removing the deployment for the zone."
    	kubectl $ACTION -f $TML_DEPLOY_FILE
    	status=$(kubectl get secrets | grep -w reporting-resource)
    	if [ $? -eq 0 ]; then
			kubectl $ACTION secret reporting-resource
        fi
     	fluentd_conf_status=$(kubectl get secrets | grep -w fluentd-conf)
		if [ $? -eq 0 ];then
			kubectl $ACTION secret fluentd-conf
		fi
		fluentd_plugin_status=$(kubectl get secrets | grep -w fluentd-plugin)
		if [ $? -eq 0 ];then
			kubectl $ACTION secret fluentd-plugin
		fi
		grafana_resource_status=$(kubectl get secrets | grep -w grafana-resource)
		if [ $? -eq 0 ];then
			kubectl $ACTION secret grafana-resource
		fi
		grafana_user_dashboards_status=$(kubectl get secrets | grep -w grafana-user-dashboards)
		if [ $? -eq 0 ];then
			kubectl $ACTION secret grafana-user-dashboards
		fi
		grafana_operations_status=$(kubectl get secrets | grep -w grafana-operations)
		if [ $? -eq 0 ];then
			kubectl $ACTION secret grafana-operations
		fi
		grafana_summary_status=$(kubectl get secrets | grep -w grafana-summary)
		if [ $? -eq 0 ];then
			kubectl $ACTION secret grafana-summary
		fi
		prometheus_resource_status=$(kubectl get secrets | grep -w prometheus-resource)
		if [ $? -eq 0 ];then
			kubectl $ACTION secret prometheus-resource
		fi
		loki_resource_status=$(kubectl get secrets | grep -w loki-resource)
		if [ $? -eq 0 ];then
			kubectl $ACTION secret loki-resource
		fi
    	
    	return 0;
    else
    	echo "No deployment file found for the given zone. Please enter a valid zone."
    	return 1
    fi
fi

kubectl $ACTION secret reporting-resource
kubectl $ACTION secret fluentd-conf
kubectl $ACTION secret fluentd-plugin
kubectl $ACTION secret grafana-resource
kubectl $ACTION secret grafana-user-dashboards
kubectl $ACTION secret grafana-operations
kubectl $ACTION secret grafana-summary
kubectl $ACTION secret prometheus-resource
kubectl $ACTION secret loki-resource

for index in $(seq 0 0); do
	reporting_pod_yaml="reporting-pod-${index}.yaml"

	kubectl $ACTION -f $reporting_pod_yaml
done
