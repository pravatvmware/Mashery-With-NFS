#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#

TML_TYPE=$1
if [ "$TML_TYPE" = "" ]; then
    echo "**** " `date +'%m/%d %H:%M:%S'` " Please provide a valid TML component (nosql,clustermanager,log,sql,cache,tm)."
    exit 1
fi

ZONE=$2
if [ "$ZONE" = "" ]; then
    echo "**** " `date +'%m/%d %H:%M:%S'` " Please provide a valid zone. Make sure it matches one of the zones used during first deployment."
    exit 1
fi
TML_DEPLOY_FILE_PREFIX=""
TML_IMAGE=""

if [ "$TML_TYPE" = "nosql" ]; then
   TML_DEPLOY_FILE_PREFIX="nosql-pod-*."
   TML_IMAGE="tml-nosql"
fi
if [ "$TML_TYPE" = "cm" ]; then
   TML_DEPLOY_FILE_PREFIX="cm-pod-*"
   TML_IMAGE="tml-cm"
fi
if [ "$TML_TYPE" = "api" ]; then
   TML_DEPLOY_FILE_PREFIX="cm-pod-*"
   TML_IMAGE="tml-api"
fi
if [ "$TML_TYPE" = "log" ]; then
   TML_DEPLOY_FILE_PREFIX="log-pod-*"
   TML_IMAGE="tml-log"
fi
if [ "$TML_TYPE" = "sql" ]; then
   TML_DEPLOY_FILE_PREFIX="sql-pod-*"
   TML_IMAGE="tml-sql"
fi
if [ "$TML_TYPE" = "cache" ]; then
   TML_DEPLOY_FILE_PREFIX="cache-pod-*"
   TML_IMAGE="tml-cache"
fi
if [ "$TML_TYPE" = "tm" ]; then
   TML_DEPLOY_FILE_PREFIX="tm-pod-*"
   TML_IMAGE="tml-tm"
fi
if [ "$TML_DEPLOY_FILE_PREFIX" = "" ]; then
   echo "No valid TML component found."
   exit 1
fi
TML_DEPLOY_FILE=$(grep -inl "value: \"$ZONE\"" $TML_DEPLOY_FILE_PREFIX.yaml)
echo "Deployment file for the given component and region : "$TML_DEPLOY_FILE
if [ "$TML_DEPLOY_FILE" = "" ]; then
    echo "**** " `date +'%m/%d %H:%M:%S'` " No deployment file found for the given input."
    exit 1
fi

TML_DEPLOY_NAME=$(kubectl get -f $TML_DEPLOY_FILE | cut -d " " -f 1 | sed -n 2p)
echo "TML Deployment Name : "$TML_DEPLOY_NAME
if [ "$TML_DEPLOY_NAME" = "" ]; then
    echo "**** " `date +'%m/%d %H:%M:%S'` " No deployment found for the given input."
    exit 1
fi

for pod in $(kubectl get pods -o json --selector=app=$TML_DEPLOY_NAME | jq -r '[.items[] | .metadata.name] | @tsv'); do
echo "Reconfiguring TML pod: "$pod;
kubectl exec $pod /usr/local/bin/tml-event-handler.sh setUnsatisfied
done


