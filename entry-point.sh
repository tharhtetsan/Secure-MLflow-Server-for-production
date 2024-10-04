#!/bin/sh

#set -e

# Verify that all required variables are set
if [[ -z "${GCP_PROJECT}" ]]; then
    echo "Error: GCP_PROJECT not set"
    exit 1
fi

#export GOOGLE_APPLICATION_CREDENTIALS="/app/credentials/serviceAccount.json"
#echo $GOOGLE_APPLICATION_CREDENTIALS

# Fetch secrets from Secret Manager in CGP
export MLFLOW_TRACKING_USERNAME="$(python3 /app/get_secret.py --project="${GCP_PROJECT}" --secret=mlflow_tracking_username)"
export MLFLOW_TRACKING_PASSWORD="$(python3 /app/get_secret.py --project="${GCP_PROJECT}" --secret=mlflow_tracking_password)"
export ARTIFACT_URL="$(python3 /app/get_secret.py --project="${GCP_PROJECT}" --secret=mlflow_artifact_url)"
export DATABASE_URL="$(python3 /app/get_secret.py --project="${GCP_PROJECT}" --secret=mlflow_database_url)"

if [[ -z "${DATABASE_URL}" ]]; then # Allow overriding for local deployment
    export DATABASE_URL="$(python3 /app/get_secret.py --project="${GCP_PROJECT}" --secret=mlflow_database_url)"
fi

# Verify that all required variables are set
if [[ -z "${MLFLOW_TRACKING_USERNAME}" ]]; then
    echo "Error: MLFLOW_TRACKING_USERNAME not set"
    exit 1
fi

if [[ -z "${MLFLOW_TRACKING_PASSWORD}" ]]; then
    echo "Error: MLFLOW_TRACKING_PASSWORD not set"
    exit 1
fi

if [[ -z "${ARTIFACT_URL}" ]]; then
    echo "Error: ARTIFACT_URL not set"
    exit 1
fi

if [[ -z "${DATABASE_URL}" ]]; then
    echo "Error: DATABASE_URL not set"
    exit 1
fi

if [[ -z "${PORT}" ]]; then
    export PORT=8080
fi

if [[ -z "${HOST}" ]]; then
    export HOST=0.0.0.0
fi

export WSGI_AUTH_CREDENTIALS="${MLFLOW_TRACKING_USERNAME}:${MLFLOW_TRACKING_PASSWORD}"

# Start MLflow and ngingx using supervisor
exec  mlflow server  --host 0.0.0.0 --port 8080 --default-artifact-root ${ARTIFACT_URL}  --backend-store-uri ${DATABASE_URL}