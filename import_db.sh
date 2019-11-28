#!/bin/bash
if [[ -z "$1" ]];then
	echo "Pass new password for neo4j as an argument."
	exit 1
fi
SERVICE_NAME="db"
echo 'Importing dump ...'
docker-compose exec "$SERVICE_NAME" \
	/home/db/import_db_dump.sh /home/db/cinema.cql neo4j "$1"
