#!/bin/sh

exec 2>&1

. /home/app/.env.production

printenv | egrep -v 'DATABASE_URL|SECRET_KEY|LDAP_ADMIN' > /tmp/launch-env

bundle exec rake db:migrate
bin/delayed_job start

exec bundle exec puma -w 3 --preload
