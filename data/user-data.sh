#!/bin/bash
set -x

sed -i "s/#\$nrconf{restart} = 'i'/\$nrconf{restart} = 'a'/" /etc/needrestart/needrestart.conf

apt-get update -q -y
apt-get upgrade -q -y

apt-get install -q -y openjdk-17-jre-headless vim

iptables -I INPUT 6 -m state --state NEW -p tcp --dport 25565 -j ACCEPT

mkdir -p /temp && cd /temp
curl https://objectstorage.${region}.oraclecloud.com${setup_request}user-script.sh -o user-script.sh
chmod +x ./user-script.sh
su -c "./user-script.sh" ubuntu >> server.log 2>&1