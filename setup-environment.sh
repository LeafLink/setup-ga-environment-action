#!/bin/bash

set -ev

AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID:-470196620241}";
AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-west-2}";
AWS_ECR_BASE="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com";

REPO_NAME="${REPO_NAME:-$(echo $GITHUB_REPOSITORY | awk -F '/' '{print $2}')}";
SHORT_SHA="${GITHUB_SHA:0:7}"

DOCKER_TAG="${SHORT_SHA}"
DOCKER_TAGS="${SHORT_SHA}"
if [ "${GITHUB_REF}" == "refs/heads/master" ] || [ "${GITHUB_REF}" == "refs/heads/main" ]; then
    DOCKER_TAG="master-${SHORT_SHA}"
    DOCKER_TAGS="master-${SHORT_SHA},master,latest"
fi

if [[ ! -z "${PR_NUMBER}" ]]; then
    DOCKER_TAG="PR-${PR_NUMBER}"
    DOCKER_TAGS="PR-${PR_NUMBER}"
fi

if [[ ! -z "${RELEASE_TAG}" ]]; then
    DOCKER_TAG="${RELEASE_TAG}"
    DOCKER_TAGS="${RELEASE_TAG},stable"
fi


echo "AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID}" >> $GITHUB_ENV;
echo "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" >> $GITHUB_ENV;
echo "AWS_REGION=${AWS_DEFAULT_REGION}" >> $GITHUB_ENV;
echo "AWS_ECR_BASE=${AWS_ECR_BASE}" >> $GITHUB_ENV;

echo "DOCKER_TAG=${DOCKER_TAG}" >> $GITHUB_ENV;
echo "DOCKER_TAGS=${DOCKER_TAGS}" >> $GITHUB_ENV;

echo "REPO_NAME=${REPO_NAME}" >> $GITHUB_ENV;
