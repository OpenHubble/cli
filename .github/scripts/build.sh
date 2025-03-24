#!/bin/bash

# Get the tag from the argument
CI_COMMIT_TAG=$1

# Docker Hub details
USERNAME="openhubble"
REPO_NAME="cli"
IMAGE_NAME="${USERNAME}/${REPO_NAME}"

echo "🚀 Building and pushing ${IMAGE_NAME}:${CI_COMMIT_TAG} and latest for multiple architectures"

# Enable Buildx if not already enabled
docker buildx create --use || true

# Build and push the multi-architecture image
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ${IMAGE_NAME}:${CI_COMMIT_TAG} \
  -t ${IMAGE_NAME}:latest \
  --push .

echo "✅ Docker images pushed successfully!"
