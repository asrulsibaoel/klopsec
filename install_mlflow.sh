#!/bin/bash

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