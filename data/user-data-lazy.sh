#!/bin/bash
set -x

BUCKET="https://objectstorage.${region}.oraclecloud.com${setup_request}"

sed -i "s/#\$nrconf{restart} = 'i'/\$nrconf{restart} = 'a'/" /etc/needrestart/needrestart.conf

apt-get update -q -y
apt-get upgrade -q -y

apt-get install -q -y openjdk-17-jre-headless vim

iptables -I INPUT 6 -m state --state NEW -p tcp --dport 25565 -j ACCEPT

timedatectl set-timezone ${timezone}

# Connecting to volume
VOLUME_IQN="${volume_iqn}"
VOLUME_ADDRESS="${volume_ip}:${volume_port}"

iscsiadm -m node -o new -T VOLUME_IQN -p VOLUME_ADDRESS
iscsiadm -m node -T VOLUME_IQN -o update -n node.startup -v automatic
iscsiadm -m node -T VOLUME_IQN -p VOLUME_ADDRESS -l

# Formatting if not formatted yet
if [ -z "$(lsblk /dev/sdb -no fstype | xargs)" ]; then
	mkfs -t ext4 /dev/sdb
else
	echo "Already formatted"
fi

# Mounting
mkdir /minecraft
chown ubuntu:ubuntu /minecraft
UUID="$(blkid | grep /dev/sdb | gawk 'match($0, /UUID="([a-z0-9\-]+)"/, a) {print a[1]}')"
bash -c "echo 'UUID=\"$UUID\" /minecraft ext4 defaults,noatime,_netdev 0 2' >> /etc/fstab"
mount /dev/sdb /minecraft

# Download and set up base server files
cd /minecraft
curl "$${BUCKET}server-setup-base.sh" -o server-setup-base.sh

chmod +x ./server-setup-base.sh
su -c "./server-setup-base.sh" ubuntu >> server-setup.log 2>&1