#echo `git status`

#todo add parameters validation

/opt/idea/bin/idea.sh dump-shared-index project \
    --project-dir=${IDEA_PROJECT_DIR} \
    --project-id=${PROJECT_ID} \
    --commit-id=${COMMIT_ID} \
    --tmp=${SHARED_INDEX_BASE}/temp \
    --output=${SHARED_INDEX_BASE}/output

# Format for CDN (cdn-layout-tool)
if [ ! -z "$INDEXES_CDN_URL" ]; then
#    echo "Formatting indexes"
#    /opt/cdn-layout-tool/bin/cdn-layout-tool \
#        --indexes-dir=${SHARED_INDEX_BASE} \
#        --url=${INDEXES_CDN_URL} && \
#        mv ${SHARED_INDEX_BASE}/output ${SHARED_INDEX_BASE}/project/output

    # Zip files. Prepare for sending
    echo "Zipping output"
    cd ${SHARED_INDEX_BASE}/output && zip -r /opt/zipped_index.zip ./* && cd -

    echo "Sending output to Server"
    curl -X POST "${INDEXES_CDN_URL}/manage/upload?commitId=${COMMIT_ID}&projectId=${PROJECT_ID}" \
       -H "accept: */*" \
       -H "Content-Type: multipart/form-data" \
       -F "file=@/opt/zipped_index.zip"
fi
