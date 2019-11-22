# Project docker-team11
# db service
## building
```
docker-compose build db
```

Note: Build variable *NEW_NEO4J_PASSWD* is set in docker-compose. It contains
values which will be used as new password for dbms instance during build process.

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


