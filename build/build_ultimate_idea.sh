
filename='../supported_versions.properties'
echo "Start"

if [ -z "${IS_RELEASE}" ]; then
    SNAPSHOT_SUFFIX='-snapshot'
else
    SNAPSHOT_SUFFIX=""
fi

while read VERSION_INDEX; do

  IMAGE_NAME=damintsew/indexer-${VERSION_INDEX}${SNAPSHOT_SUFFIX}
  echo "Build image for version $IMAGE_NAME"
  docker build ../ --build-arg INTELLIJ_VERSION=ideaIU-"${VERSION_INDEX}" --file ../Dockerfile --tag "${IMAGE_NAME}"

  echo "Push image for version $IMAGE_NAME"
  docker push "$IMAGE_NAME"

done < "$filename"