#!/usr/bin/env bash
set -e
# See https://github.com/BulbEnergy/bulb-server-common

GCP_KEY=${!1:-$GCP_SERVICE_KEY}

if [ -z ${GCP_KEY} ]; then
  echo "Project not set up correctly - need GCP_SERVICE_KEY!"
  exit 1
fi

echo "${GCP_KEY}" > account-credentials.json
gcloud auth activate-service-account --key-file=account-credentials.json

if [ ! -z $PROJECT_NAME ]; then
  GCLOUD_PROJECT="$(gcloud projects list --format="value(projectId)" --filter="name=${PROJECT_NAME}")"
  gcloud config set project ${GCLOUD_PROJECT}

  GCLOUD_CLUSTER=$(gcloud container clusters list --format="value(name)" --filter="name ~ ${PROJECT_NAME}")
  GCLOUD_ZONE=$(gcloud container clusters list --format="value(location)" --filter="name ~ ${PROJECT_NAME}")
fi

# GCLOUD_ZONE is defined in the `bulbenrg-default` context but if context isn't used fall back to the default value
GCLOUD_ZONE=${GCLOUD_ZONE:-"europe-west1-c"}

gcloud container clusters get-credentials ${GCLOUD_CLUSTER} --zone ${GCLOUD_ZONE} --project ${GCLOUD_PROJECT}

echo "export GCLOUD_CLUSTER=${GCLOUD_CLUSTER}" >> $BASH_ENV
echo "export GCLOUD_PROJECT=${GCLOUD_PROJECT}" >> $BASH_ENV
echo "export GCLOUD_ZONE=${GCLOUD_ZONE}" >> $BASH_ENV

gcloud config set project ${GCLOUD_PROJECT}
gcloud auth configure-docker

source $BASH_ENV

rm account-credentials.json