
filename='./supported_versions.properties'
echo "Start"

#Checking if need to build release dependency
if [ -z "$1" ]; then
    SNAPSHOT_SUFFIX='-snapshot'
else
    SNAPSHOT_SUFFIX=""
fi

#Set Docker provider based on input params
if [ -z "$2" ]; then
    DOCKER_PROVIDER='docker.io'
else
    DOCKER_PROVIDER="ghcr.io"
fi

while read VERSION_INDEX; do

  IMAGE_NAME=${DOCKER_PROVIDER}/damintsew/indexer-${VERSION_INDEX}${SNAPSHOT_SUFFIX}
  echo "Build image for version $IMAGE_NAME"
  docker build . --build-arg INTELLIJ_VERSION=ideaIU-"${VERSION_INDEX}" --file Dockerfile \
   --tag "${IMAGE_NAME}" --tag ghcr.io/"${IMAGE_NAME}"

  echo "Push image for version $IMAGE_NAME"
#  docker push "$IMAGE_NAME"
  docker push ghcr.io/"$IMAGE_NAME"

done < "$filename"