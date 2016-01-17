#!/bin/bash

echo "hello"

set -e

export PATH="$PATH:/usr/local/bin"

# Get the directory the script is being run from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR
# Store the current date in YYYY-mm-DD-HHMMSS
DATE=$(date -u "+%F-%H%M%S")
FILE_NAME="backup-$DATE"
ARCHIVE_NAME="$FILE_NAME.tar.gz"

# Lock the database
# Note there is a bug in mongo 2.2.0 where you must touch all the databases before you run mongodump
mongo admin --eval "var databaseNames = db.getMongo().getDBNames(); for (var i in databaseNames) { printjson(db.getSiblingDB(databaseNames[i]).getCollectionNames()) }; printjson(db.fsyncLock());"

# Dump the database
mongodump --out $DIR/backup/$FILE_NAME

# Unlock the database
mongo admin --eval "printjson(db.fsyncUnlock());"

# Tar Gzip the file
tar -C $DIR/backup/ -zcvf $DIR/backup/$ARCHIVE_NAME $FILE_NAME/

# Remove the backup directory
rm -r $DIR/backup/$FILE_NAME

# Send the file to the backup drive or S3
echo $AWS_ACCESS_KEY
echo $AWS_SECRET_KEY
echo $S3_REGION
echo $S3_BUCKET

if [[ -z $AWS_ACCESS_KEY ]] || [[ -z $AWS_SECRET_KEY ]] || [[ -z $S3_REGION ]] || [[ -z $S3_BUCKET ]]
then
  echo "No s3 credentials, skip sending to s3."
else
  HEADER_DATE=$(date -u "+%a, %d %b %Y %T %z")
  CONTENT_MD5=$(openssl dgst -md5 -binary $DIR/backup/$ARCHIVE_NAME | openssl enc -base64)
  CONTENT_TYPE="application/x-download"
  STRING_TO_SIGN="PUT\n$CONTENT_MD5\n$CONTENT_TYPE\n$HEADER_DATE\n/$S3_BUCKET/$ARCHIVE_NAME"
  SIGNATURE=$(echo -e -n $STRING_TO_SIGN | openssl dgst -sha1 -binary -hmac $AWS_SECRET_KEY | openssl enc -base64)

  echo "curl -X PUT \
  --header \"Host: $S3_BUCKET.s3-$S3_REGION.amazonaws.com\" \
  --header \"Date: $HEADER_DATE\" \
  --header \"content-type: $CONTENT_TYPE\" \
  --header \"Content-MD5: $CONTENT_MD5\" \
  --header \"Authorization: AWS $AWS_ACCESS_KEY:$SIGNATURE\" \
  --upload-file $DIR/backup/$ARCHIVE_NAME \
  https://$S3_BUCKET.s3-$S3_REGION.amazonaws.com/$ARCHIVE_NAME
  "

  error_msg="$(curl -X PUT \
  --header "Host: $S3_BUCKET.s3-$S3_REGION.amazonaws.com" \
  --header "Date: $HEADER_DATE" \
  --header "content-type: $CONTENT_TYPE" \
  --header "Content-MD5: $CONTENT_MD5" \
  --header "Authorization: AWS $AWS_ACCESS_KEY:$SIGNATURE" \
  --upload-file $DIR/backup/$ARCHIVE_NAME \
  https://$S3_BUCKET.s3-$S3_REGION.amazonaws.com/$ARCHIVE_NAME)"

  echo $error_msg

  if [[ -z $error_msg ]]; then
    mkdir -p $DIR/backup/uploaded
    mv $DIR/backup/$ARCHIVE_NAME $DIR/backup/uploaded/$ARCHIVE_NAME
  fi
fi
