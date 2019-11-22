FROM ubuntu:16.04

RUN apt-get update && apt-get install -y apt-utils \
  apt-transport-https \
  software-properties-common \
  python-software-properties \
  default-jdk

RUN apt-get install -y git

RUN mkdir -p /var/lib/cinema-app \
	&& mkdir /home/install

WORKDIR /home/install
RUN git clone https://github.com/gkostkowski/cinema-web-app.git \
	&& mv cinema-web-app/web-app/cinema-app-0.0.1.jar \
		/var/lib/cinema-app/cinema-app-0.0.1.jar

# CMD ["java", "-jar", "/var/lib/cinema-app/cinema-app-0.0.1.jar", "--spring.config.location=file:///var/lib/cinema-app/cinema-app.properties"]