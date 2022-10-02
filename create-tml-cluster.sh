#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.

K8S_DEPLOY_NAMESPACE=ml550

# Set default namespace in case namespace is other than default
if [ $K8S_DEPLOY_NAMESPACE == default ]; then
    :
else
    source create-tml-namespace.sh
    kubectl config set-context --current --namespace=$K8S_DEPLOY_NAMESPACE
fi

kubectl create secret generic cluster-property --from-file=tml_cluster_properties.json
kubectl create secret generic zones-property --from-file=tml_zones_properties.json
kubectl create secret generic papi-property --from-file=tml_papi_properties.json

# Create storage classes for persistent stores
echo "Creating storage classes."
source set-storage-classes.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Create Cassandra service
echo "Creating cassandra service."
source set-cass-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Deploy Cassandra pods
echo "Deploying cassandra pods."
source deploy-nosql-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Create Cluster Manager service
source set-cm-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# deploy cm pods
echo "Deploying CM pods."
source deploy-cm-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Create Log service
source set-log-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Deploy Log pods
source deploy-log-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Create database service
echo "Creating DB service."
source set-mysql-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Deploy database pods
echo "Deploying DB pods."
source deploy-sql-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Create memcached service
source set-cache-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Deploy memcached pods
echo "Deploying memcache pods."
source deploy-cache-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Create Traffic Manager service
echo "Ceating TM service."
source set-tm-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# deploy-tm-pod.sh
echo "Deploying TM pods."
source deploy-tm-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# deploy reporting pods if enabled
if [ "false" = "true" -o "false" = "TRUE" ]; then
		source set-reporting-svc.sh "local"
        source deploy-reporting-pod.sh "local"
        if [ $? -ne 0 ]; then
    		exit $?
		fi
fi
