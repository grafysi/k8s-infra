STRIMZI_HOME=$GRAFYSI_HOME/k8s-infra/strimzi

helm repo add strimzi https://strimzi.io/charts/

helm upgrade --install strimzi-operator strimzi/strimzi-kafka-operator \
  --namespace strimzi --create-namespace \
  --values $STRIMZI_HOME/resource/strimzi-values.yml