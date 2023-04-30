#!/bin/bash
kubectl create namespace seldon-monitoring

helm upgrade --install seldon-monitoring kube-prometheus \
    --version 8.3.2 \
    --set fullnameOverride=seldon-monitoring \
    --namespace seldon-monitoring \
    --repo https://charts.bitnami.com/bitnami

kubectl rollout status -n seldon-monitoring statefulsets/prometheus-seldon-monitoring-prometheus

kubectl apply -f ./seldon-core/prometheus.monitoring.yaml
