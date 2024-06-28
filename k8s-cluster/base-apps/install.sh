################### install cilium
CLUSTER_NAME=$GRAFYSI_CLUSTER_NAME

MASTER_NODE=${CLUSTER_NAME}-control-plane
MASTER_NODE_IP=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $MASTER_NODE)

BASE_APPS_RESOURCE=$GRAFYSI_HOME/k8s-infra/k8s-cluster/base-apps/resource

helm upgrade --install cilium cilium/cilium --version 1.15.6 \
  --namespace kube-system \
  --values $BASE_APPS_RESOURCE/cilium-values.yml \
  --set k8sServiceHost=${MASTER_NODE_IP} \
  --set k8sServicePort=6443 \


################## install haproxy-ingress controller
helm upgrade --install haproxy-ingress haproxytech/kubernetes-ingress \
  --create-namespace \
  --namespace haproxy-controller \
  --values $BASE_APPS_RESOURCE/haproxy-ingress-values.yml