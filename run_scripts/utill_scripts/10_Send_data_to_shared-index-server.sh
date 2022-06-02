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
