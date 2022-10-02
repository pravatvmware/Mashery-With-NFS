#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=create

ZONE=$1
if [ "$ZONE" != "" ]; then
    TML_DEPLOY_FILE=$(grep -inl "value: \"$ZONE\"" reporting-pod-*.yaml)
    if [ "$TML_DEPLOY_FILE" != "" ]; then
        echo "Deployment file $TML_DEPLOY_FILE found for the given zone $ZONE. Deploying for the zone."
        status=$(kubectl get secrets | grep -w reporting-resource)
    	if [ $? -ne 0 ]; then
			kubectl $ACTION secret generic reporting-resource --from-file=resources/tml-reporting
		fi
		fluentd_conf_status=$(kubectl get secrets | grep -w fluentd-conf)
		if [ $? -ne 0 ];then
			kubectl $ACTION secret generic fluentd-conf --from-file=resources/tml-reporting/fluentd/conf
		fi
		fluentd_plugin_status=$(kubectl get secrets | grep -w fluentd-plugin)
		if [ $? -ne 0 ];then
			kubectl $ACTION secret generic fluentd-plugin --from-file=resources/tml-reporting/fluentd/plugin
		fi
		grafana_resource_status=$(kubectl get secrets | grep -w grafana-resource)
		if [ $? -ne 0 ];then
			kubectl $ACTION secret generic grafana-resource --from-file=resources/tml-reporting/grafana
		fi
		grafana_user_dashboards_status=$(kubectl get secrets | grep -w grafana-user-dashboards)
		if [ $? -ne 0 ];then
			kubectl $ACTION secret generic grafana-user-dashboards --from-file=resources/tml-reporting/grafana/dashboards/CustomDashboards
		fi
		grafana_operations_status=$(kubectl get secrets | grep -w grafana-operations)
		if [ $? -ne 0 ];then
			kubectl $ACTION secret generic grafana-operations --from-file=resources/tml-reporting/grafana/dashboards/MasheryReporting/operations
		fi
		grafana_summary_status=$(kubectl get secrets | grep -w grafana-summary)
		if [ $? -ne 0 ];then
			kubectl $ACTION secret generic grafana-summary --from-file=resources/tml-reporting/grafana/dashboards/MasheryReporting/summary
		fi
		prometheus_resource_status=$(kubectl get secrets | grep -w prometheus-resource)
		if [ $? -ne 0 ];then
			kubectl $ACTION secret generic prometheus-resource --from-file=resources/tml-reporting/prometheus
		fi
		loki_resource_status=$(kubectl get secrets | grep -w loki-resource)
		if [ $? -ne 0 ];then
			kubectl $ACTION secret generic loki-resource --from-file=resources/tml-reporting/loki
		fi
    	kubectl $ACTION -f $TML_DEPLOY_FILE
    	return 0;
    else
    	echo "No deployment file found for the given zone. Please enter a valid zone."
    	return 1
    fi
fi

kubectl $ACTION secret generic reporting-resource --from-file=resources/tml-reporting
kubectl $ACTION secret generic fluentd-conf --from-file=resources/tml-reporting/fluentd/conf
kubectl $ACTION secret generic fluentd-plugin --from-file=resources/tml-reporting/fluentd/plugin
kubectl $ACTION secret generic grafana-resource --from-file=resources/tml-reporting/grafana
kubectl $ACTION secret generic grafana-user-dashboards --from-file=resources/tml-reporting/grafana/dashboards/CustomDashboards
kubectl $ACTION secret generic grafana-operations --from-file=resources/tml-reporting/grafana/dashboards/MasheryReporting/operations
kubectl $ACTION secret generic grafana-summary --from-file=resources/tml-reporting/grafana/dashboards/MasheryReporting/summary
kubectl $ACTION secret generic prometheus-resource --from-file=resources/tml-reporting/prometheus
kubectl $ACTION secret generic loki-resource --from-file=resources/tml-reporting/loki

for index in $(seq 0 0); do
	reporting_pod_yaml="reporting-pod-${index}.yaml"
	kubectl $ACTION -f $reporting_pod_yaml
done

# Check reporting pods deployment progress
while [ : ]
do
    status=$(kubectl get pods| grep "reporting-set")
    if [ $? -ne 0 ]; then
        break
    fi

    echo
    echo "$status"
    count=$(echo "$status" | grep "1/1 *Running" | wc -l)
    if [ $? -eq 0 ] && [ $count -eq $((TMGC_REPORTING_COUNT * 1)) ]; then
        break
    fi
    sleep 5
done
