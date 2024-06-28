#!/bin/bash
set -o errexit

DATA_DIR=$GRAFYSI_CONFIG/docker-registry/data

mkdir -p $DATA_DIR

REG_CONTAINER='gfs-docker-registry'


if [ "$(docker inspect -f '{{.State.Running}}' "${REG_CONTAINER}" 2>/dev/null || true)" != 'true' ]; then
  docker compose -f $GRAFYSI_HOME/k8s-infra/docker-registry/resource/compose.yml up -d
fi
