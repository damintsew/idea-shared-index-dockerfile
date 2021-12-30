
filename='./goland_versions.properties'
echo "Start"

#Checking if need to build release dependency
if [ -z "$1" ]; then
    SNAPSHOT_SUFFIX='-snapshot'
else
    SNAPSHOT_SUFFIX=""
fi

while read VERSION_INDEX; do

  IMAGE_NAME=damintsew/go-indexer-${VERSION_INDEX}${SNAPSHOT_SUFFIX}
  echo "Build image for version $IMAGE_NAME"
  docker build . --build-arg INTELLIJ_VERSION="${VERSION_INDEX}" --file images/GO-indexer-Dockerfile --tag "${IMAGE_NAME}"

  echo "Push image for version $IMAGE_NAME"
  docker push "$IMAGE_NAME"

done < "$filename"