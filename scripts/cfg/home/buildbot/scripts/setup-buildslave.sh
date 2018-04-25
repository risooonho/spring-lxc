#!/bin/bash

set -e
source $(dirname $0)/make_static_libs_common.sh

apt update
apt -y install g++ make cmake p7zip-full ninja-build \
	libxmu-dev libxi-dev default-jre default-jdk \
	libcurl4-openssl-dev libssl-dev libopenal-dev libvorbis-dev \
	libogg-dev libsdl2-dev libfreetype6-dev libfontconfig1-dev \
	freeglut3-dev libgif-dev \
	buildbot-slave \
	pwgen \
	autossh \
	libboost-test-dev libboost-chrono-dev libboost-thread-dev libboost-system-dev \
	chrpath

