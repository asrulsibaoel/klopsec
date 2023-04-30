#!/bin/bash
export POD_NAME=$(kubectl get pods --namespace mlflow -l "app.kubernetes.io/name=mlflow-tracking,app.kubernetes.io/instance=mlflow" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace mlflow $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:5000 to use your application"
kubectl --namespace mlflow port-forward $POD_NAME 5000:$CONTAINER_PORT