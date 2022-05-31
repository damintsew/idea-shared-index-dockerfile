#echo `git status`

echo "Start"

#while getopts "c:p:" opt
#do
#   case "$opt" in
#      v ) COMMIT_ID="$OPTARG" ;;
#      p ) PROJECT_ID="$OPTARG" ;;
#      ? ) echo "todo print help" # https://unix.stackexchange.com/questions/31414/how-can-i-pass-a-command-line-argument-into-a-shell-script
#   esac
#done


for file in $(ls "/opt/scripts/before_execution/"| sort -r); do
  echo "Executing file $file"
  bash "$file" || break  # execute successfully or break
  # Or more explicitly: if this execution fails, then stop the `for`:
  # if ! bash "$f"; then break; fi
done

/opt/idea/bin/idea.sh dump-shared-index project \
    --project-dir=${PROJECT_DIR} \
    --project-id=${PROJECT_ID} \
    --commit-id=${COMMIT_ID} \
    --tmp=${SHARED_INDEX_BASE}/temp \
    --output=${SHARED_INDEX_BASE}/output

for file in $(ls "/opt/scripts/after_execution/"| sort -r); do
  echo "Executing file $file"
  bash "$file" || break  # execute successfully or break
  # Or more explicitly: if this execution fails, then stop the `for`:
  # if ! bash "$f"; then break; fi
done

# Zip files and send to Shared-index server
if [ ! -z "$INDEXES_CDN_URL" ]; then

    # Zip files. Prepare for sending
    echo "Zipping output"
    cd ${SHARED_INDEX_BASE}/output && zip -r /opt/zipped_index.zip ./* && cd -

    echo "Sending output to Server"
    curl -X POST "${INDEXES_CDN_URL}/manage/upload?commitId=${COMMIT_ID}&projectId=${PROJECT_ID}" \
       -H "accept: */*" \
       -H "Content-Type: multipart/form-data" \
       -F "file=@/opt/zipped_index.zip"

    echo "Index successfully sended to server ${INDEXES_CDN_URL}"
    echo "Removing zipped_index.zip"
    rm /opt/zipped_index.zip
    rm /${SHARED_INDEX_BASE}/output/*
fi
