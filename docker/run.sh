#!/bin/sh

set -e

if [ -z "${POSTGRES_USERNAME}" ]; then
  echo >&2 "POSTGRES_USERNAME must be set"
  exit 1
fi

if [ -z "${POSTGRES_PASSWORD}" ]; then
  echo >&2 "POSTGRES_PASSWORD must be set"
  exit 1
fi

if [ -z "${POSTGRES_HOST}" ]; then
  echo >&2 "POSTGRES_HOST must be set"
  exit 1
fi

if [ -z "${POSTGRES_PORT}" ]; then
  echo >&2 "POSTGRES_PORT must be set"
  exit 1
fi

if [ -z "${POSTGRES_DB_NAME}" ]; then
  echo >&2 "POSTGRES_DB_NAME must be set"
  exit 1
fi

if [ -z "${BUCKET_NAME}" ]; then
  echo >&2 "BUCKET_NAME must be set"
  exit 1
fi


# mkdir -p "${FILE_DIR}"

mlflow server \
    --backend-store-uri postgresql://$POSTGRES_USERNAME:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB_NAME \
    --default-artifact-root "$BUCKET_NAME/mlflow/artifacts" \
    --host 0.0.0.0 \
    --port "$PORT"
