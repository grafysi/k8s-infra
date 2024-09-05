ARGOCD_PASSWORD="abcd1234"

#kubectl port-forward svc/argocd-server -n argocd 8090:443
INITIAL_PASSWORD=$(argocd admin initial-password -n argocd | head -n 1)

argocd login localhost:8090 --insecure --username admin --password $INITIAL_PASSWORD
argocd account update-password --current-password $INITIAL_PASSWORD --new-password $ARGOCD_PASSWORD