#!/bin/bash
set -o errexit

NFS_HOME=$GRAFYSI_HOME/k8s-infra/nfs-server
NFS_CONF=$GRAFYSI_CONFIG/nfs-server

mkdir -p $NFS_CONF/disk
cp $NFS_HOME/resource/nfs_exports $NFS_CONF/exports
cp $NFS_HOME/resource/apparmor_profile /etc/apparmor.d/erichough_nfs
apparmor_parser -r /etc/apparmor.d/erichough_nfs

CONTAINER_NAME='gfs-nfs-server'

if [ "$(docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}" 2>/dev/null || true)" != 'true' ]; then
  docker compose -f $NFS_HOME/resource/compose.yml up -d
fi

chown -R $USER:$USER $NFS_CONF
chmod -R 777 $NFS_CONF