#!/usr/bin/env bash

set -e

if [ $# -ne 1 ]; then
    echo "Please provide a single semver version (without a \"v\" prefix) to test the repository against, e.g 0.99.0"
    exit 1
fi

bucket=gs://feast-helm-charts
repo_url=https://feast-helm-charts.storage.googleapis.com/

helm plugin install https://github.com/hayorov/helm-gcs.git || true

helm repo add feast-helm-chart-repo $bucket

helm package infra/charts/feast-core
helm package infra/charts/feast-serving

helm gcs push feast-core-${1}.tgz feast-helm-chart-repo
helm gcs push feast-serving-${1}.tgz feast-helm-chart-repo