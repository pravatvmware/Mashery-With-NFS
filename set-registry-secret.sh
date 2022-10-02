#!/bin/bash
# Copyright (c) 2018, TIBCO Software Inc. All rights reserved.
#
TMGC_REGISTRY_SECRET_YAML="k8s-registry-secret.yaml"

if [ "$1" != "" ]; then
    ACTION=$1
else
    TEST=`kubectl get secret tmgc-registry-key 2>/dev/null | grep dockerconfigjson`
    if [ "$TEST" = "" ]; then
        ACTION=create
    else
        ACTION=replace
    fi
fi

cat > $TMGC_REGISTRY_SECRET_YAML << EOF
apiVersion: v1
kind: Secret
metadata:
  name: tmgc-registry-key
#  namespace: mashery
data:
  .dockerconfigjson: |
$(cat ~/.docker/config.json | base64 | sed 's/^/    /')
type: kubernetes.io/dockerconfigjson
EOF

kubectl $ACTION -f $TMGC_REGISTRY_SECRET_YAML
