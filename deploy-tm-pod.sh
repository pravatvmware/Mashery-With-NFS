#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
ACTION=create

ZONE=$1
if [ "$ZONE" != "" ]; then
    TML_DEPLOY_FILE=$(grep -inl "value: \"$ZONE\"" tm-pod-*.yaml)
    if [ "$TML_DEPLOY_FILE" != "" ]; then
        echo "Deployment file $TML_DEPLOY_FILE found for the given zone $ZONE. Deploying for the zone."
    	kubectl $ACTION -f $TML_DEPLOY_FILE
    	status=$(kubectl get secrets | grep -w tm-property)
    	if [ $? -ne 0 ]; then
        	kubectl $ACTION secret generic tm-property --from-file=tml_tm_properties.json
			kubectl $ACTION secret generic tm-jks --from-file=tml-tm.jks
			kubectl $ACTION secret generic tm-trust-jks --from-file=tml-tm-trust.jks
            kubectl $ACTION secret generic tm-resource --from-file=resources/tml-tm/

            
    	fi
    	exit 0;
    else
    	echo "No deployment file found for the given zone. Please enter a valid zone."
    	exit 1
    fi
fi

kubectl $ACTION secret generic tm-property --from-file=tml_tm_properties.json
kubectl $ACTION secret generic tm-jks --from-file=tml-tm.jks
kubectl $ACTION secret generic tm-trust-jks --from-file=tml-tm-trust.jks
kubectl $ACTION secret generic tm-resource --from-file=resources/tml-tm/

for index in $(seq 0 0); do
	tm_pod_yaml="tm-pod-${index}.yaml"
	kubectl $ACTION -f $tm_pod_yaml
done

# Check tm pods deployment progress
while [ : ]
do
    status=$(kubectl get pods| grep "tm-deploy")
    if [ $? -ne 0 ]; then
        break
    fi
    
    echo
    echo "$status"
    count=$(echo "$status" | grep "1/1 *Running" | wc -l)
    if [ $? -eq 0 ] && [ $count -eq $((1 * 1)) ]; then
        break
    fi
    sleep 5
done
# Print URLs to access TM, Config manager and Dev Portal.
echo -e "\n"
echo "Please use below URLs to access different services from your machine after all the components are ACTIVE."
echo -e "\n"
echo "----- Traffic manager URL. Append endpoint, api key and other parameters as needed -----"
echo "http://"$(kubectl describe node node-1 | grep InternalIP | cut -d ':' -f 2 | sed -e 's/^[ \t]*//')":"$(kubectl describe svc tm-svc | grep -m 1 NodePort | grep -Eo '[0-9]{4,5}')
echo -e "\n"
echo "----- Config Manager URL -----"
echo "https://"$(kubectl describe node node-1 | grep InternalIP | cut -d ':' -f 2 | sed -e 's/^[ \t]*//')":"$(kubectl describe svc cm-svc-0 | grep NodePort | grep cm-https-port | grep -Eo '[0-9]{4,5}')"/admin"
echo -e "\n"
echo "----- Dev Portal URL -----"
echo "https://"$(kubectl describe node node-1 | grep InternalIP | cut -d ':' -f 2 | sed -e 's/^[ \t]*//')":"$(kubectl describe svc cm-svc-0 | grep NodePort | grep cm-https-port | grep -Eo '[0-9]{4,5}')
echo -e "\n"