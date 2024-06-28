#!/bin/bash
set -o errexit

DOCKER_CACHE=$GRAFYSI_CONFIG/docker-cache

KIND_NAME=$GRAFYSI_CLUSTER_NAME

CACHE_HOST=$GRAFYSI_DOCKER_CACHE_HOST
PROXY_PORT=3128

mkdir -p $DOCKER_CACHE/data
mkdir -p $DOCKER_CACHE/certs

cd $GRAFYSI_HOME/k8s-infra/docker-cache/resource

docker compose up -d

# Wait until the server is ready
while ! curl --output /dev/null --silent --head --fail http://${CACHE_HOST}:${PROXY_PORT}/ca.crt; do
  echo "Waiting for URL to be ready..."
  sleep 1
done

echo "Docker cache server is ready and listening on port 3128"
