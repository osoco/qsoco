#!/bin/sh

REPOSITORY="nexus.osoco.es"
IMAGE_NAME="${REPOSITORY}/osoco/odocker"

die() {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "version argument required. Example: ./release.sh 0.55"

mix test
mix escript.build

echo $1 >> version

docker login "$REPOSITORY"
docker build -t "$IMAGE_NAME" .
docker push "$IMAGE_NAME"
