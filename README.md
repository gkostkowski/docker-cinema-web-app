# Project docker-team11
# db image
## building
```
docker build . -t "cinema-db" -f db.Dockerfile --build-arg passwd=${NEW_NEO4J_PASSWD}
```
where *NEW_NEO4J_PASSWD* is set by you environment variable containing new
password for neo4j dbms instance.
## running
```
./run_db.sh
```

# web application
## building
```
docker build . -t "cinema-app" -f webapp.Dockerfile
```
## running
```
./run_webapp.sh
```
