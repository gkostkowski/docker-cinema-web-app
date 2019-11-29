# Project docker-team11
# db service
## building
```
docker-compose build db
```

## running

```
docker-compose up -d db
```
After starting container, configure it. Keep in mind that db service need 
about 30 seconds to start, you can check it using ```docker-compose logs db```.

## configuring
You must change neo4j DBMS password as neo4j policy requires this.
```

./set_dbms_passwd.sh NEW_NEO4J_PASSWD
```
You should additionally run script *import_db.sh*
to import database dump (already placed inside container).

```
./import_db.sh NEW_NEO4J_PASSWD
```
# web application service
## building
```
docker-compose build webapp
```
## running
```
docker-compose up -d webapp
```

