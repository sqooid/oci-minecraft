#!/bin/bash
set -x

apt-get update -q -y
apt-get upgrade -q -y

apt-get install -q -y openjdk-17-jre-headless

mkdir -p /minecraft && cd /minecraft
chown ubuntu:ubuntu /minecraft

USER_SCRIPT=$(cat <<END
${user_script}
END
)

su -c "$USER_SCRIPT" ubuntu >> server.log