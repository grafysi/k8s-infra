#!/bin/bash
set -o errexit

PROXY_CONFIG=$GRAFYSI_CONFIG/reverse-proxy

CONTAINER_NAME=gfs-reverse-proxy

KIND_NAME=$GRAFYSI_CLUSTER_NAME



mkdir -p $PROXY_CONFIG

cp $GRAFYSI_HOME/k8s-infra/reverse-proxy/resource/base_haproxy.cfg $PROXY_CONFIG/haproxy.cfg

mkdir -p $PROXY_CONFIG/certs

cd $PROXY_CONFIG/certs

# domains
ROOT_CA_KEY=$GRAFYSI_CONFIG/cert-authority/rootCA.key
ROOT_CA_CRT=$GRAFYSI_CONFIG/cert-authority/rootCA.crt
DOMAINS=( "gfscr.io" "grafysi.com" )

for DOMAIN in "${DOMAINS[@]}"; do
  # creat a backup dir to store certs of domain
  mkdir -p $PROXY_CONFIG/certs/${DOMAIN}
  cd $PROXY_CONFIG/certs/${DOMAIN}
  
  # generate private key for domain
  openssl genrsa -out ${DOMAIN}.key 2048
  
  # create signing
  openssl req -new -sha256 \
    -key ${DOMAIN}.key \
    -subj "/C=VN/ST=HCMC/O=Grafysi/CN=${DOMAIN}" \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:${DOMAIN}")) \
    -out ${DOMAIN}.csr
  
  # generate domain certificate
  openssl x509 -req -extfile <(printf "subjectAltName=DNS:${DOMAIN}") -days 365 \
    -in ${DOMAIN}.csr -CA $ROOT_CA_CRT -CAkey $ROOT_CA_KEY -CAcreateserial -out ${DOMAIN}.crt -sha256
  
  # bundle to pem file for haproxy config
  cat ${DOMAIN}.key ${DOMAIN}.crt > $PROXY_CONFIG/certs/${DOMAIN}.pem
done

# write k8s nodes info
K8S_NODES_FILE=$GRAFYSI_CONFIG/reverse-proxy/k8s_nodes
echo "$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}:{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}')" > $K8S_NODES_FILE

EXTRA_K8S_NODES_FILE=$GRAFYSI_HOME/k8s-infra/reverse-proxy/resource/extra_k8s_nodes.env
cat $EXTRA_K8S_NODES_FILE >> $K8S_NODES_FILE

# write backend definitions into haproxy.cfg

HAPROXY_CFG_FILE=$PROXY_CONFIG/haproxy.cfg

# k8s_cluster backend
echo "backend k8s_cluster" >> $HAPROXY_CFG_FILE
echo "  balance roundrobin" >> $HAPROXY_CFG_FILE

for LINE in $(echo $(cat ${K8S_NODES_FILE}) | xargs)
do
  NODE_VALUES=(${LINE//:/ })
  NODE_NAME=${NODE_VALUES[0]}
  NODE_IP=${NODE_VALUES[1]}
  echo "  server ${NODE_NAME} ${NODE_IP}:30000" >> $HAPROXY_CFG_FILE
done

echo "" >> $HAPROXY_CFG_FILE

# tls-gateway backend
echo "backend tls_gateway_back" >> $HAPROXY_CFG_FILE
echo "  mode tcp" >> $HAPROXY_CFG_FILE
echo "  balance roundrobin" >> $HAPROXY_CFG_FILE

for LINE in $(echo $(cat ${K8S_NODES_FILE}) | xargs)
do
  NODE_VALUES=(${LINE//:/ })
  NODE_NAME=${NODE_VALUES[0]}
  NODE_IP=${NODE_VALUES[1]}
  echo "  server ${NODE_NAME} ${NODE_IP}:30443" >> $HAPROXY_CFG_FILE
done
echo "" >> $HAPROXY_CFG_FILE


# http-gateway backend
echo "backend http_gateway_back" >> $HAPROXY_CFG_FILE
echo "  mode tcp" >> $HAPROXY_CFG_FILE
echo "  balance roundrobin" >> $HAPROXY_CFG_FILE

for LINE in $(echo $(cat ${K8S_NODES_FILE}) | xargs)
do
  NODE_VALUES=(${LINE//:/ })
  NODE_NAME=${NODE_VALUES[0]}
  NODE_IP=${NODE_VALUES[1]}
  echo "  server ${NODE_NAME} ${NODE_IP}:30080" >> $HAPROXY_CFG_FILE
done
echo "" >> $HAPROXY_CFG_FILE



# private registry backend
echo "backend docker_registry" >> $HAPROXY_CFG_FILE
echo "  balance roundrobin" >> $HAPROXY_CFG_FILE
echo "  server docker-registry ${GRAFYSI_DOCKER_REGISTRY_HOST}:5000" >> $HAPROXY_CFG_FILE


if [ "$(docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}" 2>/dev/null || true)" != 'true' ]; then
  docker compose -f $GRAFYSI_HOME/k8s-infra/reverse-proxy/resource/compose.yml up -d
fi








