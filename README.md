# Project docker-team11
# db service
## building
```
docker-compose build db
```

where *NEW_NEO4J_PASSWD* is set by you environment variable containing new
password for neo4j dbms instance.

## running
```
docker-compose up -d db
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


