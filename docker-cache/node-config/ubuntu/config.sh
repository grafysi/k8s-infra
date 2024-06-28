#!/bin/bash

PROXY_HOST=$GRAFYSI_DOCKER_CACHE_HOST
PROXY_PORT=3128

# configure docker proxy and nginx server ca certificate
mkdir -p /etc/systemd/system/docker.service.d
cat << EOD > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${PROXY_HOST}:${PROXY_PORT}/"
Environment="HTTPS_PROXY=http://${PROXY_HOST}:${PROXY_PORT}/"
Environment="NO_PROXY=localhost,127.0.0.1,gfscr.io,${PROXY_HOST}"
EOD

# Check if docker_registry_proxy.crt exists
echo "Downloading CA certificate from proxy..."
curl "${PROXY_HOST}:${PROXY_PORT}/ca.crt" > /usr/local/share/ca-certificates/docker_registry_proxy.crt

update-ca-certificates --fresh

echo "Reloading systemd and dockerd..."

# Reload systemd
systemctl daemon-reload

# Restart dockerd
systemctl restart docker.service

while true; do
  if systemctl is-active --quiet docker.service; then
    echo "docker.service is active and ready"
    break
  else
    echo "Waiting for docker.service to become active and ready..."
    sleep 1
  fi
done

sleep 3

echo "Completed"
