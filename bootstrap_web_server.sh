#!/bin/bash

# fix for dpkg-preconfigure: https://stackoverflow.com/questions/47408174/vagrant-provision-dpkg-preconfigure-unable-to-re-open-stdin
export DEBIAN_FRONTEND=noninteractive
TOMCAT_USER='tomcat'

set -o errexit

apt-get update && apt-get install -y apt-utils apt-transport-https software-properties-common python-software-properties
apt-get update && apt-get install default-jdk -y
mkdir -p /opt/tomcat
if [[ -z $(getent passwd $TOMCAT_USER) ]] ; then
  echo "$user"
  echo "$(getent passwd $user)"
  echo "Creating group and user 'tomat'"
  # add user and group with same name (flag -U)
  useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
fi


wget http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.47/bin/apache-tomcat-8.5.47.tar.gz -P /tmp
tar xf /tmp/apache-tomcat-8*.tar.gz -C /opt/tomcat


# -L for symbolic link (-f only for regular files)!
if [ ! -L /opt/tomcat/latest ];then
  echo "Create symbolic link: /opt/tomcat/latest"
  ln -s /opt/tomcat/apache-tomcat-8.5.47 /opt/tomcat/latest
fi

chown -RH tomcat: /opt/tomcat/latest
sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'

cp /vagrant/tomcat.service /etc/systemd/system/tomcat.service
systemctl daemon-reload
systemctl start tomcat

cp /vagrant/wait-for-neo4j.sh ~
~/wait-for-neo4j.sh
cp /vagrant/cinema-web-app/web-app/ng-boot-project-seed-0.0.1-SNAPSHOT.war "/opt/tomcat/latest/webapps"
systemctl daemon-reload
systemctl start tomcat
systemctl status tomcat
systemctl enable tomcat
