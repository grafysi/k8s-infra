#!/bin/bash

set -o errexit

CERT_NAME=grafysi_authority

KIND_NAME=$GRAFYSI_CLUSTER_NAME

GRAFYSI_ROOT_CA_CRT=$GRAFYSI_CONFIG/cert-authority/rootCA.crt

for NODE in $(kind get nodes --name=${KIND_NAME}); do
  docker cp $GRAFYSI_ROOT_CA_CRT $NODE:/usr/local/share/ca-certificates/${CERT_NAME}.crt
  docker exec $NODE update-ca-certificates --fresh
done
