#!/bin/bash

NEO4J_HOME=$GRAFYSI_HOME/k8s-infra/neo4j

helm upgrade --install instance1 neo4j/neo4j \
  --values $NEO4J_HOME/resource/neo4j_values.yml \
  --create-namespace \
  --namespace neo4j

helm upgrade --install rp neo4j/neo4j-reverse-proxy \
  --values $NEO4J_HOME/resource/neo4j_rp_values.yml \
  --create-namespace \
  --namespace neo4j