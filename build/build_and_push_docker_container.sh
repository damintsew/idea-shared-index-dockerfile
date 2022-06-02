
echo "Start"

helpFunction()
{
   echo ""
   echo "Usage: $0 -v -p docker.io -d idea/goland"
   echo -e "\t-v Optional is not specified SNAPSHOT suffix will be added"
   echo -e "\t-p Docker provider selection"
   echo -e "\t-d Intellij idea or goland version"
   exit 1 # Exit script after printing help
}

while getopts "v:p:d:" opt
do
   case "$opt" in
      v ) SNAPSHOT_SUFFIX="$OPTARG" ;;
      p ) DOCKER_PROVIDER="$OPTARG" ;;
      d ) DOCKERFILE="$OPTARG" ;;
      ? ) helpFunction ;;
   esac
done

if [ -z "$DOCKER_PROVIDER" ] || [ -z "$DOCKERFILE" ]
then
   echo "Some parameters are empty";
   helpFunction
fi

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
