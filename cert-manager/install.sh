helm repo add jetstack https://charts.jetstack.io --force-update

helm upgrade --install cert-manager jetstack/cert-manager \
    --create-namespace \
    --namespace certmanager \
    --version v1.15.3 \
    --set installCRDs=true