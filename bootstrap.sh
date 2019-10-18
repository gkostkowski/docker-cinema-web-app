#!/bin/bash

# install java
apt update && apt install -y default-jre default-jre-headless

java_installed=$(which java)

if [ -z $java_installed];then
	echo "running alternative ..."
	sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/bin/java
	sudo update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac
fi

# install neo4j DBMS
wget --no-check-certificate -O - https://debian.neo4j.org/neotechnology.gpg.key | apt-key add -
echo 'deb http://debian.neo4j.org/repo stable/' | tee /etc/apt/sources.list.d/neo4j.list

apt update && apt install neo4j
service neo4j status

# install web application
mkdir -p /var/lib/cinema-app
cp cinema-web-app/web-app/ng-boot-project-seed-0.0.1-SNAPSHOT.jar /var/lib/cinema-app/cinema-app.jar

