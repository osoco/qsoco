#!/bin/sh

IMAGE_NAME="osoco/odocker"
CONTAINER_NAME="odocker"
if ! command -v docker > /dev/null; then
  echo "Docker not installed, please install it to use odocker."
  exit 1
fi

ODOCKERS_UP=$(docker container ls -a -q -f "name=$CONTAINER_NAME" | wc -l | tr -d ' ');

if [ "$ODOCKERS_UP" != "1" ] ; then
  echo "Starting odocker..."
  docker run -d -v /var/run/docker.sock:/var/run/docker.sock --name $CONTAINER_NAME $IMAGE_NAME tail -f /dev/null >> /dev/null
  RESULT=$?
  if [ $RESULT -ne 0 ] ; then
     echo "Error starting odocker: $RESULT"
  fi
fi 
#echo "go! ${1} ${2} ${3} ${4}"

docker exec odocker ./odocker $1 $2 $3 $4 $5
