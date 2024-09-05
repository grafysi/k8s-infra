#!/bin/bash

ENVOY_GATEWAY_HOME=$GRAFYSI_HOME/k8s-infra/envoy-gateway

helm upgrade --install envoygateway oci://docker.io/envoyproxy/gateway-helm --version v1.1.0 -n envoy-gateway-system --create-namespace

kubectl apply -f $ENVOY_GATEWAY_HOME/resource/gateway-class.yml
kubectl apply -f $ENVOY_GATEWAY_HOME/resource/shared-gateway.yml

