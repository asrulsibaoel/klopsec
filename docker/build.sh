#!/bin/bash
gcloud auth configure-docker asia-southeast2-docker.pkg.dev

docker-compose -f docker/docker-compose.yml build
docker-compose -f docker/docker-compose.yml push