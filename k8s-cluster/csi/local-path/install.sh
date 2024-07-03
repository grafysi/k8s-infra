#!/bin/bash
set -o errexit

CSI_HOME=$GRAFYSI_HOME/k8s-infra/k8s-cluster/csi

helm repo add containeroo https://charts.containeroo.ch

helm install local-path-provisioner containeroo/local-path-provisioner \
  --version 0.0.30 --create-namespace --namespace local-path-storage \
  --values $CSI_HOME/local-path/resource/values.yml