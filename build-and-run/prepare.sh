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


if ! [ $# -eq 1 ]; then
	echo Usage: $0 [commit]
	echo
	echo This file prepares a Dockerfile which can be used to create a Docker image that will build diqube from source and execute it. 
	echo You need to provide a valid git commit reference from which to build the image.
	exit 1
fi

script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
commit="$1"

if [ "`curl -o /dev/null -s -w '%{http_code}' https://github.com/diqube/diqube/commit/$commit`" != "200" ]; then
	echo Invalid commit ID: $commit
	exit 2
fi

target_dir="results/$commit"

echo Preparing Dockerfile and environment in ${script_dir}/$target_dir
cd ${script_dir}
mkdir -p "$target_dir"
cp src/* "${target_dir}/"
sed -i "s/ENV diqube_commit.*/ENV diqube_commit $commit/" "${target_dir}/Dockerfile"

echo Environment prepared. Please see the README file on how to progress from here.

cd - > /dev/null
