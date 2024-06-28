#!/bin/bash

set -o errexit

ROOT_CA_DIR=$GRAFYSI_CONFIG/cert-authority

DOMAIN=grafysi-ca.com

mkdir -p $ROOT_CA_DIR

if [ -f $ROOT_CA_DIR/rootCA.crt ] && [ -f $ROOT_CA_DIR/rootCA.key ]; then
  echo "Root certificate existed, no need to re-create."
else
  openssl genrsa -out $ROOT_CA_DIR/rootCA.key 4096

  openssl req -x509 -new -nodes -key $ROOT_CA_DIR/rootCA.key -sha256 -days 1024 \
    -subj "/C=VN/ST=HCMC/O=Grafysi, Inc./CN=${DOMAIN}" \
    -out $ROOT_CA_DIR/rootCA.crt
fi


