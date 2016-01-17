# Add cron job to backup mongodb

First, spin up `mongodb` with valid `AWS_ACCESS_KEY`, `AWS_SECRET_KEY`, `S3_REGION`, `S3_BUCKET` in `codesubmit/shellscripts/docker/mongodb/mongodb_up.sh`

Second, run command `crontab -e` and add following line

```
0 0 * * * docker exec mongodb sh -c "/mongodb-s3-backup.sh >> /backup/backup.log"
```
