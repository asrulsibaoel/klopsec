#!/bin/bash
# gcloud container clusters get-credentials $CLUSTER_NAME --zone $GCP_ZONE --project $PROJECT_ID
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION TARGET_ARCH=x86_64 sh -

cd istio-$ISTIO_VERSION && export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
cd ../

istioctl install -f istio/istio-with-extra-ports.yaml -y
kubectl create namespace seldon-system
kubectl create namespace seldon-monitoring

kubectl apply -f ./seldon-core/ingress-gateway.yaml

helm install seldon-core seldon-core-operator \
    --repo https://storage.googleapis.com/seldon-charts \
    --set usageMetrics.enabled=true \
    --namespace seldon-system \
    --set istio.enabled=true

kubectl create namespace seldon

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export INGRESS_URL=$INGRESS_HOST:$INGRESS_PORT
echo "Here is your Ingress gateway for Deployed Model to Seldon: $INGRESS_URL"

echo "Deploying Example models..."
kubectl apply -f examples/model.example.yaml
echo "Kindly check the deployed model here: $INGRESS_URL/seldon/seldon/iris-model/api/v1.0/doc/"


echo "Creating MLflow instance..."
kubectl create namespace mlflow
kubectl label namespace mlflow istio-injection=enabled

helm install -n mlflow \
    mlflow ./mlflow-docker \
    --set image.repository=$IMG \
    --set image.tag=$TAG \
    --set env.POSTGRES_USERNAME=$POSTGRES_USERNAME \
    --set env.POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
    --set env.POSTGRES_HOST=$POSTGRES_HOST \
    --set env.POSTGRES_PORT=$POSTGRES_PORT \
    --set env.POSTGRES_DB_NAME=$POSTGRES_DB_NAME \
    --set env.BUCKET_NAME=$BUCKET_NAME \
    --set env.PORT=$PORT

echo "Check your Mlflow dashboard here: $INGRESS_HOST:$PORT"

echo "All setups are done."