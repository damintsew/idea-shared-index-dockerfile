
filename='./supported_versions.properties'
echo "Start"

#Checking if need to build release dependency


#Set Docker provider based on input params
#if [ -z "$2" ]; then
#    DOCKER_PROVIDER='docker.io'
#else
#    DOCKER_PROVIDER="ghcr.io"
#fi

while getopts "v:p:" opt
do
   case "$opt" in
      v ) SNAPSHOT_SUFFIX="$OPTARG" ;;
      p ) DOCKER_PROVIDER="$OPTARG" ;;
      ? ) echo "help" # https://unix.stackexchange.com/questions/31414/how-can-i-pass-a-command-line-argument-into-a-shell-script
   esac
done

if [ -z "${SNAPSHOT_SUFFIX}" ]; then
    SNAPSHOT_SUFFIX='-snapshot'
else
    SNAPSHOT_SUFFIX=""
fi

while read VERSION_INDEX; do

  IMAGE_NAME=${DOCKER_PROVIDER}/damintsew/indexer-${VERSION_INDEX}${SNAPSHOT_SUFFIX}
  echo "Build image for version $IMAGE_NAME"
  docker build . --build-arg INTELLIJ_VERSION=ideaIU-"${VERSION_INDEX}" --file Dockerfile \
   --tag "${IMAGE_NAME}" --tag "${IMAGE_NAME}"

  echo "Push image for version $IMAGE_NAME"
  docker push "$IMAGE_NAME"

done < "$filename"