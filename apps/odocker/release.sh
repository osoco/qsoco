#!/bin/sh

REPOSITORY="https://index.docker.io/v1/"
IMAGE_NAME="jorgeosoco/odocker"

die() {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "version argument required. Example: ./release.sh 0.55"

mix test
mix escript.build

rm version
echo $1 >> version

docker login "$REPOSITORY"
docker build -t "$IMAGE_NAME" .
docker push "$IMAGE_NAME"
