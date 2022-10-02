#!/bin/bash
# Copyright (c) 2020, TIBCO Software Inc. All rights reserved.

# Start Cassandra service
echo -e "\nStarting cassandra service."
source set-cass-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Deploy Cassandra pods
echo -e "Deploying cassandra pods."
source deploy-nosql-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Start Cluster Manager service
echo -e "\nStarting CM service."
source set-cm-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# deploy cm pods
echo -e "Deploying CM pods."
source deploy-cm-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Start Log service
echo -e "\nStarting log service."
source set-log-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Deploy Log pods
echo -e "Deploying log pods."
source deploy-log-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Start database service
echo -e "\nStarting DB service."
source set-mysql-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Deploy database pods
echo -e "Deploying DB pods."
source deploy-sql-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Start memcached service
echo -e "\nStarting memcache service."
source set-cache-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Deploy memcached pods
echo -e "Deploying memcache pods."
source deploy-cache-pod.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Start Traffic Manager service
echo -e "\nStarting TM service."
source set-tm-svc.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# deploy-tm-pod.sh
echo -e "Deploying TM pods."
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