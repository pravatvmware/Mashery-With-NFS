kubectl cp update_registry_schema.cql ${1}:/usr/bin

kubectl cp cluster_ids_util.sh ${1}:/usr/bin

kubectl exec -it ${1} -- bash -c "cd /usr/bin; chmod 777 cluster_ids_util.sh; ./cluster_ids_util.sh;"

echo "Updating the schema..."
kubectl exec -it ${1} -- bash -c "service cassandra status; cd /usr/bin; cqlsh -f update_registry_schema.cql;"
echo "Done."
