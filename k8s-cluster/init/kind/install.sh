#!/bin/bash
set -o errexit

KIND_INIT_DIR=$GRAFYSI_HOME/k8s-infra/k8s-cluster/init/kind

CLUSTER_CONFIG_DIR=$GRAFYSI_CONFIG/k8s-cluster

DOCKER_NET=$GRAFYSI_DOCKER_NODE_VLAN_NET

mkdir -p $CLUSTER_CONFIG_DIR

CLUSTER_NAME=$GRAFYSI_CLUSTER_NAME

# create kind cluster
export KIND_EXPERIMENTAL_DOCKER_NETWORK=$DOCKER_NET
kind create cluster --name=$CLUSTER_NAME --config=$KIND_INIT_DIR/resource/cluster.yml || true

# as above creation mode is not supported by KIND
# we need some workarounds

# 1. re-connect nodes to VLAN network for assigning static ip
for NODE in $(kind get nodes --name=${CLUSTER_NAME}); do
  NODE_IP=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${NODE})
  docker stop $NODE
  docker network disconnect $DOCKER_NET $NODE
  docker network connect --ip $NODE_IP $DOCKER_NET $NODE
  docker start $NODE
done


# 2. manually add cluster context to kubectl
CLUSTER_CONF_FILE=$CLUSTER_CONFIG_DIR/${CLUSTER_NAME}_config

# get and modify cluster config file
docker cp $CLUSTER_NAME-control-plane:/etc/kubernetes/admin.conf $CLUSTER_CONF_FILE
# change user name
sed -i "s/kubernetes-admin/${CLUSTER_NAME}-admin/g" $CLUSTER_CONF_FILE

# change api server host
MASTER_NODE=${CLUSTER_NAME}-control-plane
MASTER_NODE_IP=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $MASTER_NODE)
sed -i "s/$MASTER_NODE:6443/$MASTER_NODE_IP:6443/g" $CLUSTER_CONF_FILE

# apply new config if possible
if [ -z "${KUBECONFIG+xxx}" ] ; then # kubeconfig is not set
  cp ~/.kube/config ~/.kube/config.prev.${CLUSTER_NAME}.backup
  export KUBECONFIG=$CLUSTER_CONF_FILE:~/.kube/config.prev.${CLUSTER_NAME}.backup
  kubectl config view --flatten > ~/.kube/config
  unset KUBECONFIG
else
  echo "KUBECONFIG is set, can not automatically apply new cluster config"
fi

# wait for api server ready
echo "Waiting for API server to become ready..."
until kubectl get pods --all-namespaces &> /dev/null; do
  echo "API server is not ready yet, sleeping for 1 seconds..."
  sleep 1
done

# Print a success message
echo "API server is ready!"





