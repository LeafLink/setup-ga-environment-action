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

DOCKER_TAGS_WITH_REPO=$(echo "${DOCKER_TAGS}" | tr "," "\n" | sed "s%^\(.*\)$%${AWS_ECR_BASE}/${REPO_NAME}:\1%" | tr "\n" "," | sed "s/,$//");

echo "AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID}" >> $GITHUB_ENV;
echo "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" >> $GITHUB_ENV;
echo "AWS_REGION=${AWS_DEFAULT_REGION}" >> $GITHUB_ENV;
echo "AWS_ECR_BASE=${AWS_ECR_BASE}" >> $GITHUB_ENV;

echo "DOCKER_TAG=${DOCKER_TAG}" >> $GITHUB_ENV;
echo "DOCKER_TAGS=${DOCKER_TAGS}" >> $GITHUB_ENV;
echo "DOCKER_TAGS_WITH_REPO=${DOCKER_TAGS_WITH_REPO}" >> $GITHUB_ENV;
echo "SHORT_COMMIT_SHA=${SHORT_SHA}" >> $GITHUB_ENV;

echo "REPO_NAME=${REPO_NAME}" >> $GITHUB_ENV;

# Setup Lint-er
curl -s https://raw.githubusercontent.com/LeafLink/ci-tools/add-yamlint/.yamlint > $GITHUB_WORKSPACE/.yamlint;
