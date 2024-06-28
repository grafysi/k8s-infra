#!/bin/bash
set -o errexit

STORAGE_SERVER_HOME=$GRAFYSI_HOME/k8s-infra/storage-server
STORAGE_SERVER_CONF=$GRAFYSI_CONFIG/storage-server

mkdir -p $STORAGE_SERVER_CONF/data

CONTAINER_NAME='gfs-storage-server'

if [ "$(docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}" 2>/dev/null || true)" != 'true' ]; then
  docker compose -f $STORAGE_SERVER_HOME/resource/compose.yml up -d
fi