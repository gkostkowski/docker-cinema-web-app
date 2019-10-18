#!/usr/bin/env bash

# respects exit codes, stops after first error exit code
set -o errexit

apt-get update && apt-get install -y apt-utils \
  apt-transport-https \
  build-essential \
  git \
  python-software-properties \
  software-properties-common

echo "Installing Java..."
apt-get install -y openjdk-8-jre-headless

# install neo4j DBMS
echo "Install neo4j ..."
wget --no-check-certificate -O - https://debian.neo4j.org/neotechnology.gpg.key | apt-key add -
echo 'deb http://debian.neo4j.org/repo stable/' | tee /etc/apt/sources.list.d/neo4j.list
apt-get update && apt-get install -y neo4j

service neo4j stop

# copy db config file
mkdir -p /etc/neo4j
cp /vagrant/neo4j.conf /etc/neo4j/neo4j.conf
chown neo4j:adm /etc/neo4j/neo4j.conf

service neo4j start
service neo4j status

cp /vagrant/wait-for-neo4j.sh ~
~/wait-for-neo4j.sh

echo "Importing db dump ..."
cat /vagrant/cinema.cql | cypher-shell

# simple test
if [[ -z $(echo 'match (n) where id(n) = 5 return n.title;' | cypher-shell) ]];then
	echo "Dump not imported successfully."
	exit 1
else
	echo "Dump imported successfully."
fi
