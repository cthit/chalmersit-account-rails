#!/bin/bash
# Wait for the database to start up

host="$1"
password="$2"
#shift 2
cmd_bundle="$3"
cmd_rails="$4"

until mysql -h "$host" --user="root" --password="$password" --execute="\q"; do
    >&2 echo "MySQL is unavailable - sleeping"
    sleep 2
done

>&2 echo "MySQL is up - executing order 66"
#exec $cmd_bundle
#exec $cmd_rails
bundle exec rake db:create db:migrate && rails s -p 3000 -b '0.0.0.0'