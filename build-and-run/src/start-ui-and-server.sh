#!/bin/bash
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


# Start Tomcat in background
/home/diqube/diqube-server-exec/tomcat/bin/catalina.sh start

# Start diqube server in foreground
java -server -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC -Xmx10G -Ddiqube.properties=/home/diqube/diqube-server-work/conf/server.properties -jar /home/diqube/diqube-server-exec/diqube-server.jar org.diqube.server.Server

