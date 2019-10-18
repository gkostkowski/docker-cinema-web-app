#!/bin/bash

#exit after first error
set -o errexit

apt-get update && apt-get install -y apt-utils \
  apt-transport-https \
  software-properties-common \
  python-software-properties \
  default-jdk

# install web application
mkdir -p /var/lib/cinema-app
cp /vagrant/cinema-web-app/web-app/ng-boot-project-seed-0.0.1-SNAPSHOT.jar /var/lib/cinema-app/cinema-app.jar
cp /vagrant/cinema-app.properties /var/lib/cinema-app/cinema-app.properties

nohup java -jar /var/lib/cinema-app/cinema-app.jar \
--spring.config.location=file:///var/lib/cinema-app/cinema-app.properties &> /var/log/cinema-app.log &
