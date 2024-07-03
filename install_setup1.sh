#!/bin/bash
set -o errexit

INFRA_HOME=$GRAFYSI_HOME/k8s-infra

# init KIND cluster
echo "##################################### INIT KIND CLUSTER"
K8S_INIT_DIR=$INFRA_HOME/k8s-cluster/init
bash $K8S_INIT_DIR/kind/install.sh

# install and configure cert-authority
echo "##################################### CERT AUTHORITY"
CA_DIR=$INFRA_HOME/cert-authority
bash $CA_DIR/install.sh
bash $CA_DIR/node-config/ubuntu/config.sh
bash $CA_DIR/node-config/kind/config.sh

sleep 1 # sleep 1s to ensure everything are settle

# install and configure docker cache
echo "##################################### DOCKER CACHE"
DCACHE_DIR=$INFRA_HOME/docker-cache
bash $DCACHE_DIR/install.sh
bash $DCACHE_DIR/node-config/ubuntu/config.sh
bash $DCACHE_DIR/node-config/kind/config.sh

sleep 1 # sleep 1s to ensure everything are settle

# install and configure private docker registry
echo "##################################### DOCKER REGISTRY"
DREG_DIR=$INFRA_HOME/docker-registry
bash $DREG_DIR/install.sh

sleep 1 # sleep 1s to ensure everything are settle

# install and configure reverse proxy
echo "##################################### REVERSE PROXY"
RPROXY_DIR=$INFRA_HOME/reverse-proxy
bash $RPROXY_DIR/install.sh

# install and config storage server
#echo "##################################### STORAGE SERVER"
#STR_SER_DIR=$INFRA_HOME/storage-server
#bash $STR_SER_DIR/install.sh

# install base apps (cni, ingress controller) for k8s cluster
echo "##################################### BASE APPS"
K8S_BASE_APPS_DIR=$INFRA_HOME/k8s-cluster/base-apps
bash $K8S_BASE_APPS_DIR/install.sh

# install local path csi
echo "##################################### LOCAL PATH CSI"
CSI_DIR=$INFRA_HOME/k8s-cluster/csi
bash $CSI_DIR/local-path/install.sh

# as running this script require sudo
# we need to change privileges of created directories
echo "Re-assign ${GRAFYSI_CONFIG} to ${USER}"
chown -R ${USER}:${USER} ${GRAFYSI_CONFIG}
chmod -R 777 ${GRAFYSI_CONFIG}
