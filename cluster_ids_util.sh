#!/bin/bash
cqlsh -e "use tmg_registry; SELECT id FROM clusters WHERE name = '$TMG_CLUSTER_NAME'" > /cluster_ids.txt
echo "Reading the clusterIds..."
export CLUSTERIDS=$(sed 's/\ //g;/^id/d; /^----.*/d; /^(/d; /^\s*$/d;' /cluster_ids.txt | tr '\n' ',' |  sed -e 's/,$/\n/')
echo "Updating the clusterIds..."
sed -i "s/DataCenters/$CLUSTERIDS/g" /usr/bin/update_registry_schema.cql
