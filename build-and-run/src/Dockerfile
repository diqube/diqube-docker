#
# diqube: Distributed Query Base, Docker images
#
# Copyright (C) 2015 Bastian Gloeckle
#
# This file is part of diqube Docker images.
#
# diqube Docker images is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

FROM ubuntu:wily
MAINTAINER Bastian Gloeckle <bastian@diqube.org>

USER root
RUN apt-get update && apt-get -y install openjdk-8-jdk maven build-essential git gnupg wget ca-certificates-java && update-ca-certificates -f

RUN adduser diqube --disabled-password --disabled-login

# Create necessary folders
RUN mkdir /home/diqube/.m2 && \
	mkdir /home/diqube/diqube-server-exec && \
	mkdir /home/diqube/diqube-server-exec/tomcat && \
	mkdir /home/diqube/diqube-server-work && \
	mkdir /home/diqube/diqube-server-work/conf && \
	mkdir /home/diqube/diqube-server-work/data && \
	mkdir /home/diqube/thrift

COPY settings.xml /home/diqube/.m2/
COPY server.properties /home/diqube/diqube-server-work/conf/
COPY ticket.pem /home/diqube/diqube-server-work/conf/
COPY start-ui-and-server.sh /home/diqube/diqube-server-exec/

RUN chown -R diqube:diqube /home/diqube

USER diqube

WORKDIR /home/diqube
# GPG keys for Apache Tomcat and Apache Thrift.
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
	05AB33110949707C93A279E3D3EFE6B686867BA6 \
	07E48665A34DCAFAE522E5E6266191C37C037D42 \
	47309207D818FFD8DCD3F83F1931D684307A10A5 \
	541FBE7D8F78B25E055DDEE13C370389288584E7 \
	61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
	79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
	9BA44C2621385CB966EBA586F72C284D731FABEE \
	A27677289986DB50844682F8ACB77FC2E86E29AC \
	A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
	DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
	F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
	F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23 \
	5E43CAB9AEC77EAF \
	B31B213D208F5064 \
	D51878299A7B2398 \
	66E75196C9BBCAFB \
	4294934D218B3A5B \
	BB06368F66B778F9

# Download, verify and then build Apache Thrift.
WORKDIR /home/diqube/thrift
RUN set -x && \
	wget http://archive.apache.org/dist/thrift/0.9.3/thrift-0.9.3.tar.gz -O thrift.tar.gz && \
	wget http://archive.apache.org/dist/thrift/0.9.3/thrift-0.9.3.tar.gz.asc -O thrift.tar.gz.asc && \
	gpg --verify thrift.tar.gz.asc thrift.tar.gz && \
	tar -xf thrift.tar.gz --strip-components=1 && \
	rm thrift.tar.gz*
# Build only the thrift compiler, no "libraries".
RUN ./configure --without-d --without-go --without-haskell --without-ruby --without-php_extension --without-php --without-perl --without-python --without-lua --without-nodejs --without-erlang --without-java --without-csharp --without-c_glib --without-qt4 --without-cpp && \
	make

# Download & extract Apache Tomcat.
WORKDIR /home/diqube/diqube-server-exec/tomcat
RUN set -x \
	&& wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.26/bin/apache-tomcat-8.0.26.tar.gz -O tomcat.tar.gz \
	&& wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.26/bin/apache-tomcat-8.0.26.tar.gz.asc -O tomcat.tar.gz.asc \
	&& gpg --verify tomcat.tar.gz.asc tomcat.tar.gz \
	&& tar -xf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

# Get "master" of diqube and build it.
WORKDIR /home/diqube
RUN git clone https://github.com/diqube/diqube.git
WORKDIR /home/diqube/diqube

# The diqube commit we want to build.
ENV diqube_commit master

RUN set -x && \
	git checkout ${diqube_commit} && \
	mvn clean install -DskipTests && \
	cp /home/diqube/diqube/diqube-server/target/diqube-server-*.jar /home/diqube/diqube-server-exec/diqube-server.jar && \
	cp /home/diqube/diqube/diqube-ui/target/diqube-ui-*.war /home/diqube/diqube-server-exec/diqube-ui.war && \
	cp /home/diqube/diqube/diqube-ui/target/diqube-ui-*.war /home/diqube/diqube-server-exec/tomcat/webapps/diqube-ui.war && \
	cp /home/diqube/diqube/diqube-tool/target/diqube-tool-*.jar /home/diqube/diqube-server-exec/diqube-tool.jar && \
	rm -rf /home/diqube/diqube/*

VOLUME /home/diqube/diqube-server-work
VOLUME /home/diqube/diqube-server-exec

CMD [ "/bin/bash", "/home/diqube/diqube-server-exec/start-ui-and-server.sh" ]
EXPOSE 5101 8080
