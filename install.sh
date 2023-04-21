#!/bin/bash
gcloud container clusters get-credentials $CLUSTER_NAME --zone $GCP_ZONE --project $PROJECT_ID
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION TARGET_ARCH=x86_64 sh -

cd istio-$ISTIO_VERSION && export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled

kubectl create namespace seldon-system

helm install seldon-core seldon-core-operator \
    --repo https://storage.googleapis.com/seldon-charts \
    --set usageMetrics.enabled=true \
    --namespace seldon-system \
    --set istio.enabled=true

kubectl create namespace seldon
kubectl create namespace mlflow

helm install -f values.yaml mlflow ./