#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#

TML_TYPE=$1
if [ "$TML_TYPE" = "" ]; then
    echo "**** " `date +'%m/%d %H:%M:%S'` " Please provide a valid TML component (nosql,clustermanager,log,sql,cache,tm)."
    exit 1
fi
IMAGE_TAG=$2
if [ "$IMAGE_TAG" = "" ]; then
    echo "**** " `date +'%m/%d %H:%M:%S'` " Please provide a valid new image tag."
    exit 1
fi
ZONE=$3
if [ "$ZONE" = "" ]; then
    echo "**** " `date +'%m/%d %H:%M:%S'` " Please provide a valid zone. Make sure it matches one of the zones used during first deployment."
    exit 1
fi
TML_DEPLOY_FILE_PREFIX=""
TML_IMAGE=""
IS_STATEFUL=""
CONTAINER_POSITION=0
if [ "$TML_TYPE" = "nosql" ]; then
   TML_DEPLOY_FILE_PREFIX="nosql-pod-*"
   TML_IMAGE="tml-nosql"
   IS_STATEFUL="Y"
fi
if [ "$TML_TYPE" = "cm" ]; then
   TML_DEPLOY_FILE_PREFIX="cm-pod-*"
   TML_IMAGE="tml-cm"
fi
if [ "$TML_TYPE" = "api" ]; then
   TML_DEPLOY_FILE_PREFIX="cm-pod-*"
   TML_IMAGE="tml-api"
   CONTAINER_POSITION=1
fi
if [ "$TML_TYPE" = "log" ]; then
   TML_DEPLOY_FILE_PREFIX="log-pod-*"
   TML_IMAGE="tml-log"
   IS_STATEFUL="Y"
fi
if [ "$TML_TYPE" = "sql" ]; then
   TML_DEPLOY_FILE_PREFIX="sql-pod-*"
   TML_IMAGE="tml-sql"
   IS_STATEFUL="Y"
fi
if [ "$TML_TYPE" = "cache" ]; then
   TML_DEPLOY_FILE_PREFIX="cache-pod-*"
   TML_IMAGE="tml-cache"
   IS_STATEFUL="Y"
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

TML_DEPLOY_NAME=$(kubectl get -f $TML_DEPLOY_FILE | cut -d " " -f 1 | sed -n 2p)
echo "TML Deployment Name : "$TML_DEPLOY_NAME
echo "Patching TML component with new image version : " $IMAGE_TAG

if [ "$IS_STATEFUL" = "Y" ];then
    kubectl patch statefulset $TML_DEPLOY_NAME --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/'$CONTAINER_POSITION'/image", "value":"'$TML_IMAGE':'$IMAGE_TAG'"}]'
else
    kubectl patch deployment $TML_DEPLOY_NAME --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/'$CONTAINER_POSITION'/image", "value":"'$TML_IMAGE':'$IMAGE_TAG'"}]'
fi


