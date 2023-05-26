#!/bin/bash
kubectl create namespace seldon-monitoring

helm upgrade --install seldon-monitoring kube-prometheus \
    --version 8.3.2 \
    --set fullnameOverride=seldon-monitoring \
    --namespace seldon-monitoring \
    --repo https://charts.bitnami.com/bitnami

kubectl rollout status -n seldon-monitoring statefulsets/prometheus-seldon-monitoring-prometheus

kubectl apply -f ./seldon-core/seldon-monitoring.peerauth.yaml
kubectl apply -f ./seldon-core/seldon-monitoring.podmonitor.yaml
kubectl apply -f ./seldon-core/seldon-monitoring.service.yaml
kubectl apply -f ./seldon-core/seldon-monitoring.serviceaccount.yaml
kubectl apply -f ./seldon-core/seldon-monitoring.virtualservice.yaml