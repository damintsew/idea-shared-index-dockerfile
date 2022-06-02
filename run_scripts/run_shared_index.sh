
echo "Start"

validateParameters()
{
   echo ""
   echo "Validating provided paramters"
   if [ -z "$COMMIT_ID" ]
   then
      echo "'COMMIT_ID' parameter is empty. Please provide correct 'COMMIT_ID' parameter";
      exit 1
   fi

   if [ -z "$PROJECT_ID" ]
   then
      echo "'PROJECT_ID' parameter is empty. Please provide correct 'PROJECT_ID' parameter";
      exit 1
   fi

   echo "Parameters are valid"
   #todo print values
}

processScriptsInDirectory() {
  DIRECTORY=$1
  for file in $(ls "$DIRECTORY" | sort ); do
    echo "Executing file $file"
    bash "$DIRECTORY/$file" || break  # execute successfully or break
    # Or more explicitly: if this execution fails, then stop the `for`:
    # if ! bash "$f"; then break; fi
  done
}

validateParameters

processScriptsInDirectory "$EXECUTION_SCRIPTS_BEFORE_DIR"

/opt/idea/bin/idea.sh dump-shared-index project \
    --project-dir=${PROJECT_DIR} \
    --project-id=${PROJECT_ID} \
    --commit-id=${COMMIT_ID} \
    --tmp=${SHARED_INDEX_BASE}/temp \
    --output=${SHARED_INDEX_BASE}/output

processScriptsInDirectory "$EXECUTION_SCRIPTS_AFTER_DIR"


