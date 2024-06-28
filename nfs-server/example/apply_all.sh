EXAMPLE_DIR=$GRAFYSI_HOME/k8s-infra/nfs-server/example
kubectl apply -f $EXAMPLE_DIR/nfs_sc.yml
kubectl apply -f $EXAMPLE_DIR/nfs_pvc.yml
kubectl apply -f $EXAMPLE_DIR/nfs_pvc2.yml
kubectl apply -f $EXAMPLE_DIR/nginx_pod.yml
kubectl apply -f $EXAMPLE_DIR/nginx_pod2.yml


