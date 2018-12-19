#!/bin/sh

IMAGE_NAME="jorgeosoco/odocker"
CONTAINER_NAME="odocker"
if ! command -v docker > /dev/null; then
  echo "Docker not installed, please install it to use odocker."
  exit 1
fi

ODOCKERS_UP=$(docker container ls -q -f "name=$CONTAINER_NAME" | wc -l | tr -d ' ');

if [ "$ODOCKERS_UP" != "1" ] ; then

  STOPPED_DOCKER=$(docker container ls -a -q -f "name=$CONTAINER_NAME")

  if [ -z $STOPPED_DOCKER ]; then
      echo "Starting odocker container..."
      docker run -d -v /var/run/docker.sock:/var/run/docker.sock --name $CONTAINER_NAME $IMAGE_NAME tail -f /dev/null 2> /dev/null
      RESULT=$?
      if [ $RESULT -ne 0 ] ; then
         echo "Error starting odocker: $RESULT"
      fi
  else
      docker start $STOPPED_DOCKER 2> /dev/null
  fi
fi 
#echo "go! ${1} ${2} ${3} ${4}"

if [ "$1" == "autoClean" ] ; then
  echo "Removing odocker container and image..."
  docker rm -f $CONTAINER_NAME
  docker rmi -f $IMAGE_NAME
else
  docker exec odocker ./odocker $1 $2 $3 $4 $5
fi
