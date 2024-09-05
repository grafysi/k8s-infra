#!/bin/bash

APICURIO_REGISTRY_HOME=$GRAFYSI_HOME/k8s-infra/apicurio-registry


NAMESPACE=apicurio

kubetl get ns apicurio || kubectl create ns $NAMESPACE

cat $APICURIO_REGISTRY_HOME/resource/manifest-stable.yml |
sed "s/apicurio-registry-operator-namespace/$NAMESPACE/g" | kubectl apply -f - -n $NAMESPACE