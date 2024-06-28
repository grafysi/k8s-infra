#!/bin/bash
set -o errexit

PROXY_HOST=$GRAFYSI_DOCKER_CACHE_HOST
PROXY_PORT=3128
KIND_NAME=$GRAFYSI_CLUSTER_NAME

# configure kind k8s nodes
echo "Configuring KIND nodes..."
CA_CRT_URL=http://${PROXY_HOST}:${PROXY_PORT}/ca.crt

for NODE in $(kind get nodes --name "$KIND_NAME"); do
  docker exec $NODE mkdir -p /etc/systemd/system/containerd.service.d
  
  REGISTRY_PROXY_CONF="[Service]\nEnvironment=\"HTTPS_PROXY=http://${PROXY_HOST}:${PROXY_PORT}/\" \"NO_PROXY=127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16\""
  
  docker exec $NODE bash -c "printf '$REGISTRY_PROXY_CONF' > /etc/systemd/system/containerd.service.d/http-proxy.conf"

  
  docker exec $NODE sh -c "curl ${CA_CRT_URL} > /usr/local/share/ca-certificates/docker_registry_proxy.crt"
  
  docker exec $NODE update-ca-certificates --fresh
  docker exec $NODE systemctl daemon-reload
  docker exec $NODE systemctl restart containerd.service
done
echo "Completed."
