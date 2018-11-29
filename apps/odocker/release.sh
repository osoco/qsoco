#!/bin/sh

REPOSITORY="nexus.osoco.es"
IMAGE_NAME="${REPOSITORY}/osoco/odocker"

mix escript.build
docker login "$REPOSITORY"
docker build -t "$IMAGE_NAME" .
docker push "$IMAGE_NAME"
