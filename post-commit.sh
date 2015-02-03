#!/bin/bash
# Run a push to AWS S3 after a local git commit

timestamp() {
  date +"%Y%m%d-%H%M%S"
}

LOG_MESSAGE="$(timestamp) - $(git log -1 HEAD --pretty=format:%h:%s)"
LOG_FILE=push.log

echo -e "\nRunning post-commit hook...\n"
echo $LOG_MESSAGE >> $LOG_FILE

echo "jekyll build:"
jekyll build | tee -a $LOG_FILE

echo "s3_website push:"
s3_website push | tee -a $LOG_FILE