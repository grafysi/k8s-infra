#!/bin/bash

set -o errexit

CERT_NAME=grafysi_authority
GRAFYSI_ROOT_CA_CRT=$GRAFYSI_CONFIG/cert-authority/rootCA.crt

cp $GRAFYSI_ROOT_CA_CRT /usr/local/share/ca-certificates/${CERT_NAME}.crt

update-ca-certificates --fresh

