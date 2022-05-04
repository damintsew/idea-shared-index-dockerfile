
echo "Start"

while getopts "v:p:d:" opt
do
   case "$opt" in
      v ) SNAPSHOT_SUFFIX="$OPTARG" ;;
      p ) DOCKER_PROVIDER="$OPTARG" ;;
      d ) DOCKERFILE="$OPTARG" ;;
      ? ) echo "todo print help" # https://unix.stackexchange.com/questions/31414/how-can-i-pass-a-command-line-argument-into-a-shell-script
   esac
done

if [ -z "${SNAPSHOT_SUFFIX}" ]; then
    SNAPSHOT_SUFFIX='-snapshot'
else
    SNAPSHOT_SUFFIX=""
fi

filename=./versions-${DOCKERFILE}.properties

while read VERSION_INDEX; do

  IMAGE_NAME=${DOCKER_PROVIDER}/damintsew/indexer-${DOCKERFILE}-${VERSION_INDEX}${SNAPSHOT_SUFFIX}
  echo "Build image for version $IMAGE_NAME"
  echo "CMD: docker build --build-arg INTELLIJ_VERSION=""${VERSION_INDEX}"" --file images/Dockerfile-${DOCKERFILE} --tag ""${IMAGE_NAME}"" ."

  docker build --build-arg INTELLIJ_VERSION="${VERSION_INDEX}" --file images/Dockerfile-${DOCKERFILE} \
   --tag "${IMAGE_NAME}" .

  echo "Push image for version $IMAGE_NAME"
  docker push "$IMAGE_NAME"

done < "$filename"
