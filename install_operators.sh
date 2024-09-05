#!/bin/bash

set -o errexit

INFRA_HOME=$GRAFYSI_HOME/k8s-infra

echo "====================== INSTALL APICURIO REGISTRY OPERATOR"
cd $INFRA_HOME/apicurio-registry
bash install.sh
echo "---------------------------------------------------------"

echo "====================== INSTALL ARGOCD"
cd $INFRA_HOME/argocd
bash install.sh
echo "---------------------------------------------------------"

echo "====================== INSTALL CERT MANAGER OPERATOR"
cd $INFRA_HOME/cert-manager
bash install.sh
echo "---------------------------------------------------------"

echo "====================== INSTALL ENVOY GATEWAY OPERATOR"
cd $INFRA_HOME/envoy-gateway
bash install.sh
echo "---------------------------------------------------------"

echo "====================== INSTALL STRIMZI OPERATOR"
cd $INFRA_HOME/strimzi
bash install.sh
echo "---------------------------------------------------------"


