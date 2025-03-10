#!/bin/bash

# Get the tag from the argument
CI_COMMIT_TAG=$1

# Docker Hub details
USERNAME="openhubble"
REPO_NAME="cli"
IMAGE_NAME="${USERNAME}/${REPO_NAME}"

echo "🚀 Building and pushing ${IMAGE_NAME}:${CI_COMMIT_TAG} and latest"

# Build the Docker image
docker build --platform linux/amd64 -t ${IMAGE_NAME}:${CI_COMMIT_TAG} .

# Push the versioned image
docker push ${IMAGE_NAME}:${CI_COMMIT_TAG}

# Tag as latest and push
docker tag ${IMAGE_NAME}:${CI_COMMIT_TAG} ${IMAGE_NAME}:latest
docker push ${IMAGE_NAME}:latest

echo "✅ Docker image pushed successfully!"
