#!/bin/bash

DOCKER_USERNAME="353pongsakorn"
REPO_NAME="pongsakorn-tananon-353" 

echo "Building and Pushing multi-platform images (frontend & backend) to: $DOCKER_USERNAME/$REPO_NAME"

docker buildx create --use --name mybuilder 2>/dev/null || docker buildx use mybuilder

echo "--------------------------------------"
echo "Processing Frontend..."
docker buildx build --platform linux/amd64,linux/arm64 \
  -t $DOCKER_USERNAME/$REPO_NAME:frontend \
  --push ./frontend

echo "--------------------------------------"
echo "Processing Backend..."
docker buildx build --platform linux/amd64,linux/arm64 \
  -t $DOCKER_USERNAME/$REPO_NAME:backend \
  --push ./backend

echo "--------------------------------------"
echo "Done!"
echo "Images pushed to:"
echo " - $DOCKER_USERNAME/$REPO_NAME:frontend"
echo " - $DOCKER_USERNAME/$REPO_NAME:backend"