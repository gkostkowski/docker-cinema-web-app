#!/bin/bash
if [[ -z "$1" ]];then
	echo "Pass new password for neo4j as an argument."
	exit 1
fi
NEO4J_PASSWD="$1"
SERVICE_NAME="db"
WEBAPP_CONFIG='webapp/cinema-app.properties'
echo 'Changing password...'
docker-compose exec "$SERVICE_NAME" \
	cypher-shell -u neo4j -p neo4j "CALL dbms.changePassword('""$NEO4J_PASSWD""');"

echo "Update webapp config ..."
sed -i '/spring.data.neo4j.password/s/=.*$/='$NEO4J_PASSWD'/' "$WEBAPP_CONFIG"
