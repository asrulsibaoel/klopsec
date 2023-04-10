#!/bin/bash
gcloud container clusters get-credentials $CLUSTER_NAME --region $GCP_REGION --project $PROJECT_ID
kubectl create namespace seldon-system

helm install seldon-core seldon-core-operator \
    --repo https://storage.googleapis.com/seldon-charts \
    --set usageMetrics.enabled=true \
    --namespace seldon-system \
    --set istio.enabled=true

kubectl create namespace seldon


