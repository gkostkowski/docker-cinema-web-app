#!/bin/bash

TIMEOUT=60
ENDPOINT='http://localhost:7474'
end="$((SECONDS+$TIMEOUT))"

echo "Waiting for Neo4j DBMS on $ENDPOINT ..."
while true; do
    [[ "200" = "$(curl --silent --write-out %{http_code} --output /dev/null $ENDPOINT)" ]] && break
    [[ "${SECONDS}" -ge "${end}" ]] && echo "Error: Neo4j DBMS is not accessible after timeout: $TIMEOUT" && exit 1
    sleep 1
done
echo "Neo4j DBMS is active."
