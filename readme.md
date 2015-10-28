# codeSubmit
> write __Code__ then __Submit__

*codeSubmit* is a web base code judge system

## Development
To spin up database, run `shellscripts/docker/mongodb/mongodb_up.sh`, `shellscripts/docker/redis/redis_up.sh` and `shellscripts/docker/rabbitmq/rabbitmq.sh`

To watch changes and livereload for admin, run `grunt` and visit `http://localhost:8000`
To watch changes and livereload for student, run `grunt student` and visit `http://localhost:8001`
To watch changes and livereload for worker, run `grunt worker`

To spin up dockers for each of above three, run `shellscripts/docker/codesubmit/admin_up.sh`, `shellscripts/docker/codesubmit/student_up.sh` and `shellscripts/docker/codesubmit/worker_up.sh`
